GO ?= go
VACUUM = github.com/daveshanley/vacuum@latest
ROOT = APISpec
SPEC = openapi.yaml
OUTPUT = /tmp/swagger.yaml

REDOCLY := npx @redocly/cli
REDOCLY_FLAGS := --remove-unused-components
SCHEMAS := $(shell find $(ROOT)/schemas -type file)

.PHONY: lint
lint:
	@cd $(ROOT) && $(GO) run $(VACUUM) lint -d $(SPEC)

# https://github.com/python-openapi/openapi-spec-validator
validate:
	cd $(ROOT) && openapi-spec-validator $(SPEC)

build:
	cd $(ROOT) && npx @redocly/cli bundle --remove-unused-components $(SPEC) --output=$(OUTPUT)

dist: prepare-dist \
	  dist/regional.foundation-compute.v1.yaml \
	  dist/regional.foundation-network.v1.yaml

prepare-dist:
	@mkdir -p dist

dist/regional.foundation-compute.v1.yaml: $(ROOT)/regional.foundation-compute.v1.yaml $(SCHEMAS)
	$(REDOCLY) bundle $(REDOCLY_FLAGS) $< --output=$@
	$(GO) run $(VACUUM) lint -d $@

dist/regional.foundation-network.v1.yaml: $(ROOT)/regional.foundation-network.v1.yaml $(SCHEMAS)
	$(REDOCLY) bundle $(REDOCLY_FLAGS) $< --output=$@
	$(GO) run $(VACUUM) lint -d $@
