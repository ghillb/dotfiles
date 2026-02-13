#!/bin/bash
# Toggle a floating terminal popup, keyed per base session.
#
# Usage:
#   tmux_toggle_term.sh <prefix> [command] [toggle-size] [prefill]
#
# Examples:
#   tmux_toggle_term.sh ft                    # plain floating term
#   tmux_toggle_term.sh ft "" toggle-size     # toggle size of floating term
#   tmux_toggle_term.sh git "" "" "gg "       # prefill "gg " in prompt (no auto-execute)

PREFIX="${1:?usage: tmux_toggle_term.sh <prefix> [command] [toggle-size] [prefill]}"
COMMAND="$2"
ACTION="$3"
PREFILL="$4"

CURRENT_SESSION="$(tmux display-message -p -F '#{session_name}')"
CURRENT_PATH="$(tmux display-message -p -F '#{pane_current_path}')"

# If already inside a session with this prefix, detach
if [[ "$CURRENT_SESSION" == ${PREFIX}-* ]]; then
    tmux detach-client
    exit 0
fi

if [[ "$CURRENT_SESSION" == ft-* || "$CURRENT_SESSION" == git-* ]]; then
    tmux display-message "Nested floating terms are disabled"
    exit 0
fi

BASE_SESSION="${CURRENT_SESSION}"

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
elif [ -n "$COMMAND" ] || [ -n "$PREFILL" ] || [ -f "$STATE_FILE" ]; then
    # Sessions with a command or prefill start maximized; plain ft respects state
    SIZE_W="100%"; SIZE_H="100%"; BORDER="-B"
else
    SIZE_W="80%"; SIZE_H="80%"; BORDER=""
fi

if ! tmux has-session -t "$TARGET_SESSION" 2>/dev/null; then
    if [ -n "$COMMAND" ]; then
        tmux new-session -d -s "$TARGET_SESSION" -c "$CURRENT_PATH" "$COMMAND"
    else
        tmux new-session -d -s "$TARGET_SESSION" -c "$CURRENT_PATH"
    fi

    if [ -n "$PREFILL" ]; then
        tmux send-keys -t "$TARGET_SESSION" "$PREFILL" ""
    fi
fi

SESSION_CMD="tmux attach-session -t '${TARGET_SESSION}'"

# shellcheck disable=SC2086
tmux popup -d '#{pane_current_path}' -w "$SIZE_W" -h "$SIZE_H" $BORDER -E "$SESSION_CMD"
