#!/usr/bin/env bash

set -xeo pipefail

k3s crictl ps --state exited -q | xargs --no-run-if-empty k3s crictl rm

k3s crictl ps -q | while read line; do
	k3s crictl inspect --template '{{.info.config.image.image}}' --output go-template $line
done > /tmp/used-images

k3s crictl images -q | while read line; do
	if ! grep -q "$line" /tmp/used-images; then
		k3s crictl rmi "$line"
	fi
done
