for FILE in *.rar *.zip *.7z; do
  if [ -e "${FILE}" ] && [ ! -d /mnt/c/Users/byteframe/Desktop/________/3dmodelorg/finished/"${FILE%.*}" ]; then
    DIR=$(echo "${FILE// /_}" | tr '[:upper:]' '[:lower:]' | sed -e "s/.rar//" -e "s/.zip//" -e "s/.7z//" -e "s/-/_/g" -e "s/[(]//g" -e "s/[)]//g")
    mkdir -p "${DIR}"
    cd "${DIR}"
    if [[ ../"${FILE}" == *.7z ]]; then
      7z x ../"${FILE}"
    elif [[ ../"${FILE}" == *.rar ]]; then
      unrar x ../"${FILE}"
    else
      unzip ../"${FILE}"
    fi
    if [ $(ls -1 | wc -l) == 1 ]; then
      DIR2=$(ls -1)
      mv "${DIR2}/"* .
      rmdir -v "${DIR2}"
    fi
    if [ $(ls -1 *.fbx | wc -l) == 1 ]; then
      mv *.fbx ${DIR}.fbx
      for FBX in $(find . -name "*.fbx"); do
        mv "${FBX}" "${DIR}".fbx
      done
    fi
    for JPEG in $(find . -name "*.jpeg"); do
      mv -v "${JPEG}" "${JPEG/jpeg/jpg}"
    done
    cd ..
  fi
done