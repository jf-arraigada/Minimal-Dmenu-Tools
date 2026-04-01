#!/usr/bin/env bash

set -euo pipefail

export MINIMAL_DMENU_TOOLS_GENERAL=true
export CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export INSTALL_DIR="$HOME/.minimal-dmenu-tools"
export LOG_FILE="$INSTALL_DIR/install.log"

mkdir -p "$INSTALL_DIR"

install_module() {
  "$CURRENT_DIR/$1/install.sh"
}

source "$CURRENT_DIR/common/common.sh"

msg 'Welcome to the General Installation Menu for "Minimal D-menu Tools!"'
msg "All the scripts were made using bemenu (wayland), but only a few don't work with another d-menu-like (fuzzel, wofi, rofi)"
msg "Please, if you don't use bemenu, check the config file at ~/.minimal-dmenu-tools/config/ directory"
msg "Also all the module-install scripts will noticed wich line/s you need to change"
msg "Don't worry buddy :) the most of the changes needed will be about d-menu flags"
msg "Select your D-Menu:"
read -p  "[1]bemenu, [2]fuzzel, [3]rofi, [4]wofi, [5]other\n>>>" DMENU 
if [[ ! "$DMENU" =~ ^[0-9]+$ ]]; then
  error "Invalid option: $opt"
fi

case "$DMENU" in
  1) export SELECTED_DMENU=bemenu ;;
  2) export SELECTED_DMENU=fuzzel ;;
  3) export SELECTED_DMENU=rofi ;;
  4) export SELECTED_DMENU=wofi ;;
  *) export SELECTED_DMENU=other ;;
esac

clear
msg "Select script(s) to install:"
IFS=',' read -a opts -p "[1]wifi-menu, [2]bluetooth-menu, [3]note-menu, [4]energy-menu, [5]clipboard-menu, [6]power-menu, [7]kill-process-menu, [8]audio-menu, [0]All-menus\n>>>"


mkdir -p "$INSTALL_DIR/config/themes"
mkdir -p "$INSTALL_DIR/common"

cp "$CURRENT_DIR/config/config.sh" "$INSTALL_DIR/config"
cp "$CURRENT_DIR/config/themes/bemenu-theme.sh" "$INSTALL_DIR/config/themes"
cp "$CURRENT_DIR/common/dmenu_launcher_function.sh" "$INSTALL_DIR/common"
cp "$CURRENT_DIR/common/notify_function.sh" "$INSTALL_DIR/common"


for opt in "${opts[@]}"; do
  if [[ ! "$opt" =~ ^[0-9]+$ ]]; then
  error "Invalid option: $opt"
  fi
  case "$opt" in
    1) install_module wifi-menu
    ;;
    2) install_module bluetooth-menu
    ;;
    3) install_module note-menu
    ;;
    4) install_module energy-menu
    ;;
    5) install_module clipboard-menu
    ;;
    6) install_module power-menu
    ;;
    7) install_module kill-process-menu
    ;;
    8) install_module audio-menu
    ;;
    0) install_module wifi-menu
       install_module bluetooth-menu
       install_module note-menu
       install_module energy-menu
       install_module clipboard-menu
       install_module power-menu
       install_module kill-proccess-menu
       install_module audio-menu
    ;;
    *) error "No module selected!" 
    ;;

  esac
done

log "See the install_log"

