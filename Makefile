SHELL:=/bin/bash
include .env

EXAMPLE=$(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))

.PHONY: all clean validate test diagram docs format

all: validate test docs format

clean:
	rm -rf .terraform/

validate:
	$(ANSIBLE) ansible-playbook tests/default.yml --syntax-check

test: validate
	$(ANSIBLE) ansible-playbook tests/default.yml --skip-tags "production"

diagram:
	$(DIAGRAMS) diagram.py

docs: diagram
	$(ANSIBLE_AUTODOC)

format:
	$(ANSIBLE_LINT)

example:
	$(TERRAFORM) init examples/$(EXAMPLE) && $(TERRAFORM) plan -input=false examples/$(EXAMPLE)
