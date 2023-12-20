#!/bin/sh

# Check for XCode Command Line Tools
if ! xcode-select -p &> /dev/null; then
  echo "Installing XCode Command Line Tools"
  xcode-select --install
else
  echo "XCode Command Line Tools already installed"
fi

# Homebrew Installation
if ! command -v brew &> /dev/null; then
  echo "Installing HomeBrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "HomeBrew already installed"
fi

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Install Brewfile
echo "Checking Brewfile installations"
brew bundle check --file=./Brewfile || brew bundle --file=./Brewfile

# Configure git if not already configured
GIT_USER_NAME=$(git config --global user.name)
GIT_USER_EMAIL=$(git config --global user.email)
if [ "$GIT_USER_NAME" != "dugiahuy" ] || [ "$GIT_USER_EMAIL" != "dugiahuy@gmail.com" ]; then
  echo "Configuring Git"
  git config --global user.name "dugiahuy"
  git config --global user.email "dugiahuy@gmail.com"
else
  echo "Git already configured"
fi

# Install and Configure Prezto
if [[ ! -d "${ZDOTDIR:-$HOME}/.zprezto" ]]; then
  echo "Installing Prezto"
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

echo "Updating Prezto configurations"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# Setting ZSH as the default shell
if [ "$(dscl . -read ~/ UserShell | awk '{print $2}')" != "/bin/zsh" ]; then
  echo "Setting ZSH as the default shell"
  chsh -s /bin/zsh
else
  echo "ZSH is already the default shell"
fi

# Creating symlinks for .zshrc and .zpreztorc
echo "Creating symlinks for .zshrc and .zpreztorc"
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zpreztorc ~/.zpreztorc

echo "Setup complete!"

