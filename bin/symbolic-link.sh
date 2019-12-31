#!/bin/bash

# @improve this path stuff
source_helpers="$HOME/.dotfiles/script_helpers"
source "$source_helpers/printing.sh"
source "$source_helpers/file_ops.sh"

abort() {
  error "\nAborting...\n"
  exit 1
}

# If the path is not symbolic or an absolute drive path then we return it in an expanded form.
clean_path() {
  path=$1
  if [[ $(is_absolute_unix_path $path) -eq 0 && $(is_sym_file $path) -eq 0 ]]; then
    path=$(expand_path "$path")
  fi
  echo $path
}

path_debug() {
  path=$1
  printf "\ninfo on path '$path'\n"
  printf "abs unix path: $(is_absolute_unix_path $path)\n"
  printf "sym file: $(is_sym_file $path)\n"
  if [[ $path =~ \/+ ]]; then echo "unix path\n"; else echo "not unix path\n"; fi
  expanded_path=$(expand_path "$path")
  printf "expanded version: $expanded_path\n"
  if [[ $(is_absolute_unix_path $path) -eq 0 && $(is_sym_file $path) -eq 0 ]]; then
    printf "needs cleaning\n"
  else
    printf "no cleaning needed\n"
  fi
}

cwd=$PWD
platform=`uname` # 'Linux', 'Darwin', etc
source_path=""
dest_path=""

#echo "got $1 and $2"
#path_debug $1
#path_debug $2

if [[ $1 ]]; then
  source_path="$1"
else
  printf "${BOLD}${YELLOW}Enter full path to source file/dir:\n${NORMAL}"
  read -e source_path
fi

source_path=$(clean_path "$source_path")
! test -d "$source_path" && ! test -e "$source_path" && error "Source path '$source_path' doesn't exist!" && abort

if [[ $2 ]]; then
  dest_path="$2"
else
  printf "${BOLD}${YELLOW}Enter full path to symlink destination:\n${NORMAL}"
  read -e dest_path
fi

dest_path=$(clean_path $dest_path)
test -d "$dest_path" && error "Dest folder '$dest_path' already exists!" && abort
test -e "$dest_path" && error "Dest file '$dest_path' already exists!" && abort

source_path=$(windows_path $source_path)
dest_path=$(windows_path $dest_path)

cmd="cmd //c 'mklink  $dest_path $source_path'"

echo "${BOLD}${BLUE}Will attempt to link ${GREEN}$source_path${BLUE} to ${GREEN}$dest_path${BLUE}"
printf "\n${BOLD}Enter 1 to proceed\n${YELLOW}> ${NORMAL}"
read confirm

if [[ $confirm == 1 ]]; then
  eval "$cmd"
else
  abort
fi
