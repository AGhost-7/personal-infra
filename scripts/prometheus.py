#!/usr/bin/env python3

from subprocess import Popen
import requests
from os import environ

token = environ['DO_TOKEN']

headers = {
    'Authorization': 'Bearer {}'.format(token),
    'Content-Type': 'application/json'
}

response = requests.get(
    'https://api.digitalocean.com/v2/droplets?tag_name=data',
    headers=headers)

droplets = response.json()['droplets']
ip = droplets[0]['networks']['v4'][0]['ip_address']

tunnel = Popen([
    'ssh',
    '-i', '~/.ssh/do',
    '-L', '9090:localhost:9090',
    'root@{}'.format(ip),
    '-N'
])

try:
    print('Prometheus available on port 5601')
    tunnel.wait()
except KeyboardInterrupt:
    tunnel.kill()
    import sys
    sys.exit(0)
