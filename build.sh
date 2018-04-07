#!/usr/bin/env bash

set -e

docker build --no-cache -t aghost7/ninja-chat images/chat
docker push aghost7/ninja-chat
