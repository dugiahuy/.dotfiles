#!/bin/sh

# Detect OS
OS=$(uname -s)
dotfiles=$(pwd)

if [ "$OS" = "Darwin" ]; then
  # Check for XCode Command Line Tools (macOS only)
  if ! xcode-select -p >/dev/null 2>&1; then
    echo "Installing XCode Command Line Tools"
    xcode-select --install
  else
    echo "XCode Command Line Tools already installed"
  fi

  # Homebrew Installation
  if ! command -v brew >/dev/null 2>&1; then
    echo "Installing HomeBrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "HomeBrew already installed"
  fi

  # Install Brewfile
  export HOMEBREW_CASK_OPTS="--appdir=/Applications"
  echo "Checking Brewfile installations"
  brew bundle check --file=./Brewfile || brew bundle --file=./Brewfile
fi

if [ "$OS" = "Linux" ]; then  # macOS
  if ! apt update >/dev/null 2>&1; then
    echo "Updating package index..."
    apt-get update
  fi

  if ! dpkg --list | grep -q "git"; then
    echo "Installing Git"
    sudo apt-get install git -y
  else
    echo "Git already installed"
  fi
fi

# Configure git (if not already configured)
GIT_USER_NAME=$(git config --global user.name)
GIT_USER_EMAIL=$(git config --global user.email)
if [ "$GIT_USER_NAME" != "dugiahuy" ] || [ "$GIT_USER_EMAIL" != "dugiahuy@gmail.com" ]; then
  echo "Configuring Git"
  git config --global user.name "dugiahuy"
  git config --global user.email "dugiahuy@gmail.com"
else
  echo "Git already configured"
fi

# Install and Configure Prezto (if not already installed)
if [ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]; then
  echo "Installing Prezto"
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

echo "Updating Prezto configurations"
setopt EXTENDED_GLOB
find "${ZDOTDIR:-$HOME}/.zprezto/runcoms" -type f -not -name "README.md" | while IFS= read -r rcfile; do
  ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile##*/}"
done

# Set ZSH as the default shell (if not already set)
echo "Setting ZSH as the default shell"
if ! [ "$SHELL" = "/bin/zsh" ]; then
  echo "Do you want to set ZSH as the default shell? (y/n): "
  read -r answer
  if [ "$answer" = "y" ]; then
    chsh -s /bin/zsh
    echo "ZSH is now the default shell"
  else
    echo "Skipping setting ZSH as the default shell"
  fi
else
  echo "ZSH is already the default shell"
fi

# Create symlinks for .zshrc and .zpreztorc (if not already created)
# Ask to overwrite from user
if ! [ -L "${HOME}/.zshrc" ] || ! [ -L "${HOME}/.zpreztorc" ]; then
  echo "Creating customized symlinks for .zshrc and .zpreztorc"
  echo "Do you want to overwrite existing files? (y/n): "
  read -r answer
  if [ "$answer" = "y" ]; then
    # Backup existing .zshrc and .zpreztorc files
    echo "Backing up existing .zshrc and .zpreztorc files"
    mv ~/.zshrc ~/.zshrc.backup
    mv ~/.zpreztorc ~/.zpreztorc.backup
    ln -sf "$dotfiles/.zshrc" ~/.zshrc
    ln -sf "$dotfiles/.zpreztorc" ~/.zpreztorc
  else
    echo "Skipping symlink creation"
  fi
fi

echo "Setup complete!"