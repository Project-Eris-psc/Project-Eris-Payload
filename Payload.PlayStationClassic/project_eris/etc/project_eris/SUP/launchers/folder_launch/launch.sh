#!/bin/sh

source "/var/volatile/project_eris.cfg"
TEXT_X=640
TEXT_Y=120
TEXT_SIZE=16
TEXT_FONT="/usr/share/fonts/ttf/LiberationMono-Regular.ttf"
TEXT_BG="0x7E000000"
if [ -f "${THEMES_PATH}/${SELECTED_THEME}/menu_files/Boot/splashscreen.png" ]; then
  BACKGROUND="${THEMES_PATH}/${SELECTED_THEME}/menu_files/Boot/splashscreen.png"
else
  BACKGROUND="${PROJECT_ERIS_PATH}/etc/project_eris/IMG/splashscreen.png"
fi

launch_fm()
{
  echo 2 > "/data/power/disable"

  # Create a database backup before opening
  [ ! -d "${PROJECT_ERIS_PATH}/etc/project_eris/SYS/databases-backup" ] && cp -r "${PROJECT_ERIS_PATH}/etc/project_eris/SYS/databases" "${PROJECT_ERIS_PATH}/etc/project_eris/SYS/databases-backup"
  # Copy internal game database
  [ ! -f "${PROJECT_ERIS_PATH}/etc/project_eris/SYS/databases/stockRegional.db" ] && cp "/gaadata/databases/regional.db" "${PROJECT_ERIS_PATH}/etc/project_eris/SYS/databases/stockRegional.db"

  cd "/var/volatile/launchtmp"
  echo "launch_stockui" > "/tmp/launchfilecommand"
  chmod +x "folder_menu"
  ./folder_menu --database-folder "${PROJECT_ERIS_PATH}/etc/project_eris/SYS/databases" --theme-folder "${THEMES_PATH}/${SELECTED_THEME}/menu_files" \
                --texture-folder "${THEMES_PATH}/stock/menu_files" &> "${RUNTIME_LOG_PATH}/folder_manager.log"
}

clean_folders()
{
  if [ ! -z "${FOLDERSID}" ]; then
    rm -rf "${PROJECT_ERIS_PATH}/etc/project_eris/SUP/launchers/pefolder"*
  else
    # Something is wrong. Lets jump ship now!
    killall sdl_display
    exit 1
  fi
}

create_folders()
{
  for x in "${FOLDERSID[@]}"; do
    FOLDERDATA=$("${PROJECT_ERIS_PATH}/bin/sqlite3" "${PROJECT_ERIS_PATH}/etc/project_eris/SYS/databases/regional.db" -cmd "SELECT * FROM FOLDER_ENTRIES WHERE FOLDER_ID = ${x} ORDER BY FOLDER_ID" ".quit")
    IFS='|' read -r -a ONEDATA <<< "${FOLDERDATA}"
    DIRECTORYNAME="${PROJECT_ERIS_PATH}/etc/project_eris/SUP/launchers/pefolder${ONEDATA[0]}"
    if [ ! -d "${DIRECTORYNAME}" ]; then
      mkdir -p "${DIRECTORYNAME}"
    fi
    echo "launcher_filename=\"folder\"" > "${DIRECTORYNAME}/launcher.cfg"
    echo "launcher_title=\"${ONEDATA[1]}\"" >> "${DIRECTORYNAME}/launcher.cfg"
    echo "launcher_publisher=\"Folder\"" >> "${DIRECTORYNAME}/launcher.cfg"
    echo "launcher_year=\"2020\"" >> "${DIRECTORYNAME}/launcher.cfg"
    echo "launcher_sort=\"no\"" >> "${DIRECTORYNAME}/launcher.cfg"
    echo "#!/bin/sh" > "${DIRECTORYNAME}/launch.sh"
    echo "echo 2 > /data/power/disable" >> "${DIRECTORYNAME}/launch.sh"
    echo "source \"/var/volatile/project_eris.cfg\"" >> "${DIRECTORYNAME}/launch.sh"
    echo "echo ${ONEDATA[0]} > \"${PROJECT_ERIS_PATH}/etc/project_eris/CFG/selected_folder\"" >> "${DIRECTORYNAME}/launch.sh"
    echo "cd \"/var/volatile/launchtmp\"" >> "${DIRECTORYNAME}/launch.sh"
    echo "echo \"launch_stockui\" > \"/tmp/launchfilecommand\"" >> "${DIRECTORYNAME}/launch.sh"
    cp -f "${PROJECT_ERIS_PATH}/etc/project_eris/SUP/launchers/folder_launch/${ONEDATA[2]}" "${DIRECTORYNAME}/folder.png"

    echo "[PROJECT ERIS](FOLDERS)  ==== Created carousel folder: ${ONEDATA[1]}" >> "${RUNTIME_LOG_PATH}/folder_manager.log" 
    echo "[PROJECT ERIS](FOLDERS)  Folder ID: ${ONEDATA[0]}" >> "${RUNTIME_LOG_PATH}/folder_manager.log" 
    echo "[PROJECT ERIS](FOLDERS)  Folder ART: ${ONEDATA[2]}" >> "${RUNTIME_LOG_PATH}/folder_manager.log" 
  done
}

main()
{
  launch_fm
  #${PROJECT_ERIS_PATH}/bin/sdl_text_display "Processing folders. Please wait" "${TEXT_X}" "${TEXT_Y}" "${TEXT_SIZE}" "${TEXT_FONT}" 255 255 255 "${BACKGROUND}" "${TEXT_BG}"
  FOLDERSID=($("${PROJECT_ERIS_PATH}/bin/sqlite3" "${PROJECT_ERIS_PATH}/etc/project_eris/SYS/databases/regional.db" -cmd "SELECT FOLDER_ID FROM FOLDER_ENTRIES ORDER BY FOLDER_ID" ".quit"))
  clean_folders
  create_folders
  killall sdl_display
}

main
