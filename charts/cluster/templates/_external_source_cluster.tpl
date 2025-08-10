{{- define "cluster.externalSourceCluster" -}}
{{- $name := first . -}}
{{- $config := index . 1 -}}
- name: {{ first . }}
  connectionParameters:
    host: {{ $config.host | quote }}
    port: {{ $config.port | quote }}
    user: {{ $config.username | quote }}
    {{- with $config.database }}
    dbname: {{ . | quote }}
    {{- end }}
    sslmode: {{ $config.sslMode | quote }}
  {{- if and $config.passwordSecret (or $config.passwordSecret.create $config.passwordSecret.name) }}
  password:
    {{- if $config.passwordSecret.create }}
    name: {{ default (printf "%s-import-password" (include "cluster.fullname" (index . 2))) $config.passwordSecret.name }}
    {{- else }}
    name: {{ $config.passwordSecret.name }}
    {{- end }}
    key: {{ $config.passwordSecret.key | default "password" }}
  {{- end }}
  {{- if and $config.sslKeySecret $config.sslKeySecret.name }}
  sslKey:
    name: {{ $config.sslKeySecret.name }}
    key: {{ $config.sslKeySecret.key }}
  {{- end }}
  {{- if and $config.sslCertSecret $config.sslCertSecret.name }}
  sslCert:
    name: {{ $config.sslCertSecret.name }}
    key: {{ $config.sslCertSecret.key }}
  {{- end }}
  {{- if and $config.sslRootCertSecret $config.sslRootCertSecret.name }}
  sslRootCert:
    name: {{ $config.sslRootCertSecret.name }}
    key: {{ $config.sslRootCertSecret.key }}
  {{- end }}
{{- end }}
