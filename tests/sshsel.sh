#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
readonly repo
readonly picker="$repo/bin/.local/bin/sshsel"
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
Host usable usable-alt
  HostName usable.example
  User alice
  Port 2222

Host x
  HostName short.example
  User bob

Host tunnel
  HostName tunnel.example
  DynamicForward 5555

Host restricted
  HostName restricted.example
  SessionType none

Host git-transport
  HostName github.com
  User git

Host *
  User fallback
EOF

cat >"$test_tmp/bin/fzf" <<'EOF'
#!/usr/bin/env bash
for arg in "$@"; do
  [[ "$arg" != --expect=* ]] || exit 64
done
input=$(cat)
printf '%s\n' "$input" >"$SSHSEL_TEST_CHOICES"
printf '%s\n' "$input" | head -n 1
EOF

cat >"$test_tmp/bin/ssh" <<'EOF'
#!/usr/bin/env bash
for arg in "$@"; do
  if [[ "$arg" == -G ]]; then
    exec /usr/bin/ssh "$@"
  fi
done
printf '%s\n' "$@" >"$SSHSEL_TEST_SSH_LOG"
EOF

cat >"$test_tmp/bin/tmux-hop" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@" >"$SSHSEL_TEST_TMUX_HOP_LOG"
EOF
chmod +x "$test_tmp/bin/fzf" "$test_tmp/bin/ssh" "$test_tmp/bin/tmux-hop"

SSH_CONFIG="$test_tmp/ssh-config" \
  SSHSEL_TEST_CHOICES="$test_tmp/choices.log" \
  SSHSEL_TEST_SSH_LOG="$test_tmp/ssh.log" \
  PATH="$test_tmp/bin:$PATH" \
  "$picker"

mapfile -t choices <"$test_tmp/choices.log"
[[ ${#choices[@]} -eq 2 ]] || fail "expected two usable hosts, got: ${choices[*]}"
[[ "${choices[0]}" == $'usable\tusable  alice@usable.example:2222' ]] ||
  fail "unexpected long-host row: ${choices[0]}"
[[ "${choices[1]}" == $'x\tx       bob@short.example:22' ]] ||
  fail "short host is not aligned: ${choices[1]}"

mapfile -t ssh_args <"$test_tmp/ssh.log"
[[ "${ssh_args[*]}" == "-F $test_tmp/ssh-config -- usable" ]] ||
  fail "Enter did not launch plain SSH: ${ssh_args[*]}"

SSH_CONFIG="$test_tmp/ssh-config" \
  SSHSEL_TEST_CHOICES="$test_tmp/choices.log" \
  SSHSEL_MODE=tmux-hop \
  SSHSEL_TEST_TMUX_HOP_LOG="$test_tmp/tmux-hop.log" \
  PATH="$test_tmp/bin:$PATH" \
  "$picker"

mapfile -t tmux_hop_args <"$test_tmp/tmux-hop.log"
[[ "${tmux_hop_args[*]}" == usable ]] ||
  fail "Enter in hop mode did not launch tmux-hop: ${tmux_hop_args[*]}"

printf 'sshsel tests passed.\n'
