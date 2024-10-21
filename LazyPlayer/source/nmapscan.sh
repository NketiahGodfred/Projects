#!/bin/bash
sleep 1

working_directory="$(cd "$(dirname "$0")/.." && pwd)"

firefox_open_tabs() {
    while true; do
        read -p "Please enter the port number: " port
        firefox "$user_input:$port" &
    done
}

press_alt_up() {
    for ((i = 0; i < 5; i++)); do
        xdotool key Alt+Up
        sleep 0.1
    done
}

press_alt_left() {
    for ((i = 0; i < 4; i++)); do
        xdotool key Alt+Left
        sleep 0.1
    done
}

press_ctrl_shift_left() {
    local count=18
    xdotool keydown Control
    xdotool keydown Shift
    for ((i = 0; i < count; i++)); do
        xdotool key Left
    done
    xdotool keyup Shift
    xdotool keyup Control
}

press_ctrl_shift_right() {
    local count=22
    xdotool keydown Control
    xdotool keydown Shift
    for ((i = 0; i < count; i++)); do
        xdotool key Right
    done
    xdotool keyup Shift
    xdotool keyup Control
}

run_recon() {
    user_input="$1"
    folder_path="$2"

    figlet LazyRecon

    xdotool key Alt+h
    sleep 0.8
    xdotool type "$working_directory/miscs/./rustscan -a $user_input | tee $folder_path/scan_output"
    xdotool key Return
    wait

    sleep 0.8
    xdotool type "cat $folder_path/scan_output | grep -i 'open' | awk '{print \$2}' | cut -d ':' -f4 | tr -d 'and' > $folder_path/open_ports"
    xdotool key Return
    wait
    xdotool type "rm $folder_path/scan_output"
    xdotool key Return
    xdotool type "clear"
    xdotool key Return
    xdotool type "cat $folder_path/open_ports"
    xdotool key Return
    xdotool key Alt+v
    sleep 0.8
    xdotool type "nmap -sV -sC --min-rate 2500 $user_input -oN $folder_path/initial"
    xdotool key Return
    press_alt_up
    xdotool key Alt+h
    sleep 0.8
    xdotool type "nikto -h $user_input"
    xdotool key Return

    xdotool key Alt+v 
    sleep 0.8
    xdotool type "dirsearch -u $user_input"
    xdotool key Return
    press_ctrl_shift_right
    wait

    press_alt_left

    xdotool key Alt+Down
    xdotool key Alt+h
    sleep 0.8
    xdotool type "nmap -sV -sC --min-rate 2500 $user_input --script=vuln -oN $folder_path/vulns"
    xdotool key Return

    press_ctrl_shift_left
    firefox_open_tabs
}

# Accept IP and folder path from Code 1
user_input="$1"
folder_path="$2"

run_recon "$user_input" "$folder_path"
