#!/bin/sh

DIRECTORY=$(dirname "$1")
FILE=$(basename "$1")
FULL="$DIRECTORY/$FILE"
NAME="${FILE%.*}"
EXTENSION=$(printf '%s' "$FILE" | sed -e "s/^$NAME\.*//" -e 's/+/p/g' -e 's/-/_/g')
eval "$(eval "printf '%s' \"\$CODERUN_$EXTENSION\"")"
exit 0
