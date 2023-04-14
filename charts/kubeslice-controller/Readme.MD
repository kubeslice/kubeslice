# Kubeslice Controller Helm Charts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)


The KubeSlice Controller is installed in one of the clusters and provides a central configuration management system, for slices across multiple clusters. Please refer to the [documentation](https://docs.avesha.io/documentation/open-source/0.7.0/architecture#kubeslice-controller) for more details.

# Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add kubeslice https://kubeslice.github.io/kubeslice/
```

You can then run `helm search repo kubeslice` to see the charts.


## Setting Up Kubeslice Controller

### Install Chart


See [Kubeslice Controller Installation](https://docs.avesha.io/documentation/open-source/0.7.0/getting-started-with-kind-clusters) for instructions on installing kubeslice controller on [`kind`](https://kind.sigs.k8s.io/) for non-production use.

For setting up Kubeslice Controller on other cloud platforms, refer to the [Kubeslice Controller Installation on Cloud](https://docs.avesha.io/documentation/open-source/0.7.0/getting-started-with-cloud-clusters/).

### Uninstall Chart

Please refer the following Kubeslice controller [uninstallation](https://docs.avesha.io/documentation/open-source/0.7.0/getting-started-with-cloud-clusters/uninstalling-kubeslice/) steps

### Upgrading Chart

```console
helm upgrade [RELEASE_NAME] kubeslice/kubeslice-controller [flags]
```

Guide
---

A full and comprehensive documentation is available on our opensource [documentation](https://docs.avesha.io/documentation/open-source/0.7.0/) website.
