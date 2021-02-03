SYSTEM_PYTHON := python3.7
VENV_DIR := .venv
PYTHON := $(PWD)/$(VENV_DIR)/bin/python
ANSIBLE := $(PWD)/$(VENV_DIR)/bin/ansible
ANSIBLE_GALAXY := $(PWD)/$(VENV_DIR)/bin/ansible-galaxy
ANSIBLE_PLAYBOOK := $(PWD)/$(VENV_DIR)/bin/ansible-playbook


#
# Environment for Ansible
#

.PHONY: devenv venv install_packages

devenv: venv install_packages

venv:
	$(SYSTEM_PYTHON) -m venv $(VENV_DIR)

install_packages:
	$(PYTHON) -m pip install -r requirements.txt
	$(ANSIBLE_GALAXY) install nvidia.nvidia_driver nvidia.nvidia_docker

#
# Ansible
#

.PHONY: inventory test_connection initial_setup

inventory:
	cp examples/inventory.yaml inventory.yaml

test_connection:
	$(ANSIBLE) workstation -i inventory.yaml -m ping

initial_setup:
	$(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/packages.yaml -vvv
	$(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/nvidia.yaml -vvv
	$(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/zsh.yaml -vvv
	$(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/ssh.yaml -vvv
	$(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/docker.yaml -vvv
	$(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/nvidia-docker.yaml -vvv
	$(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/ddns.yaml -vvv

	# WireGuard is still in development...
	# $(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/wireguard.yaml -vvv
