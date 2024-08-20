{{/*
Base template for building docker image reference
*/}}
{{- define "app.baseImage" }}
{{- $registry := .global.registry | default .service.registry | default "" -}}
{{- $repository := .service.repository | default "" -}}
{{- $ref := ternary (printf ":%s" (.service.tag | default .defaultVersion | toString)) (printf "@%s" .service.digest) (empty .service.digest) -}}
{{- if and $registry $repository -}}
  {{- printf "%s/%s%s" $registry $repository $ref -}}
{{- else -}}
  {{- printf "%s%s%s" $registry $repository $ref -}}
{{- end -}}
{{- end -}}

{{/*
Docker image name for service-manager web
*/}}
{{- define "serviceManagerWeb.image" -}}
{{- $dict := dict "service" .Values.web.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "app.baseImage" $dict -}}
{{- end -}}

{{/*
Docker image name for pep-proxy
*/}}
{{- define "pepProxy.image" -}}
{{- $dict := dict "service" .Values.authorization.pepProxy.image "global" .Values.global.image "defaultVersion" .Chart.AppVersion -}}
{{- include "app.baseImage" $dict -}}
{{- end -}}
