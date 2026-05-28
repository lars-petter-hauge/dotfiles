
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/local/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv 2>/dev/null || /opt/homebrew/bin/brew shellenv 2>/dev/null)" 2>/dev/null

# Add mason bin to path in order to have lsp servers in path
export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/mason/bin:$PATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

unsetopt autopushd

autoload -Uz compinit && compinit -u

export VIRTUAL_ENV_DISABLE_PROMPT=1

# Source additional files; alias, post-rc
if [ -f $HOME/.alias ]; then source $HOME/.alias; fi
if command -v limactl &>/dev/null && [ -f $HOME/.lima-helpers ]; then source $HOME/.lima-helpers; fi

if [ -f $HOME/.post-rc ]; then source $HOME/.post-rc; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"
