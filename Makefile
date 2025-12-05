# This is an example Makefile template for Python. You can adapt it for any other
# language by changing what commands are written for each target.

# Type 'make' to see the help target in use.

# the SHELL defaults to /bin/sh which may vary depending on OS
SHELL=/bin/bash

# the help target should always come first so that it is the default target
# the .PHONY boilerplate is required for each target unless it correlates to a real file name.
# See the Makefile documentation. 
.PHONY: help
help:  ## Print this message
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-24s\033[0m %s\n", $$1, $$2}'


.PHONY: deps
deps:  ## Install all dependencies
	pip install -U pip
	pip install -r requirements.txt


.PHONY: test
test:  ## Run the test suite
	python -m unittest .


.PHONY: lint
lint:  ## Run the code formatter(s)
	black .
	flake8 .
	mypy .


.PHONY: setup
setup:  ## Prepare the application to run
	echo 'build a docker image'