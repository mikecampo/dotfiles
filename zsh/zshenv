platform=`uname -s`

# Unbreak broken, non-colored terminal
export TERM=xterm-256color

# Use vim as the editor
export EDITOR=vim

# Homebrew setup
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha

# Ruby
export RBENV_PATH="$HOME/.rbenv"

# Clojure
export LEIN_FAST_TRAMPOLINE=y

if [[ $platform == 'Linux' ]]; then
  export LD_LIBRARY_PATH="/usr/lib/jvm/java-8-openjdk/jre/lib/amd64"
  export LOLCOMMITS_ANIMATE=4
  export LOLCOMMITS_FORK=true
  export LOLCOMMITS_STEALTH=true
  export LOLCOMMITS_DIR="/shared/Dev/lolcommits"
fi

if [ -d "$HOME/.rbenv" ]; then
  # Start rbenv
  eval "$(rbenv init -)"
fi

# Start the SSH agent
eval "$(ssh-agent -s)" > /dev/null
