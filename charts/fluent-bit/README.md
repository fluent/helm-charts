# Fluent Bit + 10x Helm Chart

[Fluent Bit](https://fluentbit.io/) is a fast and lightweight log processor and forwarder for Linux, OSX and BSD family operating systems.

[10x](https://doc.log10x.com/home/) is an observability runtime that executes in edge/cloud environments to optimize and reduce the cost of analyzing and storing log/trace data.

## Overview

This chart is intended to set up a Fluent Bit daemonset with a 10x [Edge application](https://doc.log10x.com/apps/edge/)

The chart is derived from the base [Fluent Bit chart](https://github.com/fluent/helm-charts/tree/main/charts/fluent-bit), with some key differences which enable Fluent Bit to work with 10x:

1. Container image is derived from the official Fluent Bit image, with the 10x engine on it. For more details, see [Dockerfile](https://github.com/log-10x/docker-images/blob/main/fwd/fluentbit/Dockerfile)
2. Fluent Bit configuration is adapted to include emitting/receiving events to/from 10x. For more details on how Fluent Bit communicates with 10x, see [here](https://doc.log10x.com/run/input/forwarder/fluentbit/)
3. Added easy fetching of 10x application configuration and [symbols](https://doc.log10x.com/run/symbol/) from Github using an init container which pulls and mounts the needed files onto the main pod. For more details, see [Dockerfile](https://github.com/log-10x/docker-images/tree/main/ext/github-config-fetcher/Dockerfile)

## Installation

### OCI Repository (Recommended)

Install directly from the OCI registry:

```sh
helm install fluent-bit oci://ghcr.io/log-10x/fluent-helm-charts/fluent-bit
```

### Helm Repository (Alternative)

```sh
helm repo add log10x-fluent https://log-10x.github.io/fluent-helm-charts
helm repo update
helm install fluent-bit log10x-fluent/fluent-bit
```

## Examples

Sample values.yaml which sets up Fluent Bit with a 10x [Edge application](https://doc.log10x.com/apps/edge/) can be found [here](https://github.com/log-10x/fluent-helm-charts/tree/main/samples), for a 10x [Reporter](https://github.com/log-10x/fluent-helm-charts/blob/main/samples/fluentbit-report.yaml), [Regulator](https://github.com/log-10x/fluent-helm-charts/blob/main/samples/fluentbit-regulate.yaml) and [Optimizer](https://github.com/log-10x/fluent-helm-charts/blob/main/samples/fluentbit-optimize.yaml)

Full details on the base Fluent Bit chart can be found at the [original repo](https://github.com/fluent/helm-charts/tree/main/charts/fluent-bit)

## Chart Values

```sh
# OCI
helm show values oci://ghcr.io/log-10x/fluent-helm-charts/fluent-bit

# Or via Helm repo
helm show values log10x-fluent/fluent-bit
```

## 10x Configuration

The chart includes the following 10x-specific configuration options:

### tenx.enabled
Main switch to enable/disable 10x integration. Default: `true`

### tenx.variant
Specifies the 10x distribution. Options: `jit` (default), `native`. For more details, see [10x Flavors](https://doc.log10x.com/architecture/flavors)

### tenx.apiKey
Your 10x API key for metrics reporting. Default: `"NO-API-KEY"`

### tenx.kind
10x mode of operation. Options: `report`, `regulate` (default), `optimize`

### tenx.github.config
Configuration for fetching 10x config from GitHub:
- `enabled`: Enable config fetching (default: `false`)
- `token`: GitHub access token
- `repo`: Repository in format `user/repo`
- `branch`: Optional branch name

### tenx.github.symbols
Configuration for fetching 10x symbols from GitHub:
- `enabled`: Enable symbols fetching (default: `false`)
- `token`: GitHub access token
- `repo`: Repository in format `user/repo`
- `branch`: Optional branch name
- `path`: Optional sub-folder path within the repo

## Usage

### Using Lua Scripts

Fluent Bit allows us to provide a filter to modify the incoming records using custom [Lua scripts.](https://docs.fluentbit.io/manual/pipeline/filters/lua)

### How to use Lua scripts with this Chart

First, you should add your Lua scripts to `luaScripts` in values.yaml, templating is supported.

```yaml
luaScripts:
  filter_example.lua: |
    function filter_name(tag, timestamp, record)
        -- put your lua code here.
    end
```

After that, the Lua scripts will be ready to be used as filters. So next step is to add your Fluent bit [filter](https://docs.fluentbit.io/manual/concepts/data-pipeline/filter) to `config.filters` in values.yaml, for example:

```yaml
config:
  filters: |
    [FILTER]
        Name    lua
        Match   <your-tag>
        script  /fluent-bit/scripts/filter_example.lua
        call    filter_name
```

Under the hood, the chart will:

- Create a configmap using `luaScripts`.
- Add a volumeMounts for each Lua scripts using the path `/fluent-bit/scripts/<script>`.
- Add the Lua script's configmap as volume to the pod.

> [!NOTE]
> Remember to set the `script` attribute in the filter using `/fluent-bit/scripts/`, otherwise the file will not be found by fluent bit.
