# dotfiles

## Requirements

Using brew as package manager, the Brewfile contains all packages necessary. Install brew and run

```
brew bundle install
```

## Symlink config files

```
git clone https://github.com/lars-petter-hauge/dotfiles
cd dotfiles
./install.sh
```

## Lima VM

A Lima-based Linux VM provides an isolated dev environment with native Docker.
Works on both macOS and Linux (QEMU).

```
brew install lima
source .alias
dev
```

The `dev` function creates/starts the VM on first run and attaches to a tmux session.
Provisioning installs Homebrew, Brewfile packages, and symlinks dotfiles automatically.
