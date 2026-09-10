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

Host other
  HostName other.example
  User other-user
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
if [[ ${TMUX_HOP_TEST_WAIT:-} == true ]]; then
  exec sleep 60
fi
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
/usr/bin/tmux -L "$tmux_socket" \
  new-session -d -e SSH_CONNECTION='client 1 server 22' -s verify-ssh 'sleep 30'
local_status=$(/usr/bin/tmux -L "$tmux_socket" display-message -p -t verify:1.1 '#{E:status-right}')
ssh_status=$(/usr/bin/tmux -L "$tmux_socket" display-message -p -t verify-ssh:1.1 '#{E:status-right}')
grep -Fq '#[bg=colour239]#[fg=colour246] verify@' <<<"$local_status" ||
  fail 'local status location does not retain its muted style'
grep -Fq '#[bg=colour239]#[fg=] verify-ssh@' <<<"$ssh_status" ||
  fail 'SSH status location text does not use the SSH accent color'
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
grep 'User2' <<<"$root_keys" | grep -Fq 'SSHSEL_MODE=tmux-hop' ||
  fail 'session-based picker does not default Enter to tmux-hop'
grep 'User3' <<<"$root_keys" | grep -Fq 'SSHSEL_MODE=ssh' ||
  fail 'window-based picker does not default Enter to plain SSH'
grep 'User2' <<<"$hop_keys" | grep -Fq 'SSHSEL_MODE=tmux-hop' ||
  fail 'nested session picker does not default Enter to tmux-hop'
grep 'User3' <<<"$hop_keys" | grep -Fq 'SSHSEL_MODE=ssh' ||
  fail 'nested window picker does not default Enter to plain SSH'

# Exercise the helper and configured picker bindings with a real tmux client.
cat >"$test_tmp/bin/tmux" <<'EOF'
#!/bin/bash
exec /usr/bin/tmux -L "$TMUX_HOP_TEST_SOCKET" "$@"
EOF
cat >"$test_tmp/bin/bash" <<'EOF'
#!/bin/bash
if [[ ${1:-} == -ic && ${2:-} == sshsel ]]; then
  exec "$TMUX_HOP_TEST_PICKER"
fi
exec /bin/bash "$@"
EOF
cat >"$test_tmp/bin/fzf" <<'EOF'
#!/bin/bash
host=$(cat "$TMUX_HOP_TEST_CHOICE")
awk -v host="$host" '$1 == host { print; exit }'
EOF
chmod +x "$test_tmp/bin/tmux" "$test_tmp/bin/bash" "$test_tmp/bin/fzf"

python3 - "$repo" "$test_tmp" "$tmux_socket" <<'PYTEST'
import os
from pathlib import Path
import subprocess
import sys
import time

repo, temporary, socket = sys.argv[1:]
env = dict(os.environ, PATH=f"{temporary}/bin:{os.environ['PATH']}",
           TMUX_HOP_TEST_SOCKET=socket, TMUX_HOP_TEST_WAIT="true",
           TMUX_HOP_TEST_LOG=f"{temporary}/ssh.log",
           TMUX_HOP_TEST_CHOICE=f"{temporary}/choice",
           TMUX_HOP_TEST_PICKER=f"{repo}/bin/.local/bin/sshsel",
           SSH_CONFIG=f"{temporary}/ssh-config")
Path(env["TMUX_HOP_TEST_CHOICE"]).write_text("server")
env.pop("TMUX", None)
env.pop("TMUX_HOP_CLIENT", None)
env.pop("TMUX_HOP_ORIGIN", None)


def tmux(*args):
    return subprocess.check_output(
        ["/usr/bin/tmux", "-L", socket, *args], env=env, text=True).strip()


def wait_for(predicate, message):
    deadline = time.monotonic() + 5
    while time.monotonic() < deadline:
        if predicate():
            return
        time.sleep(0.02)
    print(tmux("list-panes", "-a", "-F", "#{session_name}:#{pane_id}:#{pane_current_command}"))
    print(tmux("capture-pane", "-p"))
    print(tmux("list-clients", "-F", "#{client_name}:#{session_name}:#{client_key_table}"))
    print(tmux("list-sessions", "-F", "#{session_name}:#{@hop_origin}:#{@hop_pane}"))
    raise AssertionError(message)


