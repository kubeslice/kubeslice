# Example Bookinfo on Kubeslice with Istio and mTLS

This directory contains scripts and manifests to deploy the Istio Bookinfo application across three kind clusters (controller, worker1, worker2) connected by Kubeslice, with Istio and mTLS enabled.

## Steps

1. **Create clusters:**
   ./kind-multicluster.sh

2. **Install Istio with mTLS:**
   ./install-istio.sh controller
   ./install-istio.sh worker1
   ./install-istio.sh worker2

3. **Install Kubeslice:**
   ./install-kubeslice.sh controller controller
   ./install-kubeslice.sh worker1 worker
   ./install-kubeslice.sh worker2 worker

4. **Configure Kubeslice:**
   kubectl --context kind-controller apply -f project.yaml
   kubectl --context kind-controller apply -f slice.yaml

5. **Deploy Bookinfo microservices:**
   # On controller:
   kubectl --context kind-controller apply -f bookinfo-split.yaml
   # On worker1:
   kubectl --context kind-worker1 apply -f bookinfo-split.yaml
   # On worker2:
   kubectl --context kind-worker2 apply -f bookinfo-split.yaml

6. **Verify cross-cluster Bookinfo access with mTLS.**

---

See README.md for prerequisites and more details.
