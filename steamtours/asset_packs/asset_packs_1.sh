SRC=/mnt/d/Game
WORK=/mnt/d/Work/Game/steamtours/asset_packs
STEAMAPPS=/mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/common
CONTENT="${STEAMAPPS}"/SteamVR/tools/steamvr_environments/content/steamtours_addons
GAME="${STEAMAPPS}"/SteamVR/tools/steamvr_environments/game/steamtours_addons
windows_path()
{
  WINDOWS_PATH=${1/\/mnt\/}
  echo ${WINDOWS_PATH/\//:\\}
}
header()
{
  echo -e "\n\n\n\n--------------------------------------------------------------------------------"
  echo ${1}
  echo "--------------------------------------------------------------------------------"
  sleep 1
}
extract_vpk_contents()
{
  if [ -d "${1/.vpk}" ]; then
    cp -vR "${1/.vpk}" "${CONTENT}"/${DIR}/
  else
    if [ ! -e ~/.local/bin/vpk ] || [[ $(~/.local/bin/vpk -t "${1}") == *"Error:"* ]]; then
      echo "error in: ${1}, must extract manually"
      read PAUSE
    else
      ~/.local/bin/vpk -re "(models|materials|particles)/.*" -x "${CONTENT}"/${DIR} "${1}"
    fi
    if [ -d "${CONTENT}"/${DIR}/${2} ]; then
      cp -r --link "${CONTENT}"/${DIR}/${2}/materials "${CONTENT}"/${DIR}/
      cp -r --link "${CONTENT}"/${DIR}/${2}/models  "${CONTENT}"/${DIR}/
      cp -r --link "${CONTENT}"/${DIR}/${2}/particles  "${CONTENT}"/${DIR}/
      rm -fr "${CONTENT}"/${DIR}/${2}
    fi
  fi
}
rename_background_files()
{
  find ${DIR}/materials/console/ ${DIR}/materials/vgui/chapters/ ${DIR}/materials/vgui/backgrounds/ -type f \
  -name background0* -or -name background_menu.* -or -name loading_screen_background.* -or -name coopcommentary_chapter* -or -name background_menu_widescreen.* -or \
  -name loading.* -or -name intro.* -or -name intro_widescreen.* -or -name startup_loading.* -or \
  -name startup.* -or -name console_background.* -or -name chapter* | while read FILE; do
    if [[ "${FILE}" != *-* ]] && [ ! -d "${FILE}" ]; then
      if [[ "${FILE}" == *.vmt ]]; then
        FILE_SHORT="${FILE/${DIR}\/materials\//}"
        sed -i -e "s:${FILE_SHORT/.vmt/}:${FILE_SHORT/.vmt/}-${1}:g" "${FILE}"
      fi
      mv -v "${FILE}" "${FILE/./-${1}.}"
    fi
  done
}
find_asset_file()
{
  for SEARCH in ${DIR} ${CHECKS}; do
    if [ -e ${SEARCH}/${1} ]; then
      echo ${SEARCH}/${1}
      return
    fi
  done
}
MAKE_ASSET_PACK()
{
  DIR=${1/\//}
  header "${DIR}: RECREATING IN 90 SECONDS..."
  REFLECTANCE_RANGE=${2}
  DOWNLOAD="${3}"
  CHECKS="${4//,/ }"
  if [ "${CHECKS}" == none ]; then
    unset CHECKS
  fi
  ls -l "${CONTENT}"/${DIR}/ 2> /dev/null
  sleep 90
  rm -fr "${GAME}"/${DIR}
  mkdir -p "${GAME}"/${DIR}
  echo "\"AddonInfo\"{\"Dependencies\"{}}" > "${GAME}"/${DIR}/addoninfo.txt
  cd "${CONTENT}"
  rm -fr ${DIR}/*
  rm -fr ${SRC}/CULL_${DIR}
  mkdir -p ${DIR}
  cp -v "${DOWNLOAD}"/gameinfo.txt ${DIR}
  echo "" > ${DIR}/convertedBumpmaps.txt
  cat "${WORK}"/scripts/global_vars.txt | sed -e "s/X/${REFLECTANCE_RANGE}/" > ${DIR}/global_vars.txt
  for VAR in "$@"; do
    if [[ ${VAR} == *.vpk* ]]; then
      readarray -d "+" -t VARS <<< "${VAR}"
      header "${DIR}: EXTRACTING ${DOWNLOAD}"/"${VARS[0]}" | tee -a ${DIR}/${DIR}-0-extract.txt
      extract_vpk_contents "${DOWNLOAD}"/"${VARS[0]}" ${VARS[1]} >> ${DIR}/${DIR}-0-extract.txt 2>&1
      rename_background_files ${VARS[1]} >> ${DIR}/${DIR}-0-extract.txt 2>&1
    fi
  done

  header "${DIR}: PREBUILD FIXES/NEGATIONS, THEN RUN VTFEDIT..."
  mv -v ${DIR}/materials/dons_decals/serviet_*.vmt ${DIR}/materials/dons_decals/serviet_bug.vmt 2> /dev/null
  mv -v ${DIR}/materials/dons_decals/serviet_*.vtf ${DIR}/materials/dons_decals/serviet_bug.vtf 2> /dev/null
  rm -v ${DIR}/materials/nightvision.vmt 2> /dev/null
  sed -i -e "/reflectivity/d" ${DIR}/materials/esther/blends/b_sand_2_sanddune_001_trash.vmt 2> /dev/null
  sed -i -e "/decalscale/d" ${DIR}/materials/decals/verboten.vmt 2> /dev/null
  if [ ${DIR} == asset_pack_bms ]; then
    sed -i -e "/\/\//d" ${DIR}/materials/models/xenians/houndeye/houndeye.vmt 2> /dev/null
  elif [ ${DIR} == asset_pack_mm ]; then
    sed -i -e "/\/\//d" ${DIR}/materials/nature/water_l04.vmt 2> /dev/null
    sed -i -e "/\/\//d" ${DIR}/materials/nature/water_l05_a.vmt 2> /dev/null
    sed -i -e "/\/\//d" ${DIR}/materials/nature/water_l05_b.vmt 2> /dev/null
    sed -i -e "/\/\//d" ${DIR}/materials/nature/water_l05_b_regen.vmt 2> /dev/null
    sed -i -e "/\/\//d" ${DIR}/materials/nature/water_l06_c.vmt 2> /dev/null
  elif [ ${DIR} == asset_pack_dab ]; then
    mv ${DIR}/materials/models/stormy/da_floorlight_01_nor.vmt ${DIR}/materials/models/stormy/da_floorlight_01_nor.vmt.neg
    sed -i -e "/\/\//d" ${DIR}/materials/models/shells/12gauge/shell_12gauge.vmt 2> /dev/null
    sed -i -e "/\/\//d" ${DIR}/materials/models/weapons/v_models/mossberg590/diffuse.vmt 2> /dev/null
    sed -i -e "/\/\//d" ${DIR}/materials/models/weapons/v_models/mossberg590/mossberg590.vmt 2> /dev/null
    sed -i -e "/\/\//d" ${DIR}/materials/models/weapons/v_models/mossberg590/shotgun_shell.vmt 2> /dev/null
  elif [ ${DIR} == asset_pack_pm ]; then
    find ${DIR}/materials -name *.vmt -exec sed -i -e "/\[\$[xX]360\]/d" -e "s/\s*\[\$WIN32\]//" {} \;
  fi
  read PAUSE

  header "${DIR}: FIXING FILE WHITESPACE"
  {
    find ${DIR}/ -name "*\ *" -type d | while read FILE; do
      mv -v "${FILE}" "${FILE// /_}"
    done
    find ${DIR}/ -name "*\ *" | while read FILE; do
      mv -v "${FILE}" "${FILE// /_}"
    done
  } >> ${DIR}/${DIR}-1-whitespace.txt 2>&1

  header "${DIR}: RUNNING CONVERSION SCRIPTS"
  python "${WORK}"/scripts/mdl_to_vmdl.py ${DIR} >> ${DIR}/${DIR}-2-models.txt 2>&1
  if grep -q Traceback ${DIR}/${DIR}-2-models.txt; then
    echo "${DIR}: FAILURE IN MODELS SCRIPT, EXECUTION HALTED"
    return 1
  fi
  python "${WORK}"/scripts/vmt_to_vmat.py "${CONTENT}"/${DIR} >> ${DIR}/${DIR}-3-materials.txt 2>&1
  if grep -q Traceback ${DIR}/${DIR}-3-materials.txt; then
    echo "${DIR}: FAILURE IN MATERIAL SCRIPT, EXECUTION HALTED"
    return 1
  fi
  if [ -d ${DIR}/particles ]; then
    python /mnt/c/Users/byteframe/Downloads/source1import-steamvr/utils/particles_import.py -i "${CONTENT}"/${DIR} -e "${CONTENT}"/${DIR} >> ${DIR}/${DIR}-4-particles.txt 2>&1
  fi
  if grep -q Traceback ${DIR}/${DIR}-4-particles.txt; then
    echo "${DIR}: FAILURE IN PARTICLE SCRIPT"
  fi

  header "${DIR}: CULLING AGAINST ${CHECKS}"
  {
    mkdir -p  "${SRC}"/CULL_${DIR}/
    COUNT=0
    for CHECK in ${CHECKS}; do
      COUNT=$((COUNT+1))
      find ${DIR}/ -type f | while read LINE; do 
        LINE=${LINE#*/}
        if [ -e ${CHECK}/"${LINE}" ] && [[ "${LINE}" != *".txt" ]]; then
          if [ ! -z ${CULLING} ]; then
            mkdir -p "${SRC}"/"CULL_${DIR}/$(dirname ${COUNT}-${CHECK}/"${LINE}")"
            mv -v ${DIR}/"${LINE}" "${SRC}"/"CULL_${DIR}/$(dirname ${COUNT}-${CHECK}/"${LINE}")"
          else
            echo "could have culled: ${CHECK} -- ${LINE}"
          fi
        fi
      done
    done
  } >> ${DIR}/${DIR}-5-cull.txt 2>&1
	
  header "${DIR}: CHECKING MATERIAL FILES"
  {
    find ${DIR/\//}/materials -name "*.vmat" | while read FILE; do
      COLOR=$(grep -m1 TextureColor "${FILE}" | awk '{print $2}' | tr -d '"' | tr -d '\r\n' )
      NORMAL=$(grep -m1 TextureNormal "${FILE}" | awk '{print $2}' | tr -d '"' | tr -d '\r\n' )
      TRANSLUCENCY=$(grep -m1 TextureTranslucency "${FILE}" | awk '{print $2}' | tr -d '"' | tr -d '\r\n' )
      REFLECTANCE=$(grep -m1 TextureReflectance "${FILE}"| awk '{print $2}' | tr -d '"' | tr -d '\r\n' )
      SELFILLUMMASK=$(grep -m1 TextureSelfIllumMask "${FILE}"| awk '{print $2}' | tr -d '"' | tr -d '\r\n' )
      GLOSSINESS=$(grep -m1 TextureGlossiness "${FILE}"| awk '{print $2}' | tr -d '"' | tr -d '\r\n' )
      if [ ! -z "${GLOSSINESS}" ] && [[ -z $(find_asset_file "${Glossiness}") ]]; then
        echo "   Glossiness- | ${FILE} -- ${COLOR}" ; sed -i -e "s/\tTextureGlossiness/\/\/TextureGlossiness/" "${FILE}"
      fi
      if [ ! -z "${COLOR}" ] && [[ -z $(find_asset_file "${COLOR}") ]]; then
        echo "        Color- | ${FILE} -- ${COLOR}" ; sed -i -e "s/\tTextureColor/\/\/TextureColor/" "${FILE}"
      fi
      if [ ! -z "${TRANSLUCENCY}" ] && [[ -z $(find_asset_file "${TRANSLUCENCY}") ]]; then
        echo " Translucency- | ${FILE} -- ${TRANSLUCENCY}" ; sed -i -e "s/\tTextureTranslucency/\/\/TextureTranslucency/" "${FILE}"
      fi
      if [ ! -z "${NORMAL}" ] && [[ -z $(find_asset_file "${NORMAL}") ]]; then
        echo "       Normal- | ${FILE} -- ${NORMAL}" ; sed -i -e "s/\tTextureNormal/\/\/TextureNormal/" "${FILE}"
        unset NORMAL
      fi
      if [ ! -z "${REFLECTANCE}" ] && [[ "${REFLECTANCE}" == materials/* ]] && [[ -z $(find_asset_file "${REFLECTANCE}") ]]; then
        if [ ! -z "${NORMAL}" ]; then
          echo "  Reflectance+ | ${FILE} -- ${REFLECTANCE}" ; sed -i -e "s:${REFLECTANCE}:${NORMAL}:g" "${FILE}"
        else
          echo "  Reflectance- | ${FILE} -- ${REFLECTANCE}" ; sed -i -e "s/\tTextureReflectance/\/\/TextureReflectance/" "${FILE}"
        fi
      fi
      if [ ! -z "${SELFILLUMMASK}" ] && [[ -z $(find_asset_file "${SELFILLUMMASK}") ]]; then
        echo "SelfIllumMask- | ${FILE} -- ${SELFILLUMMASK}" ; sed -i -e "s/\tTextureSelfIllumMask/\/\/TextureSelfIllumMask/" "${FILE}"
      fi
    done
  } >> ${DIR}/${DIR}-6-diff.txt 2>&1
}

echo MAKE_ASSET_PACK asset_pack_hl2 3 "${SRC}/AAA_DOWNLOAD/Half-Life 2/hl2" none "hl2_misc_dir.vpk+hl2" "hl2_textures_dir.vpk+hl2" "../lostcoast/lostcoast_pak_dir.vpk+lostcoast" "../../Half-Life 2 Deathmatch/hl2mp/hl2mp_pak_dir.vpk+hl2mp"
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_hl2/models/breen_monitor.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_hl2/models/vortigaunt.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_hl2/models/odessa.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_hl2/models/monk.vmdl
		 echo mv -v ${DIR}/models/humans/group01 "${SRC}"/CULL_${DIR}/
		 echo mv -v ${DIR}/models/humans/group02 "${SRC}"/CULL_${DIR}/
		 echo mv -v ${DIR}/models/humans/group03 "${SRC}"/CULL_${DIR}/
		 echo mv -v ${DIR}/models/humans/group03m "${SRC}"/CULL_${DIR}/
echo MAKE_ASSET_PACK asset_pack_portal2 4 "${SRC}/AAA_DOWNLOAD/Portal 2/portal2" none "pak01_dir.vpk+portal2" "../portal2_dlc1/pak01_dir.vpk+portal2" "../portal2_dlc2/pak01_dir.vpk+portal2"
		 echo sed -i -e "s/container_ride_360/container_ride/" asset_pack_portal2/models/container_ride_360/*
		 echo sed -i -e "s/container_ride\/lowres/container_ride/" asset_pack_portal2/models/container_ride/lowres/endwalldestruction3.vmdl
		 echo sed -i -e "s/container_ride\/lowres/container_ride/" asset_pack_portal2/models/container_ride/lowres/lorezcontainerscombined_1_56.vmdl
		 echo sed -i -e "s/container_ride\/lowres/container_ride/" asset_pack_portal2/models/container_ride/lowres/lorezcontainerscombined_57_92.vmdl
		 echo sed -i -e "s/container_ride\/lowres/container_ride/" asset_pack_portal2/models/container_ride/lowres/finedebris_part5.vmdl
echo MAKE_ASSET_PACK asset_pack_left4dead2 4 "${SRC}/AAA_DOWNLOAD/Left 4 Dead 2/left4dead2" none "pak01_dir.vpk+left4dead2" "../left4dead2_dlc1/pak01_dir.vpk+left4dead2" "../left4dead2_dlc2/pak01_dir.vpk+left4dead2" "../left4dead2_dlc3/pak01_dir.vpk+left4dead2"
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/c1_chargerexit/doors_glass_5.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/c1_chargerexit/doors_glass_6.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/c1_chargerexit/plywood_cent.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/c5_bridge_destruction/bridge_left_tower.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/c5_bridge_destruction/bridge_right_tower.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/c5m3_bridge_overpass_debris/bridgedebris_set_a.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/destruction_tanker/destruction_tanker_debris_1.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/destruction_tanker/destruction_tanker_debris_2.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/destruction_tanker/destruction_tanker_debris_4.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/hybridphysx/map1_tarp_4.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/hybridphysx/map1_tarp_3.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/hybridphysx/map1_tarp_2.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/hybridphysx/map1_tarp_1.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/hybridphysx/gasstationpart_5.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/hybridphysx/gasstationpart_4.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/hybridphysx/gasstationpart_3.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/hybridphysx/gasstationpart_2.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/hybridphysx/gasstationpart_1.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/hybridphysx/airliner_left_wing_secondary.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/hybridphysx/airliner_fuselage_secondary_4.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/hybridphysx/airliner_fuselage_secondary_3.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/hybridphysx/airliner_fuselage_secondary_2.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/hybridphysx/airliner_fuselage_secondary_1.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/props_destruction/general_dest_concrete_set.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_left4dead2/models/props_destruction/general_dest_roof_set.vmdl
		 echo mv -v ${DIR}/models/infected "${SRC}"/CULL_${DIR}/
		 echo mv -v ${DIR}/models/survivors "${SRC}"/CULL_${DIR}/
BUILD=asset_pack_hl2
echo MAKE_ASSET_PACK asset_pack_cstrike 3 "${SRC}/AAA_DOWNLOAD/Counter-Strike Source/cstrike" asset_pack_hl2 "cstrike_pak_dir.vpk+cstrike"
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_cstrike/models/characters/hostage_01.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_cstrike/models/characters/hostage_02.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_cstrike/models/characters/hostage_03.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_cstrike/models/characters/hostage_04.vmdl
echo MAKE_ASSET_PACK asset_pack_dod 3 "${SRC}/AAA_DOWNLOAD/Day of Defeat Source/dod" asset_pack_hl2 "dod_pak_dir.vpk+dod"
CULLING=true
echo MAKE_ASSET_PACK asset_pack_episodic 5 "${SRC}/AAA_DOWNLOAD/Half-Life 2/episodic" asset_pack_hl2 "ep1_pak_dir.vpk+episodic"
echo MAKE_ASSET_PACK asset_pack_ep2 5 "${SRC}/AAA_DOWNLOAD/Half-Life 2/ep2" asset_pack_episodic,asset_pack_hl2 "ep2_pak_dir.vpk+ep2"
echo MAKE_ASSET_PACK asset_pack_fromearth 5 "${STEAMAPPS}/From Earth/fromearth"  asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2 "materials.vpk+fromearth" "models.vpk+fromearth" "particles.vpk+fromearth"
echo MAKE_ASSET_PACK asset_pack_se1 5 "${SRC}/AAA_DOWNLOAD/SiN Episodes Emergence/SE1" asset_pack_hl2,asset_pack_cstrike,asset_pack_dod "../vpks/depot_1301_dir.vpk+se1" "../vpks/depot_1302_dir.vpk+se1" "../vpks/depot_1316_dir.vpk+se1"
		 echo mv -v ${DIR}/materials/models/hl2_materials "${SRC}"/CULL_${DIR}/
		 echo mv -v ${DIR}/models/hl2_props "${SRC}"/CULL_${DIR}/
		 echo cp -v asset_pack_hl2/materials/dev/dev_combinemonitor_1.vmat asset_pack_se1/materials/models/vehicles/sin_car_crashed/
		 echo cp -v asset_pack_hl2/materials/dev/dev_combinemonitor_1.vmat asset_pack_se1/materials/models/vehicles/sin_car_crashed/temp_jcmonitor.vmat
		 echo find asset_pack_se1/materials -name *.vmat -exec sed -i -e "s/F_RENDER_BACKFACES 1\"/F_RENDER_BACKFACES 1/" {} \;
echo MAKE_ASSET_PACK asset_pack_ship 5 "${SRC}/AAA_DOWNLOAD/The Ship Single Player/ship" asset_pack_hl2,asset_pack_cstrike,asset_pack_dod "../vpks/depot_2402_dir.vpk+ship" "../vpks/depot_2405_dir.vpk+ship"
		 echo mv -v ${DIR}/materials/console/intro-ship* "${SRC}"/CULL_${DIR}/
		 echo mv -v ${DIR}/materials/console/loading-ship* "${SRC}"/CULL_${DIR}/
echo MAKE_ASSET_PACK asset_pack_pm 5 "${SRC}/AAA_DOWNLOAD/Bloody Good Time/pm" asset_pack_hl2,asset_pack_ship,asset_pack_cstrike,asset_pack_dod "../vpks/depot_2452_dir.vpk+pm"
echo MAKE_ASSET_PACK asset_pack_mm 5 "${SRC}/AAA_DOWNLOAD/Dark Messiah Might and Magic Single Player/mm" asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_portal2 "../vpks/depot_2103_dir.vpk+mm" "../vpks/depot_2104_dir.vpk+mm" "../vpks/depot_2105_dir.vpk+mm" "../vpks/depot_2106_dir.vpk+mm"
     echo find asset_pack_mm/materials -name *.vmat -exec sed -i -e "s/F_RENDER_BACKFACES 1\"/F_RENDER_BACKFACES 1/" {} \;
BUILD=asset_pack_portal2,asset_pack_hl2,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2
echo MAKE_ASSET_PACK asset_pack_dearesther 5 "${SRC}/AAA_DOWNLOAD/Dear Esther/dearesther" asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "materials.vpk+dearesther" "models.vpk+dearesther" "particles.vpk+dearesther"
	   echo mv -v ${DIR}/materials/console/Dearesther_product* "${SRC}"/CULL_${DIR}/
echo MAKE_ASSET_PACK asset_pack_thestanleyparable 5 "${SRC}/AAA_DOWNLOAD/The Stanley Parable/thestanleyparable" asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "materials.vpk+thestanleyparable" "models.vpk+thestanleyparable" "particles.vpk+thestanleyparable"
echo MAKE_ASSET_PACK asset_pack_swarm 5 "${SRC}/AAA_DOWNLOAD/Alien Swarm/swarm" asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "pak01_dir.vpk+swarm"
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_swarm/models/aliens/harvester/harvester.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_swarm/models/swarm/harvester/harvester.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_swarm/models/aliens/shieldbug/shieldbug.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_swarm/models/swarm/shieldbug/shieldbug.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_swarm/models/swarm/drone/uberdrone.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_swarm/models/swarm/drone/drone.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_swarm/models/aliens/drone/drone.vmdl
echo MAKE_ASSET_PACK asset_pack_dystopia 5 "${SRC}/AAA_DOWNLOAD/Dystopia/dystopia" asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "materials.vpk+dystopia" "models.vpk+dystopia" "particles.vpk+dystopia"
echo MAKE_ASSET_PACK asset_pack_neotokyosource 5 "${SRC}/AAA_DOWNLOAD/NEOTOKYO/NeotokyoSource" asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "materials.vpk+neotokyosource" "models.vpk+neotokyosource"
echo MAKE_ASSET_PACK asset_pack_nucleardawn 5 "${SRC}/AAA_DOWNLOAD/Nuclear Dawn/nucleardawn" asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "pak01_dir.vpk+nucleardawn"
echo MAKE_ASSET_PACK asset_pack_zps 5 "${SRC}/AAA_DOWNLOAD/Zombie Panic Source/zps" asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "../vpks/zps_content.vpk+zps"
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_zps/models/zpprops/farmhaydark.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_zps/models/zpprops/farmhaylight.vmdl
echo MAKE_ASSET_PACK asset_pack_contagion 5 "${SRC}/AAA_DOWNLOAD/Contagion/contagion" asset_pack_zps,asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "../vpks/materials.vpk+contagion" "../vpks/models.vpk+contagion" "particles.vpk+contagion"
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_contagion/models/survivors/male/eugene.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_contagion/models/survivors/male/eugene_young.vmdl
echo MAKE_ASSET_PACK asset_pack_insurgency 5 "${SRC}/AAA_DOWNLOAD/insurgency2/insurgency" asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "insurgency_materials.vpk+insurgency" "insurgency_models.vpk+insurgency" "insurgency_particles.vpk+insurgency"
echo MAKE_ASSET_PACK asset_pack_dinodday 5 "${SRC}/AAA_DOWNLOAD/Dino D-Day/dinodday" asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "materials.vpk+dinodday" "models.vpk+dinodday" "particles.vpk+dinodday"
echo MAKE_ASSET_PACK asset_pack_frontend 5 "${SRC}/AAA_DOWNLOAD/Anarchy Arcade/frontend" asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "materials.vpk+frontend" "models.vpk+frontend"
echo MAKE_ASSET_PACK asset_pack_dab 5 "${SRC}/AAA_DOWNLOAD/Double Action/dab" asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "materials.vpk+dab" "models.vpk+dab" "particles.vpk+dab"
echo MAKE_ASSET_PACK asset_pack_bms 5 "${SRC}/AAA_DOWNLOAD/Black Mesa/bms" asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "bms_materials.vpk+bms" "bms_models.vpk+bms" "bms_textures.vpk+bms" "bms_misc.vpk+bms"
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_bms/models/humans/scientist_eli.vmdl 2> /dev/null
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_bms/models/player/*marine*.vmdl 2> /dev/null
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_bms/models/humans/*marine*.vmdl 2> /dev/null
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_bms/models/props_xen/c4a1a-island-c1a/c4a1a-island-c1a036.vmdl 2> /dev/null
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_bms/models/props_xen/c4a1a-island-c1a/c4a1a-island-c1a034.vmdl 2> /dev/null
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_bms/models/props_xen/c4a1a-island-c1a/c4a1a-island-c1a015.vmdl 2> /dev/null
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_bms/models/props_xen/c4a1a-island-c1a/c4a1a-island-c1a014.vmdl 2> /dev/null
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_bms/models/props_xen/c4a1a-island-c1a/c4a1a-island-c1a013.vmdl 2> /dev/null
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_bms/models/props_xen/c4a1a-island-c1a/c4a1a-island-c1a012.vmdl 2> /dev/null
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_bms/models/props_xen/c4a1a-island-c1a/c4a1a-island-c1a011.vmdl 2> /dev/null
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_bms/models/props_xen/c4a1a-island-c1a/c4a1a-island-c1a003.vmdl 2> /dev/null
echo MAKE_ASSET_PACK asset_pack_vampire 5 "${SRC}/AAA_DOWNLOAD/Vampire The Masquerade - Bloodlines/vampire"
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_vampire/models/character/monster/animalism_beastform/animalism_beastform_mdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_vampire/models/character/shared/male/allsequences_mdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_vampire/models/character/shared/male/npc_allsequences_mdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_vampire/models/character/shared/male/pcidles_allsequences_mdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_vampire/models/character/shared/female/npc_allsequences_mdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_vampire/models/character/shared/female/pcidles_allsequences_mdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_vampire/models/character/shared/female/allsequences_mdl
echo MAKE_ASSET_PACK asset_pack_brainbread2 5 "${SRC}/AAA_DOWNLOAD/brainbread2/brainbread2"  asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "../base/bb2_game_dir.vpk+brainbread2" "../base/misc_game_dir.vpk+brainbread2"
echo MAKE_ASSET_PACK asset_pack_mindlock 5 "${SRC}/AAA_DOWNLOAD/The Trap 2 Mindlock (beta)/mindlock"  asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "materials.vpk+mindlock" "models.vpk+mindlock"
echo MAKE_ASSET_PACK asset_pack_wilson_chronicles 5 "${SRC}/AAA_DOWNLOAD/Wilson Chronicles/wilson_chronicles"  asset_pack_portal2,asset_pack_hl2,asset_pack_se1,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "materials.vpk+wilson_chronicles" "models.vpk+wilson_chronicles" "particles.vpk+wilson_chronicles"
echo MAKE_ASSET_PACK asset_pack_nmrih 5 "${SRC}/AAA_DOWNLOAD/nmrih/nmrih"  asset_pack_portal2,asset_pack_hl2,asset_pack_se1,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "nmrih_dir.vpk+nmrih"
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_nmrih/models/weapons/me_abrasivesaw/w_me_abrasivesaw.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_nmrih/models/weapons/me_axe_fire/v_me_axe_fire.vmdl
echo MAKE_ASSET_PACK asset_pack_revelations 5 "${SRC}/AAA_DOWNLOAD/Revelations 2012/revelations" asset_pack_portal2,asset_pack_hl2,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "materials.vpk+revelations" "models.vpk+revelations" "particles.vpk+revelations"
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_revelations/models/Revelations/priest/priest.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_revelations/models/Revelations/MorphGun/gunmorph.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_revelations/models/Revelations/weapons/viewmodels/v_gauntlet.vmdl
		 echo mv -v ${DIR}/models/players "${SRC}"/CULL_${DIR}/
echo MAKE_ASSET_PACK asset_pack_berimbau 5 "${SRC}/AAA_DOWNLOAD/Blade Symphony/berimbau" none "materials.vpk+berimbau" "models.vpk+berimbau" "particles.vpk+berimbau"
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_berimbau/models/props_monastery/books*.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_berimbau/models/temple/tt_r*.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_berimbau/models/temple/tt_l*.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_berimbau/models/temple/tt_m*.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_berimbau/models/temple/gong.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_berimbau/models/temple/rock*.vmdl
echo MAKE_ASSET_PACK asset_pack_portal_stories 5 "${STEAMAPPS}/Portal Stories Mel/portal_stories" asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "pak01_dir.vpk+portal_stories"
echo MAKE_ASSET_PACK asset_pack_csgo 5 "${STEAMAPPS}/Counter-Strike Global Offensive/csgo" none "pak01_dir.vpk+csgo"
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_csgo/models/weapons/v_rif_m4a1_s.vmdl
	 	 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_csgo/models/player/custom_player/legacy/ctm_diver_varianta.vmdl
	   echo sed -i -e "s/\.mdl/_mdl/" asset_pack_csgo/models/player/custom_player/animset_t.vmdl
	   echo sed -i -e "s/\.mdl/_mdl/" asset_pack_csgo/models/player/custom_player/animset_ct.vmdl
echo BUILD=asset_pack_portal2,asset_pack_hl2,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2
echo MAKE_ASSET_PACK asset_pack_gstringv2 5 "${STEAMAPPS}/G String/gstringv2" ${BUILD} "gstringv2_dir.vpk+gstringv2"
     echo find asset_pack_gstringv2 -name "*.vmat" -exec sed -i -e "s:TextureGlossiness://TextureGlossiness:" {} \; 
echo MAKE_ASSET_PACK asset_pack_p3 5 "${STEAMAPPS}/Postal III/p3" ${BUILD} "materials.vpk+p3" "models.vpk+p3" "particles.vpk+p3"
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_p3/models/characters/monkey/monkey_animations.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_p3/models/characters/krotchy/krotchy.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_p3/models/characters/krotchynpc/krotchynpc.vmdl
		 echo sed -i -e "s/\.mdl/_mdl/" asset_pack_p3/models/characters/krotchynpc/krotchynpc_animations.vmdl
