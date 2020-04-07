{{- define "fluentd.pod" -}}
{{- $defaultTag := printf "%s-debian-elasticsearch" (.Chart.AppVersion) -}}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 8 }}
{{- end }}
{{- if .Values.priorityClassName }}
priorityClassName: {{ .Values.priorityClassName }}
{{- end }}
serviceAccountName: {{ include "fluentd.serviceAccountName" . }}
securityContext:
  {{- toYaml .Values.podSecurityContext | nindent 8 }}
containers:
  - name: {{ .Chart.Name }}
    securityContext:
      {{- toYaml .Values.securityContext | nindent 12 }}
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default $defaultTag }}"
    imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- if .Values.env }}
    env:
    {{- toYaml .Values.env | nindent 10 }}
  {{- end }}
  {{- if .Values.envFrom }}
    envFrom:
    {{- toYaml .Values.envFrom | nindent 10 }}
  {{- end }}
    ports:
      # - name: forward
      #   containerPort: 24224
      #   protocol: TCP
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
      {{- toYaml .Values.resources | nindent 12 }}
    volumeMounts:
      - name: varlog
        mountPath: /var/log
      - name: varlibdockercontainers
        mountPath: /var/lib/docker/containers
        readOnly: true
    {{- if .Values.extraVolumeMounts }}
      {{- toYaml .Values.extraVolumeMounts | nindent 12 }}
    {{- end }}
volumes:
  - name: varlog
    hostPath:
      path: /var/log
  - name: varlibdockercontainers
    hostPath:
      path: /var/lib/docker/containers
{{- if .Values.extraVolumes }}
  {{- toYaml .Values.extraVolumes | nindent 8 }}
{{- end }}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 8 }}
{{- end }}
{{- with .Values.affinity }}
affinity:
  {{- toYaml . | nindent 8 }}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 8 }}
{{- end }}

{{- end -}}
