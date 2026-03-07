#!/usr/bin/env bash

log() {
  printf "\033[1;32m[INFO]\033[0m %s\n" "$*"
}

error() {
  printf "\033[1;31m[ERROR]\033[0m %s\n" "$*" >&2
}

require() {
  command -v "$1" >/dev/null || {
    echo "Missing dependency: $1"
    exit 1
  }
}

