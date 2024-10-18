GO ?= go
VACUUM = github.com/daveshanley/vacuum@latest
SPEC = APISpec/openapi.yaml

.PHONY: lint
lint:
	@$(GO) run $(VACUUM) lint -d $(SPEC)
