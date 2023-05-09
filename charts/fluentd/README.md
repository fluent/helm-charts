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

## Backwards Compatibility - v0.1.x

The old fluentd chart used the ENV variables and the default fluentd container definitions to set-up automatically many aspects of fluentd. It is still possible to trigger this behaviour by removing this charts current `.Values.env` configuration and replace by:

```yaml
env:
- name: FLUENT_ELASTICSEARCH_HOST
  value: "elasticsearch-master"
- name: FLUENT_ELASTICSEARCH_PORT
  value: "9200"
```
