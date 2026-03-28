#!/bin/bash

generar_ambiente() {
# Nombre del directorio principal donde se desarrollará el Escape Room
local BASE_DIR="$1"

# Generar prefijo y sufijo aleatorios únicos (en formato hexadecimal de 4 caracteres)
local PREFIX=$(printf "%04X" $RANDOM)
local SUFFIX=$(printf "%04X" $RANDOM)

echo "Creando ambiente para el Escape Room en ./$BASE_DIR..."

# Limpiar el ambiente si ya existe previamente y crearlo de nuevo
rm -rf "$BASE_DIR"
mkdir -p "$BASE_DIR"
cd "$BASE_DIR" || return 1

# --- Desafío 1: El Laberinto (Navegación) ---
echo "Configurando Desafío 1..."
mkdir -p laberinto

# Definir diccionarios para la estructura
alas=("ala_norte" "ala_sur" "ala_este" "ala_oeste" "subsuelo" "torre_central" "atico")
habitaciones=("habitacion_roja" "habitacion_azul" "pasillo_oscuro" "callejon_sin_salida" "armario_limpieza" "bano" "oficina" "laboratorio")
muebles=("cajon" "estante" "ropero" "mesa" "baul" "caja_fuerte" "archivero" "casillero")
escondites=("fondo" "doble_fondo" "interior" "secreto" "hueco" "debajo")

# Generar un laberinto de directorios falsos de manera aleatoria (50 rutas falsas)
for i in {1..50}; do
    ala_falsa="${alas[$RANDOM % ${#alas[@]}]}"
    hab_falsa="${habitaciones[$RANDOM % ${#habitaciones[@]}]}"
    mueble_falso="${muebles[$RANDOM % ${#muebles[@]}]}"
    
    dir_path="laberinto/$ala_falsa/$hab_falsa/$mueble_falso"
    mkdir -p "$dir_path"
    echo "Aquí no hay nada interesante, solo polvo y telarañas." > "$dir_path/basura.txt"
    if [ $((RANDOM % 4)) -eq 0 ]; then
        echo "Un recibo viejo de $RANDOM pesos." > "$dir_path/recibo_$((RANDOM % 1000)).txt"
    fi
done

# Crear el camino real y esconder la nota de rescate
N1="${alas[$RANDOM % ${#alas[@]}]}"
N2="${habitaciones[$RANDOM % ${#habitaciones[@]}]}"
N3="${muebles[$RANDOM % ${#muebles[@]}]}"
N4="${escondites[$RANDOM % ${#escondites[@]}]}"
CAMINO_REAL="laberinto/$N1/$N2/$N3/$N4"
mkdir -p "$CAMINO_REAL"
echo "¡Me encontraste! Has demostrado que sabes navegar." > "$CAMINO_REAL/nota_de_rescate.txt"
echo "Bandera 1: FLAG{${PREFIX}_NAV_3XP3RT_${SUFFIX}}" >> "$CAMINO_REAL/nota_de_rescate.txt"

# --- Desafío 2: La Aguja en el Pajar (Filtros) ---
echo "Configurando Desafío 2..."
mkdir -p logs_sistema
# Generar 5000 líneas de log falso
for i in {1..5000}; do
    echo "INFO: Conexión establecida desde 192.168.1.$((RANDOM % 255)) - status: OK" >> logs_sistema/conexiones.log
done
# Insertar la bandera y la palabra PASSWORD en una línea aleatoria (ej. línea 3456)
sed -i "3456i WARNING: Intento sospechoso. PASSWORD utilizada: FLAG{${PREFIX}_GR3P_M4ST3R_${SUFFIX}}" logs_sistema/conexiones.log

# --- Desafío 3: El Rastro del Intruso (Redirección) ---
echo "Configurando Desafío 3..."
mkdir -p servidor_web
# Generar un log de autenticaciones con intentos exitosos y fallidos
FAILED_COUNT=0
for i in {1..100}; do
    if [ $((RANDOM % 10)) -eq 0 ]; then
        echo "FAILED login from 10.0.0.$((RANDOM % 255)) - Pista del intruso" >> servidor_web/auth.log
        FAILED_COUNT=$((FAILED_COUNT + 1))
    else
        echo "SUCCESS login from 192.168.1.$((RANDOM % 255))" >> servidor_web/auth.log
    fi
done

# Crear script validador para entregar la bandera
cat << EOF > servidor_web/validar.sh
#!/bin/bash
if [ ! -f "evidencia.txt" ]; then
    echo "Error: No se encontró el archivo 'evidencia.txt'. Recuerda usar la redirección (>)."
    exit 1
fi

if [ "\$(grep -c 'FAILED' evidencia.txt)" -eq "$FAILED_COUNT" ] && [ "\$(grep -c 'SUCCESS' evidencia.txt)" -eq "0" ]; then
    echo "¡Excelente! Has aislado los registros correctos."
    echo "Bandera 3: FLAG{${PREFIX}_R3D1R_L0G5_${SUFFIX}}"
else
    echo "El archivo 'evidencia.txt' no contiene exactamente los registros fallidos. ¡Revisa tu filtro!"
fi
EOF
chmod +x servidor_web/validar.sh

# --- Desafío 4: Lo Invisible (Archivos Ocultos) ---
echo "Configurando Desafío 4..."
mkdir -p sala_vacia

# Archivos visibles (para despistar si solo usan 'ls')
echo "Parece que no hay nada importante aquí a simple vista." > sala_vacia/nota_abandonada.txt
echo "Revisar conductos de ventilación... hecho." > sala_vacia/bitacora_guardia.log
echo "Recordatorio: La sala debe mantenerse limpia." > sala_vacia/reglas_sala.txt

# Archivos ocultos de distracción
echo "Último acceso al sistema: desconocido." > sala_vacia/.historial_accesos
echo "Modo de depuración: DESACTIVADO" > sala_vacia/.config_sistema

# El archivo oculto real con la bandera y la pista
echo "Bandera 4: FLAG{${PREFIX}_H1DD3N_S3CR3T_${SUFFIX}}" > sala_vacia/.llave_maestra
echo "Pista adicional: La contraseña del usuario 'admin' es 'escape123'" >> sala_vacia/.llave_maestra

# --- Desafío 5: ¿Quién soy? (Identidad y Usuarios) ---
echo "Configurando Desafío 5..."
mkdir -p boveda
echo "Bandera 5: FLAG{${PREFIX}_WH0_4M_1_4DM1N_${SUFFIX}}" > boveda/tesoro.txt

# Comprobar si somos root para crear el usuario 'admin' real o solo simular los permisos
if [ "$EUID" -ne 0 ]; then
    echo "  -> Aviso: Ejecutando sin permisos root. Simulando Desafío 5 (quitando permisos de lectura)."
    chmod 000 boveda/tesoro.txt
else
    echo "  -> Permisos root detectados. Creando usuario 'admin'..."
    if ! id "admin" &>/dev/null; then
        # Si el grupo 'admin' ya existe en este SO, lo asignamos directamente para evitar errores
        if getent group admin &>/dev/null; then
            useradd -m -s /bin/bash -g admin admin
        else
            useradd -m -s /bin/bash admin
        fi
        echo "admin:escape123" | chpasswd
    fi
    # Aseguramos la contraseña por si el usuario ya existía de un intento anterior
    echo "admin:escape123" | chpasswd

    # Asegurar que admin sea dueño de la carpeta y el archivo
    chown admin:admin boveda
    chmod 755 boveda
    chown admin:admin boveda/tesoro.txt
    chmod 400 boveda/tesoro.txt

    # IMPORTANTE: Si el ambiente se genera dentro de /root, el usuario 'admin' no podrá atravesar
    # la carpeta para leer el archivo y recibirá "Permission denied". Aseguramos el acceso (+x):
    RUTA_ACTUAL="$PWD"
    while [ "$RUTA_ACTUAL" != "/" ]; do
        chmod a+x "$RUTA_ACTUAL" 2>/dev/null
        RUTA_ACTUAL=$(dirname "$RUTA_ACTUAL")
    done
fi

# --- Desafío 6: Acceso Denegado (Permisos) ---
echo "Configurando Desafío 6..."
mkdir -p panel_control
cat << EOF > panel_control/reinicio_sistema.sh
#!/bin/bash
echo "Iniciando secuencia de reinicio..."
sleep 1
echo "Sistemas restaurados. ¡Felicidades, salvaste los datos!"
echo "Bandera 6: FLAG{${PREFIX}_CHM0D_W1N_${SUFFIX}}"
EOF
# Quitar permisos de ejecución explícitamente para que deban usar chmod
chmod -x panel_control/reinicio_sistema.sh

# Volver al directorio padre para crear el archivo zip
# cd ..
# echo "Comprimiendo el ambiente en ${BASE_DIR}.zip..."
# zip -qr "${BASE_DIR}.zip" "$BASE_DIR"

echo "====================================================="
echo "¡Ambiente creado exitosamente en el directorio '$BASE_DIR'!"
}

# Lista de todos los grupos horarios
GRUPOS=(
    "Horario_A1" "Horario_B1" "Horario_A2" "Horario_B2"
    "Horario_A3" "Horario_B3" "Horario_A4" "Horario_B4"
    "Horario_A5" "Horario_B5" "Horario_A6" "Horario_B6"
    "Horario_A7" "Horario_B7" "Horario_A8" "Horario_B8"
    "Horario_A9" "Horario_B9" "Horario_A10" "Horario_B10"
    "Horario_A11" "Horario_B11" "Colonia" "Salto" "Paysandu"
)

for GRUPO in "${GRUPOS[@]}"; do
    generar_ambiente "escape_room_ambiente_${GRUPO}"
done
