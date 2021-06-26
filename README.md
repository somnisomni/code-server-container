# docker-code-server
Customized Docker image build files of [code-server](https://github.com/cdr/code-server).

## How to use
Just execute `$ docker build .` on root of the repository, or run `build.sh` script.
  
`build.sh` script will build the image with tag name `somni-code-server`.

## Customizations against vanilla image
  - Based on [latest Ubuntu LTS image](https://hub.docker.com/_/ubuntu)
  - Use `KST` timezone
  - `ko_KR` locale/language registered
  - `.NET SDK` preinstalled
  - `dpkg-dev` preinstalled for debian packaging development
  - Latest `GCC` and `build-essential` preinstalled
  - `Node.js` preinstalled using [`NVM`](https://nvm.sh)
  - Other various essential packages preinstalled, see [Dockerfile](Dockerfile)
  - [Branding](branding.sh)

## Port exposes
  - `code-server` itself : **8080**
  - Development server *<small>(e.g. Live Server)</small>* : **30000 - 30002**
