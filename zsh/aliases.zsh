# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias getssh=copyssh
alias reloadshell="source $HOME/.zshrc"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias ll="/opt/homebrew/Cellar/coreutils/9.1/libexec/gnubin/ls -AhlFo --color --group-directories-first"
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"
alias c="clear"
alias vim="nvim"
alias v="nvim"

# Directories
alias dotfiles="cd $HOME/.dotfiles"
alias library="cd $HOME/Library"
alias sites="cd $HOME/Sites"

# Laravel
alias a="herd php artisan"
alias fresh="herd php artisan migrate:fresh --seed"
alias tinker="herd php artisan tinker"
alias seed="herd php artisan db:seed"
alias atest="herd php artisan test --parallel"
alias serve="herd php artisan serve"
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'
alias vapor="php vendor/bin/vapor"

# PHP
alias cfresh="rm -rf vendor/ composer.lock && composer i"
alias php="herd php"
alias composer="herd composer"

alias php74="~/Library/Application\ Support/Herd/bin/php74"
alias php80="~/Library/Application Support/Herd/bin/php80"
alias php81="~/Library/Application Support/Herd/bin/php81"
alias php82="~/Library/Application Support/Herd/bin/php82"
alias php83="~/Library/Application Support/Herd/bin/php83"

# JS
alias nfresh="rm -rf node_modules/ package-lock.json && npm install"
alias watch="npm run watch"

# Docker
alias docker-composer="docker-compose"

# Git
alias gst="git status"
alias gb="git branch"
alias gc="git checkout"
alias switch="git switch"
alias gl="git log --oneline --decorate --color"
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias diff="git diff"
alias force="git push --force"
alias nuke="git clean -df && git reset --hard"
alias pop="git stash pop"
alias pull="git pull"
alias push="git push"
alias resolve="git add . && git commit --no-edit"
alias stash="git stash -u"
alias unstage="git restore --staged ."
alias wip="commit wip"
alias prune-dry="git remote prune origin --dry-run"
alias prune="git remote prune origin"

# Opens database in applications like TablePlus
# Example 1: `db` command will check env file in its directory and grab env variables and will open that database
# Example 2: `db test` command will open test database
# https://github.com/bhushan/Mac-Setup-From-Scratch/blob/master/6_step_aliases.md
db() {
    if [ $# -eq 0 ]; then
        [ ! -f .env ] && {
            echo "No .env file found."
            return 0
        }

        DB_HOST=$(grep DB_HOST .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
        DB_PORT=$(grep DB_PORT .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
        DB_DATABASE=$(grep DB_DATABASE .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
        DB_USERNAME=$(grep DB_USERNAME .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
        DB_PASSWORD=$(grep DB_PASSWORD .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)

        DB_URL="mysql://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_DATABASE}"
    fi

    if [ $# -eq 1 ]; then
        DB_URL="mysql://127.0.0.1/$1"
    fi

    open $DB_URL
}

# Loop over a test to check an intermitent failure
# loopPhpUnit tests/Unit/Reports/ProductActivityReportTest.php --filter 'it_filters_by_category'
loopPhpUnit()
{
    while true; do vendor/bin/phpunit --stop-on-failure "$@" || break; done;
}
