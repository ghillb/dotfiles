#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DOTFILES="${DOTFILES:-$HOME/.files}"
REPO_URL="https://github.com/ghillb/dotfiles.git"

# Print colored messages
print_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check for stow
if ! command -v stow &>/dev/null; then
    print_error "stow is required but not installed. Install it first:"
    print_error "  Debian/Ubuntu: sudo apt install stow"
    print_error "  Fedora: sudo dnf install stow"
    exit 1
fi

print_info "Starting dotfiles deployment..."

# Clone or update dotfiles repository
if [[ ! -d "$DOTFILES" ]]; then
    print_info "Cloning dotfiles repository..."
    git clone "$REPO_URL" "$DOTFILES"
    cd "$DOTFILES"
else
    print_info "Dotfiles directory already exists at $DOTFILES"
    cd "$DOTFILES"
    if [[ -d .git ]]; then
        print_info "Updating dotfiles repository..."
        git pull --rebase || print_warn "Could not update repository (might have local changes)"
    fi
fi

# Install dotfiles using stow
print_info "Installing dotfiles with stow..."

# Get all package directories (excluding hidden directories and files)
PACKAGES=$(find . -maxdepth 1 -type d ! -path . ! -path './.git' ! -path './.git/*' ! -path './.*' -exec basename {} \;)

for package in $PACKAGES; do
    print_info "Installing $package..."
    stow --dotfiles --dir "$DOTFILES" --target "$HOME" "$package" -D 2>/dev/null || true
    stow --dotfiles --dir "$DOTFILES" --target "$HOME" "$package"
done

# Setup bash configuration
if [[ -f "$DOTFILES/.bash/bashrc" ]]; then
    if ! grep -q "source '$DOTFILES/.bash/bashrc'" "$HOME/.bashrc" 2>/dev/null; then
        echo -e "\nsource '$DOTFILES/.bash/bashrc'" >> "$HOME/.bashrc"
        print_info "Added dotfiles bashrc to ~/.bashrc"
    else
        print_info "Dotfiles bashrc already sourced in ~/.bashrc"
    fi
fi

print_info "Dotfiles deployment complete!"
print_info "Restart your terminal or run: source ~/.bashrc"
