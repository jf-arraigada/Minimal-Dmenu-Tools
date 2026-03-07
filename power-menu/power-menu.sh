#!/bin/bash

CONFIG_PATH="$HOME/.minimal-dmenu-tools/config/config.sh"

# =================================================================================================
#                                     DMENU CONFIG
# =================================================================================================

source "$CONFIG_PATH"
source "$THEMES_DIR/bemenu-theme.sh"
source "$LIB_DIR/dmenu_launcher_function.sh"

# ==============================
# DMENU VARS
# ==============================

DMENU_CENTER_POS_FLAGS=(-c -i -P ">" -W 0.4 -l 5)


# =================================================================================================
#                                     MAIN FLOW
# =================================================================================================



# Opciones del menú
options=" Reboot\n Shutdown\n Lock\n󰍃 Logout\n⏾ Suspend"

# Lanzar bemenu
choice=$(echo -e "$options" | dmenu_launcher "Power Menu:" center )

# Ejecutar según selección
case "$choice" in
    " Reboot")
        # Reiniciar
        systemctl reboot
        ;;
    " Shutdown")
        # Apagar
        systemctl poweroff
        ;;
    " Lock")
        # Bloquear pantalla (dependiendo del bloqueador que uses)
        swaylock -f
        ;;
    "󰍃 Logout")
        # Salir de sway
        swaymsg exit
        ;;
    "⏾ Suspend")
        # Suspender
        systemctl suspend
        ;;
    *)
        exit 0
        ;;
esac
