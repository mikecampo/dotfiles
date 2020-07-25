#!/usr/bin/env bash

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

error() {
  printf "${BOLD}${RED}$1${NORMAL}\n"
}

abort() {
  error "\nAborting..."
  exit 1
}

set -e

cwd=$PWD

uname_s="$(uname -s)"
case "${uname_s}" in
    Linux*)   machine=Linux;;
    Darwin*)  machine=Mac;;
    CYGWIN*)  machine=Cygwin;;
    MINGW*)   machine=MinGw;;
    *)        machine="UNKNOWN:${uname_s}"
esac

printf "${YELLOW}Platform: $machine${NORMAL}\n"
