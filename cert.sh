#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
	echo -e '\033[0;31mEmail must be specified as the first parameter to this script\033[0;0m'
	exit 1
fi

docker run -ti \
	--rm \
	-p 6000:6000 \
	-v /etc/letsencrypt:/etc/letsencrypt \
	aghost7/certbot \
	certbot certonly \
		--standalone \
		--agree-tos \
		--preferred-challenges http \
		--http-01-port 6000 \
		--no-eff-email \
		--email "$1" \
		-d jonathan-boudreau.com \
		-d chat.jonathan-boudreau.com
