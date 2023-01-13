# Fluent Helm Charts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Release Status](https://github.com/fluent/helm-charts/workflows/Release%20Charts/badge.svg?branch=main)](https://github.com/fluent/helm-charts/actions)

This functionality is in beta and is subject to change. The code is provided as-is with no warranties. Beta features are not subject to the support SLA of official GA features.

## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```sh
helm repo add fluent https://fluent.github.io/helm-charts
```

You can then run `helm search repo fluent` to see the charts.

## Upgrading

Although the services will deploy and generally work, version 1.0 introduces some changes that are considered _breaking changes_. To upgrade, you should do the following to avoid any potential conflicts or problems:

- Add the `mountVarLogDirectory` and `mountDockerContainersDirectory` values and set them to the values you need; to follow the previous setup where these were mounted by default, set the values to `true`, e.g. `mountVarLogDirectory: true`
- If you have the `varlog` mount point defined and enabled under both `volumes` and `volumeMounts`, set `mountVarLogDirectory` to true
- If you have the `varlibdockercontainers` mount point defined and enabled under both `volumes` and `volumeMounts`, set `mountDockerContainersDirectory` to true
- Remove the previous default volume and volume mount definitions - `etcfluentd-main`, `etcfluentd-config`, `varlog`, and `varlibdockercontainers`
- Remove the `FLUENTD_CONF` entry from the `env:` list

## Contributing

We'd love to have you contribute! Please refer to our [contribution guidelines](CONTRIBUTING.md) for details.

## License

[Apache 2.0 License](./LICENSE).
