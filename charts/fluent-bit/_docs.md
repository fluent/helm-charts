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
