
# Bookinfo on Kubeslice with Istio and mTLS (3 clusters)

Scripts and manifests to deploy Bookinfo across three kind clusters (controller, worker1, worker2) with Istio (mTLS enabled) and Kubeslice.

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
