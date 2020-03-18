#!/bin/sh
source "/var/volatile/project_eris.cfg"
rm -f "${RUNTIME_LOG_PATH}/retroarch.log"
chmod +x "${PROJECT_ERIS_PATH}/bin/ra_watch"
chmod +x "${RETROARCH_PATH}/retroarch"
touch "/tmp/launch_ra.flag"
export XDG_CONFIG_HOME="${RETROARCH_PATH}/config"
while [ -f "/tmp/launch_ra.flag" ]; do
  rm -f "/tmp/launch_ra.flag"
  PATH="${PATH}:${PROJECT_ERIS_PATH}/bin" "${RETROARCH_PATH}/retroarch" --config "${RETROARCH_PATH}/config/retroarch/retroarch.cfg" "$@" 2>&1 | "${PROJECT_ERIS_PATH}/bin/ra_watch" >> "${RUNTIME_LOG_PATH}/retroarch.log"
done
