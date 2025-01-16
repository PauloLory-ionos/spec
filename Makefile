GO ?= go
VACUUM = github.com/daveshanley/vacuum@latest
ROOT = APISpec
SPEC = openapi.yaml
OUTPUT = /tmp/swagger.yaml

REDOCLY := npx @redocly/cli
REDOCLY_FLAGS := --remove-unused-components

SCHEMAS := $(shell find $(ROOT)/schemas -type file)
SCHEMAS_SOURCES := $(shell ls $(ROOT)/*.yaml)
SCHEMAS_FINAL = $(SCHEMAS_SOURCES:$(ROOT)/%.yaml=dist/%.yaml)

VACUUM := $(GO) run $(VACUUM)
VACUUM_FLAGS := -r config/ruleset-recommended.yaml

.PHONY: lint
lint:
	@cd $(ROOT) && $(GO) run $(VACUUM) lint -d $(SPEC)

# https://github.com/python-openapi/openapi-spec-validator
validate:
	cd $(ROOT) && openapi-spec-validator $(SPEC)

build:
	cd $(ROOT) && npx @redocly/cli bundle --remove-unused-components $(SPEC) --output=$(OUTPUT)

dist: prepare-dist $(SCHEMAS_FINAL)

prepare-dist:
	@mkdir -p dist

dist/%.yaml: $(ROOT)/%.yaml $(SCHEMAS)
	$(REDOCLY) bundle $(REDOCLY_FLAGS) $< --output=$@
	$(VACUUM) lint $(VACUUM_FLAGS) -d $@