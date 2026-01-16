# fluent-bit-aggregator

![Version: 1.0.0-beta.1](https://img.shields.io/badge/Version-1.0.0--beta.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 4.2.2](https://img.shields.io/badge/AppVersion-4.2.2-informational?style=flat-square)

Helm chart for Fluent Bit running as an aggregation stateful set.

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
| affinity | object | `{}` | Affinity settings for pod scheduling. If an explicit label selector is not provided for pod affinity or pod anti-affinity one will be created from the pod selector labels. |
| args | list | `[]` | Extra args for the default container; `--workdir`, `--config` & `--enable-hot-reload` are managed by the chart. |
| automountServiceAccountToken | bool | `nil` | If the service account token should be mounted to the pod, this overrides `serviceAccount.automountToken`. |
| autoscaling.behavior | object | `{}` | Behaviour configuration for the `HorizontalPodAutoscaler`. |
| autoscaling.enabled | bool | `false` | If `true`, create a `HorizontalPodAutoscaler` to scale the `StatefulSet`. |
| autoscaling.maxReplicas | int | `3` | Maximum number of replicas for the `HorizontalPodAutoscaler`. |
| autoscaling.metrics | list | See _values.yaml_ | Metrics configuration for the `HorizontalPodAutoscaler`. |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas for the `HorizontalPodAutoscaler`. |
| command | list | `["/fluent-bit/bin/fluent-bit"]` | Command for the default container |
| commonLabels | object | `{}` | Labels to add to all chart resources. |
| config.env | object | `{}` | The [Env](https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/environment-variables-section) section allows you to define environment variables directly within the configuration file. These variables can then be used to dynamically replace values throughout your configuration using the ${VARIABLE_NAME} syntax. These values support templating. The `STORAGE_PATH` & `ADDITIONAL_PORT_<INDEX>` values are available but can't be set as they are controlled by the chart. |
| config.includes | list | `[]` | The [Includes](https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/includes-section) section allows you to specify additional YAML configuration files to be merged into the current configuration. |
| config.multilineParsers | list | `[]` | The [Multiline Parsers](https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/multiline-parsers-section) section allows you to define custom multiline parsers. |
| config.parsers | list | `[]` | The [Parsers](https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/parsers-section) section allows you to define custom parsers. |
| config.pipeline.filters | list | `[]` | The pipeline filters configure the plugins responsible for processing data. |
| config.pipeline.inputs | list | `[{"alias":"in","buffer_chunk_size":"1M","buffer_max_size":"6M","listen":"0.0.0.0","name":"forward","port":"${ADDITIONAL_PORT_0}","storage.type":"filesystem"}]` | The pipeline inputs configure the plugins responsible for collecting or receiving data. |
| config.pipeline.outputs | list | `[{"alias":"out","match":"*","name":"stdout"}]` | The pipeline outputs configure the plugins responsible for storing or forwarding data. |
| config.plugins | list | `[]` | The [Plugins](https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/plugins-section) section adds support for loading external plugins at runtime. |
| config.service | object | `{"http_listen":"0.0.0.0","log_level":"info"}` | The [Service](https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/service-section) section defines global properties of the service. The `daemon`, `http_server`, `http_port` & `storage.path` keys can't be set as they are controlled by the chart. |
| config.upstreamServers | list | `[]` | The [Upstream Servers](https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/upstream-servers-section) section defines a group of endpoints, referred to as nodes, which are used by output plugins to distribute data in a round-robin fashion. |
| dashboards.enabled | bool | `false` | If `true`, install the _Grafana_ dashboards provided by the chart. |
| env | list | `[]` | Environment variables for the default container. |
| extraConfig | object | `{}` | Additional YAML configuration to mount as YAML files to /fluent-bit/etc/conf/. |
| extraVolumeMounts | list | `[]` | Extra volume mounts for the default container. |
| extraVolumes | list | `[]` | Extra volumes for the pod. |
| fullnameOverride | string | `nil` | Override the full name of the chart. |
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
| ingresses | list | See _values.yaml_ | Ingresses, each input plugin will need it's own. |
| livenessProbe | object | See _values.yaml_ | Liveness probe configuration for the default container. |
| luaScripts | object | `{}` | Lua scripts to configure, these will be created at /fluent-bit/scripts/ and need to be referenced by an absolute path. |
| minReadySeconds | int | `nil` | Min ready seconds for the `StatefulSet`. |
| nameOverride | string | `nil` | Override the name of the chart. |
| nodeSelector | object | `{}` | Node labels to match for pod scheduling. |
| ordinals | object | `{}` | Ordinals configuration for the `StatefulSet`. |
| persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the `PersistentVolumeClaim`. |
| persistence.annotations | object | `{}` | Annotations for the `PersistentVolumeClaim`. |
| persistence.enabled | bool | `false` | If `true` & `storage.enabled` is `true`, persistence should be enabled for the `StatefulSet`. |
| persistence.retainDeleted | bool | `true` | If `true`, keep `PersistentVolumeClaims` when the `StatefulSet` is deleted. |
| persistence.retainScaled | bool | `true` | If `true`, keep `PersistentVolumeClaim` when the `StatefulSet` is scaled down. |
| persistence.size | string | `"8Gi"` | Size of the `PersistentVolumeClaim`. |
| persistence.storageClass | string | `nil` | Storage class for the `PersistentVolumeClaim`, if not set the default will be used. |
| podAnnotations | object | `{}` | Annotations to add to the pod. |
| podDisruptionBudget.enabled | bool | `false` | If `true`, create a `PodDisruptionBudget` resource. |
| podDisruptionBudget.maxUnavailable | string | `nil` | Minimum number of unavailable pods, either a number or a percentage. |
| podDisruptionBudget.minAvailable | string | `nil` | Minimum number of available pods, either a number or a percentage. |
| podDisruptionBudget.unhealthyPodEvictionPolicy | string | `nil` | Unhealthy pod eviction policy for the PDB. |
| podLabels | object | `{}` | Labels to add to the pod. |
| podManagementPolicy | string | `nil` | Pod management policy for the `StatefulSet`. |
| podSecurityContext | object | See _values.yaml_ | Security context for the pod. |
| priorityClassName | string | `nil` | Priority class name for the pod. |
| rbac.additionalRules | list | `[]` | Additional rules to add to the `ClusterRole`. |
| rbac.create | bool | `false` | If `true`, create a `ClusterRole` & `ClusterRoleBinding` with access to the Kubernetes API. |
| readinessProbe | object | See _values.yaml_ | Readiness probe configuration for the default container. |
| replicas | int | `1` | Number of replicas to create if `autoscaling.enabled` is `false`. |
| resources | object | `{}` | Resources for the default container. |
| securityContext | object | See _values.yaml_ | Security context for the default container. |
| service.additionalPorts | list | See _values.yaml_ | Additional ports to expose. |
| service.annotations | object | `{}` | Service annotations. |
| service.httpPort | int | `2020` | Fluent Bit HTTP port used for status and metrics. |
| service.trafficDistribution | string | `nil` | Traffic distribution for the service. |
| service.type | string | `"ClusterIP"` | Service type. |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account. |
| serviceAccount.automountToken | bool | `false` | If `true`, mount the `ServiceAccount` token. |
| serviceAccount.create | bool | `true` | If `true`, create a new `ServiceAccount`. |
| serviceAccount.labels | object | `{}` | Labels to add to the service account. |
| serviceAccount.name | string | `nil` | If this is set and `serviceAccount.create` is `true` this will be used for the created `ServiceAccount` name, if set and `serviceAccount.create` is `false` then this will define an existing `ServiceAccount` to use. |
| serviceMonitor.additionalEndpoints | list | `[]` | Additional `ServiceMonitor`endpoints, these are needed for metrics output plugins. |
| serviceMonitor.additionalLabels | object | `{}` | Additional labels for the `ServiceMonitor`. |
| serviceMonitor.enabled | bool | `false` | If `true`, create a `ServiceMonitor` resource to support the _Prometheus Operator_. |
| serviceMonitor.endpointConfig | object | `{}` | Additional endpoint configuration for the default `ServiceMonitor` endpoint. |
| terminationGracePeriodSeconds | int | `nil` | Termination grace period for the pod in seconds. |
| tolerations | list | `[]` | Node taints which will be tolerated for pod scheduling. |
| topologySpreadConstraints | list | `[]` | Topology spread constraints for pod scheduling. If an explicit label selector is not provided one will be created from the pod selector labels. |
| updateStrategy | object | `{}` | Update strategy for the `StatefulSet`. |
