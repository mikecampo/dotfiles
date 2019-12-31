#!/bin/bash

if which tput >/dev/null 2>&1; then
  ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  NORMAL=""
fi

set -e

cwd=$PWD
platform=`uname`

if [[ $platform != 'Linux' && $platform != 'Darwin' ]]; then
  printf "${RED}This is only supported on Linux or OS X.${NORMAL}\n"
  exit
fi

setup_dotfile_repo() {
  if [ ! -d "$HOME/.dotfiles" ]; then
    printf "${YELLOW}Creating dotfiles symlink${NORMAL}\n"
    ln -s $cwd $HOME/.dotfiles
  fi

  # Used by various things (e.g. vim history)
  mkdir -p $HOME/tmp
}

link_file() {
  file=$1
  dest="$HOME/.$file"
  if [ ! -e $dest ]; then
    printf "${YELLOW}Creating ${file} symlink${NORMAL}\n"
    ln -s "$HOME/.dotfiles/$file" $dest
  fi
}

setup_git() {
  printf "Setting up git...\n"

  FILES=()
  FILES+=('gitconfig')
  FILES+=('githelpers')

  for file in "${FILES[@]}"
  do
    link_file "$file"
  done
}

setup_zsh() {
  printf "Setting up zsh...\n"
  TEST_CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
  if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
    if hash chsh >/dev/null 2>&1; then
      printf "\n${BLUE}Changing the default shell to zsh${NORMAL}\n"
      chsh -s $(grep /zsh$ /etc/shells | tail -1)
    else
      printf "\n${RED}Unable to change the shell because this system does not have chsh.\n"
      printf "${BLUE}If this is Windows then you probably want to run the bash installer.${NORMAL}\n"
    fi
  fi

  FILES=()
  FILES+=('zsh')
  FILES+=('zshrc')
  FILES+=('zshenv')
  FILES+=('zlogin')
  FILES+=('zprofile')

  for file in "${FILES[@]}"
  do
    link_file "$file"
  done
}

setup_vim() {
  printf "Setting up vim...\n"

  FILES=()
  FILES+=('vim')
  FILES+=('vimrc')

  for file in "${FILES[@]}"
  do
    link_file "$file"
  done
}

setup_misc() {
  printf "Setting up misc...\n"

  FILES=()
  FILES+=('curlrc')
  FILES+=('racketrc')

  for file in "${FILES[@]}"
  do
    link_file "$file"
  done
}

# ////////////////////////////////////////////////////////////////////////////////////////
# OSX

setup_osx() {
  ./osx/install.sh
}

# ////////////////////////////////////////////////////////////////////////////////////////
# Run

setup_dotfile_repo
setup_git
setup_zsh
setup_vim
setup_misc

if [[ $platform == 'Darwin' ]]; then
  printf "\n${BOLD}Running the OS X installer${NORMAL}\n"
  setup_osx
fi
