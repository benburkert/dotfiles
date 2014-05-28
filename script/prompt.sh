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

function previous_exit_status {
  echo -ne "$?"
}

function set_prompt {
  local exit_status=$?

  local         RED="\[\033[0;31m\]"
  local        BLUE="\[\033[0;34m\]"
  local       GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local      YELLOW="\[\033[0;33m\]"
  local      PURPLE="\[\033[0;35m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  local       CLEAR="\[\033[m\]"

  if [[ $exit_status -eq 0 ]] ; then
    local exit_color=$GREEN
  else
    local exit_color=$RED
  fi

  PS1="${YELLOW}╭──$WHITE\w$BLUE\$(rbenv_version)$PURPLE\$(parse_git_branch)${exit_color}\n${YELLOW}╰→ $CLEAR"
  PS2='> '
  PS4='+ '
}

export -f set_prompt
