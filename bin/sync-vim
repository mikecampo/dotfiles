#!/bin/bash

set -e

if [ ! -d "~/.vim" ]; then
  echo "Syncing user dictionary" && cp ~/.vim/spell/* ~/.dotfiles/vim/spell/
  echo "Syncing user colors" && cp ~/.vim/colors/* ~/.dotfiles/vim/colors/
  echo "Syncing after directory" && cp -r ~/.vim/after ~/.dotfiles/vim/
  echo "Syncing templates" && cp -r ~/.vim/templates ~/.dotfiles/vim/
fi
