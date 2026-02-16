#!/bin/bash

DIRECTION=${1:-next}
CURRENT_SESSION=$(tmux display-message -p '#{session_name}')
CURRENT_CLIENT=$(tmux display-message -p '#{client_name}')
CURRENT_TTY=$(tmux display-message -p '#{client_tty}')

IS_FLOAT=false
BASE_SESSION="$CURRENT_SESSION"
case "$CURRENT_SESSION" in
  git-*|ft-*|nvim-*)
    IS_FLOAT=true
    BASE_SESSION="${CURRENT_SESSION#git-}"
    BASE_SESSION="${BASE_SESSION#nvim-}"
    BASE_SESSION="${BASE_SESSION#ft-}"
    ;;
esac

mapfile -t SESSIONS < <(
  tmux list-sessions \
    -f '#{&&:#{&&:#{!=:#{m:ft-*,#{session_name}},1},#{!=:#{m:git-*,#{session_name}},1}},#{!=:#{m:nvim-*,#{session_name}},1}}' \
    -F '#{session_name}'
)

TOTAL=${#SESSIONS[@]}
[ "$TOTAL" -eq 0 ] && exit 1

LINE=-1
for i in "${!SESSIONS[@]}"; do
  if [ "${SESSIONS[$i]}" = "$BASE_SESSION" ]; then
    LINE=$i
    break
  fi
done
[ "$LINE" -lt 0 ] && exit 1

if [ "$DIRECTION" = "prev" ]; then
  TARGET_INDEX=$(( (LINE - 1 + TOTAL) % TOTAL ))
else
  TARGET_INDEX=$(( (LINE + 1) % TOTAL ))
fi
TARGET="${SESSIONS[$TARGET_INDEX]}"

if [ -n "$TARGET" ]; then
  if [ "$IS_FLOAT" = true ]; then
    BASE_CLIENT=""
    FALLBACK_CLIENT=""
    while IFS=$'\t' read -r CLIENT_NAME CLIENT_TTY CLIENT_SESSION; do
      [ "$CLIENT_NAME" = "$CURRENT_CLIENT" ] && continue
      [ "$CLIENT_SESSION" = "$BASE_SESSION" ] || continue

      if [ "$CLIENT_TTY" = "$CURRENT_TTY" ]; then
        BASE_CLIENT="$CLIENT_NAME"
        break
      fi

      if [ -z "$FALLBACK_CLIENT" ]; then
        FALLBACK_CLIENT="$CLIENT_NAME"
      fi
    done < <(tmux list-clients -F '#{client_name}\t#{client_tty}\t#{session_name}')

    if [ -z "$BASE_CLIENT" ]; then
      BASE_CLIENT="$FALLBACK_CLIENT"
    fi

    if [ -n "$BASE_CLIENT" ]; then
      tmux switch-client -c "$BASE_CLIENT" -t "$TARGET"
    fi
    tmux detach-client
  else
    tmux switch-client -t "$TARGET"
  fi
fi
