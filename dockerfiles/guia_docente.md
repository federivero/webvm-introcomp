# Material

* Diapositivas: https://nube.fing.edu.uy/index.php/s/82KyM3WfF53Z3io \[descargar y ver que hay **notas** bajo cada diapositiva.
* Solución del taller: Ver más abajo en 'hitos'
* Acceso a la consola online https://federivero.github.io/webvm-introcomp/
* Hoja con comandos a usar (Cheat Sheet): PDF con comandos básicos (`ls`, `cd`, `pwd`, `cat`, `grep`, `chmod`, `./`).
* FAQ Sobre el ambiente **al final de este documento.**

# Pautas

En este taller se les proporcionará a los estudiantes una máquina virtual y la tarea consistirá en seguir una serie de comandos a partir de la letra: navegar por el árbol de directorios, manipular archivos, ejecutar comandos como ls, chmod, find, grep, etc.

## Introducción

> 0 a 45 min

La idea de este sección inicial es presentar las bases para el taller. El taller precisa entender los conceptos de sistema de archivos, usuarios y permisos. Es muy natural explicar esos conceptos en conjunto con sistemas operativos, pero para este taller es posible que sea demasiado complejo.

Ver notas bajo cada diapositiva para una guía de qué explicar en cada momento.

**Demo en vivo:** Proyectar la pantalla y mostrar los comandos básicos para que los estudiantes repliquen en sus entornos:

1. "¿Dónde estoy?": `pwd`
2. "¿Qué hay aquí?": `ls` y `ls -l`
3. "Quiero entrar ahí": `cd` y `cd ..`
4. "Quiero leer eso": `cat`

**Práctica guiada:** Los estudiantes repiten estos comandos en sus máquinas para asegurarse de que todos tengan el entorno funcionando.

## Desarrollo

> 45 min a 2h 15 min (1 hora 30 min)

Presentar la narrativa: Son el equipo de respuesta ante incidentes. Deben encontrar códigos de desbloqueo en 90 minutos antes de que se pierdan los datos. Los grupos trabajan de forma autónoma buscando las 6 "Banderas". El docente circula asistiendo.

**Hitos de la actividad:**

* **Desafío 1: El Laberinto (Navegación)**
  * _Misión:_ Encontrar el archivo `nota_de_rescate.txt`.
  * _Obstáculo:_ Está dentro de una estructura de carpetas profunda.
  * _Aprendizaje:_ Uso intensivo de `cd` y `ls`.
* **Desafío 2: La Aguja en el Pajar (Filtros)**
  * _Misión:_ Encontrar la contraseña del usuario administrador.
  * _Obstáculo:_ Hay un archivo `conexiones.log` con 5000 líneas de texto falsas. Deben buscar la palabra "PASSWORD".
  * _Aprendizaje:_ Uso de `grep "PASSWORD" conexiones.log`.
* **Desafío 3: El Rastro del Intruso (Redirección)**
  * _Misión:_ Extraer todas las IPs atacantes de un log y guardarlas en un archivo nuevo llamado evidencia.txt.
  * _Obstáculo:_ grep "FAILED" auth.log \> evidencia.txt. Al crear el archivo, aparece la bandera dentro.
  * _Aprendizaje:_ Redirección de salida (\>).
* **Desafío 4: Lo Invisible (Archivos Ocultos)**
  * _Misión:_ Encontrar la llave maestra.
  * _Obstáculo:_ La carpeta parece vacía al ejecutar `ls`.
  * _Aprendizaje:_ Uso de `ls -a` para ver archivos que empiezan con punto (`.llave_maestra`).
* **Desafío 5: ¿Quién soy? (Identidad y Usuarios)**
  * _Misión:_ El archivo tesoro.txt pertenece al usuario admin. El alumno debe "convertirse" en admin.
  * _Obstáculo:_ Deben encontrar la pista de la contraseña del usuario admin en un archivo oculto anteriormente.
  * _Aprendizaje:_ Uso de `whoami`, `su` (o `sudo`).
* **Desafío 6: Acceso Denegado (Permisos)**
  * _Misión:_ Ejecutar el script `reinicio_sistema.sh` para salvar el día.
  * _Obstáculo:_ Al intentar ejecutarlo (`./reinicio_sistema.sh`), el sistema muestra el mensaje "Permission denied".
  * _Aprendizaje:_ Entender `rwx`. Usar `chmod +x reinicio_sistema.sh`.

## Cierre

> 2h 15 min a 3h (45 min)

**Evaluación:** Los estudiantes deben entregar completar un formulario en EVA con:

1. **Las 6 Banderas:** Los códigos encontrados en cada etapa.
2. **Bitácora de Comandos (Log):** Deben escribir qué comando usaron para resolver cada desafío.
   * _Ejemplo:_ "Para el desafío 2 usamos: `grep PASSWORD log.txt`".
3. **Pregunta de Reflexión:**
   * _"Si fueras el administrador de este sistema, ¿qué error de seguridad identificaste en el Desafío 2 (donde la contraseña estaba en un archivo de texto)?"_

**Debate final:**

* ¿Por qué es útil la consola? (Automatización, servidores remotos).
* ¿Por qué existen los permisos? (Seguridad).

# FAQ sobre el ambiente:

1) La VM tiene persistencia del lado del usuario. Si borran un archivo y refrescan la página el archivo no aparece, ídem con demás cambios. Si accidentalmente rompen el ambiente, tienen dos opciones para comenzar nuevamente:

i) Acceder en incógnito

ii) Borrar los datos de navegación -\> Dependiendo del browser puede ser un poco difícil encontrar la opción para solo borrar los datos de navegación de **este sitio**, puede ser más fácil abrir las herramientas del desarrollador (hotkey F12 en windows) e ir a Aplicación -\> Borrar datos del sitio (Clear site data)

![image.png](image.png){width="652" height="183"}

2) Ejecutar 'sudo' cuelga la máquina virtual. En ese caso deben refrescar la página (F5) o quizás incluso pedirles que realicen el paso anterior.