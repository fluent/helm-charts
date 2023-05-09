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
