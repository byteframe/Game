#!/bin/sh
source /mnt/d/Work/Game/steamtours/asset_packs/steamtours_environment.sh

clear
for DIR in /mnt/d/Source/*; do
  if ls ${DIR}/soundevents/*.vsndevts > /dev/null 2>&1; then
    cd ${DIR}
    DIR=$(basename ${DIR} | sed -e "s:source1import_::")
    mkdir -p "${C}"/sound_library/soundevents/${DIR}
    cp -R soundevents/* "${C}"/sound_library/soundevents/${DIR}/
    find "${C}"/sound_library/soundevents/${DIR}/ -type f -name "*.vsndevts" -exec sed -i -e "s:src1_3d:destinations.simple_vr:" -e "s:\"sounds:\"sounds/${DIR}:" {} \;
    {
      echo -e '<!-- kv3 encoding:text:version{e21c7f3c-8a33-41c5-9977-a76d3a32aa0d} format:generic:version{7412167c-06e9-4698-aff2-e63eb59037e7} -->'
      echo -e "{"
      echo -e "\tresourceManifest = "
      echo -e "\t["
      echo -e "$(ls -1 soundevents/*.vsndevts | while read FILE; do echo -e "\t\t\"${FILE/soundevents\/soundevents\/${DIR}\/}\","; done)"
      echo -e "\t]"
      echo -e "}"
    } | sed -e "s:\"soundevents/:\"soundevents/${DIR}/:g" > "${C}"/sound_library/soundevents/${DIR}/soundevents_manifest.vrman
    if [ ! -e "${C}"/sound_library/soundevents/soundevents_manifest.vrman ]; then
      {
        echo -e '<!-- kv3 encoding:text:version{e21c7f3c-8a33-41c5-9977-a76d3a32aa0d} format:generic:version{7412167c-06e9-4698-aff2-e63eb59037e7} -->'
        echo -e "{"
        echo -e "\tresourceManifest = "
        echo -e "\t["
        echo -e "\t]"
        echo -e "}"
      } > "${C}"/sound_library/soundevents/soundevents_manifest.vrman
    fi
    if ! grep -q soundevents/${DIR}/soundevents_manifest.vrman "${C}"/sound_library/soundevents/soundevents_manifest.vrman; then
      sed -i -e "s:\]:\t\"soundevents/${DIR}/soundevents_manifest.vrman\",\n\t\]:" "${C}"/sound_library/soundevents/soundevents_manifest.vrman
    fi
  fi
done
cd /mnt/d/Source
echo -e "soundscapes_manifest\n{" > "${C}"/sound_library/scripts/soundscapes_manifest.txt
for ADDON in source1import_*; do
  FILE=${ADDON}/scripts/soundscapes_manifest.txt
  if [ -e ${FILE} ]; then
    mkdir -p "${C}"/sound_library/scripts/${ADDON:14}
    cat ${FILE} | sed 's/\r$//' | grep -o \"file\".* | while read LINE; do
      echo -e "\t${LINE}" | sed -e "s:scripts/:scripts/${ADDON:14}/:" >> "${C}"/sound_library/scripts/soundscapes_manifest.txt
      FILE2=$(echo ${LINE} | awk '{print $2}' | sed -e "s:\"::g")
      mkdir -p "$(dirname "${C}"/sound_library/scripts/${ADDON:14}/${FILE2/scripts/}})"
      echo ${ADDON}/${FILE2}
      sed -e "s:\\\:/:g" -e "s:\"wave\"\s*\":\"wave\"\t\"${ADDON:14}/:" ${ADDON}/${FILE2} > "${C}"/sound_library/scripts/${ADDON:14}/${FILE2/scripts/}
    done
  fi
  echo ${ADDON}
done
echo "}" >> "${C}"/sound_library/scripts/soundscapes_manifest.txt