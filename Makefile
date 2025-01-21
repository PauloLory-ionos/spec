GO ?= go
VACUUM = github.com/daveshanley/vacuum@latest
ROOT = spec
DIST = dist
SPEC = openapi.yaml
OUTPUT = /tmp/swagger.yaml
ASSETS = assets
DOCS = docs
ASSETS_FILES = $(shell find $(ASSETS) -type file)
DOCS_FILES = $(shell find $(DOCS) -type file)
README = README.md

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

$(DIST): $(README) $(ASSETS_FILES) $(DOCS_FILES)
	@mkdir -p $(DIST)
	cp $(README) $(DIST)
	cp -r $(ASSETS) $(DIST)
	cp -r $(DOCS) $(DIST)

$(DIST)/%.yaml: $(ROOT)/%.yaml $(SCHEMAS) $(DIST)
	$(REDOCLY) bundle $(REDOCLY_BUNDLE_FLAGS) $< --output=$@

$(DIST)/%.html: $(DIST)/%.yaml $(SCHEMAS) $(DIST)
	$(REDOCLY) build-docs $(REDOCLY_DOCS_FLAGS) $< --output=$@

.PHONY: lint
lint: $(SCHEMAS_FINAL)
	$(VACUUM) lint $(VACUUM_LINT_FLAGS) $(SCHEMAS_FINAL)

.PHONY: clean
clean:
	rm -rf $(DIST)
