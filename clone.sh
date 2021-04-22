#!/bin/sh

echo "Cloning Zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/jessarcher/zsh-artisan.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/artisan

echo "Cloning repositories..."

SITES=$HOME/Sites
