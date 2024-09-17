# dotfiles

## Requirements

### Neovim

The neovim config use a package manager (lazy) that requires a fairly
new neovim (>= 0.8.0) and must be built with LuaJIT. It is bootstrapped
and will be automatically setup if not present.

Using lazynvim as distro, handling all the lsp configurations.

#### Telescope (and pickers)

Live grep requires ripgrep to be installed (<leader> fg)

#### Rust

The rust_analyser lsp expects Cargo to be installed. It is necessary to
have a Cargo.toml in the root folder for the lsp server to function.

## Install ``` git clone <https://github.com/lars-petter-hauge/dotfiles>

cd ~/dotfiles chmod +x install.sh ./install.sh ```
