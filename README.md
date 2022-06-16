# Kubeslice Community Kubernetes Helm Charts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

KubeSlice provides network services to applications that need secure and highly available connectivity between multiple clusters. KubeSlice creates a flat overlay network to connect the clusters. The overlay network can be described as an application slice that provides a slice of connectivity between the pods of an application running in multiple clusters. It can also be described as an application-specific VPC that spans across clusters. Pods can connect to the slice overlay network and communicate with each other seamlessly across cluster boundaries.

# Architecture overview
See [Kubeslice Reference Architecture](https://docs.avesha.io/opensource/kube-slice-architecture) to get an overview of the overall architecture and core components.

# Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add kubeslice https://kubeslice.github.io/charts/
```

You can then run `helm search repo kubeslice` to see the charts.


Quick Start
---

See [Getting Started](https://docs.avesha.io/opensource/getting-started-with-kind-clusters) for instructions on setting up a local kubeslice setup using [`kind`](https://kind.sigs.k8s.io/) for non-production use.

For setting up Kubeslice on other cloud platforms, refer to the [getting started with cloud](https://docs.avesha.io/opensource/getting-started-with-cloud-clusters).

Guide
---
A full and comprehensive documentation is available on our opensource [documentation](https://docs.avesha.io/opensource/) website.
