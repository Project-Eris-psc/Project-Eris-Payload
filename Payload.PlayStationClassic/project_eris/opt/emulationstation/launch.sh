#!/bin/sh

echo "launch_bootmenu" > "/tmp/launchfilecommand"
export HOME="/media/project_eris/opt/emulationstation"
export PATH="${PATH}:${HOME}/bin"
export LD_LIBRARY_PATH="$LD_{LIBRARY_PATH:${HOME}/lib"
chmod +x "${HOME}/emulationstation" "${HOME}/bin/"*
SDL_VIDEODRIVER=wayland "${HOME}/emulationstation" &> "/media/logs/emulationstation.log"