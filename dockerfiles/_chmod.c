#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>

int main(int argc, char *argv[]) {
    uid_t ruid = getuid();

    // Si no es root quien llama, validamos cada argumento provisto
    if (ruid != 0) {
        int options_ended = 0;
        for (int i = 1; i < argc; i++) {
            if (!options_ended && strcmp(argv[i], "--") == 0) {
                options_ended = 1;
                continue;
            }

            if (!options_ended && argv[i][0] == '-') {
                // Bloquear uso recursivo para evitar que el usuario modifique en lote 
                // archivos que estén anidados y pertenezcan a otros usuarios.
                if (strcmp(argv[i], "--recursive") == 0) {
                    fprintf(stderr, "chmod: El uso recursivo (-R) está deshabilitado por seguridad.\n");
                    return 1;
                }
                if (argv[i][1] != '-' && strchr(argv[i], 'R') != NULL) {
                    fprintf(stderr, "chmod: El uso recursivo (-R) está deshabilitado por seguridad.\n");
                    return 1;
                }
                continue;
            }

            struct stat st;
            // Usamos lstat para verificar de manera segura incluso enlaces simbólicos
            if (lstat(argv[i], &st) == 0) {
                if (st.st_uid != ruid) {
                    fprintf(stderr, "chmod: cambiando permisos de '%s': Operación no permitida (No eres el dueño)\n", argv[i]);
                    return 1;
                }
            }
        }
        
        // Si todos los chequeos pasan, escalamos privilegios a root completamente 
        // para que la ejecución real en WebVM no falle por limitaciones de emulación.
        setuid(0);
    }

    // Ejecutar el comando chmod nativo
    execv("/bin/chmod.real", argv);
    perror("execv");
    return 1;
}
