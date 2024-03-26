# Development guidelines for kubeslice Charts

The KubeSlice repository consolidates the packaging of all components, complete with Helm charts for streamlined deployment.

It is strongly recommended to use a released version. Follow the instructions provided in this [document](https://kubeslice.io/documentation/open-source/1.2.0/category/install-kubeslice).

## Contributing to KubeSlice Repository

We welcome contributions to the KubeSlice project! If you've made changes locally and would like to update the Helm charts in the repository, here's how you can do it:

1. Fork the KubeSlice repository on GitHub.
2. Clone your forked repository to your local machine.
3. Make your changes locally and commit them to your forked repository.
4. Push the changes to your GitHub fork.
5. To update the Helm charts with your changes, use the following command in your terminal:
   ```bash 
   helm repo add my-changes https://github.com/<your-username>/kubeslice
   ```
6. Replace `<your-username>` with your actual GitHub username.
7. Submit a pull request to the main KubeSlice repository with a description of your changes.

**Your contributions are valuable to us, and we look forward to reviewing your pull request!**

## Adding KubeSlice Helm Repository to a Kind Cluster

To integrate KubeSlice into your kind cluster, you'll need to add the KubeSlice Helm repository. Helm charts simplify the deployment and management of applications on Kubernetes clusters. Follow these steps to set up the KubeSlice Helm repo:

1. Open your terminal.
2. Ensure that you have Helm installed. If not, install Helm using the official [installation guide](https://helm.sh/docs/intro/install/).
3. Add the KubeSlice Helm repository with the following command:
   ```bash 
   helm repo add kubeslice https://kubeslice.github.io/kubeslice/
      ```
4. Update your Helm repository to ensure you have the latest version of the charts:
   ```bash
   helm repo update
   ```
5. Now, you can search for available charts in the KubeSlice repository:
   ```bash
   helm search repo kubeslice
   ```

By completing these steps, you've successfully added the KubeSlice Helm repository to your kind cluster, and you're ready to deploy KubeSlice components.
Visit the [KubeSlice documentation](https://kubeslice.io/documentation/open-source/) for detailed installation instructions.

## License

Apache License 2.0
