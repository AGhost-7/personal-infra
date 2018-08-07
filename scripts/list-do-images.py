#!/usr/bin/env python3

# This script lists all digital ocean images. Useful if you built a packer
# image a while back and don't have the id for use with terraform.

import requests
from os import environ

token = environ['DO_TOKEN']

headers = {
    'Authorization': 'Bearer {}'.format(token),
    'Content-Type': 'application/json'
}

response = requests.get(
    'https://api.digitalocean.com/v2/snapshots', headers=headers)

for snapshot in response.json()['snapshots']:
    print('Name: {}, ID: {}'.format(snapshot['name'], snapshot['id']))
