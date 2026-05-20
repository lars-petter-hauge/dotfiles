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

## Use case for docker devlopment

This repo is designed to use all files also within a docker dev environment. The alias dev will take
you into the docker container directly, with current working directory mounted.
