#!/usr/bin/env bash

set -euo pipefail

if [ "$MINIMAL_DMENU_TOOLS_GENERAL" != "true" ]; then
  MDT_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd && cd ..)"
  MDT_INSTALL_DIR="$HOME/.minimal-dmenu-tools"
  LOG_FILE="$MDT_ROOT_DIR/install.log"

  source "$MDT_ROOT_DIR/common/common.sh"

  log "Installing clipboard-menu:" "$LOG_FILE"

  mkdir -p "$MDT_INSTALL_DIR"

  msg 'Welcome to the clipboard-menu Installation Menu for "Minimal D-menu Tools!"'

  msg "Select your D-Menu:"
  msg "[1]bemenu, [2]fuzzel, [3]rofi, [4]wofi, [5]other" 
  read -p  ">>>" DMENU 
  if [[ ! "$DMENU" =~ ^[0-9]+$ ]]; then
    error "Invalid option: $opt" "$LOG_FILE"
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
  CLIPBOARD_INSTALL_DIR="$MDT_INSTALL_DIR/clipboard-menu"
  CLIPBOARD_CURRENT_DIR="$MDT_ROOT_DIR/clipboard-menu"
else
  source "$CURRENT_DIR/common/common.sh"

  log "Installing clipboard-menu:" "$LOG_FILE"

  CONFIG_INSTALL_DIR="$INSTALL_DIR/config"
  CLIPBOARD_INSTALL_DIR="$INSTALL_DIR/clipboard-menu"
  CLIPBOARD_CURRENT_DIR="$CURRENT_DIR/clipboard-menu"
fi

mkdir -p "$CLIPBOARD_INSTALL_DIR"

require "wl-copy" "$LOG_FILE"
require "wl-paste" "$LOG_FILE"
require "systemctl" "$LOG_FILE"


cp "$CLIPBOARD_CURRENT_DIR/clipboard-menu.sh" "$CLIPBOARD_INSTALL_DIR"
cp "$CLIPBOARD_CURRENT_DIR/cliphist.service" "$HOME/.config/systemd/user/"

systemctl --user daemon-reload
systemctl --user enable cliphist.service
systemctl --user start cliphist.service

log "In some cases, the cliphist.service had problems with Sway or other WM so, considere to add to your sway config file this lines:" "$LOG_FILE"
msg "exec_always {" "$LOG_FILE"
msg "  systemctl --user import-environment WAYLAND_DISPLAY SWAYSOCK" "$LOG_FILE"
msg "  systemctl --user start cliphist.service" "$LOG_FILE"
msg "}" "$LOG_FILE"


case "$SELECTED_DMENU" in
    "bemenu") 
      log "clipboard-menu installation succed!" "$LOG_FILE"
      ;;
    *) 
      log "clipboard-menu installation succed! Please fix:" "$LOG_FILE"
      msg "[Var] in line 24 of $CONFIG_INSTALL_DIR/config.sh" "$LOG_FILE"
      msg "[Flag] in line 25 of $CONFIG_INSTALL_DIR/config.sh" "$LOG_FILE"
      msg "[Flag] in line 33 of $CONFIG_INSTALL_DIR/config.sh" "$LOG_FILE"
      msg "[Theme] in line 9 of $CLIPBOARD_INSTALL_DIR/clipboard-menu.sh" "$LOG_FILE"
      msg "[Flag] in line 17 of $CLIPBOARD_INSTALL_DIR/clipboard-menu.sh" "$LOG_FILE"
      ;;
esac

mkdir -p "$HOME/.local/bin"
ln -s "$CLIPBOARD_INSTALL_DIR/clipboard-menu.sh" "$HOME/.local/bin/clipboard-menu"

