function _dc_config_paths() {
  local ws="$1"
  local no_ssh="$2"
  shift 2
  local -a extra_mounts=("$@")

  local config
  if [ -f "$ws/.devcontainer/devcontainer.json" ]; then
    config="$ws/.devcontainer/devcontainer.json"
  elif [ -f "$ws/.devcontainer.json" ]; then
    config="$ws/.devcontainer.json"
  else
    config="$HOME/.devcontainer/devcontainer.json"
  fi

  local overlay="$HOME/.devcontainer/overlay.json"
  local merged_config="$config"
  local tmpdir=""
  if [ -f "$overlay" ]; then
    if ! command -v jq >/dev/null; then
      echo "devcontainer helper: jq is required to merge $overlay" >&2
      return 1
    fi

    tmpdir="$(mktemp -d)"
    merged_config="$tmpdir/devcontainer.json"

    local config_dir
    config_dir="$(cd "$(dirname "$config")" && pwd)"

    local ssh_source=""
    if [[ "$no_ssh" != "1" ]]; then
      if [[ "$(uname)" == "Darwin" ]]; then
        ssh_source="/run/host-services/ssh-auth.sock"
      elif [[ -n "$SSH_AUTH_SOCK" ]]; then
        ssh_source="$SSH_AUTH_SOCK"
      fi
    fi

    local extra_mounts_json="[]"
    if (( ${#extra_mounts[@]} > 0 )); then
      extra_mounts_json=$(printf '%s\n' "${extra_mounts[@]}" | jq -R '[inputs // empty | "type=bind,source=\(.),target=\(.)"]' 2>/dev/null || echo "[]")
    fi

    jq -s --arg ctx "$config_dir" --arg ssh "$ssh_source" --argjson extra "$extra_mounts_json" '
      .[0] as $base
      | .[1] as $overlay
      | $base * $overlay
      | .features = (($base.features // {}) * ($overlay.features // {}))
      | .mounts = (($base.mounts // []) + ($overlay.mounts // []) + $extra | unique)
      | if $ssh != "" then .mounts += ["type=bind,source=\($ssh),target=/ssh-agent"] | .containerEnv.SSH_AUTH_SOCK = "/ssh-agent" | .postStartCommand = "sudo chmod 666 /ssh-agent" else . end
      | .customizations.vscode.extensions = (($base.customizations.vscode.extensions // []) + ($overlay.customizations.vscode.extensions // []) | unique)
      | if .build then .build.context = $ctx | .build.dockerfile = ($ctx + "/" + .build.dockerfile) else . end
    ' "$config" "$overlay" > "$merged_config" || {
      rm -rf "$tmpdir"
      return 1
    }
  fi

  printf "%s\n%s\n" "$merged_config" "$tmpdir"
}


function _dc_tmux_start_command() {
  cat <<'EOF'
export TMPDIR="$(cd -P . && pwd)/.tmp"
mkdir -p "$TMPDIR"
tmux set-environment -g PATH "$PATH" 2>/dev/null || true
tmux set-environment -g TMPDIR "$TMPDIR" 2>/dev/null || true
tmux new-session -A -s main
EOF
}

# Build and start a devcontainer for the given workspace.
# Additional arguments are paths to extra projects mounted into the container.
function dcup() {
  local no_ssh="$1"
  local ws="${2:-.}"
  ws="$(cd "$ws" && pwd)"
  shift 2 2>/dev/null || true
  local -a extra=("$@")

  local -a config_paths
  config_paths=("${(@f)$(_dc_config_paths "$ws" "$no_ssh" "${extra[@]}")}") || return 1
  local merged_config="${config_paths[1]}"
  local generated_config="${config_paths[2]}"

  echo "Config: $merged_config"
  read -r "?Press Enter to continue..."

  devcontainer up --workspace-folder "$ws" \
    --config "$merged_config" \
    --dotfiles-repository https://github.com/lars-petter-hauge/dotfiles \
    --dotfiles-install-command ./install.sh
  local exit_code=$?

  [[ -n "$generated_config" ]] && rm -rf "$generated_config"

  return $exit_code
}

# Enter a devcontainer, creating it if needed.
# Usage:
#   dev              - use current directory as workspace
#   dev project      - use project as workspace
#   dev projA projB  - projA as workspace, projB mounted alongside
#   dev --no-ssh project  - without SSH agent access
function dev() {
  local no_ssh="0"
  if [[ "$1" == "--no-ssh" ]]; then
    no_ssh="1"
    shift
  fi

  local ws
  local -a extra=()

  if (( $# == 0 )); then
    ws="$(pwd)"
  else
    ws="$(cd "$1" && pwd)"
    shift
    for arg in "$@"; do
      extra+=("$(cd "$arg" && pwd)")
    done
  fi

  local container_id
  container_id=$(docker ps -q --filter "label=devcontainer.local_folder=$ws")
  if [[ -n "$container_id" && "$no_ssh" == "1" ]]; then
    docker rm -f "$container_id" >/dev/null
    container_id=""
  fi
  if [[ -z "$container_id" ]]; then
    dcup "$no_ssh" "$ws" "${extra[@]}" || return 1
    container_id=$(docker ps -q --filter "label=devcontainer.local_folder=$ws")
  fi

  docker exec -u vscode "$container_id" ln -sfn "$ws" "/home/vscode/$(basename "$ws")" 2>/dev/null
  for p in "${extra[@]}"; do
    docker exec -u vscode "$container_id" ln -sfn "$p" "/home/vscode/$(basename "$p")" 2>/dev/null
  done

  local tmux_start_command
  tmux_start_command="$(_dc_tmux_start_command)"

  docker exec -it -e TERM="$TERM" -u vscode "$container_id" zsh -lic "cd ~/$(basename "$ws") && $tmux_start_command"
}

function rmdev() {
  local ws="${1:-.}"
  ws="$(cd "$ws" && pwd)"
  local container_id
  container_id=$(docker ps -q --filter "label=devcontainer.local_folder=$ws")
  if [[ -n "$container_id" ]]; then
    docker rm -f "$container_id"
  else
    echo "No running devcontainer found for $ws"
  fi
}

