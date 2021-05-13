This repo houses all of the containers for my portfolio site.

## Directory structure
The base directory structure is organized on the following way:
- `roles`: Ansible roles.
- `scripts`: Misc scripts.
- `ansible`: Git submodule which is included for the digital ocean dynamic
inventory that is part of the ansible contrib.
- `*.yml`: Ansible playbooks.
- `main.tf`: Terraform configuration
- `modules`: Terraform modules.

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
Metrics are pulled from [prometheus][prometheus]. They can be viewed using
grafana.

[prometheus]: https://prometheus.io
