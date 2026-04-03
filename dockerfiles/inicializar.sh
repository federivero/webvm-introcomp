#!/bin/bash

GRUPO="$1"

if [ -z "$GRUPO" ]; then
    echo "Uso: inicializar <grupo_horario>"
    echo "Ejemplo: inicializar Horario_A9"
    exit 1
fi

TARGET_DIR="escape_room_ambiente_$GRUPO"

if [ ! -d "/home/user/taller2/$TARGET_DIR" ]; then
    echo "Error: El grupo '$GRUPO' no fue encontrado."
    exit 1
fi

echo "Inicializando ambiente para $GRUPO..."
/usr/local/bin/_fix_ownership "$TARGET_DIR"
