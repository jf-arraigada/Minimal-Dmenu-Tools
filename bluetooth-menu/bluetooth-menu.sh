#!/usr/bin/env bash

CONFIG_PATH="$HOME/.minimal-dmenu-tools/config/config.sh"

source "$CONFIG_PATH"
source "$THEMES_DIR/bemenu-theme.sh"
source "$LIB_DIR/dmenu_launcher_function.sh"
source "$LIB_DIR/notify_function.sh"

# =========================================================
# GLOBALS
# =========================================================

DMENU_CENTER_POS_FLAGS=(-s 
                        -f 
                        -W 0.5 
                        -l 15 
                        -P ">" 
                        -c 
                        --fixed-height
)

ADAPTER="/org/bluez/hci0"
declare -A DEV_NAME
declare -A DEV_CONNECTED
declare -A DEV_PAIRED
declare -A DEV_PATH

# =========================================================
# CACHE DEVICES (ONE DBUS CALL)
# =========================================================

cache_devices() {

  DEV_NAME=()
  DEV_CONNECTED=()
  DEV_PAIRED=()
  DEV_PATH=()

  while IFS="|||" read -r mac name conn paired path; do
    DEV_NAME["$mac"]="$name"
    DEV_CONNECTED["$mac"]="$conn"
    DEV_PAIRED["$mac"]="$paired"
    DEV_PATH["$mac"]="$path"
  done < <(

    busctl --json=pretty call \
      org.bluez / \
      org.freedesktop.DBus.ObjectManager \
      GetManagedObjects |

    jq -r '
      .data[0]
      | to_entries[]
      | select(.value["org.bluez.Device1"]?)
      | .key as $path
      | .value["org.bluez.Device1"] as $d
      | [
          $d.Address.data,
          ($d.Alias.data // $d.Name.data // $d.Address.data),
          ($d.Connected.data // false),
          ($d.Paired.data // false),
          $path
        ]
      | @tsv
    ' | tr "\t" "|||"
  )


}


# =========================================================
# ADAPTER POWER
# =========================================================

adapter_powered() {
  busctl get-property org.bluez "$ADAPTER" org.bluez.Adapter1 Powered | awk '{print $2}'
}

toggle_adapter() {
  local option="$1"

  if [ "$1" = "on" ]; then
    busctl set-property org.bluez "$ADAPTER" org.bluez.Adapter1 Powered b false
    notify "Bluetooth" "Adapter apagado" 2000
  elif [ "$1" = "off" ]; then
    busctl set-property org.bluez "$ADAPTER" org.bluez.Adapter1 Powered b true
    notify "Bluetooth" "Adapter encendido" 2000
  fi
}

# =========================================================
# DISCOVERY
# =========================================================

scan_devices() {

  busctl set-property org.bluez "$ADAPTER" org.bluez.Adapter1 Powered b true

  notify "Bluetooth" "Escaneando..." 2000

  if busctl call org.bluez "$ADAPTER" org.bluez.Adapter1 StartDiscovery >/dev/null 2>&1; then
      sleep 8
      busctl call org.bluez "$ADAPTER" org.bluez.Adapter1 StopDiscovery >/dev/null 2>&1
      notify "Bluetooth" "Escaneo finalizado" 2000
  else
      notify "Bluetooth" "No se pudo iniciar discovery" 2000
      return
  fi

  # Mostrar dispositivos inmediatamente
  device=$(list_devices_menu)
  [ -z "$device" ] && return

  mac=$(extract_mac "$device")
  device_menu "$mac"
}

# =========================================================
# DEVICE MENU
# =========================================================

device_menu() {
  cache_devices

  local mac="$1"
  local path="${DEV_PATH[$mac]}"
  local name="${DEV_NAME[$mac]}"

  if [ "${DEV_CONNECTED[$mac]}" = "true" ]; then
    action="Disconnect"
  else
    action="Connect"
  fi

  choice=$(printf "%s\nRemove\nBack\n" "$action" |
           dmenu_launcher "$name" center)

  echo "$path"

  case "$choice" in
    "Connect")
      busctl call org.bluez "$path" org.bluez.Device1 Connect
      notify "Bluetooth" "Conectado a $name" 2000
      ;;
    "Disconnect")
      busctl call org.bluez "$path" org.bluez.Device1 Disconnect
      notify "Bluetooth" "Desconectado de $name" 2000
      ;;
    "Remove")
      busctl call org.bluez "$ADAPTER" org.bluez.Adapter1 RemoveDevice o "$path"
      notify "Bluetooth" "Dispositivo eliminado" 2000
      ;;
  esac
}

# =========================================================
# LIST DEVICES (USING CACHE)
# =========================================================

list_devices_menu() {

  cache_devices

  for mac in "${!DEV_NAME[@]}"; do
    name="${DEV_NAME[$mac]}"
    conn="${DEV_CONNECTED[$mac]}"
    paired="${DEV_PAIRED[$mac]}"

    if [ "$conn" = "true" ]; then
      printf "* %-22.22s %-15.15s %15s\n" "$name" "[Connected]" "$mac"
    elif [ "$paired" = "true" ]; then
      printf "  %-22.22s %-15.15s %15s\n" "$name" "[Paired]" "$mac"
    else
      printf "  %-22.22s %-15.15s %15s\n" "$name" "[Available]" "$mac"
    fi
  done | dmenu_launcher "Devices:" center
}

#  extract_mac() {
#    <<<"$1" awk -F'[][]' '{gsub(/^[ \t]+/, "", $3); print $3}'
#  }
extract_mac() {
  grep -oE '([0-9A-F]{2}:){5}[0-9A-F]{2}' <<< "$1"
}

# =========================================================
# MAIN
# =========================================================

main_menu() {
  power=$(adapter_powered)
  printf "Adapter: %s\nScan & Select\nDevices\n" "$power" |
    dmenu_launcher "Bluetooth:" center
}

choice=$(main_menu)

case "$choice" in
  "Adapter: true")
    toggle_adapter on
    ;;
  "Adapter: false")
    toggle_adapter off
    ;;
  "Scan & Select")
    scan_devices
    ;;
  "Devices")
    device=$(list_devices_menu)
    [ -z "$device" ] && exit
    echo "$device" | awk -F'[][]' '{gsub(/^[ \t]+/, "", $3); print $3}'
    mac=$(extract_mac "$device")
    echo "\n"
    echo "($mac)"
    device_menu "$mac"
    ;;
esac
