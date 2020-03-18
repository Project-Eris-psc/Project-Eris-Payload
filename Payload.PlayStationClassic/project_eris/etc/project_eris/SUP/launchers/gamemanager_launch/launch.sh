#!/bin/sh

source "/var/volatile/project_eris.cfg"

echo 2 > "/data/power/disable"

cd "/var/volatile/launchtmp"
echo "launch_stockui" > "/tmp/launchfilecommand"
chmod +x "game_manager"
./game_manager --database-folder "${PROJECT_ERIS_PATH}/etc/project_eris/SYS/databases" --theme-folder "${THEMES_PATH}/${SELECTED_THEME}/menu_files" \
               --texture-folder "${THEMES_PATH}/stock/menu_files" &> "${RUNTIME_LOG_PATH}/game_manager.log"
