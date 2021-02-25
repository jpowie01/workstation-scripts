SYSTEM_PYTHON := python3.7
VENV_DIR := .venv
PYTHON := $(PWD)/$(VENV_DIR)/bin/python
ANSIBLE := $(PWD)/$(VENV_DIR)/bin/ansible
ANSIBLE_GALAXY := $(PWD)/$(VENV_DIR)/bin/ansible-galaxy
ANSIBLE_PLAYBOOK := $(PWD)/$(VENV_DIR)/bin/ansible-playbook

INVENTORY_FILE ?= inventory.yaml


#
# Environment for Ansible
#

.PHONY: devenv venv install_packages

devenv: venv install_packages

venv:
	$(SYSTEM_PYTHON) -m venv $(VENV_DIR)

install_packages:
	$(PYTHON) -m pip install -r requirements.txt
	$(ANSIBLE_GALAXY) install nvidia.nvidia_docker

#
# Ansible
#

.PHONY: inventory test_connection provision provision_kernel provision_packages \
		provision_nvidia provision_zsh provision_vim provision_ssh provision_docker \
		provision_nvidia_docker provision_ddns provision_wireguard

inventory:
	cp examples/inventory.yaml $(INVENTORY_FILE)

test_connection:
	$(ANSIBLE) workstation -i $(INVENTORY_FILE) -m ping

provision:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY_FILE) --ask-become-pass -vvv \
		playbooks/kernel.yaml playbooks/general.yaml playbooks/nvidia.yaml playbooks/zsh.yaml \
		playbooks/vim.yaml playbooks/ssh.yaml playbooks/docker.yaml playbooks/nvidia-docker.yaml \
		playbooks/ddns.yaml

provision_kernel:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY_FILE) --ask-become-pass -vvv playbooks/kernel.yaml

provision_general:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY_FILE) --ask-become-pass -vvv playbooks/general.yaml

provision_nvidia:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY_FILE) --ask-become-pass -vvv playbooks/nvidia.yaml

provision_zsh:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY_FILE) --ask-become-pass -vvv playbooks/zsh.yaml

provision_vim:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY_FILE) --ask-become-pass -vvv playbooks/vim.yaml

provision_ssh:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY_FILE) --ask-become-pass -vvv playbooks/ssh.yaml

provision_docker:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY_FILE) --ask-become-pass -vvv playbooks/docker.yaml

provision_nvidia_docker:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY_FILE) --ask-become-pass -vvv playbooks/nvidia-docker.yaml

provision_ddns:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY_FILE) --ask-become-pass -vvv playbooks/ddns.yaml

provision_wireguard:
	echo "WireGuard is still in development..."
	# $(ANSIBLE_PLAYBOOK) -i $(INVENTORY_FILE) --ask-become-pass -vvv playbooks/wireguard.yaml
