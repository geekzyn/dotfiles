#!/bin/sh


install_zsh() {
  if command -v zsh &> /dev/null; then
    echo "Oh My Zsh is already installed."
  else
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "Setting /bin/zsh as the default shell..."
    chsh -s $(which zsh)
  fi
}

install_brew() {
  if command -v brew &> /dev/null; then
    echo "Homebrew is already installed."
  else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Adding Homebrew to PATH.."
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

# remove message of the day prompt
# touch $HOME/.hushlogin

brew update && brew bundle --file=~/.dotfiles/homebrew/Brewfile

# install_zsh
# install_brew
