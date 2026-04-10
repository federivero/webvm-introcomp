#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <glob.h>
#include <unistd.h>
#include <pwd.h>
#include <sys/types.h>

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Uso: _do_unlock <sala> <ambiente_dir>\n");
        return 1;
    }

    const char *valid[] = {
        "sala_vacia", "laberinto", "logs_sistema",
        "servidor_web", "panel_control", "boveda", NULL
    };

    int found = 0;
    for (int i = 0; valid[i] != NULL; i++) {
        if (strcmp(argv[1], valid[i]) == 0) { found = 1; break; }
    }

    if (!found) {
        fprintf(stderr, "Sala inválida.\n");
        return 1;
    }

    // Validar que el directorio del ambiente sea seguro para evitar path traversal
    if (strncmp(argv[2], "/home/user/taller2/escape_room_ambiente_", 40) != 0 || strstr(argv[2], "..") != NULL) {
        fprintf(stderr, "Error: Directorio de ambiente inválido.\n");
        return 1;
    }

    char target[512];
    snprintf(target, sizeof(target), "%s/%s", argv[2], argv[1]);

    int error = 0;

    if (chmod(target, 0755) != 0) {
        perror("chmod");
        error = 1;
    }

    return error;
}
