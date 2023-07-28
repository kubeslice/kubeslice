# Kubeslice Worker Helm Charts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)


The Slice Operator, also known as a Kubeslice Worker is a Kubernetes Operator component that manages the life-cycle of the KubeSlice related Custom Resource Definitions (CRDs). Please refer to the [documentation](https://docs.avesha.io/documentation/open-source/1.1.0/architecture#slice-operator) for more details.

# Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add kubeslice https://kubeslice.github.io/kubeslice/
```

You can then run `helm search repo kubeslice` to see the charts.

## Setting Up Kubeslice Worker

### Install Chart


See [Kubeslice Worker Installation](https://docs.avesha.io/documentation/open-source/1.1.0/getting-started-with-kind-clusters#registering-the-worker-clusters) for instructions on istalling worker operator on [`kind`](https://kind.sigs.k8s.io/) for non-production use.

For setting up Worker Operator on other cloud platforms, refer to the [Kubeslice Worker Installation on Cloud](https://docs.avesha.io/documentation/open-source/1.1.0/getting-started-with-cloud-clusters/installing-kubeslice/registering-the-worker-cluster).

### Uninstall Chart

Please refer the following Kubeslice Worker [uninstallation](https://docs.avesha.io/documentation/open-source/1.1.0/getting-started-with-cloud-clusters/uninstalling-kubeslice/deregistering-the-worker-cluster) steps

### Upgrading Chart

```console
helm upgrade [RELEASE_NAME] kubeslice/kubeslice-worker [flags]
```

Guide
---
A full and comprehensive documentation is available on our opensource [documentation](https://docs.avesha.io/documentation/open-source/1.1.0/) website.
