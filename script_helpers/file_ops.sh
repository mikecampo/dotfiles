#!/usr/bin/env bash

# Requires the printing.sh helper to be sourced.
# Requires the platform.sh helper to be sourced.

#---------------------------------------------------------------------------------------------------
# API
#---------------------------------------------------------------------------------------------------

strip_trailing_slashes() {
    local ret="$1"
    shopt -s extglob
    ret=$(echo "${ret%%+(/)}")
    echo $ret
}

# Will return a symlink path in its expanded form. If the path's root is the
# home directory symbol "~" then it'll be replaced by the full home path.
expand_path() {
    local ret="$1"

    IFS="/" read -ra parts <<< "$ret"
    if [[ "${parts[0]}" == "~" ]]; then
        ret="$HOME"
        for ((i=1; i < ${#parts[@]}; i++))
        do
            ret="$ret/${parts[$i]}"
        done
    fi
    ret=$(readlink -m "$ret")
    echo $ret
}

# Returned value does not have a trailing '\'.
unix_to_windows_path() {
    local ret="$1"
    if [[ $(is_windows_path "$ret") -eq 0 ]]; then
        if [[ $(is_absolute_unix_path "$ret") -eq 1 ]]; then
            ret="${ret/\//}"
            # Fix the drive name, e.g. c\foo becomes c:\foo
            ret=$(sed 's,\([a-zA-Z]*\),\1:,' <<< "$ret")
        fi
        ret="${ret////\\}"    # Replace Unix slashes.
        ret="${ret//\\\(/\(}" # Remove backslash before (.
        ret="${ret//\\\)/\)}" # Remove backslash before ).
    fi
    ret=$(strip_trailing_slashes "$ret")
    echo $ret
}

# Returned value does not have a trailing '/'.
windows_to_unix_path() {
    local ret="$1"
    ret="/${ret/:/}"     # Remove drive ':'.
    ret="${ret//\\//}"   # Replace Windows slashes.
    ret="${ret// /\\ }"  # Add a backslash before spaces.
    ret="${ret//\(/\\(}" # Add a backslash before (.
    ret="${ret//\)/\\)}" # Add a backslash before ).
    ret="${ret/\/\//\/}" # If the passed in path was a unix path then we'll have two leading '/'; strip if it exists.
    ret=$(strip_trailing_slashes "$ret")
    echo "$ret"
}

# Returns a Unix path without escaped spaces, e.g. "/x/some folder" instead of "/x/some\ folder"
windows_to_unix_path_unescaped() {
    local ret=$(windows_to_unix_path "$1")
    ret="${ret/\\ / }" # Remove '\' that appears before spaces.
    echo "$ret"
}

# Returns a Unix path with spaces escaped with a '\'.
escape_unix_path() {
    local ret="$1"
    ret="${ret/ /\\ }"
    echo "$ret"
}

# Returns a Windows path with backslashes escaped so that you can print the path and see the slashes.
escape_backslashes() {
    local ret="$1"
    ret="${ret/\\/\\\\}"
    echo "$ret"
}

# Returns the last part of a path without leading or trailing slashes.
strip_path() {
    local result=$(basename "$1")
    echo "$result"
}

# Returns a path without the last part. Does not end in a slash.
strip_filename() {
    local result=$(dirname "$1")
    echo "$result"
}

is_absolute_unix_path() {
    if [[ $1 =~ ^/ ]]; then echo 1; else echo 0; fi
}

# Check if the first part of a path is a symlink.
is_first_dir_a_sym_link() {
    local path="$1"
    IFS="/" parts=( ${path//\/" "} )
    local first_dir="${parts[0]}" # will be empty string if path started with slash.
    if [[ $first_dir == "" || $first_dir == "." || ! -L $first_dir ]]; then
        echo 0
    else
        echo 1
    fi
}

# Check if any part of the path is a symlink. Stops at the first symlink that is found.
is_any_part_of_path_a_symlink() {
    local path="$1"

    if [[ $(is_absolute_unix_path "$path") -eq 1 ]]; then
        echo 0
        return
    fi

    IFS="/" parts=( ${path//\/" "} )

    if [[ ${parts[0]} == "" ]]; then
        echo 0
        return
    fi

    local at=0
    local len=${#parts[@]}

    if [[ ${parts[0]} == "." ]]; then
        if [[ $len -gt 1 ]]; then
            at=1 # Skip the period.
        else
            echo 0
            return
        fi
    fi

    local test_path="${parts[$at]}"
    if [[ -L "$test_path" ]]; then
        echo 1
        return
    fi

    ((at=at+1))

    until [ $at -eq $len ]
    do
        local part=${parts[$at]}
        test_path="$test_path/$part"
        if [[ -L $test_path ]]; then
            echo 1
            return
        fi
        ((at=at+1))
    done
    echo 0
}

# Check if the first part of a path is a dotfile.
is_dotfile() {
    if [[ $1 =~ ^\.{1} ]]; then echo 1; else echo 0; fi
}

# We're treating symlinks as Unix paths. This may give us trouble but we'll
# deal with it later should an edge case come up.
is_windows_path() {
    if [[ $(is_any_part_of_path_a_symlink "$1") -eq 0 && $1 =~ \\+ ]]; then echo 1; else echo 0; fi
}

is_unix_path() {
    echo $(! is_windows_path "$1")
}

path_has_a_space() {
    local regexp="[[:blank:]]+"
    if [[ $1 =~ $regexp ]]; then echo 1; else echo 0; fi
}

expand_path_if_not_symlink_or_absolute() {
    local path="$1"
    if [[ $(is_absolute_unix_path "$path") -eq 0 && $(is_any_part_of_path_a_symlink "$path") -eq 0 ]]; then
        path=$(expand_path "$path")
    fi
    echo $path
}

move_file() {
    local src="$1"
    local src_expanded=$(expand_path "$src")

    local dest_path=$(windows_to_unix_path_unescaped "$2")
    local dest_filename="$3"

    if [[ $dest_filename == "" ]]; then
        dest_filename=$(strip_path "$src")
    fi

    if [[ -e "$src_expanded" ]]; then
        mkdir -p "$dest_path"

        local dest="$dest_path/$dest_filename"
        mv "$src_expanded" "$dest"
        printf "${BOLD}${GREEN}==> ${NORMAL}${BOLD}move:    ${YELLOW}'$src'${NORMAL}${BOLD} to ${YELLOW}'$dest'${NORMAL}\n" 2>/dev/null
    else
        printf "${BOLD}${RED}==> move:    ${YELLOW}'$src' ${RED}doesn't exists${NORMAL}\n"
        return
    fi
}

copy_file() {
    local src="$1"
    local src_expanded=$(expand_path "$src")

    local dest_path=$(windows_to_unix_path_unescaped "$2")
    local dest_filename="$3"

    if [[ $dest_filename == "" ]]; then
        dest_filename=$(strip_path "$src_expanded")
    fi

    if [[ -e "$src_expanded" ]]; then
        mkdir -p "$dest_path"

        local dest="$dest_path/$dest_filename"
        cp "$src_expanded" "$dest"
        printf "${BOLD}${GREEN}==> ${NORMAL}${BOLD}copy:    ${YELLOW}'$src'${NORMAL}${BOLD} to\n             ${YELLOW}'$dest'${NORMAL}\n" 2>/dev/null
    else
        printf "${BOLD}${RED}==> copy:    ${YELLOW}'$src' ${RED}doesn't exists${NORMAL}\n"
        return
    fi
}

copy_dir_files() {
    local src="$1"
    local src_expanded=$(expand_path "$src")

    local dest_path=$(windows_to_unix_path_unescaped "$2")

    if [[ -d $src_expanded ]]; then
        mkdir -p $dest_path

        # Need to escape in order to use the wildcard and we have to eval in order to retain the backslash.
        local src_escaped=$(escape_unix_path "$src_expanded")
        cmd="cp -r $src_escaped/* \"$dest_path\""
        eval $cmd

        printf "${BOLD}${GREEN}==> ${NORMAL}${BOLD}copy *:  ${BOLD}${YELLOW}'$src/*'${NORMAL}${BOLD} into ${YELLOW}'$dest_path'${NORMAL}\n" 2>/dev/null
    else
        printf "${BOLD}${RED}==> copy *:  ${YELLOW}'$src' ${RED}doesn't exists${NORMAL}\n"
        return
    fi
}

# Only works with Unix paths.
make_link() {
    local src=$1
    local dest=$2

    local debug=0

    os_is_windows is_windows
    os_is_unix is_unix

    if [[ $is_windows -eq 1 ]]; then
        if [[ $(is_windows_path "$src") -eq 1 ]]; then
            local escaped_path=$(escape_backslashes "$src")
            error "Expected a Unix source path, but got '$escaped_path instead.\n"
            return
        fi
        if [[ $(is_windows_path "$dest") -eq 1 ]]; then
            local escaped_path=$(escape_backslashes "$dest")
            error "Expected a Unix dest path, but got '$escaped_path' instead.\n"
            return
        fi
    fi

    local expand_source_symlink=$3
    local overwrite_existing=$4
    local require_confirmation=$5

    if [[ $overwrite_existing -ne 1 || $overwrite_existing -ne 0 ]]; then
        overwrite_existing=$MC_OVERWRITE_EXISTING_SYMLINK
    fi

    if [[ $debug -eq 1 ]]; then
        echo source path: $src
        echo dest path: $dest
        echo abs unix source: $(is_absolute_unix_path "$src")
        echo abs unix dest: $(is_absolute_unix_path "$dest")
        echo "overwrite existing? $overwrite_existing"
        echo "require_confirmation? $require_confirmation"
        echo "expand source symlink? $expand_source_symlink"
    fi

    local final_src=$src
    local final_dest=$dest

    if [[ $is_windows -eq 1 ]]; then
        if [[ $expand_source_symlink -eq 1 ]]; then
            final_src=$(expand_path "$final_src")
        else
            final_src=$(expand_path_if_not_symlink_or_absolute "$final_src")

            # Having issues with mingw symlinking a path in the cwd to a dest that's not in the cwd.
            # We prepend the cwd when it's not an absolute path in order to work around the issue.
            if [[ $(is_absolute_unix_path "$final_dest") -ne 1 && $(is_dotfile "$final_dest") -ne 1 ]]; then
                if [[ $(is_absolute_unix_path "$final_src") -eq 0 ]]; then
                    final_src="$PWD/$final_src"
                fi
            fi
        fi
        final_dest=$(expand_path_if_not_symlink_or_absolute "$final_dest")
    fi

    local source_has_space=$(path_has_a_space "$final_src")
    local dest_has_space=$(path_has_a_space "$final_dest")

    if [[ $debug -eq 1 ]]; then
        echo "final source: $final_src"
        echo "final dest: $final_dest"
        echo source has space: $source_has_space
        echo dest has space: $dest_has_space
    fi

    # Verify that the source path exists.
    ! test -e "$final_src" && printf "${BOLD}${RED}==> symlink: ${YELLOW}'$src' ${RED}doesn't exists${NORMAL}\n" && return

    # Verify that the dest path doesn't already exist unless we're overwriting.
    if [[ -e "$final_dest" ]]; then
        if [[ $overwrite_existing -eq 1 ]]; then
            echo "DELETING FINAL DEST: $final_dest | orig: $dest  ||| final src: $final_src"
            rm "$final_dest"
        else
            printf "==> symlink: ${BOLD}${YELLOW}'$dest'${NORMAL} already linked to ${BOLD}${YELLOW}'$src'${NORMAL}\n"
            return
        fi
    fi

    local cmd_source_path=""
    local cmd_dest_path=""
    local link_cmd=""

    if [[ $is_windows -eq 1 ]]; then
        cmd_source_path=$(unix_to_windows_path "$final_src")
        cmd_dest_path=$(unix_to_windows_path "$final_dest")
        if [[ $source_has_space -eq 1 ]]; then cmd_source_path="\"$cmd_source_path\""; fi
        if [[ $dest_has_space -eq 1 ]];   then cmd_dest_path="\"$cmd_dest_path\""; fi
        link_cmd="cmd //c 'mklink $cmd_dest_path $cmd_source_path'"
    else
        if [[ $source_has_space -eq 1 ]]; then cmd_source_path="\"$cmd_source_path\""; fi
        if [[ $dest_has_space -eq 1 ]];   then cmd_dest_path="\"$cmd_dest_path\""; fi
        link_cmd="ln -sf $cmd_source_path $cmd_dest_path"
    fi

    if [[ $require_confirmation -eq 1 ]]; then
        echo "${BOLD}${BLUE}Will attempt to link ${YELLOW}'$src'${BLUE} to ${YELLOW}'$dest'${BLUE}"
        printf "${BOLD}Enter 1 to proceed\n${YELLOW}> ${NORMAL}"
        read confirm
        if [[ $confirm != 1 ]]; then abort; fi
    fi

    if [[ $debug -eq 1 ]]; then
        echo Final cmd source: $cmd_source_path
        echo Final cmd dest: $cmd_dest_path
        echo Link cmd:: $link_cmd
    fi

    printf "${BOLD}${GREEN}==> ${NORMAL}${BOLD}symlink: ${YELLOW}'$src'${NORMAL}${BOLD} to ${YELLOW}'$dest'${NORMAL}\n" 2>/dev/null
    eval $link_cmd 1>/dev/null
}

create_dir() {
    local path=$(strip_trailing_slashes "$1")
    if [ ! -d $path ]; then
        mkdir $path
    fi
    printf "${BOLD}${GREEN}==> ${NORMAL}${BOLD}mkdir:   ${NORMAL}${BOLD}${YELLOW}'$path'${NORMAL}\n"
}

