FROM mcr.microsoft.com/devcontainers/base:ubuntu

COPY Brewfile /tmp/Brewfile
USER vscode
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
    && brew bundle install --file=/tmp/Brewfile \
    && brew cleanup --prune=all \
    && rm /tmp/Brewfile

RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
    && rustup default stable

COPY install-nvim-plugins.sh /tmp/install-nvim-plugins.sh
RUN /tmp/install-nvim-plugins.sh && rm /tmp/install-nvim-plugins.sh
USER root
