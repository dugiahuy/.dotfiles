#!/bin/sh

# Install XCode
sudo xcodebuild -license # agree with license
xcode-select --install # Install command line tool

echo "Install HomeBrew"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

echo "Install Brewfile"
brew bundle --file=./Brewfile

# Config github
echo "Config Git"
git config --global user.name dugiahuy
git config --global user.email dugiahuy@gmail.com

# Install Prezto
if [[ -d "~/.zprezto" ]]; then
  echo "Prezto installed, refresh configs"
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/*.md; do
    if [[ "$rcfile" != *"README.md" ]]; then
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile##*/}"
    fi
  done
else
  echo "Install Prezto"
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/*.md; do
    if [[ "$rcfile" != *"README.md" ]]; then
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile##*/}"
    fi
  done
fi

echo "Set ZSH as default shell"
chsh -s /bin/zsh

echo "Make symlinks to .zshrc and .zpreztorc"
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zpreztorc ~/.zpreztorc
