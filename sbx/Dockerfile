FROM docker/sandbox-templates:shell-docker

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gdb cmake meson pkg-config \
    libglib2.0-dev libssh-dev libopenmpi-dev guile-3.0 \
    bzip2 zstd htop tree watch wget tmux zsh \
    && rm -rf /var/lib/apt/lists/*

USER agent

RUN curl -fsSL https://mise.run | sh
ENV PATH="/home/agent/.local/bin:/home/agent/.local/share/mise/shims:$PATH"

COPY --chown=agent:agent sbx/mise.toml sbx/mise.lock /home/agent/.config/mise/
RUN cd /home/agent/.config/mise && mise install --yes

RUN echo 'eval "$(~/.local/bin/mise activate bash)"' >> "$HOME/.bashrc" \
    && echo 'eval "$(~/.local/bin/mise activate zsh)"' >> "$HOME/.zshrc" 2>/dev/null || true

COPY --chown=agent:agent . /home/agent/dotfiles
RUN DOTFILES_SANDBOX=1 "$HOME/dotfiles/install.sh"
