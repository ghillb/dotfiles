#!/bin/bash

DIRECTION=${1:-next}
CURRENT_SESSION=$(tmux display-message -p '#{session_name}')
CURRENT_CLIENT=$(tmux display-message -p '#{client_name}')
CURRENT_TTY=$(tmux display-message -p '#{client_tty}')
SESSION_FILTER='#{&&:#{&&:#{&&:#{!=:#{m:ft-*,#{session_name}},1},#{!=:#{m:git-*,#{session_name}},1}},#{!=:#{m:nvim-*,#{session_name}},1}},#{!=:#{m:bv-*,#{session_name}},1}}'
WORKSPACE_FORMAT='#{session_name} | #{?session_attached,ATTACHED,DETACHED} | #{?#{==:#{session_path},},-,#{b:session_path}} | win #{session_windows} | last #{t/p:session_activity}'

show_workspaces_popup() {
  tmux display-popup \
    -T "Workspaces" \
    -w 95% \
    -h 85% \
    -E "tmux choose-tree -s -O name -f '$SESSION_FILTER' -F '$WORKSPACE_FORMAT' \"switch-client -t '%%'\""
}

show_ports_popup() {
  local tmp_file
  tmp_file="$(mktemp /tmp/tmux-ports.XXXXXX)"

  local ports_cmd='if command -v ss >/dev/null 2>&1; then ss -ltnp; elif command -v lsof >/dev/null 2>&1; then lsof -nP -iTCP -sTCP:LISTEN; elif command -v netstat >/dev/null 2>&1; then netstat -lntp; else echo "No port inspection command found (ss/lsof/netstat)."; fi'
  bash -lc "$ports_cmd" >"$tmp_file" 2>&1

  local line_count max_cols
  line_count="$(wc -l < "$tmp_file" | tr -d ' ')"
  max_cols="$(awk '{ if (length > m) m = length } END { print (m ? m : 1) }' "$tmp_file")"

  [ -z "$line_count" ] && line_count=1
  [ -z "$max_cols" ] && max_cols=1

  local client_w client_h
  client_w="$(tmux display-message -p '#{client_width}')"
  client_h="$(tmux display-message -p '#{client_height}')"

  [ -z "$client_w" ] && client_w=160
  [ -z "$client_h" ] && client_h=48

  local min_w=40 min_h=8
  local max_w=$((client_w - 4))
  local max_h=$((client_h - 4))
  local desired_w=$((max_cols + 4))
  local desired_h=$((line_count + 4))
  local popup_w=$desired_w
  local popup_h=$desired_h

  [ "$max_w" -lt "$min_w" ] && max_w=$min_w
  [ "$max_h" -lt "$min_h" ] && max_h=$min_h

  [ "$popup_w" -lt "$min_w" ] && popup_w=$min_w
  [ "$popup_w" -gt "$max_w" ] && popup_w=$max_w
  [ "$popup_h" -lt "$min_h" ] && popup_h=$min_h
  [ "$popup_h" -gt "$max_h" ] && popup_h=$max_h

  tmux display-popup \
    -T "Ports" \
    -w "$popup_w" \
    -h "$popup_h" \
    -E "bash -lc 'trap \"rm -f -- $tmp_file\" EXIT; less -SR -- $tmp_file'"
}

case "$DIRECTION" in
  popup)
    show_workspaces_popup
    exit 0
    ;;
  ports)
    show_ports_popup
    exit 0
    ;;
esac

IS_FLOAT=false
BASE_SESSION="$CURRENT_SESSION"
case "$CURRENT_SESSION" in
  git-*|ft-*|nvim-*|bv-*)
    IS_FLOAT=true
    BASE_SESSION="${CURRENT_SESSION#git-}"
    BASE_SESSION="${BASE_SESSION#nvim-}"
    BASE_SESSION="${BASE_SESSION#ft-}"
    BASE_SESSION="${BASE_SESSION#bv-}"
    ;;
esac

mapfile -t SESSIONS < <(
  tmux list-sessions \
    -f '#{&&:#{&&:#{&&:#{!=:#{m:ft-*,#{session_name}},1},#{!=:#{m:git-*,#{session_name}},1}},#{!=:#{m:nvim-*,#{session_name}},1}},#{!=:#{m:bv-*,#{session_name}},1}}' \
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
