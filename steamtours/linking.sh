#!/bin/sh

# addons with source content
cd /mnt/d/Source
for ADDON in *; do
  ADDON=$(echo ${ADDON} | sed -e 's:/::')
  echo ---- ${ADDON} ----
  [ ! -d "${C}"/${ADDON} ] && echo 'mklink /j "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\content\steamtours_addons\'${ADDON}'"' 'D:\Source\'${ADDON}
  [ ! -e "${G}"/${ADDON} ] && echo 'mkdir "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\steamtours_addons\'${ADDON}'"'
  DRIVE=v
  [ -d /mnt/l/${ADDON} ] && DRIVE=l
  find ${ADDON}/ -mindepth 1 -maxdepth 1 -type d -not -name _cull -not -name sounds | while read DIR; do
    DIR=$(echo ${DIR} | sed -e 's:.*/::')
    [ ! -d /mnt/${DRIVE}/${ADDON}/${DIR} ] && echo 'mkdir "'${DRIVE}':\\'${ADDON}'\'${DIR}
    [ ! -e "${G}"/${ADDON}/${DIR} ] &&
      echo 'mklink /j "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\steamtours_addons\'${ADDON}'\'${DIR}'" "'${DRIVE}':\\'${ADDON}'\'${DIR}
  done
  find /mnt/${DRIVE}/${ADDON}/ -mindepth 1 -maxdepth 1 -type d | while read DIR; do
    DIR=$(echo ${DIR} | sed -e 's:.*/::')
    [ ! -d "${G}"/${ADDON}/${DIR} ] &&
      echo 'mklink /j "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\steamtours_addons\'${ADDON}'\'${DIR}'" "'${DRIVE}':\\'${ADDON}'\'${DIR}
  done
  for FILE in addoninfo.txt demoheader.tmp tools_asset_info.bin tools_thumbnail_cache.bin; do
    if [ -e /mnt/${DRIVE}/${ADDON}/${FILE} ]; then
      [ ! -e /mnt/${DRIVE}/${ADDON}/${FILE} ] &&
        echo 'copy /y nul '${DRIVE}':\'${ADDON}'\'${FILE}' >NUL'
      [ ! -e "${G}"/${ADDON}/${FILE} ] &&
        echo 'mklink '${FILE} ${DRIVE}':\\'${ADDON}'\'${FILE}
    fi
  done
  [ -d ${ADDON}/sounds ] && [ ! -d "${G}"/${ADDON}/sounds ] &&
    echo 'mklink /j "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\steamtours_addons\'${ADDON}'\sounds" "D:\\Source\'${ADDON}'\sounds'
done

# completed workshop submissions
cd /mnt/d/Work/Game/steamtours/
for _ADDON in thelab* byteframe* severance blr8800; do
  ADDON=$(echo ${_ADDON} | sed -e 's:-.*::')
  echo "---- ${_ADDON} _ ${ADDON} ----"
  [ ! -d "${C}"/${ADDON} ] && echo 'mklink /j '${ADDON}' d:\\Work\Game\steamtours\'${_ADDON}'\content'
  [ ! -d "${G}"/${ADDON} ] && echo 'mkdir "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\steamtours_addons\'${ADDON}'"'
  find ${_ADDON}/game -mindepth 1 -maxdepth 1 -type d | while read DIR; do
    DIR=$(echo ${DIR} | sed -e 's:.*/::')
    [ ! -e "${G}"/${ADDON}/${DIR} ] &&
      echo 'mklink /j "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\steamtours_addons\'${ADDON}'\'${DIR}'" d:\\Work\Game\steamtours\'${_ADDON}'\game\'${DIR}
  done
  find ${_ADDON}/game -mindepth 1 -maxdepth 1 -type f | while read FILE; do
    FILE=$(echo ${FILE} | sed -e 's:.*/::')
    [ ! -e "${G}"/${ADDON}/${FILE} ] &&
      echo 'mklink "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\steamtours_addons\'${ADDON}'\'${FILE}'" d:\\Work\Game\steamtours\'${_ADDON}'\game\'${FILE}
  done
done
if [ ! -d "${G}"/byteframe13_maps ]; then
  echo 'mkdir "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\steamtours_addons\byteframe13_maps\maps"'
fi
for FILE in gamma iota kappa theta zeta; do
  [ ! -e "${G}"/byteframe13_maps/maps/byteframe13_${FILE}.los ] &&
    echo 'mklink "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\steamtours_addons\byteframe13_maps\maps\byteframe13_'${FILE}'.los" D:\Work\Game\steamtours\byteframe13-Xenian_Xenology\game\maps\byteframe13_'${FILE}'.los'
  [ ! -e "${G}"/byteframe13_maps/maps/byteframe13_${FILE}.vpk ] &&
    echo 'mklink "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\steamtours_addons\byteframe13_maps\maps\byteframe13_'${FILE}'.vpk" D:\Work\Game\steamtours\byteframe13-Xenian_Xenology\game\maps\byteframe13_'${FILE}'.vpk'
done

# workshop extractions/other
cd /mnt/v
find . -mindepth 1 -maxdepth 1 -type d -not -name "System Volume Information" -not -name "\$RECYCLE.BIN" | while read ADDON; do
  ADDON=${ADDON:2}
  if [ ! -d /mnt/d/Source/${ADDON} ]; then
    echo "---- ${ADDON} ----"
    [ ! -d "${G}"/${ADDON} ] &&
      echo 'mkdir "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\steamtours_addons\'${ADDON}'"'
    find ${ADDON}/ -mindepth 1 -maxdepth 1 -type d | while read DIR; do
      DIR=$(echo ${DIR} | sed -e 's:.*/::')
      [ ! -e "${G}"/${ADDON}/${DIR} ] &&
        echo 'mklink /j "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\steamtours_addons\'${ADDON}'\'${DIR}'" d:\\Work\Game\steamtours\'${ADDON}'\game\'${DIR}
    done
    find ${ADDON} -mindepth 1 -maxdepth 1 -type f | while read FILE; do
      FILE=$(echo ${FILE} | sed -e 's:.*/::')
      [ ! -e "${G}"/${ADDON}/${FILE} ] &&
        echo 'mklink "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\steamtours_addons\'${ADDON}'\'${FILE}'" d:\\Work\Game\steamtours\'${ADDON}'\game\'${FILE}
    done
  fi
done