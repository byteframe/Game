# jQuery('.workshopItem a').toArray().map((e) => e.href.substr(55)).join(' ')

USER="USER"
STEAMCMD=/mnt/l/steamcmd
DOWNLOAD_STRING=""
for ID in $@; do
  if [ ! -d "${STEAMCMD}"/steamapps/workshop/content/431960/${ID} ]; then
    DOWNLOAD_STRING="${DOWNLOAD_STRING}\nworkshop_download_item 431960 ${ID}"
  fi
done
if [ ! -z "${DOWNLOAD_STRING}" ]; then
  echo "login ${USER}" > "${STEAMCMD}"/repkg.txt
  echo -e ${DOWNLOAD_STRING} >> "${STEAMCMD}"/repkg.txt
  echo quit >> "${STEAMCMD}"/repkg.txt
  "${STEAMCMD}"/steamcmd.exe +runscript repkg.txt
fi
cd "${STEAMCMD}"/steamapps/workshop/content/431960/
for DIR in *; do
  FILES=(${DIR}/*.mp4)
  if [ -d ${DIR} ] && [ ! -f "${FILES[0]}" ] && [ -f ${DIR}/scene.pkg ]; then
    /mnt/c/Users/byteframe/Downloads/RePKG.exe extract    -o "l:\\steamcmd\steamapps\workshop\content\431960\\${DIR}" "l:\\steamcmd\steamapps\workshop\content\431960\\${DIR}\scene.pkg"
    /mnt/c/Users/byteframe/Downloads/RePKG.exe extract -t -o "l:\\steamcmd\steamapps\workshop\content\431960\\${DIR}" "l:\\steamcmd\steamapps\workshop\content\431960\\${DIR}\materials"
  fi
  rm -rf ${DIR}/preview.jpg ${DIR}/*json ${DIR}/*.pkg ${DIR}/models ${DIR}/particles ${DIR}/sounds ${DIR}/materials
done