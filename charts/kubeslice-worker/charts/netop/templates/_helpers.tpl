{{/*
Expand the name of the chart.
*/}}
{{- define "netop.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "netop.fullname" -}}
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
{{- define "netop.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "netop.labels" -}}
helm.sh/chart: {{ include "netop.chart" . }}
{{ include "netop.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "netop.selectorLabels" -}}
app.kubernetes.io/name: {{ include "netop.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "netop.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "netop.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

#IMAGE PULL SECRET ##
{{/*
Return the secret with imagePullSecrets credentials
*/}}
{{- define "imagePullSecrets.secretName" -}}
    {{- if .Values.global.netop_docker_existingImagePullSecret -}}
        {{- printf "%s" (tpl .Values.global.netop_docker_existingImagePullSecret $) -}}
    {{- else -}}
        {{- printf "kubeslice-image-pull-secret" -}}
    {{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for imagePullSecrets
*/}}
{{- define "imagePullSecrets.createSecret" -}}
{{- if (not .Values.global.netop_docker_existingImagePullSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}
