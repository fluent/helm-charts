{{- define "fluent-bit.pod" -}}
{{- $l1xGHInit := or .Values.l1x.github.config.enabled .Values.l1x.github.symbols.enabled -}}
serviceAccountName: {{ include "fluent-bit.serviceAccountName" . }}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if .Values.priorityClassName }}
priorityClassName: {{ .Values.priorityClassName }}
{{- end }}
{{- with .Values.podSecurityContext }}
securityContext:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.terminationGracePeriodSeconds }}
terminationGracePeriodSeconds: {{ . }}
{{- end }}
hostNetwork: {{ .Values.hostNetwork }}
dnsPolicy: {{ .Values.dnsPolicy }}
{{- with .Values.dnsConfig }}
dnsConfig:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.hostAliases }}
hostAliases:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if and .Values.l1x.enabled $l1xGHInit }}
initContainers:
  - name: l1x-git-config
    image: ghcr.io/log-10x/github-config-fetcher:0.1.0
    args:
      {{- if .Values.l1x.github.config.enabled }}
      - "--config-repo"
      - "https://{{ .Values.l1x.github.config.token }}@github.com/{{ .Values.l1x.github.config.repo }}.git"
      {{- if .Values.l1x.github.config.branch }}
      - "--config-branch"
      - "{{ .Values.l1x.github.config.branch }}"
      {{- end }}
      {{- end }}
      {{- if .Values.l1x.github.symbols.enabled }}
      - "--symbols-repo"
      - "https://{{ .Values.l1x.github.symbols.token }}@github.com/{{ .Values.l1x.github.symbols.repo }}.git"
      {{- if .Values.l1x.github.symbols.branch }}
      - "--symbols-branch"
      - "{{ .Values.l1x.github.symbols.branch }}"
      {{- end }}
      {{- if .Values.l1x.github.symbols.path }}
      - "--symbols-path"
      - "{{ .Values.l1x.github.symbols.path }}"
      {{- end }}
      {{- end }}
    volumeMounts:
      - name: shared-git-volume
        mountPath: /data
{{- with .Values.initContainers }}
initContainers:
{{- if kindIs "string" . }}
  {{- tpl . $ | nindent 2 }}
{{- else }}
  {{-  toYaml . | nindent 2 }}
{{- end -}}
{{- end }}
{{- else }}
{{- with .Values.initContainers }}
initContainers:
{{- if kindIs "string" . }}
  {{- tpl . $ | nindent 2 }}
{{- else }}
  {{-  toYaml . | nindent 2 }}
{{- end -}}
{{- end }}
{{- end }}
containers:
  - name: {{ .Chart.Name }}
  {{- with .Values.securityContext }}
    securityContext:
      {{- toYaml . | nindent 6 }}
  {{- end }}
    image: {{ include "fluent-bit.image" (merge .Values.image (dict "tag" (default .Chart.AppVersion .Values.image.tag)) (dict "variant" (default "jit" .Values.variant))) | quote }}
    imagePullPolicy: {{ .Values.image.pullPolicy }}
    env:
    {{- if .Values.l1x.enabled }}
      - name: L1X_LICENSE
        value: "{{ .Values.l1x.license }}"
      - name: FLUENT_BIT_CONF_FILE
    {{- if eq $.Values.l1x.kind "optimize" }}
        value: "/fluent-bit/etc/conf/l1x-main-optimize.conf"
    {{- else if eq $.Values.l1x.kind "regulate" }}
        value: "/fluent-bit/etc/conf/l1x-main-regulate.conf"
    {{- else if eq $.Values.l1x.kind "report" }}
        value: "/fluent-bit/etc/conf/l1x-main-report.conf"
    {{- end }}
    {{- if .Values.l1x.reportedName }}
	  - name: L1X_RUNTIME_NAME
	    value: "{{ .Values.l1x.reportedName }}"
    {{- end }}
    {{- if .Values.l1x.github.config.enabled }}
      - name: L1X_CONFIG_PATH
        value: "/etc/l1x/git/config"
    {{- else if .Values.l1x.github.symbols.enabled }}
      - name: L1X_DATA
        value: "/etc/l1x/git/config/data"
    {{- end }}
    {{- else }}
      - name: FLUENT_BIT_CONF_FILE
        value: "/fluent-bit/etc/conf/fluent-bit.conf"
    {{- end }}
    {{- with .Values.env }}
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- range $item := .Values.envWithTpl }}
      - name: {{ $item.name }}
        value: {{ tpl $item.value $ | quote }}
    {{- end }}
  {{- if .Values.envFrom }}
    envFrom:
      {{- toYaml .Values.envFrom | nindent 6 }}
  {{- end }}
  {{- with .Values.command }}
    command:
      {{- toYaml . | nindent 6 }}
  {{- end }}
  {{- if or .Values.args .Values.hotReload.enabled }}
    args:
      {{- toYaml .Values.args | nindent 6 }}
    {{- if .Values.hotReload.enabled }}
      - --enable-hot-reload
    {{- end }}
  {{- end}}
    ports:
      - name: http
        containerPort: {{ .Values.metricsPort }}
        protocol: TCP
    {{- if .Values.extraPorts }}
      {{- range .Values.extraPorts }}
      - name: {{ .name }}
        containerPort: {{ .containerPort }}
        protocol: {{ .protocol }}
      {{- end }}
    {{- end }}
  {{- with .Values.lifecycle }}
    lifecycle:
      {{- toYaml . | nindent 6 }}
  {{- end }}
    livenessProbe:
      {{- toYaml .Values.livenessProbe | nindent 6 }}
    readinessProbe:
      {{- toYaml .Values.readinessProbe | nindent 6 }}
  {{- with .Values.resources }}
    resources:
      {{- toYaml . | nindent 6 }}
  {{- end }}
    volumeMounts:
      - name: config
        mountPath: /fluent-bit/etc/conf
    {{- if and .Values.l1x.enabled $l1xGHInit }}
      - name: shared-git-volume
        mountPath: /etc/l1x/git
    {{- end }}
    {{- if or .Values.luaScripts .Values.hotReload.enabled }}
      - name: luascripts
        mountPath: /fluent-bit/scripts
    {{- end }}
    {{- if eq .Values.kind "DaemonSet" }}
      {{- toYaml .Values.daemonSetVolumeMounts | nindent 6 }}
    {{- end }}
    {{- if .Values.extraVolumeMounts }}
      {{- toYaml .Values.extraVolumeMounts | nindent 6 }}
    {{- end }}
{{- if .Values.hotReload.enabled }}
  - name: reloader
    image: {{ include "fluent-bit.image" .Values.hotReload.image }}
    args:
      - {{ printf "-webhook-url=http://localhost:%s/api/v2/reload" (toString .Values.metricsPort) }}
      - -volume-dir=/watch/config
      - -volume-dir=/watch/scripts
    volumeMounts:
      - name: config
        mountPath: /watch/config
      - name: luascripts
        mountPath: /watch/scripts
    {{- with .Values.hotReload.resources }}
    resources:
      {{- toYaml . | nindent 12 }}
    {{- end }}
{{- end }}
{{- if .Values.extraContainers }}
  {{- if kindIs "string" .Values.extraContainers }}
    {{- tpl .Values.extraContainers $ | nindent 2 }}
  {{- else }}
    {{-  toYaml .Values.extraContainers | nindent 2 }}
  {{- end -}}
{{- end }}
volumes:
  - name: config
    configMap:
      name: {{ default (include "fluent-bit.fullname" .) .Values.existingConfigMap }}
{{- if and .Values.l1x.enabled $l1xGHInit }}
  - name: shared-git-volume
    emptyDir: {}
{{- end }}
{{- if or .Values.luaScripts .Values.hotReload.enabled }}
  - name: luascripts
    configMap:
      name: {{ include "fluent-bit.fullname" . }}-luascripts
{{- end }}
{{- if eq .Values.kind "DaemonSet" }}
  {{- toYaml .Values.daemonSetVolumes | nindent 2 }}
{{- end }}
{{- if .Values.extraVolumes }}
  {{- toYaml .Values.extraVolumes | nindent 2 }}
{{- end }}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}
