# Need to edit the path again here so that we can get the homebrew bin folder
# ahead of everything else. This is necessary because zsh is modifying the path
# in zshrc, and that causes us to run out of /usr/bin for programs that we want
# to use from homebrew's bin
#
# Update 2020-07-25: This no longer seems to be an issue.
#path=(/usr/local/bin /usr/local/sbin /usr/local/opt/openssl/bin $path)
