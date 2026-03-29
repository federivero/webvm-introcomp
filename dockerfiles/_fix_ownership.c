#include <stdlib.h>
#include <unistd.h>
#include <pwd.h>
#include <grp.h>
#include <sys/types.h>

int main() {
    /* 1. FORCE Real and Effective UID/GID to Root (0) */
    /* This stops the shell from dropping privileges during system() calls */
    setregid(0, 0);
    setreuid(0, 0);

    /* 2. Fix ownership lost during WebVM/Docker conversion */
    system("chown -R user:user /home/user/taller2");
    
    /* 3. Re-apply specific administrative ownership for your activities */
    system("chown admin:admin /home/user/taller2/*/boveda/tesoro.txt");

    /* 4. Prepare to drop privileges to the "user" account */
    struct passwd *u = getpwnam("user");
    if (!u) return 1;

    /* 5. Switch to "user" GID and UID */
    setgid(u->pw_gid);
    initgroups("user", u->pw_gid);
    setuid(u->pw_uid);

    /* 6. Launch the shell in the target directory */
    chdir("/home/user/taller2");
    execl("/bin/bash", "/bin/bash", (char *)NULL);

    return 0;
}
