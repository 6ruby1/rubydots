# Run neofetch
fastfetch

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zsh/.zcompdump"
_comp_options+=(globdots)
# export FPATH="$HOME/.config/eza:$FPATH"
zinit cdreplay -q

# Keybindings ----------------------------------------------------------------------
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey "^[[3~" delete-char
#open command in editor
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# History --------------------------------------------------------------------------
export HISTSIZE=5000
export HISTFILE=$ZDOTDIR/.zhistory
export SAVEHIST=$HISTSIZE
export HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Aliases ---------------------------------------------------------------------------
# Lazygit
alias lg='lazygit'

# Packages
alias paci='tv paci --inline'

# man
alias man='batman'

# git
alias gl="git lg"
alias gli="serie"

# Eza
alias l='eza --all --long --icons --git'
alias ls='eza --all --long --icons --git'
alias lt='eza -all --long --tree --level=2 --icons --git'
alias ltree='eza --tree --level=2 --icons --git'

# Dirs
alias cdr='cd "$(git rev-parse --show-toplevel)"'
alias z='cdi'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# nvim
alias vim='nvim'
alias v='nvim'
alias v.='nvim .'
alias vconf='nvim ~/.config/nvim'
alias va="NVIM_APPNAME=newnvim nvim"
alias nvima="NVIM_APPNAME=newnvim nvim"
alias minvim="NVIM_APPNAME=minvim nvim"

# Obsidian
alias oo='cd $HOME/vault/'
alias or='vim $HOME/vault/inbox/*.md'

# dotfiles
alias dot='cd ~/dot'
alias d.='cd ~/dot; yazi'
alias dotlink='cd ~/dot; stow --verbose --target=$HOME --restow */; cd -'
alias dotlinkrm='cd ~/dot; stow --verbose --target=$HOME --delete */; cd -'
alias cpcw='cd ~/dot; copilot -p "create commits for files, use conventional commit styling" --allow-tool "shell(git commit)" --allow-tool "shell(git add)"; cd -'


# Other
alias cat='bat --paging=never'
alias catp='bat'
alias c='clear'
alias nrd='npm run dev'
alias 'gl'="git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an %ar%C(auto) %D%n%s%n'"
alias dev='cd ~/dev/'
alias dev.='cd ~/dev; yazi'
alias cr='cargo run'
alias ct='cargo test'

# CD to Process and tools project
alias sept='cd ~/dev/SEPT-25/SEPT-major/'

#fzf
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#a48cf2,fg+:#36ef96,bg:#212337,bg+:#7081d0
  --color=hl:#f265b5,hl+:#f265b5,info:#e3666f,marker:#04d1f9
  --color=prompt:#f9515d,spinner:#04d1f9,pointer:#36ef96,header:#36ef96
  --color=gutter:#212337,border:#6877bd,preview-border:#e3666f,preview-scrollbar:#36ef96
  --color=preview-label:#e3666f,label:#36ef96,query:#d9d9d9
  --border="rounded" --border-label-pos="0" --preview-window="border-rounded"
  --prompt="> " --marker=">" --pointer="◆" --separator="─"
  --scrollbar="│" --info="right"'

# Completion styling ------------------------------------------------------------------
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
# zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' fzf-flags --bind "focus:transform-preview-label:[[ -n {} ]] && printf ' Previewing [%s] ' {}" \
  --bind "focus:+transform-header:file --brief {} || echo 'No file selected'" \
  --bind "result:transform-list-label:
        if [[ -z $FZF_QUERY ]]; then
          echo ' $FZF_MATCH_COUNT items '
        else
          echo ' $FZF_MATCH_COUNT matches for [$FZF_QUERY] '
        fi
        " \
        --color=fg:#a48cf2,fg+:#36ef96,bg:#212337,bg+:#7081d0 \
  --color=hl:#f265b5,hl+:#f265b5,info:#e3666f,marker:#04d1f9 \
  --color=prompt:#f9515d,spinner:#04d1f9,pointer:#36ef96,header:#36ef96 \
  --color=gutter:#212337,border:#6877bd,preview-border:#e3666f,preview-scrollbar:#36ef96 \
  --color=preview-label:#e3666f,label:#36ef96,query:#d9d9d9 \
  --border="rounded" --border-label-pos="0" --preview-window="border-rounded" \
  --prompt="> " --marker=">" --pointer="◆" --separator="─" \
  --scrollbar="│" --info="right"

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'

# Set minimum height for fzf-tab to ensure consistent display
zstyle ':fzf-tab:*' fzf-min-height 15


# Shell integrations ------------------------------------------------------------------
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"         # (see .zprofile)
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
eval "$(tv init zsh)"
eval "$(atuin init zsh)"
eval "$(batman --export-env)"
source "$ZDOTDIR/functions/kitty_keys.sh" # function to list kitty keybindings

# Yazi
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# enable transient prompt -------------------------------------------------------------
zle-line-init() {
  emulate -L zsh
  [[ $CONTEXT == start ]] || return 0
  while true; do
    zle .recursive-edit
    local -i ret=$?
    [[ $ret == 0 && $KEYS == $'\4' ]] || break
    [[ -o ignore_eof ]] || exit 0
  done
  local saved_prompt=$PROMPT
  local saved_rprompt=$RPROMPT
  PROMPT='%{$fg[blue]%}->%{%} % '
  RPROMPT=''
  zle .reset-prompt
  PROMPT=$saved_prompt
  RPROMPT=$saved_rprompt
  if ((ret)); then
    zle .send-break
  else
    zle .accept-line
  fi
  return ret
}
zle -N zle-line-init

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f $HOME/.dart-cli-completion/zsh-config.zsh ]] && . $HOME/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env" # ghcup-env
