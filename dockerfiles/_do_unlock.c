#include <stdio.h>
#include <string.h>
#include <sys/stat.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Uso: _do_unlock <sala>\n");
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

    char path[256];
    snprintf(path, sizeof(path), "/home/user/taller2/%s", argv[1]);

    if (chmod(path, 0755) != 0) {
        perror("chmod");
        return 1;
    }

    return 0;
}
