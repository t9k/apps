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
Create the name of the service account to use
*/}}
{{- define "gpt-researcher.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "gpt-researcher.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the enviroment variables
*/}}
{{- define "gpt-researcher.envs" -}}
{{- if eq .Values.llm.provider "openai" }}
- name: OPENAI_BASE_URL
  value: {{ .Values.llm.openai.base_url | quote }}
- name: FAST_LLM_MODEL
  value: {{ .Values.llm.openai.fast_model | quote }}
- name: FAST_TOKEN_LIMIT
  value: {{ .Values.llm.openai.fast_token_limit | quote }}
- name: SMART_LLM_MODEL
  value: {{ .Values.llm.openai.smart_model | quote }}
- name: SMART_TOKEN_LIMIT
  value: {{ .Values.llm.openai.smart_token_limit | quote }}
- name: BROWSE_CHUNK_MAX_LENGTH
  value: {{ .Values.llm.openai.browse_chunk_max_length | quote }}
- name: SUMMARY_TOKEN_LIMIT
  value: {{ .Values.llm.openai.summary_token_limit | quote }}
- name: TEMPERATURE
  value: {{ .Values.llm.openai.temperature | quote }}
{{- else if eq .Values.llm.provider "azureopenai"}}
- name: AZURE_OPENAI_ENDPOINT
  value: {{ .Values.llm.azureopenai.endpoint | quote }}
- name: AZURE_OPENAI_API_VERSION
  value: {{ .Values.llm.azureopenai.api_version | quote }}
- name: AZURE_EMBEDDING_MODEL
  value: {{ .Values.llm.azureopenai.embedding_model | quote }}
- name: FAST_LLM_MODEL
  value: {{ .Values.llm.azureopenai.fast_model | quote }}
- name: FAST_TOKEN_LIMIT
  value: {{ .Values.llm.azureopenai.fast_token_limit | quote }}
- name: SMART_LLM_MODEL
  value: {{ .Values.llm.azureopenai.smart_model | quote }}
- name: SMART_TOKEN_LIMIT
  value: {{ .Values.llm.azureopenai.smart_token_limit | quote }}
- name: BROWSE_CHUNK_MAX_LENGTH
  value: {{ .Values.llm.azureopenai.browse_chunk_max_length | quote }}
- name: SUMMARY_TOKEN_LIMIT
  value: {{ .Values.llm.azureopenai.summary_token_limit | quote }}
- name: TEMPERATURE
  value: {{ .Values.llm.azureopenai.temperature | quote }}
{{- else if eq .Values.llm.provider "google" }}
- name: FAST_LLM_MODEL
  value: {{ .Values.llm.gemini.fast_model | quote }}
- name: FAST_TOKEN_LIMIT
  value: {{ .Values.llm.gemini.fast_token_limit | quote }}
- name: SMART_LLM_MODEL
  value: {{ .Values.llm.gemini.smart_model | quote }}
- name: SMART_TOKEN_LIMIT
  value: {{ .Values.llm.gemini.smart_token_limit | quote }}
- name: BROWSE_CHUNK_MAX_LENGTH
  value: {{ .Values.llm.gemini.browse_chunk_max_length | quote }}
- name: SUMMARY_TOKEN_LIMIT
  value: {{ .Values.llm.gemini.summary_token_limit | quote }}
- name: TEMPERATURE
  value: {{ .Values.llm.gemini.temperature | quote }}
{{- end }}
- name: RETRIEVER
  value: {{ .Values.retriever.provider | quote }}
{{- if eq .Values.retriever.provider "google" }}
- name: GOOGLE_CX_KEY
  value: {{ .Values.retriever.google.cx_key | quote }}
{{- end }}
- name: USER_AGENT
  value: {{ .Values.app.user_agent | quote }}
- name: MAX_SEARCH_RESULTS_PER_QUERY
  value: {{ .Values.app.max_search_results_per_query | quote }}
- name: MEMORY_BACKEND
  value: {{ .Values.app.memory_backend | quote }}
- name: TOTAL_WORDS
  value: {{ .Values.app.total_words | quote }}
- name: REPORT_FORMAT
  value: {{ .Values.app.report_format | quote }}
- name: MAX_ITERATIONS
  value: {{ .Values.app.max_iterations | quote }}
- name: AGENT_ROLE
  value: {{ .Values.app.agent_role | quote }}
- name: SCRAPER
  value: {{ .Values.app.scraper | quote }}
- name: MAX_SUBTOPICS
  value: {{ .Values.app.user_agent | quote }}
{{- end -}}
