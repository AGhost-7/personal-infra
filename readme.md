This repo houses all of the containers for my portfolio site.

## Directory structure
The base directory structure is organized on the following way:
- `roles`: Ansible roles.
- `scripts`: Misc scripts.
- `*.yml`: Ansible playbooks.
- `main.tf`: Terraform configuration
- `modules`: Terraform modules.

## Setup
Clone and create the directory containing the inventory information:
```
git clone git@github.com:AGhost-7/personal-infra
cd personal-infra
mkdir environments
ansible-galaxy install -r requirements.yml
```

Create file under `environments/cloud/digitalocean.yml`:
```yaml
plugin: community.digitalocean.digitalocean
attributes:
  - id
  - name
  - networks
  - region
  - size_slug
  - tags
keyed_groups:
  - key: do_tags
    prefix: ''
    separator: ''

compose:
  ansible_host: do_networks.v4 | selectattr('type','eq','public')
    | map(attribute='ip_address') | first
  class: do_size.description | lower
  distro: do_image.distribution | lower
```

## Server Metrics
Metrics are pulled from [prometheus][prometheus]. They can be viewed using
grafana.

[prometheus]: https://prometheus.io
