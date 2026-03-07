#!/bin/bash

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

DMENU_CENTER_POS_FLAGS=( -c -l 15 -W 0.5 --fixed-height -P ">")

# =================================================================================================
#                                     MAIN FLOW
# =================================================================================================

options="󰓅 Performance\n󰗑 Balanced\n󰂏 Battery safe"

# Lanzar bemenu
choice=$(echo -e "$options" | dmenu_launcher "Energetic Profile Menu:" center )
token="${choice:2}"

case "$choice" in
    "󰓅 Performance")
        cpupower frequency-set -g performance
        ;;
    "󰗑 Balanced")
        cpupower frequency-set -g schedutil
        ;;
    "󰂏 Battery safe")
        cpupower frequency-set -g powersave
        ;;
esac

if [[ $? -eq 0 ]]; then
    notify "Energy" "Perfil aplicado: $token" 2000
else
    notify "Energy" "Error aplicando perfil" 3000
fi
