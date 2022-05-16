# Worker Operator Helm Charts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

The Slice Operator, also known as a Worker Operator is a Kubernetes Operator component that manages the life-cycle of the KubeSlice related Custom Resource Definitions (CRDs). Please refer to the [documentation](https://docs.avesha.io/opensource/kube-slice-architecture#Bookmark16) for more details.

# Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add avesha https://kubeslice.github.io/charts/
```

You can then run `helm search repo avesha` to see the charts.

## Setting Up Worker Operator

### Install Chart
---

See [Worker Operator Installation](https://docs.avesha.io/opensource/getting-started-with-kind-clusters#Bookmark93) for instructions on istalling worker operator on [`kind`](https://kind.sigs.k8s.io/) for non-production use.

For setting up Worker Operator on other cloud platforms, refer to the [Worker Operator Installation on Cloud](https://docs.avesha.io/opensource/registering-the-worker-cluster#Bookmark228).

### Uninstall Chart
---
Please refer the following worker operator [uninstallation](https://docs.avesha.io/opensource/de-registering-the-worker-cluster#Bookmark336) steps

### Upgrading Chart
---
```console
helm upgrade [RELEASE_NAME] avesha/kubeslice-worker [flags]
```

Guide
---
A full and comprehensive documentation is available on our opensource [documentation](https://docs.avesha.io/opensource/) website.
