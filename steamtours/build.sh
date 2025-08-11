#!/bin/sh

if [ -z "${C}" ]; then
  echo "missing environmental variables"
  exit 0
fi
ADDON=byteframe13
[ ! -z ${1} ] && ADDON=${1}
QUALITY=2
[ ! -z ${2} ] && QUALITY=${2}
RESOLUTION=8192
[ ! -z ${3} ] && RESOLUTION=${3}
MAP=${ADDON}
[ ! -z ${4} ] && MAP=${4}
cd "${C}"/${ADDON}/maps
RC_INIT="-fshallow -maxtextureres 256 -dxlevel 110 -v -unbufferedio -noassert"
RC_VRAD="-bakelighting -lightmapMaxResolution ${RESOLUTION} -vrad3 -lightmapDoWeld -lightmapVRadQuality ${QUALITY} -lightmapLocalCompile -lightmapCompressionDisabled 0"
RC_EXIT="-phys -retail -vis -breakpad -nompi -nohtml -nop4 -outroot C:\Users\BYTEFR~1\AppData\Local\Temp\valve\hammermapbuild\game"
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
fi
if [ ! -e "${G}"/${ADDON}/maps/${MAP}.vpk ]; then
  "${G}"/../bin/win64/resourcecompiler.exe ${RC_INIT} \
    -i "c:/program files (x86)/steam/steamapps/common/steamvr/tools/steamvr_environments/content/steamtours_addons/${ADDON}/maps/${MAP}.vmap" \
    -world ${RC_VRAD} ${RC_EXIT} | tee "${G}"/${ADDON}/maps/${MAP}.txt
fi
mv -v /mnt/c/Users/byteframe/AppData/Local/Temp/Valve/hammermapbuild/game/steamtours_addons/${ADDON}/maps/*.vpk "${G}"/${ADDON}/maps 
for FILE in "${G}"/${ADDON}/maps/*.txt; do
  sed -i 's/\r$//' "${FILE}"
done
find /mnt/c/Users/byteframe/AppData/Local/Temp/valve -type d -empty -delete