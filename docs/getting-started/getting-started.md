# Installing Knative

## Install Command Line Interface

### Install <a href= "https://kind.sigs.k8s.io/docs/user/quick-start/" target="blank_">Kind</a> CLI.

???+ todo "Installing Kind"

    === "macOS"
        Use Homebrew
        ```bash
        brew install kind
        ```
        Or
        ```bash
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.10.0/kind-darwin-amd64
        ```

    === "Linux"
        ```bash
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.10.0/kind-linux-amd64
        chmod +x ./kind
        mv ./kind /some-dir-in-your-PATH/kind
        ```

    === "Windows"
        ```terminal
        curl.exe -Lo kind-windows-amd64.exe https://kind.sigs.k8s.io/dl/v0.10.0/kind-windows-amd64
        Move-Item .\kind-windows-amd64.exe c:\some-dir-in-your-PATH\kind.exe
        ```
        Use [Chocolatey](https://chocolatey.org/packages/kind)

See <a href= "https://kind.sigs.k8s.io/docs/user/quick-start/" target="blank_">Kind website</a> for other installation options.

??? question "Need to upgrade Kind?"
    === "Upgrade Kind using Homebrew"
        ```bash
        brew upgrade kind
        ```
    === "Other Upgrade Options"
        See <a href= "https://kind.sigs.k8s.io/docs/user/quick-start/" target="blank_">Kind website</a> for other upgrade options.

### Install Kubernetes CLI `kubectl`

???+ todo "Installing the `kubectl` CLI"

    === "Using Homebrew"
        If you are on macOS and using [Homebrew](http://brew.sh) package manager, you can install kubectl with Homebrew.
        ``` bash
        brew install kubectl
        ```
    === "From the Kubernetes website"
        See <a href="https://kubernetes.io/docs/tasks/tools/install-kubectl/" target="_blank">the Kubernetes docs</a> for other installation options.


### Install Knatice CLI `kn`

==**The Knative CLI provides a quick and easy interface for creating Knative resources**== such as Knative Services and event sources, without the need to create or modify YAML files directly. `kn` also simplifies completion of otherwise complex procedures such as autoscaling and traffic splitting.


!!! example "Installing the `kn` CLI"

    === "Using Homebrew"
        For macOS, you can install `kn` by using <a href="https://github.com/knative/homebrew-client" target="_blank">Homebrew</a>.

        ```
        brew install knative/client/kn
        ```

    === "Using a binary"

        You can install `kn` by downloading the executable binary for your system and placing it in the system path.

        A link to the latest stable binary release is available on the <a href="https://github.com/knative/client/releases" target="_blank">`kn` release page</a>.

    === "Installing kn using Go"

        1. Check out the `kn` client repository:

              ```
              git clone https://github.com/knative/client.git
              cd client/
              ```

        1. Build an executable binary:

              ```
              hack/build.sh -f
              ```

        1. Move `kn` into your system path, and verify that `kn` commands are working properly. For example:

              ```
              kn version
              ```

    === "Running kn using container images"

        **WARNING:** Nightly container images include features which may not be included in the latest Knative release and are not considered to be stable.

        Links to images are available here:

        - <a href="https://gcr.io/knative-releases/knative.dev/client/cmd/kn" target="_blank">Latest release</a>
        - <a href="https://gcr.io/knative-nightly/knative.dev/client/cmd/kn" target="_blank">Nightly container image</a>

        You can run `kn` from a container image. For example:

        ```
        docker run --rm -v "$HOME/.kube/config:/root/.kube/config" gcr.io/knative-releases/knative.dev/client/cmd/kn:latest service list
        ```

        **NOTE:** Running `kn` from a container image does not place the binary on a permanent path. This procedure must be repeated each time you want to use `kn`.
    For more complex installations, such as nightly releases, see [Install `kn`](../client/install-kn.md)


## Installing Knative
==**The fastest way to get started with Knative locally** is to use the <a href= "https://konk.dev" target="blank_">Konk (Knative-on-kind) script.</a>==

!!! todo "Install Knative and Kubernetes on a local Docker Daemon using Konk"
    ```
    curl -sL install.konk.dev | bash
    ```

??? question "What does the KonK script actually do?"
    Knative on Kind (KonK) is a shell script which:

      1. Checks to see that you have Kind installed and creates a Cluster called "knative" via **[`01-kind.sh`](https://github.com/csantanapr/knative-kind/blob/master/01-kind.sh)**

      2. Installs **Knative Serving** with **Kourier** as the networking layer and **nip.io** as the DNS + some port-forwarding magic on the "knative" Cluster via **[`02-serving.sh`](https://github.com/csantanapr/knative-kind/blob/master/02-serving.sh)**

      3. Installs **Knative Eventing** with an In-Memory **Channels** and In-Memory **Broker** on the "knative" Cluster via **[`04-eventing.sh`](https://github.com/csantanapr/knative-kind/blob/master/04-eventing.sh)**
