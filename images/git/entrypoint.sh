#!/usr/bin/env bash

set -e

if [ ! -f /keys/ssh_host_rsa_key ]; then
	echo 'Could not find host keys, generating...'
	ssh-keygen -A
	find /etc/ssh -name 'ssh_host*' -exec mv {} /keys \;
fi

if [ ! -f /keys/authorized_keys/git ]; then
	echo 'Generating authorized_keys file'
	mkdir -p /keys/authorized_keys
	touch /keys/authorized_keys/git
fi

exec "$@"
