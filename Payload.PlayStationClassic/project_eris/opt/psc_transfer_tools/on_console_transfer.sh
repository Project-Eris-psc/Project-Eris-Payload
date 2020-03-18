#!/bin/sh
#
#  Copyright 2020 ModMyClassic (https://modmyclassic.com/license)
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
###############################################################################
# PlayStation Classic On-Console Transfer Tool Launch Script
# ModMyClassic.com / https://discordapp.com/invite/8gygsrw
###############################################################################

source "/var/volatile/project_eris.cfg"
source "${PROJECT_ERIS_PATH}/etc/project_eris/FUNC/0000_shared.funcs"

[ ! -d "${MOUNTPOINT}/games/" ] && mkdir -p "${MOUNTPOINT}/games/"
[ ! -d "${MOUNTPOINT}/transfer/" ] && mkdir -p "${MOUNTPOINT}/transfer/"
chmod +x "${PROJECT_ERIS_PATH}/opt/psc_transfer_tools/psc_game_add"
cd "${PROJECT_ERIS_PATH}/opt/psc_transfer_tools"
sdl_text "Scanning transfer directory for games..."
"${PROJECT_ERIS_PATH}/opt/psc_transfer_tools/psc_game_add" "${MOUNTPOINT}/transfer/" "${PROJECT_ERIS_PATH}/etc/project_eris/SYS/databases/" "${MOUNTPOINT}/games/" &> "${RUNTIME_LOG_PATH}/transfer.log"
if [ ! $? -eq 0 ]; then
  sdl_text "Failed to transfer games! Check transfer.log"
  wait 1
fi