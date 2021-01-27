# Fluentd Helm Chart

[Fluentd](https://www.fluentd.org/) is an open source data collector for unified logging layer. Fluentd allows you to unify data collection and consumption for a better use and understanding of data.

## Installation

To add the `fluent` helm repo, run:

```sh
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update
```

To install a release named `fluentd`, run:

```sh
helm install fluentd fluent/fluentd
```

## Chart Values

```sh
helm show values fluent/fluentd
```

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| kind | string | `"DaemonSet"` | The kind of kubernetes controller to use "DaemonSet" or "Deployement" |
| replicaCount | int | `1` | Only for kind: Deployment |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"fluent/fluentd-kubernetes-daemonset"` |  |
| image.tag | string | `"v1.11.5-debian-elasticsearch7-1.0"` |  |
| imagePullSecrets | list | `[]` | Optional array of imagePullSecrets containing private registry credentials |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.name | string | `null` |  |
| rbac.create | bool | `true` |  |
| podSecurityPolicy.enabled | bool | `true` |  |
| podSecurityPolicy.annotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| securityContext | object | `{}` |  |
| resources | object | `{}` |  |
| priorityClassName | string | `""` |  |
| nodeSelector | object | `{}` |  |
| tolerations | list | `[]` |  |
| affinity | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| env[0].name | string | `"FLUENTD_CONF"` |  |
| env[0].value | string | `"/etc/fluent/fluent.conf"` |  |
| envFrom | list | `[]` |  |
| volumes | list | [default-volumes](#default-volumes) | The external volumes to use |
| volumeMounts | list | [default-volumeMounts](#default-volumeMounts) | The volume to mount with the pods |
| service.type | string | `"ClusterIP"` |  |
| service.annotations | object | `{}` |  |
| service.ports | list | `[]` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
| metrics.serviceMonitor.additionalLabels | object | `{release: prometheus-operator}` |  |
| metrics.serviceMonitor.namespace | string | `""` |  |
| metrics.serviceMonitor.namespaceSelector | object | `{}` |  |
| metrics.serviceMonitor.scrapeInterval | string | `null` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `null` |  |
| metrics.serviceMonitor.honorLabels | bool | `true` |  |
| metrics.prometheusRule.enabled | bool | `false` |  |
| metrics.prometheusRule.additionalLabels | object | `{}` |  |
| metrics.prometheusRule.namespace | string | `""` |  |
| metrics.prometheusRule.rules | list | `[]` |  |
| dashboards.enabled | bool | `true` |  |
| dashboards.additionalLabels | object | `{grafana_dashboard: "1"}` |  |
| dashboards.namespace | string | `""` |  |
| plugins | list | `[]` | Fluentd list of plugins to install |
| configMapConfigs | list | `["fluentd-prometheus-conf"]` | List of fluentd.conf type configMaps to mount |
| fileConfigs | object | [default-volumes](#default-fluentdConfig) | Configuration files to be read by the fluentd engine |

## Value Details

### default-volumes

The default configurations bellow are required for the fluentd pod to be able to read the hosts container logs. The second section is responsible for  allowing the user to load the "extra" configMaps either defined by the `fileConfigs` contained objects or, in addition, loaded externally and indicated by `configMapConfigs`.

```yaml
- name: varlog
  hostPath:
    path: /var/log
- name: varlibdockercontainers
  hostPath:
    path: /var/lib/docker/containers
---
- name: etcfluentd-main
  configMap:
    name: fluentd-main
    defaultMode: 0777
- name: etcfluentd-config
  configMap:
    name: fluentd-config
    defaultMode: 0777
```


### default-volumeMounts

The default configurations bellow are required for the fluentd pod to be able to read the hosts container logs. They should not be removed unless for some reason your container logs are accessible through a different path

```yaml
- name: varlog
  mountPath: /var/log
- name: varlibdockercontainers
  mountPath: /var/lib/docker/containers
  readOnly: true
```

The section bellow is responsible for  allowing the user to load the "extra" configMaps either defined by the `configMapConfigs` contained objects or otherwise load externally and indicated by `configMapConfigs`.

```yaml
- name: etcfluentd-main
  mountPath: /etc/fluent
- name: etcfluentd-config
  mountPath: /etc/fluent/config.d/
  ```

### default-fluentdConfig

The `fileConfigs` section is organized by sources -> filters -> destinations. Flow control must be controlled using fluentd routing with tags or labels to guarantee that the configurations are executed as intended. Alternatively you can use numeration on your files to control the configurations loading order.

```yaml
01_sources.conf: |-
  <source>
    @type tail
    @id in_tail_container_logs
    @label @KUBERNETES
    path /var/log/containers/*.log
    pos_file /var/log/fluentd-containers.log.pos
    tag kubernetes.*
    read_from_head true
    <parse>
      @type multi_format
      <pattern>
        format json
        time_key time
        time_type string
        time_format "%Y-%m-%dT%H:%M:%S.%NZ"
        keep_time_key false
      </pattern>
      <pattern>
        format regexp
        expression /^(?<time>.+) (?<stream>stdout|stderr)( (.))? (?<log>.*)$/
        time_format '%Y-%m-%dT%H:%M:%S.%NZ'
        keep_time_key false
      </pattern>
    </parse>
    emit_unmatched_lines true
  </source>

02_filters.conf: |-
  <label @KUBERNETES>
    <match kubernetes.var.log.containers.fluentd**>
      @type relabel
      @label @FLUENT_LOG
    </match>

    # <match kubernetes.var.log.containers.**_kube-system_**>
    #   @type null
    #   @id ignore_kube_system_logs
    # </match>

    <filter kubernetes.**>
      @type record_transformer
      enable_ruby
      <record>
        hostname ${record["kubernetes"]["host"]}
        raw ${record["log"]}
      </record>
      remove_keys $.kubernetes.host,log
    </filter>

    <match **>
      @type relabel
      @label @DISPATCH
    </match>
  </label>

03_dispatch.conf: |-
  <label @DISPATCH>
    <filter **>
      @type prometheus
      <metric>
        name fluentd_input_status_num_records_total
        type counter
        desc The total number of incoming records
        <labels>
          tag ${tag}
          hostname ${hostname}
        </labels>
      </metric>
    </filter>

    <match **>
      @type relabel
      @label @OUTPUT
    </match>
  </label>

04_outputs.conf: |-
  <label @OUTPUT>
    <match **>
      @type elasticsearch
      host "elasticsearch-master"
      port 9200
      path ""
      user elastic
      password changeme
    </match>
  </label>
```

## Backwards Compatibility - v0.1.x

The old fluentd chart used the ENV variables and the default fluentd container definitions to set-up automatically many aspects of fluentd. It is still possible to trigger this behaviour by removing this charts current `.Values.env` configuration and replace by:

```yaml
env:
- name: FLUENT_ELASTICSEARCH_HOST
  value: "elasticsearch-master"
- name: FLUENT_ELASTICSEARCH_PORT
  value: "9200"
```
