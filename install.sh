#!/bin/sh

install_brew() {
  if command -v brew >/dev/null 2>&1; then
    echo "Homebrew is already installed."
  else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Adding Homebrew to PATH.."
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

# ensure Homebrew exists before anything below uses it
install_brew

brew update && brew bundle --file=~/.dotfiles/homebrew/Brewfile

# install global tools from ~/.config/mise/config.toml (uv, ...)
mise install

# make the uv-managed python the global default (python/python3 in ~/.local/bin)
uv python install --default

# use the repo's tracked git hooks (keeps the intelli-shell export in sync on commit)
git -C "$HOME/.dotfiles" config core.hooksPath .githooks

# restore the intelli-shell command library and dynamic completions
if command -v intelli-shell >/dev/null 2>&1 && [ -f "$HOME/.dotfiles/intelli-shell/commands.bak" ]; then
  intelli-shell import "$HOME/.dotfiles/intelli-shell/commands.bak"
fi
