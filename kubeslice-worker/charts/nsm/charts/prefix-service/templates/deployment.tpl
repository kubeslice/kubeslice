apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Chart.Name }}
spec:
  selector:
    matchLabels:
      app:  {{ .Chart.Name }}
  template:
    metadata:
      labels:
        app: {{ .Chart.Name }}
    spec:
      serviceAccountName: {{ .Values.serviceAccount.name }}
      imagePullSecrets:
        - name: avesha-nexus
      containers:
        - name: {{ .Chart.Name }}
          image: {{ .Values.registry }}/{{ .Values.org }}/{{ .Chart.Name }}:{{ .Values.tag }}
          imagePullPolicy: {{ .Values.pullPolicy }}
          env:
          - name: NSM_NAMESPACE
            value: {{ .Release.Namespace }}
      tolerations:
        - key: avesha/node-type
          operator: Equal
          value: gateway
          effect: NoSchedule
        - key: avesha/node-type
          operator: Equal
          value: gateway
          effect: NoExecute
