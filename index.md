# Fluent Helm Repository

![Fluentd](https://www.fluentd.org/assets/img/miscellany/fluentd-logo_2x.png)
![Fluent Bit](https://fluentbit.io/assets/img/logo1-default.png)

## Add the Fluent Helm repository

```sh
helm repo add fluent https://fluent.github.io/helm-charts
```

## Install Fluentd

```sh
helm upgrade -i fluentd fluent/fluentd
```

For more details on installing FluentD please see the [chart's README](https://github.com/fluent/helm-charts/tree/master/charts/fluentd).

## Install Fluent Bit

```sh
helm upgrade -i fluent-bit fluent/fluent-bit
```

For more details on installing Fluent Bit please see the [chart's README](https://github.com/fluent/helm-charts/tree/master/charts/fluent-bit).
