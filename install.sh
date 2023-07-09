#!/bin/sh

# Install XCode
sudo xcodebuild -license # agree with license
xcode-select --install # Install command line tool

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

brew bundle --file=./Brewfile

# Config github
git config --global user.name dugiahuy
git config --global user.email dugiahuy@gmail.com

# Make symlinks
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zpreztorc ~/.zpreztorc