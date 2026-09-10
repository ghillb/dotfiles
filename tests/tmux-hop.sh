#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
readonly repo
readonly helper="$repo/bin/.local/bin/tmux-hop"
test_tmp="$(mktemp -d)"
tmux_socket="tmux-hop-test-$$"

cleanup() {
  /usr/bin/tmux -L "$tmux_socket" kill-server 2>/dev/null || true
  rm -rf -- "$test_tmp"
}
trap cleanup EXIT

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

mkdir -p "$test_tmp/bin"

cat >"$test_tmp/ssh-config" <<'EOF'
Host server
  HostName server.example
  User remote-user
EOF

cat >"$test_tmp/bin/ssh" <<'EOF'
#!/usr/bin/env bash
for arg in "$@"; do
  if [[ "$arg" == -G ]]; then
    exec /usr/bin/ssh "$@"
  fi
done
printf '%s\n' "$@" >"$TMUX_HOP_TEST_LOG"
printf '%s\n' "${TERM:-}" >"${TMUX_HOP_TEST_TERM_LOG:-/dev/null}"
exit "${TMUX_HOP_TEST_SSH_STATUS:-0}"
EOF
chmod +x "$test_tmp/bin/ssh"

TMUX_HOP_TEST_LOG="$test_tmp/ssh.log" \
  SSH_CONFIG="$test_tmp/ssh-config" \
  PATH="$test_tmp/bin:$PATH" \
  env -u TMUX "$helper" server

mapfile -t ssh_args <"$test_tmp/ssh.log"
[[ "${ssh_args[*]}" == "-F $test_tmp/ssh-config -tt -- server exec env LC_ALL=C.UTF-8 tmux new-session -A -s 'remote-user'" ]] ||
  fail "unexpected SSH invocation: ${ssh_args[*]}"

cat >"$test_tmp/bin/tmux" <<'EOF'
#!/usr/bin/env bash
case "$1" in
  display-message)
    case "$3" in
      '#{client_name}') printf '%s\n' '/dev/pts/9' ;;
      *) exit 64 ;;
    esac
    ;;
  list-sessions)
    if [[ ${TMUX_HOP_TEST_EXISTING:-} == true &&
      ${3:-} == $'#{session_name}\t#{@hop_host}\t#{@hop_session}' ]]; then
      printf 'hop-existing\tserver\tremote-work\n'
    fi
    ;;
  has-session) exit 1 ;;
  *)
    printf '%s' "$1" >>"$TMUX_HOP_TEST_TMUX_LOG"
    shift
    printf '\t%s' "$@" >>"$TMUX_HOP_TEST_TMUX_LOG"
    printf '\n' >>"$TMUX_HOP_TEST_TMUX_LOG"
    ;;
esac
EOF
chmod +x "$test_tmp/bin/tmux"

: >"$test_tmp/tmux.log"
TMUX_HOP_TEST_TMUX_LOG="$test_tmp/tmux.log" \
  TMUX_HOP_CLIENT=/dev/pts/9 \
  SSH_CONFIG="$test_tmp/ssh-config" \
  PATH="$test_tmp/bin:$PATH" \
  TMUX="$test_tmp/tmux-socket,123,0" \
  "$helper" server remote-work

tmux_calls=$(<"$test_tmp/tmux.log")
grep -Fq $'new-session\t-d\t-s\thop-server-remote-work\t-n\tssh' <<<"$tmux_calls" ||
  fail 'a managed hop session was not created'
grep -Fq $'set-option\t-t\thop-server-remote-work\tstatus\toff' <<<"$tmux_calls" ||
  fail 'the outer status line was not disabled'
grep -Fq $'set-option\t-t\thop-server-remote-work\tprefix\tNone' <<<"$tmux_calls" ||
  fail 'the outer prefix was not disabled'
grep -Fq $'set-option\t-t\thop-server-remote-work\tkey-table\thop' <<<"$tmux_calls" ||
  fail 'the hop key table was not selected'
grep -Fq $'set-option\t-t\thop-server-remote-work\tmouse\toff' <<<"$tmux_calls" ||
  fail 'outer mouse handling was not disabled'
grep -Fq $'set-option\t-t\thop-server-remote-work\tdetach-on-destroy\toff' <<<"$tmux_calls" ||
  fail 'the originating client would detach when the hop exits'
grep -Fq $'switch-client\t-c\t/dev/pts/9\t-t\t=hop-server-remote-work' <<<"$tmux_calls" ||
  fail 'the originating client was not switched to the hop session'
grep -Fq $'respawn-pane\t-k\t-t\thop-server-remote-work:1.1' <<<"$tmux_calls" ||
  fail 'the remote tmux connection was not started in the hop session'

: >"$test_tmp/tmux.log"
TMUX_HOP_TEST_TMUX_LOG="$test_tmp/tmux.log" \
  TMUX_HOP_TEST_EXISTING=true \
  TMUX_HOP_CLIENT=/dev/pts/9 \
  SSH_CONFIG="$test_tmp/ssh-config" \
  PATH="$test_tmp/bin:$PATH" \
  TMUX="$test_tmp/tmux-socket,123,0" \
  "$helper" server remote-work

tmux_calls=$(<"$test_tmp/tmux.log")
[[ "$tmux_calls" == $'switch-client\t-c\t/dev/pts/9\t-t\t=hop-existing' ]] ||
  fail "existing hop session was not reused: $tmux_calls"

TMUX_HOP_TEST_LOG="$test_tmp/ssh.log" \
  SSH_CONFIG="$test_tmp/ssh-config" \
  PATH="$test_tmp/bin:$PATH" \
  env -u TMUX "$helper" 'host~alias.example' remote-user

mapfile -t ssh_args <"$test_tmp/ssh.log"
[[ "${ssh_args[*]}" == "-F $test_tmp/ssh-config -tt -- host~alias.example exec env LC_ALL=C.UTF-8 tmux new-session -A -s 'remote-user'" ]] ||
  fail "valid SSH alias was rejected: ${ssh_args[*]}"

/usr/bin/tmux -L "$tmux_socket" \
  -f "$repo/tmux/.config/tmux/tmux.conf" \
  new-session -d -s verify 'sleep 30'
hop_keys=$(/usr/bin/tmux -L "$tmux_socket" list-keys -T hop)
grep -Fq 'C-M-Up' <<<"$hop_keys" || fail 'hop sessions cannot select the previous workspace'
grep -Fq 'C-M-Down' <<<"$hop_keys" || fail 'hop sessions cannot select the next workspace'
grep -Fq 'User2' <<<"$hop_keys" || fail 'hop sessions cannot open the session-based SSH picker'
grep -Fq 'User3' <<<"$hop_keys" || fail 'hop sessions cannot open the window-based SSH picker'
[[ "$(wc -l <<<"$hop_keys")" -eq 4 ]] || fail 'the hop key table intercepts unrelated remote keys'
grep -Fq 'TMUX_HOP_CLIENT' <<<"$hop_keys" ||
  fail 'hop picker bindings do not preserve the originating client'
root_keys=$(/usr/bin/tmux -L "$tmux_socket" list-keys -T root)
grep 'User2' <<<"$root_keys" | grep -Fq 'TMUX_HOP_CLIENT' ||
  fail 'session-based picker does not preserve the originating client'
grep 'User3' <<<"$root_keys" | grep -Fq 'TMUX_HOP_CLIENT' ||
  fail 'window-based picker does not preserve the originating client'

printf 'tmux-hop tests passed.\n'
