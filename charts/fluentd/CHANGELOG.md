# Fluentd Helm Chart Changelog

> [!NOTE]
> All notable changes to this project will be documented in this file; the format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!--
### Added - For new features.
### Changed - For changes in existing functionality.
### Deprecated - For soon-to-be removed features.
### Removed - For now removed features.
### Fixed - For any bug fixes.
### Security - In case of vulnerabilities.
-->

## [UNRELEASED]

### Added

- Add `variantVersion` value to specify the version of the variant to use. ([#720](https://github.com/fluent/helm-charts/pull/720)) @stevehipwell

### Changed

- Use SemVer for chart versioning (remove `v` prefix from `appVersion`). ([#720](https://github.com/fluent/helm-charts/pull/720)) @stevehipwell
- Update _Fluentd_ app version to [`1.19.2`](https://github.com/fluent/fluentd/releases/tag/v1.19.2). ([#720](https://github.com/fluent/helm-charts/pull/720)) @stevehipwell
- Update _elasticsearch7_ variant version to `1.6`. ([#720](https://github.com/fluent/helm-charts/pull/720)) @stevehipwell

### Fixed

- Fix test connection pod to actually run so CI can pass. ([#720](https://github.com/fluent/helm-charts/pull/720)) @stevehipwell

## [v0.5.3] - 2025-05-05

### Changed

- Upgrade the FluentD app version to 1.17.1. ([#570](https://github.com/fluent/helm-charts/pull/570)) @idogada-akamai
- Since variant version 1.0 of elasticsearch7 for 1.17.1 doesn't exist in the Docker registry, I also changed its hard coded value to 1.2. ([#570](https://github.com/fluent/helm-charts/pull/570)) @idogada-akamai

<!--
RELEASE LINKS
-->
[UNRELEASED]: https://github.com/fluent/helm-charts/tree/main/charts/fluentd
[v0.5.3]: https://github.com/fluent/helm-charts/releases/tag/fluentd-0.5.3
