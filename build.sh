#!/usr/bin/env bash

### [ somnisomni/docker-code-server ]
### Simple Dockerfile build script

IMAGE_TAG_NAME=somni-code-server

docker build --tag $IMAGE_TAG_NAME:latest $(dirname $0)
