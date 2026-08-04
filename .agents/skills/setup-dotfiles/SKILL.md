---
name: setup-dotfiles
description: Set up or deploy the personal GNU Stow repository at ~/.files. Use for cloning, installing packages, or checking conflicts.
---

# Set up dotfiles

Use `git@github.com:ghillb/dotfiles.git` at `$HOME/.files`.

1. If absent, run `git clone git@github.com:ghillb/dotfiles.git "$HOME/.files"`.
2. If present, require that path as the Git root, the canonical `origin`, and a
   clean tracked worktree. Stop on mismatch; never pull, reset, or overwrite.
3. Read and run [`scripts/deploy.sh`](scripts/deploy.sh). No arguments deploys
   all packages; arguments limit scope:

```bash
bash "$HOME/.files/.agents/skills/setup-dotfiles/scripts/deploy.sh" tmux starship
```

Stop on conflicts. Never adopt or unstow first. Integrate `.bash/bashrc` manually
only when explicitly requested. Validate by rerunning the sidecar and checking
representative targets with `readlink -f`.

For repository-wide development checks, run:

```bash
bash "$HOME/.files/.agents/skills/setup-dotfiles/scripts/verify.sh"
```
