# Fluentd 10x Helm Chart Changelog

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

## [v0.9.0] - 2026-02-06

### Changed

- Upgraded 10x engine to appVersion 0.3.0.
- Added fluent keyword to chart metadata.

## [v0.2.1] - 2025-01-31

### Changed

- Added 10x Observability engine integration to fluentd.
- Updated container image to use Log10x fluentd-10x image.
- Added 10x configuration options (report, regulate, optimize modes).
- Added GitHub config fetcher init container for fetching config and symbols.
- Updated maintainers and sources to Log10x.

<!--
RELEASE LINKS
-->
[UNRELEASED]: https://github.com/log-10x/fluent-helm-charts/tree/main/charts/fluentd
[v0.9.0]: https://github.com/log-10x/fluent-helm-charts/releases/tag/fluentd-0.9.0
[v0.2.1]: https://github.com/log-10x/fluent-helm-charts/releases/tag/fluentd-0.2.1