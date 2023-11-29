
project_name := whylogs_container_types
src := $(shell find $(project_name)/ -name "*.py" -type f)

.PHONY: all

all: build

build: $(src)
	poetry build

publish: build
	poetry publish

lint: ## Check for type issues with pyright
	poetry run pyright

test: ## Run unit tests
	poetry run pytest

format: ## Check for formatting issues
	poetry run black --check $(project_name)
	poetry run autoflake --check --in-place --remove-unused-variables $(src)

format-fix: ## Fix formatting issues
	poetry run black $(project_name)
	poetry run autoflake --in-place --remove-unused-variables $(src)

help: ## Show this help message.
	@echo 'usage: make [target] ...'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:(.*) ##\ (.+)' ${MAKEFILE_LIST} | sed -s 's/:\(.*\)##/: ##/' | column -t -c 2 -s ':#'
