
INVENTORY ?= inventory
PLAYBOOK ?= dev.yml
BECOME_FLAGS ?=
ANSIBLE_ARGS ?=

.PHONY: bootstrap lint syntax-check validate check audit-live install facts

bootstrap:
	ansible-galaxy collection install --requirements-file requirements.yml

lint:
	ansible-lint .

syntax-check:
	ansible-playbook --inventory $(INVENTORY) $(PLAYBOOK) --syntax-check $(ANSIBLE_ARGS)

validate:
	INVENTORY=$(INVENTORY) PLAYBOOK=$(PLAYBOOK) scripts/validate

check:
	ansible-playbook --inventory $(INVENTORY) $(PLAYBOOK) --check --diff $(BECOME_FLAGS) $(ANSIBLE_ARGS)

audit-live:
	scripts/audit-macos

install:
	ansible-playbook --inventory $(INVENTORY) $(PLAYBOOK) $(BECOME_FLAGS) $(ANSIBLE_ARGS)

facts:
	ansible all --inventory $(INVENTORY) --module-name setup
