#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later

# compile-and-run
# This script is desiged for use in a Wayland session only and it
# compiles and runs a C program, depending on whether
# it's part of a project with a Makefile or a standalone C file.
#
#--------- IMPORTANT!
# In order for it to work, you need to structure your project like this:
# > main/ (directory that must contain the 'src' subdirectory and the 'Makefile')
# 	> src/ ('src' directory must contait your 'main.c' file and all the header files)
#      - main.c
#      - example_header.c
#      - example_header.h
#   > Makefile ('Makefile' must be in the 'main' directory and not in 'src' directory)
#
#--------- ALSO:
# You need to make sure your 'Makefile' includes 'make clean' and 'make run'
# make clean should clean all the buid files
# make run should compile and execute the compiled binary
#
# Example of make clean:
# clean:
#	rm -f $(OBJFILES) $(TARGET)
#
# Example of make run:
# .PHONY: run
# run: $(TARGET)
#	sleep 1
#	@./$(TARGET)
#
#--------- RECOMMENDED!
# To name this script with a short name, or simply a letter
# and place it in a directory with the shortest path name,
# this is useful for the execution speed of this script.
# A perfect example would be to name this script '.w' and place it in /home/username/
# If you name it differently or you place it in a different directory,
# then you need to adjust the corresponding lines in dioIDE.sh.
# Don't forget to make it execulable.
#
# Requirements: 
#  - gcc
#  - sed
#  - make
#  - grep
#  - bash
#  - ncurses-bin (for 'clear')
#  - wlrctl (to manage Wayland windows)
#  - mousepad (as the default text editor)
#  - coreutils (for 'cut', 'echo', 'tail', 'head', 'whoami' commands)
#
# Intended Usage:
# - This script is launched by the dioIDE.
# - It detects if you are editing a C file in the mousepad editor,
#   checks if the file is part of a larger project (Makefile),
#   and compiles and runs the program accordingly.
# - If a Makefile is present, it uses `make`. If not, it compiles 
#   the C file directly using `gcc` with several optimization flags.

clear  # Clear the terminal screen for cleaner output

set -e  # Exit immediately if any command returns a non-zero status (fail fast)

# Variables
MAKEFILE_PATH=""  # Will hold the directory of the Makefile, if found
TEXT_EDITOR=mousepad  # Name of the text editor where the code is being edited
GET_WINDOWLIST="wlrctl window list"  # Command to list all Wayland windows (using wlrctl)

# Extract the directory path from the open file in the mousepad editor window.
# This determines if we are in a project folder (Makefile) or just working on a simple C file.
# The logic extracts the file path from mousepad, formats it, and checks the location.
MAKEFILE_PATH=$($GET_WINDOWLIST | \
				grep $TEXT_EDITOR | \
				# Extracts the file path starting from the 29th character
				cut -c 29- | \
				# Removes the file name to get the directory path
				sed 's![^/]*$!!' | \
				# Prepend the home directory of the current user
				sed "s/./\/home\/`whoami`\//" | \
				# Enclose the directory in quotes
				sed '1s/^/"/;$s/$/"/')

# Check if we are in a project directory by checking if the path contains 'src'
# If the last 6 characters of the path include 'src', assume it's a project folder with a Makefile
if [ "$(echo $MAKEFILE_PATH | tail -c 6 | head -c 3)" = "src" ]; then
	clear  # Clear the terminal again for fresh output
	cd .. && make clean  # Move one directory up, clean previous builds
	make run  # Build the project using the Makefile and run the result
	exit 0  # Exit the script
else
	# If not in a project folder (no Makefile), treat the open file as a standalone C file
	# Extract the name of the file from title, then remove its extension to get the executable name
	nameOfExecutable=$($GET_WINDOWLIST | \
					   grep $TEXT_EDITOR | \
					   # Extracts the file name
					   sed 's:.*/::' | \
					   # Removes the last 11 chars (in our case it removes '- Mousepad' from title)
					   sed 's/...........$//')

	# Compile the standalone C file using gcc, with optimizations and relevant flags
	# Output binary in /tmp directory
	gcc \
		$nameOfExecutable \
		-O3 \
		-lm \
		-Wall \
		-flto \
		-Wextra \
		-Wpedantic \
		-march=native \
		-funroll-loops \
		-export-dynamic \
		-fomit-frame-pointer \
		-o /tmp/test_binary
# Here you can also include some external libraries like this:
#	gcc \
#		$nameOfExecutable \
#		-O3 \
#		-lm \
#		-Wall \
#		-flto \
#		-Wextra \
#		-Wpedantic \
#		-march=native \
#		-funroll-loops \
#		-export-dynamic \
#		-fomit-frame-pointer \
#		-o /tmp/test_binary \
#	$(pkg-config --libs \
#		gl \
#		glew \
#		glfw3 \
#		wlroots \
#		xkbcommon \
#		cairo-svg \
#		wayland-cursor \
#		wayland-server) \
#	$(pkg-config --cflags \
#		gl \
#		glew \
#		glfw3 \
#		wlroots \
#		xkbcommon \
#		cairo-svg \
#		wayland-cursor \
#		wayland-server)

	# Run the compiled binary
	/tmp/test_binary
	exit 0  # Exit the script
fi

exit 0  # Final exit (redundant, but ensures clean script termination)
