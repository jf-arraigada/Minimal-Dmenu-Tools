#!/usr/bin/env bash

CONFIG_PATH="$HOME/.minimal-dmenu-tools/config/config.sh"

# =================================================================================================
#                                     DMENU CONFIG
# =================================================================================================

source "$CONFIG_PATH"
source "$THEMES_DIR/bemenu-theme.sh"
source "$LIB_DIR/dmenu_launcher_function.sh"
source "$LIB_DIR/notify_function.sh"

# ==============================
# DMENU VARS
# ==============================

DMENU_BOTTOM_POS_FLAGS=(-l 10 -b -P ">" --fixed-height --wrap)

# =================================================================================================
#                                     MAIN FLOW
# =================================================================================================



# =========================================================
# Helpers
# =========================================================

get_default_sink() {
  pactl info | awk -F': ' '/Default Sink/ {print $2}'
}

get_default_source() {
  pactl info | awk -F': ' '/Default Source/ {print $2}'
}

get_sinks() {
  default_sink=$(get_default_sink)

  pactl list sinks | awk -v def="$default_sink" '
  /^Sink #/ {name=""; desc=""}
  /Name:/ {name=$2}
  /Description:/ {
      sub(/Description: /, "")
      desc=$0
      if (name != "" && desc != "") {
          mark = (name == def) ? "*" : " "
          printf "%s  %-35s  [%s]\n", mark, desc, name
      }
  }'
}

get_sources() {
  default_source=$(get_default_source)

  pactl list sources | awk -v def="$default_source" '
  /^Source #/ {name=""; desc=""}
  /Name:/ {name=$2}
  /Description:/ {
      sub(/Description: /, "")
      desc=$0
      if (name != "" && desc != "") {
          mark = (name == def) ? "*" : " "
          printf "%s  %-35s  [%s]\n", mark, desc, name
      }
  }'
}

extract_name() {
  echo "$1" | awk -F'[][]' '{print $2}'
}

extract_descriptor() {
  echo "$1" | awk -F'[][]' '{print $1}'
}

# =========================================================
# Main menu
# =========================================================

main_options="󰓃 Change Output\n󰍬 Change Input"

choice=$(echo -e "$main_options" | dmenu_launcher "Audio Menu:" center)
token="${choice:2}"

case "$token" in
  "Change Output")
      selection=$(get_sinks | dmenu_launcher "Select Output:" center)
      name=$(extract_name "$selection")
      descriptor=$(extract_descriptor "$selection")

      if [[ -n "$name" ]]; then
          pactl set-default-sink "$name"
          notify "Audio" "Output set to: $descriptor" 2000
      fi
      ;;
  "Change Input")
      selection=$(get_sources | dmenu_launcher "Select Input:" center)
      name=$(extract_name "$selection")

      if [[ -n "$name" ]]; then
          pactl set-default-source "$name"
          notify "Audio" "Input set to: $descriptor" 2000
      fi
esac
