**Available Languages**:

[![English](https://raw.githubusercontent.com/arjfabian/arjfabian/main/assets/icons/flags/gb.png)](README.md)
[![Español](https://raw.githubusercontent.com/arjfabian/arjfabian/main/assets/icons/flags/es.png)](README_es.md)
[![Português](https://raw.githubusercontent.com/arjfabian/arjfabian/main/assets/icons/flags/pt.png)](README_pt.md)

# Linux Cleanup

This script helps you remove all packages from your system that are not listed in a provided "base" package list. This can be useful for:

* **System cleanup:** Removing unnecessary packages to free up disk space.

* **System hardening:** Reducing the attack surface by removing potentially vulnerable software.

* **Creating a minimal system:** Maintaining a clean and minimal system with only essential packages.

**Note:**

* This script **is not** guaranteed to delete existing configuration files, only the packages themselves. If you want to delete configuration files, perform a dry run (see [Optional Arguments](#optional-arguments) for more information) and check the documentation for each affected package.

* ⚠️ **Use with caution:** Always back up your system before running this script. Removing packages may lead to unintended consequences, such as:

  * Removing critical system libraries.
  * Breaking dependencies for essential applications.
  * Uninstalling important security updates.

## How to Use

1. **Download the script:** Save the script to your local machine.

2. **Create a `pkgs.base` file:**

    - **Automatic generation:** Refer to the [Base Packages File Creation](#base-packages-file-creation) for more information regarding the supported package managers.

    - **Manual creation (for advanced users):** Create a text file named `pkgs.base` containing a list of essential packages for your system.

3. **Run the script:**

    - Execute the script from the command line:

       ```bash
       ./linux-cleanup.sh
       ```

### Optional Arguments

* `--dry-run`: Perform a dry run. Displays the list of packages that would be removed without actually removing them.

* `--base-file`: Specifies the path to the base packages file (default: `pkgs.base`).

## Supported Package Managers

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

## Base Packages File Creation

You can create the file on your current system or on a "Clean" install, depending on your needs. I **strongly** suggest making sure that the system is in a desirable state (i.e. stable and with no unnecessary packages).

* **Suggestion:** Perform a "minimal" install on a virtual machine, run the appropriate command, and export the result so you get a clean base file.

The included `pkgs.base.archlinux` file corresponds to my own "barebones" installation of Arch Linux, but I can not guarantee that this setup will work for most users.

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

This script is provided as-is without any warranty. Use it at your own risk. The author is not responsible for any damage caused by the use of this script.

## Contributions

Contributions and suggestions are welcome. Please feel free to fork and improve this script.
