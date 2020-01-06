#!/bin/bash

source "../script_helpers/printing.sh"

set -e

printf "Installing env...\n"
ln -sf $HOME/.dotfiles/osx/env.platform $HOME/.env.platform

printf "Installing git customizations...\n"
ln -sf $HOME/.dotfiles/osx/gitconfig.platform $HOME/.gitconfig.platform

brew tap homebrew/core

printf "Installing xquartz..."
#brew cask install xquartz

brew_packages=(
  'tree'
  'openssl'
  'git'
#  'xclip'
  'rlwrap'
  'cmake'
  'pkg-config'
  'vim'
  'the_silver_searcher'
  'selecta'
#  'rust'
#  'go'
  'sdl')

for package in "${brew_packages[@]}"
do
  printf "Installing $package..."
  ret=$(brew list | awk /$package/)
  if [[ $ret == $package ]]; then
    printf "${YELLOW}already installed!${NORMAL}\n"
  else
    eval "brew install $package"
    printf \n
  fi
done

printf "\n${YELLOW}Now you must install Xcode.${NORMAL}\n"
printf "Open the App Store and install the software.\n"
printf "When that finishes open a terminal and run the following:\n"
printf "  1. ${YELLOW}sudo xcode-select --install${NORMAL}\n"
printf "  2. ${YELLOW}sudo xcodebuild -license${NORMAL}\n"
printf "  3. ${YELLOW}sudo xcode-select -s /Applications/Xcode.app/Contents/Developer${NORMAL}\n"

printf "\n${BOLD}Finished setting up OS X${NORMAL}\n"
