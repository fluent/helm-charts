# Fluent Helm Repository

![Fluent Bit](https://fluentbit.io/assets/img/logo1-default.png)

## Add the Fluent Helm repository

```sh
helm repo add fluent https://fluent.github.io/helm-charts
```

## Install Fluent Bit

```sh
helm upgrade -i fluent-bit fluent/fluent-bit
```

For more details on installing Fluent Bit please see the [chart's README](https://github.com/fluent/helm-charts/tree/master/charts/fluent-bit).

## License

[Apache 2.0 License](https://www.apache.org/licenses/LICENSE-2.0)
