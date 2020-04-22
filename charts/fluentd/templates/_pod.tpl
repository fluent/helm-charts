{{- define "fluentd.pod" -}}
{{- $defaultTag := printf "%s-debian-%s" (.Chart.AppVersion) (.Values.output.type) -}}
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
containers:
  - name: {{ .Chart.Name }}
    securityContext:
      {{- toYaml .Values.securityContext | nindent 6 }}
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default $defaultTag }}"
    imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if and (.Values.output.plugins.enabled) (gt (len .Values.output.plugins.pluginsList) 0) }}
    command: ["/bin/sh", "-c", "/fluentd/etc/config.d/install-plugins.sh"]
  {{- end }}
  {{- if .Values.env }}
    env:
    {{- toYaml .Values.env | nindent 6 }}
  {{- end }}
  {{- if .Values.envFrom }}
    envFrom:
    {{- toYaml .Values.envFrom | nindent 6 }}
  {{- end }}
    ports:
{{- range $port := .Values.service.ports }}
      - name: {{ $port.name }}
        containerPort: {{ $port.containerPort }}
        protocol: {{ $port.protocol }}
{{- end }}
      - name: metrics
        containerPort: 24231
        protocol: TCP
    livenessProbe:
      httpGet:
        path: /metrics
        port: metrics
    readinessProbe:
      httpGet:
        path: /metrics
        port: metrics
    resources:
      {{- toYaml .Values.resources | nindent 8 }}
    volumeMounts:
      - name: varlog
        mountPath: /var/log
      - name: varlibdockercontainers
        mountPath: /var/lib/docker/containers
        readOnly: true
      {{- if eq .Values.output.type "custome" }}  
      - name: custome-config-volume-{{ template "fluentd.fullname" . }}
        mountPath: /fluentd/etc/
      {{- end }}
      {{- if or (.Values.output.extraConfigs) ( and (.Values.output.plugins.enabled) (gt (len .Values.output.plugins.pluginsList) 0)) -}}  
      - name: custome-config-volume-{{ template "fluentd.fullname" . }}
        mountPath: /fluentd/etc/config.d/
      {{- end }}        
    {{- if .Values.extraVolumeMounts }}
      {{- toYaml .Values.extraVolumeMounts | nindent 6 }}
    {{- end }}
volumes:  
  - name: varlog
    hostPath:
      path: /var/log
  - name: varlibdockercontainers
    hostPath:
      path: /var/lib/docker/containers
  {{- if eq .Values.output.type "custome" }}
  - name: custome-config-volume-{{ template "fluentd.fullname" . }}
    configMap:
      name: {{ template "fluentd.fullname" . }}-customeconfig
      defaultMode: 0777
  {{- end }}
  {{- if or (.Values.output.extraConfigs) ( and (.Values.output.plugins.enabled) (gt (len .Values.output.plugins.pluginsList) 0)) -}}
  - name: additional-config-volume-{{ template "fluentd.fullname" . }}
    configMap:
      name: {{ template "fluentd.fullname" . }}-additionalconfigs
      defaultMode: 0777
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
