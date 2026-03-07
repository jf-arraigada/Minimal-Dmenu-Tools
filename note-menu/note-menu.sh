#!/usr/bin/env bash

CONFIG_PATH="$HOME/.minimal-dmenu-tools/config/config.sh"
VAULT="$HOME/FocusCloud/Obsidian Vaults"

# =================================================================================================
#                                     DMENU CONFIG
# =================================================================================================


source "$CONFIG_PATH"
source "$THEMES_DIR/bemenu-theme.sh"
source "$NOTE_DIR/notevim.sh"
source "$LIB_DIR/dmenu_launcher_function.sh"

# ==============================
# DMENU VARS
# ==============================

DMENU_CENTER_POS_FLAGS=(-W 0.5 -l 15 -c -P ">" --fixed-height)
DMENU_BOTTOM_POS_FLAGS=(-b)


# =================================================================================================
#                                     FUNCTION CODE
# =================================================================================================



# ==============================
# BROWSE FUNCTION
# ==============================


browse() {
  local dir="$1"
  while [[ true ]]; do
    mapfile -d '' items < <(
      find "$dir" -mindepth 1 -maxdepth 1 \( -type d -o -iname "*.md" \) -print0
      )
    
      special_entries=("../" " New note" " New directory")
      entries=()

      for path in "${items[@]}"; do
        name=$(basename "$path")
        if [[ -d "$path" ]]; then
          entries+=("0| $name")
        else
          entries+=("1| $name")
        fi
      done

      sorted_entries=()
      while IFS= read -r line; do
        sorted_entries+=("${line#*|}")
      done < <(printf "%s\n" "${entries[@]}" | sort)

      final_entries=("${special_entries[@]}" "${sorted_entries[@]}")
      choice=$(printf "%s\n" "${final_entries[@]}" | dmenu_launcher "Browse ($(basename $dir)))" center

      [ -z "$choice" ] && return

      case "$choice" in
        "../") dir=$(dirname "$dir")
        ;;
        " New note")
          new=$(echo "" | dmenu_launcher "New note" bottom) 
          [[ -z "$new" ]] && continue
          touch "$dir/$new.md"
          echo "$dir/$new.md"
          notevim "$dir/$new.md"

          return 0
        ;;
        " New directory")
          new_dir=$(echo "" | dmenu_launcher "New note" bottom)
          [[ -z "$new_dir" ]] && continue
          [[ "$new_dir" == *"/"* ]] && continue
          [[ "$new_dir" == "." || "$new_dir" == ".." ]] && continue
          mkdir -p "$dir/$new_dir"
        ;;
        *) dir="$dir/${choice# }"
        ;;
        *)echo "$dir/${choice# }"
           notevim "$dir/${choice# }"; return 0
        ;;
        *) echo default
        ;;
      esac
  done
  
  
}

browse "$VAULT"
