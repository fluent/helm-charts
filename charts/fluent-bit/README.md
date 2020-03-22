# Fluent Bit Helm Chart

[Fluent Bit](https://fluentbit.io) is a fast and lightweight log processor and forwarder or Linux, OSX and BSD family operating systems.

## Installation

To add the `fluent` helm repo, run:

```sh
helm repo add fluent https://fluent.github.io/helm-charts
```

To install a release named `fluent-bit`, run:

```sh
helm install fluent-bit fluent/fluent-bit
```

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| config.customParsers | list | `[]` |  |
| config.filters[0]."K8S-Logging.Exclude" | bool | `true` |  |
| config.filters[0]."K8S-Logging.Parser" | bool | `true` |  |
| config.filters[0].Keep_Log | bool | `false` |  |
| config.filters[0].Match | string | `"kube.*"` |  |
| config.filters[0].Merge_Log | bool | `true` |  |
| config.filters[0].Name | string | `"kubernetes"` |  |
| config.inputs[0].Mem_Buf_Limit | string | `"5MB"` |  |
| config.inputs[0].Name | string | `"tail"` |  |
| config.inputs[0].Parser | string | `"docker"` |  |
| config.inputs[0].Path | string | `"/var/log/containers/*.log"` |  |
| config.inputs[0].Skip_Long_Lines | bool | `true` |  |
| config.inputs[0].Tag | string | `"kube.*"` |  |
| config.inputs[1].Name | string | `"systemd"` |  |
| config.inputs[1].Read_From_Tail | bool | `true` |  |
| config.inputs[1].Systemd_Filter | string | `"_SYSTEMD_UNIT=kubelet.service"` |  |
| config.inputs[1].Tag | string | `"host.*"` |  |
| config.outputs[0].Host | string | `"elasticsearch-master"` |  |
| config.outputs[0].Logstash_Format | bool | `true` |  |
| config.outputs[0].Match | string | `"*"` |  |
| config.outputs[0].Name | string | `"es"` |  |
| config.outputs[0].Retry_Limit | bool | `false` |  |
| config.service.Daemon | bool | `false` |  |
| config.service.Flush | int | `1` |  |
| config.service.HTTP_Listen | string | `"0.0.0.0"` |  |
| config.service.HTTP_Port | int | `2020` |  |
| config.service.HTTP_Server | bool | `true` |  |
| config.service.Log_Level | string | `"info"` |  |
| config.service.Parsers_File | string | `"custom_parsers.conf"` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"fluent/fluent-bit"` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| priorityClassName | string | `""` |  |
| rbac.create | bool | `true` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.annotations | object | `{}` |  |
| service.port | int | `2020` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `nil` |  |
| tolerations | list | `[]` |  |
