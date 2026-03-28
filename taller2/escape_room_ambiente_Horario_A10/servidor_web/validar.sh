#!/bin/bash
if [ ! -f "evidencia.txt" ]; then
    echo "Error: No se encontró el archivo 'evidencia.txt'. Recuerda usar la redirección (>)."
    exit 1
fi

if [ "$(grep -c 'FAILED' evidencia.txt)" -eq "8" ] && [ "$(grep -c 'SUCCESS' evidencia.txt)" -eq "0" ]; then
    echo "¡Excelente! Has aislado los registros correctos."
    echo "Bandera 3: FLAG{06D4_R3D1R_L0G5_61A7}"
else
    echo "El archivo 'evidencia.txt' no contiene exactamente los registros fallidos. ¡Revisa tu filtro!"
fi
