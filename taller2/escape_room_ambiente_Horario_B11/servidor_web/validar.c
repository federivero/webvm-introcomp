#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Lee una variable del archivo de metadatos para mantener las banderas dinámicas
void get_meta_var(const char *var_name_eq, char *buffer, size_t buffer_size) {
    FILE *fp = fopen("../../.ambiente_metadata", "r");
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
