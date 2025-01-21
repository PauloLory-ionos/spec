GO ?= go
VACUUM = github.com/daveshanley/vacuum@latest
MD2HTML = github.com/gomarkdown/mdtohtml@latest
ROOT = spec
DIST = dist
SPEC = openapi.yaml
OUTPUT = /tmp/swagger.yaml
ASSETS = assets
DOCS = docs
ASSETS_FILES = $(shell find $(ASSETS) -type file)
DOCS_FILES = $(shell find $(DOCS) -type file)
README = README.md
README_FINAL = $(DIST)/index.html

REDOCLY := npx @redocly/cli
REDOCLY_BUNDLE_FLAGS := --remove-unused-components
REDOCLY_DOCS_FLAGS := --disableGoogleFont

SCHEMAS := $(shell find $(ROOT)/schemas -type file)
SCHEMAS_SOURCES := $(shell ls $(ROOT)/*.yaml)
SCHEMAS_FINAL = $(SCHEMAS_SOURCES:$(ROOT)/%.yaml=$(DIST)/specs/%.yaml)

DOCS_FINAL = $(SCHEMAS_SOURCES:$(ROOT)/%.yaml=$(DIST)/%.html)

MD_FINAL = $(DOCS_FILES:$(DOCS)/%.md=$(DIST)/$(DOCS)/%.html)

VACUUM := $(GO) run $(VACUUM)
VACUUM_LINT_FLAGS := -r config/ruleset-recommended.yaml -b -d

build: $(DIST) $(SCHEMAS_FINAL) $(MD_FINAL) $(README_FINAL)/ fix-links $(DOCS_FINAL)

fix-links:
	# link to html instead of md
	@find $(DIST) -type f -name '*.html' -exec sed -i '' -e 's/\.md/.html/g' {} \;
	# links should open new tabs
	@find $(DIST) -type f -name '*.html' -exec sed -i '' -e 's/<a /<a target="_blank" /g' {} \;

$(DIST): $(ASSETS_FILES) 
	@-mkdir -p $(DIST)/$(ASSETS)
	cp -r $(ASSETS)/*.png $(DIST)/$(ASSETS)/
	cp -r $(ASSETS)/*.css $(DIST)/$(ASSETS)/

$(DIST)/specs/%.yaml: $(ROOT)/%.yaml $(SCHEMAS)
	@-mkdir -p $(shell dirname $@)
	$(REDOCLY) bundle $(REDOCLY_BUNDLE_FLAGS) $< --output=$@

$(DIST)/%.html: $(ROOT)/%.yaml $(SCHEMAS)
	@-mkdir -p $(shell dirname $@)
	$(REDOCLY) build-docs $(REDOCLY_DOCS_FLAGS) $< --output=$@

$(DIST)/$(DOCS)/%.html: $(DOCS)/%.md
	@-mkdir -p $(shell dirname $@)
	$(GO) run $(MD2HTML) -headingids -css ../../assets/github-markdown.css $< $@

$(README_FINAL): $(README)
	@-mkdir -p $(shell dirname $@)
	$(GO) run $(MD2HTML) -headingids -css assets/github-markdown.css $< $@

.PHONY: lint
lint: $(SCHEMAS_FINAL)
	$(VACUUM) lint $(VACUUM_LINT_FLAGS) $(SCHEMAS_FINAL)

.PHONY: clean
clean:
	rm -rf $(DIST)

dist.zip: build
	zip -r dist.zip $(DIST)
