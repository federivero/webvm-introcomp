#!/bin/bash

BATCH_SIZE=25
DESAFIOS_SELECCIONADOS="all"

# Procesar argumentos de la línea de comandos
while [[ $# -gt 0 ]]; do
    case "$1" in
        -b|--batch-size)
            BATCH_SIZE="$2"
            shift 2
            ;;
        -d|--desafios)
            DESAFIOS_SELECCIONADOS="$2"
            shift 2
            ;;
        *)
            # Los argumentos posicionales restantes se asumen como desafíos
            DESAFIOS_SELECCIONADOS="$*"
            break
            ;;
    esac
done

generar_ambiente() {
# Nombre del directorio principal donde se desarrollará el Escape Room
local BASE_DIR="$1"

# Semilla aleatoria única por subproceso para evitar colisiones al paralelizar
RANDOM=$BASHPID

echo "Creando ambiente para el Escape Room en ./$BASE_DIR..."

# Crear el ambiente base si no existe
mkdir -p "$BASE_DIR"
cd "$BASE_DIR" || return 1

# Mantener consistencia en el prefijo y sufijo si ya se habían generado para este grupo (útil si se regenera solo un desafío)
local PREFIX SUFFIX
mkdir -p .meta
if [ -f ".meta/.ambiente_metadata" ]; then
    source .meta/.ambiente_metadata
else
    PREFIX=$(printf "%02X" $((RANDOM % 256)))
    SUFFIX=$(printf "%02X" $((RANDOM % 256)))
    echo "PREFIX=$PREFIX" > .meta/.ambiente_metadata
    echo "SUFFIX=$SUFFIX" >> .meta/.ambiente_metadata
fi
chmod a-r,a+x .meta


## --- Desafío 0: Demo del Docente --- ##
if [[ "$DESAFIOS_SELECCIONADOS" == *"all"* ]] || [[ " $DESAFIOS_SELECCIONADOS " =~ " 0 " ]]; then

echo "Configurando Desafío 0 (Demo)..."
rm -rf demo_inicial
mkdir -p demo_inicial/otra_carpeta

echo "¡Hola! Este es un archivo de texto." > demo_inicial/bienvenida.txt
echo "Si estás leyendo esto, significa que usaste el comando 'cat' correctamente." >> demo_inicial/bienvenida.txt
echo "Ahora intenta entrar en 'otra_carpeta' usando el comando 'cd'." >> demo_inicial/bienvenida.txt

echo "¡Genial! Has navegado hasta aquí." > demo_inicial/otra_carpeta/secreto_demo.txt
echo "Bandera 0: FLAG{${PREFIX}_D3M0_0_${SUFFIX}}" >> demo_inicial/otra_carpeta/secreto_demo.txt

fi


## --- Desafío 1: El Laberinto (Navegación) --- ##
if [[ "$DESAFIOS_SELECCIONADOS" == *"all"* ]] || [[ " $DESAFIOS_SELECCIONADOS " =~ " 1 " ]]; then

echo "Configurando Desafío 1..."
rm -rf laberinto
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

# Guardar la cantidad de recibos generada dinámicamente
RECIBO_COUNT=0
for f in laberinto/*/*/*/recibo_*.txt; do
    [ -f "$f" ] && RECIBO_COUNT=$((RECIBO_COUNT + 1))
done
echo "RECIBO_COUNT=$RECIBO_COUNT" >> .meta/.ambiente_metadata

# Crear el camino real y esconder la nota de rescate
N1="${alas[$RANDOM % ${#alas[@]}]}"
N2="${habitaciones[$RANDOM % ${#habitaciones[@]}]}"
N3="${muebles[$RANDOM % ${#muebles[@]}]}"
N4="${escondites[$RANDOM % ${#escondites[@]}]}"
CAMINO_REAL="laberinto/$N1/$N2/$N3/$N4"
mkdir -p "$CAMINO_REAL"
echo "¡Felicitaciones! Encontraste la nota." > "$CAMINO_REAL/nota_de_rescate.txt"
echo "" >> "$CAMINO_REAL/nota_de_rescate.txt"
echo "En realidad, son terribles noticias, si estás leyendo esto es que algo terrible ha sucedido." >> "$CAMINO_REAL/nota_de_rescate.txt"
echo "" >> "$CAMINO_REAL/nota_de_rescate.txt"
echo "Al escribir esta nota recordé que la contraseña cambia una vez por mes (como indican todos los protocolos de seguridad), por lo que no tendría sentido escribirla aquí. Lamentablemente no tengo solución. Podrías intentar buscar la contraseña en los logs. Me parece que una vez la ví por ahí..." >> "$CAMINO_REAL/nota_de_rescate.txt"
echo "" >> "$CAMINO_REAL/nota_de_rescate.txt"
echo "Bandera 1: FLAG{${PREFIX}_NAV_3XP3RT_${SUFFIX}}" >> "$CAMINO_REAL/nota_de_rescate.txt"
fi


## --- Desafío 2: La Aguja en el Pajar (Filtros) --- ##
if [[ "$DESAFIOS_SELECCIONADOS" == *"all"* ]] || [[ " $DESAFIOS_SELECCIONADOS " =~ " 2 " ]]; then

echo "Configurando Desafío 2..."
rm -rf logs_sistema
mkdir -p logs_sistema

# Diccionario de contraseñas obvias para despistar
passwords_falsas=("ROOT" "ADMIN" "123456" "QWERTY" "admin123" "password" "root" "admin")

# Generar 5000 líneas de log falso
for i in {1..5000}; do
    if [ $((RANDOM % 100)) -eq 0 ]; then
        fake_pwd="${passwords_falsas[$RANDOM % ${#passwords_falsas[@]}]}"
        echo "WARNING: Intento sospechoso. $fake_pwd utilizada: Sigue buscando la bandera." >> logs_sistema/conexiones.log
    else
        echo "INFO: Conexion establecida desde 192.168.1.$((RANDOM % 255)) - status: OK" >> logs_sistema/conexiones.log
    fi
done
# Insertar la bandera y la palabra PASSWORD en una línea aleatoria entre 3000 y 4000
LINEA_INSERCION=$((RANDOM % 1001 + 3000))
sed -i "${LINEA_INSERCION}i WARNING: Intento sospechoso. PASSWORD utilizada: FLAG{${PREFIX}_GR3P_M4ST3R_${SUFFIX}}" logs_sistema/conexiones.log
fi


## --- Desafío 3: El Rastro del Intruso (Redirección) --- ##
if [[ "$DESAFIOS_SELECCIONADOS" == *"all"* ]] || [[ " $DESAFIOS_SELECCIONADOS " =~ " 3 " ]]; then

echo "Configurando Desafío 3..."
rm -rf servidor_web
mkdir -p servidor_web
# Generar un log de autenticaciones con intentos exitosos y fallidos
FAILED_COUNT=0
for i in {1..1000}; do
    if [ $((RANDOM % 100)) -eq 0 ]; then
        echo "FAILED login from 10.0.0.$((RANDOM % 255)) - Pista del intruso" >> servidor_web/auth.log
        FAILED_COUNT=$((FAILED_COUNT + 1))
    else
        echo "SUCCESS login from 192.168.1.$((RANDOM % 255))" >> servidor_web/auth.log
    fi
done

# Guardar la cantidad de fallos generada dinámicamente
echo "FAILED_COUNT=$FAILED_COUNT" >> .meta/.ambiente_metadata

# Crear el código fuente en C para el ejecutable validador
cat << 'EOF' > servidor_web/validar.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Lee una variable del archivo de metadatos para mantener las banderas dinámicas
void get_meta_var(const char *var_name_eq, char *buffer, size_t buffer_size) {
    FILE *fp = fopen("../.meta/.ambiente_metadata", "r");
    if (fp == NULL) {
        strncpy(buffer, "XXXX", buffer_size - 1);
        buffer[buffer_size - 1] = '\0';
        return;
    }
    char line[256];
    size_t var_len = strlen(var_name_eq);
    while (fgets(line, sizeof(line), fp)) {
        if (strncmp(line, var_name_eq, var_len) == 0) {
            char *value = line + var_len;
            value[strcspn(value, "\r\n")] = 0; // Quitar salto de línea
            strncpy(buffer, value, buffer_size - 1);
            buffer[buffer_size - 1] = '\0';
            fclose(fp);
            return;
        }
    }
    strncpy(buffer, "YYYY", buffer_size - 1); // Fallback si no se encuentra
    buffer[buffer_size - 1] = '\0';
    fclose(fp);
}

int count_occurrences(const char *filename, const char *word) {
    FILE *fp = fopen(filename, "r");
    if (!fp) return -1;
    char line[1024];
    int count = 0;
    while (fgets(line, sizeof(line), fp)) {
        if (strstr(line, word) != NULL) count++;
    }
    fclose(fp);
    return count;
}

int main() {
    FILE *f = fopen("evidencia.txt", "r");
    if (!f) {
        printf("Error: No se encontró el archivo 'evidencia.txt'. Recuerda usar la redirección (>).\n");
        return 1;
    }
    fclose(f);

    char failed_str[16];
    get_meta_var("FAILED_COUNT=", failed_str, sizeof(failed_str));
    int expected_failed = atoi(failed_str);

    if (count_occurrences("evidencia.txt", "FAILED") == expected_failed && count_occurrences("evidencia.txt", "SUCCESS") == 0) {
        char prefix[16], suffix[16];
        get_meta_var("PREFIX=", prefix, sizeof(prefix));
        get_meta_var("SUFFIX=", suffix, sizeof(suffix));
        printf("¡Excelente! Has aislado los registros correctos.\n");
        printf("Bandera 3: FLAG{%s_R3D1R_L0G5_%s}\n", prefix, suffix);
    } else {
        printf("El archivo 'evidencia.txt' no contiene exactamente los registros fallidos. ¡Revisa tu filtro!\n");
    }
    return 0;
}
EOF
fi


## --- Desafío 4: Lo Invisible (Archivos Ocultos) --- ##
if [[ "$DESAFIOS_SELECCIONADOS" == *"all"* ]] || [[ " $DESAFIOS_SELECCIONADOS " =~ " 4 " ]]; then

echo "Configurando Desafío 4..."
rm -rf sala_vacia
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
echo "" >> sala_vacia/.llave_maestra
echo "No debo olvidar, no debo olvidar" >> sala_vacia/.llave_maestra
echo "Hay dos contraseñas que no debo olvidar: 'escape123' y 'password', pero contraseñas para qué usuarios? no puedo recordarlo" >> sala_vacia/.llave_maestra

# Side quest 1: Limpiar la mansión
echo "[SIDE QUEST]" > sala_vacia/.recordatorio
echo "Por favor, si estás leyendo esto, solo soy un pobre jefe de seguridad..." >> sala_vacia/.recordatorio
echo "...Un jefe de seguridad con una gran mansión..." >> sala_vacia/.recordatorio
echo "...Que además está muy sucia!!..." >> sala_vacia/.recordatorio
echo "" >> sala_vacia/.recordatorio
echo "Por favor, ¿podrías limpiar/borrar/eliminar toda la basura de mi mansión?" >> sala_vacia/.recordatorio
echo "Seré muy feliz cuando verificar_basura me informe que ya no hay basura." >> sala_vacia/.recordatorio
fi


## --- Desafío 5: ¿Quién soy? (Identidad y Usuarios) --- ##
if [[ "$DESAFIOS_SELECCIONADOS" == *"all"* ]] || [[ " $DESAFIOS_SELECCIONADOS " =~ " 5 " ]]; then

echo "Configurando Desafío 5..."
rm -rf boveda
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

# Side quest 2: Recibos
echo "[SIDE QUEST]" > boveda/.nota_deudas
echo "Ay, ay, ay!" >> boveda/.nota_deudas
echo "A cada paso que doy en mi mansión encuentro un recibo." >> boveda/.nota_deudas
echo "Otro paso, otro recibo." >> boveda/.nota_deudas
echo "Y lo peor es que están sin pagar..." >> boveda/.nota_deudas
echo "Ya sé que se pagan con débito automático..." >> boveda/.nota_deudas
echo "Pero de mientras me aliviaría mucho que esos recibos dijeran 'Un recibo viejo de 0 pesos.', para no amargarme cuando los encuentro." >> boveda/.nota_deudas
echo "Seguramente podría verificar_recibos luego y dormir en paz." >> boveda/.nota_deudas
fi


## --- Desafío 6: Acceso Denegado (Permisos) --- ##
if [[ "$DESAFIOS_SELECCIONADOS" == *"all"* ]] || [[ " $DESAFIOS_SELECCIONADOS " =~ " 6 " ]]; then

echo "Configurando Desafío 6..."
rm -rf panel_control
mkdir -p panel_control

# Crear el código fuente en C para el ejecutable de reinicio
cat << 'EOF' > panel_control/reinicio_sistema.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// Lee una variable del archivo de metadatos para mantener las banderas dinámicas
void get_meta_var(const char *var_name_eq, char *buffer, size_t buffer_size) {
    // La ruta es relativa al ejecutable, que estará en panel_control/
    FILE *fp = fopen("../.meta/.ambiente_metadata", "r");
    if (fp == NULL) {
        strncpy(buffer, "XXXX", buffer_size - 1);
        buffer[buffer_size - 1] = '\0';
        return;
    }

    char line[256];
    size_t var_len = strlen(var_name_eq);
    while (fgets(line, sizeof(line), fp)) {
        if (strncmp(line, var_name_eq, var_len) == 0) {
            char *value = line + var_len;
            value[strcspn(value, "\r\n")] = 0; // Quitar salto de línea
            strncpy(buffer, value, buffer_size - 1);
            buffer[buffer_size - 1] = '\0';
            fclose(fp);
            return;
        }
    }

    strncpy(buffer, "YYYY", buffer_size - 1); // Fallback si no se encuentra
    buffer[buffer_size - 1] = '\0';
    fclose(fp);
}

int main() {
    char prefix[16], suffix[16];
    get_meta_var("PREFIX=", prefix, sizeof(prefix));
    get_meta_var("SUFFIX=", suffix, sizeof(suffix));

    printf("Iniciando secuencia de reinicio...\n");
    fflush(stdout);
    sleep(1);
    printf("Apagando servicios...\n");
    fflush(stdout);
    sleep(1);
    printf("Reiniciando sistema...\n");
    fflush(stdout);
    sleep(2);
    printf("Sistemas restaurados. ¡Felicidades, salvaste los datos!\n");
    /* Parte central de la bandera codificada con XOR para dificultar lectura directa del binario */
    const unsigned char enc[] = {0x19, 0x12, 0x17, 0x6A, 0x1E, 0x05, 0x0D, 0x6B, 0x14};
    char mid[10];
    int i;
    for (i = 0; i < 9; i++) mid[i] = enc[i] ^ 0x5A;
    mid[9] = '\0';
    printf("Bandera 6: FLAG{%s_%s_%s}\n", prefix, mid, suffix);

    return 0;
}
EOF
fi

# Volver al directorio padre para crear el archivo zip
# cd ..
# echo "Comprimiendo el ambiente en ${BASE_DIR}.zip..."
# zip -qr "${BASE_DIR}.zip" "$BASE_DIR"

echo "====================================================="
echo "¡Ambiente creado exitosamente en el directorio '$BASE_DIR'!"

cd ..
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

if [[ "$DESAFIOS_SELECCIONADOS" == *"all"* ]]; then
    rm -rf "taller2"
fi
mkdir -p "taller2"
cd "taller2" || exit 1

NUM_JOBS=0

for GRUPO in "${GRUPOS[@]}"; do
    generar_ambiente "escape_room_ambiente_${GRUPO}" &
    ((NUM_JOBS++))
    
    # Esperar a que el lote actual termine antes de lanzar el siguiente
    if (( NUM_JOBS % BATCH_SIZE == 0 )); then
        wait
    fi
done

# Esperar a que finalicen los procesos del último lote (si quedó alguno pendiente)
wait
echo "¡Todos los ambientes han sido generados en paralelo exitosamente!"
