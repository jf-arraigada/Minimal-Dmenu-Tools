#!/usr/bin/env bash

log() {
  printf "\033[1;32m[INFO]\033[0m %s\n" "$1"
  printf "\033[1;32m[INFO]\033[0m %s\n" "$1" >> "$2"
}

msg() {
  printf "%s" "$1"
  [ -n "$2" ] && printf "%s" "$1" >> "$2"
}

error() {
  printf "\033[1;31m[ERROR]\033[0m %s\n" "$1" >&2
  printf "\033[1;31m[ERROR]\033[0m %s\n" "$1" >> "$2"
}

require() {
  command -v "$1" >/dev/null || {
    msg "Missing dependency: $1" "$2"
    exit 1
  }
}

