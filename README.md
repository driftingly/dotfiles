# Anthony's Dotfiles

Borrows heavily from [Dries Vints' dotfiles](https://github.com/driesvints/dotfiles) and [Freek Van der Herten's dotfiles](https://github.com/freekmurze/dotfiles).

## Setting up a new Mac

1. Update macOS to the latest version via the App Store.
2. [Download and install 1Password](https://1password.com/downloads/mac/). Sign in, then enable the SSH agent (Settings → Developer → Use the SSH agent). This handles your SSH key and commit signing — no need to generate keys manually.
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
  Brewfile        Homebrew packages and casks
  claude/         Claude Code config, agents, and skills
  ghostty/        Ghostty terminal config
git/              .gitconfig and .gitignore_global
macos/            macOS system defaults (configure.sh)
zsh/              .zshrc, aliases, exports, functions
```

## Notes

- Machine-specific shell config (e.g. Herd's auto-injected PHP paths) belongs in `~/.zshrc.local`, which `.zshrc` sources if present. Don't commit it.
- The macOS defaults script (`macos/configure.sh`) can be re-run independently. It will prompt for confirmation before making changes.

## Mac App Store / manual installs

### App Store

- AnyList
- Festivitas
- Pixelmator Pro
- WireGuard (the GUI client)

### Other (manual download or in-app install)

- [Grammarly](https://www.grammarly.com/desktop)
- Actions For Obsidian — Obsidian community plugin, installed from inside Obsidian
- Browser Actions — Safari extension
- Polyscope
- Showcode
- Solo
- Tim
