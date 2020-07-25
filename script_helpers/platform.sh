#!/usr/bin/env bash

uname_s="$(uname -s)"
case "${uname_s}" in
    Linux*)   platform="LINUX"  platform_os="LINUX";;
    Darwin*)  platform="MACOS"  platform_os="MACOS";;
    CYGWIN*)  platform="CYGWIN" platform_os="WINDOWS";;
    MINGW*)   platform="MINGW"  platform_os="WINDOWS";;
    MSYS*)    platform="MINGW"  platform_os="WINDOWS";;
    *)        platform="UNKNOWN:${uname_s} platform_os="UNKNOWN_OS""
esac

#---------------------------------------------------------------------------------------------------
# API
#---------------------------------------------------------------------------------------------------

os_is() {
    declare -n _os_is=$1
    if [[ $platform_os == $2 ]]; then _os_is=1; else _os_is=0; fi
}

shell_is() {
    declare -n _shell_is=$1
    if [[ $platform == $2 ]]; then _shell_is=1; else _shell_is=0; fi
}

shell_is_mingw()  { declare -n _shell_ret=$1; shell_is _shell_ret "MINGW"; }
shell_is_cygwin() { declare -n _shell_ret=$1; shell_is _shell_ret "CYGWIN"; }

os_is_windows() { declare -n _os_ret=$1; os_is _os_ret "WINDOWS"; }
os_is_linux()   { declare -n _os_ret=$1; os_is _os_ret "LINUX"; }
os_is_macos()   { declare -n _os_ret=$1; os_is _os_ret "MACOS"; }
os_is_unix() {
    declare -n _os_ret=$1;
    if [[ $platform_os == "LINUX" || $platform_os == "MACOS" ]]; then
        _os_ret=1
    else
        _os_ret=0
    fi
}

