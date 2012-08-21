#! /bin/bash

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}

function rbenv_version {
  local version=$(rbenv local 2>/dev/null)

  if [[ $? -eq 0 && "$version" != "" ]] ; then
    echo -ne "($version)"
  fi
}

function set_prompt {
  local         RED="\[\033[0;31m\]"
  local        BLUE="\[\033[0;34m\]"
  local       GREEN="\[\033[0;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  local       CLEAR="\[\033[m\]"

  PS1="$WHITE\w$BLUE\$(rbenv_version)$GREEN\$(parse_git_branch)${RED}  $CLEAR"
  PS2='> '
  PS4='+ '
}

export -f set_prompt
