# Fluent Helm Charts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Release Status](https://github.com/fluent/helm-charts/actions/workflows/release.yaml/badge.svg?branch=main)](https://github.com/fluent/helm-charts/actions/workflows/release.yaml)

This functionality is in beta and is subject to change. The code is provided as-is with no warranties. Beta features are not subject to the support SLA of official GA features.

## Usage

[Helm](https://helm.sh) must be installed to use these charts; please refer to the _Helm_ [documentation](https://helm.sh/docs/) to get started.

### OCI Repositories

The recommended way to install these charts is via OCI and the `helm search hub fluent` command should list the available charts.

### Non-OCI Repository

If you don't want to use the OCI repositories you can add the `fluent` repository as follows.

```shell
helm repo add fluent https://fluent.github.io/helm-charts/
helm repo update
```

You can then run `helm search repo fluent` to see the charts.

## Charts

- [fluent-bit-aggregator](./charts/fluent-bit-aggregator/README.md)
- [fluent-bit-collector](./charts/fluent-bit-collector/README.md)
- [fluent-bit](./charts/fluent-bit/README.md) _(use one of the above instead if possible)_
- [fluent-operator](./charts/fluent-operator/README.md)
- [fluentd](./charts/fluentd/README.md)

## Contributing

We'd love to have you contribute! Please refer to our [contribution guidelines](CONTRIBUTING.md) for details.

## License

[Apache 2.0 License](./LICENSE).
