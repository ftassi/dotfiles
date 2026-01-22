# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Installation

### Prerequisites

```bash
# Debian/Ubuntu
sudo apt install stow git-crypt

# Arch
sudo pacman -S stow git-crypt
```

### Clone and install

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

# Unlock encrypted secrets (requires GPG key)
git-crypt unlock

# Install a single package
stow nvim

# Install multiple packages
stow nvim zsh git alacritty

# Install all packages
stow */
```

Each directory is a "package" that mirrors the home directory structure. For example, `stow nvim` creates symlinks so that `nvim/.config/nvim/` becomes `~/.config/nvim/`.

### Uninstall

```bash
stow -D nvim  # Remove symlinks for nvim
```

## Secrets Management

Sensitive files are encrypted with **git-crypt**. Encrypted files are defined in `.gitattributes`.

### Adding a new secret

1. Add the pattern to `.gitattributes`:
   ```
   path/to/secret filter=git-crypt diff=git-crypt
   ```

2. Create and commit the file — it will be encrypted automatically.

### Working with Claude Code

The `.claudeignore` file prevents Claude from reading sensitive files. It has two sections:

- **Auto-generated**: synced from git-crypt patterns in `.gitattributes`
- **Manual**: your custom patterns, preserved across syncs

**Before creating a file with secrets**, protect it:

```bash
# Add to .claudeignore only
./scripts/protect-secret.sh my-secret.txt

# Add to both .claudeignore and .gitattributes (git-crypt)
./scripts/protect-secret.sh my-secret.txt --git-crypt
```

Common secret patterns (`*.key`, `*.secret`, `.env*`, etc.) are already included by default.

Sync happens automatically via git hooks. To sync manually:

```bash
./scripts/sync-claudeignore.sh
```
