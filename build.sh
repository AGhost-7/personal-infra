#!/usr/bin/env bash

set -e

docker build -t aghost7/ninja-chat -f chat.docker .
docker push aghost7/ninja-chat

