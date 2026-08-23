#!/usr/bin/env bash
set -euo pipefail

if [[ ${TMUX_TOGGLE_TEST_FAKE:-0} == 1 && ${0##*/} == tmux ]]; then
  printf '%q ' "$@" >>"$TMUX_TOGGLE_TEST_LOG"
  printf '\n' >>"$TMUX_TOGGLE_TEST_LOG"

  case "$1" in
    display-message)
      case "${*: -1}" in
        '#{session_name}') printf '%s\n' "${TMUX_TOGGLE_TEST_SESSION:-gh}" ;;
        '#{client_name}') printf '%s\n' "${TMUX_TOGGLE_TEST_CLIENT:-client0}" ;;
        '#{pane_id}') printf '%s\n' "${TMUX_TOGGLE_TEST_PANE:-%1}" ;;
        '#{pane_current_path}') printf '%s\n' "${TMUX_TOGGLE_TEST_PATH:-/repo}" ;;
      esac
      ;;
    has-session)
      exit "${TMUX_TOGGLE_TEST_TARGET_MISSING:-1}"
      ;;
    show-options)
      case "${*: -1}" in
        '@base_session') printf '%s\n' "${TMUX_TOGGLE_TEST_BASE_SESSION:-}" ;;
        '@base_pane') printf '%s\n' "${TMUX_TOGGLE_TEST_BASE_PANE:-}" ;;
        '@parent_client') printf '%s\n' "${TMUX_TOGGLE_TEST_PARENT_CLIENT:-}" ;;
      esac
      ;;
  esac
  exit 0
fi

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
SUBJECT=$SCRIPT_DIR/../tmux_toggle_term.sh
CONFIG=$SCRIPT_DIR/../tmux.conf
TEST_TMP=$(mktemp -d)
trap 'rm -rf -- "$TEST_TMP"' EXIT
ln -s "$SCRIPT_DIR/${BASH_SOURCE[0]##*/}" "$TEST_TMP/tmux"

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

assert_logged() {
  local pattern=$1
  grep -Eq -- "$pattern" "$TMUX_TOGGLE_TEST_LOG" ||
    fail "expected command matching: $pattern"
}

assert_not_logged() {
  local pattern=$1
  if grep -Eq -- "$pattern" "$TMUX_TOGGLE_TEST_LOG"; then
    fail "unexpected command matching: $pattern"
  fi
}

test_direct_mode_switches_outer_client() {
  export TMUX_TOGGLE_TEST_FAKE=1
  export TMUX_TOGGLE_TEST_LOG=$TEST_TMP/tmux.log
  : >"$TMUX_TOGGLE_TEST_LOG"

  PATH=$TEST_TMP:$PATH "$SUBJECT" git "bash -ic 'gg; exec bash -i'"

  assert_logged '^new-session .*git-1'
  assert_logged '^switch-client -t git-1 '
  assert_not_logged '^popup '
}

test_direct_mode_switches_outer_client
printf 'PASS: direct mode switches outer client\n'

test_same_mode_returns_to_base_pane() {
  export TMUX_TOGGLE_TEST_SESSION=git-1
  export TMUX_TOGGLE_TEST_BASE_SESSION=gh
  export TMUX_TOGGLE_TEST_BASE_PANE=%1
  : >"$TMUX_TOGGLE_TEST_LOG"

  PATH=$TEST_TMP:$PATH "$SUBJECT" git "bash -ic 'gg; exec bash -i'"

  assert_logged '^switch-client -t %1 '
  assert_not_logged '^detach-client '
}

test_same_mode_returns_to_base_pane
printf 'PASS: same mode returns to base pane\n'

test_direct_modes_switch_without_returning_to_base() {
  export TMUX_TOGGLE_TEST_SESSION=git-1
  export TMUX_TOGGLE_TEST_BASE_SESSION=gh
  export TMUX_TOGGLE_TEST_BASE_PANE=%1
  : >"$TMUX_TOGGLE_TEST_LOG"

  PATH=$TEST_TMP:$PATH "$SUBJECT" nvim nvim

  assert_logged '^switch-client -t nvim-1 '
  assert_not_logged '^detach-client '
  assert_not_logged '^popup '
}

test_direct_modes_switch_without_returning_to_base
printf 'PASS: direct modes switch without returning to base\n'

test_float_opens_over_direct_mode() {
  export TMUX_TOGGLE_TEST_SESSION=git-1
  export TMUX_TOGGLE_TEST_BASE_SESSION=gh
  export TMUX_TOGGLE_TEST_BASE_PANE=%1
  : >"$TMUX_TOGGLE_TEST_LOG"

  PATH=$TEST_TMP:$PATH "$SUBJECT" ft

  assert_logged '^popup '
  assert_logged '^set-option -t ft-gh @parent_client client0 '
  assert_not_logged '^detach-client '
  assert_not_logged '^switch-client '
}

