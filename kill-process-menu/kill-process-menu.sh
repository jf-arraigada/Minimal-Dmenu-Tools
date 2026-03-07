#!/bin/bash

CONFIG_PATH="$HOME/.minimal-dmenu-tools/config/config.sh"

# =================================================================================================
#                                     DMENU CONFIG
# =================================================================================================

source "$CONFIG_PATH"
source "$THEMES_DIR/bemenu-theme.sh"
source "$LIB_DIR/dmenu_launcher_function.sh"
source "$LIB_DIR/notify_function.sh"

# ==============================
# DMENU VARS
# ==============================

DMENU_CENTER_POS_FLAGS=( -c -l 15 -W 0.5 --fixed-height -P ">")

# =================================================================================================
#                                     MAIN FLOW
# =================================================================================================



# Listar procesos del usuario con PID, CPU%, MEM%, comando
# Eliminamos la cabecera con tail -n +2
PROCESSES=$(ps -u $USER -o pid,%cpu,%mem,cmd --sort=-%mem | tail -n +2 | awk '{printf "| %-10.10s | %-25.25s | %-4s%% | %-5sMB |\n", $1, $4, $2, $3}')

# Mostrar la lista en bemenu y permitir seleccionar varios (Shift/Control)
# Se puede usar bemenu-multi si tu versión lo soporta
SELECTED=$(echo "$PROCESSES" | dmenu_launcher "Kill Proccess:" center)

# Salir si no se seleccionó nada
[ -z "$SELECTED" ] && exit 0

# Iterar sobre cada línea seleccionada
echo "$SELECTED" | while read -r line; do
    # Extraer PID de la primera columna
    PID=$(echo "$line" | awk '{print $2}')

    # Intentar cerrar educadamente primero
    kill -15 "$PID" 2>/dev/null

    # Esperar un segundo y matar si sigue vivo
    sleep 1
    if kill -0 "$PID" 2>/dev/null; then
        kill -9 "$PID"
    fi
    notify "Kill Proccess Manager" "Proceso $PID eliminado exitosamente!" 3000
done

