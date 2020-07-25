#!/usr/bin/env bash

# Requires the printing.sh helper to be sourced.
# Requires the platform.sh helper to be sourced.

#---------------------------------------------------------------------------------------------------
# API
#---------------------------------------------------------------------------------------------------


# Will return a symlink path in its expanded form.  If the path's root is the
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

unix_to_windows_path() {
    ret=$1
    if [[ $(is_windows_path $ret) -eq 1 ]]; then
        echo $ret
    else
        if [[ $(is_absolute_unix_path $ret) -eq 1 ]]; then
            ret="${ret/\//}"
            # Fix the drive name, e.g. c\foo becomes c:\foo
            ret=$(sed 's,\([a-zA-Z]*\),\1:,' <<< "$ret")
        fi
        ret="${ret////\\}" # replace unix path with windows path
        echo $ret
    fi
}

windows_to_unix_path() {
  ret=$1
  ret="/${ret/:/}"     # Remove drive ':'.
  ret="${ret//\\//}"   # Replace Windows slashes.
  ret="${ret// /\\ }"  # Add a backslash before spaces.
  echo "$ret"
}

move_file() {
  local src="$1"
  local src_path=$(dirname "${src}")
  local src_name=$(basename "${src}")
  local dest=$2
  local src_type=$3 # e.g. "script", "dependency", etc

  if [[ $src_type != '' ]]; then
    src_type="$src_type "
  fi

  if [[ -e "$src" ]]; then
    mkdir -p "$dest"
    mv "$src" "$dest"
    printf "${BOLD}${GREEN}Moved $src_type$src to $dest${NORMAL}\n"
  else
    error "Unable to find $src_type$src!\n"
  fi
}

copy_file() {
  local src="$1"
  local src_path=$(dirname "${src}")
  local src_name=$(basename "${src}")
  local dest=$2
  local src_type=$3 # e.g. "script", "dependency", etc

  if [[ $src_type != '' ]]; then
    src_type="$src_type "
  fi

  if [[ -e "$src" ]]; then
    # @fixme If $dest is a file then strip the file name from the path and mkdir on that instead
    echo "MAKE DIR $src $dest"
    #mkdir -p "$dest"
    cp "$src" "$dest"
    printf "${BOLD}${GREEN}Copied $src_type$src to $dest${NORMAL}\n"
  else
    error "Unable to find $src_type$src!\n"
  fi
}

