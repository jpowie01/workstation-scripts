# Workstation management scripts

Collection of scripts that automates management of my GPU Workstation.

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

### What have I done?

This repository contains Ansible Playbooks that manage:
 - Nvidia Drivers with CUDA support and utilities,
 - Docker with Docker-Compose and Nvidia support,
 - SSH server with additional protection against potential attacks,
 - Dynamic DNS through DuckDNS service, so that I will be able to access my workstation remotely
   without needs for static IP from my ISP,
 - ZSH with my preferred setup,
 - various APT packages that I use on a daily basis (Python, VIM, etc.).

I still have to work on VPN configuration, so that I will be protected on additional level.

## Prerequisites

1. Install Ubuntu Server 20.04.1 LTS on fresh disk.
2. Create user with your preferred name.
3. Assign static IP that matches your network topology.
4. During (or after) installation configure proper public key for SSH access.

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

1. Create Python virtual environment with all required packages:

```bash
$ make devenv
```

2. Prepare your inventory file (default one works fine with Vagrant machine):

```bash
$ make inventory
$ vim inventory.yaml
```

3. Test your connection to the workstation:

```bash
$ make test_connection
```

And now, you're good to go!

## Provisioning

To provision the Workstation, use Makefile entrypoint that runs prepared Ansible Playbooks:

```bash
$ make provision
```

## Easier access to Workstation

### SSH Config

I like to simplify access to remote machines by adding them to my `~/.ssh/config`:

```
Host workstation
    HostName LOCAL_IP_ADDRESS
    User USERNAME
    Port 22
    IdentityFile ~/.ssh/workstation.key

Host workstation_with_mlflow
    HostName LOCAL_IP_ADDRESS
    User USERNAME
    Port 22
    LocalForward 5000 localhost:5000
    IdentityFile ~/.ssh/workstation.key
```

Thanks to that, I can access them with:

```bash
$ ssh workstation
```

### SSH File System (SSHFS)

Accessing, copying and viewing multiple files on a remote machine may slow down work significatly.
 To speed up my workflow, I set up SSHFS on my notebook that allows me to access remote file
 system through SSH tunnel:

```bash
$ sudo mkdir /Volumes/Workstation
$ sudo sshfs workstation:~ /Volumes/Workstation -o Workstation
```
