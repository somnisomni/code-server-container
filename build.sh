#!/usr/bin/env bash

### [ somnisomni/code-server-container ]
### Simple Containerfile build script

IMAGE_TAG_NAME=somni-code-server

podman build --rm \
	--build-arg ARCH=$(dpkg --print-architecture) \
	--tag $IMAGE_TAG_NAME:latest \
	-f Containerfile \
	$(dirname $0)
