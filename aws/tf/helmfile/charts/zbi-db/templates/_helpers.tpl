{{/*
Expand the name of the chart.
*/}}
{{- define "db.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "db.fullname" -}}
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
Create database connection string
*/}}
{{- define "db.ConnectionString" -}}
{{- $mongoSecretObj := (lookup "v1" "Secret" .Values.namespace "mongo-admin-zbi") | default dict }}
{{- $mongoSecretData := (get $mongoSecretObj "data") | default dict }}

{{- if .Values.tls.enabled}}
{{- (get $mongoSecretData "connectionString.standardSrv") | b64dec }}
{{- else }}
{{- (get $mongoSecretData "connectionString.standard") | b64dec }}
{{- end }}

{{- end }}

{{- define "db.SecretName" -}}
{{-  "mongo-admin-zbi" }}
{{- end }}

{{- define "db.ConnectionStringName" -}}
{{- if .Values.tls.enabled}}
{{- "connectionString.standardSrv" }}
{{- else }}
{{- "connectionString.standard" }}
{{- end }}
{{- end }}
