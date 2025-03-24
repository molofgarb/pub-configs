# molofgarb's zshrc
# you probably need to install:
#   - zsh-syntax-highlighting
#   - zsh-autosuggestions
#   - fzf
#   - vim-plug

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
alias ls='ls --color=auto --group-directories-first -lh'
alias la='ls -ah'
alias grep='grep --color=auto'
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

git-fastcommit() {
    if [ "$1" = "" ]; then return 1; fi
    git status && git add -A && git commit -sm "$1" && git push
}

# ===== Plugins (fuzzybacksearch, syntax highlighting, autosuggestions, autocomplete) =====
# fzf
if [ "$(command -v fzf)" ]; then
    source <(fzf --zsh)
fi

# Syntax highlighting
if [ "$(uname)" = "Linux" -a -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_SYNTAX_HIGHLIGHTING_ENABLED=1
fi
if [ "$(uname)" = "Darwin" ]; then
    if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
        source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_SYNTAX_HIGHLIGHTING_ENABLED=1
    fi
fi
if [ $ZSH_SYNTAX_HIGHLIGHTING_ENABLED ]; then
    ZSH_HIGHLIGHT_STYLES[arg0]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=white
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=green
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=green
fi

# Autosuggestions
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Autocomplete (by pressing tab)
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
#eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'


# ===== Keybinds =====
bindkey -e
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word
bindkey '^[[3~' delete-char

# ===== Enable auto-execution of functions, load modules, load functions =====
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
unset preexec_functions
unset precmd_functions
unset chpwd_functions
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

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
  no_share_history \
  shwordsplit \
  transient_rprompt \
  hist_ignore_space \
  no_equals \

# ===== Prompt =====
if [[ "$USER" == "root" ]] ; then
    PROMPT=$'%B%F{red}%n%b%F{green}@%B%F{green}%m%b %B%F{yellow}%d%b%F{default}%F{red}$(prompt_git_info)%F{default} %F{blue}%?'$'\n''%(!.%F{red}#%F{default}.%F{green}$%F{default}) '
else
    preexec_functions+='preexec_update_git_vars'
    precmd_functions+='precmd_update_git_vars'
    chpwd_functions+='chpwd_update_git_vars'

    PROMPT=$'%B%F{green}%n%b%F{green}@%B%F{green}%m%b %B%F{yellow}%d%b%F{default}%F{red}$(prompt_git_info)%F{default} %F{blue}%?'$'\n''%(!.%F{red}#%F{default}.%F{green}$%F{default}) '
fi

# ===== Colors =====
autoload -U colors
colors

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
setopt histignorealldups sharehistory

# ==============================================================================
# ===== VSCODIUM TO RECOGNIZE GIT BRANCH =======================================
# ==============================================================================

export fpath=(~/.zsh/functions $fpath)

cd .

# ==============================================================================
# ===== zshrc_local override ===================================================
# ==============================================================================

if [ -f ~/.zsh/.zshrc_local ]; then
    source ~/.zsh/.zshrc_local
else
    echo ~/.zsh/.zshrc_local not found
fi
