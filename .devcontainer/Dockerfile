FROM mcr.microsoft.com/devcontainers/base:ubuntu

COPY Brewfile /tmp/Brewfile
COPY install-nvim-plugins.sh /tmp/install-nvim-plugins.sh
USER vscode
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
    && brew bundle install --file=/tmp/Brewfile \
    && brew cleanup --prune=all

RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
    && rustup default stable

RUN /tmp/install-nvim-plugins.sh
USER root
RUN rm /tmp/Brewfile /tmp/install-nvim-plugins.sh
