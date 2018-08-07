This repo houses all of the containers for my portfolio site.

The host uses the following packer build to run on digital ocean:

https://github.com/AGhost-7/digitalocean-image-docker

## Directory structure
The base directory structure is organised on the following way:
- `images`: Docker images.
- `roles`: Ansible roles.
- `files`: Misc files.
- `scripts`: Misc scripts.
- `ansible`: Git submodule which is included for the digital ocean dynamic
inventory that is part of the ansible contrib.
- `*.sh`: Scripts which manage both the infrastructure (through terraform) and
host/application side (through ansible) side. For example, the `gitlab.sh`
script handles creating the virtual machine, creating the container, adding the
address to the load balancer, and reloading gitlab if configuration changes are
made.
- `docker-compose.*.yml`: Files used for docker compose which manages
remaining legacy setup.
- `*.yml`: Ansible playbooks.
- `main.tf`: Terraform configuration
