# Fluent + 10x Helm Charts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Release Status](https://github.com/log-10x/fluent-helm-charts/actions/workflows/release.yaml/badge.svg?branch=main)](https://github.com/log-10x/fluent-helm-charts/actions)

Helm charts for deploying Fluentd / Fluent-Bit with an [10x Edge app](http://doc.log10x.com/apps/#edge)

The Fluentd and Fluent-Bit charts are built on top of the official [fluent helm charts](https://github.com/fluent/helm-charts), and work by replacing the base image with one which has [10x installed](http://doc.log10x.com/home/install/package/) on it, as well as setting all the necessary [10x configuration](http://doc.log10x.com/run/input/forwarder/)

For more details on how the images are created, see - https://github.com/log-10x/docker-images

The supported [10x distributions](http://doc.log10x.com/home/install/#flavor-matrix) are JIT Edge and Native Edge. Check out each individual chart values.yaml for full configuration options.


## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```sh
helm repo add fluent-10x https://log-10x.github.io/fluent-helm-charts
```

You can then run `helm search repo fluent-10x` to see the charts.
