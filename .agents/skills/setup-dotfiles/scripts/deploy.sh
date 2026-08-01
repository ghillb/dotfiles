#!/usr/bin/env bash
set -euo pipefail

readonly -a ALL_PACKAGES=(
    alacritty bin ideavim neovim powershell starship tmux user wezterm
)

die() {
    printf 'error: %s\n' "$*" >&2
    exit 1
}

command -v stow >/dev/null || die "GNU Stow is required"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
repo="$(cd "$script_dir/../../../.." && pwd -P)"
target="${DOTFILES_TARGET:-$HOME}"
packages=("$@")
(( ${#packages[@]} > 0 )) || packages=("${ALL_PACKAGES[@]}")

for package in "${packages[@]}"; do
    valid=false
    for candidate in "${ALL_PACKAGES[@]}"; do
        [[ "$package" == "$candidate" ]] && valid=true
    done
    [[ "$valid" == true && -d "$repo/$package" ]] || die "unknown package: $package"
done

stow --dotfiles --no --verbose --dir "$repo" --target "$target" "${packages[@]}"
stow --dotfiles --dir "$repo" --target "$target" "${packages[@]}"
