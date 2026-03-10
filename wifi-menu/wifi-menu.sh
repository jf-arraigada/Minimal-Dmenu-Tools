#!/usr/bin/env bash

CONFIG_PATH="$HOME/.minimal-dmenu-tools/config/config.sh"

source "$CONFIG_PATH"
source "$THEMES_DIR/bemenu-theme.sh"
source "$LIB_DIR/notify_function.sh"

# =================================================================================================
#                                     DMENU CONFIG
# =================================================================================================



# ==============================
# DMENU VARS
# ==============================

DMENU_CENTER_POS_FLAGS=(-s -f -W 0.5 -l 15 -P ">" -c --fixed-height)
DMENU_BOTTOM_POS_FLAGS=(-b -l 2 -P ">" --fixed-height)
DMENU_BOTTOM_POS_LINE_FLAGS=(-b -P ">" --fixed-height)

# ==============================
# DMENU LAUNCHER FUNCTION
# ==============================

wifi_dmenu_launcher() {
  local prompt="$1" # string 
  local position="$2" # bottom or center
  local password="$3" # pass or nothing

  local flags 

  case "$position" in 
    center) flags=("${DMENU_CENTER_POS_FLAGS[@]}") ;;
    bottom) flags=("${DMENU_BOTTOM_POS_FLAGS[@]}") ;;
    bottom-line) flags=("${DMENU_BOTTOM_LINE_POS_FLAGS}") ;;
    *) flags=("${DMENU_CENTER_POS_FLAGS[@]}") ;;
  esac

  if [ "$password" = "pass" ]; then
    "$DMENU" "${flags[@]}" -p "$prompt" --password indicator
  else
    "$DMENU" "${flags[@]}" -p "$prompt"
  fi
}

# =================================================================================================
#                                     FUNCTION CODE
# =================================================================================================



# ==============================
# MENU FUNCTION
# ==============================

network_menu() {
  local cache_file="$HOME/.cache/wifi_daemon/cache.txt"

  if [ ! -f "$cache_file" ]; then
    notify "WiFi" "Daemon cache no disponible" 3000
    exit 1
  fi

  mapfile -t menu < "$cache_file"

  # Formatear tabla
  local formatted=()
  for line in "${menu[@]}"; do
    IFS='|' read -r ssid signal bars security <<< "$line"

    formatted+=("$(printf "%-25.25s  (%-11s)  %5s [%-9s]" "$ssid" "$signal" "$bars" "$security")")
  done

  local choice
  choice=$(printf "%s\n" "${formatted[@]}" |
    nl -w2 -s' ' |
    wifi_dmenu_launcher "WiFi:" center)

  [ -z "$choice" ] && return 1

  local index
  index=$(echo "$choice" | awk '{print $1}')

  local selected_line="${menu[$((index-1))]}"
  local selected_ssid=$(echo "$selected_line" | cut -d'|' -f1)

#  local selected_ssid
#  IFS='|' read -r selected_ssid _ <<< "${menu[$((index-1))]}"

#  [ -z "$selected_ssid" ] && return 1

  echo "$selected_ssid"
}

# ==============================
# PASSWORD PROMPT FUNCTION
# ==============================
#
network_password_prompt() {

  while true; do

    local selected_ssid="$1"
    local pass
    pass=$(echo " " | wifi_dmenu_launcher "Password for $selected_ssid:" bottom-line pass)

    [ -z "$pass" ] && return 1

    if nmcli dev wifi connect "$selected_ssid" password "$pass" >/dev/null 2>&1; then
        notify "WiFi" "Conectado a $selected_ssid" 2000
        return 0
    fi

    local retry
    retry=$(printf "No\nSí\n" | wifi_dmenu_launcher "Contraseña incorrecta. ¿Reintentar?:" bottom-line)

    if [ "$retry" != "Sí" ]; then
        return 2   # señal de volver al menú
    fi

  done
}


# =================================================================================================
#                                     MAIN FLOW CODE
# =================================================================================================



# ==============================
# ESTADO ACTUAL
# ==============================

current_ssid=$(nmcli -t -f NAME connection show --active)

if [ -n "$current_ssid" ]; then
  notify "WiFi" "Conectado a $current_ssid" 3000

  change=$(printf "No\nSí\n" | wifi_dmenu_launcher "¿Desea cambiar de red?:" bottom)

  [ "$change" != "Sí" ] && exit 0
fi

mapfile -t known_connections < <(nmcli -g NAME connection show)


# ==============================
# LLAMADA A MENU FUNCTION
# ==============================

ssid=$(network_menu) || exit 1
[ -z "$ssid" ] && exit 1


# ==============================
# RED CONOCIDA → conecta directo
# ==============================

if printf "%s\n" "${known_connections[@]}" | grep -Fxq "$ssid"; then

  if nmcli device wifi connect "$ssid"; >/dev/null 2>&1; then
      notify "WiFi" "Conectado a $ssid (perfil existente)" 2000
      exit
  else
      nmcli connection delete "$ssid" 2>/dev/null

      pass=$(echo " " | wifi_dmenu_launcher "Password for $ssid" bottom-line pass)
      
      if nmcli dev wifi connect "$ssid" password "$pass"; then
          notify "WiFi" "Reconectado a $ssid" 2000
          exit
      fi
  fi

fi


# ==============================
# RED NUEVA → pedir password
# ==============================

network_password_prompt "$ssid"

case $? in
  0) exit 0 ;;
  1) exit 1 ;;
  2) ssid=$(network_menu) ;;
esac
