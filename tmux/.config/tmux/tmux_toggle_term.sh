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
CURRENT_CLIENT="$(tmux display-message -p -F '#{client_name}')"
CURRENT_TTY="$(tmux display-message -p -F '#{client_tty}')"
CURRENT_PATH="$(tmux display-message -p -F '#{pane_current_path}')"
POPUP_CLIENT=""
FLOAT_PREFIX=""
BASE_SESSION="$CURRENT_SESSION"

resolve_base_client() {
    local base_session="$1"
    local fallback_client=""
    local client_name client_tty client_session

    while IFS=$'\t' read -r client_name client_tty client_session; do
        [ "$client_name" = "$CURRENT_CLIENT" ] && continue
        [ "$client_session" = "$base_session" ] || continue

        if [ "$client_tty" = "$CURRENT_TTY" ]; then
            printf '%s\n' "$client_name"
            return
        fi

        if [ -z "$fallback_client" ]; then
            fallback_client="$client_name"
        fi
    done < <(tmux list-clients -F '#{client_name}\t#{client_tty}\t#{session_name}')

    [ -n "$fallback_client" ] && printf '%s\n' "$fallback_client"
}

case "$CURRENT_SESSION" in
    git-*)
        FLOAT_PREFIX="git"
        BASE_SESSION="${CURRENT_SESSION#git-}"
        ;;
    nvim-*)
        FLOAT_PREFIX="nvim"
        BASE_SESSION="${CURRENT_SESSION#nvim-}"
        ;;
    ft-*)
        FLOAT_PREFIX="ft"
        BASE_SESSION="${CURRENT_SESSION#ft-}"
        ;;
esac

# If already inside a session with this prefix, detach
if [ "$FLOAT_PREFIX" = "$PREFIX" ]; then
    tmux detach-client
    exit 0
fi

if [ -n "$FLOAT_PREFIX" ]; then
    BASE_CLIENT="$(resolve_base_client "$BASE_SESSION")"
    if [ -n "$BASE_CLIENT" ]; then
        POPUP_CLIENT="$BASE_CLIENT"
        CURRENT_PATH="$(tmux display-message -c "$BASE_CLIENT" -p -F '#{pane_current_path}')"
    fi

    # Minimize current float before opening the other float.
    tmux detach-client
fi

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
if [ -n "$POPUP_CLIENT" ]; then
    tmux popup -c "$POPUP_CLIENT" -d "$CURRENT_PATH" -w "$SIZE_W" -h "$SIZE_H" $BORDER -E "$SESSION_CMD"
else
    tmux popup -d "$CURRENT_PATH" -w "$SIZE_W" -h "$SIZE_H" $BORDER -E "$SESSION_CMD"
fi
