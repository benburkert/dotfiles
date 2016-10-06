#!/bin/bash -e

function cloud {
  eval "$(ion-client shell)"
  cloud "$@"
}

export -f cloud
