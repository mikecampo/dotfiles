#!/usr/bin/env bash

#---------------------------------------------------------------------------------------------------
# API
#---------------------------------------------------------------------------------------------------

# If you're using msys/mingw shell for compiling then it's possible for its gcc
# link.exe to take precedence over the VC link.exe simply due to the path
# order. We get around this by prefixing all VC tools with the active VC arch
# bin path.
#
# This will only work if the shell ran vcvarsall.bat.

get_msvc_bin_path() {
    declare -n _path=$1
    declare -n _x64_toolset=$2

    _path=""
    _x64_toolset=0

    if [[ $VisualStudioVersion == "14.0" ]]; then
        ##########################################
        # Visual Studio 2015
        ##########################################
        _path="$VCINSTALLDIR"

        if [[ $(env | grep "LIB=" | grep "x64") != "" ]]; then
            printf "${BOLD}${YELLOW}[VS2015 X64]${NORMAL}\n"
            _x64_toolset=1
            _path+="bin/amd64"
        elif [[ $(env | grep "LIB=" | grep "x86") != "" ]]; then
            printf "${BOLD}${YELLOW}[VS2015 X86]${NORMAL}\n"
            _path+="bin/"
        else
            error "Unable to determine if you're using an x86 or x64 MSVC toolset\n"
            exit 1
        fi
    elif [[ $VisualStudioVersion == "15.0" ]]; then
        ##########################################
        # Visual Studio 2017
        ##########################################
        _path="$VCToolsInstallDir"

        if [[ $VSCMD_ARG_HOST_ARCH == "x64" ]]; then
            printf "${BOLD}${YELLOW}[VS2017 X64]${NORMAL}\n"
            _x64_toolset=1
            _path+="bin/Hostx64/x64"
        elif [[ $VSCMD_ARG_HOST_ARCH == "x86" ]]; then
            printf "${BOLD}${YELLOW}[VS2017 X86]${NORMAL}\n"
            _path+="bin/Hostx86/x86"
        else
            error "Unable to determine if you're using an x86 or x64 MSVC toolset\n"
            exit 1
        fi
    elif [[ $VisualStudioVersion == "16.0" ]]; then
        ##########################################
        # Visual Studio 2019
        ##########################################
        _path="$VCToolsInstallDir"

        if [[ $VSCMD_ARG_HOST_ARCH == "x64" ]]; then
            printf "${BOLD}${YELLOW}[VS2019 X64]${NORMAL}\n"
            _x64_toolset=1
            _path+="bin/Hostx64/x64"
        elif [[ $VSCMD_ARG_HOST_ARCH == "x86" ]]; then
            printf "${BOLD}${YELLOW}[VS2019 X86]${NORMAL}\n"
            _path+="bin/Hostx86/x86"
        else
            error "Unable to determine if you're using an x86 or x64 MSVC toolset\n"
            exit 1
        fi
    else
        error "Either you don't have Visual Studio installed or it's not supported by this script.\nFound version '$VisualStudioVersion'\n"
        exit 1
    fi

    # Fix up the path
    _path="/${_path/:/}"    # Remove ':'.
    _path="${_path//\\//}"  # Remove Windows slashes.
    _path="${_path// /\\ }" # Add a backslash before spaces.
}

