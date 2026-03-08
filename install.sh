#!/usr/bin/env bash

set -euo pipefail

export MINIMAL_DMENU_TOOLS_GENERAL=true
export CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export INSTALL_DIR="$HOME/.minimal-dmenu-tools"

LOG_FILE="$INSTALL_DIR/install_log"

mkdir -p "$INSTALL_DIR"

exec > >(awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a "$LOG_FILE") 2> >(awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a "$LOG_FILE" >&2)

install_module() {
  "$CURRENT_DIR/$1/install.sh"
}

source "$CURRENT_DIR/common/common.sh"

echo 'Welcome to the General Installation Menu for "Minimal D-menu Tools!"'
echo "All the scripts were made using bemenu (wayland), but only a few don't work with another d-menu-like (fuzzel, wofi, rofi)"
echo "Please, if you don't use bemenu, check the config file at ~/.minimal-dmenu-tools/config/ directory"
echo "Also all the module-install scripts will noticed wich line/s you need to change"
echo "Don't worry buddy :) the most of the changes needed will be about d-menu flags"
echo "Select your D-Menu:"
read -p  "[1]bemenu, [2]fuzzel, [3]rofi, [4]wofi, [5]other" DMENU 
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
echo "Select script(s) to install:"
IFS=',' read -a opts -p "[1]wifi-menu, [2]bluetooth-menu, [3]note-menu, [4]energy-menu, [5]clipboard-menu, [6]power-menu, [7]kill-process-menu, [8]audio-menu, [0]All-menus"


mkdir -p "$INSTALL_DIR/config/themes"
mkdir -p "$INSTALL_DIR/common"

cp "$CURRENT_DIR/config/config.sh" "$INSTALL_DIR/config"
cp "$CURRENT_DIR/config/themes/bemenu-theme.sh" "$INSTALL_DIR/config/themes"
cp "$CURRENT_DIR/common/dmenu_launcher_function.sh" "$INSTALL_DIR/common"
cp "$CURRENT_DIR/common/notify_functión.sh" "$INSTALL_DIR/common"


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

