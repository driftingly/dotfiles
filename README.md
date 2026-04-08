# Anthony's Dotfiles

Borrows heavily from [Dries Vints' dotfiles](https://github.com/driesvints/dotfiles) and [Freek Van der Herten's dotfiles](https://github.com/freekmurze/dotfiles).

## Setting up a new Mac

1. Update macOS to the latest version via the App Store.
2. Sign in to 1Password and enable the SSH agent (Settings → Developer → Use the SSH agent). This handles your SSH key and commit signing — no need to generate keys manually.
3. Clone this repo:

   ```zsh
   git clone git@github.com:driftingly/dotfiles.git ~/.dotfiles
   ```

4. Run the install script:

   ```zsh
   ~/.dotfiles/bin/install
   ```

5. Restart your computer to finalize.

## Updating

To pull the latest dotfiles and refresh Homebrew packages:

```zsh
~/.dotfiles/bin/update
```

## Notes

- Machine-specific shell config (e.g. Herd's auto-injected PHP paths) belongs in `~/.zshrc.local`, which `.zshrc` sources if present. Don't commit it.

## Mac App Store only (no Homebrew cask exists)

### Install via App Store

- AnyList
- Festivitas
- Pixelmator Pro
- WireGuard (the GUI client)

If you want to script these, the pattern is:

```
brew 'mas'
mas '1Password 7 - Password Manager', id: 1333542190
mas 'Numbers', id: 409203825
mas 'Xcode',   id: 497799835
# etc.
```

### Others:
- Actions For Obsidian — Obsidian community plugin, installed from inside Obsidian
- Browser Actions — Safari extension
- Polyscope
- Showcode
- Solo
- Tim
