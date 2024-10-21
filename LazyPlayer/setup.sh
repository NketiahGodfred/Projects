#!/bin/bash

# Function to check if a package is installed
is_installed() {
    dpkg -l | grep -qw "$1"
}

# Check if packages are installed
packages=("dirsearch" "terminator" "guake" "ffuf" "gobuster")
need_install=0

for package in "${packages[@]}"; do
    if is_installed "$package"; then
        echo "$package is already installed."
    else
        echo "$package is not installed."
        need_install=1
    fi
done

# Install missing packages with progress bar
if [ $need_install -eq 1 ]; then
    for package in "${packages[@]}"; do
        if ! is_installed "$package"; then
            echo "Installing $package..."
            sudo apt-get install -y "$package" | while IFS= read -r line; do
                echo "$line"
                if [[ "$line" == *"Progress"* ]]; then
                    echo -ne "\r$line"
                fi
            done
            echo -e "\n$package installed."
        fi
    done
fi

# Message for user
echo ""
echo -e "\033[1;34m     ======================================\033[0m"
echo -e "\033[1;33m             Important Setup Alert!      \033[0m"  # Orange (using 33 for yellow)
echo -e "\033[1;34m     ======================================\033[0m"

echo ""
echo ""
echo -e "\033[0;35m    Please configure Terminator:\033[0m"
echo -e "\033[1;31m  -----------------------------------\033[0m"
echo -e "\033[0;35m=> Right click on it > Preferences > Keybindings.\033[0m"
echo -e "\033[0;35m=> Search & Change 'split_horiz' to Alt + H and 'split_vert' to Alt + V.\033[0m"

echo ""

echo -e "\033[1;33mYou must make these changes to continue!\033[0m"
echo ""

# Loop until the user confirms they've made the changes
while true; do
    read -p "Have you made the changes? (yes/no): " answer
    echo ""

    if [[ "$answer" == "yes" || "$answer" == "y" ]]; then
        break
    else
        echo -e "\033[1;31mOpening Terminator for you to make the changes!\033[0m"
        
        # Final messages before opening Terminator
        echo -e "\033[1;34mAll packages are now installed.\033[0m"
        echo ""
        echo ""
        echo -e "\033[1;32m#created by Nketiah - Godfred\033[0m"
        
        sleep 3
        terminator &
        exit 0
    fi
done

# Final messages only if changes are made
echo -e "\033[1;34mAll packages are now installed.\033[0m"
echo ""
echo -e "\033[1;31mOpen Guake and HAVE FUN!\033[0m"
echo ""
echo -e "\033[1;32m#created by Nketiah - Godfred\033[0m"
