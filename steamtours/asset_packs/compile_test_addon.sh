if [ -z "${C}" ]; then
  echo "missing environmental variables"
  exit 0
fi
cd "${C}"
if [ -z "${1}" ]; then
  A=zzz_test
else
  A=${1}
fi

"${W}"/no_vtf-4.2.0/no_vtf.exe --ldr-format "tiff|tiff" --hdr-format pfm ${A}/materials/
touch "${A}"/gameinfo.txt

TYPE=materials
python "${W}"/source1import-0.3.12/utils/${TYPE}_import.py -i "${C}"/${A} -e "${C}"/${A}
"${G}"/../bin/win64/resourcecompiler.exe -nominidumps -r -i "C:/Program Files (x86)/Steam/steamapps/common/SteamVR/tools/steamvr_environments/content/steamtours_addons/${A}/${TYPE}/*"

TYPE=models
python "${W}"/source1import-0.3.12/utils/${TYPE}_import.py -i "${C}"/${A} -e "${C}"/${A}
"${G}"/../bin/win64/resourcecompiler.exe -nominidumps -r -i "C:/Program Files (x86)/Steam/steamapps/common/SteamVR/tools/steamvr_environments/content/steamtours_addons/${A}/${TYPE}/*"

TYPE=particles
python "${W}"/source1import-0.3.12/utils/${TYPE}_import.py -i "${C}"/${A} -e "${C}"/${A}
"${G}"/../bin/win64/resourcecompiler.exe -nominidumps -r -i "C:/Program Files (x86)/Steam/steamapps/common/SteamVR/tools/steamvr_environments/content/steamtours_addons/${A}/${TYPE}/*"
