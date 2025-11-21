#!/usr/bin/env bash

_pkg_completion() {
  # input commandline passed via COMP_WORDS / COMP_CWORD
  local WORD="${COMP_WORDS[COMP_CWORD]}"

  # look up-tree for the folder that packages live in
  local WKD=$(pwd | sed -Ee "s:(.*)/packages.*:\1:")

  # set output options in COMPREPLY
  COMPREPLY=( $(/bin/ls -1 "$WKD/packages" | grep "$WORD") )
} &&

complete -F _pkg_completion pkg
# -F function: run the function (1) for the command (2)
