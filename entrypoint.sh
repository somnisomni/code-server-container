#!/usr/bin/env bash

### [ somnisomni/code-server-container ]
### code-server entrypoint script

set -eu

echo "=== code-server ENTRYPOINT ==="
echo "  \$CODE_DATA = $CODE_DATA"
echo "  \$PATH = $PATH"
echo "  Current user  = $(id -un)"
echo "  Current group = $(id -gn)"
echo "  Entrypoint arguments = ${@}"
echo

dumb-init fixuid -q /usr/bin/code-server $(echo "${@}" | sed -e "s|{0}|$CODE_DATA|g" | sed -e "s|{1}|$CODE_EXTENSIONS|g")
