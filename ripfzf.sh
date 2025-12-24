RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
RG_PREFIX_HIDDEN="rg --column --line-number --no-heading --color=always --smart-case --hidden "
INITIAL_QUERY="${*:-}"
fzf --ansi --disabled --query "$INITIAL_QUERY" \
  --bind "start:reload($RG_PREFIX {q})+unbind(ctrl-r)" \
  --bind "change:reload:sleep 0.1; [[ \$FZF_PROMPT =~ hidden ]] && $RG_PREFIX_HIDDEN {q} || $RG_PREFIX {q} || true" \
  --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)" \
  --bind "ctrl-r:unbind(ctrl-r)+change-prompt(1. ripgrep> )+disable-search+reload($RG_PREFIX {q} || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
  --bind "alt-h:transform:[[ ! \$FZF_PROMPT =~ hidden ]] && echo \"change-prompt(1. ripgrep+hidden> )+reload($RG_PREFIX_HIDDEN {q} || true)+rebind(change)\" || echo \"change-prompt(1. ripgrep> )+reload($RG_PREFIX {q} || true)+rebind(change)\"" \
  --color "hl:-1:underline,hl+:-1:underline:reverse" \
  --prompt '1. ripgrep> ' \
  --delimiter : \
  --header '╱ CTRL-R (ripgrep mode) ╱ CTRL-F (fzf mode) ╱ ALT-H (toggle hidden) ╱' \
  --preview 'bat --color=always {1} --highlight-line {2}' \
  --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
  --bind 'enter:become(nvim {1} +{2})'
