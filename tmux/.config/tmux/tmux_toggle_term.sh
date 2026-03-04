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
#   tmux_toggle_term.sh bv "" "" "bv "        # prefill "bv " in prompt (no auto-execute)

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

normalize_path() {
    local path="$1"
    [ -z "$path" ] && {
        printf '\n'
        return
    }

    if command -v realpath >/dev/null 2>&1; then
        realpath -m -- "$path" 2>/dev/null && return
    fi

    if [ -d "$path" ]; then
        (cd "$path" 2>/dev/null && pwd -P) && return
    fi

    printf '%s\n' "${path%/}"
}

is_parent_path() {
    local parent="$1"
    local child="$2"

    [ -z "$parent" ] && return 1
    [ -z "$child" ] && return 1

    [ "$parent" = "$child" ] && return 0
    case "$child" in
        "$parent"/*) return 0 ;;
    esac
    return 1
}

repo_root_for_path() {
    local path="$1"
    [ -z "$path" ] && {
        printf '\n'
        return
    }
    [ -d "$path" ] || {
        printf '\n'
        return
    }

    git -C "$path" rev-parse --show-toplevel 2>/dev/null || printf '\n'
}

focus_git_window_for_path() {
    local target_session="$1"
    local target_path="$2"

    [ "$PREFIX" = "git" ] || return 0
    [ -n "$target_path" ] || return 0

    local target_path_normalized
    target_path_normalized="$(normalize_path "$target_path")"
    local target_base
    target_base="$(basename "$target_path_normalized")"
    local target_repo_root
    target_repo_root="$(normalize_path "$(repo_root_for_path "$target_path_normalized")")"

    local matched_pane=""
    local matched_window_index=""
    local pane_id window_index pane_path pane_path_normalized pane_repo_root
    local pane_rows
    pane_rows="$(tmux list-panes -s -t "$target_session" -F '#{pane_id}|#{window_index}|#{pane_current_path}')"

    # 1) Exact normalized path match
    while IFS='|' read -r pane_id window_index pane_path; do
        pane_path_normalized="$(normalize_path "$pane_path")"
        if [ "$pane_path_normalized" = "$target_path_normalized" ]; then
            matched_pane="$pane_id"
            matched_window_index="$window_index"
            break
        fi
    done <<< "$pane_rows"

    # 2) Parent-path match (pick the deepest ancestor for best locality)
    if [ -z "$matched_pane" ]; then
        local best_parent_len=0
        local candidate_len=0
        while IFS='|' read -r pane_id window_index pane_path; do
            pane_path_normalized="$(normalize_path "$pane_path")"
            if is_parent_path "$pane_path_normalized" "$target_path_normalized"; then
                candidate_len=${#pane_path_normalized}
                if [ "$candidate_len" -gt "$best_parent_len" ]; then
                    best_parent_len="$candidate_len"
                    matched_pane="$pane_id"
                    matched_window_index="$window_index"
                fi
            fi
        done <<< "$pane_rows"
    fi

    # 3) Same git repository root
    if [ -z "$matched_pane" ] && [ -n "$target_repo_root" ]; then
        while IFS='|' read -r pane_id window_index pane_path; do
            pane_path_normalized="$(normalize_path "$pane_path")"
            pane_repo_root="$(normalize_path "$(repo_root_for_path "$pane_path_normalized")")"
            if [ -n "$pane_repo_root" ] && [ "$pane_repo_root" = "$target_repo_root" ]; then
                matched_pane="$pane_id"
                matched_window_index="$window_index"
                break
            fi
        done <<< "$pane_rows"
    fi

    # 4) Basename fallback
    if [ -z "$matched_pane" ]; then
        while IFS='|' read -r pane_id window_index pane_path; do
            if [ "$(basename "$(normalize_path "$pane_path")")" = "$target_base" ]; then
                matched_pane="$pane_id"
                matched_window_index="$window_index"
                break
            fi
        done <<< "$pane_rows"
    fi

    if [ -z "$matched_pane" ]; then
        local window_name
        window_name="$target_base"
        [ -n "$window_name" ] || window_name="shell"
        matched_pane="$(tmux new-window -d -P -F '#{pane_id}' -t "$target_session" -c "$target_path" -n "$window_name")"
        matched_window_index="$(tmux display-message -p -t "$matched_pane" '#{window_index}')"
    fi

    if [ -n "$matched_pane" ]; then
        [ -n "$matched_window_index" ] && tmux select-window -t "${target_session}:${matched_window_index}"
        tmux select-pane -t "$matched_pane"
    fi
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
    bv-*)
        FLOAT_PREFIX="bv"
        BASE_SESSION="${CURRENT_SESSION#bv-}"
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

focus_git_window_for_path "$TARGET_SESSION" "$CURRENT_PATH"

SESSION_CMD="tmux attach-session -t '${TARGET_SESSION}'"

# shellcheck disable=SC2086
if [ -n "$POPUP_CLIENT" ]; then
    tmux popup -c "$POPUP_CLIENT" -d "$CURRENT_PATH" -w "$SIZE_W" -h "$SIZE_H" $BORDER -E "$SESSION_CMD"
else
    tmux popup -d "$CURRENT_PATH" -w "$SIZE_W" -h "$SIZE_H" $BORDER -E "$SESSION_CMD"
fi
