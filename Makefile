SYSTEM_PYTHON := python3.7
VENV_DIR := .venv
PYTHON := $(PWD)/$(VENV_DIR)/bin/python

#
# Environment for Ansible
#

.PHONY: venv install_packages

venv:
	$(SYSTEM_PYTHON) -m venv $(VENV_DIR)
	$(MAKE) install_packages

install_packages:
	$(PYTHON) -m pip install -r requirements.txt

#
# Ansible
#

.PHONY: inventory test_connection initial_setup

inventory:
	cp examples/inventory.yaml inventory.yaml

test_connection:
	ansible workstation -i inventory.yaml -m ping

initial_setup:
	ansible-playbook -i inventory.yaml playbooks/packages.yaml -vvv
	ansible-playbook -i inventory.yaml playbooks/nvidia.yaml -vvv
	ansible-playbook -i inventory.yaml playbooks/zsh.yaml -vvv
	ansible-playbook -i inventory.yaml playbooks/ssh.yaml -vvv
	ansible-playbook -i inventory.yaml playbooks/docker.yaml -vvv
	ansible-playbook -i inventory.yaml playbooks/nvidia-docker.yaml -vvv
	ansible-playbook -i inventory.yaml playbooks/ddns.yaml -vvv

	# Wireshark is still in development...
	# ansible-playbook -i inventory.yaml playbooks/wireguard.yaml -vvv
