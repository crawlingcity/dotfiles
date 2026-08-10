# Dotfiles

Clone the repository with its private submodule:

```zsh
git clone --recurse-submodules <repository-url> ~/dotfiles
cd ~/dotfiles
```

Use GNU Stow for the regular dotfile packages:

`git clone https://github.com/LazyVim/starter ~/dotfiles/nvim/.config/nvim`

```zsh
stow --adopt -v nvim
```

Install both AeroSpace configurations:

```zsh
stow aerospace aerospace-fixed
```

Install the private 1Password SSH agent configuration:

```zsh
stow --dir=dotfiles-private --target="$PWD/.." 1password
chmod 600 "$PWD/../.config/1Password/ssh/agent.toml"
```

Install the private SSH host configuration:

```zsh
stow --dir=dotfiles-private --target="$PWD/.." ssh
```

Install the EurKEY keyboard layout:

```zsh
./eurkey/install.sh
```

See [eurkey/README.md](eurkey/README.md) for the required macOS logout and
input-source selection steps.
