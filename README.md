# dotfiles

## Requirements

Install brew, then run:

```
brew bundle install
```

`gh` and `tree` in the Brewfile are optional extras (used by the `copilot` and `tree` aliases).

## Symlink config files

```
git clone https://github.com/lars-petter-hauge/dotfiles
cd dotfiles
./install.sh
```

## Docker Sandbox development environment

Use `dev` with a Git checkout to create or enter an isolated, clone-mode
Copilot sandbox with an interactive development shell:

```
dev .
dev --name my-project-feature ./my-project
```

The first run builds `dotfiles/sbx-dev:latest` from
`sbx/Dockerfile`, loads it into Docker Sandboxes, and creates a
sandbox named after the project. Run `dev` without a project to list
sandboxes.
