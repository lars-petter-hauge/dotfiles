SBX_HELPERS_DIR="$(cd "$(dirname "$(readlink "$HOME/.sbx-helpers.sh" 2>/dev/null || echo "${(%):-%x}")")" && pwd)"
SBX_DEV_IMAGE="dotfiles/sbx-dev:latest"

function _sbx_dev_help() {
  cat <<'EOF'
Usage: dev [options] [project] [rm]

Enter, list, or remove a Docker Sandbox.

Arguments:
  project             Local Git checkout to clone into the sandbox
  rm                  Remove the sandbox and cached template images

Options:
  -h, --help          Show this help
  -n, --name NAME     Override the sandbox name

Examples:
  dev
  dev .
  dev myproj
  dev --name myproj-feature myproj
  dev myproj rm
EOF
}

# Convert a project name to an sbx-safe name.
# Examples: "My Project!!" -> "my-project", "a" -> "a-dev".
function _sbx_dev_slug() {
  local name
  name="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9.-]/-/g; s/--*/-/g; s/^[^a-z0-9]*//; s/[^a-z0-9]*$//')"
  [[ ${#name} -ge 2 ]] || name="${name}-dev"
  printf '%s\n' "$name"
}

function _sbx_dev_valid_name() {
  [[ "$1" != "default" ]] && printf '%s' "$1" | grep -Eq '^[[:alnum:]][[:alnum:].-]+$'
}

# Check the sbx image store, accepting Docker Hub's normalized prefix.
# Example: "dotfiles/sbx-dev:latest" also matches "docker.io/dotfiles/sbx-dev:latest".
function _sbx_dev_template_exists() {
  sbx template ls --json |
    jq -e --arg image "$SBX_DEV_IMAGE" '
      any(.images[];
        (.repository + ":" + .tag) == $image or
        ("docker.io/" + .repository + ":" + .tag) == $image or
        (.repository + ":" + .tag) == ("docker.io/" + $image)
      )
    ' >/dev/null
}

function _sbx_dev_ensure_template() {
  if _sbx_dev_template_exists; then
    return 0
  fi

  if ! docker image inspect "$SBX_DEV_IMAGE" >/dev/null 2>&1; then
    docker build \
      --tag "$SBX_DEV_IMAGE" \
      --file "$SBX_HELPERS_DIR/sbx/Dockerfile" \
      "$SBX_HELPERS_DIR" || return 1
  fi

  local tmpdir
  tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/sbx-dev.XXXXXX")" || return 1

  docker image save "$SBX_DEV_IMAGE" --output "$tmpdir/template.tar" &&
    sbx template load "$tmpdir/template.tar"
  local exit_code=$?

  rm -rf "$tmpdir"
  if (( exit_code != 0 )); then
    return "$exit_code"
  fi

  if ! _sbx_dev_template_exists; then
    echo "dev: template $SBX_DEV_IMAGE was not available after loading" >&2
    return 1
  fi
}

function _sbx_dev_sandbox_exists() {
  local name="$1"
  local sandboxes
  sandboxes="$(sbx ls -q)" || return 2
  printf '%s\n' "$sandboxes" | grep -Fxq -- "$name"
}

function _sbx_dev_set_github_secret() {
  local token_file="$HOME/.config/gh-copilot-token"
  if [[ ! -s "$token_file" ]]; then
    echo "dev: GitHub Copilot token not found: $token_file" >&2
    return 1
  fi

  sbx secret set github \
    --sandbox "$1" \
    --command 'cat "$HOME/.config/gh-copilot-token"' \
    --refresh on-demand >/dev/null
}

function dev() {
  local name=""

  while (( $# > 0 )); do
    case "$1" in
      -h|--help)
        _sbx_dev_help
        return 0
        ;;
      -n|--name)
        if (( $# < 2 )); then
          echo "dev: $1 requires a name" >&2
          return 1
        fi
        name="$2"
        shift 2
        ;;
      --name=*)
        name="${1#*=}"
        shift
        ;;
      --)
        shift
        break
        ;;
      -*)
        echo "dev: unknown option: $1" >&2
        return 1
        ;;
      *)
        break
        ;;
    esac
  done

  if (( $# == 0 )) && [[ -z "$name" ]]; then
    sbx ls
    return $?
  fi

  if (( $# < 1 || $# > 2 )); then
    echo "dev: expected a project and optional rm action" >&2
    return 1
  fi

  local action="${2:-enter}"
  if [[ "$action" != "enter" && "$action" != "rm" ]]; then
    echo "dev: unknown action: $action" >&2
    return 1
  fi

  local project_path
  project_path="$(cd "$1" && pwd -P)" || return 1

  local workspace
  workspace="$(git -C "$project_path" rev-parse --show-toplevel 2>/dev/null)" || {
    echo "dev: $project_path must be a Git repository" >&2
    return 1
  }
  workspace="$(cd "$workspace" && pwd -P)" || return 1

  if [[ -z "$name" ]]; then
    name="$(_sbx_dev_slug "$(basename "$workspace")")"
  elif ! _sbx_dev_valid_name "$name"; then
    echo "dev: invalid sandbox name: $name" >&2
    return 1
  fi

  _sbx_dev_sandbox_exists "$name"
  local sandbox_status=$?
  if (( sandbox_status > 1 )); then
    return 1
  fi

  if [[ "$action" == "rm" ]]; then
    tmux kill-session -t "$name" 2>/dev/null

    if (( sandbox_status == 0 )); then
      sbx rm "$name" || return 1
    fi

    rm -f "${TMPDIR:-/tmp}/sbx-exec-$name"

    if _sbx_dev_template_exists; then
      sbx template rm "$SBX_DEV_IMAGE" || return 1
    fi

    if docker image inspect "$SBX_DEV_IMAGE" >/dev/null 2>&1; then
      docker image rm "$SBX_DEV_IMAGE" || return 1
    fi

    return 0
  fi

  if (( sandbox_status == 1 )); then
    _sbx_dev_ensure_template || return 1

    sbx create \
      --clone \
      --name "$name" \
      --template "$SBX_DEV_IMAGE" \
      shell \
      "$workspace" || return 1
  fi

  _sbx_dev_set_github_secret "$name" || return 1

  local wrapper="${TMPDIR:-/tmp}/sbx-exec-$name"
  printf '#!/bin/sh\nsbx exec -it %s zsh -l\nexec "${SHELL:-/bin/zsh}" -l\n' "$name" >| "$wrapper"
  chmod +x "$wrapper"

  if ! tmux has-session -t "=$name" 2>/dev/null; then
      tmux new-session -d -s "$name" "$wrapper" || return 1
  fi

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$name"
  else
    tmux attach-session -t "$name"
  fi
}
