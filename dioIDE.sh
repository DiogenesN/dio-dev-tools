#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later

# dioIDE
# This script is designed for use in a Wayland session only.
# It provides a convenient way to launch the IDE, save, compile, 
# and run a C program, all with a single keyboard shortcut.
# 
# Usage:
# - If Mousepad (the IDE in this context) is running, the script 
#   will automatically save the file, compile, and run it.
# - If Mousepad is not running, it launches both Mousepad and a 
#   terminal window (xfce4-terminal) for compilation.
#
# Requirements:
#  - sed
#  - make
#  - grep
#  - bash
#  - procps (for 'ps')
#  - diowtype (or ydotool)
#  - ncurses-bin (for 'clear')
#  - wlrctl (to manage Wayland windows)
#  - mousepad (as the default text editor)
#  - coreutils (for 'cut', 'echo', 'tail', 'head', 'sleep', 'whoami' commands)
#
# Dependencies:
# - This script assumes the existence of diowtype (or ydotool) for simulating keyboard input,
#   and wlrctl for managing Wayland windows.
# - Mousepad is the default text editor used here, but can be replaced with another editor.
# - xfce4-terminal is used as the terminal for running commands.

TEXT_EDITOR=mousepad   # Define the default text editor (Mousepad)
TERMINAL=xfce4-terminal # Define the terminal application (XFCE4 terminal)

# The following block checks if a Mousepad window is currently open by listing all windows
# and searching for any instance of Mousepad using 'wlrctl window list' and 'grep'.
# It extracts the directory path of the file being edited in Mousepad
# and stores it in /tmp/.cfilepath
wlrctl window list | \
	# Filter the window list to find the one corresponding to Mousepad
    grep $TEXT_EDITOR | \
    # Cut the window list output starting from the 12th character (file path)
    cut -c 12- | \
    # Remove the file name from the path, keeping only the directory
    sed 's![^/]*$!!' | \
    # Prepend the home directory of the current user
    sed "s/./\/home\/`whoami`\//" > /tmp/.cfilepath

# Check if Mousepad is already running by using 'ps aux' and 'grep'.
# This will look for the Mousepad process. If it is running, proceed to the next step.
if [[ $(ps aux | grep [m]ousepad) ]]; then
    sleep 0.3  # Sleep to allow smooth transitions between actions

    # Save the current file in Mousepad by simulating Ctrl+S (save) key press using wlrctl.
    wlrctl keyboard type "s" modifiers CTRL
    sleep 0.3

    # Simulate another Ctrl+S in case the save action didn't register correctly.
    wlrctl keyboard type "s" modifiers CTRL
    sleep 0.3

    # Focus on the terminal window (titled "TerminalIDE") to prepare for running the compiled binary.
    wlrctl window focus title:TerminalIDE
    sleep 0.3

    # Change to the directory where the source file is located (read from /tmp/.cfilepath),
    # and execute the script ~/.w to compile and run the program.
    wlrctl keyboard type "cd \$(cat /tmp/.cfilepath) && ~/.w"
    sleep 0.3

    # Simulate the 'Enter' key press to execute the command in the terminal.
    # diowtype or ydotool are used here for simulating key presses, sending the Enter key.
    diowtype 28  # Keycode 28 corresponds to the Enter key.
    #ydotool key 28:1 28:0 (corresponds to Enter key press and can be used instead of diowtype)

    # After 1 second, return focus to the Mousepad window so the user can continue editing.
    (sleep 1; wlrctl window focus $TEXT_EDITOR)&

else
    # If Mousepad isn't already running, open Mousepad and a terminal window.
    echo "Mousepad is not opened, opening Mousepad"

    # Launch Mousepad in the background.
    $TEXT_EDITOR &

    # Launch XFCE terminal (titled "TerminalIDE") in the background.
    # It opens with certain configurations: no borders, menu bar, scroll bar,
    # and a specified size/position.
    $TERMINAL \
    --title="TerminalIDE" \
    --hide-borders \
    --hide-menubar \
    --hide-scrollbar \
    --geometry=105x10-0+900 &
fi

exit 0  # Exit the script (redundant but ensures proper script termination)
