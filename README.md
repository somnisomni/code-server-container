# somni-code-server
Customized container image build files of [code-server](https://github.com/cdr/code-server).

## How to use
Just execute `$ podman build .` on root of the repository, or run `build.sh` script.

`build.sh` script will build the image with tag name `somni-code-server`.

Podman is supported. Docker is may not supported.

## Customizations against vanilla image
  - Based on [latest Ubuntu LTS image](https://hub.docker.com/_/ubuntu)
  - Use `KST` timezone
  - `ko_KR` locale/language registered
  - `.NET SDK` preinstalled
  - `dpkg-dev` preinstalled for debian packaging development
  - Latest `GCC` and `build-essential` preinstalled
  - Latest `Node.js` LTS version preinstalled using [`NVM`](https://nvm.sh), Corepack enabled
  - Other various essential packages preinstalled, see [Dockerfile](Dockerfile)
  - [Branding](branding.sh)

## Port exposes
  - `code-server` itself : **8080**
  - Development server *<small>(e.g. Live Server)</small>* : **39001**, **39002**

## Note
**Huge image** *(about 1~2GB)* will be produced when build this customized Dockerfile
so I will not upload the image to any Docker repositories.

Please build locally if you want to use this.
