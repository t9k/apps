{{/*
Expand the name of the chart.
*/}}
{{- define "vllm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "vllm.fullname" -}}
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
{{- define "vllm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "vllm.labels" -}}
helm.sh/chart: {{ include "vllm.chart" . }}
{{ include "vllm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "vllm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "vllm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "vllm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "vllm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the options of datacube
*/}}
{{- define "vllm.options" -}}
{{- if eq .Values.datacube.source "huggingface" }}
- name: repo
  value: {{ .Values.datacube.huggingface.id | quote }}
{{- if .Values.datacube.huggingface.files }}
- name: files
  value: {{ .Values.datacube.huggingface.files | quote }}
{{- end }}
{{- if .Values.datacube.huggingface.existingSecret }}
- name: token
  valueFrom:
    secretKeyRef:
      name: {{ .Values.datacube.huggingface.existingSecret | quote }}
      key: token
{{- end }}
{{- else if eq .Values.datacube.source "git" }}
- name: url
  value: {{ .Values.datacube.git.url | quote }}
{{- if .Values.datacube.git.ref }}
- name: ref
  value: {{ .Values.datacube.git.ref | quote }}
{{- end }}
{{- if .Values.datacube.git.existingSecret }}
- name: token
  valueFrom:
    secretKeyRef:
      name: {{ .Values.datacube.git.existingSecret | quote }}
      key: token
{{- end }}
{{- else if eq .Values.datacube.source "s3" }}
- name: s3-uri
  value: {{ .Values.datacube.s3.url | quote }}
{{- if .Values.datacube.s3.existingSecret }}
- name: s3-endpoint
  valueFrom:
    secretKeyRef:
      name: {{ .Values.datacube.s3.existingSecret | quote }}
      key: endpoint
- name: s3-access-key-id
  valueFrom:
    secretKeyRef:
      name: {{ .Values.datacube.s3.existingSecret | quote }}
      key: accessKeyID
- name: s3-secret-access-key
  valueFrom:
    secretKeyRef:
      name: {{ .Values.datacube.s3.existingSecret | quote }}
      key: secretAccessKey
{{- end }}
{{- end }}
{{- end }}
