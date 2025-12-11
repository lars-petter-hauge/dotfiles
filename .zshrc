
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/local/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

unsetopt autopushd

autoload -Uz compinit && compinit -u

export VIRTUAL_ENV_DISABLE_PROMPT=1

# Source additional files; alias, post-rc
if [ -f $HOME/.alias ]; then source $HOME/.alias; fi

if [ -f $HOME/.post-rc ]; then source $HOME/.post-rc; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
