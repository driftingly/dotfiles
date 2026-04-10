# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Theme
ZSH_THEME="robbyrussell"

# History timestamp format
HIST_STAMPS="yyyy-mm-dd"

# Tell oh-my-zsh where our custom plugins live (zsh/plugins/<name>)
ZSH_CUSTOM=$HOME/.dotfiles/zsh

# Plugins
plugins=(
    git
    git-open
    artisan
    colorize
)

source $ZSH/oh-my-zsh.sh

# zsh-autosuggestions and zsh-syntax-highlighting come from Homebrew so they
# stay updated via `brew upgrade`. Order matters: syntax-highlighting MUST be
# sourced last, or its hooks conflict with autosuggestions.
if command -v brew &>/dev/null; then
    BREW_PREFIX="$(brew --prefix)"
    [ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
        source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
        source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    unset BREW_PREFIX
fi

# Load the shell dotfiles (exports first so later files can use the vars)
for file in ~/.dotfiles/zsh/{exports,aliases,functions}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Modern CLI tool initialization
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
command -v fnm    &>/dev/null && eval "$(fnm env --use-on-cd)"
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/anthony/Library/Application Support/Herd/config/php/84/"

# Herd injected PHP binary.
export PATH="/Users/anthony/Library/Application Support/Herd/bin/":$PATH
