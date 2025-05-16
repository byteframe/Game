cd /mnt/d/Source
for DIR in source1import_*; do
  for FILE in $(find ${DIR}/materials -mindepth 2 -name "*.vmat"); do
    if grep "//" "${FILE}" ; then
      echo ${FILE}
    fi
  done
done

exit 0

for FILE in $(cat /mnt/c/Users/byteframe/Desktop/cp.txt); do cp Source/"${FILE}" /mnt/t/Source/"${FILE}"; done
for DIR in Source/source1import_*; do
  cp ${DIR}/materials/*.* /mnt/t/${DIR}/materials
done
for DIR in ambientcg freepbr baddragon brazzers hhp227 holodexx veiviev; do
  rsync --delete --size-only -truv Source/${DIR}/ /mnt/t/Source/${DIR}
done

N=n
SRC=/mnt/v
DST=/mnt/x
cd "${SRC}"
for DIR in $(find -maxdepth 1 -type d -not -name "System Volume Information" -not -name "___MISC" -not -name "\$RECYCLE.BIN" -not -name "." | sed "s|^\./||"); do
  echo -e "\n---- ${DIR} ----\n"
  rsync --delete --size-only -lruv${N} ${SRC}/"${DIR}"/ ${DST}/"${DIR}"
done