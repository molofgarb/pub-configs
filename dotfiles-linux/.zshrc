#!/bin/zsh
# molofgarb's zshrc
# you probably need to install:
#   - fzf
#   - zsh-syntax-highlighting
#   - zsh-completions
#   - zsh-autosuggestions
#   - vim-plug

# ==============================================================================
# ===== CORE ===================================================================
# ==============================================================================

# ===== Variables =====
export EDITOR='nvim'
export VISUAL='nvim'

# ===== Aliases =====
alias reload='source ~/.zshrc'
alias zshrc='$EDITOR ~/.zshrc'
alias zshrc_local='$EDITOR ~/.zsh/.zshrc_local'
alias zshrc-update="curl https://raw.githubusercontent.com/molofgarb/molofgarb-system-scripts/main/dotfiles-linux/.zshrc > /dev/null &&
    curl https://raw.githubusercontent.com/molofgarb/molofgarb-system-scripts/main/dotfiles-linux/.zshrc -o ~/.zshrc &&
    reload"
alias nvim-update="curl https://raw.githubusercontent.com/molofgarb/molofgarb-system-scripts/main/dotfiles-linux/init.vim > /dev/null &&
    mkdir -p ~/.config/nvim &&
    curl https://raw.githubusercontent.com/molofgarb/molofgarb-system-scripts/main/dotfiles-linux/init.vim -o ~/.config/nvim/init.vim"

# Git aliases
gitc() {
    if [ "$1" = "" ]; then return 1; fi
    git status && git add -A && git commit -sm "$1" && git push
}
alias gpl='git pull'
alias gdf='git diff'
alias gs='git status'
alias gitpl='git pull'

# ===== Realiases =====
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
alias grep='grep --color=auto'

# ssh rebind for ssh in kitty terminal
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

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
  '%F{orange}%d%f'
  '%F{blue}%?%f'
  '%F{cyan}$(prompt_git_branch)%f'
  '${NEWLINE}%F{green}\$%f '
)
PROMPT_USER=(
  '%F{green}%n@%m%f'
  '%F{yellow}%d%f'
  '%F{blue}%?%f'
  '%F{cyan}$(prompt_git_branch)%f'
  '${NEWLINE}%F{green}\$%f '
)

if [ "$USER" = "root" ]; then PROMPT=${PROMPT_ROOT[*]}; else PROMPT=${PROMPT_USER[@]}; fi

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
  correct \
  correct_all \
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

#cdpath=(. ~)
DIRSTACKSIZE=60

# ===== Options =====
fignore=(\~)
LISTMAX=0
LOGCHECK=60
HISTSIZE=20000
HISTFILE=~/.zsh_history
SAVEHIST=30000000
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

# zsh-yntax-highlighting
if [ "$(uname)" = "Linux" ] && \
   [ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]
then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_SYNTAX_HIGHLIGHTING_ENABLED=1
fi
if [ "$(uname)" = "Darwin" ] && \
   [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]
then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_SYNTAX_HIGHLIGHTING_ENABLED=1
fi
if [ $ZSH_SYNTAX_HIGHLIGHTING_ENABLED ]; then
    ZSH_HIGHLIGHT_STYLES[arg0]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=white
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=green
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=green
fi

# zsh-completions
autoload -Uz compinit
compinit
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

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
