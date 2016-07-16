#!/usr/bin/env bash

set -e

cache="$1"

build-image() {
	if [ "$cache" == "--no-cache" ]; then
		docker build --no-cache -t "portfolio-$1" -f "$1.docker" .
	else
		docker build -t "portfolio-$1" -f "$1.docker" .
	fi

	docker tag "portfolio-$1" "localhost:5000/$1"
	docker push "localhost:5000/$1"
}

build-image base
build-image mongodb
build-image node-shop
build-image postgres
