#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <pwd.h>
#include <grp.h>
#include <sys/types.h>

int main(int argc, char *argv[]) {
    /* 1. FORCE Real and Effective UID/GID to Root (0) */
    /* This stops the shell from dropping privileges during system() calls */
    setregid(0, 0);
    setreuid(0, 0);

    char target_dir[256] = "/home/user/taller2";
    char cmd_chown_user[512];
    char cmd_chown_admin[512];

    if (argc == 2) {
        snprintf(target_dir, sizeof(target_dir), "/home/user/taller2/%s", argv[1]);
        snprintf(cmd_chown_user, sizeof(cmd_chown_user), "chown -R user:user %s", target_dir);
        snprintf(cmd_chown_admin, sizeof(cmd_chown_admin), "chown admin:admin %s/boveda/tesoro.txt", target_dir);
    } else {
        snprintf(cmd_chown_user, sizeof(cmd_chown_user), "chown -R user:user /home/user/taller2");
        snprintf(cmd_chown_admin, sizeof(cmd_chown_admin), "chown admin:admin /home/user/taller2/*/boveda/tesoro.txt");
    }

    /* 2. Fix ownership lost during WebVM/Docker conversion */
    system(cmd_chown_user);
    
    /* 3. Re-apply specific administrative ownership for your activities */
    system(cmd_chown_admin);

    /* 4. Prepare to drop privileges to the "user" account */
    struct passwd *u = getpwnam("user");
    if (!u) return 1;

    /* 5. Switch to "user" GID and UID */
    setgid(u->pw_gid);
    initgroups("user", u->pw_gid);
    setuid(u->pw_uid);

    /* 6. Launch the shell in the target directory */
    chdir(target_dir);
    execl("/bin/bash", "/bin/bash", (char *)NULL);

    return 0;
}
