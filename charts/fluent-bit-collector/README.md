# fluent-bit-collector

![Version: 1.0.0-beta.2](https://img.shields.io/badge/Version-1.0.0--beta.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 4.2.2](https://img.shields.io/badge/AppVersion-4.2.2-informational?style=flat-square)

Helm chart for Fluent Bit running as a collector DaemonSet.

**Homepage:** <https://fluentbit.io/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| stevehipwell | <steve.hipwell@gmail.com> | <https://github.com/stevehipwell> |

## Source Code

* <https://github.com/fluent/fluent-bit/>
* <https://github.com/fluent/helm-charts/>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity settings for pod scheduling. |
| args | list | `[]` | Extra args for the default container; `--workdir`, `--config` & `--enable-hot-reload` are managed by the chart. |
| automountServiceAccountToken | bool | `nil` | If the service account token should be mounted to the pod, this overrides `serviceAccount.automountToken`. |
| command | list | `["/fluent-bit/bin/fluent-bit"]` | Command for the default container |
| commonLabels | object | `{}` | Labels to add to all chart resources. |
| config.env | object | `{}` | The [Env](https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/environment-variables-section) section allows you to define environment variables directly within the configuration file. These variables can then be used to dynamically replace values throughout your configuration using the ${VARIABLE_NAME} syntax. These values support templating. The `STORAGE_PATH`, `STORAGE_TYPE_PREFER_FS`, `ADDITIONAL_PORT_<INDEX>`, `KUBELET_ENDPOINT` & `NOT_KUBELET_ENDPOINT` values are available but can't be set as they are controlled by the chart. |
| config.includes | list | `[]` | The [Includes](https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/includes-section) section allows you to specify additional YAML configuration files to be merged into the current configuration. |
| config.multilineParsers | list | `[]` | The [Multiline Parsers](https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/multiline-parsers-section) section allows you to define custom multiline parsers. |
| config.parsers | list | `[{"format":"regex","name":"kubernetes-tag","regex":"^(?<namespace_name>[^.]+)\\.(?<pod_name>[^.]+)\\.(?<container_name>[^.]+)"}]` | The [Parsers](https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/parsers-section) section allows you to define custom parsers. |
| config.parsersFile | string | `"/fluent-bit/etc/parsers.conf"` | The service `parsers_file`, due to how YAML is processed this key can only be set once. |
| config.pipeline.filters | list | `[]` | The pipeline filters configure the plugins responsible for processing data. |
| config.pipeline.inputs | list | `[{"alias":"k8s-logs","db":"${STORAGE_PATH}/tail.db","multiline.parser":"cri","name":"tail","path":"/var/log/containers/*.log","processors":{"logs":[{"k8s-logging.exclude":true,"k8s-logging.parser":true,"kube_tag_prefix":"kube.","kubelet_host":"${NODE_IP}","kubelet_port":10250,"name":"kubernetes","regex_parser":"kubernetes-tag","use_kubelet":"${KUBELET_ENDPOINT}"}]},"read_from_head":true,"skip_empty_lines":true,"skip_long_lines":true,"storage.type":"${STORAGE_TYPE_PREFER_FS}","tag":"kube.<namespace_name>.<pod_name>.<container_name>","tag_regex":"(?<pod_name>[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*)_(?<namespace_name>[^_]+)_(?<container_name>.+)-"}]` | The pipeline inputs configure the plugins responsible for collecting or receiving data. If storage is not enabled the `db` key will be removed to stop errors. |
| config.pipeline.outputs | list | `[{"alias":"out","match":"*","name":"stdout"}]` | The pipeline outputs configure the plugins responsible for storing or forwarding data. |
| config.plugins | list | `[]` | The [Plugins](https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/plugins-section) section adds support for loading external plugins at runtime. |
| config.service | object | `{"http_listen":"0.0.0.0","log_level":"info"}` | The [Service](https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/service-section) section defines global properties of the service. The `daemon`, `http_server`, `http_port`, `parsers_file` & `storage.path` keys can't be set as they are controlled by the chart. |
| config.upstreamServers | list | `[]` | The [Upstream Servers](https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/upstream-servers-section) section defines a group of endpoints, referred to as nodes, which are used by output plugins to distribute data in a round-robin fashion. |
| dashboards.enabled | bool | `false` | If `true`, install the _Grafana_ dashboards provided by the chart. |
| env | list | `[]` | Environment variables for the default container. |
| extraConfig | object | `{}` | Additional YAML configuration to mount as YAML files to /fluent-bit/etc. |
| extraVolumeMounts | list | `[]` | Extra volume mounts for the default container. |
| extraVolumes | list | `[]` | Extra volumes for the pod. |
| fullnameOverride | string | `nil` | Override the full name of the chart. |
| hostVolumes | list | `[{"hostPath":{"path":"/etc/machine-id","type":"File"},"mountPath":"/etc/machine-id","name":"machine-id"},{"hostPath":{"path":"/var/log","type":"Directory"},"mountPath":"/var/log","name":"logs"}]` | Host volumes to read-only mount to the default container. |
| hotReload.enabled | bool | `false` | If `true`, enable [hot-reload](https://docs.fluentbit.io/manual/administration/hot-reload) via a sidecar container. |
| hotReload.extraWatchVolumes | list | `[]` | Extra volumes for the hot-reload sidecar container to watch. |
| hotReload.image.digest | string | `nil` | Optional image digest for the hot-reload sidecar container. |
| hotReload.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy for the hot-reload sidecar container. |
| hotReload.image.repository | string | `"ghcr.io/jimmidyson/configmap-reload"` | Image repository for the hot-reload sidecar container. |
| hotReload.image.tag | string | `"v0.15.0"` | Image tag for the hot-reload sidecar container. |
| hotReload.resources | object | `{}` | Resources for the hot-reload sidecar container. |
| image.digest | string | `nil` | Optional image digest for the default container. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy for the default container. |
| image.repository | string | `"ghcr.io/fluent/fluent-bit"` | Image repository for the default container. |
| image.tag | string | `nil` | Image tag for the default container, this will default to `.Chart.AppVersion` if not set and will be omitted if set to `-`. |
| imagePullSecrets | list | `[]` | Image pull secrets. |
| kubeletEndpoint.enabled | bool | `false` | If `true`, the _Kubernetes_ filter will use _Kubelet_ as the API endpoint (**EXPERIMENTAL**). |
| livenessProbe | object | See _values.yaml_ | Liveness probe configuration for the default container. |
| luaScripts | object | `{}` | Lua scripts to configure, these will be created at /fluent-bit/scripts and need to be referenced by an absolute path. |
| minReadySeconds | int | `nil` | Min ready seconds for the `DaemonSet`. |
| nameOverride | string | `nil` | Override the name of the chart. |
| nodeSelector | object | `{}` | Node labels to match for pod scheduling. |
| podAnnotations | object | `{}` | Annotations to add to the pod. |
| podLabels | object | `{}` | Labels to add to the pod. |
| podSecurityContext | object | See _values.yaml_ | Security context for the pod. |
| priorityClassName | string | `nil` | Priority class name for the pod. |
| rbac.additionalRules | list | `[]` | Additional rules to add to the `ClusterRole`. |
| rbac.create | bool | `true` | If `true`, create a `ClusterRole` & `ClusterRoleBinding` with access to the Kubernetes API. |
| readinessProbe | object | See _values.yaml_ | Readiness probe configuration for the default container. |
| resources | object | `{}` | Resources for the default container. |
| securityContext | object | See _values.yaml_ | Security context for the default container. |
| service.additionalPorts | string | See _values.yaml_ | Additional ports to expose. |
| service.annotations | object | `{}` | Service annotations. |
| service.enabled | bool | `false` | If `true`, create an internal local traffic service. |
| service.httpPort | int | `2020` | Fluent Bit HTTP port used for status and metrics. |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account. |
| serviceAccount.automountToken | bool | `true` | If `true`, mount the `ServiceAccount` token. |
| serviceAccount.create | bool | `true` | If `true`, create a new `ServiceAccount`. |
| serviceAccount.labels | object | `{}` | Labels to add to the service account. |
| serviceAccount.name | string | `nil` | If this is set and `serviceAccount.create` is `true` this will be used for the created `ServiceAccount` name, if set and `serviceAccount.create` is `false` then this will define an existing `ServiceAccount` to use. |
| serviceMonitor.additionalEndpoints | list | `[]` | Additional `ServiceMonitor`endpoints, these are needed for metrics output plugins. |
| serviceMonitor.additionalLabels | object | `{}` | Additional labels for the `ServiceMonitor`. |
| serviceMonitor.enabled | bool | `false` | If `true`, create a `ServiceMonitor` (or `PodMonitor` if the Service isn't enabled) resource to support the _Prometheus Operator_. |
| serviceMonitor.endpointConfig | object | `{}` | Additional endpoint configuration for the default `ServiceMonitor` endpoint. |
| storage.enabled | bool | `false` | If `true`, writeable host filesystem storage will be enabled. |
| storage.hostPath | string | `"/var/fluent-bit/data"` |  |
| terminationGracePeriodSeconds | int | `nil` | Termination grace period for the pod in seconds. |
| tolerations | list | `[]` | Node taints which will be tolerated for pod scheduling. |
| updateStrategy | object | `{}` | Update strategy for the `DaemonSet`. |
