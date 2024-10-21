#!/bin/bash

# Set the working directory to the correct parent directory
working_directory="$(cd "$(dirname "$0")/.." && pwd)"

gobuster_enum() {
    read -p "Enter the target domain: " url

    read -p "Enter the wordlist path (press Enter for default 'websearch'): " wordlist_path
    if [[ -z "$wordlist_path" ]]; then
        wordlist_path="$working_directory/miscs/websearch"
    fi

    echo "Using wordlist path: $wordlist_path"  # Debug statement

    if [[ ! -f "$wordlist_path" ]]; then
        echo "The specified wordlist file does not exist. Please enter a valid path."
        exit 1
    fi

    guake --hide
    terminator &
    sleep 2

    NEW_TERMINATOR_WINDOW=$(xdotool search --class terminator | tail -n 1)
    xdotool windowactivate "$NEW_TERMINATOR_WINDOW"
    sleep 0.3
    xdotool keydown Super
    xdotool key Up
    xdotool keyup Super

    xdotool type "gobuster dir -u $url -w $wordlist_path"
    xdotool key Return
    sleep 1

    xdotool keydown Alt
    xdotool key h
    xdotool keyup Alt
    sleep 0.5

    xdotool windowactivate "$NEW_TERMINATOR_WINDOW"
    sleep 0.3

    xdotool type "ffuf -u $url/FUZZ -w $wordlist_path"
    xdotool key Return
    sleep 1

    xdotool keydown Alt
    xdotool key v
    xdotool keyup Alt
    sleep 0.5

    xdotool windowactivate "$NEW_TERMINATOR_WINDOW"
    sleep 0.3

    xdotool type "dirsearch -u $url"
    xdotool key Return
}

gobuster_enum
