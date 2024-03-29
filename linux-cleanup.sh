#!/bin/bash

base_packages_file="pkgs.base"

# Get list of currently installed packages
packages_to_remove=$(comm -13 <(sort "$base_packages_file") <(pacman -Q | awk '{ print $1 }'))

# Count the number of packages to remove
amount_of_packages=$(echo "$packages_to_remove" | wc -l)
echo "There are $amount_of_packages packages to remove."

# Wait for user confirmation
read -p "Do you want to remove these packages? (y/n): " confirm
if [[ $confirm == [Yy]* ]]; then
    # Remove the packages
    sudo pacman -Rs $packages_to_remove
else
    echo "Package removal cancelled."
fi
