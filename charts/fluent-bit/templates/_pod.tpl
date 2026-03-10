{{- define "fluent-bit.pod" -}}
{{- $tenxGitInit := and .Values.tenx.enabled (or .Values.tenx.config.git.enabled .Values.tenx.symbols.git.enabled) -}}
{{- $tenxVolumeInit := and .Values.tenx.enabled (or .Values.tenx.config.volume.enabled .Values.tenx.symbols.volume.enabled) -}}
{{- $tenxConfigEnabled := or $tenxGitInit $tenxVolumeInit -}}
{{- if ne .Values.serviceAccount.automountServiceAccountToken nil }}
automountServiceAccountToken: {{ .Values.serviceAccount.automountServiceAccountToken }}
{{- end }}
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
{{- if or $tenxGitInit .Values.initContainers }}
initContainers:
{{- if $tenxGitInit }}
  - name: tenx-git-config
    image: "{{ $.Values.tenx.configFetcherImage.repository }}:{{ $.Values.tenx.configFetcherImage.tag }}"
    imagePullPolicy: {{ $.Values.tenx.configFetcherImage.pullPolicy }}
    env:
      - name: GIT_TOKEN
        valueFrom:
          secretKeyRef:
            name: {{ include "fluent-bit.fullname" . }}-tenx-git-token
            key: token
    args:
      {{- if .Values.tenx.config.git.enabled }}
      - "--config-repo"
      - {{ .Values.tenx.config.git.url | quote }}
      {{- if .Values.tenx.config.git.branch }}
      - "--config-branch"
      - {{ .Values.tenx.config.git.branch | quote }}
      {{- end }}
      {{- end }}
      {{- if .Values.tenx.symbols.git.enabled }}
      - "--symbols-repo"
      - {{ .Values.tenx.symbols.git.url | quote }}
      {{- if .Values.tenx.symbols.git.branch }}
      - "--symbols-branch"
      - {{ .Values.tenx.symbols.git.branch | quote }}
      {{- end }}
      {{- if .Values.tenx.symbols.git.path }}
      - "--symbols-path"
      - {{ .Values.tenx.symbols.git.path | quote }}
      {{- end }}
      {{- end }}
    volumeMounts:
      - name: tenx-git
        mountPath: /data
{{- end }}
{{- with .Values.initContainers }}
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
    image: {{ include "fluent-bit.image" (merge .Values.image (dict "tag" (default .Chart.AppVersion .Values.image.tag)) (dict "variant" (default "jit" .Values.tenx.variant))) | quote }}
    imagePullPolicy: {{ .Values.image.pullPolicy }}
    env:
    {{- if .Values.tenx.enabled }}
      - name: TENX_API_KEY
    {{- if and .Values.tenx.apiKey (ne .Values.tenx.apiKey "NO-API-KEY") }}
        valueFrom:
          secretKeyRef:
            name: {{ include "fluent-bit.fullname" . }}-tenx-api-key
            key: api-key
    {{- else }}
        value: {{ .Values.tenx.apiKey | quote }}
    {{- end }}
      - name: FLUENT_BIT_CONF_FILE
    {{- if eq $.Values.tenx.kind "optimize" }}
        value: "/fluent-bit/etc/conf/tenx-main-optimize.conf"
    {{- else if eq $.Values.tenx.kind "regulate" }}
        value: "/fluent-bit/etc/conf/tenx-main-regulate.conf"
    {{- else if eq $.Values.tenx.kind "report" }}
        value: "/fluent-bit/etc/conf/tenx-main-report.conf"
    {{- end }}
    {{- if .Values.tenx.runtimeName }}
      - name: TENX_RUNTIME_NAME
        value: {{ .Values.tenx.runtimeName | quote }}
    {{- end }}
    {{- if .Values.tenx.config.git.enabled }}
      - name: TENX_CONFIG
        value: "/etc/tenx/git/config"
    {{- else if .Values.tenx.config.volume.enabled }}
      - name: TENX_CONFIG
        value: "/etc/tenx/config"
    {{- end }}
    {{- if .Values.tenx.symbols.git.enabled }}
      - name: TENX_SYMBOLS_PATH
        value: "/etc/tenx/git/config/data/shared/symbols"
    {{- else if .Values.tenx.symbols.volume.enabled }}
      - name: TENX_SYMBOLS_PATH
        value: "/etc/tenx/symbols"
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
    {{- if $tenxGitInit }}
      - name: tenx-git
        mountPath: /etc/tenx/git
    {{- end }}
    {{- if and .Values.tenx.enabled .Values.tenx.config.volume.enabled }}
      - name: tenx-config-volume
        mountPath: /etc/tenx/config
    {{- end }}
    {{- if and .Values.tenx.enabled .Values.tenx.symbols.volume.enabled }}
      - name: tenx-symbols-volume
        mountPath: /etc/tenx/symbols
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
  {{- with .Values.hotReload.securityContext }}
    securityContext:
      {{- toYaml . | nindent 6 }}
  {{- end }}
    image: {{ include "fluent-bit.image" .Values.hotReload.image }}
    args:
      - {{ printf "-webhook-url=http://localhost:%s/api/v2/reload" (toString .Values.metricsPort) }}
      - -volume-dir=/watch/config
      - -volume-dir=/watch/scripts
      {{- range $idx, $val := .Values.hotReload.extraWatchVolumes }}
      - {{ printf "-volume-dir=/watch/extra-%d" (int $idx) }}
      {{- end }}
    volumeMounts:
      - name: config
        mountPath: /watch/config
      - name: luascripts
        mountPath: /watch/scripts
      {{- range $idx, $val := .Values.hotReload.extraWatchVolumes }}
      - name: {{ $val }}
        mountPath: {{ printf "/watch/extra-%d" (int $idx) }}
      {{- end }}
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
{{- if $tenxGitInit }}
  - name: tenx-git
    emptyDir: {}
{{- end }}
{{- if and .Values.tenx.enabled .Values.tenx.config.volume.enabled }}
  - name: tenx-config-volume
    persistentVolumeClaim:
      claimName: {{ .Values.tenx.config.volume.claimName }}
{{- end }}
{{- if and .Values.tenx.enabled .Values.tenx.symbols.volume.enabled }}
  - name: tenx-symbols-volume
    persistentVolumeClaim:
      claimName: {{ .Values.tenx.symbols.volume.claimName }}
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
