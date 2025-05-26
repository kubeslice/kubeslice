#IMAGE PULL SECRET ##
{{/*
Return the secret with imagePullSecrets credentials
*/}}
{{- define "imagePullSecrets.secretName" -}}
    {{- if .Values.global.nsmw_docker_existingImagePullSecret -}}
        {{- printf "%s" (tpl .Values.global.nsmw_docker_existingImagePullSecret $) -}}
    {{- else -}}
        {{- printf "kubeslice-image-pull-secret" -}}
    {{- end -}}
{{- end -}}

{{/*
Return true if a secret object should be created for imagePullSecrets
*/}}
{{- define "imagePullSecrets.createSecret" -}}
{{- if (not .Values.global.nsmw_docker_existingImagePullSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}
