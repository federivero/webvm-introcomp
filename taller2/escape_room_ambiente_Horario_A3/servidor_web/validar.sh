#!/bin/bash
if [ ! -f "evidencia.txt" ]; then
    echo "Error: No se encontró el archivo 'evidencia.txt'. Recuerda usar la redirección (>)."
    exit 1
fi

if [ "$(grep -c 'FAILED' evidencia.txt)" -eq "11" ] && [ "$(grep -c 'SUCCESS' evidencia.txt)" -eq "0" ]; then
    echo "¡Excelente! Has aislado los registros correctos."
    echo "Bandera 3: FLAG{2C4A_R3D1R_L0G5_6761}"
else
    echo "El archivo 'evidencia.txt' no contiene exactamente los registros fallidos. ¡Revisa tu filtro!"
fi
