#!/usr/bin/env bash

set -e

# run terraform to spin up VM, etc
terraform apply

# run playbook to create fingerboard app container, etc
ansible-playbook -i environments/inventory.py ci.yml
