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


selection=$(cliphist list | dmenu_launcher "Clipboard>" bottom) 

[ -z "$selection" ] && exit

# Normal → recuperar bloque completo
echo "$selection" | cliphist decode | wl-copy
notify "Clipboard" "Copiado al portapapeles!"

