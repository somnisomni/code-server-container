#!/usr/bin/env bash

### [ somnisomni/docker-code-server ]
### code-server custom branding script
### ... just for fun?

sed -i 's/\"code-server\"/\"code-server-somni\"/g' /usr/local/bin/code-server/lib/vscode/product.json
