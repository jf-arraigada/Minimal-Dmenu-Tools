#!/usr/bin/env bash

set -euo pipefail

if [ "$MINIMAL_DMENU_TOOLS_GENERAL" != "true" ]; then
  MDT_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd && cd ..)"
  MDT_INSTALL_DIR="$HOME/.minimal-dmenu-tools"

  source "$MDT_ROOT_DIR/common/common.sh"

  log "Installing energy-menu:"

  mkdir -p "$MDT_INSTALL_DIR"

  echo 'Welcome to the energy-menu Installation Menu for "Minimal D-menu Tools!"'

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

  mkdir -p "$MDT_INSTALL_DIR/config/themes"
  mkdir -p "$MDT_INSTALL_DIR/common"

  cp "$MDT_ROOT_DIR/config/config.sh" "$MDT_INSTALL_DIR/config"
  cp "$MDT_ROOT_DIR/config/themes/bemenu-theme.sh" "$MDT_INSTALL_DIR/config/themes"
  cp "$MDT_ROOT_DIR/common/dmenu_launcher_function.sh" "$MDT_INSTALL_DIR/common"
  cp "$MDT_ROOT_DIR/common/notify_function.sh" "$MDT_INSTALL_DIR/common"
  CONFIG_INSTALL_DIR="$MDT_INSTALL_DIR/config"
  ENERGY_INSTALL_DIR="$MDT_INSTALL_DIR/energy-menu"
  ENERGY_CURRENT_DIR="$MDT_ROOT_DIR/energy-menu"
else
  source "$CURRENT_DIR/common/common.sh"

  log "Installing energy-menu:"

  CONFIG_INSTALL_DIR="$INSTALL_DIR/config"
  ENERGY_INSTALL_DIR="$INSTALL_DIR/energy-menu"
  ENERGY_CURRENT_DIR="$CURRENT_DIR/energy-menu"
fi

mkdir -p "$ENERGY_INSTALL_DIR"

require "cpupower" 


cp "$ENERGY_CURRENT_DIR/energy-menu.sh" "$ENERGY_INSTALL_DIR"


case "$SELECTED_DMENU" in
    "bemenu") 
      log "energy-menu installation succed!" 
      ;;
    *) 
      log "energy-menu installation succed! Please fix:"
      echo "[Var] in line 24 of $CONFIG_INSTALL_DIR/config.sh"
      echo "[Flag] in line 25 of $CONFIG_INSTALL_DIR/config.sh"
      echo "[Flag] in line 33 of $CONFIG_INSTALL_DIR/config.sh"
      echo "[Theme] in line 9 of $ENERGY_INSTALL_DIR/energy-menu.sh"
      echo "[Flag] in line 17 of $ENERGY_INSTALL_DIR/energy-menu.sh"
      ;;
esac

mkdir -p "$HOME/.local/bin"
ln -s "$ENERGY_INSTALL_DIR/energy-menu.sh" "$HOME/.local/bin/energy-menu"

