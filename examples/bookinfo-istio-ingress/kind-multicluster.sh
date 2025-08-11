#!/bin/bash
# kind-multicluster.sh: Create three kind clusters for Bookinfo Istio Ingress example

set -e

declare -a CLUSTERS=(controller worker1 worker2)

for CLUSTER in "${CLUSTERS[@]}"; do
  kind create cluster --name "$CLUSTER" --wait 120s
  kubectl config use-context "kind-$CLUSTER"
  kubectl cluster-info
  echo "Created $CLUSTER cluster."
done

echo "\nAll clusters created. Use 'kubectl config get-contexts' to view."
