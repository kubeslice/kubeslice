#!/bin/bash
# install-kubeslice.sh: Install Kubeslice controller/worker on a given cluster

set -e

CLUSTER_NAME=${1:-controller}
ROLE=${2:-controller}

kubectl config use-context kind-$CLUSTER_NAME

if [ "$ROLE" = "controller" ]; then
  helm repo add kubeslice https://kubeslice.github.io/kubeslice/
  helm repo update
  helm install kubeslice-controller kubeslice/kubeslice-controller -n kubeslice-system --create-namespace
else
  helm repo add kubeslice https://kubeslice.github.io/kubeslice/
  helm repo update
  helm install kubeslice-worker kubeslice/kubeslice-worker -n kubeslice-system --create-namespace \
    --set controller.clusterName=controller
fi

echo "Kubeslice $ROLE installed on $CLUSTER_NAME."
