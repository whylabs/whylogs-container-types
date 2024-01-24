project_name := whylogs_container_types
src := $(shell find $(project_name)/ -name "*.py" -type f)

.PHONY: dist build publish lint test lint-fix format format-fix fix help clean

dist: build

install: ## Install dependencies
	poetry install --extras llm

clean: ## Clean up build artifacts
	rm -rf dist

build: $(src)
	poetry build

publish: build
	poetry publish

test: ## Run unit tests
	poetry run pytest

lint: ## Check for type issues with pyright
	@{ echo "Running pyright\n"; poetry run pyright; PYRIGHT_EXIT_CODE=$$?; } ; \
	{ echo "\nRunning ruff check\n"; poetry run ruff check; RUFF_EXIT_CODE=$$?; } ; \
	exit $$(($$PYRIGHT_EXIT_CODE + $$RUFF_EXIT_CODE))

lint-fix:
	poetry run ruff check --fix

format: ## Check for formatting issues
	poetry run ruff format --check

format-fix: ## Fix formatting issues
	poetry run ruff format

fix: lint-fix format-fix ## Fix all linting and formatting issues

help: ## Show this help message.
	@echo 'usage: make [target] ...'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:(.*) ##\ (.+)' ${MAKEFILE_LIST} | sed -s 's/:\(.*\)##/: ##/' | column -t -c 2 -s ':#'
