{{/*
Expand the name of the chart.
*/}}
{{- define "gpt-researcher.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gpt-researcher.fullname" -}}
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
{{- define "gpt-researcher.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "gpt-researcher.labels" -}}
helm.sh/chart: {{ include "gpt-researcher.chart" . }}
{{ include "gpt-researcher.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "gpt-researcher.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gpt-researcher.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Get the enviroment variables
*/}}
{{- define "gpt-researcher.envs" -}}
- name: FAST_LLM
  value: {{ .Values.llm.fastLlm | quote }}
- name: SMART_LLM
  value: {{ .Values.llm.smartLlm | quote }}
- name: STRATEGIC_LLM
  value: {{ .Values.llm.strategicLlm | quote }}
- name: EMBEDDING
  value: {{ .Values.llm.embedding | quote }}
- name: FAST_TOKEN_LIMIT
  value: {{ .Values.llm.fastTokenLimit | quote }}
- name: SMART_TOKEN_LIMIT
  value: {{ .Values.llm.smartTokenLimit | quote }}
- name: SUMMARY_TOKEN_LIMIT
  value: {{ .Values.llm.summaryTokenLimit | quote }}
- name: TEMPERATURE
  value: {{ .Values.llm.temperature | quote }}
{{- if eq .Values.llm.provider "openai" }}
- name: OPENAI_BASE_URL
  value: {{ .Values.llm.baseUrl | quote }}
{{- else if eq .Values.llm.provider "ollama"}}
- name: OPENAI_API_BASE
  value: {{ printf "%s/v1" .Values.llm.baseUrl | quote }}
- name: OLLAMA_BASE_URL
  value: {{ .Values.llm.baseUrl | quote }}
{{- end }}
- name: RETRIEVER
  value: {{ .Values.retriever.provider | quote }}
{{- if eq .Values.retriever.provider "google" }}
- name: GOOGLE_CX_KEY
  value: {{ .Values.retriever.google.cxKey | quote }}
{{- end }}
- name: USER_AGENT
  value: {{ .Values.app.userAgent | quote }}
- name: BROWSE_CHUNK_MAX_LENGTH
  value: {{ .Values.app.browseChunkMaxLength | quote }}
- name: SIMILARITY_THRESHOLD
  value: {{ .Values.app.similarityThreshold | quote }}
- name: MAX_SEARCH_RESULTS_PER_QUERY
  value: {{ .Values.app.maxSearchResultsPerQuery | quote }}
- name: MEMORY_BACKEND
  value: {{ .Values.app.memoryBackend | quote }}
- name: TOTAL_WORDS
  value: {{ .Values.app.totalWords | quote }}
- name: REPORT_FORMAT
  value: {{ .Values.app.reportFormat | quote }}
- name: MAX_ITERATIONS
  value: {{ .Values.app.maxIterations | quote }}
- name: AGENT_ROLE
  value: {{ .Values.app.agentRole | quote }}
- name: SCRAPER
  value: {{ .Values.app.scraper | quote }}
- name: MAX_SUBTOPICS
  value: {{ .Values.app.maxSubtopics | quote }}
{{- end -}}
