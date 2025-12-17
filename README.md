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
./create_symlinks.sh.sh
```

## Update applications

Add plugin manager to tmux
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

and run the install command for tpm plugins

The plugin manager for neovim (lazy) is bootstrapped. Open neovim and run `:Lazy restore` to install according to lock file
