set windows-shell := ["pwsh", "-NoLogo", "-Command"]

default:
  just --list

fmt:
  rumdl fmt --fix

lint:
  rumdl check .

docs:
  helm-docs --template-files=./_templates.gotmpl --template-files=./_chart-readme.md.gotmpl
