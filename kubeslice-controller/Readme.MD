::: full-height-container
::: {#sidebar .split}
::: {#search .navgroup}
:::

::: {#navigation .navgroup}
-   k-Native Application: iperf - OS
:::
:::

::: {#content .split}
::: wiki-page
::: wiki-title
# k-Native Application: iperf - OS {#Bookmark1 .page-title-lvl-cover}
:::

::: wiki-content
::: {.toc-macro .rbtoc1651832938559}
-   [Introduction](#Bookmark2 "Introduction")
-   [Prerequisites](#Bookmark3 "Prerequisites")
-   [Deploying iPerf](#Bookmark4 "Deploying iPerf")
    -   [Creating Iperf Sleep .yaml
        File](#Bookmark5 "Creating Iperf Sleep .yaml File")
    -   [Applying the Iperf Sleep .yaml
        File](#Bookmark6 "Applying the Iperf Sleep .yaml File")
    -   [Creating the Iperf Server .yaml
        File](#Bookmark7 "Creating the Iperf Server .yaml File")
    -   [Applying the Iperf-Server .yaml
        File](#Bookmark8 "Applying the Iperf-Server .yaml File")
-   [Validating your iPerf
    Installation](#Bookmark9 "Validating your iPerf Installation")
    -   [Validating the iPerf Sleep
        Installation](#Bookmark10 "Validating the iPerf Sleep Installation")
    -   [Validating the iPerf Server
        Installation](#Bookmark11 "Validating the iPerf Server Installation")
    -   [Validating ServiceExport and
        ServiceImport](#Bookmark12 "Validating ServiceExport and ServiceImport")
-   [Getting the DNS Name](#Bookmark13 "Getting the DNS Name")
-   [Verifying the Inter-Cluster
    Communication](#Bookmark14 "Verifying the Inter-Cluster Communication")
-   [Uninstalling Iperf](#Bookmark15 "Uninstalling Iperf")
-   [Next Steps](#Bookmark16 "Next Steps")
:::

[]{#Bookmark2}

## Introduction {#Bookmark2}

iPerf is a tool commonly used to measure network performance, perform
network tuning, and more. The iPerf application consists of two main
services, iperf-sleep (client) and iperf-server.

This tutorial provides the steps to:

-   Install the iperf-sleep and iperf-server services on two clusters
    within a KubeSlice configuration.

-   Verify inter-cluster communication over the KubeSlice.

[]{#Bookmark3}

## Prerequisites {#Bookmark3}

To install iPerf, you should first have a KubeSlice configuration with
two or more clusters installed. To install KubeSlice, visit:

command-line

[k-Native Prerequisites - OS
(WIP)](https://avesha.atlassian.net/wiki/spaces/TD/pages/2284486657 "https://avesha.atlassian.net/wiki/spaces/TD/pages/2284486657"){linked-resource-id="2284486657"
linked-resource-version="4" linked-resource-type="page"}[]{#Bookmark4}

## Deploying iPerf {#Bookmark4}

In this tutorial, iperf-sleep and iperf-server will be deployed in the
two different clusters. The cluster used for iperf-sleep is referred to
as \<sleep cluster\>, and the cluster used for iperf-server is referred
to as \<server cluster\>.

[]{#Bookmark5}

### Creating Iperf Sleep .yaml File {#Bookmark5}

Using the template below, create a deployment file, `iperf-sleep.yaml`.
All fields in the template remain the same except for **\<slice name\>**
which must be replaced with the name of your slice.

::: {.code .panel .pdl style="border-width: 1px;"}
::: {.codeContent .panelContent .pdl}
``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: iperf-sleep
  namespace: iperf
  labels:
    app: iperf-sleep
  annotations:
    kubeslice.io/slice: <slice-Name>
spec:
  replicas: 1
  selector:
    matchLabels:
      app: iperf-sleep
  template:
    metadata:
      labels:
        app: iperf-sleep
    spec:
      containers:
      - name: iperf
        image: mlabbe/iperf
        imagePullPolicy: Always
        command: ["/bin/sleep", "3650d"]
      - name: sidecar
        image: nicolaka/netshoot
        imagePullPolicy: IfNotPresent
        command: ["/bin/sleep", "3650d"]
        securityContext:
          capabilities:
            add: ["NET_ADMIN"]
          allowPrivilegeEscalation: true
          privileged: true
```
:::
:::

[]{#Bookmark6}

### Applying the Iperf Sleep .yaml File {#Bookmark6}

Perform these steps:

1.  Switch the context to the registered cluster you want to install
    Iperf-sleep.\

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    kubectx <cluster name>
    ```
    :::
    :::

2.  Create the iPerf namespace.\

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    kubectl create ns iperf
    ```
    :::
    :::

3.  Apply the `iperf-sleep.yaml` deployment.\

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    kubectl apply -f iperf-sleep.yaml -n iperf
    ```
    :::
    :::

[]{#Bookmark7}

### Creating the Iperf Server .yaml File {#Bookmark7}

Using the template below, create a deployment file name
`iperf-server.yaml`. All fields in the template will remain the same
except for **two** **\<slice name\>** instances which must be replaced
with the name of your slice.

::: {.code .panel .pdl style="border-width: 1px;"}
::: {.codeContent .panelContent .pdl}
``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: iperf-server
  namespace: iperf
  labels:
    app: iperf-server
  annotations:
    kubeslice.io/slice: <slice-name>
spec:
  replicas: 1
  selector:
    matchLabels:
      app: iperf-server
  template:
    metadata:
      labels:
        app: iperf-server
    spec:
      containers:
      - name: iperf
        image: mlabbe/iperf
        imagePullPolicy: Always
        args:
          - '-s'
          - '-p'
          - '5201'
        ports:
        - containerPort: 5201
          name: server
      - name: sidecar
        image: nicolaka/netshoot
        imagePullPolicy: IfNotPresent
        command: ["/bin/sleep", "3650d"]
        securityContext:
          capabilities:
            add: ["NET_ADMIN"]
          allowPrivilegeEscalation: true
          privileged: true
---
apiVersion: kubeslice.kubeslice.io/v1beta1
kind: ServiceExport
metadata:
  name: iperf-server
  namespace: iperf
spec:
  slice: <slice-name>
  selector:
    matchLabels:
      app: iperf-server
  ports:
  - name: tcp
    containerPort: 5201
    protocol: TCP
```
:::
:::

[]{#Bookmark8}

###  Applying the Iperf-Server .yaml File {#Bookmark8}

\
Perform these steps:

1.  Switch context to the registered cluster you want to install the
    iperf server.

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    kubectx <cluster name>
    ```
    :::
    :::

2.  Create the namespace `iperf`.

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    kubectl create ns iperf
    ```
    :::
    :::

3.  Apply the `iperf-server.yaml` deployment.

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    kubectl apply -f iperf-server.yaml -n iperf
    ```
    :::
    :::

[]{#Bookmark9}

## Validating your iPerf Installation {#Bookmark9}

To verify our iPerf installation, first switch contexts to the cluster
with the `iperf-sleep.yaml` applied.

[]{#Bookmark10}

### Validating the iPerf Sleep Installation {#Bookmark10}

Perform these steps:

1.  Switch the context to the cluster where you installed the Iperf
    Sleep.

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    kubectx <cluster name>
    ```
    :::
    :::

2.  To validate the iperf-sleep pods belonging to the namespace iperf,
    run the following command:

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    $ kubectl get pods -n iperf
    ```
    :::
    :::

    Example Output

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    NAME                           READY   STATUS    RESTARTS   AGE
    iperf-sleep-5477bf94cb-vmmtd   4/4     Running   0          10s
    ```
    :::
    :::

3.  Validate the ServiceImport using the following command:

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    $ kubectl get serviceimport -n iperf
    ```
    :::
    :::

    Example Output

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    NAME           SLICE   PORT(S)   ENDPOINTS   STATUS
    iperf-server   lion              1           READY
    ```
    :::
    :::

[]{#Bookmark11}

###  Validating the iPerf Server Installation {#Bookmark11}

Perform these steps:

1.  Switch the context to the cluster where you have installed the Iperf
    Server.

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    kubectx <cluster name>
    ```
    :::
    :::

2.  Validate the iperf-server pods belonging to the namespace iperf, run
    the following command:

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    $ kubectl get pods -n iperf
    ```
    :::
    :::

    Example Output

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    NAME                            READY   STATUS    RESTARTS   AGE
    iperf-server-5958958795-fld2p   4/4     Running   0          20s
    ```
    :::
    :::

3.  Validate the ServiceImport using the following command:

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    $ kubectl get serviceimport -n iperf
    ```
    :::
    :::

    Example Output

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    NAME           SLICE   PORT(S)   ENDPOINTS   STATUS
    iperf-server   lion              1           READY
    ```
    :::
    :::

4.  Validate the ServiceExport using the following command:

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    $ kubectl get serviceexport -n iperf
    ```
    :::
    :::

    Example Output

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    NAME           SLICE   INGRESS   PORT(S)    ENDPOINTS   STATUS
    iperf-server   lion              5201/TCP   1           READY
    ```
    :::
    :::

[]{#Bookmark12}

### Validating ServiceExport and ServiceImport {#Bookmark12}

Perform these steps in the cluster where KubeSlice Controller is
installed:

1.  Switch the context of the cluster.

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    kubectx <cluster name>
    ```
    :::
    :::

2.  To validate serviceexportconfig use the following command:

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    $ kubectl get serviceexportconfigs -A
    ```
    :::
    :::

    Example Output

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    NAMESPACE          NAME           AGE
    kubeslice-devops   iperf-server   5m12s
    ```
    :::
    :::

3.  To validate the[ workerserviceimport]{.inline-comment-marker
    ref="1888ed87-7c9f-4eb6-9f8c-9dc105a08405"}s use the following
    command:

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    $ kubectl get workerserviceimports -A
    ```
    :::
    :::

    \
    Example Output

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    NAMESPACE          NAME                                      AGE
    kubeslice-devops   iperf-server-iperf-lion-worker-cluster-1   5m59s
    kubeslice-devops   iperf-server-iperf-lion-worker-cluster-2   5m59s
    ```
    :::
    :::

[]{#Bookmark13}

## Getting the DNS Name {#Bookmark13}

Next, run the following command to describe the iperf-server service and
retrieve the short and full DNS names for the service. We will use the
*short * DNS name later to verify the inter-cluster communication.

::: {.code .panel .pdl style="border-width: 1px;"}
::: {.codeContent .panelContent .pdl}
``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
kubectl describe serviceimport iperf-server -n iperf | grep "Dns Name:"
```
:::
:::

Expected Output

::: {.code .panel .pdl style="border-width: 1px;"}
::: {.codeContent .panelContent .pdl}
``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
Dns Name:  iperf-server.iperf.svc.slice.local #The DNS Name listed here will be used as the DNS Name below.
    Dns Name: <iperf server service>.<cluster identifier>.iperf-server.iperf.svc.slice.local #Full DNS Name
```
:::
:::

[]{#Bookmark14}

## Verifying the Inter-Cluster Communication {#Bookmark14}

Perform these steps:

1.  Switch the context of the cluster.

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    kubectx <cluster name>
    ```
    :::
    :::

2.  List the pods in the `iperf` namespace to get the full name of the
    `iperf-sleep` pod.

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    kubectl get pods -n iperf
    ```
    :::
    :::

3.  Using the pod name you just retrieved, execute the command into the
    iperf-sleep pod with the following command:

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    kubectl exec -it <iperf-sleep pod name> -c iperf -n iperf -- sh
    ```
    :::
    :::

4.  Once attached to the pod, use the short DNS Name retrieved above to
    connect to the server from the sleep pod.

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    iperf -c <short iperf-server DNS Name> -p 5201 -i 1 -b 10Mb;
    ```
    :::
    :::

    \
    Expected Output.\
    If the iperf-sleep pod is able to reach the iperf-server pod across
    clusters, you should see similar output to that below.\

    ::: {.code .panel .pdl style="border-width: 1px;"}
    ::: {.codeContent .panelContent .pdl}
    ``` {.syntaxhighlighter-pre syntaxhighlighter-params="brush: java; gutter: false; theme: Confluence" theme="Confluence"}
    > kubectl exec -it iperf-sleep-5477bf94cb-vmmtd -c iperf -n iperf -- sh
    / $ iperf -c iperf-server.iperf.svc.slice.local -p 5201 -i 1 -b 10Mb;
    ------------------------------------------------------------
    Client connecting to iperf-server.iperf.svc.slice.local, TCP port 5201
    TCP window size: 45.0 KByte (default)
    ------------------------------------------------------------
    [  1] local 10.1.1.89 port 38400 connected with 10.1.2.25 port 5201
    [ ID] Interval       Transfer     Bandwidth
    [  1] 0.00-1.00 sec  1.25 MBytes  10.5 Mbits/sec
    [  1] 1.00-2.00 sec  1.25 MBytes  10.5 Mbits/sec
    [  1] 2.00-3.00 sec  1.25 MBytes  10.5 Mbits/sec
    [  1] 3.00-4.00 sec  1.25 MBytes  10.5 Mbits/sec
    [  1] 4.00-5.00 sec  1.25 MBytes  10.5 Mbits/sec
    [  1] 5.00-6.00 sec  1.25 MBytes  10.5 Mbits/sec
    [  1] 6.00-7.00 sec  1.25 MBytes  10.5 Mbits/sec
    [  1] 7.00-8.00 sec  1.25 MBytes  10.5 Mbits/sec
    [  1] 8.00-9.00 sec  1.25 MBytes  10.5 Mbits/sec
    [  1] 9.00-10.00 sec  1.25 MBytes  10.5 Mbits/sec
    [  1] 0.00-10.00 sec  12.8 MBytes  10.7 Mbits/sec
    / $
    ```
    :::
    :::

[]{#Bookmark15}

## Uninstalling Iperf {#Bookmark15}

If you would like to uninstall iPerf from your KubeSlice configuration,
simply follow the instructions in the guide below:

[k-Native Detaching the Applications -
OS](https://avesha.atlassian.net/wiki/spaces/TD/pages/2285437008/k-Native+Detaching+the+Applications+-+OS "https://avesha.atlassian.net/wiki/spaces/TD/pages/2285437008/k-Native+Detaching+the+Applications+-+OS"){linked-resource-id="2285437008"
linked-resource-version="3" linked-resource-type="page"}

[]{#Bookmark16}

## Next Steps {#Bookmark16}

Learn how to uninstall KubeSlice in [k-Native Uninstalling KubeSlice -
OS](https://avesha.atlassian.net/wiki/spaces/TD/pages/2285436995/k-Native+Uninstalling+KubeSlice+-+OS "https://avesha.atlassian.net/wiki/spaces/TD/pages/2285436995/k-Native+Uninstalling+KubeSlice+-+OS"){linked-resource-id="2285436995"
linked-resource-version="2" linked-resource-type="page"} .
:::
:::
:::
:::
