# ─── Zinit ───────────────────────────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ ! -d $ZINIT_HOME ]] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ─── Plugins ─────────────────────────────────────────────────────────────────
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-history-substring-search

# ─── Completions ─────────────────────────────────────────────────────────────
autoload -Uz compinit
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

# fzf-tab must be loaded after compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons=always $realpath'
zstyle ':fzf-tab:complete:z:*'  fzf-preview 'eza --color=always --icons=always $realpath'

# ─── History ─────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE SHARE_HISTORY AUTO_CD

# history-substring-search keybindings (must be set after plugin loads)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'

# ─── fzf ─────────────────────────────────────────────────────────────────────
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border --bind='ctrl-/:toggle-preview'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --icons=always {}'"

# ─── zoxide ──────────────────────────────────────────────────────────────────
eval "$(zoxide init zsh --cmd cd)"

# ─── mise ────────────────────────────────────────────────────────────────────
eval "$($HOME/.local/bin/mise activate zsh)"

# ─── Starship ────────────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ─── eza ─────────────────────────────────────────────────────────────────────
alias ls='eza --color=always --icons=always'
alias ll='eza -la --color=always --icons=always --git'
alias la='eza -a --color=always --icons=always'
alias lt='eza --tree --color=always --icons=always --git -L 2'
alias l='eza -l --color=always --icons=always --git'

# ─── git ─────────────────────────────────────────────────────────────────────
alias gst='git status'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gp='git push'
alias gpl='git pull --rebase'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias glog='git log --oneline --graph --decorate'
alias gd='git diff'
alias gds='git diff --staged'
alias gsw='git switch'
alias gsc='git switch -c'
alias grb='git rebase'
alias grs='git restore'

# ─── docker ──────────────────────────────────────────────────────────────────
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimg='docker images'
alias dex='docker exec -it'
alias dlogs='docker logs -f'

# ─── pnpm ────────────────────────────────────────────────────────────────────
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# ─── PATH ────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ─── bat ─────────────────────────────────────────────────────────────────────
export BAT_THEME="Catppuccin Mocha"
alias cat='bat --paging=never'
alias catt='/usr/bin/cat'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# ─── ripgrep ─────────────────────────────────────────────────────────────────
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"

# ─── lazygit ─────────────────────────────────────────────────────────────────
alias lg='lazygit'

# ─── gh ──────────────────────────────────────────────────────────────────────
command -v gh &>/dev/null && eval "$(gh completion -s zsh)"

# ─── tldr ────────────────────────────────────────────────────────────────────
export TLDR_COLOR_NAME="cyan"
export TLDR_COLOR_DESCRIPTION="white"
export TLDR_COLOR_EXAMPLE="green"
export TLDR_COLOR_COMMAND="red"

# ─── System maintenance ──────────────────────────────────────────────────────
# snapshot + full system update in one command
alias sysupdate='sudo timeshift --create --comments "pre-update $(date +%Y-%m-%d)" --tags D && sudo pacman -Syu'

# ─── Dynamic completions ─────────────────────────────────────────────────────
command -v kubectl &>/dev/null && source <(kubectl completion zsh)
command -v docker  &>/dev/null && source <(docker completion zsh)
command -v helm    &>/dev/null && source <(helm completion zsh)

# ─── sdkman (must remain last) ───────────────────────────────────────────────
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
