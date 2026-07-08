{{/*
Expand the name of the chart.
*/}}
{{- define "fluentd-aggregator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fluentd-aggregator.fullname" -}}
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
{{- define "fluentd-aggregator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "fluentd-aggregator.labels" -}}
helm.sh/chart: {{ include "fluentd-aggregator.chart" . }}
{{ include "fluentd-aggregator.selectorLabels" . }}
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
{{- define "fluentd-aggregator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fluentd-aggregator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "fluentd-aggregator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "fluentd-aggregator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define the service name
*/}}
{{- define "fluentd-aggregator.serviceName" -}}
{{- include "fluentd-aggregator.fullname" . }}
{{- end }}

{{/*
Define the headless service name
*/}}
{{- define "fluentd-aggregator.headlessServiceName" -}}
{{- (printf "%s-headless" (include "fluentd-aggregator.serviceName" .) | trunc 54 | trimSuffix "-") }}
{{- end }}

{{/*
Define the config configmap name
*/}}
{{- define "fluentd-aggregator.configConfigMapName" -}}
{{- (printf "%s-config" (include "fluentd-aggregator.fullname" .) | trunc 56 | trimSuffix "-") }}
{{- end }}

{{/*
Define the dashboard configmap name
*/}}
{{- define "fluentd-aggregator.dashboardConfigMapName" -}}
{{- (printf "%s-dashboard" (include "fluentd-aggregator.fullname" .) | trunc 53 | trimSuffix "-") }}
{{- end }}

{{/*
Create an image
*/}}
{{- define "fluentd-aggregator.image" -}}
{{- $tag := ternary (printf ":%s" .tag) "" (ne .tag "-") }}
{{- $digest := ternary (printf "@%s" .digest) "" (not (empty .digest)) }}
{{- printf "%s%s%s" .repository $tag $digest }}
{{- end }}

{{/*
Patch the label selector on an object
*/}}
{{- define "fluentd-aggregator.patchLabelSelector" -}}
{{- if not (hasKey ._target "labelSelector") }}
{{- $selectorLabels := (include "fluentd-aggregator.selectorLabels" .) | fromYaml }}
{{- $_ := set ._target "labelSelector" (dict "matchLabels" $selectorLabels) }}
{{- end }}
{{- end }}

{{/*
Patch pod affinity
*/}}
{{- define "fluentd-aggregator.patchPodAffinity" -}}
{{- if (hasKey ._podAffinity "requiredDuringSchedulingIgnoredDuringExecution") }}
{{- range $term := ._podAffinity.requiredDuringSchedulingIgnoredDuringExecution }}
{{- include "fluentd-aggregator.patchLabelSelector" (merge (dict "_target" $term) $) }}
{{- end }}
{{- end }}
{{- if (hasKey ._podAffinity "preferredDuringSchedulingIgnoredDuringExecution") }}
{{- range $weightedTerm := ._podAffinity.preferredDuringSchedulingIgnoredDuringExecution }}
{{- include "fluentd-aggregator.patchLabelSelector" (merge (dict "_target" $weightedTerm.podAffinityTerm) $) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Patch affinity
*/}}
{{- define "fluentd-aggregator.patchAffinity" -}}
{{- if (hasKey .Values.affinity "podAffinity") }}
{{- include "fluentd-aggregator.patchPodAffinity" (merge (dict "_podAffinity" .Values.affinity.podAffinity) .) }}
{{- end }}
{{- if (hasKey .Values.affinity "podAntiAffinity") }}
{{- include "fluentd-aggregator.patchPodAffinity" (merge (dict "_podAffinity" .Values.affinity.podAntiAffinity) .) }}
{{- end }}
{{- end }}

{{/*
Patch topology spread constraints
*/}}
{{- define "fluentd-aggregator.patchTopologySpreadConstraints" -}}
{{- range $constraint := .Values.topologySpreadConstraints }}
{{- include "fluentd-aggregator.patchLabelSelector" (merge (dict "_target" $constraint) $) }}
{{- end }}
{{- end }}
