#!/bin/sh

ZSH_CUSTOM=$HOME/.dotfiles/zsh

echo "Cloning Zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/jessarcher/zsh-artisan.git $ZSH_CUSTOM/plugins/artisan
git clone https://github.com/paulirish/git-open.git $ZSH_CUSTOM/plugins/git-open

echo "Cloning repositories..."

SITES=$HOME/Sites

# Personal
git clone git@github.com:driftingly/anthony.git $SITES/anthony
