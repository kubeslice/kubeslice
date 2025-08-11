#!/bin/bash
# kind-multicluster.sh: Create two kind clusters for Kubeslice Bookinfo Istio/mTLS example

set -e

# Cluster names
declare -a CLUSTERS=(controller worker1 worker2)

# Create clusters
for CLUSTER in "${CLUSTERS[@]}"; do
  kind create cluster --name "$CLUSTER" --wait 120s
  kubectl config use-context "kind-$CLUSTER"
  kubectl cluster-info
  echo "Created $CLUSTER cluster."
done

echo "\nAll clusters created. Use 'kubectl config get-contexts' to view."
