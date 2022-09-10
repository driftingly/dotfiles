# Anthony's Dotfiles

This repository borrows **heavily** from Dries Vints' dotfiles.

- View the code: https://github.com/driesvints/dotfiles
- Read the blog post: https://driesvints.com/blog/getting-started-with-dotfiles
- Watch the screencast on Laracasts: https://laracasts.com/series/guest-spotlight/episodes/1

## Before you re-install

Checkout the checklist at https://github.com/driesvints/dotfiles#before-you-re-install

### Setting up your Mac

If you did all of the above you may now follow these install instructions to setup a new Mac.

1. Update macOS to the latest version with the App Store
2. You can now use 1Password to configure your SSH Key and Signing or
[Generate a new public and private SSH key](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) by running:

   ```zsh
   curl https://raw.githubusercontent.com/driesvints/dotfiles/HEAD/ssh.sh | sh -s "<your-email-address>"
   ```

3. Clone this repo to `~/.dotfiles` with:

    ```zsh
    git clone git@github.com:driftingly/dotfiles.git ~/.dotfiles
    ```

4. Run `~/.dotfiles/fresh.sh` to start the installation
5. After mackup is synced with your cloud storage (check local icloud is synced), restore preferences by running mackup restore
6. Restart your computer to finalize the process

## Other settings

### iTerm
Natural text editing: https://twitter.com/ericlbarnes/status/1415049563933757441?s=21

## Other Applications
https://laravelshift.com/workbench


## Homebrew

Homebrew is "_the missing package manage for macOS_" which lets you install OSS.  I use it for installing and managing much of the software needed for web development.

[This tutorial](https://medium.com/@kkworden/a-beginners-guide-to-homebrew-4b665956a74) is a good place to start if you are new to Homebrew.

### Terminology

- **formula**: Homebrew package definition built from upstream sources
- **cask**: Homebrew package definition that installs macOS native applications
- **keg**: installation destination directory of a given formula version e.g. /usr/local/Cellar/foo/0.1
- **rack**: directory containing one or more versioned kegs e.g. /usr/local/Cellar/foo
- **keg-only**: a formula is keg-only if it is not symlinked into Homebrew’s prefix (e.g. /usr/local)
- **cellar**: directory containing one or more named racks e.g. /usr/local/Cellar
- **Caskroom**: directory containing one or more named casks e.g. /usr/local/Caskroom
- **external** command: brew subcommand defined outside of the Homebrew/brew GitHub repository
- **tap**: directory (and usually Git repository) of formulae, casks and/or external commands
- **bottle**: pre-built keg poured into the cellar/rack instead of building from upstream sources

 So, **tap** = **repository**, **cellar** = **local install location**, **formula** = **software package**.


### Commands

For the full command list, see the [COMMANDS](https://docs.brew.sh/Manpage#commands) section of the docs.

Installing formulae (software packages):

```bash
brew install <formula>
# Node example
brew install node
```

Uninstalling:

```bash
brew uninstall <formula>
```

List all installed formulae (software packages) and casts (native applications):

```bash
brew list
```

Tap a formula repository (usually a git repository), if no arguments are provided, list all installed taps:

```bash
brew tap
```

By default, Homebrew assumes that you are looking for a repository on Github. The convention for tap names is `<user>/<repo>`.

To actually add new taps, use one of the following commands:

```bash
brew tap <user>/<repo>
```

Fetch the newest version of Homebrew and all formulae from GitHub:

```bash
brew update
```

> Homebrew will typically keep itself up-to-date when you run other brew commands, but calling this is still a good practice.

Upgrade outdated casks and outdated, unpinned formulae using the same options they were originally installed with, plus any appended brew formula options. If cask or formula are specified, upgrade only the given cask or formula kegs (unless they are pinned; see pin, unpin).

Typically you want to update beforehand.

```bash
brew update && brew upgrade
```

To remove old versions of packages and free up space, you can run:

```bash
brew cleanup
```
