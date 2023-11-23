# dotfiles

## Requirements

 - The nvim dotfiles use a package manager that requires a fairly new neovim (>= 0.8.0) and must be built with LuaJIT
 - Nvim is configured to search for pyenv environment named nvim_env. The python environment must include pynvim and pyright
 - Make sure to run :checkhealth in nvim after installing
 - The DAP used requires debugpy to function with python files (pip installable)

## Install
```
git clone https://github.com/lars-petter-hauge/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```
