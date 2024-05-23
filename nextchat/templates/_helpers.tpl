{{/*
Expand the name of the chart.
*/}}
{{- define "nextchat.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nextchat.fullname" -}}
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
{{- define "nextchat.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nextchat.labels" -}}
helm.sh/chart: {{ include "nextchat.chart" . }}
{{ include "nextchat.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nextchat.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nextchat.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nextchat.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "nextchat.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the enviroment variables
*/}}
{{- define "nextchat.envs" -}}
{{- if eq .Values.llm.provider "openai" }}
- name: BASE_URL
  value: {{ .Values.llm.openai.base_url | quote }}
{{- else if eq .Values.llm.provider "azure"}}
- name: AZURE_URL
  value: {{ .Values.llm.azure.url | quote }}
- name: AZURE_API_VERSION
  value: {{ .Values.llm.azure.api_version | quote }}
{{- else if eq .Values.llm.provider "anthropic"}}
- name: ANTHROPIC_URL
  value: {{ .Values.llm.azure.url | quote }}
- name: ANTHROPIC_API_VERSION
  value: {{ .Values.llm.azure.api_version | quote }}
{{- else if eq .Values.llm.provider "google" }}
- name: GOOGLE_URL
  value: {{ .Values.llm.google.url | quote }}
{{- end }}
{{- end }}
