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
VACUUM_FLAGS := -r config/ruleset-recommended.yaml -b -d 

build: $(SCHEMAS_FINAL)

dist:
	@mkdir -p dist

dist/%.yaml: $(ROOT)/%.yaml $(SCHEMAS) dist
	$(REDOCLY) bundle $(REDOCLY_FLAGS) $< --output=$@

.PHONY: lint
lint: $(SCHEMAS_FINAL)
	$(VACUUM) lint $(VACUUM_FLAGS) $(SCHEMAS_FINAL)
