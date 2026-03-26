#!/bin/bash

# Whitelist to prevent path traversal — only unlocks known exercise folders
case "$1" in
    sala_vacia|laberinto|logs_sistema|servidor_web|panel_control|boveda)
        chmod -R 755 "/home/user/taller2/$1"
        ;;
    *)
        echo "Sala inválida." >&2
        exit 1
        ;;
esac
