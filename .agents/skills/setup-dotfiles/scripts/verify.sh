#!/usr/bin/env bash
set -euo pipefail

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

for command in stow shellcheck stylua python3 nvim tmux docker; do
  command -v "$command" >/dev/null || die "$command is required"
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
repo="$(cd "$script_dir/../../../.." && pwd -P)"
temporary_home="$(mktemp -d)"
tmux_socket="dotfiles-verify-$$"
nvim_data_home="${XDG_DATA_HOME:-$HOME/.local/share}"

cleanup() {
  tmux -L "$tmux_socket" kill-server 2>/dev/null || true
  rm -rf -- "$temporary_home"
}
trap cleanup EXIT

readonly -a bash_files=(
  .agents/skills/setup-dotfiles/scripts/deploy.sh
  .agents/skills/setup-dotfiles/scripts/verify.sh
  .bash/aliases.sh
  .bash/bashrc
  .bash/functions.sh
  bin/.local/bin/cx-switch
  bin/.local/bin/paste-image
  tmux/.config/tmux/scolor.sh
  tmux/.config/tmux/switch_session.sh
  tmux/.config/tmux/tmux_toggle_term.sh
)

for file in "${bash_files[@]}"; do
  bash -n "$repo/$file"
done

shellcheck --severity=warning \
  "$repo/.agents/skills/setup-dotfiles/scripts/deploy.sh" \
  "$repo/.agents/skills/setup-dotfiles/scripts/verify.sh" \
  "$repo/bin/.local/bin/cx-switch" \
  "$repo/bin/.local/bin/paste-image" \
  "$repo/tmux/.config/tmux/scolor.sh" \
  "$repo/tmux/.config/tmux/switch_session.sh" \
  "$repo/tmux/.config/tmux/tmux_toggle_term.sh"
shellcheck --shell=bash --severity=error "$repo/.bash/aliases.sh" "$repo/.bash/bashrc" "$repo/.bash/functions.sh"

stylua --check "$repo/neovim/.config/nvim"

python3 - "$repo/tmux/.config/tmux/git_info.py" <<'PY'
import ast
from pathlib import Path
import sys

for filename in sys.argv[1:]:
    ast.parse(Path(filename).read_text(), filename=filename)
PY

DOTFILES_TARGET="$temporary_home" bash "$script_dir/deploy.sh" >/dev/null
HOME="$temporary_home" \
  XDG_CONFIG_HOME="$temporary_home/.config" \
  XDG_DATA_HOME="$nvim_data_home" \
  XDG_STATE_HOME="$temporary_home/.nvim-state" \
  XDG_CACHE_HOME="$temporary_home/.nvim-cache" \
  nvim --headless -i NONE --cmd 'set shadafile=NONE' '+qa'

tmux -L "$tmux_socket" -f "$repo/tmux/.config/tmux/tmux.conf" new-session -d -s verify 'sleep 30'
tmux -L "$tmux_socket" kill-server

docker compose -f "$repo/.docker/docker-compose.yml" config --quiet

printf 'Dotfiles verification passed.\n'
