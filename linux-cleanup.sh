#!/bin/bash

# File containing the list of base packages
BASE_PACKAGES_FILE="pkgs.base"

# Helper function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Function to detect the package manager used in the system
get_package_manager() {
    local package_manager=""
    # First, detect the distro and suggest a "most probable" package manager
    local distro=$(awk -F '=' '/^ID=/{print $2}' /etc/os-release)
    case "$distro" in
        "debian" | "ubuntu" | "linuxmint" | "popos")
            package_manager="apt"
            ;;
        "fedora" | "redhat" | "centos")
            package_manager="dnf"
            ;;
        "arch" | "manjaro" | "endeavouros")
            package_manager="pacman"
            ;;
        "alpine")
            package_manager="pkg"
            ;;
        "opensuse" | "suse")
            package_manager="zypper"
            ;;
        "gentoo")
            package_manager="portage"
            ;;
    esac
    # Check if the inferred package manager exists
    if [[ -n "$package_manager" && ! command_exists "$package_manager" ]]; then
        package_manager="" 
    fi
    # If no package manager could not be inferred from the distro, try to detect
    # it based on available commands
    if [[ -z "$package_manager" ]]; then
        if command_exists "apt"; then
            package_manager="apt"
        elif command_exists "dnf"; then
            package_manager="dnf"
        elif command_exists "pacman"; then
            package_manager="pacman"
        elif command_exists "brew"; then
            package_manager="brew"
        elif command_exists "nix-shell"; then
            package_manager="nix"
        elif command_exists "guix shell"; then
            package_manager="guix"
        elif command_exists "apk"; then
            package_manager="pkg"
        elif command_exists "qlist"; then
            package_manager="portage"
        elif command_exists "yum"; then
            package_manager="yum"
        elif command_exists "zypper"; then
            package_manager="zypper"
        fi
    fi
    # If all checks failed, the function will return an empty string
    echo "$package_manager"
}

# Function to get installed packages
# Note: No default case (e.g., *) is provided because the package manager is
#       validated at the start of the script. If the script reaches this point,
#       a valid package manager is guaranteed.
get_installed_packages() {
    case $1 in
        apt)
            dpkg-query -W -f='${binary:Package}\n'
            ;;
        brew)
            brew list
            ;;
        dnf)
            dnf list installed | awk '{print $1}' | tail -n +2
            ;;
        pacman)
            pacman -Q | awk '{ print $1 }'
            ;;
        portage)
            qlist -I
            ;;
        yum)
            yum list installed | awk '{print $1}' | tail -n +2
            ;;
        zypper)
            zypper se --installed-only | awk '{print $2}'
            ;;
        nix)
            nix-env -qa --out-fmt '{ name, version }' | jq -r '.name'
            ;;
        guix)
            guix package list | awk '{print $1}'
            ;;
        pkg)
            apk info -v | awk '{print $1}'
            ;;
    esac
}

# Function to remove packages
# Note: As in get_installed_packages(), no default case (e.g., *) is included
#       because the package manager is validated at the start of the script.
remove_packages() {
    case $1 in
        apt)
            sudo apt remove --purge -y "$2"
            ;;
        brew)
            brew uninstall "$2"
            ;;
        dnf)
            sudo dnf remove -y "$2"
            ;;
        pacman)
            sudo pacman -Rs --noconfirm "$2"
            ;;
        portage)
            sudo emerge --depclean "$2"
            ;;
        yum)
            sudo yum remove -y "$2"
            ;;
        zypper)
            sudo zypper remove "$2"
            ;;
        nix)
            nix-env -e "$2"
            ;;
        guix)
            guix package remove "$2"
            ;;
        pkg)
            sudo apk del "$2"
            ;;
    esac
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    "--dry-run")
      dry_run=true
      shift
      ;;
    "--base-file")
      BASE_PACKAGES_FILE="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--dry-run] [--base-file <filename>]"
      exit 1
      ;;
  esac
done

# Determine the package manager
PACKAGE_MANAGER=$(get_package_manager)
if [[ "$PACKAGE_MANAGER" == "none" ]]; then
    echo "Error: No supported package manager found."
    exit 1
fi

# Check if the base packages file exists
if [[ ! -f "$BASE_PACKAGES_FILE" ]]; then
    echo "Error: Base package list file '$BASE_PACKAGES_FILE' not found."
    exit 1
fi

# Get the list of installed and base packages
installed_packages=$(get_installed_packages "$PACKAGE_MANAGER")
base_packages=$(sort "$BASE_PACKAGES_FILE")

# Identify packages installed on the system but not in the base list
packages_to_remove=()
while IFS= read -r base_package; do
    if ! grep -qxF "$base_package" <<<"$installed_packages"; then
        packages_to_remove+=("$base_package")
    fi
done < "$BASE_PACKAGES_FILE"

# Count the number of packages to be removed
amount_of_packages=$(echo "$packages_to_remove" | wc -w)

# Exit the script if no additional packages were detected.
if [[ -z "$packages_to_remove" ]]; then
    echo "No additional packages need to be removed."
    exit 0
fi

# Show the list of affected packages.
echo "Found $amount_of_packages package(s) not in the base list:"
echo "$packages_to_remove" | tr '\n' ' '

# If the script is in dry run mode, no changes will be made to the system.
if [[ "$dry_run" ]]; then
    echo "Dry run mode active, no changes will be made."
    exit 0
fi

# Prompt the user for confirmation
echo "To proceed, type 'CONFIRM' in uppercase."
echo "Any other input will cancel the operation."
read -p "Your answer: " confirm

# If the user does not explicitly enter "CONFIRM", abort the operation.
# Otherwise, proceed.
if [[ "$confirm" != "CONFIRM" ]]; then
    echo "Package removal cancelled."
    exit 0
fi
echo "Proceeding with package removal..."

# Execute the removal command and display the raw output.
remove_packages "$PACKAGE_MANAGER" "${packages_to_remove[@]}"

if [[ $? -eq 0 ]]; then
    echo "Packages removed successfully."
else
    echo "Errors occurred during package removal."
    exit 1
fi
