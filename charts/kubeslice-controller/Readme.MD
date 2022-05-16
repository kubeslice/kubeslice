# Kubeslice Controller Helm Charts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

The KubeSlice Controller is installed in one of the clusters and provides a central configuration management system, for slices across multiple clusters. Please refer to the [documentation](https://docs.avesha.io/opensource/kube-slice-architecture#Bookmark11) for more details.

# Architecture overview
See [Kubeslice Reference Architecture](https://docs.avesha.io/opensource/kube-slice-architecture) to get an overview of the overall architecture and Kubeslice Controller component.

# Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add avesha https://kubeslice.github.io/charts/
```

You can then run `helm search repo avesha` to see the charts.


Quick Start
---

See [Kubeslice Controller Installation](https://docs.avesha.io/opensource/getting-started-with-kind-clusters#Bookmark56) for instructions on installing kubeslice controller on [`kind`](https://kind.sigs.k8s.io/) for non-production use.

For setting up Kubeslice Controller on other cloud platforms, refer to the [Kubeslice Controller Installation on Cloud](https://docs.avesha.io/opensource/installing-the-kubeslice-controller).

Guide
---
A full and comprehensive documentation is available on our opensource [documentation](https://docs.avesha.io/opensource/) website.
