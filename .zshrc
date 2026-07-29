if [ -n "$GHOSTTY_RESOURCES_DIR" ]; then
  source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi

export EDITOR='nvim'
export VISUAL='nvim'

# --- ZINIT SETUP ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Load Oh My Zsh plugins (Snippets)
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::lib/clipboard.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::docker
zinit snippet OMZP::golang
zinit snippet OMZP::rust
zinit snippet OMZP::python
zinit snippet OMZP::pip
zinit snippet OMZP::fzf

# Load modern fast plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light MichaelAquilina/zsh-you-should-use
zinit light fdellwing/zsh-bat
# -------------------

# --- Aliases ---
alias google='f() { lynx -accept_all_cookies -useragent="AdsBot-Google (+http://www.google.com/adsbot.html)" "https://www.google.com/search?q=$*" }; f'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Core Utilities
alias ls="eza --icons=always"
alias l="eza -lh --icons=always"
alias ll="eza -lah --icons=always"
alias la="eza -a --icons=always"
alias tree="eza --tree --icons=always"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias mkdir='mkdir -p'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

# Quick Config Access
alias zshconfig="nvim ~/.zshrc"
alias reload="source ~/.zshrc"

# Git (Simplified)
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'

# Proxy
alias px='http_proxy=http://127.0.0.1:10808 https_proxy=http://127.0.0.1:10808 ALL_PROXY=socks5://127.0.0.1:10808'

# Thesis
alias ss='z the && lazygit'

# Paths
export PNPM_HOME="/home/mohireza/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH="/home/mohireza/.gapcode/bin:$PATH"
export PATH=$PATH:/home/mohireza/.spicetify

# Zoxide (Smarter cd)
eval "$(zoxide init zsh)"

# Fix word deletion for Ctrl+Backspace and Alt+Backspace
bindkey '^H' backward-kill-word
bindkey '^[^?' backward-kill-word

# Fix word jumping for Ctrl+Left and Ctrl+Right
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Fix btop UTF-8 font issue
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Starship Prompt
eval "$(starship init zsh)"

# pnpm
export PNPM_HOME="/home/mohireza/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
