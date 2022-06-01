#!/usr/bin/env bash

### [ somnisomni/docker-code-server ]
### code-server custom branding script
### ... just for fun?

sed -i 's/\"nameShort\": \"code-server\"/\"nameShort\": \"code-server-somni\"/g' /usr/local/bin/code-server/lib/vscode/product.json
sed -i 's/\"nameLong\": \"code-server\"/\"nameLong\": \"code-server-somni\"/g' /usr/local/bin/code-server/lib/vscode/product.json
sed -i 's/\"applicationName\": \"code-server\"/\"applicationName\": \"code-server-somni\"/g' /usr/local/bin/code-server/lib/vscode/product.json
sed -i 's/\"serverApplicationName\": \"code-server-oss\"/\"serverApplicationName\": \"code-server-somni\"/g' /usr/local/bin/code-server/lib/vscode/product.json

