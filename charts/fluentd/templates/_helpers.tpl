{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "fluentd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fluentd.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "fluentd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "fluentd.labels" -}}
helm.sh/chart: {{ include "fluentd.chart" . }}
{{ include "fluentd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "fluentd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fluentd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "fluentd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "fluentd.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Shortened version of the releaseName, applied as a suffix to numerous resources.
*/}}
{{- define "fluentd.shortReleaseName" -}}
{{- .Release.Name | trunc 35 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name of the configMap used for the fluentd.conf configuration file; allows users to override the default.
*/}}
{{- define "fluentd.mainConfigMapName" -}}
{{- if .Values.mainConfigMapNameOverride -}}
    {{ .Values.mainConfigMapNameOverride }}
{{- else -}}
    {{ printf "%s-%s" "fluentd-main" ( include "fluentd.shortReleaseName" . ) }}
{{- end -}}
{{- end -}}

{{/*
Name of the configMap used for additional configuration files; allows users to override the default.
*/}}
{{- define "fluentd.extraFilesConfigMapName" -}}
{{- if .Values.extraFilesConfigMapNameOverride -}}
    {{ printf "%s" .Values.extraFilesConfigMapNameOverride }}
{{- else -}}
    {{ printf "%s-%s" "fluentd-config" ( include "fluentd.shortReleaseName" . ) }}
{{- end -}}
{{- end -}}

{{/*
HPA ApiVersion according k8s version
Check legacy first so helm template / kustomize will default to latest version
*/}}
{{- define "fluentd.hpa.apiVersion" -}}
{{- if and (.Capabilities.APIVersions.Has "autoscaling/v2beta2") (semverCompare "<1.23-0" .Capabilities.KubeVersion.GitVersion) -}}
autoscaling/v2beta2
{{- else -}}
autoscaling/v2
{{- end -}}
{{- end -}}
{{- define "fluentd.zones" -}}
{{- if .Values.zonalDeployments -}}
{{- toJson .Values.zonalDeployments -}}
{{- else -}}
{{- toJson (list (dict "name" "")) -}}
{{- end -}}
{{- end -}}

{{- define "fluentd.zoneContext" -}}
{{- $root := .root -}}
{{- $zone := .zone -}}
{{- if and $root.Values.zonalDeployments (not (and (kindIs "map" $zone) $zone.name)) -}}
{{- fail "every entry in zonalDeployments must be a map with a name" -}}
{{- end -}}
{{- $values := deepCopy $root.Values -}}
{{- if $zone.name -}}
{{- $_ := set $values "nodeSelector" (merge (dict $root.Values.zonalDeploymentsTopologyKey $zone.name) ($values.nodeSelector | default dict)) -}}
{{- if hasKey $zone "replicaCount" -}}
{{- $_ := set $values "replicaCount" $zone.replicaCount -}}
{{- end -}}
{{- if hasKey $zone "minReplicas" -}}
{{- $_ := set $values.autoscaling "minReplicas" $zone.minReplicas -}}
{{- end -}}
{{- if hasKey $zone "maxReplicas" -}}
{{- $_ := set $values.autoscaling "maxReplicas" $zone.maxReplicas -}}
{{- end -}}
{{- end -}}
{{- $_ := set .ctx "Values" $values -}}
{{- $_ := set .ctx "Zone" ($zone.name | default "") -}}
{{- range $key := list "Release" "Chart" "Capabilities" "Files" "Template" -}}
{{- $_ := set $.ctx $key (index $root $key) -}}
{{- end -}}
{{- end -}}

{{- define "fluentd.workloadName" -}}
{{- if .Zone -}}
{{- $suffix := printf "-%s" .Zone -}}
{{- printf "%s%s" (include "fluentd.fullname" . | trunc (int (sub 63 (len $suffix))) | trimSuffix "-") $suffix -}}
{{- else -}}
{{- include "fluentd.fullname" . -}}
{{- end -}}
{{- end -}}
