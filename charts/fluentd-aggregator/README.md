# fluentd-aggregator

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.1.0](https://img.shields.io/badge/AppVersion-2.1.0-informational?style=flat-square)

Helm chart for Fluentd running as an aggregation StatefulSet and using the fluent-plugin-route router.

**Homepage:** <https://www.fluentd.org/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| stevehipwell | <steve.hipwell@gmail.com> |  |

## Source Code

* <https://github.com/fluent/fluentd-aggregator-docker-image/>
* <https://github.com/fluent/helm-charts/>

## Installing the Chart

### OCI Repository

To install the chart using the recommended OCI method you can use the following command.

```shell
helm upgrade --install fluentd-aggregator oci://ghcr.io/fluent/helm-charts/fluentd-aggregator --version 1.0.0
```

#### Verification

As the OCI chart release is signed by [Cosign](https://github.com/sigstore/cosign) you can verify the chart before installing it by running the following command.

```shell
cosign verify --certificate-oidc-issuer https://token.actions.githubusercontent.com --certificate-identity-regexp 'https://github\.com/action-stars/helm-workflows/\.github/workflows/release\.yaml@.+' --certificate-github-workflow-repository fluent/helm-charts --certificate-github-workflow-name Release ghcr.io/fluent/helm-charts/fluentd-aggregator:1.0.0
```

### Non-OCI Repository

Alternatively you can use the legacy non-OCI method via the following commands.

```shell
helm repo add fluent https://fluent.github.io/helm-charts/
helm upgrade --install fluentd-aggregator fluent/fluentd-aggregator --version 1.0.0
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity settings for pod scheduling. If an explicit label selector is not provided for pod affinity or pod anti-affinity one will be created from the pod selector labels. |
| args | list | `[]` | Args for the default container. |
| automountServiceAccountToken | bool | `nil` | If the service account token should be mounted to the pod, this overrides `serviceAccount.automountToken`. |
| autoscaling.behavior | object | `{}` | Behaviour configuration for the `HorizontalPodAutoscaler`. |
| autoscaling.enabled | bool | `false` | If `true`, create a `HorizontalPodAutoscaler` to scale the `StatefulSet`. |
| autoscaling.maxReplicas | int | `3` | Maximum number of replicas for the `HorizontalPodAutoscaler`. |
| autoscaling.metrics | list | See _values.yaml_ | Metrics configuration for the `HorizontalPodAutoscaler`. |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas for the `HorizontalPodAutoscaler`. |
| bashImage.digest | string | `nil` | Optional image digest for the bash containers. |
| bashImage.pullPolicy | string | `"IfNotPresent"` | Image pull policy for bash containers. |
| bashImage.repository | string | `"cgr.dev/chainguard/bash"` | Image repository for bash containers. |
| bashImage.tag | string | `"latest"` | Image tag for bash containers, this will be omitted if set to `-`. |
| commonLabels | object | `{}` | Labels to add to all chart resources. |
| config.filters | string | See _values.yaml_ | Fluentd filter configuration. |
| config.metrics | bool | `true` | If `true`, configure metrics |
| config.routes | list | See _values.yaml_ | Fluentd router configuration. |
| config.sourceLabel | string | `"@INPUT"` | Label for input sources which will be used to route logs through the pipeline. |
| config.sources | string | See _values.yaml_ | Fluentd source configuration. |
| config.system | object | See _values.yaml_ | Fluent Bit system configuration. |
| dashboards.enabled | bool | `false` | If `true`, install the _Grafana_ dashboards provided by the chart. |
| env | list | `[]` | Environment variables for the default container. |
| extraVolumeMounts | list | `[]` | Extra volume mounts for the default container. |
| extraVolumes | list | `[]` | Extra volumes for the pod. |
| fullnameOverride | string | `nil` | Override the full name of the chart. |
| httpRoutes | list | See _values.yaml_ | `HTTPRoute` resources, each input plugin will need its own. |
| image.digest | string | `nil` | Optional image digest for the default container. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy for the default container. |
| image.repository | string | `"ghcr.io/fluent/fluentd-aggregator-docker-image"` | Image repository for the default container. |
| image.tag | string | `nil` | Image tag for the default container, this will default to `.Chart.AppVersion` if not set and will be omitted if set to `-`. |
| imagePullSecrets | list | `[]` | Image pull secrets. |
| ingresses | list | See _values.yaml_ | Ingresses, each input plugin will need it's own. |
| initNonRootSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":65532,"runAsNonRoot":true,"runAsUser":65532}` | Security context for non-root init containers. |
| livenessProbe | object | See _values.yaml_ | Liveness probe configuration for the default container. |
| minReadySeconds | int | `nil` | Min ready seconds for the `StatefulSet`. |
| nameOverride | string | `nil` | Override the name of the chart. |
| nodeSelector | object | `{}` | Node labels to match for pod scheduling. |
| ordinals | object | `{}` | Ordinals configuration for the `StatefulSet`. |
| persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the `PersistentVolumeClaim`. |
| persistence.annotations | object | `{}` | Annotations for the `PersistentVolumeClaim`. |
| persistence.enabled | bool | `false` | If `true`, persistence should be enabled for the `StatefulSet`. |
| persistence.legacy | bool | `false` | If `true`, use the legacy volume claim pattern. |
| persistence.legacyName | string | `"buffer"` | The name to use for legacy volume claims, either `buffer` or `state`. |
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
| readinessProbe | object | See _values.yaml_ | Readiness probe configuration for the default container. |
| replicas | int | `1` | Number of replicas to create if `autoscaling.enabled` is `false`. |
| resources | object | `{}` | Resources for the default container. |
| securityContext | object | See _values.yaml_ | Security context for the default container. |
| service.additionalPorts | list | See _values.yaml_ | Additional ports to expose. |
| service.annotations | object | `{}` | Service annotations. |
| service.httpPort | int | `9880` | Fluentd port used for status. |
| service.legacy | bool | `false` | If `true`, use legacy naming so the headless service doesn't change. |
| service.metricsPort | int | `24231` | Fluentd port used for metrics. |
| service.trafficDistribution | string | `nil` | Traffic distribution for the service. |
| service.type | string | `"ClusterIP"` | Service type. |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account. |
| serviceAccount.automountToken | bool | `false` | If `true`, mount the `ServiceAccount` token. |
| serviceAccount.create | bool | `true` | If `true`, create a new `ServiceAccount`. |
| serviceAccount.labels | object | `{}` | Labels to add to the service account. |
| serviceAccount.name | string | `nil` | If this is set and `serviceAccount.create` is `true` this will be used for the created `ServiceAccount` name, if set and `serviceAccount.create` is `false` then this will define an existing `ServiceAccount` to use. |
| serviceMonitor.additionalLabels | object | `{}` | Additional labels for the `ServiceMonitor`. |
| serviceMonitor.enabled | bool | `false` | If `true`, create a `ServiceMonitor` resource to support the _Prometheus Operator_. |
| serviceMonitor.endpointConfig | object | `{}` | Additional endpoint configuration for the default `ServiceMonitor` endpoint. |
| terminationGracePeriodSeconds | int | `nil` | Termination grace period for the pod in seconds. |
| tolerations | list | `[]` | Node taints which will be tolerated for pod scheduling. |
| topologySpreadConstraints | list | `[]` | Topology spread constraints for pod scheduling. If an explicit label selector is not provided one will be created from the pod selector labels. |
| updateStrategy | object | `{}` | Update strategy for the `StatefulSet`. |

----------------------------------------------

Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs/).
