# docker-code-server
Customized Docker image build files of [code-server](https://github.com/cdr/code-server).

## How to use
 Just execute `$ docker build .` on root of the repository, or run `build.sh` script.
  
 `build.sh` script will build the image with tag name `somni-code-server`.

## Port exposes
  - `code-server` itself : **8080**
  - Development server *<small>(e.g. Live Server)</small>* : **30000 - 30002**
