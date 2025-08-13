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

# Parse command line arguments
SKIP_PACKAGES=false
SKIP_NODE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-packages)
            SKIP_PACKAGES=true
            shift
            ;;
        --skip-node)
            SKIP_NODE=true
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --skip-packages       Skip package installation"
            echo "  --skip-node           Skip nvm/node installation"
            echo "  --help                Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check if running on Ubuntu/Debian
if [[ ! -f /etc/debian_version ]]; then
    print_error "This script is designed for Ubuntu/Debian systems only"
    exit 1
fi

print_info "Starting dotfiles deployment..."

# Install packages if not skipped
if [[ "$SKIP_PACKAGES" == false ]]; then
    print_info "Updating package lists..."
    sudo apt-get update

    print_info "Installing prerequisites..."
    sudo apt-get install -y \
        git \
        stow \
        make \
        curl \
        wget \
        software-properties-common

    print_info "Installing terminal utilities..."
    # Install packages that are available
    PACKAGES=(
        tmux
        ripgrep
        bat
        jq
        htop
        ncdu
        direnv
        shellcheck
        dos2unix
        bash-completion
        gcc
        perl
        golang
        python3-venv
        python3-pip
        python3-dev
        sqlite3
        libsqlite3-dev
        silversearcher-ag
        git-lfs
        tig
        fzf
        fd-find
    )
    
    # Install Neovim 0.11+ via PPA (works everywhere including Docker)
    if ! command -v nvim &>/dev/null; then
        print_info "Installing Neovim from PPA..."
        # Add Neovim PPA (key from https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable)
        curl -fsSL 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x9DBB0BE9366964F134855E2255F96FCF8231B6DD' | sudo gpg --dearmor -o /usr/share/keyrings/neovim-ppa.gpg
        echo "deb [signed-by=/usr/share/keyrings/neovim-ppa.gpg] https://ppa.launchpadcontent.net/neovim-ppa/unstable/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/neovim-ppa.list
        sudo apt-get update
        sudo apt-get install -y neovim
    else
        # Check version if already installed
        NVIM_VERSION=$(nvim --version | head -1 | grep -oP '\d+\.\d+' | head -1)
        print_info "Neovim $NVIM_VERSION already installed"
    fi
    
    # Install Starship prompt if not already installed
    if ! command -v starship &>/dev/null; then
        print_info "Installing Starship prompt..."
        # Use --force flag for non-interactive environments like Docker
        curl -sS https://starship.rs/install.sh | sh -s -- --force || print_warn "Failed to install Starship"
    else
        print_info "Starship already installed"
    fi
    
    for pkg in "${PACKAGES[@]}"; do
        if apt-cache show "$pkg" &>/dev/null; then
            sudo apt-get install -y "$pkg" || print_warn "Failed to install $pkg"
        else
            print_warn "Package $pkg not found, skipping"
        fi
    done

    # Initialize git-lfs if installed
    if command -v git-lfs &>/dev/null; then
        git lfs install
    fi
else
    print_warn "Skipping package installation (--skip-packages flag set)"
fi

# Clone or update dotfiles repository
if [[ ! -d "$DOTFILES" ]]; then
    print_info "Cloning dotfiles repository..."
    git clone "$REPO_URL" "$DOTFILES"
    cd "$DOTFILES"
else
    print_info "Dotfiles directory already exists at $DOTFILES"
    cd "$DOTFILES"
    # Pull latest changes if it's a git repo
    if [[ -d .git ]]; then
        print_info "Updating dotfiles repository..."
        git pull --rebase || print_warn "Could not update repository (might have local changes)"
    fi
fi

# Install dotfiles using stow
print_info "Installing dotfiles with stow..."

# Get all package directories (excluding hidden directories and files)
PACKAGES=$(find . -maxdepth 1 -type d ! -path . ! -path './.git' ! -path './.git/*' ! -path './.*' -exec basename {} \;)

# System packages that need sudo (none currently)
SYSTEM_PACKAGES=""

for package in $PACKAGES; do
    if [[ " $SYSTEM_PACKAGES " =~ " $package " ]]; then
        TARGET="/"
        PREFIX="sudo"
    else
        TARGET="$HOME"
        PREFIX=""
    fi
    
    # Remove old symlinks and create new ones
    print_info "Installing $package..."
    $PREFIX stow --dotfiles --dir "$DOTFILES" --target "$TARGET" "$package" -D 2>/dev/null || true
    $PREFIX stow --dotfiles --dir "$DOTFILES" --target "$TARGET" "$package"
done

# Create necessary directories
print_info "Creating necessary directories..."
mkdir -p "$HOME/code"
mkdir -p "$HOME/.bash_completion.d"

# Install fzf from git if not installed via package manager
if ! command -v fzf &>/dev/null; then
    if [[ ! -d "$HOME/.fzf" ]]; then
        print_info "Installing fzf from git..."
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
        "$HOME/.fzf/install" --all --no-update-rc --no-fish --no-zsh
    else
        print_info "fzf already installed from git"
    fi
else
    print_info "fzf already installed via package manager"
fi

# Setup bash configuration
print_info "Configuring bash..."
if ! grep -q "source '$DOTFILES/.bash/bashrc'" "$HOME/.bashrc" 2>/dev/null; then
    echo -e "\nsource '$DOTFILES/.bash/bashrc'" >> "$HOME/.bashrc"
    print_info "Added dotfiles bashrc to ~/.bashrc"
else
    print_info "Dotfiles bashrc already sourced in ~/.bashrc"
fi

# Install bash completion for aliases
if [[ ! -f "$HOME/.bash_completion.d/complete_alias" ]]; then
    print_info "Installing bash completion for aliases..."
    curl -sL https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias \
        -o "$HOME/.bash_completion.d/complete_alias"
fi

# Configure git
print_info "Configuring git..."
git config --global pull.ff only || true
git config --global credential.helper 'cache --timeout=43200' || true

# Install nvm and node (unless skipped)
if [[ "$SKIP_NODE" == false ]]; then
    if [[ ! -d "$HOME/.nvm" ]]; then
        print_info "Installing nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
        
        # Source nvm and install node
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        
        print_info "Installing Node.js v16..."
        nvm install 16
        nvm use 16
        nvm alias default 16
    else
        print_info "nvm already installed"
    fi
else
    print_warn "Skipping nvm/node installation (--skip-node flag set)"
fi

print_info "✨ Dotfiles deployment complete!"
print_info "Please restart your terminal or run: source ~/.bashrc"