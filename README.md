# SPDX-License-Identifier: GPL-2.0-or-later

# Dio-Dev-Tools
A set of scripts to automate the development (building and testing) of C programs.
These tools are designed for use in a Wayland session only. I mostly use only
built-in standard GNU/Linux tools with the help of which i turn a simple text editor
(in theis case mousepad) and a simple terminal (xfce4-terminal) into a decent IDE that
i use all the time and i develop all my projects using this setup. It provides a convenient
way to launch the IDE, save, compile and run a C project or a standalone C file and all this
with a single keyboard shortcut. Dio-Dev-Tools consists of two scripts: compile-and-run (nama: w)
and dioIDE (name: dioIDE.sh), they are very well annotated, straightforward and self-explanatory.

# With Dio-Dev-Tools you use one single keyboard shortcut to:
   1. Lauch the IDE if it's not running.
   2. Save, compile and run the project.
   3. Automatically detect whether it's a project with a Makefile or a simple C file.

# Requirements
Make sure you have following libs installed:

gcc\
sed\
make\
grep\
bash\
procps (for 'ps')\
[diowtype](https://github.com/DiogenesN/diowtype) (or ydotool)\
ncurses-bin (for 'clear')\
wlrctl (to manage Wayland windows)\
mousepad (as the default text editor)\
xfce4-terminal (as the default terminal)\
coreutils (for 'cut', 'echo', 'tail', 'head', 'sleep', 'whoami' commands)

# Installation/Usage
  1. Open a terminal and run:

    chmod +x ./w
    chmod +x ./dioIDE.sh
    cp w ~/.w

  2. Add your favorite keyboard shortcut to launch the 'dioIDE.sh' script.
  3. The provided 'Makefile' is just an example that contains 'make clean' and 'make run' that are needed for the IDE to work.

  That's all. now you can use the same shortcuts for launching the IDE,
  the same shortcut for savimg, compiling and running the C project.

# Screenshots
 
![Alt text](https://raw.githubusercontent.com/DiogenesN/dio-dev-tools/main/screenshot.png)

# Optional

  If you want to use my custom modified cobalt theme for mousepad,
  then copy 'cobalt.xml' to /usr/share/gtksourceview-4/styles/

That's it!

# Support

   My Libera IRC support channel: #linuxfriends

   Matrix: https://matrix.to/#/#linuxfriends2:matrix.org

   Email: nicolas.dio@protonmail.com

   My repository for BASH programming: https://github.com/DiogenesVX
