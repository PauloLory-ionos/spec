GO ?= go
VACUUM = github.com/daveshanley/vacuum@latest
MD2HTML = github.com/gomarkdown/mdtohtml@latest
ROOT = spec
DIST = dist
DIST_ZIP = dist.zip
SPEC = openapi.yaml
OUTPUT = /tmp/swagger.yaml
ASSETS = assets
DOCS = docs
ASSETS_FILES = $(shell find $(ASSETS) -type f)
DOCS_FILES = $(shell find $(DOCS) -type f)
README = README.md
README_FINAL = $(DIST)/index.html

REDOCLY := npx @redocly/cli
REDOCLY_BUNDLE_FLAGS := --remove-unused-components
REDOCLY_DOCS_FLAGS := --disableGoogleFont

SCHEMAS := $(shell find $(ROOT)/schemas -type f)
SCHEMAS_SOURCES := $(shell ls $(ROOT)/*.yaml)
SCHEMAS_FINAL = $(SCHEMAS_SOURCES:$(ROOT)/%.yaml=$(DIST)/specs/%.yaml)

DOCS_FINAL = $(SCHEMAS_SOURCES:$(ROOT)/%.yaml=$(DIST)/%.html)

MD_FINAL = $(DOCS_FILES:$(DOCS)/%.md=$(DIST)/$(DOCS)/%.html)

VACUUM := $(GO) run $(VACUUM)
VACUUM_LINT_FLAGS := -r config/ruleset-recommended.yaml -b

all: $(DIST_ZIP)

$(DIST_ZIP): build
	rm -f $@
	cd $(DIST) && zip -r ../$@ *

build: $(DIST) $(SCHEMAS_FINAL) $(DOCS_FINAL) $(MD_FINAL) $(DIST)/index.html fix-links

fix-links:
	# Detect OS and set proper sed flags
	@if sed --version >/dev/null 2>&1; then \
		find $(DIST) -name '*.html' | xargs sed -i 's/\.md/.html/g'; \
		find $(DIST) -name '*.html' | xargs sed -i 's/<a /<a target="_blank" /g'; \
	else \
		find $(DIST) -name '*.html' | xargs sed -i '' 's/\.md/.html/g'; \
		find $(DIST) -name '*.html' | xargs sed -i '' 's/<a /<a target="_blank" /g'; \
	fi

$(DIST)/index.html: $(README)
	@mkdir -p $(DIST)
	$(GO) run $(MD2HTML) -headingids -css assets/github-markdown.css $< $@

$(DIST): $(ASSETS_FILES) 
	@mkdir -p $(DIST)/$(ASSETS)
	@find $(ASSETS) -type f -exec cp {} $(DIST)/$(ASSETS)/ \;

$(DIST)/specs/%.yaml: $(ROOT)/%.yaml $(SCHEMAS)
	@mkdir -p $(shell dirname $@)
	$(REDOCLY) bundle $(REDOCLY_BUNDLE_FLAGS) $< --output=$@

$(DIST)/%.html: $(ROOT)/%.yaml $(SCHEMAS)
	@mkdir -p $(shell dirname $@)
	$(REDOCLY) build-docs $(REDOCLY_DOCS_FLAGS) $< --output=$@

$(DIST)/$(DOCS)/%.html: $(DOCS)/%.md
	@mkdir -p $(shell dirname $@)
	$(GO) run $(MD2HTML) -headingids -css ../../assets/github-markdown.css $< $@

.PHONY: lint
lint: $(SCHEMAS_FINAL)
	$(VACUUM) lint $(VACUUM_LINT_FLAGS) $(SCHEMAS_FINAL)

.PHONY: lint-verbose
lint-verbose: $(SCHEMAS_FINAL)
	$(VACUUM) lint $(VACUUM_LINT_FLAGS) -d $(SCHEMAS_FINAL)

.PHONY: clean
clean:
	rm -rf $(DIST) $(DIST_ZIP)
