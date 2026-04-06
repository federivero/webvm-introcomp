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
