GO ?= go
VACUUM = github.com/daveshanley/vacuum@latest
ROOT = APISpec
DIST = dist
SPEC = openapi.yaml
OUTPUT = /tmp/swagger.yaml

REDOCLY := npx @redocly/cli
REDOCLY_BUNDLE_FLAGS := --remove-unused-components
REDOCLY_DOCS_FLAGS := --disableGoogleFont

SCHEMAS := $(shell find $(ROOT)/schemas -type file)
SCHEMAS_SOURCES := $(shell ls $(ROOT)/*.yaml)
SCHEMAS_FINAL = $(SCHEMAS_SOURCES:$(ROOT)/%.yaml=$(DIST)/%.yaml)

DOCS_FINAL = $(SCHEMAS_SOURCES:$(ROOT)/%.yaml=$(DIST)/%.html)

VACUUM := $(GO) run $(VACUUM)
VACUUM_LINT_FLAGS := -r config/ruleset-recommended.yaml -b -d

build: $(SCHEMAS_FINAL) $(DOCS_FINAL)

$(DIST):
	@mkdir -p $(DIST)

$(DIST)/%.yaml: $(ROOT)/%.yaml $(SCHEMAS) $(DIST)
	$(REDOCLY) bundle $(REDOCLY_BUNDLE_FLAGS) $< --output=$@

$(DIST)/%.html: $(DIST)/%.yaml $(SCHEMAS) $(DIST)
	$(REDOCLY) build-docs $(REDOCLY_DOCS_FLAGS) $< --output=$@

.PHONY: lint
lint: $(SCHEMAS_FINAL)
	$(VACUUM) lint $(VACUUM_LINT_FLAGS) $(SCHEMAS_FINAL)
