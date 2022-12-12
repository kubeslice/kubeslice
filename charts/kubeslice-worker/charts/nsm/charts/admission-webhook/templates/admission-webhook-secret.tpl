{{- $ca := genCA "admission-controller-ca" 3650 -}}
{{- $cn := printf "nsm-admission-webhook-svc" -}}
{{- $altName1 := printf "%s.%s.svc" $cn .Release.Namespace }}
{{- $altName2 := printf "%s.%s.svc.cluster.local" $cn .Release.Namespace }}
{{- $cert := genSignedCert $cn nil (list $altName1 $altName2) 3650 $ca -}}
apiVersion: v1
kind: Secret
metadata:
  name: nsm-admission-webhook-certs
  namespace: {{ .Release.Namespace }}
type: Opaque
data:
  tls.key: {{ $cert.Key | b64enc }}
  tls.crt: {{ $cert.Cert | b64enc }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nsm-admission-webhook
  namespace: {{ .Release.Namespace }}
  labels:
    app: nsm-admission-webhook
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nsm-admission-webhook
  template:
    metadata:
      labels:
        app: nsm-admission-webhook
    spec:
      imagePullSecrets:
        - name: avesha-nexus
      containers:
        - name: nsm-admission-webhook
          image: docker.io/aveshasystems/nsm-admission-webhook:1.0.2
          imagePullPolicy: {{ .Values.pullPolicy }}
          env:
            - name: INITCONTAINER_REPO
              value: "{{ .Values.initContainerRegistry }}"
            - name: INITCONTAINER_TAG
              value: "{{ .Values.initContainerTag }}"
            - name: DNS_SIDECAR_REPO
              value: "{{ .Values.dnsSidecarContainerRegistry }}"
            - name: DNS_SIDECAR_TAG
              value: "{{ .Values.dnsSidecarContainerTag }}"
            - name: NSM_NAMESPACE
              value: "{{ .Values.clientNamespace }}"
            - name: TRACER_ENABLED
              value: {{ .Values.global.JaegerTracing | default false | quote }}
            - name: JAEGER_AGENT_HOST
              value: jaeger.{{ .Release.Namespace }}
            - name: JAEGER_AGENT_PORT
              value: "6831"
            - name: CABUNDLE
              value: {{ $ca.Cert | b64enc }}
          volumeMounts:
            - name: webhook-certs
              mountPath: /etc/webhook/certs
              readOnly: true
          livenessProbe:
            httpGet:
              path: /liveness
              port: 5555
            initialDelaySeconds: 10
            periodSeconds: 10
            timeoutSeconds: 3
          readinessProbe:
            httpGet:
              path: /readiness
              port: 5555
            initialDelaySeconds: 10
            periodSeconds: 10
            timeoutSeconds: 3
      volumes:
        - name: webhook-certs
          secret:
            secretName: nsm-admission-webhook-certs
---
apiVersion: v1
kind: Service
metadata:
  name: nsm-admission-webhook-svc
  namespace: {{ .Release.Namespace }}
  labels:
    app: nsm-admission-webhook
spec:
  ports:
    - port: 443
      targetPort: 443
  selector:
    app: nsm-admission-webhook
---
apiVersion: admissionregistration.k8s.io/v1
kind: MutatingWebhookConfiguration
metadata:
  name: nsm-admission-webhook-cfg
  namespace: {{ .Release.Namespace }}
  labels:
    app: nsm-admission-webhook
webhooks:
  - name: admission-webhook.networkservicemesh.io
    sideEffects: None
    admissionReviewVersions: ["v1", "v1beta1"]
    failurePolicy: Ignore
    matchPolicy: Equivalent
    clientConfig:
      service:
        name: nsm-admission-webhook-svc
        namespace: {{ .Release.Namespace }}
        path: "/mutate"
      caBundle: {{ $ca.Cert | b64enc }}
    rules:
      - operations: ["CREATE"]
        apiGroups: ["apps", "extensions", ""]
        apiVersions: ["v1", "v1beta1"]
        resources: ["deployments", "services", "pods"]
