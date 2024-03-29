
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/local/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

unsetopt autopushd

autoload -Uz compinit && compinit

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# Leaving the setting here uncommented purposefully, as pyenv includes by default
# The virtualenenv-init facilitates pyenv to change venv on directory change
# looking for a python.version file. It is however fairly slow, and does so on
# every command line call.
# eval "$(pyenv virtualenv-init -)"

export VIRTUAL_ENV_DISABLE_PROMPT=1

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Source additional files; alias, post-rc
if [ -f $HOME/.alias ]; then source $HOME/.alias; fi

if [ -f $HOME/.post-rc ]; then source $HOME/.post-rc; fi
