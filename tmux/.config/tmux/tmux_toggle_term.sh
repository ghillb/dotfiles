#!/bin/bash
# Switch persistent tool sessions or toggle a floating terminal popup.
# `ft` is a per-base-session popup; git and nvim switch the outer client
# to a persistent session keyed by the original base pane.
#
# Usage:
#   tmux_toggle_term.sh <prefix> [command] [toggle-size] [prefill]
#
# Examples:
#   tmux_toggle_term.sh ft                    # plain floating term
#   tmux_toggle_term.sh ft "" toggle-size     # toggle size of floating term
#   tmux_toggle_term.sh git "bash -ic 'gg; exec bash -i'"
#   tmux_toggle_term.sh nvim nvim

PREFIX="${1:?usage: tmux_toggle_term.sh <prefix> [command] [toggle-size] [prefill]}"
COMMAND="$2"
ACTION="$3"
PREFILL="$4"

CURRENT_SESSION="$(tmux display-message -p -F '#{session_name}')"
CURRENT_CLIENT="$(tmux display-message -p -F '#{client_name}')"
CURRENT_PANE="$(tmux display-message -p -F '#{pane_id}')"
CURRENT_PATH="$(tmux display-message -p -F '#{pane_current_path}')"
DIRECT_CLIENT=""
CURRENT_MODE=""
BASE_SESSION="$CURRENT_SESSION"
BASE_PANE="$CURRENT_PANE"
PARENT_CLIENT=""

session_option() {
    local session_name="$1"
    local option_name="$2"
    tmux show-options -t "$session_name" -v "$option_name" 2>/dev/null || true
}

session_set_option() {
    local session_name="$1"
    local option_name="$2"
    local option_value="$3"
    tmux set-option -t "$session_name" "$option_name" "$option_value"
}

pane_is_alive() {
    local pane_id="$1"
    [ -n "$pane_id" ] || return 1
    tmux display-message -p -t "$pane_id" '#{pane_id}' >/dev/null 2>&1
}

is_direct_mode() {
    case "$1" in
        git|nvim) return 0 ;;
        *) return 1 ;;
    esac
}

case "$CURRENT_SESSION" in
    git-*|nvim-*|ft-*)
        CURRENT_MODE="${CURRENT_SESSION%%-*}"
        BASE_SESSION="$(session_option "$CURRENT_SESSION" '@base_session')"
        BASE_PANE="$(session_option "$CURRENT_SESSION" '@base_pane')"
        if [ "$CURRENT_MODE" = "ft" ]; then
            PARENT_CLIENT="$(session_option "$CURRENT_SESSION" '@parent_client')"
        fi
        ;;
esac

if [ -n "$CURRENT_MODE" ] && { [ -z "$BASE_SESSION" ] || [ -z "$BASE_PANE" ]; }; then
    tmux display-message "$CURRENT_MODE layer missing base_session/base_pane metadata"
    exit 1
fi

# The same shortcut returns from a direct mode or closes the popup.
if [ "$CURRENT_MODE" = "$PREFIX" ]; then
    if [ "$PREFIX" = "ft" ]; then
        tmux detach-client
        exit 0
    fi

    if pane_is_alive "$BASE_PANE"; then
        tmux switch-client -t "$BASE_PANE"
    elif tmux has-session -t "$BASE_SESSION" 2>/dev/null; then
        tmux switch-client -t "$BASE_SESSION"
    else
        tmux display-message "Base session is no longer available"
    fi
    exit 0
fi

if [ -n "$CURRENT_MODE" ]; then
    if pane_is_alive "$BASE_PANE"; then
        CURRENT_PATH="$(tmux display-message -p -t "$BASE_PANE" -F '#{pane_current_path}')"
    fi

    if [ "$CURRENT_MODE" = "ft" ] && is_direct_mode "$PREFIX"; then
        DIRECT_CLIENT="$PARENT_CLIENT"
        if [ -z "$DIRECT_CLIENT" ]; then
            tmux display-message "ft layer missing parent_client metadata"
            exit 1
        fi
    fi
fi

TARGET_KEY="${BASE_PANE#%}"
if [ "$PREFIX" = "ft" ]; then
    TARGET_KEY="$BASE_SESSION"
fi
TARGET_SESSION="${PREFIX}-${TARGET_KEY}"
STATE_FILE="/tmp/tmux_float_${PREFIX}_maximized"

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

session_set_option "$TARGET_SESSION" @base_session "$BASE_SESSION"
session_set_option "$TARGET_SESSION" @base_pane "$BASE_PANE"

if is_direct_mode "$PREFIX"; then
    if [ -n "$DIRECT_CLIENT" ]; then
        tmux switch-client -c "$DIRECT_CLIENT" -t "$TARGET_SESSION"
        tmux detach-client
    else
        tmux switch-client -t "$TARGET_SESSION"
    fi
    exit 0
fi

session_set_option "$TARGET_SESSION" @parent_client "$CURRENT_CLIENT"

# Determine popup size.
if [ "$ACTION" = "toggle-size" ]; then
    if [ -f "$STATE_FILE" ]; then
        rm "$STATE_FILE"
        SIZE_W="80%"; SIZE_H="80%"; BORDER=""
    else
        touch "$STATE_FILE"
        SIZE_W="100%"; SIZE_H="100%"; BORDER="-B"
    fi
elif [ -n "$COMMAND" ] || [ -n "$PREFILL" ] || [ -f "$STATE_FILE" ]; then
    SIZE_W="100%"; SIZE_H="100%"; BORDER="-B"
else
    SIZE_W="80%"; SIZE_H="80%"; BORDER=""
fi

SESSION_CMD="tmux attach-session -t '${TARGET_SESSION}'"

# shellcheck disable=SC2086
tmux popup -d "$CURRENT_PATH" -w "$SIZE_W" -h "$SIZE_H" $BORDER -E "$SESSION_CMD"
