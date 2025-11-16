#!/bin/bash

DIRECTION=${1:-next}
CURRENT=$(tmux display-message -p '#{session_name}')
SESSIONS=$(tmux list-sessions -f '#{!=:#{session_name},floating_term}' -F '#{session_name}')
TOTAL=$(echo "$SESSIONS" | wc -l)

# Get current session line number
LINE=$(echo "$SESSIONS" | grep -n "^$CURRENT\$" | cut -d: -f1)
[ -z "$LINE" ] && exit 1  # Session not found

if [ "$DIRECTION" = "prev" ]; then
  if [ "$LINE" -gt 1 ]; then
    TARGET=$(echo "$SESSIONS" | sed -n "$((LINE-1))p")
  else
    TARGET=$(echo "$SESSIONS" | tail -1)
  fi
else
  if [ "$LINE" -lt "$TOTAL" ]; then
    TARGET=$(echo "$SESSIONS" | sed -n "$((LINE+1))p")
  else
    TARGET=$(echo "$SESSIONS" | head -1)
  fi
fi

[ -n "$TARGET" ] && tmux switch-client -t "$TARGET"
