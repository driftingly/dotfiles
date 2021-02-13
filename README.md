# Anthony's Dotfiles

This repository borrows **heavily** from Dries Vints' dotfiles.

- View the code: https://github.com/driesvints/dotfiles
- Read the blog post: https://driesvints.com/blog/getting-started-with-dotfiles
- Watch the screencast on Laracasts: https://laracasts.com/series/guest-spotlight/episodes/1

## Before you re-install

Checkout the checklist at https://github.com/driesvints/dotfiles#before-you-re-install

## Setting up your Mac

If you did all of the above you may now follow these install instructions to setup a new Mac.

1) Update macOS to the latest version with the App Store
2) Install Xcode from the App Store, open it and accept the license agreement
3) Install macOS Command Line Tools by running `xcode-select --install`
    For newer version of Xcode you may need to download CLT manually from https://developer.apple.com/download/more/
4) [Generate a new public and private SSH key](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and add them to Github
5) Clone this repo to `~/.dotfiles`
6) Install Oh My Zsh
7) Run `fresh.sh` to start the installation
8) Restart your computer to finalize the process
