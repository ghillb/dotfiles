---
name: windows-terminal-setup
description: Install, repair, or validate the Windows-to-WSL configuration links for this dotfiles repository's WezTerm and Alacritty configs. Use when bootstrapping a Windows/WSL machine, restoring terminal configuration links, diagnosing why Windows terminals ignore repo configs, or verifying the existing symlink setup.
---

# Windows Terminal Setup

Keep the terminal configuration files in WSL as the canonical copies. Link the Windows configuration paths to them with `scripts/link-configs.ps1`.

## Link mappings

- Link `%USERPROFILE%\.config\wezterm\wezterm.lua` to `wezterm/.config/wezterm/wezterm.lua`.
- Link `%APPDATA%\alacritty\alacritty.toml` to `alacritty/.config/alacritty/alacritty.toml`.

Derive the Windows username, WSL distribution, and repository location at runtime. Do not hard-code them.

## Workflow

1. Run from the repository root inside WSL.
2. Validate existing links without changing them:

   ```bash
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(wslpath -w .agents/skills/windows-terminal-setup/scripts/link-configs.ps1)" -ValidateOnly
   ```

3. Create missing links:

   ```bash
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(wslpath -w .agents/skills/windows-terminal-setup/scripts/link-configs.ps1)"
   ```

4. Run validation-only mode again.
5. Validate each terminal's configuration with its installed executable when changing terminal config content.

The script is idempotent. It creates missing parent directories and links, but refuses to replace a conflicting file, directory, or wrong link. Inspect conflicts and ask before moving or removing user data. If Windows rejects symbolic-link creation, enable Developer Mode or run the command from an elevated shell, then retry.
