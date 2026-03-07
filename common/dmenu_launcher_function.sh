#!bin/bash

# ==============================
# DMENU LAUNCHER FUNCTION
# ==============================

dmenu_launcher() {
  local prompt="$1" # string 
  local position="$2" # bottom or center

  local flags 

  case "$position" in 
    center) flags=("${DMENU_CENTER_POS_FLAGS[@]}") ;;
    bottom) flags=("${DMENU_BOTTOM_POS_FLAGS[@]}") ;;
    *) flags=("${DMENU_CENTER_POS_FLAGS[@]}") ;;
  esac

  "$DMENU" "${flags[@]}" -p "$prompt"
}
