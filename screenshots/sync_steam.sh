cd /mnt/c/Program\ Files\ \(x86\)/Steam/userdata/752001/760/remote
for DIR in *; do
  find ${DIR}/screenshots -type f -not -path "*thumbnails*" -not -name "*_vr.jpg" | while read FILE; do
    if [ ! -e /mnt/d/Image/Steam/"${FILE}" ]; then
      mkdir -p /mnt/d/Image/Steam/${DIR}/screenshots
      JPG=${FILE/*\/}
      if [[ ${JPG} =~ 20[1-2][0-9]*_[0-9].jpg ]]; then
        DATE="${JPG:0:4}:${JPG:4:2}:${JPG:6:2} ${JPG:8:2}:${JPG:10:2}:${JPG:12:2}"
      elif [[ ${JPG} =~ [0-9]*_.*_.*.jpg ]]; then
        DATE=($(echo "${JPG}" | tr '_' '\n'))
        DATE=$(date -d @${DATE[2]} '+%Y:%m:%d %H:%M:%S')
      else
        DATE=$(date -r "${FILE}" '+%Y:%m:%d %H:%M:%S')
      fi
      cp -v "${FILE}" /mnt/d/Image/Steam/"${FILE}"
      exiv2 -k -M"set Exif.Photo.DateTimeOriginal ${DATE}" /mnt/d/Image/Steam/"${FILE}"
    fi
  done
done