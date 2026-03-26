#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <pwd.h>
#include <sys/types.h>

/* Keep in sync with users created in the Dockerfile */
typedef struct { const char *user; const char *password; } Cred;
static Cred creds[] = {
    {"root",  "password"},
    {"user",  "password"},
    {"admin", "escape123"},
    {NULL, NULL}
};

int main(int argc, char *argv[]) {
    const char *username = (argc > 1) ? argv[1] : "root";

    const char *expected = NULL;
    for (int i = 0; creds[i].user != NULL; i++) {
        if (strcmp(username, creds[i].user) == 0) {
            expected = creds[i].password;
            break;
        }
    }

    if (!expected) {
        fprintf(stderr, "su: user %s does not exist\n", username);
        return 1;
    }

    struct passwd *pw = getpwnam(username);
    if (!pw) {
        fprintf(stderr, "su: user %s not found\n", username);
        return 1;
    }

    char password[256];
    printf("Password: ");
    fflush(stdout);
    if (fgets(password, sizeof(password), stdin) == NULL) return 1;
    password[strcspn(password, "\n")] = '\0';

    if (strcmp(password, expected) != 0) {
        fprintf(stderr, "su: Authentication failure\n");
        return 1;
    }

    if (setgid(pw->pw_gid) != 0 || setuid(pw->pw_uid) != 0) {
        perror("su");
        return 1;
    }

    setenv("USER", username, 1);
    setenv("LOGNAME", username, 1);
    setenv("HOME", pw->pw_dir, 1);

    char *shell = (pw->pw_shell && pw->pw_shell[0]) ? pw->pw_shell : "/bin/bash";
    execlp(shell, shell, NULL);
    perror("su");
    return 1;
}
