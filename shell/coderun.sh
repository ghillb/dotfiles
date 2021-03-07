#!/bin/sh

FULL=$(realpath "$1")
DIRECTORY=$(dirname "$1")
FILE=$(basename "$1")
NAME="${FILE%.*}"
EXTENSION=$(printf '%s' "$FILE" | sed -e "s/^$NAME\.*//" -e 's/+/p/g' -e 's/-/_/g')
eval "$(eval "printf '%s' \"\$CODERUN_$EXTENSION\"")"
exit 0

