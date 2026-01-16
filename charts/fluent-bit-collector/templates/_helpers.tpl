{{/*
Expand the name of the chart.
*/}}
{{- define "fluent-bit-collector.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fluent-bit-collector.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "fluent-bit-collector.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "fluent-bit-collector.labels" -}}
helm.sh/chart: {{ include "fluent-bit-collector.chart" . }}
{{ include "fluent-bit-collector.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "fluent-bit-collector.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fluent-bit-collector.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "fluent-bit-collector.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "fluent-bit-collector.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}



{{/*
Define the service name
*/}}
{{- define "fluent-bit-collector.serviceName" -}}
{{- include "fluent-bit-collector.fullname" . }}
{{- end }}

{{/*
Define the config configmap name
*/}}
{{- define "fluent-bit-collector.configConfigMapName" -}}
{{- (printf "%s-config" (include "fluent-bit-collector.fullname" .)) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Define the scripts configmap name
*/}}
{{- define "fluent-bit-collector.scriptsConfigMapName" -}}
{{- (printf "%s-scripts" (include "fluent-bit-collector.fullname" .)) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Define the dashboard configmap name
*/}}
{{- define "fluent-bit-collector.dashboardConfigMapName" -}}
{{- (printf "%s-dashboard" (include "fluent-bit-collector.fullname" .)) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
The image to use
*/}}
{{- define "fluent-bit-collector.image" -}}
{{- $tag := ternary (printf ":%s" (default .Chart.AppVersion .Values.image.tag)) "" (ne .Values.image.tag "-") }}
{{- $digest := ternary (printf "@%s" .Values.image.digest) "" (not (empty .Values.image.digest)) }}
{{- printf "%s%s%s" .Values.image.repository $tag $digest }}
{{- end }}

{{/*
The config reloader image to use
*/}}
{{- define "fluent-bit-collector.reloaderImage" -}}
{{- $tag := ternary (printf ":%s" .Values.hotReload.image.tag) "" (not (empty .Values.hotReload.image.tag)) }}
{{- $digest := ternary (printf "@%s" .Values.hotReload.image.digest) "" (not (empty .Values.hotReload.image.digest)) }}
{{- printf "%s%s%s" .Values.hotReload.image.repository $tag $digest }}
{{- end }}
