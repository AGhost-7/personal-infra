#!/usr/bin/env bash

ansible-playbook -i ansible/contrib/inventory/digital_ocean.py gitlab.yml
