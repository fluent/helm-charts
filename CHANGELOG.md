# ChangeLog

All notable changes to this project are documented in this file.

## [0.3.0] - DATE YYYY/MM/DD

- Added statefulset suport

## [1.0.0] - 2023/01/13

- (fluentd) Mount all standard config files in the pod definition (see `charts/fluentd/templates/_pod.tpl`)
- (fluentd) Use `mountVarLogDirectory` instead of the `volumes` list to control whether or not `/var/log` is mounted
- (fluentd) Use `mountDockerContainersDirectory` instead of the `volumes` list to control whether or not `/var/lib/docker/containers` is mounted
- (fluentd) Override the ConfigMap used to mount the main `fluent.conf` file by setting `mainConfigMapNameOverride`
- (fluentd) Override the ConfigMap used to mount extra configuration files by setting `extraFilesConfigMapNameOverride`
- (fluentd) All ConfigMap definitions are now specific to each deployment, allowing users to deploy Fluentd to the same namespace multiple times