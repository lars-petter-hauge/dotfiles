# dotfiles

## Requirements


### Neovim

 The neovim config use a package manager (lazy) that requires a fairly
 new neovim (>= 0.8.0) and must be built with LuaJIT. It is bootstrapped
 and will be automatically setup if not present.

 Mason is used to install language servers (such as pyright). Mason is
 also bootstrapped and should work out of the box. Make sure to run
 :checkhealth in nvim after installing.

#### Telescope (and pickers)

Live grep requires ripgrep to be installed (<leader> fg)

#### Python

For faster start time a pythonpath has been set to a pyenv environment
named nvim_env. (~/.pyenv/versions/nvim_env/bin/python). It is expected
that this environment has debugpy, pynvim and black installed.

#### Rust

The rust_analyser lsp expects Cargo to be installed. It is necessary to
have a Cargo.toml in the root folder for the lsp server to function.

## Install ``` git clone https://github.com/lars-petter-hauge/dotfiles
cd ~/dotfiles chmod +x install.sh ./install.sh ```
