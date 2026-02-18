# Fluent + 10x Helm Charts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Release Status](https://github.com/log-10x/fluent-helm-charts/actions/workflows/release.yaml/badge.svg?branch=main)](https://github.com/log-10x/fluent-helm-charts/actions/workflows/release.yaml)

Helm charts for deploying Fluentd / Fluent-Bit with an [10x Edge app](https://doc.log10x.com/apps/edge)

The Fluentd and Fluent-Bit charts are built on top of the official [fluent helm charts](https://github.com/fluent/helm-charts), and work by replacing the base image with one which has [10x installed](https://doc.log10x.com/install/linux/) on it, as well as setting all the necessary [10x configuration](https://doc.log10x.com/run/input/forwarder/)

For more details on how the images are created, see the [docker-images repo](https://github.com/log-10x/docker-images).

The supported [10x distributions](https://doc.log10x.com/architecture/flavors/) are JIT Edge and Native Edge. Check out each individual chart values.yaml for full configuration options.

## Usage

[Helm](https://helm.sh) must be installed to use these charts; please refer to the _Helm_ [documentation](https://helm.sh/docs/) to get started.

### OCI Repository (Recommended)

Install directly from the OCI registry:

```shell
# Install fluentd
helm install fluentd oci://ghcr.io/log-10x/fluent-helm-charts/fluentd

# Install a specific version
helm install fluentd oci://ghcr.io/log-10x/fluent-helm-charts/fluentd --version 0.2.0

# Show chart info and available versions
helm show all oci://ghcr.io/log-10x/fluent-helm-charts/fluentd
```

No `helm repo add` required - OCI pulls directly from the registry.

### Helm Repository (Alternative)

Add the Helm repository:

```shell
helm repo add log10x-fluent https://log-10x.github.io/fluent-helm-charts
helm repo update
helm search repo fluent
```

Then install:

```shell
helm install fluentd log10x-fluent/fluentd
```

## Charts

- [fluentd](./charts/fluentd/README.md)
- [fluent-bit](./charts/fluent-bit/README.md)

## License

This repository is licensed under the [Apache License 2.0](LICENSE).

### Important: Log10x Product License Required

This repository contains deployment tooling for Log10x with Fluent Bit/Fluentd. While the tooling
itself is open source, **using Log10x requires a commercial license**.

| Component | License |
|-----------|---------|
| This repository (Helm charts) | Apache 2.0 (open source) |
| Log10x engine and runtime | Commercial license required |

**What this means:**

- You can freely use, modify, and distribute these Helm charts
- The Log10x software that these charts deploy requires a paid subscription
- A valid Log10x API key is required to run the deployed software

**Get Started:**

- [Log10x Pricing](https://log10x.com/pricing)
- [Documentation](https://doc.log10x.com)
- [Contact Sales](mailto:sales@log10x.com)
