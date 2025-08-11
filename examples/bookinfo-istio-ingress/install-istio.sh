#!/bin/bash
# install-istio.sh: Install Istio on a given cluster

set -e

CLUSTER_NAME=${1:-controller}
ISTIO_VERSION=1.22.0
PROFILE=demo

if [ ! -d "istio-$ISTIO_VERSION" ]; then
  curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -
fi

export PATH=$PWD/istio-$ISTIO_VERSION/bin:$PATH

kubectl config use-context kind-$CLUSTER_NAME
istioctl install --set profile=$PROFILE -y

echo "Istio installed on $CLUSTER_NAME."
