#!/usr/bin/env bash

set -e

if [ -z "$EMAIL" ]; then
	echo -e '\033[0;31mEMAIL environment variable must be specified\033[0;0m'
	exit 1
fi

docker run -ti \
	--rm \
	-v /etc/letsencrypt:/etc/letsencrypt \
	-v /etc/certbot/secrets:/etc/certbot/secrets \
	certbot/dns-digitalocean \
	certonly \
		--server https://acme-v02.api.letsencrypt.org/directory \
		--dns-digitalocean \
		--dns-digitalocean-credentials /etc/certbot/secrets/digitalocean.ini \
		--expand \
		--noninteractive \
		--agree-tos \
		--no-eff-email \
		--email "$EMAIL" \
		-d jonathan-boudreau.com \
		-d '*.jonathan-boudreau.com'
