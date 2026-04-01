#!/usr/bin/env bash

log() {
  local time=$(date "+%Y-%m-%d %H:%M:%S")

  printf "\033[1;32m[INFO]\033[0m %s\n" "$1"
  printf "[%s] [INFO] %s\n" "$time" "$1" >> "$2"
}

msg() {
  local time=$(date "+%Y-%m-%d %H:%M:%S")

  printf "%s\n" "$1"
}

error() {
  local time=$(date "+%Y-%m-%d %H:%M:%S")

  printf "\033[1;31m[ERROR]\033[0m %s\n" "$1" >&2
  printf "[%s] [ERROR] %s\n" "$time" "$1" >> "$2"
}

require() {
  command -v "$1" >/dev/null || {
    local time=$(date "+%Y-%m-%d %H:%M:%S")

    msg "[$time] Missing dependency: $1" "$2"
    exit 1
  }
}

