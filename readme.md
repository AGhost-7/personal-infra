This repo houses all of the containers for my portfolio site.

The host uses the following packer build to run on digital ocean:

https://github.com/AGhost-7/digitalocean-image-docker

## Directory structure
The base directory structure is organized on the following way:
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

## Setup
Clone and create the directory containing the inventory information:
```
git clone git@github.com:AGhost-7/personal-infra
cd personal-infra
git submodule --init update
mkdir environments
# symlink the dynamic inventory script
ln -s '../ansible/contrib/inventory/digital_ocean.py' environments/inventory.py
```

## Server Metrics
Right now, I have a fairly simple setup for metrics. [Prometheus][prometheus]
is listening on localhost, which I access using an ssh tunnel:

```
ssh -L 9090:localhost:9090 <address> -N
```

Also, since each server has a [netdata][netdata] daemon running, you can access
more granular (up to the second) metrics on the target machine:
```
ssh -L 19999:localhost:19999 <address> -N
```

[netdata]: https://github.com/firehol/netdata
[prometheus]: https://prometheus.io
