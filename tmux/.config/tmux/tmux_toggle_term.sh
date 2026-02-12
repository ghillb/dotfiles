#!/bin/bash
# Toggle a floating terminal popup, keyed per base session.
#
# Usage:
#   tmux_toggle_term.sh <prefix> [command] [toggle-size]
#
# Examples:
#   tmux_toggle_term.sh ft                  # plain floating term
#   tmux_toggle_term.sh ft "" toggle-size   # toggle size of floating term
#   tmux_toggle_term.sh git "bash -i -c gg"  # floating neogit (always maximized)

PREFIX="${1:?usage: tmux_toggle_term.sh <prefix> [command] [toggle-size]}"
COMMAND="$2"
ACTION="$3"

CURRENT_SESSION="$(tmux display-message -p -F '#{session_name}')"

# If already inside a session with this prefix, detach
if [[ "$CURRENT_SESSION" == ${PREFIX}-* ]]; then
    tmux detach-client
    exit 0
fi

# Strip any prefix from current session name to get the real base
# (handles nested floating terms, e.g. being in ft-main and opening git)
BASE_SESSION="${CURRENT_SESSION}"
for p in ft git; do
    BASE_SESSION="${BASE_SESSION#${p}-}"
done

TARGET_SESSION="${PREFIX}-${BASE_SESSION}"
STATE_FILE="/tmp/tmux_float_${PREFIX}_maximized"

# Determine popup size
if [ "$ACTION" = "toggle-size" ]; then
    if [ -f "$STATE_FILE" ]; then
        rm "$STATE_FILE"
        SIZE_W="80%"; SIZE_H="80%"; BORDER=""
    else
        touch "$STATE_FILE"
        SIZE_W="100%"; SIZE_H="100%"; BORDER="-B"
    fi
elif [ -n "$COMMAND" ] || [ -f "$STATE_FILE" ]; then
    # Sessions with a command (git) always start maximized; plain ft respects state
    SIZE_W="100%"; SIZE_H="100%"; BORDER="-B"
else
    SIZE_W="80%"; SIZE_H="80%"; BORDER=""
fi

# Build the attach-or-new command
if [ -n "$COMMAND" ]; then
    SESSION_CMD="tmux attach-session -t '${TARGET_SESSION}' || tmux new-session -s '${TARGET_SESSION}' '${COMMAND}'"
else
    SESSION_CMD="tmux attach-session -t '${TARGET_SESSION}' || tmux new-session -s '${TARGET_SESSION}'"
fi

# shellcheck disable=SC2086
tmux popup -d '#{pane_current_path}' -w "$SIZE_W" -h "$SIZE_H" $BORDER -E "$SESSION_CMD"
