# Fluentd + 10x Helm Chart

[Fluentd](https://www.fluentd.org/) is an open source data collector for unified logging layer. Fluentd allows you to unify data collection and consumption for a better use and understanding of data.

[10x](https://doc.log10x.com/home/) is an observability runtime that executes in edge/cloud environments to optimize and reduce the cost of analyzing and storing log/trace data.

## Overview

This chart is intended to set up a Fluentd daemonset with a 10x [Edge application](https://doc.log10x.com/apps/edge/)

The chart is derived from the base [Fluentd chart](https://github.com/fluent/helm-charts/tree/main/charts/fluentd), with some key differences which enable Fluentd to work with 10x:

1. Container image is derived from [Fluentd k8s daemonset](https://github.com/fluent/fluentd-kubernetes-daemonset), with the 10x engine on it. For more details, see [Dockerfile](https://github.com/log-10x/docker-images/blob/main/fwd/fluentd/daemonset/Dockerfile)
2. Fluentd configuration is adapted to include emitting/receiving events to/from 10x. For more details on how Fluentd communicates with 10x, see [here](https://doc.log10x.com/run/input/forwarder/fluentd/)
3. Added easy fetching of 10x application configuration and [symbols](https://doc.log10x.com/run/symbol/) from any Git provider using an init container which pulls and mounts the needed files onto the main pod. For more details, see [git-config-fetcher](https://github.com/log-10x/docker-images/tree/main/ext/git-config-fetcher)

## Installation

### OCI Repository (Recommended)

Install directly from the OCI registry:

```sh
helm install fluentd oci://ghcr.io/log-10x/fluent-helm-charts/fluentd
```

### Helm Repository (Alternative)

```sh
helm repo add log10x-fluent https://log-10x.github.io/fluent-helm-charts
helm repo update
helm install fluentd log10x-fluent/fluentd
```

## Examples

Sample values.yaml which sets up Fluentd with a 10x [Edge application](https://doc.log10x.com/apps/edge/) can be found [here](https://github.com/log-10x/fluent-helm-charts/tree/main/samples), for a 10x [Reporter](https://github.com/log-10x/fluent-helm-charts/blob/main/samples/fluentd-report.yaml), [Regulator](https://github.com/log-10x/fluent-helm-charts/blob/main/samples/fluentd-regulate.yaml) and [Optimizer](https://github.com/log-10x/fluent-helm-charts/blob/main/samples/fluentd-optimize.yaml)

Full details on the base Fluentd chart can be found at the [original repo](https://github.com/fluent/helm-charts/tree/main/charts/fluentd)

## Chart Values

```sh
# OCI
helm show values oci://ghcr.io/log-10x/fluent-helm-charts/fluentd

# Or via Helm repo
helm show values log10x-fluent/fluentd
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
