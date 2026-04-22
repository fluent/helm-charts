# fluent-operator-fluent-bit-crds

![Version: 4.0.0](https://img.shields.io/badge/Version-4.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.7.0](https://img.shields.io/badge/AppVersion-3.7.0-informational?style=flat-square)

Custom Resource Definitions (CRDs) for Fluent Bit. Provides full Helm lifecycle management for all Fluent Bit CRDs used by Fluent Operator.

**Homepage:** <https://github.com/fluent/fluent-operator>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| wenchajun | <dehaocheng@kubesphere.io> |  |
| marcofranssen | <marco.franssen@gmail.com> | <https://marcofranssen.nl> |
| joshuabaird | <joshbaird@gmail.com> |  |

## Source Code

* <https://github.com/fluent/fluent-operator/tree/master/charts/fluent-operator-fluent-bit-crds>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalAnnotations | object | `{}` | Additional annotations for all CRDs (e.g., helm.sh/resource-policy: keep to prevent deletion on uninstall) |
