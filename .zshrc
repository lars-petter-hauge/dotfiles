# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

unsetopt autopushd

# hide user@hostname
prompt_context(){}

export PIPENV_PYTHON="$HOME/.pyenv/shims/python"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Source additional files; alias
if [ -f $HOME/.alias ]; then source $HOME/.alias; fi
