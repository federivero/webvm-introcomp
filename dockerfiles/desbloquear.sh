#!/bin/bash

# Passwords per exercise folder — change these before class!
declare -A PASSWORDS
PASSWORDS["laberinto"]="llavedemarfil"
PASSWORDS["sala_vacia"]="rayos_x"
PASSWORDS["logs_sistema"]="huellas"
PASSWORDS["servidor_web"]="apache"
PASSWORDS["panel_control"]="linux"
PASSWORDS["boveda"]="oro"

SALA="$1"

if [ -z "$SALA" ]; then
    echo "Uso: desbloquear <nombre_de_sala>"
    echo "Salas: sala_vacia, laberinto, logs_sistema, servidor_web, panel_control, boveda"
    exit 1
fi

if [ -z "${PASSWORDS[$SALA]+x}" ]; then
    echo "Sala '$SALA' no encontrada."
    exit 1
fi

read -p "Contraseña: " INPUT
echo

if [ "$INPUT" = "${PASSWORDS[$SALA]}" ]; then
    /usr/local/bin/_do_unlock "$SALA"
    echo "¡Sala '$SALA' desbloqueada!"
else
    echo "Contraseña incorrecta."
    exit 1
fi
