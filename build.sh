#!/usr/bin/env bash

### [ somnisomni/docker-code-server ]
### Simple Dockerfile build script

IMAGE_TAG_NAME=somni-code-server

podman build --rm --build-arg ARCH=$(dpkg --print-architecture) --tag $IMAGE_TAG_NAME:latest $(dirname $0)
