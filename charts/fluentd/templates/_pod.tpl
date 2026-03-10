{{- define "fluentd.pod" -}}
{{- $defaultTag := printf "%s-%s" (.Chart.AppVersion) (.Values.tenx.variant) -}}
{{- $tenxGitInit := and .Values.tenx.enabled (or .Values.tenx.config.git.enabled .Values.tenx.symbols.git.enabled) -}}
{{- $tenxVolumeInit := and .Values.tenx.enabled (or .Values.tenx.config.volume.enabled .Values.tenx.symbols.volume.enabled) -}}
{{- $tenxConfigEnabled := or $tenxGitInit $tenxVolumeInit -}}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if .Values.priorityClassName }}
priorityClassName: {{ .Values.priorityClassName }}
{{- end }}
serviceAccountName: {{ include "fluentd.serviceAccountName" . }}
securityContext:
  {{- toYaml .Values.podSecurityContext | nindent 2 }}
{{- with .Values.terminationGracePeriodSeconds }}
terminationGracePeriodSeconds: {{ . }}
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
            name: {{ include "fluentd.fullname" . }}-tenx-git-token
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
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}
containers:
  - name: {{ .Chart.Name }}
    securityContext:
      {{- toYaml .Values.securityContext | nindent 6 }}
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default $defaultTag }}"
    imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.plugins }}
    command:
    - "/bin/sh"
    - "-c"
    - |
      {{- range $plugin := .Values.plugins }}
        {{- print "fluent-gem install " $plugin | nindent 6 }}
      {{- end }}
      exec /fluentd/entrypoint.sh
  {{- end }}
    env:
    - name: FLUENTD_CONF
      value: "../../../etc/fluent/fluent.conf"
    {{- if .Values.tenx.enabled }}
    - name: TENX_API_KEY
    {{- if and .Values.tenx.apiKey (ne .Values.tenx.apiKey "NO-API-KEY") }}
      valueFrom:
        secretKeyRef:
          name: {{ include "fluentd.fullname" . }}-tenx-api-key
          key: api-key
    {{- else }}
      value: {{ .Values.tenx.apiKey | quote }}
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
    {{- end }}
    {{- if .Values.env }}
    {{- toYaml .Values.env | nindent 4 }}
    {{- end }}
  {{- if .Values.envFrom }}
    envFrom:
    {{- toYaml .Values.envFrom | nindent 4 }}
  {{- end }}
    ports:
    - name: metrics
      containerPort: 24231
      protocol: TCP
    {{- range $port := .Values.service.ports }}
    - name: {{ $port.name }}
      containerPort: {{ $port.containerPort }}
      protocol: {{ $port.protocol }}
    {{- end }}
    {{- with .Values.lifecycle }}
    lifecycle:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    livenessProbe:
      {{- toYaml .Values.livenessProbe | nindent 6 }}
    readinessProbe:
      {{- toYaml .Values.readinessProbe | nindent 6 }}
    resources:
      {{- toYaml .Values.resources | nindent 8 }}
    volumeMounts:
    - name: etcfluentd-main
      mountPath: /etc/fluent
    - name: etcfluentd-config
      mountPath: /etc/fluent/config.d/
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
    {{- if .Values.mountVarLogDirectory }}
    - name: varlog
      mountPath: /var/log
    {{- end }}
    {{- if .Values.mountDockerContainersDirectory }}
    - name: varlibdockercontainers
      mountPath: /var/lib/docker/containers
      readOnly: true
    {{- end }}
    {{- if .Values.volumeMounts -}}
    {{- toYaml .Values.volumeMounts | nindent 4 }}
    {{- end -}}
    {{- range $key := .Values.configMapConfigs }}
    {{- print "- name: " $key | nindent 4 }}
      {{- print "mountPath: /etc/fluent/" $key ".d"  | nindent 6 }}
    {{- end }}
    {{- if .Values.persistence.enabled }}
    - mountPath: /var/log/fluent
      name: {{ include "fluentd.fullname" . }}-buffer
    {{- end }}
volumes:
- name: etcfluentd-main
  configMap:
    name: {{ include "fluentd.mainConfigMapName" . }}
    defaultMode: 0777
- name: etcfluentd-config
  configMap:
    name: {{ include "fluentd.extraFilesConfigMapName" . }}
    defaultMode: 0777
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
{{- if .Values.mountVarLogDirectory }}
- name: varlog
  hostPath:
    path: /var/log
{{- end }}
{{- if .Values.mountDockerContainersDirectory }}
- name: varlibdockercontainers
  hostPath:
    path: /var/lib/docker/containers
{{- end }}
{{- if .Values.volumes -}}
{{- toYaml .Values.volumes | nindent 0 }}
{{- end -}}
{{- range $key := .Values.configMapConfigs }}
{{- print "- name: " $key | nindent 0 }}
  configMap:
    {{- print "name: " $key "-" ( include "fluentd.shortReleaseName" $ ) | nindent 4 }}
    defaultMode: 0777
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
