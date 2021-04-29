#!/bin/sh

echo "Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# Install global Composer packages
/usr/local/bin/composer global require laravel/installer laravel/valet beyondcode/expose tightenco/takeout squizlabs/php_codesniffer friendsofphp/php-cs-fixer phpstan/phpstan

# Install Laravel Valet
$HOME/.composer/vendor/bin/valet install

# Create a Sites directory
# This is a default directory for macOS user accounts but doesn't comes pre-installed
mkdir $HOME/Sites

# Clone Github repositories
./clone.sh

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc

# Use .gitignore_global
git config --global core.excludesfile ~/.dotfiles/.gitignore_global

# Configure git
git config --global user.name "Anthony Clark"
git config --global user.email anthonyclark@gmail.com
git config --global pull.rebase true

# Set macOS preferences
# We will run this last because this will reload the shell
source .macos
