
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# History
if [ -d "$HOME/.zsh_history_dir" ]; then
  HISTFILE="$HOME/.zsh_history_dir/.zsh_history"
fi

# Nix
. "$HOME/.nix-profile/etc/profile.d/nix.sh" 2>/dev/null || true

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

if command -v devcontainer &>/dev/null && [ -f $HOME/.devcontainer-helpers ]; then source $HOME/.devcontainer-helpers; fi

if [ -f $HOME/.post-rc ]; then source $HOME/.post-rc; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"
