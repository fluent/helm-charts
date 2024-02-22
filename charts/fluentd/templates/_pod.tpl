{{- define "fluentd.pod" -}}
{{- $defaultTag := printf "%s-debian-%s-1.0" (.Chart.AppVersion) (.Values.variant) -}}
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
{{- with .Values.initContainers }}
initContainers:
  {{- toYaml . | nindent 2 }}
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
