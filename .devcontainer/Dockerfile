FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

COPY Brewfile /tmp/Brewfile
USER vscode
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
    && brew bundle install --file=/tmp/Brewfile \
    && brew cleanup --prune=all

RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
    && rustup default stable

RUN mkdir -p /home/vscode/.cargo/registry /home/vscode/.cache/pip /home/vscode/.npm /home/vscode/.local/share/nvim /home/vscode/.ssh \
    && chown -R vscode:vscode /home/vscode/.cargo /home/vscode/.cache /home/vscode/.npm /home/vscode/.local /home/vscode/.ssh \
    && chmod 700 /home/vscode/.ssh
USER root
RUN rm /tmp/Brewfile
