#!/bin/sh

source /mnt/d/Work/Game/steamtours/asset_packs/steamtours_environment.sh
ADDON=byteframe14
[ ! -z ${1} ] && ADDON=${1}
QUALITY=1
[ ! -z ${2} ] && QUALITY=${2}
RESOLUTION=2048
[ ! -z ${3} ] && RESOLUTION=${3}
MAP=${ADDON}
[ ! -z ${4} ] && MAP=${4}
RC_INIT="-fshallow -maxtextureres 256 -dxlevel 110 -v -unbufferedio -noassert"
RC_VRAD="-bakelighting -lightmapMaxResolution ${RESOLUTION} -vrad3 -lightmapDoWeld -lightmapVRadQuality ${QUALITY} -lightmapLocalCompile -lightmapCompressionDisabled 0"
RC_EXIT="-phys -retail -vis -breakpad -nompi -nohtml -nop4 -outroot C:\Users\BYTEFR~1\AppData\Local\Temp\valve\hammermapbuild\game"
cd "${C}"/${ADDON}/maps
if [ ${ADDON} = 'byteframe13' ]; then
  for FILE in ${ADDON}_*.vmap; do
    if [ ! -e "${G}"/${ADDON}/maps/${FILE/vmap/txt} ]; then
      "${G}"/../bin/win64/resourcecompiler.exe ${RC_INIT} \
        -i "c:/program files (x86)/steam/steamapps/common/steamvr/tools/steamvr_environments/content/steamtours_addons/${ADDON}/maps/${FILE}" \
        -world ${RC_VRAD} ${RC_EXIT} | tee "${G}"/${ADDON}/maps/${FILE/vmap/txt}
    fi
  done
  unset RC_VRAD
  sleep 30
elif [ ${ADDON} = 'zzz_test' ]; then
  mkdir -p "${G}"/${ADDON}/maps/prefabs
  for FILE in prefabs/prefab_section_*.vmap; do
    if [ ! -e "${G}"/${ADDON}/maps/${FILE/vmap/txt} ]; then
      "${G}"/../bin/win64/resourcecompiler.exe ${RC_INIT} \
        -i "c:/program files (x86)/steam/steamapps/common/steamvr/tools/steamvr_environments/content/steamtours_addons/${ADDON}/maps/${FILE}" \
        -world ${RC_VRAD} ${RC_EXIT} | tee "${G}"/${ADDON}/maps/${FILE/vmap/txt}
    fi
  done
  unset RC_VRAD
  sleep 30
fi
if [ ! -e "${G}"/${ADDON}/maps/${MAP}.vpk ] && [ -e ${MAP}.vmap ]; then
  "${G}"/../bin/win64/resourcecompiler.exe ${RC_INIT} \
    -i "c:/program files (x86)/steam/steamapps/common/steamvr/tools/steamvr_environments/content/steamtours_addons/${ADDON}/maps/${MAP}.vmap" \
    -world ${RC_VRAD} ${RC_EXIT} | tee "${G}"/${ADDON}/maps/${MAP}.txt
fi
find /mnt/c/Users/byteframe/AppData/Local/Temp/Valve/hammermapbuild/game/steamtours_addons/${ADDON}/maps/ -name "*.vpk" | while read FILE; do
  mv -v "${FILE}" "${G}"/${ADDON}/maps/${FILE/*maps\//}
done
find "${G}"/${ADDON}/maps/ -name "*.txt" -exec sed -i -e 's/\r$//' {} \;
find /mnt/c/Users/byteframe/AppData/Local/Temp/valve -type d -empty -delete