# Anthony's Dotfiles

Borrows heavily from [Dries Vints' dotfiles](https://github.com/driesvints/dotfiles) and [Freek Van der Herten's dotfiles](https://github.com/freekmurze/dotfiles).

## Setting up a new Mac

1. Update macOS to the latest version via the App Store.
2. Install 1Password from the terminal (or [download it manually](https://1password.com/downloads/mac/)):

   ```zsh
   curl -fL -o /tmp/1Password.pkg https://downloads.1password.com/mac/1Password.pkg \
     && pkgutil --check-signature /tmp/1Password.pkg \
     && sudo installer -pkg /tmp/1Password.pkg -target / \
     && rm /tmp/1Password.pkg
   ```

   The signature check stops the install if the package is unsigned or tampered with. Its output should name AgileBits Inc. as the developer. Sign in, then enable the SSH agent (Settings → Developer → Use the SSH agent). This handles your SSH key and commit signing, so there is no need to generate keys manually.
3. Clone this repo:

   ```zsh
   git clone git@github.com:driftingly/dotfiles.git ~/.dotfiles
   ```

   > If the SSH clone fails (1Password SSH agent not yet working), use HTTPS and switch later:
   > ```zsh
   > git clone https://github.com/driftingly/dotfiles.git ~/.dotfiles
   > ```

4. Run the install script:

   ```zsh
   ~/.dotfiles/bin/install
   ```

   This will prompt for confirmation, then:
   - Install Oh My Zsh and zsh plugins
   - Install Homebrew and everything in the Brewfile
   - Symlink shell, git, Ghostty, and Claude Code config
   - Set up fzf shell integration
   - Install Node (via fnm) and global npm packages
   - Apply macOS system defaults (will prompt separately)

5. Install apps that aren't available via Homebrew (see [below](#mac-app-store--manual-installs)).
6. Restart your computer to finalize.

## Setting up a development VM

macOS VMs get only the core development tools. Follow the steps above, but run the install script with `--vm`:

```zsh
~/.dotfiles/bin/install --vm
```

This installs `config/Brewfile` (core tools) and skips `config/Brewfile.full` (personal apps and extras). The profile is saved to `~/.dotfiles/.profile`, so `bin/update` and later runs of `bin/install` keep using it without the flag. Run `bin/install --full` to switch a machine to the full profile. A machine with no saved profile is treated as full.

On the vm profile, the shell prompt starts with a yellow `[vm]` label so you can always tell the two machines apart.

## Updating

Pull the latest dotfiles and refresh everything:

```zsh
~/.dotfiles/bin/update
```

This updates the dotfiles repo, Homebrew packages, Oh My Zsh, zsh plugins, and global npm packages.

## Structure

```
bin/              Install and update scripts
config/
  Brewfile        Core Homebrew packages and casks (every machine)
  Brewfile.full   Extra packages and apps (full profile only)
  claude/         Claude Code config, agents, and skills
  ghostty/        Ghostty terminal config
git/              .gitconfig and .gitignore_global
macos/            macOS system defaults (configure.sh)
zsh/              .zshrc, aliases, exports, functions
```

## Notes

- Herd appends its PHP exports directly to `~/.zshrc`, so those live in `zsh/.zshrc` alongside everything else.
- The macOS defaults script (`macos/configure.sh`) can be re-run independently. It will prompt for confirmation before making changes.

## Mac App Store / manual installs

### App Store

- AnyList
- Festivitas
- Pixelmator Pro
- WireGuard (the GUI client)

### Other (manual download or in-app install)

- [Grammarly](https://www.grammarly.com/desktop)
- Actions For Obsidian (Obsidian community plugin, installed from inside Obsidian)
- Browser Actions (Safari extension)
- Polyscope
- Showcode
- Solo
- Tim
