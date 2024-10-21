stabilize_shell() {
    guake --hide
    sleep 0.1
    xdotool key Control+u
    sleep 0.2   
    xdotool type "/usr/bin/python$1 -c 'import pty; pty.spawn(\"/bin/bash\")'"
    xdotool key Return
    sleep 1
    xdotool key Control+z
    sleep 0.3
    xdotool type "stty raw -echo"  # Set terminal to raw mode without echo
    xdotool key Return
    sleep 0.3
    xdotool type "fg"  # Bring the background job to the foreground
    xdotool key Return
    
    xdotool type "export TERM=xterm-256color"  # Use xterm-256color for better compatibility
    xdotool key Return
    xdotool type "stty -ixon"  # Disable flow control
    xdotool key Return
    xdotool type "reset"
    xdotool key Return
    xdotool type "echo 'Shell Stabilized'"
    xdotool key Return
    sleep 0.8
    xdotool type "clear"
    xdotool key Return
}
