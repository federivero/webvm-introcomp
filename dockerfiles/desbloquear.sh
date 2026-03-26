#!/bin/bash

# Passwords per exercise folder — change these before class!
declare -A PASSWORDS
PASSWORDS["laberinto"]="clave"
PASSWORDS["sala_vacia"]="clave"
PASSWORDS["logs_sistema"]="clave"
PASSWORDS["servidor_web"]="clave"
PASSWORDS["panel_control"]="clave"
PASSWORDS["boveda"]="clave"

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
