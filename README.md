# dotfiles

## Requirements


### Neovim

 The neovim config use a package manager (lazy) that requires a fairly
 new neovim (>= 0.8.0) and must be built with LuaJIT. It is bootstrapped
 and will be automatically setup if not present. Mason is used to
 install language servers (such as pyright). Mason is also bootstrapped
 and should work out of the box. Make sure to run :checkhealth in nvim
 after installing.

## Install
```
git clone https://github.com/lars-petter-hauge/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```
