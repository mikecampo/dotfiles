#!/usr/bin/env bash

#---------------------------------------------------------------------------------------------------
# API
#---------------------------------------------------------------------------------------------------

get_clang_bin_path() {
    declare -n _path=$1

    _path="C:\Program Files\LLVM\bin"

    if [[ ! -d $_path ]]; then
        error "Was unable to find LLVM at "$_path".\n"
        exit 1
    fi

    # Fix up the path
    _path="/${_path/:/}"    # Remove ':'.
    _path="${_path//\\//}"  # Remove Windows slashes.
    _path="${_path// /\\ }" # Add a backslash before spaces.

    # Assuming X64.
    printf "${BOLD}${YELLOW}[Clang X64]${NORMAL}\n"
}

