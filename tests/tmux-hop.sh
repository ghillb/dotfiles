#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
readonly repo
readonly helper="$repo/bin/.local/bin/tmux-hop"
test_tmp="$(mktemp -d)"

cleanup() {
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
      '#{session_name}') printf '%s\n' 'local work' ;;
      '#{client_tty}') printf '%s\n' '/dev/pts/9' ;;
      '#{client_termname}') printf '%s\n' 'alacritty' ;;
      *) exit 64 ;;
    esac
    ;;
  detach-client)
    printf '%s\n' "$3" >"$TMUX_HOP_TEST_DETACH_LOG"
    bash -c "$5"
    ;;
  -S)
    printf '%s\n' "$@" >"$TMUX_HOP_TEST_ATTACH_LOG"
    ;;
  *) exit 65 ;;
esac
EOF
chmod +x "$test_tmp/bin/tmux"

: >"$test_tmp/ssh.log"
TMUX_HOP_TEST_LOG="$test_tmp/ssh.log" \
  TMUX_HOP_TEST_DETACH_LOG="$test_tmp/detach.log" \
  TMUX_HOP_TEST_ATTACH_LOG="$test_tmp/attach.log" \
  TMUX_HOP_TEST_TERM_LOG="$test_tmp/term.log" \
  TMUX_HOP_TEST_SSH_STATUS=42 \
  SSH_CONFIG="$test_tmp/ssh-config" \
  PATH="$test_tmp/bin:$PATH" \
  TMUX="$test_tmp/tmux socket,123,0" \
  "$helper" server remote-work

[[ "$(<"$test_tmp/detach.log")" == /dev/pts/9 ]] ||
  fail 'the current tmux client was not detached'

mapfile -t ssh_args <"$test_tmp/ssh.log"
[[ "${ssh_args[*]}" == "-F $test_tmp/ssh-config -tt -- server exec env LC_ALL=C.UTF-8 tmux new-session -A -s 'remote-work'" ]] ||
  fail "unexpected handoff SSH invocation: ${ssh_args[*]}"
[[ "$(<"$test_tmp/term.log")" == alacritty ]] ||
  fail 'the SSH client did not inherit the original terminal type'

mapfile -t attach_args <"$test_tmp/attach.log"
[[ "${attach_args[*]}" == "-S $test_tmp/tmux socket attach-session -t =local work" ]] ||
  fail "the original local session was not reattached: ${attach_args[*]}"

TMUX_HOP_TEST_LOG="$test_tmp/ssh.log" \
  SSH_CONFIG="$test_tmp/ssh-config" \
  PATH="$test_tmp/bin:$PATH" \
  env -u TMUX "$helper" 'host~alias.example' remote-user

mapfile -t ssh_args <"$test_tmp/ssh.log"
[[ "${ssh_args[*]}" == "-F $test_tmp/ssh-config -tt -- host~alias.example exec env LC_ALL=C.UTF-8 tmux new-session -A -s 'remote-user'" ]] ||
  fail "valid SSH alias was rejected: ${ssh_args[*]}"

printf 'tmux-hop tests passed.\n'
