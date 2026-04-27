#!/bin/zsh
# shellcheck disable=SC1071
# molofgarb's zshrc
# you probably need to install:
#   - fzf
#   - zsh-syntax-highlighting
#   - zsh-completions
#   - zsh-autosuggestions
#   - vim-plug
# These are nice-to-haves:
#   - eza (for ls)
#   - bat (for cat)
#   - zoxide (for cd)

# ==============================================================================
# ===== CORE ===================================================================
# ==============================================================================

# ===== env Variables =====
export EDITOR='nvim'
export VISUAL='nvim'
export ZSHRC_PATH='~/.zshrc'

# ===== Aliases =====
alias reload="source $ZSHRC_PATH"
alias zshrc="$EDITOR $ZSHRC_PATH"
alias zshrc_local="$EDITOR $(dirname $ZSHRC_PATH)/.zsh/.zshrc_local"
zshrc-update() {
  local zshrc_url='https://raw.githubusercontent.com/molofgarb/molofgarb-system-scripts/main/dotfiles-linux/.zshrc'
  if curl $zshrc_url > /dev/null; then
    curl $zshrc_url -H 'Cache-Control: no-cache, no-store' -o ~/.zshrc 
    reload
  fi
}
nvim-update() {
  local initvim_url='https://raw.githubusercontent.com/molofgarb/molofgarb-system-scripts/main/dotfiles-linux/init.vim'
  if curl $initvim_url > /dev/null; then
    mkdir -p ~/.config/nvim 
    curl $initvim_url -H 'Cache-Control: no-cache, no-store' -o ~/.config/nvim/init.vim
    reload
  fi
}

# Git aliases
alias 'git diff'='git diff --word-diff=color'
gc() {
    if [ "$1" = "" ]; then return 1; fi
    git status && git add -A && git commit -sm "$1" && git pull && git push
}
alias   gr='git rebase'
gpl() {
    git status && git stash push && git pull && git stash pop
}
alias  gph='git push'
alias  gdf='git diff'
alias   gs='git status'
alias   gl='git log'

# ===== Default Argument Aliases ======
# Use eza instead of ls, or set nice defaults for ls
if which eza > /dev/null; then 
  alias ls="eza -lh --icons --git --sort=type"
  alias la="eza -alh --icons --git --sort=type"
else
  alias ls='ls --color=auto --group-directories-first -lh'
  alias la='ls -ah'
fi

# Use bat instead of cat
if which bat > /dev/null; then 
  alias cat='bat'
fi

# Use zoxide instead of cd
if which zoxide > /dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

# Set nice defaults for grep
alias grep='grep -P --color=auto'

# ssh rebind for ssh in kitty terminal if not in an ssh session
if [[ "$TERM" = "xterm-kitty" ]] && ! [[ -v SSH_CLIENT ]] && ! [[ -v SSH_TTY ]]; then
  alias ssh="kitty +kitten ssh"
fi

# ===== Keybinds =====
bindkey -e
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word
bindkey '^[[3~' delete-char

# ===== Prompt =====
prompt_git_branch() {
    git symbolic-ref --short HEAD 2> /dev/null 
}
NEWLINE=$'\n'
PROMPT_ROOT=(
  '%F{red}%n@%m%f'
  '%F{yellow}%d%f'
  '%F{cyan}%?%f'
  '%F{magenta}${date +"%H:%M:%S"}%f'
  '%F{blue}$(prompt_git_branch)%f'
  '${NEWLINE}%F{green}\#%f '
)
PROMPT_USER=(
  '%F{green}%n@%m%f'
  '%F{yellow}%d%f'
  '%F{cyan}%?%f'
  '%F{magenta}%*%f'
  '%F{blue}$(prompt_git_branch)%f'
  '${NEWLINE}%F{green}\$%f '
)

if [ "$USER" = "root" ]; then PROMPT=${PROMPT_ROOT[@]}; else PROMPT=${PROMPT_USER[@]}; fi

# ===== Zsh options =====
# aliases: expands aliases in noninteractive shell
setopt \
  aliases \
  auto_cd \
  auto_name_dirs \
  auto_pushd \
  auto_resume \
  no_beep \
  cdable_vars \
  csh_null_glob \
  extended_glob \
  extended_history \
  no_glob_dots \
  hist_allow_clobber \
  hist_find_no_dups \
  no_hist_ignore_all_dups \
  hist_ignore_dups \
  hist_reduce_blanks \
  no_hist_save_no_dups \
  inc_append_history \
  no_list_ambiguous \
  no_list_beep \
  long_list_jobs \
  magic_equal_subst \
  no_notify \
  prompt_subst \
  pushd_minus \
  pushd_silent \
  pushd_to_home \
  rc_quotes \
  shwordsplit \
  transient_rprompt \
  hist_ignore_space \
  no_equals \
  sharehistory
  # correct \
  # correct_all \

#cdpath=(. ~)
DIRSTACKSIZE=60

# ===== Options =====
fignore=(\~)
LISTMAX=0
LOGCHECK=60
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh/.zsh_history
watch=(all)
TIMEFMT='%J  %*U user %*S system %P cpu (%*E wasted time).'
WATCHFMT='%n %a %l from %m at %t.'
WORDCHARS="${WORDCHARS:s#/#}"

# For VSCodium to recognize the current git branch
cd .

# ==============================================================================
# ===== Plugins ================================================================ 
# ==============================================================================
# fzf
if [ "$(command -v fzf)" ]; then
    source <(fzf --zsh)
fi

# zsh-syntax-highlighting
if [ "$(uname)" = "Linux" ] && \
   [ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]
then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    zsh_syntax_highlighting_enabled=true
fi
if [ "$(uname)" = "Darwin" ] && \
   [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]
then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    zsh_syntax_highlighting_enabled=true
fi
if [ -v zsh_syntax_highlighting_enabled ]; then
    ZSH_HIGHLIGHT_STYLES[arg0]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=white
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=green
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=green
fi

# zsh-completions
autoload -Uz compinit
autoload -U colors && colors
compinit
_comp_options+=(globdots)

# zsh-autosuggestions
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ==============================================================================
# ===== zshrc_local override ===================================================
# ==============================================================================

if [ -f ~/.zsh/.zshrc_local ]; then
    source ~/.zsh/.zshrc_local
else
    echo ~/.zsh/.zshrc_local not found
fi
