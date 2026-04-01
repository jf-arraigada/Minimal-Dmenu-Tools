#!/usr/bin/env bash

set -euo pipefail

if [ "$MINIMAL_DMENU_TOOLS_GENERAL" != "true" ]; then
  MDT_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd && cd ..)"
  MDT_INSTALL_DIR="$HOME/.minimal-dmenu-tools"
  LOG_FILE="$MDT_ROOT_DIR/install.log"

  source "$MDT_ROOT_DIR/common/common.sh"

  log "Installing note-menu:" "$LOG_FILE"

  mkdir -p "$MDT_INSTALL_DIR"

  msg 'Welcome to the note-menu Installation Menu for "Minimal D-menu Tools!"'

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
  NOTE_INSTALL_DIR="$MDT_INSTALL_DIR/note-menu"
  NOTE_CURRENT_DIR="$MDT_ROOT_DIR/note-menu"
else
  source "$CURRENT_DIR/common/common.sh"

  log "Installing note-menu:" "$LOG_FILE"

  CONFIG_INSTALL_DIR="$INSTALL_DIR/config"
  NOTE_INSTALL_DIR="$INSTALL_DIR/note-menu"
  NOTE_CURRENT_DIR="$CURRENT_DIR/note-menu"
fi

mkdir -p "$NOTE_INSTALL_DIR"

require "nvim" "$LOG_FILE" 

log "If you don't use sway, change the notevim.sh script on $NOTE_INSTALL_DIR" "$LOG_FILE"

cp "$NOTE_CURRENT_DIR/note-menu.sh" "$NOTE_INSTALL_DIR"


case "$SELECTED_DMENU" in
    "bemenu") 
      log "note-menu installation succed!" "$LOG_FILE"
      ;;
    *) 
      log "note-menu installation succed! Please fix:" "$LOG_FILE"
      msg "[Var] in line 24 of $CONFIG_INSTALL_DIR/config.sh" "$LOG_FILE"
      msg "[Flag] in line 25 of $CONFIG_INSTALL_DIR/config.sh" "$LOG_FILE"
      msg "[Flag] in line 33 of $CONFIG_INSTALL_DIR/config.sh" "$LOG_FILE"
      msg "[Vault] in line 3 of $NOTE_INSTALL_DIR/note-menu.sh" "$LOG_FILE"
      msg "[Theme] in line 11 of $NOTE_INSTALL_DIR/note-menu.sh" "$LOG_FILE"
      msg "[Flag] in line 19 of $NOTE_INSTALL_DIR/note-menu.sh" "$LOG_FILE"
      msg "[Flag] in line 20 of $NOTE_INSTALL_DIR/note-menu.sh" "$LOG_FILE"
      ;;
esac


mkdir -p "$HOME/.local/bin"
ln -s "$NOTE_INSTALL_DIR/note-menu.sh" "$HOME/.local/bin/note-menu"
