{{/*
Expand the name of the chart.
*/}}
{{- define "search-with-lepton.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "search-with-lepton.fullname" -}}
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
{{- define "search-with-lepton.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "search-with-lepton.labels" -}}
helm.sh/chart: {{ include "search-with-lepton.chart" . }}
{{ include "search-with-lepton.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "search-with-lepton.selectorLabels" -}}
app.kubernetes.io/name: {{ include "search-with-lepton.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Get the enviroment variables
*/}}
{{- define "search-with-lepton.envs" -}}
- name: OPENAI_BASE_URL
  value: {{ .Values.llm.baseUrl | quote }}
- name: LLM_MODEL
  value: {{ .Values.llm.modelName | quote }}
- name: BACKEND
  value: {{ .Values.searchEngine.provider | quote }}
{{- if eq .Values.searchEngine.provider "GOOGLE" }}
- name: GOOGLE_SEARCH_CX
  value: {{ .Values.searchEngine.google.cxKey | quote }}
{{- end }}
{{- end -}}
