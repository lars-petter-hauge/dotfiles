# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Bash prompt
PS1='\[\033[01;37m\]\u\[\033[00m\]:\[\033[01;32m\]\W\[\033[00m\]\$\[\033[00m\] '

# Always use UTF8
export LANG=en_US.UTF-8

# History, ignore duplicates, append
export HISTSIZE="10000"
export HISTFILESIZE="10000"
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
shopt -s histappend

# fzf: Respect .gitignore and don't exclude hidden files
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'

# Source additional files; alias
if [ -f $HOME/.alias ]; then source $HOME/.alias; fi

# Enable git completion on macos/bash
if [[ "$OSTYPE" == "darwin"* && "$SHELL" == "/bin/bash" ]]; then
    . ~/.git-completion.bash
fi

# <start pyenv config>
# remove if not using pyenv

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# <end pyenv config>

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
