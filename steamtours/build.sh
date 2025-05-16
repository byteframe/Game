#!/bin/sh

if [ -z "${C}" ]; then
  echo "missing environmental variables"
  exit 0
fi
RESOLUTION=8192
QUALITY=1
ADDON=byteframe13
cd "${C}"/${ADDON}/maps
if [ ! -e "${G}"/${ADDON}/maps/${ADDON}.txt ]; then
  "${G}"/../bin/win64/resourcecompiler.exe \
    -fshallow -maxtextureres 256 -dxlevel 110 -v -unbufferedio -noassert \
    -i "c:/program files (x86)/steam/steamapps/common/steamvr/tools/steamvr_environments/content/steamtours_addons/${ADDON}/maps/${ADDON}.vmap" \
    -world -phys -vis -retail -breakpad -nompi -nohtml -nop4 -outroot "C:\Users\BYTEFR~1\AppData\Local\Temp\valve\hammermapbuild\game" | tee "${G}"/byteframe13/maps/${ADDON}.txt
  mv /mnt/c/Users/byteframe/AppData/Local/Temp/Valve/hammermapbuild/game/steamtours_addons/byteframe13/maps/${ADDON}.vpk "${G}"/byteframe13/maps 
fi
for FILE in ${ADDON}_*.vmap; do
  if [ ! -e "${G}"/${ADDON}/maps/${FILE/vmap/txt} ]; then
    "${G}"/../bin/win64/resourcecompiler.exe \
      -fshallow -maxtextureres 256 -dxlevel 110 -v -unbufferedio -noassert \
      -i "c:/program files (x86)/steam/steamapps/common/steamvr/tools/steamvr_environments/content/steamtours_addons/${ADDON}/maps/${FILE}" \
      -world -bakelighting -lightmapMaxResolution ${RESOLUTION} -vrad3 -lightmapDoWeld -lightmapVRadQuality ${QUALITY} -lightmapLocalCompile -lightmapCompressionDisabled 0 \
      -phys -retail -vis -breakpad -nompi -nohtml -nop4 -outroot "C:\Users\BYTEFR~1\AppData\Local\Temp\valve\hammermapbuild\game" | tee "${G}"/byteframe13/maps/${FILE/vmap/txt}
    mv /mnt/c/Users/byteframe/AppData/Local/Temp/Valve/hammermapbuild/game/steamtours_addons/byteframe13/maps/${FILE/vmap/vpk} "${G}"/byteframe13/maps
  fi
done
for FILE in "${G}"/byteframe13/maps/*.txt; do
  sed -i 's/\r$//' "${FILE}"
done