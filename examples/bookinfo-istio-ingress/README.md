
# Bookinfo on Kubeslice with Istio Ingress Gateway (multi-cluster)

This example uses 3 clusters (controller, worker1, worker2) to deploy Bookinfo with an Istio ingress gateway exposing the Product Page service, similar to the setup in #28.

## Quickstart

1. Create clusters:
   ./kind-multicluster.sh
2. Install Istio:
   ./install-istio.sh controller
   ./install-istio.sh worker1
   ./install-istio.sh worker2
3. Install Kubeslice:
   ./install-kubeslice.sh controller controller
   ./install-kubeslice.sh worker1 worker
   ./install-kubeslice.sh worker2 worker
4. Configure Kubeslice:
   kubectl --context kind-controller apply -f project.yaml
   kubectl --context kind-controller apply -f slice.yaml
5. Deploy Bookinfo:
   kubectl --context kind-controller apply -f bookinfo-split.yaml
   kubectl --context kind-worker1 apply -f bookinfo-split.yaml
   kubectl --context kind-worker2 apply -f bookinfo-split.yaml
6. Deploy Istio ingress gateway:
   kubectl --context kind-controller apply -f istio-gateway.yaml
