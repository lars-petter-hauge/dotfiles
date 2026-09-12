#!/bin/sh

session="$(tmux display-message -p '#{session_name}')"
wrapper="${TMPDIR:-/tmp}/sbx-exec-$session"

if [ -x "$wrapper" ]; then
  exec "$wrapper"
fi

exec "${SHELL:-/bin/zsh}" -l
