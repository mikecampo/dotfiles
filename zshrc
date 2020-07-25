platform=`uname`

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.zsh

# Plugins to enable - they are found in .zsh/plugins
PLUGINS=(safe-paste)

fpath=($fpath $ZSH/func)
typeset -U fpath

is_plugin() {
  local base_dir=$1
  local name=$2
  test -f $base_dir/plugins/$name/$name.plugin.zsh \
    || test -f $base_dir/plugins/$name/_$name
}

# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin ($PLUGINS); do
  if is_plugin $ZSH $plugin; then
    fpath=($ZSH/plugins/$plugin $fpath)
  fi
done

# Load all of the plugins that were defined in ~/.zshrc
for plugin ($PLUGINS); do
  if [ -f $ZSH/plugins/$plugin/$plugin.plugin.zsh ]; then
    source $ZSH/plugins/$plugin/$plugin.plugin.zsh
  fi
done

# Setup the custom prompt
setopt promptsubst
autoload -U promptinit
promptinit
prompt grb

# Linux specific config
if [[ $platform == 'Linux' ]]; then
  # Set caps to ctrl
  #setxkbmap -option 'caps:ctrl_modifier'
  # Make caps act as Esc when tapped. Require `xcape` package.
  #xcape -e 'Caps_Lock=Escape'
fi

# Autoload things before calling compinit
autoload -Uz compinit
compinit

# Never know when you're gonna need to popd!
setopt AUTO_PUSHD

# Allow completing of the remainder of a command
bindkey "^N" insert-last-word

# Show contents of directory after cd-ing into it
chpwd() {
  if [[ $platform == 'Linux' ]]; then
    ls -lrthG --color
  elif [[ $platform == 'Darwin' ]]; then
    ls -lG
  fi
}

# Save a ton of history
export HISTSIZE=20000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE
setopt appendhistory autocd
bindkey -e

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Load all of the config files in ~/.zsh that end in .zsh
source $ZSH/lib/*.zsh

# Source my custom files after oh-my-zsh so I can override things.
test -f $HOME/.aliases && . $HOME/.aliases
test -f $HOME/.aliases.private && . $HOME/.aliases.private
# Common env must come first.
test -f $HOME/.private-dotfiles.common/env && . $HOME/.private-dotfiles.common/env
test -f $HOME/.private-dotfiles/env && . $HOME/.private-dotfiles/env

if [[ -d "$HOME/bin" ]]; then
    export PATH=$HOME/bin/:$PATH
fi

if [[ -d "$HOME/.dotfiles/bin" ]]; then
    export PATH=$HOME/.dotfiles/bin/:$PATH
fi

# Fix <c-h> in neovim
infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $HOME/.$TERM.ti
tic $HOME/.$TERM.ti
