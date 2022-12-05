.PHONY := setup-terminal setup-desktop
.DEFAULT_GOAL := setup-terminal

export DOTFILES = $(HOME)/.files
export CODE = $(HOME)/code

DOT_SCRIPTS = ./.scripts
HINT_TEXT = "Current target: "
STOW = $(shell command -v stow 2> /dev/null)

check_stow:
ifndef STOW
$(error No 'stow' in $$PATH, consider installing GNU stow)
endif

ifndef CI
PASS_PROMPT = "--ask-become-pass"
endif

setup-terminal: prepare install-dots install-terminal post-install
setup-desktop: prepare install-dots install-terminal install-desktop post-install

prepare:
	@echo ">>[ $(HINT_TEXT)$@ ]<<\n"
	@bash -c "$(DOT_SCRIPTS)/dependencies.yml $(PASS_PROMPT) --tags pre-requisites"

install-dots: check_stow
	@echo ">>[ $(HINT_TEXT)$@ ]<<\n"
	@bash -c $(DOT_SCRIPTS)/install_dots.sh

install-terminal:
	@echo ">>[ $(HINT_TEXT)$@ ]<<\n"
	@bash -c "$(DOT_SCRIPTS)/dependencies.yml $(PASS_PROMPT) --tags terminal-utilities"

install-desktop:
	@echo ">>[ $(HINT_TEXT)$@ ]<<\n"
	@bash -c "$(DOT_SCRIPTS)/dependencies.yml $(PASS_PROMPT) --tags desktop-utilities"

post-install:
	@echo ">>[ $(HINT_TEXT)$@ ]<<\n"
	@bash -c $(DOT_SCRIPTS)/post_install.sh
