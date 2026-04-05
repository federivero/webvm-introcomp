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

# Contar archivos basura.txt con globbing (find no está disponible)
# Los archivos falsos están a exactamente 3 niveles: laberinto/<ala>/<habitacion>/<mueble>/basura.txt
COUNT=0
for f in "$LABERINTO"/*/*/*/basura.txt; do
    [ -f "$f" ] && COUNT=$((COUNT + 1))
done

if [ "$COUNT" -gt 0 ]; then
    echo "Aún quedan $COUNT archivos 'basura.txt' en el laberinto. ¡Seguí limpiando!"
    exit 1
fi

# Leer PREFIX y SUFFIX del archivo de metadatos para armar la bandera dinámica
PREFIX="XXXX"
SUFFIX="YYYY"
META="$ESCAPE_DIR/.meta/.ambiente_metadata"
if [ -f "$META" ]; then
    while IFS='=' read -r key val; do
        case "$key" in
            PREFIX) PREFIX="$val" ;;
            SUFFIX) SUFFIX="$val" ;;
        esac
    done < "$META"
fi

echo "¡La mansión está impecable! No queda ni un archivo basura.txt."
echo "Bandera Side Quest: FLAG{${PREFIX}_CL34N_M4NS10N_${SUFFIX}}"
