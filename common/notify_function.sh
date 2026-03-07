#!bin/bash

# ==============================
# NOTIFY FUNCTION
# ==============================

notify() {
  local title="$1"
  local message="$2"
  local time="$3"

  notify-send "$title" "$message" -t "$time"
}

