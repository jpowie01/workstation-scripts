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

.PHONY: inventory test_connection provision provision_packages provision_nvidia provision_zsh \
	    provision_vim provision_ssh provision_docker provision_nvidia_docker provision_ddns \
		provision_wireguard

inventory:
	cp examples/inventory.yaml inventory.yaml

test_connection:
	$(ANSIBLE) workstation -i inventory.yaml -m ping

provision: provision_packages provision_nvidia provision_zsh provision_vim provision_ssh \
	       provision_docker provision_nvidia_docker provision_ddns provision_wireguard

provision_packages:
	$(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/packages.yaml -vvv

provision_nvidia:
	$(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/nvidia.yaml -vvv

provision_zsh:
	$(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/zsh.yaml -vvv

provision_vim:
	$(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/vim.yaml -vvv

provision_ssh:
	$(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/ssh.yaml -vvv

provision_docker:
	$(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/docker.yaml -vvv

provision_nvidia_docker:
	$(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/nvidia-docker.yaml -vvv

provision_ddns:
	$(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/ddns.yaml -vvv

provision_wireguard:
	echo "WireGuard is still in development..."
	# $(ANSIBLE_PLAYBOOK) -i inventory.yaml playbooks/wireguard.yaml -vvv
