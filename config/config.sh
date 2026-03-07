#!bin/bash

# =================================================================================================
#                                     DMENU CONFIG
# =================================================================================================

MINIMAL_TOOLS_DIR="$HOME/.minimal-dmenu-tools"
CONFIG_DIR="$MINIMAL_TOOLS_DIR/config"
LIB_DIR="$MINIMAL_TOOLS_DIR/common"
NOTE_DIR="$MINIMAL_TOOLS_DIR/note-menu"
POWER_DIR="$MINIMAL_TOOLS_DIR/power-menu"
WIFI_DIR="$MINIMAL_TOOLS_DIR/wifi-menu"
THEMES_DIR="$CONFIG_DIR/themes"

# ==============================
# DMENU THEME
# ==============================


# ==============================
# DMENU VARS
# ==============================

DMENU="bemenu" # or wofi/rofi/etc
DMENU_CENTER_POS_FLAGS=(-s 
                        -f 
                        -W 0.5 
                        -l 15 
                        -P ">" 
                        -c 
                        --fixed-height
)
DMENU_BOTTOM_POS_FLAGS=(-b
                        -P ">" 
)


