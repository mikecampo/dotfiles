#!/bin/bash

# Requires the printing.sh helper to be sourced.

#---------------------------------------------------------------------------------------------------
# API
#---------------------------------------------------------------------------------------------------

abort() {
  error "\nAborting...\n"
  exit 1
}
