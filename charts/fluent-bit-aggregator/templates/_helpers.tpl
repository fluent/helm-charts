{{/*
Expand the name of the chart.
*/}}
{{- define "fluent-bit-aggregator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fluent-bit-aggregator.fullname" -}}
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
{{- define "fluent-bit-aggregator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "fluent-bit-aggregator.labels" -}}
helm.sh/chart: {{ include "fluent-bit-aggregator.chart" . }}
{{ include "fluent-bit-aggregator.selectorLabels" . }}
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
{{- define "fluent-bit-aggregator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fluent-bit-aggregator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "fluent-bit-aggregator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "fluent-bit-aggregator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define the service name
*/}}
{{- define "fluent-bit-aggregator.serviceName" -}}
{{- include "fluent-bit-aggregator.fullname" . }}
{{- end }}

{{/*
Define the headless service name
*/}}
{{- define "fluent-bit-aggregator.headlessServiceName" -}}
{{- (printf "%s-headless" (include "fluent-bit-aggregator.serviceName" .)) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Define the config configmap name
*/}}
{{- define "fluent-bit-aggregator.configConfigMapName" -}}
{{- (printf "%s-config" (include "fluent-bit-aggregator.fullname" .)) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Define the scripts configmap name
*/}}
{{- define "fluent-bit-aggregator.scriptsConfigMapName" -}}
{{- (printf "%s-scripts" (include "fluent-bit-aggregator.fullname" .)) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Define the dashboard configmap name
*/}}
{{- define "fluent-bit-aggregator.dashboardConfigMapName" -}}
{{- (printf "%s-dashboard" (include "fluent-bit-aggregator.fullname" .)) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
The image to use
*/}}
{{- define "fluent-bit-aggregator.image" -}}
{{- $tag := ternary (printf ":%s" (default .Chart.AppVersion .Values.image.tag)) "" (ne .Values.image.tag "-") }}
{{- $digest := ternary (printf "@%s" .Values.image.digest) "" (not (empty .Values.image.digest)) }}
{{- printf "%s%s%s" .Values.image.repository $tag $digest }}
{{- end }}

{{/*
The config reloader image to use
*/}}
{{- define "fluent-bit-aggregator.reloaderImage" -}}
{{- $tag := ternary (printf ":%s" .Values.hotReload.image.tag) "" (not (empty .Values.hotReload.image.tag)) }}
{{- $digest := ternary (printf "@%s" .Values.hotReload.image.digest) "" (not (empty .Values.hotReload.image.digest)) }}
{{- printf "%s%s%s" .Values.hotReload.image.repository $tag $digest }}
{{- end }}

{{/*
Patch the label selector on an object
*/}}
{{- define "fluent-bit-aggregator.patchLabelSelector" -}}
{{- if not (hasKey ._target "labelSelector") }}
{{- $selectorLabels := (include "fluent-bit-aggregator.selectorLabels" .) | fromYaml }}
{{- $_ := set ._target "labelSelector" (dict "matchLabels" $selectorLabels) }}
{{- end }}
{{- end }}

{{/*
Patch pod affinity
*/}}
{{- define "fluent-bit-aggregator.patchPodAffinity" -}}
{{- if (hasKey ._podAffinity "requiredDuringSchedulingIgnoredDuringExecution") }}
{{- range $term := ._podAffinity.requiredDuringSchedulingIgnoredDuringExecution }}
{{- include "fluent-bit-aggregator.patchLabelSelector" (merge (dict "_target" $term) $) }}
{{- end }}
{{- end }}
{{- if (hasKey ._podAffinity "preferredDuringSchedulingIgnoredDuringExecution") }}
{{- range $weightedTerm := ._podAffinity.preferredDuringSchedulingIgnoredDuringExecution }}
{{- include "fluent-bit-aggregator.patchLabelSelector" (merge (dict "_target" $weightedTerm.podAffinityTerm) $) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Patch affinity
*/}}
{{- define "fluent-bit-aggregator.patchAffinity" -}}
{{- if (hasKey .Values.affinity "podAffinity") }}
{{- include "fluent-bit-aggregator.patchPodAffinity" (merge (dict "_podAffinity" .Values.affinity.podAffinity) .) }}
{{- end }}
{{- if (hasKey .Values.affinity "podAntiAffinity") }}
{{- include "fluent-bit-aggregator.patchPodAffinity" (merge (dict "_podAffinity" .Values.affinity.podAntiAffinity) .) }}
{{- end }}
{{- end }}

{{/*
Patch topology spread constraints
*/}}
{{- define "fluent-bit-aggregator.patchTopologySpreadConstraints" -}}
{{- range $constraint := .Values.topologySpreadConstraints }}
{{- include "fluent-bit-aggregator.patchLabelSelector" (merge (dict "_target" $constraint) $) }}
{{- end }}
{{- end }}
