#!/usr/bin/env python3

# simple script which searches for the first digitalocean tag that is specified
# as the first argument of this script and ssh's into the box.
# example usage: `./scripts/ssh.py gitlab`

from sys import argv
from os import execlp, environ
import requests

token = environ['DO_API_TOKEN']

headers = {
    'Authorization': 'Bearer {}'.format(token),
    'Content-Type': 'application/json'
}

tag = argv[1]

response = requests.get(
    'https://api.digitalocean.com/v2/droplets?tag_name={}'.format(tag),
    headers=headers)

droplets = response.json()['droplets']

ip = [
    network['ip_address']
    for network in droplets[0]['networks']['v4']
    if network['type'] == 'public'
][0]

port = 22
if tag == 'ci':
    port = 2222

# bit of syscall magic...
execlp(
    'ssh',
    'ssh',
    '-p', str(port),
    '-i', '{}/.ssh/do'.format(environ['HOME']),
    'root@{}'.format(ip))