copy_dir_files() {
  local src="$1"
  local dest=$2

  if [[ -d "$src" ]]; then
    mkdir -p "$dest"
    cp -r $src/* $dest
    printf "${BOLD}${GREEN}Copied contents of $src into $dest${NORMAL}\n"
  else
    error "Unable to find $src!\n"
  fi
}

is_absolute_unix_path() {
  if [[ $1 =~ ^/ ]]; then echo 1; else echo 0; fi
}

is_sym_file() {
  if [[ $1 =~ ^\.{1} ]]; then echo 1; else echo 0; fi
}

is_windows_path() {
  if [[ ! $1 =~ \/+ ]]; then echo 1; else echo 0; fi
}

is_unix_path() {
  echo $(! is_windows_path "$1")
}

path_has_a_space() {
    regexp="[[:blank:]]+"
    if [[ $1 =~ $regexp ]]; then echo 1; else echo 0; fi
}

# Expands a path when it's not a symbolic link or an absolute drive path.
_clean_link_file_path() {
    path=$1
    if [[ $(is_absolute_unix_path "$path") -eq 0 && $(is_sym_file "$path") -eq 0 ]]; then
        path=$(expand_path "$path")
    fi
    echo $path
}

# Creates a symlink.
# Requires an admin shell when running under Windows.
link_file() {
    source_path=$1
    dest_path=$2
    require_confirmation=$3
    expand_symlinks=$4

    os_is_windows is_windows
    os_is_unix is_unix

    # @INSTEAD ESCAPE THE SPACES IN THE FINAL WINDOWS PATH:
    # e.g. path="${path// /\\ }" # Add a backslash before spaces.
    # https://stackoverflow.com/questions/1473981/how-to-check-if-a-string-has-spaces-in-bash-shell
    # https://stackoverflow.com/questions/28256178/how-can-i-match-spaces-with-a-regexp-in-bash

    source_has_space=$(path_has_a_space "$source_path")
    dest_has_space=$(path_has_a_space "$dest_path")

    debug=0
    if [[ $debug -eq 1 ]]; then
        echo source path: $source_path
        echo dest path: $dest_path
        echo source has space: $source_has_space
        echo dest has space: $dest_has_space
        echo abs unix source: $(is_absolute_unix_path "$source_path")
        echo abs unix dest: $(is_absolute_unix_path "$dest_path")
        echo "require_confirmation? $require_confirmation"
        echo "expand_symlinks? $expand_symlinks"
    fi

    if [[ $is_windows -eq 1 ]]; then
        if [[ $expand_symlinks -eq 1 ]]; then
            source_path=$(expand_path "$source_path")
            dest_path=$(expand_path "$dest_path")
        else
            source_path=$(_clean_link_file_path "$source_path")
            dest_path=$(_clean_link_file_path "$dest_path")
        fi
    fi

    if [[ $debug -eq 1 ]]; then
        echo "after source: $source_path"
        echo "after dest: $dest_path"
    fi

    # Verify that the source path exists.
    ! test -d "$source_path" && ! test -e "$source_path" && error "Source path '$source_path' doesn't exist!" && abort

    # Verify that the dest path doesn't already exist.
    test -d "$dest_path" && error "Dest folder '$dest_path' already exists!\n" && return
    test -e "$dest_path" && error "Dest file '$dest_path' already exists!\n" && return

    if [[ $is_windows -eq 1 ]]; then
        source_path=$(unix_to_windows_path "$source_path")
        dest_path=$(unix_to_windows_path "$dest_path")
        if [[ $source_has_space -eq 1 ]]; then source_path="\"$source_path\""; fi
        if [[ $dest_has_space -eq 1 ]];   then dest_path="\"$dest_path\""; fi
        link_cmd="cmd //c 'mklink $dest_path $source_path'"
    else
        if [[ $source_has_space -eq 1 ]]; then source_path="\"$source_path\""; fi
        if [[ $dest_has_space -eq 1 ]];   then dest_path="\"$dest_path\""; fi
        link_cmd="ln -sf $source_path $dest_path"
    fi

    if [[ $require_confirmation -eq 1 ]]; then
        echo "${BOLD}${BLUE}Will attempt to link ${GREEN}$source_path${BLUE} to ${GREEN}$dest_path${BLUE}"
        printf "${BOLD}Enter 1 to proceed\n${YELLOW}> ${NORMAL}"
        read confirm
        if [[ $confirm != 1 ]]; then abort; fi
    fi

    if [[ $debug -eq 1 ]]; then
        echo Final source: $source_path
        echo Final dest: $dest_path
        echo Link cmd:: $link_cmd
    fi

    printf "${BOLD}*${NORMAL} ${YELLOW}Linking '$source_path'${NORMAL} to ${YELLOW}'$dest_path'${NORMAL}\n"
    eval $link_cmd
}

function setup_file() {
    src=$1
    dest=$2
    if [ ! -f $dest ]; then
        link_file $src $dest $confirm_link
    else
        printf "${BOLD}*${NORMAL} ${YELLOW}'$dest'${NORMAL} already linked to ${YELLOW}'$src'${NORMAL}\n"
    fi
}

function setup_dir() {
    src=$1
    dest=$2
    if [ ! -d $dest ]; then
        link_file $src $dest $confirm_link
    else
        printf "${BOLD}*${NORMAL} ${YELLOW}'$dest'${NORMAL} already linked to ${YELLOW}'$src'${NORMAL}\n"
    fi
}

