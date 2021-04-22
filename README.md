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
2. [Generate a new public and private SSH key](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) by running:

   ```zsh
   curl https://raw.githubusercontent.com/driesvints/dotfiles/HEAD/ssh.sh | sh -s "<your-email-address>"
   ```

3. Clone this repo to `~/.dotfiles` with:

    ```zsh
    git clone git@github.com:driftingly/dotfiles.git ~/.dotfiles
    ```

4. Run `~/.dotfiles/fresh.sh` to start the installation
5. Restart your computer to finalize the process
