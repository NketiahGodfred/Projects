#!/bin/bash

clear

# Define color variables
LIGHT_GREEN="\e[1;32m"
YELLOW="\e[1;33m"
RESET="\e[0m"

# Function to display the banner
display_banner() {
    echo -e "${LIGHT_GREEN}    __                      ____  __                     "
    echo -e "   / /   ____ _____  __  __/ __ \/ /___ ___  _____  _____"
    echo -e "  / /   / __ \`/_  / / / / / /_/ / / __ \` / / / / _ \/ ___/"
    echo -e " / /___/ /_/ / / /_/ /_/ / ____/ / /_/ / /_/ /  __/ /    "
    echo -e "/_____/\__,_/ /___/\__, /_/   /_/\__,_/\__, /\___/_/     "
    echo -e "                  /____/              /____/             ${RESET}"
    echo -e "${YELLOW}       Built by Nketiah Godfred       ${RESET}"
    echo -e "${LIGHT_GREEN}       A lazy man playing CTFs         ${RESET}"
    echo -e "${YELLOW}----------------------------------------${RESET}"
}

# Call the function to display the banner
display_banner

# Get the current directory of the script
working_directory="$(cd "$(dirname "$0")/source" && pwd)"

show_menu() {
    echo "1) Lazy Recon"
    echo "2) Stabilize Shell"
    echo "3) File Upload"
    echo "4) DNS Enumeration"
    echo "5) Directory Search"
    echo "6) Exit"
}

start_nmap_scan() {
    read -p "Enter an IP: " user_input_ip

    if [[ -z "$user_input_ip" ]]; then
        echo "IP cannot be empty. Please enter a valid IP."
        return
    fi

    read -p "Enter the path to store recon output (or press Enter to use current directory): " folder_path
    if [[ -z "$folder_path" ]]; then
        folder_path="$(pwd)/recon"
    else
        folder_path="$folder_path/recon"
    fi

    mkdir -p "$folder_path"
    echo "Folder created at: $folder_path"

    guake --hide

    terminator -e "bash -c '$working_directory/nmapscan.sh \"$user_input_ip\" \"$folder_path\"'" &
    sleep 1

    NEW_TERMINATOR_WINDOW=$(xdotool search --class terminator | tail -n 1)
    xdotool windowactivate "$NEW_TERMINATOR_WINDOW"
    xdotool keydown Super
    xdotool key Up
    xdotool keyup Super

    echo "Nmap scan started. Results will be stored in: $folder_path"
    exit 0
}

while true; do
    show_menu
    read -p "Choose an option [1-6]: " choice

    case $choice in
        1)
            start_nmap_scan
            ;;
        2)
            "$working_directory/stabilize.sh"
            ;;
        3)
            "$working_directory/file_upload.sh" 
            ;;
        4)
            "$working_directory/dns_enum.sh"
            ;;
        5)
            "$working_directory/dirbust.sh" 
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            sleep 0.2
            ;;
    esac
done
