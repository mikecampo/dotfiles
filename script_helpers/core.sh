#!/usr/bin/env bash

# Requires the printing.sh helper to be sourced.

#---------------------------------------------------------------------------------------------------
# API
#---------------------------------------------------------------------------------------------------

abort() {
  error "\nAborting...\n"
  exit 1
}

# Use this by setting a trap in your script, like so:
# `trap at_exit EXIT`
at_exit() {
    ret=$?
    if [[ $ret -gt 0 ]]; then
      error "The script failed with error $ret.\n"
    fi
    exit "$ret"
}

