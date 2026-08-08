#!/bin/zsh
# shellcheck disable=SC1071
# molofgarb's zshrc
# you probably need to install:
#   - zsh-syntax-highlighting
#   - zsh-autosuggestions
#   - zsh-autocomplete
#   - fzf
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
    local zshrc_url='https://raw.githubusercontent.com/molofgarb/molofgarb-system-scripts/main/zsh/.zshrc'
    if curl $zshrc_url > /dev/null; then
        curl $zshrc_url -H 'Cache-Control: no-cache, no-store' -o ~/.zshrc 
        reload
    fi
}
nvim-update() {
    local initvim_url='https://raw.githubusercontent.com/molofgarb/molofgarb-system-scripts/main/neovim/init.vim'
    if curl $initvim_url > /dev/null; then
        mkdir -p ~/.config/nvim 
        curl $initvim_url -H 'Cache-Control: no-cache, no-store' -o ~/.config/nvim/init.vim
    fi
}

# Pre-load an optional pre-local file to execute/set vars in case they need to 
# be set before this file gets sourced
if [[ -f ~/.zsh/.zshrc_pre_local ]]; then
    source ~/.zsh/.zshrc_pre_local
fi

# ==============================================================================
# ===== Program Aliases ========================================================
# ==============================================================================
# Use eza instead of ls, or set nice defaults for ls
# Use bat instead of cat
# Use zoxide instead of cd
if which eza > /dev/null; then 
    alias ls="eza -lh --icons --git --sort=type"
    alias la="eza -alh --icons --git --sort=type"
else
    alias ls='ls --color=auto --group-directories-first -lh'
    alias la='ls -ah'
fi
if which bat > /dev/null; then alias cat='bat'; fi

# Set nice defaults for grep
alias grep='grep -P --color=auto'

# ssh rebind for ssh in kitty terminal if not in an ssh session
if [[ "$TERM" = "xterm-kitty" ]] && ! [[ -v SSH_CLIENT ]] && ! [[ -v SSH_TTY ]]; then
    alias ssh="kitty +kitten ssh"
fi

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


# ==============================================================================
# ===== Keybinds ===============================================================
# ==============================================================================
bindkey -e
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word
bindkey '^[[3~' delete-char

# ==============================================================================
# ===== Prompt =================================================================
# ==============================================================================
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

# ==============================================================================
# ===== Options ================================================================
# ==============================================================================
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

# ==============================================================================
# ===== Plugins ================================================================ 
# ==============================================================================

_zsh_syntax_highlighting_plugin_enabled=false
_zsh_autosuggestions_plugin_enabled=false
_zsh_autocomplete_plugin_enabled=false
_zsh_fzf_plugin_enabled=false

# zsh-syntax-highlighting
if [[ "$(uname)" = "Linux" ]] && \
   [[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]
then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    _zsh_syntax_highlighting_plugin_enabled=true
elif [[ "$(uname)" = "Linux" ]] && \
     [[ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]
then
    source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    _zsh_syntax_highlighting_plugin_enabled=true
elif [ "$(uname)" = "Darwin" ] && \
     [[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]
then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    _zsh_syntax_highlighting_plugin_enabled=true
fi
if [[ "$_zsh_syntax_highlighting_plugin_enabled" = 'true' ]]; then
    ZSH_HIGHLIGHT_STYLES[arg0]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=white
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=green
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=green
fi

# zsh-autosuggestions
if  [[ "$(uname)" = "Linux" ]] && \
    [[ -f '/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' ]]
then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    _zsh_autosuggestions_plugin_enabled=true
elif [[ "$(uname)" = "Linux" ]] && \
     [[ -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]
then
    source "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    _zsh_autosuggestions_plugin_enabled=true
fi

# zsh-autocomplete
if [[ -f /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    _zsh_autocomplete_plugin_enabled=true

    # Keybindings below are set to emulate a pwsh MenuComplete-like feel
    # Make Tab and ShiftTab go to the menu
    bindkey              '^I' menu-select
    bindkey "$terminfo[kcbt]" menu-select

    # Make Tab and ShiftTab change the selection in the menu
    bindkey -M menuselect              '^I'         menu-complete
    bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete
    
    # Make Ctrl + ← or → always move the cursor on the command line (not the non-Ctrl ones)
    bindkey -M menuselect  '^[[1;5D' .backward-word  '^[OD' .backward-word
    bindkey -M menuselect  '^[[1;5C' .forward-word   '^[OD' .forward-word

    # Keep up and down as their default bindings
    bindkey \
    "^P"    .up-line-or-history \
    "^[OA"  .up-line-or-history \
    "^[[A"  .up-line-or-history \
    "^N"    .down-line-or-history \
    "^[OB"  .down-line-or-history \
    "^[[B"  .down-line-or-history \

    # Don't add a semicolon after history completions
    zstyle ':autocomplete:*' add-semicolon no
fi

# fzf (this overrides some settings/binds in zsh-autocomplete)
if [ "$(command -v fzf)" ]; then
    source <(fzf --zsh)
    _zsh_fzf_plugin_enabled=true
fi

zshrc-plugin-diagnostic() {
# Reports whether plugins were loaded
    set | grep -Pi '_zsh_.*_plugin_enabled'
}

# ==============================================================================
# ===== zshrc_local override ===================================================
# ==============================================================================

if [[ -f ~/.zsh/.zshrc_local ]]; then
    source ~/.zsh/.zshrc_local
else
    echo ~/.zsh/.zshrc_local not found
fi

# ==============================================================================
# ===== Miscellaneous ==========================================================
# ==============================================================================

# Needs to be near the bottom of the file otherwise other plugin stuff makes it complain
if which zoxide > /dev/null; then eval "$(zoxide init zsh)"; alias cd='z'; fi

# For VSCodium to recognize the current git branch
cd .
