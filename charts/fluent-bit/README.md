# fluent-bit

![Version: 0.55.0](https://img.shields.io/badge/Version-0.55.0-informational?style=flat-square) ![AppVersion: 4.2.2](https://img.shields.io/badge/AppVersion-4.2.2-informational?style=flat-square)

Fast and lightweight log processor and forwarder for Linux, OSX and BSD family operating systems.

**Homepage:** <https://fluentbit.io/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| edsiper | <eduardo@calyptia.com> |  |
| naseemkullah | <naseem@transit.app> |  |
| Towmeykaw | <towmeykaw@gmail.com> |  |
| stevehipwell | <steve.hipwell@gmail.com> |  |

## Source Code

* <https://github.com/fluent/fluent-bit/>

## Installing the Chart

### OCI Repository

To install the chart using the recommended OCI method you can use the following command.

```shell
helm upgrade --install fluent-bit oci://ghcr.io/fluent/helm-charts/fluent-bit --version 0.55.0
```

#### Verification

As the OCI chart release is signed by [Cosign](https://github.com/sigstore/cosign) you can verify the chart before installing it by running the following command.

```shell
cosign verify --certificate-oidc-issuer https://token.actions.githubusercontent.com --certificate-identity-regexp 'https://github\.com/action-stars/helm-workflows/\.github/workflows/release\.yaml@.+' --certificate-github-workflow-repository fluent/helm-charts --certificate-github-workflow-name Release ghcr.io/fluent/helm-charts/fluent-bit:0.55.0
```

### Non-OCI Repository

Alternatively you can use the legacy non-OCI method via the following commands.

```shell
helm repo add fluent https://fluent.github.io/helm-charts/
helm upgrade --install fluent-bit fluent/fluent-bit --version 0.55.0
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| annotations | object | `{}` |  |
| args[0] | string | `"--workdir=/fluent-bit/etc"` |  |
| args[1] | string | `"--config=/fluent-bit/etc/conf/fluent-bit.conf"` |  |
| autoscaling.behavior | object | `{}` |  |
| autoscaling.customRules | list | `[]` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `3` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `75` |  |
| autoscaling.vpa.annotations | object | `{}` |  |
| autoscaling.vpa.controlledResources | list | `[]` |  |
| autoscaling.vpa.controlledValues | string | `nil` |  |
| autoscaling.vpa.enabled | bool | `false` |  |
| autoscaling.vpa.maxAllowed | object | `{}` |  |
| autoscaling.vpa.minAllowed | object | `{}` |  |
| autoscaling.vpa.updatePolicy.updateMode | string | `"Auto"` |  |
| command[0] | string | `"/fluent-bit/bin/fluent-bit"` |  |
| config.customParsers | string | `"[PARSER]\n    Name docker_no_time\n    Format json\n    Time_Keep Off\n    Time_Key time\n    Time_Format %Y-%m-%dT%H:%M:%S.%L\n"` |  |
| config.extraFiles | object | `{}` |  |
| config.filters | string | `"[FILTER]\n    Name kubernetes\n    Match kube.*\n    Merge_Log On\n    Keep_Log Off\n    K8S-Logging.Parser On\n    K8S-Logging.Exclude On\n"` |  |
| config.inputs | string | `"[INPUT]\n    Name tail\n    Path /var/log/containers/*.log\n    multiline.parser docker, cri\n    Tag kube.*\n    Mem_Buf_Limit 5MB\n    Skip_Long_Lines On\n\n[INPUT]\n    Name systemd\n    Tag host.*\n    Systemd_Filter _SYSTEMD_UNIT=kubelet.service\n    Read_From_Tail On\n"` |  |
| config.outputs | string | `"[OUTPUT]\n    Name es\n    Match kube.*\n    Host elasticsearch-master\n    Logstash_Format On\n    Retry_Limit False\n\n[OUTPUT]\n    Name es\n    Match host.*\n    Host elasticsearch-master\n    Logstash_Format On\n    Logstash_Prefix node\n    Retry_Limit False\n"` |  |
| config.service | string | `"[SERVICE]\n    Daemon Off\n    Flush {{ .Values.flush }}\n    Log_Level {{ .Values.logLevel }}\n    Parsers_File /fluent-bit/etc/parsers.conf\n    Parsers_File /fluent-bit/etc/conf/custom_parsers.conf\n    HTTP_Server On\n    HTTP_Listen 0.0.0.0\n    HTTP_Port {{ .Values.metricsPort }}\n    Health_Check On\n"` |  |
| config.upstream | object | `{}` |  |
| daemonSetVolumeMounts[0].mountPath | string | `"/var/log"` |  |
| daemonSetVolumeMounts[0].name | string | `"varlog"` |  |
| daemonSetVolumeMounts[1].mountPath | string | `"/var/lib/docker/containers"` |  |
| daemonSetVolumeMounts[1].name | string | `"varlibdockercontainers"` |  |
| daemonSetVolumeMounts[1].readOnly | bool | `true` |  |
| daemonSetVolumeMounts[2].mountPath | string | `"/etc/machine-id"` |  |
| daemonSetVolumeMounts[2].name | string | `"etcmachineid"` |  |
| daemonSetVolumeMounts[2].readOnly | bool | `true` |  |
| daemonSetVolumes[0].hostPath.path | string | `"/var/log"` |  |
| daemonSetVolumes[0].name | string | `"varlog"` |  |
| daemonSetVolumes[1].hostPath.path | string | `"/var/lib/docker/containers"` |  |
| daemonSetVolumes[1].name | string | `"varlibdockercontainers"` |  |
| daemonSetVolumes[2].hostPath.path | string | `"/etc/machine-id"` |  |
| daemonSetVolumes[2].hostPath.type | string | `"File"` |  |
| daemonSetVolumes[2].name | string | `"etcmachineid"` |  |
| dashboards.annotations | object | `{}` |  |
| dashboards.deterministicUid | bool | `false` |  |
| dashboards.enabled | bool | `false` |  |
| dashboards.labelKey | string | `"grafana_dashboard"` |  |
| dashboards.labelValue | int | `1` |  |
| dashboards.namespace | string | `""` |  |
| dnsConfig | object | `{}` |  |
| dnsPolicy | string | `"ClusterFirst"` |  |
| env | list | `[]` |  |
| envFrom | list | `[]` |  |
| envWithTpl | list | `[]` |  |
| existingConfigMap | string | `""` |  |
| extraContainers | list | `[]` |  |
| extraPorts | list | `[]` |  |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` |  |
| flush | int | `1` |  |
| fullnameOverride | string | `""` |  |
| hostAliases | list | `[]` |  |
| hostNetwork | bool | `false` |  |
| hotReload.enabled | bool | `false` |  |
| hotReload.extraWatchVolumes | list | `[]` |  |
| hotReload.image.digest | string | `nil` |  |
| hotReload.image.pullPolicy | string | `"IfNotPresent"` |  |
| hotReload.image.repository | string | `"ghcr.io/jimmidyson/configmap-reload"` |  |
| hotReload.image.tag | string | `"v0.15.0"` |  |
| hotReload.resources | object | `{}` |  |
| hotReload.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| hotReload.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| hotReload.securityContext.privileged | bool | `false` |  |
| hotReload.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| hotReload.securityContext.runAsGroup | int | `65532` |  |
| hotReload.securityContext.runAsNonRoot | bool | `true` |  |
| hotReload.securityContext.runAsUser | int | `65532` |  |
| image.digest | string | `nil` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"cr.fluentbit.io/fluent/fluent-bit"` |  |
| image.tag | string | `nil` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.extraHosts | list | `[]` |  |
| ingress.hosts | list | `[]` |  |
| ingress.ingressClassName | string | `""` |  |
| ingress.tls | list | `[]` |  |
| initContainers | list | `[]` |  |
| kind | string | `"DaemonSet"` | DaemonSet or Deployment |
| labels | object | `{}` |  |
| lifecycle | object | `{}` |  |
| livenessProbe.httpGet.path | string | `"/"` |  |
| livenessProbe.httpGet.port | string | `"http"` |  |
| logLevel | string | `"info"` |  |
| luaScripts | object | `{}` |  |
| metricsPort | int | `2020` |  |
| minReadySeconds | string | `nil` |  |
| nameOverride | string | `""` |  |
| networkPolicy.enabled | bool | `false` |  |
| nodeSelector | object | `{}` |  |
| openShift.enabled | bool | `false` |  |
| openShift.securityContextConstraints.annotations | object | `{}` |  |
| openShift.securityContextConstraints.create | bool | `true` |  |
| openShift.securityContextConstraints.existingName | string | `""` |  |
| openShift.securityContextConstraints.name | string | `""` |  |
| openShift.securityContextConstraints.runAsUser.type | string | `"RunAsAny"` |  |
| openShift.securityContextConstraints.seLinuxContext.type | string | `"MustRunAs"` |  |
| podAnnotations | object | `{}` |  |
| podDisruptionBudget.annotations | object | `{}` |  |
| podDisruptionBudget.enabled | bool | `false` |  |
| podDisruptionBudget.maxUnavailable | string | `"30%"` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| podSecurityPolicy.annotations | object | `{}` |  |
| podSecurityPolicy.create | bool | `false` |  |
| podSecurityPolicy.runAsUser.rule | string | `"RunAsAny"` |  |
| podSecurityPolicy.seLinux.rule | string | `"RunAsAny"` |  |
| priorityClassName | string | `""` |  |
| prometheusRule.enabled | bool | `false` |  |
| rbac.create | bool | `true` |  |
| rbac.eventsAccess | bool | `false` |  |
| rbac.nodeAccess | bool | `false` |  |
| readinessProbe.httpGet.path | string | `"/api/v1/health"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| replicaCount | int | `1` | Only applicable if kind=Deployment |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.annotations | object | `{}` |  |
| service.externalIPs | list | `[]` |  |
| service.internalTrafficPolicy | string | `nil` |  |
| service.labels | object | `{}` |  |
| service.loadBalancerClass | string | `nil` |  |
| service.loadBalancerIP | string | `nil` |  |
| service.loadBalancerSourceRanges | list | `[]` |  |
| service.port | int | `2020` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | string | `nil` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `nil` |  |
| serviceMonitor.additionalEndpoints | list | `[]` |  |
| serviceMonitor.enabled | bool | `false` |  |
| terminationGracePeriodSeconds | string | `nil` |  |
| testFramework.enabled | bool | `true` |  |
| testFramework.image.digest | string | `nil` |  |
| testFramework.image.pullPolicy | string | `"Always"` |  |
| testFramework.image.repository | string | `"busybox"` |  |
| testFramework.image.tag | string | `"latest"` |  |
| testFramework.namespace | string | `nil` |  |
| tolerations | list | `[]` |  |
| updateStrategy | object | `{}` |  |
| volumeMounts[0].mountPath | string | `"/fluent-bit/etc/conf"` |  |
| volumeMounts[0].name | string | `"config"` |  |

## Usage

### Using Lua Scripts

Fluent Bit allows us to provide a filter to modify the incoming records using custom [Lua scripts.](https://docs.fluentbit.io/manual/pipeline/filters/lua)

### How to use Lua scripts with this Chart

First, you should add your Lua scripts to `luaScripts` in values.yaml, templating is supported.

```yaml
luaScripts:
  filter_example.lua: |
    function filter_name(tag, timestamp, record)
        -- put your lua code here.
    end
```

After that, the Lua scripts will be ready to be used as filters. So next step is to add your Fluent bit [filter](https://docs.fluentbit.io/manual/concepts/data-pipeline/filter) to `config.filters` in values.yaml, for example:

```yaml
config:
  filters: |
    [FILTER]
        Name    lua
        Match   <your-tag>
        script  /fluent-bit/scripts/filter_example.lua
        call    filter_name
```

Under the hood, the chart will:

- Create a configmap using `luaScripts`.
- Add a volumeMounts for each Lua scripts using the path `/fluent-bit/scripts/<script>`.
- Add the Lua script's configmap as volume to the pod.

> [!NOTE]
> Remember to set the `script` attribute in the filter using `/fluent-bit/scripts/`, otherwise the file will not be found by fluent bit.

----------------------------------------------

Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs/).
