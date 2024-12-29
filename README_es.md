**Idiomas disponibles**:

[![English](https://raw.githubusercontent.com/arjfabian/arjfabian/main/assets/icons/flags/gb.png)](README.md)
[![Español](https://raw.githubusercontent.com/arjfabian/arjfabian/main/assets/icons/flags/es.png)](README_es.md)
[![Português](https://raw.githubusercontent.com/arjfabian/arjfabian/main/assets/icons/flags/pt.png)](README_pt.md)

# Linux Cleanup

Este script ayuda a eliminar todos los paquetes de tu sistema que no estén listados en un archivo de paquetes base provisto. Esto puede ser útil para:

* **Limpieza del sistema:** Eliminar paquetes innecesarios para liberar espacio en el disco.

* **Fortalecimiento del sistema:** Reducir la superficie de ataque eliminando software potencialmente vulnerable.

* **Creación de un sistema mínimo:** Mantener un sistema limpio y mínimo con solo los paquetes esenciales.

**Nota:**

* Este script **no garantiza** eliminar los archivos de configuración existentes, solo los paquetes en sí. Si deseas eliminar archivos de configuración, realiza una ejecución en seco (consulta [Argumentos Opcionales](#argumentos-opcionales) para obtener más información) y verifica la documentación de cada paquete afectado.

* ⚠️ **Úsalo con precaución:** Siempre haz una copia de seguridad de tu sistema antes de ejecutar este script. Eliminar paquetes puede tener consecuencias no deseadas, como:

  * Eliminar bibliotecas críticas del sistema.
  * Romper dependencias para aplicaciones esenciales.
  * Desinstalar actualizaciones de seguridad importantes.

## Cómo usar

1. **Descarga el script:** Guarda el script en tu máquina local.

2. **Crea un archivo `pkgs.base`:**

    - **Generación automática:** Consulta la sección [Creación del archivo de paquetes base](#creación-del-archivo-de-paquetes-base) para obtener más información sobre los gestores de paquetes compatibles.

    - **Creación manual (para usuarios avanzados):** Crea un archivo de texto llamado pkgs.base que contenga una lista de paquetes esenciales para tu sistema.

3. **Ejecuta el script:**

    - Ejecuta el script desde la línea de comandos:

       ```bash
       ./linux-cleanup.sh
       ```

### Argumentos opcionales

* `--dry-run`: Realiza una ejecución en seco. Muestra la lista de paquetes que se eliminarían sin eliminarlos realmente.

* `--base-file`: Especifica la ruta al archivo de paquetes base (predeterminado: `pkgs.base`).

## Gestores de paquetes compatibles

* APT (Debian, Ubuntu, Linux Mint, Pop!_OS)
* DNF (Fedora, Red Hat, CentOS 8+)
* Guix
* Homebrew (macOS)
* Nix
* Pacman (Arch Linux, Manjaro, EndeavourOS)
* Pkg (Alpine Linux)
* Portage (Gentoo)
* YUM (CentOS, Red Hat)
* Zypper (openSUSE, SUSE Linux Enterprise)

## Creación del archivo de paquetes base

Puedes crear el archivo en tu sistema actual o en una instalación "limpia", según tus necesidades. Te recomiendo **encarecidamente** asegurarte de que el sistema se encuentre en un estado deseable (es decir, estable y sin paquetes innecesarios).

* **Sugerencia:** Realiza una instalación "mínima" en una máquina virtual, ejecuta el comando apropiado y exporta el resultado para obtener un archivo base limpio.

El archivo `pkgs.base.archlinux` incluido corresponde a mi propia instalación "mínima" de Arch Linux, pero no puedo garantizar que esta configuración funcione para la mayoría de los usuarios.

### Pacman (Arch Linux, Manjaro, EndeavourOS)

```bash
pacman -Q | awk '{ print $1 }' > pkgs.base
```

### APT (Debian, Ubuntu, Linux Mint, Pop!_OS)

```bash
dpkg-query -W -f='${binary:Package}\n' | sort > pkgs.base
```

### DNF (Fedora, Red Hat, CentOS 8+)

```bash
dnf list installed | awk '{print $1}' | tail -n +2 | sort > pkgs.base
```

### Guix

```bash
guix package list | awk '{print $1}' | sort > pkgs.base
```

### Homebrew (macOS)

```bash
brew list | sort > pkgs.base
```

### Nix

```bash
nix-env -qa --out-fmt '{ name, version }' | jq -r '.name' | sort > pkgs.base
```

### Pkg (Alpine Linux)

```bash
apk info -v | awk '{print $1}' | sort > pkgs.base
```

### Portage (Gentoo)

```bash
qlist -I | sort > pkgs.base
```

### YUM (CentOS, Red Hat)

```bash
yum list installed | awk '{print $1}' | tail -n +2 | sort > pkgs.base
```

### Zypper (openSUSE, SUSE Linux Enterprise)

```bash
zypper se --installed-only | awk '{print $2}' | sort > pkgs.base
```

## Disclaimer

Este script se proporciona tal cual sin ninguna garantía. Úselo bajo su propio riesgo. El autor no se hace responsable de ningún daño causado por el uso de este script.

## Contribuciones

Se agradecen las contribuciones y sugerencias. Siéntete libre de bifurcar y mejorar este script.
