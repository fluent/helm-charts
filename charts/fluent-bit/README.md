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
| config.customParsers | string | `"[PARSER]\n    Name docker_no_time\n    Format json\n    Time_Keep Off\n    Time_Key time\n    Time_Format %Y-%m-%dT%H:%M:%S.%L\n"` |  |
| config.filters | string | `"[FILTER]\n    Name kubernetes\n    Match kube.*\n    Merge_Log On\n    Keep_Log Off\n    K8S-Logging.Parser On\n    K8S-Logging.Exclude On\n"` |  |
| config.inputs | string | `"[INPUT]\n    Name tail\n    Path /var/log/containers/*.log\n    Parser docker\n    Tag kube.*\n    Mem_Buf_Limit 5MB\n    Skip_Long_Lines On\n\n[INPUT]\n    Name systemd\n    Tag host.*\n    Systemd_Filter _SYSTEMD_UNIT=kubelet.service\n    Read_From_Tail On\n"` |  |
| config.outputs | string | `"[OUTPUT]\n    Name es\n    Match kube.*\n    Host elasticsearch-master\n    Logstash_Format On\n    Retry_Limit False\n\n[OUTPUT]\n    Name es\n    Match host.*\n    Host elasticsearch-master\n    Logstash_Format On\n    Logstash_Prefix node\n    Retry_Limit False\n"` |  |
| config.service | string | `"[SERVICE]\n    Flush 1\n    Daemon Off\n    Log_Level info\n    Parsers_File parsers.conf\n    Parsers_File custom_parsers.conf\n    HTTP_Server On\n    HTTP_Listen 0.0.0.0\n    HTTP_Port 2020\n"` |  |
| env | list | `[]` |  |
| envFrom | list | `[]` |  |
| extraPorts | list | `[]`| |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"fluent/fluent-bit"` |  |
| image.tag | string | `.Chart.AppVersion` |  |
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
| serviceMonitor.enabled | bool | `false` |  |
| serviceMonitor.namespace | string | `monitoring` |  |
| serviceMonitor.interval | string | `10s` |  |
| serviceMonitor.scrapeTimeout | string | `10s` |  |
| serviceMonitor.selector | object | `{}` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `nil` |  |
| tolerations | list | `[]` |  |
