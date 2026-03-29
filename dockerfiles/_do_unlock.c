#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <glob.h>
#include <unistd.h>
#include <pwd.h>
#include <sys/types.h>

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

    struct passwd *pw = getpwnam("user");
    if (!pw) {
        fprintf(stderr, "Error: no se encontró al usuario 'user'.\n");
        return 1;
    }

    char pattern[256];
    snprintf(pattern, sizeof(pattern), "/home/user/taller2/*/%s", argv[1]);

    glob_t globbuf;
    int error = 0;
    if (glob(pattern, 0, NULL, &globbuf) == 0) {
        for (size_t i = 0; i < globbuf.gl_pathc; i++) {
            if (chmod(globbuf.gl_pathv[i], 0777) != 0) {
                perror("chmod");
                error = 1;
            }
            // if (chown(globbuf.gl_pathv[i], pw->pw_uid, pw->pw_gid) != 0) {
            //     perror("chown");
            //     error = 1;
            // }
        }
        globfree(&globbuf);
    } else {
        fprintf(stderr, "No se encontró la sala.\n");
        return 1;
    }

    return error;
}