test_float_opens_over_direct_mode
printf 'PASS: floating terminal opens over direct mode\n'

test_float_toggle_only_detaches_popup_client() {
  export TMUX_TOGGLE_TEST_SESSION=ft-gh
  export TMUX_TOGGLE_TEST_BASE_SESSION=gh
  export TMUX_TOGGLE_TEST_BASE_PANE=%1
  : >"$TMUX_TOGGLE_TEST_LOG"

  PATH=$TEST_TMP:$PATH "$SUBJECT" ft

  assert_logged '^detach-client '
  assert_not_logged '^switch-client '
}

test_float_toggle_only_detaches_popup_client
printf 'PASS: floating terminal toggle only detaches popup client\n'

test_direct_mode_from_float_switches_parent_client() {
  export TMUX_TOGGLE_TEST_SESSION=ft-gh
  export TMUX_TOGGLE_TEST_BASE_SESSION=gh
  export TMUX_TOGGLE_TEST_BASE_PANE=%1
  export TMUX_TOGGLE_TEST_PARENT_CLIENT=outer
  : >"$TMUX_TOGGLE_TEST_LOG"

  PATH=$TEST_TMP:$PATH "$SUBJECT" git "bash -ic 'gg; exec bash -i'"

  assert_logged '^switch-client -c outer -t git-1 '
  assert_logged '^detach-client '
  assert_not_logged '^popup '
}

test_direct_mode_from_float_switches_parent_client
printf 'PASS: direct mode from floating terminal switches parent client\n'

test_mode_bindings_use_direct_session_helper() {
  grep -Eq '^bind -n C-M-g run-shell .*tmux_toggle_term\.sh git ' "$CONFIG" ||
    fail 'Ctrl+Alt+G no longer invokes git mode'
  grep -Eq '^bind -n C-M-n run-shell .*tmux_toggle_term\.sh nvim ' "$CONFIG" ||
    fail 'Ctrl+Alt+N no longer invokes nvim mode'
}

test_mode_bindings_use_direct_session_helper
printf 'PASS: direct mode bindings remain configured\n'

test_session_picker_filters_internal_sessions() {
  local picker_binding
  picker_binding=$(grep '^bind -n C-M-Space ' "$CONFIG")

  for pattern in 'ft-*' 'git-*' 'nvim-*'; do
    [[ $picker_binding == *"$pattern"* ]] ||
      fail "Ctrl+Alt+Space no longer filters $pattern sessions"
  done
}

test_session_picker_filters_internal_sessions
printf 'PASS: session picker filters internal mode sessions\n'

test_alt_drag_selects_rectangle() {
  local mouse_bindings
  mouse_bindings=$(
    local validation_socket="tmux-toggle-test-$$-$RANDOM"
    trap 'tmux -L "$validation_socket" kill-server 2>/dev/null || true' EXIT
    tmux -L "$validation_socket" -f /dev/null new-session -d -s validation
    tmux -L "$validation_socket" source-file "$CONFIG"
    tmux -L "$validation_socket" list-keys -T copy-mode-vi | grep 'M-MouseDrag' || true
  )

  [[ $mouse_bindings == *'M-MouseDrag1Pane'*'begin-selection'*'rectangle-on'* ]] ||
    fail 'Alt+drag does not begin rectangular selection'
  [[ $mouse_bindings == *'M-MouseDragEnd1Pane'*'copy-pipe-and-cancel'* ]] ||
    fail 'Alt+drag release does not copy and exit'
}

test_alt_drag_selects_rectangle
printf 'PASS: Alt+drag selects a rectangle\n'

test_alt_drag_enters_rectangle_from_live_pane() {
  local mouse_binding
  mouse_binding=$(
    local validation_socket="tmux-toggle-test-$$-$RANDOM"
    trap 'tmux -L "$validation_socket" kill-server 2>/dev/null || true' EXIT
    tmux -L "$validation_socket" -f /dev/null new-session -d -s validation
    tmux -L "$validation_socket" source-file "$CONFIG"
    tmux -L "$validation_socket" list-keys -T root | grep 'M-MouseDrag1Pane' || true
  )

  [[ $mouse_binding == *'copy-mode -M'*'rectangle-on'* ]] ||
    fail 'Alt+drag from a live pane does not enter rectangular copy mode'
}

test_alt_drag_enters_rectangle_from_live_pane
printf 'PASS: Alt+drag enters rectangular copy mode from a live pane\n'
