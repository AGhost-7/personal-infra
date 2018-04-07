#!/usr/bin/env bash

set -e

docker build --no-cache -t aghost7/ninja-chat -f chat.docker .
docker push aghost7/ninja-chat
