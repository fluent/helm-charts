# fluentd

![Version: 0.5.3](https://img.shields.io/badge/Version-0.5.3-informational?style=flat-square) ![AppVersion: 1.19.2](https://img.shields.io/badge/AppVersion-1.19.2-informational?style=flat-square)

Helm chart for deploying Fluentd on Kubernetes. [Fluentd](https://www.fluentd.org/) is an open source data collector for unified logging layer. Fluentd allows you to unify data collection and consumption for a better use and understanding of data.

**Homepage:** <https://www.fluentd.org/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| edsiper | <eduardo@treasure-data.com> |  |
| dioguerra | <diogo.filipe.tomas.guerra@cern.ch> |  |

## Source Code

* <https://github.com/fluent/fluentd/>
* <https://github.com/fluent/fluentd-kubernetes-daemonset>

## Installing the Chart

### OCI Repository

To install the chart using the recommended OCI method you can use the following command.

```shell
helm upgrade --install fluentd oci://ghcr.io/fluent/helm-charts/fluentd --version 0.5.3
```

#### Verification

As the OCI chart release is signed by [Cosign](https://github.com/sigstore/cosign) you can verify the chart before installing it by running the following command.

```shell
cosign verify --certificate-oidc-issuer https://token.actions.githubusercontent.com --certificate-identity-regexp 'https://github\.com/action-stars/helm-workflows/\.github/workflows/release\.yaml@.+' --certificate-github-workflow-repository fluent/helm-charts --certificate-github-workflow-name Release ghcr.io/fluent/helm-charts/fluentd:0.5.3
```

### Non-OCI Repository

Alternatively you can use the legacy non-OCI method via the following commands.

```shell
helm repo add fluent https://fluent.github.io/helm-charts/
helm upgrade --install fluentd fluent/fluentd --version 0.5.3
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| annotations | object | `{}` |  |
| autoscaling.customRules | list | `[]` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| configMapConfigs | list | `[]` |  |
| dashboards.enabled | string | `"true"` |  |
| dashboards.labels.grafana_dashboard | string | `"\"1\""` |  |
| dashboards.namespace | string | `""` |  |
| env | list | `[]` |  |
| envFrom | list | `[]` |  |
| fileConfigs."01_sources.conf" | string | `"## logs from podman\n<source>\n  @type tail\n  @id in_tail_container_logs\n  @label @KUBERNETES\n  path /var/log/containers/*.log\n  pos_file /var/log/fluentd-containers.log.pos\n  tag kubernetes.*\n  read_from_head true\n  <parse>\n    @type multi_format\n    <pattern>\n      format json\n      time_key time\n      time_type string\n      time_format \"%Y-%m-%dT%H:%M:%S.%NZ\"\n      keep_time_key false\n    </pattern>\n    <pattern>\n      format regexp\n      expression /^(?<time>.+) (?<stream>stdout|stderr)( (.))? (?<log>.*)$/\n      time_format '%Y-%m-%dT%H:%M:%S.%NZ'\n      keep_time_key false\n    </pattern>\n  </parse>\n  emit_unmatched_lines true\n</source>\n\n# expose metrics in prometheus format\n<source>\n  @type prometheus\n  bind 0.0.0.0\n  port 24231\n  metrics_path /metrics\n</source>"` |  |
| fileConfigs."02_filters.conf" | string | `"<label @KUBERNETES>\n  <match kubernetes.var.log.containers.fluentd**>\n    @type relabel\n    @label @FLUENT_LOG\n  </match>\n\n  # <match kubernetes.var.log.containers.**_kube-system_**>\n  #   @type null\n  #   @id ignore_kube_system_logs\n  # </match>\n\n  <filter kubernetes.**>\n    @type kubernetes_metadata\n    @id filter_kube_metadata\n    skip_labels false\n    skip_container_metadata false\n    skip_namespace_metadata true\n    skip_master_url true\n  </filter>\n\n  <match **>\n    @type relabel\n    @label @DISPATCH\n  </match>\n</label>"` |  |
| fileConfigs."03_dispatch.conf" | string | `"<label @DISPATCH>\n  <filter **>\n    @type prometheus\n    <metric>\n      name fluentd_input_status_num_records_total\n      type counter\n      desc The total number of incoming records\n      <labels>\n        tag ${tag}\n        hostname ${hostname}\n      </labels>\n    </metric>\n  </filter>\n\n  <match **>\n    @type relabel\n    @label @OUTPUT\n  </match>\n</label>"` |  |
| fileConfigs."04_outputs.conf" | string | `"<label @OUTPUT>\n  <match **>\n    @type elasticsearch\n    host \"elasticsearch-master\"\n    port 9200\n    path \"\"\n    user elastic\n    password changeme\n    # Don't wait for elastic to start up.\n    verify_es_version_at_startup false\n  </match>\n</label>"` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"fluent/fluentd-kubernetes-daemonset"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].port | int | `9880` |  |
| ingress.tls | list | `[]` |  |
| initContainers | list | `[]` |  |
| kind | string | `"DaemonSet"` |  |
| labels | object | `{}` |  |
| lifecycle | object | `{}` |  |
| livenessProbe.httpGet.path | string | `"/metrics"` |  |
| livenessProbe.httpGet.port | string | `"metrics"` |  |
| metrics.prometheusRule.additionalLabels | object | `{}` |  |
| metrics.prometheusRule.enabled | bool | `false` |  |
| metrics.prometheusRule.namespace | string | `""` |  |
| metrics.prometheusRule.rules | list | `[]` |  |
| metrics.serviceMonitor.additionalLabels.release | string | `"prometheus-operator"` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
| metrics.serviceMonitor.metricRelabelings | list | `[]` |  |
| metrics.serviceMonitor.namespace | string | `""` |  |
| metrics.serviceMonitor.namespaceSelector | object | `{}` |  |
| metrics.serviceMonitor.relabelings | list | `[]` |  |
| minReadySeconds | string | `nil` |  |
| mountDockerContainersDirectory | bool | `true` |  |
| mountVarLogDirectory | bool | `true` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.enabled | bool | `false` |  |
| persistence.size | string | `"10Gi"` |  |
| persistence.storageClass | string | `""` |  |
| plugins | list | `[]` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| podSecurityPolicy.annotations | object | `{}` |  |
| podSecurityPolicy.enabled | bool | `true` |  |
| rbac.create | bool | `true` |  |
| readinessProbe.httpGet.path | string | `"/metrics"` |  |
| readinessProbe.httpGet.port | string | `"metrics"` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.annotations | object | `{}` |  |
| service.enabled | bool | `true` |  |
| service.ports | list | `[]` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `nil` |  |
| terminationGracePeriodSeconds | string | `nil` |  |
| tolerations | list | `[]` |  |
| updateStrategy | object | `{}` |  |
| variant | string | `"elasticsearch7"` |  |
| variantVersion | string | `"1.6"` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

## Upgrading

### To 0.4.0

Although the services will deploy and generally work, version 0.4.0 introduces some changes that are considered _breaking changes_. To upgrade, you should do the following to avoid any potential conflicts or problems:

- Add the `mountVarLogDirectory` and `mountDockerContainersDirectory` values and set them to the values you need; to follow the previous setup where these were mounted by default, set the values to `true`, e.g. `mountVarLogDirectory: true`
- If you have the `varlog` mount point defined and enabled under both `volumes` and `volumeMounts`, set `mountVarLogDirectory` to true
- If you have the `varlibdockercontainers` mount point defined and enabled under both `volumes` and `volumeMounts`, set `mountDockerContainersDirectory` to true
- Remove the previous default volume and volume mount definitions - `etcfluentd-main`, `etcfluentd-config`, `varlog`, and `varlibdockercontainers`
- Remove the `FLUENTD_CONF` entry from the `env:` list

## Chart Values

```sh
helm show values fluent/fluentd
```

## Value Details

### default-volumes

The default configurations bellow are required for the fluentd pod to be able to read the hosts container logs. The second section is responsible for allowing the user to load the "extra" configMaps either defined by the `fileConfigs` contained objects or, in addition, loaded externally and indicated by `configMapConfigs`.

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

The section bellow is responsible for allowing the user to load the "extra" configMaps either defined by the `fileConfigs` contained objects or otherwise load externally and indicated by `configMapConfigs`.

```yaml
- name: etcfluentd-main
  mountPath: /etc/fluent
- name: etcfluentd-config
  mountPath: /etc/fluent/config.d/
  ```

### default-fluentdConfig

The `fileConfigs` section is organized by sources -> filters -> destinations. Flow control must be configured using fluentd routing with tags or labels to guarantee that the configurations are executed as intended. Alternatively you can use numeration on your files to control the configurations loading order.

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

## Headless Service

The chart supports deploying a headless service, which is useful for StatefulSet deployments where you need direct pod DNS resolution (e.g., `pod-0.fluentd-headless.namespace.svc.cluster.local`).

To enable the headless service, configure the following values:

```yaml
headlessService:
  enabled: true
  annotations: {}
  ports:
    - name: "forwarder"
      protocol: TCP
      containerPort: 24224
```

The headless service will be created with the name `<release-name>-fluentd-headless` and will expose the metrics port (24231) by default, plus any additional ports specified in `headlessService.ports`.

## Backwards Compatibility - v0.1.x

The old fluentd chart used the ENV variables and the default fluentd container definitions to set-up automatically many aspects of fluentd. It is still possible to trigger this behaviour by removing this charts current `.Values.env` configuration and replace by:

```yaml
env:
- name: FLUENT_ELASTICSEARCH_HOST
  value: "elasticsearch-master"
- name: FLUENT_ELASTICSEARCH_PORT
  value: "9200"
```

----------------------------------------------

Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs/).
