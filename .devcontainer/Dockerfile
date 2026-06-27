FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

RUN mkdir -p /home/vscode/.cargo/registry /home/vscode/.cache/pip /home/vscode/.npm /home/vscode/.local/share/nvim /home/vscode/.ssh \
    && chown -R vscode:vscode /home/vscode/.cargo /home/vscode/.cache /home/vscode/.npm /home/vscode/.local /home/vscode/.ssh \
    && chmod 700 /home/vscode/.ssh
