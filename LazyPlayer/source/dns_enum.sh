#!/bin/bash

working_directory="$(cd "$(dirname "$0")/.." && pwd)"

dns_enum() {
    read -p "Enter an IP: " user_input_dns

    guake --hide
    terminator & 
    sleep 0.5

    NEW_TERMINATOR_WINDOW=$(xdotool search --class terminator | tail -n 1)
    xdotool windowactivate "$NEW_TERMINATOR_WINDOW"
    sleep 0.5
    xdotool keydown Super
    xdotool key Up
    xdotool keyup Super
    sleep 1.5
    xdotool type "python3 $working_directory/miscs/sublist3r.py -d $user_input_dns"
    xdotool key Return
}

dns_enum
