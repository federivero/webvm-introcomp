#!/bin/bash
if [ ! -f "evidencia.txt" ]; then
    echo "Error: No se encontró el archivo 'evidencia.txt'. Recuerda usar la redirección (>)."
    exit 1
fi

if [ "$(grep -c 'FAILED' evidencia.txt)" -eq "12" ] && [ "$(grep -c 'SUCCESS' evidencia.txt)" -eq "0" ]; then
    echo "¡Excelente! Has aislado los registros correctos."
    echo "Bandera 3: FLAG{1A6E_R3D1R_L0G5_54D4}"
else
    echo "El archivo 'evidencia.txt' no contiene exactamente los registros fallidos. ¡Revisa tu filtro!"
fi
