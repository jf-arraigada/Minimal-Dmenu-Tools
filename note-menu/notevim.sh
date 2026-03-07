#!/usr/bin/env bash

notevim() {
  local file="$1"
  local name="$(basename "$file")"
  local term="${TERMINAL:-kitty}"

  swaymsg exec "FILE=\"$file\" $term --title \"$name\" sh -c 'nvim \"\$FILE\"'"

}

