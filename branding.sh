#!/usr/bin/env bash

### [ somnisomni/code-server-container ]
### code-server custom branding script
### ... just for fun?

PRODUCT_JSON=/usr/local/bin/code-server/lib/vscode/product.json

echo "Applying custom branding"

sed -i 's/\"nameShort\": \"code-server\"/\"nameShort\": \"code-server-somni\"/g' $PRODUCT_JSON
sed -i 's/\"nameLong\": \"code-server\"/\"nameLong\": \"code-server-somni\"/g' $PRODUCT_JSON
sed -i 's/\"applicationName\": \"code-server\"/\"applicationName\": \"code-server-somni\"/g' $PRODUCT_JSON
sed -i 's/\"serverApplicationName\": \"code-server-oss\"/\"serverApplicationName\": \"code-server-somni\"/g' $PRODUCT_JSON
sed -i 's/\"win32NameVersion\": \"code-server\"/\"win32NameVersion\": \"code-server-somni\"/g' $PRODUCT_JSON
sed -i 's/\"win32ShellNameShort\": \"c&ode-server\"/\"win32ShellNameShort\": \"c\&ode-server-somni\"/g' $PRODUCT_JSON
