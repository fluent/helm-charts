# Contributing Guidelines

Please follow the guidelines here to interact with this project; if in doubt please start by opening an [issue](#issues).

## Community Requirements

This project is released with a [Contributor Covenant](https://www.contributor-covenant.org). By participating in this project you agree to abide by its [code of conduct](./CODE_OF_CONDUCT.md).

## Issues

Issues are the default method of interacting with this project, please open an issue if you'd like to report a bug, request a feature or ask a question.

## Pull Requests

A pull request should only be opened once there is an issue that has triaged by a maintainer, this is intended to ensure that contributions that cannot be accepted don't waste the contributor's time. In order to make pull requests easier to review and merge, please ensure that each pull request only contains changes to a single chart or is a version bump for a single image.

> [!NOTE]
> To make changes to the _fluent-operator_ Helm chart, please submit changes to the [fluent/fluent-operator](https://github.com/fluent/fluent-operator/) repository; the chart in this repository will be synced whenever there is a new release for _fluent-operator_.

### PR Checklist

The following steps need to be completed before submitting a PR for review.

- Make sure any change to _values.yaml_ has an updated [helm-docs](https://github.com/norwoodj/helm-docs) comment
- Run `helm-docs --template-files=./_templates.gotmpl --template-files=./_chart-readme.md.gotmpl` or if you have [Just](https://just.systems/man/en/) installed `just docs`
- Add an entry (or multiple entries) to the _CHANGELOG.md_ file in the chart directory
- Format the markdown using `rumdl fmt --fix` or if you have [Just](https://just.systems/man/en/) installed `just fmt`
- Sign off your commits as described [below](#sign-off-your-work)
- Make sure the PR closes the issue

#### Sign off Your Work

The Developer Certificate of Origin (DCO) is a lightweight way for contributors to certify that they wrote or otherwise have the right to submit the code they are contributing to the project. Here is the full text of the [DCO](http://developercertificate.org/). Contributors must sign-off that they adhere to these requirements by adding a `Signed-off-by` line to commit messages.

```text
This is my commit message

Signed-off-by: Random J Developer <random@developer.example.org>
```

See `git help commit`:

```text
-s, --signoff
    Add Signed-off-by line by the committer at the end of the commit log
    message. The meaning of a signoff depends on the project, but it typically
    certifies that committer has the rights to submit this work under the same
    license and agrees to a Developer Certificate of Origin (see
    http://developercertificate.org/ for more information).
```
