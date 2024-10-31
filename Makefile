GO ?= go
VACUUM = github.com/daveshanley/vacuum@latest
ROOT = APISpec
SPEC = openapi.yaml
OUTPUT = /tmp/swagger.yaml
.PHONY: lint
lint:
	cd $(ROOT) && @$(GO) run $(VACUUM) lint -d $(SPEC)

# https://github.com/python-openapi/openapi-spec-validator
validate:
	cd $(ROOT) && openapi-spec-validator $(SPEC)

build:
	cd $(ROOT) && npx @redocly/cli bundle --remove-unused-components $(SPEC) --output=$(OUTPUT)
