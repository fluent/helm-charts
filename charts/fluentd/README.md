# Fluentd Helm Chart

## WIP

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| envFrom | list | `[]` |  |
| env[0].name | string | `"FLUENT_ELASTICSEARCH_HOST"` |  |
| env[0].value | string | `"elasticsearch-master"` |  |
| env[1].name | string | `"FLUENT_ELASTICSEARCH_PORT"` |  |
| env[1].value | string | `"9200"` |  |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"fluent/fluentd-kubernetes-daemonset"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| kind | string | `"DaemonSet"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| output.plugins.enabled | bool | `false` |  |
| output.plugins.pluginsList | list | `[]` |  |
| output.type | string | `"elasticsearch"` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| priorityClassName | string | `""` |  |
| rbac.create | bool | `true` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.annotations | object | `{}` |  |
| service.ports | list | `[]` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `nil` |  |
| serviceMonitor.enabled | bool | `false` |  |
| tolerations | list | `[]`