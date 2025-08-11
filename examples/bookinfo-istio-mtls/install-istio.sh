#!/bin/bash
# install-istio.sh: Install Istio with mTLS enabled on a given cluster

set -e

CLUSTER_NAME=${1:-controller}
ISTIO_VERSION=1.22.0
PROFILE=demo

# Download Istio if not present
if [ ! -d "istio-$ISTIO_VERSION" ]; then
  curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -
fi

export PATH=$PWD/istio-$ISTIO_VERSION/bin:$PATH

# Switch context
kubectl config use-context kind-$CLUSTER_NAME

# Install Istio
istioctl install --set profile=$PROFILE -y

# Enable strict mTLS
kubectl apply -f - <<EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: istio-system
spec:
  mtls:
    mode: STRICT
EOF

echo "Istio with mTLS enabled installed on $CLUSTER_NAME."
