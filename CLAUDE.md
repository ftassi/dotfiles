# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository using the **XDG Base Directory** structure. Each top-level directory mirrors the home directory structure and can be symlinked or managed with GNU Stow.

## Structure Pattern

```
<tool>/.config/<tool>/     # For XDG-compliant tools
<tool>/.<toolrc>           # For legacy dotfile locations
```

Examples:
- `nvim/.config/nvim/` → `~/.config/nvim/`
- `ideavim/.ideavimrc` → `~/.ideavimrc`

## Key Components

### Neovim (`nvim/.config/nvim/`)
Kickstart-based Lua configuration with lazy.nvim plugin manager.
- `lua/ftassi/options.lua` - Editor options
- `lua/ftassi/keymaps.lua` - Keybindings
- `lua/ftassi/plugins/` - Individual plugin configs (LSP, telescope, git, etc.)

### Zsh (`zsh/.config/zsh/`)
Modular shell configuration with Antigen plugin manager and Powerlevel10k prompt.
- `zsh.d/` - Environment-specific configs (distrobox detection, tool initialization)
- `.secrets.zsh` - Encrypted secrets (git-crypt)

### Git (`git/.config/git/`)
- `config` - Primary git configuration
- `config-madisoft` - Workspace-specific overrides (conditional includes)

## Security: git-crypt and .claudeignore

Sensitive files are encrypted with git-crypt. The `.gitattributes` file defines which files are encrypted. Never commit plaintext secrets.

The `.claudeignore` has two sections:
- **Auto-generated**: synced from `.gitattributes` git-crypt patterns
- **Manual**: user-defined patterns preserved across syncs

**Before creating a file with secrets**, protect it first:
```bash
./scripts/protect-secret.sh my-secret.txt           # Add to .claudeignore only
./scripts/protect-secret.sh my-secret.txt --git-crypt  # Also add to .gitattributes
```

## Scripts

```bash
# Sync .claudeignore from git-crypt patterns (preserves manual entries)
./scripts/sync-claudeignore.sh

# Protect a file BEFORE creating it
./scripts/protect-secret.sh <pattern> [--git-crypt]
```

Sync runs automatically via git hooks (pre-commit, post-checkout, post-merge).

## Notes

- Container-aware configs exist for distrobox environments
- Neovim supports multiple configurations via `NVIM_APPNAME`
- TODO items for this repo are tracked in `nvim/.config/nvim/TODO.md`
