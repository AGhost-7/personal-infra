#!/usr/bin/env bash

set -e

# run terraform to spin up VM, etc
terraform apply

# run playbook to create fingerboard app container, etc
ansible-playbook -i ansible/contrib/inventory/digital_ocean.py fingerboard.yml
