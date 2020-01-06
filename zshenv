platform=`uname -s`
kernel_release=`uname -r`

test -f ~/.aliases.private && . ~/.aliases.private
# Common env must come first.
test -f ~/.private-dotfiles.common/env && . ~/.private-dotfiles.common/env
test -f ~/.private-dotfiles/env && . ~/.private-dotfiles/env

# Unbreak broken, non-colored terminal
export TERM=xterm-256color

# Use vim as the editor
export EDITOR=vim

# Homebrew setup
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha

# Grep tweaks
export GREP_OPTIONS="-nRi --color --exclude-dir=.git  --exclude-dir=tmp --exclude-dir=log --exclude-dir=node_modules --exclude-dir=bower_components --exclude-dir=coverage --exclude-dir=.bundle --exclude=*.csv --exclude=*.pdf --exclude-dir=vendor --exclude-dir=rdoc --exclude-dir=target --exclude-dir=personal --exclude-dir=resources/public/js/*.*" # --exclude-dir=images --exclude-dir=coverage

export RBENV_PATH="$HOME/.rbenv"

export LEIN_FAST_TRAMPOLINE=y

if [[ $platform == 'Linux' ]]; then
  export LD_LIBRARY_PATH="/usr/lib/jvm/java-8-openjdk/jre/lib/amd64"
  export LOLCOMMITS_ANIMATE=4
  export LOLCOMMITS_FORK=true
  export LOLCOMMITS_STEALTH=true
  export LOLCOMMITS_DIR="/shared/Dev/lolcommits"
fi

path=($HOME/bin $HOME/.dotfiles/bin ${RBENV_PATH}/bin $HOME/.vim/scripts $path)

if [[ $platform == 'Darwin' ]]; then
  test -f $HOME/.cargo && source $HOME/.cargo/env
  # TODO: test for qt
  if [ -d "$HOME/Qt" ]; then
    path=($HOME/Qt/5.8/clang_64/bin $path)
  fi
fi

if [ -d "$HOME/.rbenv" ]; then
  # Start rbenv
  eval "$(rbenv init -)"
fi

# Start the SSH agent
eval "$(ssh-agent -s)" > /dev/null