for key in ("PATH", "TMUX_HOP_TEST_SOCKET", "TMUX_HOP_TEST_WAIT",
            "TMUX_HOP_TEST_LOG", "TMUX_HOP_TEST_PICKER", "TMUX_HOP_TEST_CHOICE", "SSH_CONFIG"):
    tmux("set-environment", "-g", key, env[key])

client_process = subprocess.Popen(
    ["/usr/bin/tmux", "-L", socket, "-C", "attach-session", "-t", "verify"],
    env=env, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
    text=True)
try:
    wait_for(lambda: tmux("list-clients", "-F", "#{client_name}"), "client did not attach")
    client = tmux("list-clients", "-F", "#{client_name}")
    origin = tmux("display-message", "-p", "-t", "verify", "#{session_id}")

    def current(format):
        return tmux("display-message", "-p", "-c", client, format)

    # Root User2 creates an ephemeral picker; its parent must survive that picker.
    tmux("send-keys", "-K", "-c", client, "User2")
    wait_for(lambda: current("#{session_name}:#{client_key_table}") == "hop-server-remote-user:hop",
             "session picker did not create a hop")
    hop = current("#{session_id}")
    connection = current("#{pane_id}")
    # Renaming the origin must not strand the window picker.
    tmux("rename-session", "-t", origin, "renamed-local")
    Path(env["TMUX_HOP_TEST_CHOICE"]).write_text("other")
    tmux("send-keys", "-K", "-c", client, "User3")
    wait_for(lambda: current("#{session_id}") == origin,
             "plain SSH picker stayed inside the hop")
    wait_for(lambda: Path(env["TMUX_HOP_TEST_LOG"]).read_text().splitlines()
             == ["-F", env["SSH_CONFIG"], "--", "other"],
             "plain SSH picker did not connect to the second host")
    assert tmux("show-options", "-v", "-t", hop, "@hop_origin") == origin
    assert tmux("show-options", "-v", "-t", hop, "@hop_pane") == connection
    assert current("#{window_name}") == "ssh", "plain SSH window was not selected"
    assert current("#{key-table}") == "root", "plain SSH window has hop key handling"
    assert tmux("list-windows", "-t", hop, "-F", "#{window_id}").count("\n") == 0

    for option, expected in {"status": "off", "prefix": "None", "prefix2": "None",
                             "key-table": "hop", "mouse": "off",
                             "detach-on-destroy": "off"}.items():
        actual = tmux("show-options", "-v", "-t", hop, option)
        assert actual == expected, (option, actual)

    helper_env = dict(env, TMUX=current("#{socket_path},#{pid},0"), TMUX_HOP_CLIENT=client)

    def connect():
        subprocess.run([f"{repo}/bin/.local/bin/tmux-hop", "server", "remote-user"],
                       env=helper_env, check=True)

    # Even after a manual window/pane change, reuse must restore the connection.
    tmux("move-window", "-s", connection, "-t", f"{hop}:7")
    tmux("split-window", "-d", "-t", connection, "sleep 60")
    tmux("select-pane", "-t", f"{hop}:7.2")
    other_window = tmux("new-window", "-P", "-F", "#{window_id}", "-t", f"{hop}:", "sleep 60")
    connect()
    assert current("#{pane_id}") == connection, "reuse selected another connection"
    tmux("kill-window", "-t", other_window)

    # Opening the nested session picker must retain the same local origin.
    Path(env["TMUX_HOP_TEST_CHOICE"]).write_text("other")
    tmux("send-keys", "-K", "-c", client, "User2")
    wait_for(lambda: current("#{session_name}:#{client_key_table}") == "hop-other-other-user:hop",
             "nested picker did not create the second hop")
    assert current("#{@hop_origin}") == origin, "nested hop lost the local origin"
    connect()
    wait_for(lambda: current("#{pane_id}:#{client_key_table}") == f"{connection}:hop",
             "reuse did not restore the original connection")

    tmux("kill-session", "-t", origin)
    windows = tmux("list-windows", "-t", hop, "-F", "#{window_id}")
    tmux("send-keys", "-K", "-c", client, "User3")
    wait_for(lambda: "Originating local workspace is unavailable"
             in tmux("show-messages", "-t", client),
             "missing origin did not report a recovery message")
    assert current("#{session_id}") == hop, "missing origin switched to an unrelated session"
    assert tmux("list-windows", "-t", hop, "-F", "#{window_id}") == windows
finally:
    client_process.communicate("detach-client\n", timeout=5)
PYTEST

printf 'tmux-hop tests passed.\n'
