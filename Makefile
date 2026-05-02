# forge-finance

FORGE ?= forge

.PHONY: help install validate test clean

help:
	@echo "  make install    deploy and activate git hooks"
	@echo "  make validate   validate module structure"
	@echo "  make test       validate module"
	@echo "  make clean      remove build artifacts"

install:
	@command -v $(FORGE) >/dev/null 2>&1 \
	    || { echo "forge not found — ask an AI assistant to execute INSTALL.md"; exit 1; }
	git config core.hooksPath .githooks
	$(FORGE) install

validate:
	@bash .githooks/pre-commit

test: validate

clean:
	rm -rf build/
