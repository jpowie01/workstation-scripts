# Workstation management scripts

Collection of scripts that automates management of my GPU Workstation machine.

## A few words about my use case...

I love to be mobile. Using a single stationary PC on a daily basis is not possible in my case.
 Also, I don't want to run my deep learning workload on a notebook. It's stupid. Renting compute
 instances in the cloud is way too expesive to be sensible for personal projects use.

My solution for this problem was to build my custom GPU Workstation and treat it as a remote
 server, even though it sits underneath my desk.

### Hardware

My GPU Workstation has:
- AMD Ryzen 9 based on Zen 3 architecture,
- Nvidia RTX based on Ampere architecture,
- 64GB of DDR4 memory,
- storage based on NVMe Gen4.

I use MacBook Pro for daily use, main development and access to the Workstation.

## Prerequisites

1. Install Ubuntu Server 20.04.1 LTS on fresh disk.
2. Create user with your preferred name and add it to sudoers:

```bash
$ adduser <USERNAME>
$ usermod -aG sudo <USERNAME>
```

3. Add your public SSH key to newly created account:

```bash
$ scp ~/.ssh/id_rsa.pub <USERNAME>@<WORKSTATION_IP>:/tmp/key.pub
$ ssh <USERNAME>@<WORKSTATION_IP>
$ cat /tmp/key.pub >> ~/.ssh/authorized_keys
```

Do nothing more than that. Everything else is automated with Ansible.

## Virtual machine for experiments

Everyone makes mistakes, so let's be prepared for them to happen. I want to treat my Workstation
 as my "production"-like server and I don't want to run any script with fingers crossed that it
 won't break anything. That's why, I added simple Vagrantfile that should (more or less) help
 to develop new changes and help me find potential issues quickly in sandboxed environment.

To setup virtual machine, make sure that you're using proper versions of tools. I tested everything
 using these versions:
  - VirtualBox: 6.1.18,
  - Vagrant: 2.2.14.

Once you have done it, feel free to use your VM with:

```bash
$ vagrant up
$ ...  # Do whatever you want to do
$ vagrant halt
$ vagrant destroy
```

## Local environment

To allow for workstation provisioning, prepare your local environment with Ansible.

1. Create Python virtual environment, activate it and install all packages:

```bash
$ make venv
$ . .venv/bin/activate
(.venv) $ make install_packages
(.venv) $ ansible-galaxy install nvidia.nvidia_driver nvidia.nvidia_docker
```

2. Prepare your inventory file (default one works fine with Vagrant machine):

```bash
(.venv) $ make inventory
(.venv) $ vim inventory.yaml
```

3. Test your connection to the workstation:

```bash
(.venv) $ make test_connection
```

And now, you're good to go!

## Provisioning

To do the initial setup of workstation, use Makefile entrypoint that runs prepared Ansible Playbooks:

```bash
(.venv) $ make initial_setup
```

