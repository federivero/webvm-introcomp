#!/bin/bash

# Sube desde el directorio actual hasta encontrar el directorio escape_room_ambiente_*
ESCAPE_DIR=""
CURRENT="$PWD"
while [ "$CURRENT" != "/" ]; do
    if [[ "$(basename "$CURRENT")" == escape_room_ambiente_* ]]; then
        ESCAPE_DIR="$CURRENT"
        break
    fi
    CURRENT=$(dirname "$CURRENT")
done

# Si no se encontró, buscar en la ubicación estándar
if [ -z "$ESCAPE_DIR" ]; then
    for dir in /home/user/taller2/escape_room_ambiente_*/; do
        [ -d "$dir/laberinto" ] && ESCAPE_DIR="${dir%/}" && break
    done
fi

if [ -z "$ESCAPE_DIR" ] || [ ! -d "$ESCAPE_DIR/laberinto" ]; then
    echo "Error: No se encontró el directorio del escape room."
    echo "Ejecutá este comando desde dentro de tu carpeta escape_room_ambiente_*."
    exit 1
fi

LABERINTO="$ESCAPE_DIR/laberinto"

# Verificar que el laberinto está desbloqueado (accesible)
if [ ! -x "$LABERINTO" ] || [ ! -r "$LABERINTO" ]; then
    echo "Este comando es para uso posterior en el taller."
    exit 1
fi

# Leer metadatos
PREFIX="XXXX"
SUFFIX="YYYY"
EXPECTED_COUNT=0
META="$ESCAPE_DIR/.meta/.ambiente_metadata"
if [ -f "$META" ]; then
    while IFS='=' read -r key val; do
        case "$key" in
            PREFIX)        PREFIX="$val" ;;
            SUFFIX)        SUFFIX="$val" ;;
            RECIBO_COUNT)  EXPECTED_COUNT="$val" ;;
        esac
    done < "$META"
fi

# Verificar que la cantidad de recibos no cambió (no se borró ninguno)
ACTUAL_COUNT=0
for f in "$LABERINTO"/*/*/*/recibo_*.txt; do
    [ -f "$f" ] && ACTUAL_COUNT=$((ACTUAL_COUNT + 1))
done

if [ "$ACTUAL_COUNT" -ne "$EXPECTED_COUNT" ]; then
    echo "La cantidad de recibos no coincide: se esperaban $EXPECTED_COUNT pero hay $ACTUAL_COUNT."
    echo "Los recibos deben editarse, no borrarse ni crearse."
    exit 1
fi

# Verificar que cada recibo diga 'Un recibo viejo de 0 pesos.' (se permiten espacios extra)
WRONG=0
for f in "$LABERINTO"/*/*/*/recibo_*.txt; do
    if [ -f "$f" ]; then
        if ! grep -qE "Un recibo viejo de[[:space:]]*0[[:space:]]*pesos\." "$f"; then
            WRONG=$((WRONG + 1))
        fi
    fi
done

if [ "$WRONG" -gt 0 ]; then
    echo "Hay $WRONG recibo(s) que todavía no dicen 'Un recibo viejo de 0 pesos.'"
    exit 1
fi

echo "¡Todos los $ACTUAL_COUNT recibos fueron saldados!"
echo "Bandera Side Quest: FLAG{${PREFIX}_D3BT_FR33_${SUFFIX}}"
