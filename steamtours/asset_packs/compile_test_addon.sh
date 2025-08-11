if [ -z "${C}" ]; then
  echo "missing environmental variables"
  exit 0
fi
cd "${C}"
ADDON=zzz_test
[ ! -z "${1}" ] && ADDON=${1}

"${W}"/no_vtf-5.1.1/no_vtf.exe --ldr-format "tiff|tiff" --hdr-format pfm ${ADDON}/materials/
touch "${ADDON}"/gameinfo.txt

TYPE=materials
python "${W}"/source1import-0.3.12/utils/${TYPE}_import.py -i "${C}"/${ADDON} -e "${C}"/${ADDON}
"${G}"/../bin/win64/resourcecompiler.exe -nominidumps -r -i "C:/Program Files (x86)/Steam/steamapps/common/SteamVR/tools/steamvr_environments/content/steamtours_addons/${ADDON}/${TYPE}/*"

TYPE=models
python "${W}"/source1import-0.3.12/utils/${TYPE}_import.py -i "${C}"/${ADDON} -e "${C}"/${ADDON}
"${G}"/../bin/win64/resourcecompiler.exe -nominidumps -r -i "C:/Program Files (x86)/Steam/steamapps/common/SteamVR/tools/steamvr_environments/content/steamtours_addons/${ADDON}/${TYPE}/*"

TYPE=particles
python "${W}"/source1import-0.3.12/utils/${TYPE}_import.py -i "${C}"/${ADDON} -e "${C}"/${ADDON}
"${G}"/../bin/win64/resourcecompiler.exe -nominidumps -r -i "C:/Program Files (x86)/Steam/steamapps/common/SteamVR/tools/steamvr_environments/content/steamtours_addons/${ADDON}/${TYPE}/*"
