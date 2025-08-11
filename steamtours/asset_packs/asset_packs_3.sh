#!/bin/sh
S=/mnt/s/SteamLibrary/steamapps/common
L=/mnt/l/SteamLibrary/steamapps/common
D=/mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/common
C=${D}/SteamVR/tools/steamvr_environments/content/steamtours_addons
G=${D}/SteamVR/tools/steamvr_environments/game/steamtours_addons
W=/mnt/c/Users/byteframe/Downloads
X=/mnt/d/Work/Game/steamtours/asset_packs
N=/mnt/c/Program\ Files/Notepad++/notepad++.exe
P=source1import_
B=${1/*\//}
header() {
  echo -e "\n--------------------------------------------------------------------------------"
  echo ${1}
  echo "--------------------------------------------------------------------------------"
}
extract_vpk() {
  header ${A}" | VPK: ${1}"
  if ~ grep -q "exit 1" ~/.local/share/pipx/venvs/vpk/lib/python3.12/site-packages/vpk/cli.py; then
    echo -e "error in: vpk binary unmodified\n"
    read PAUSE
  elif ! ~/.local/bin/vpk -re "(models|materials|particles|sound|scripts|scenes|surfaces)/.*" -x "${C}"/${A} "${1}"; then
    echo -e "error in: ${1}, must extract manually\n"
    read PAUSE
  fi
  if [ -d "${C}"/${A}/${A/${P}/} ]; then
    for DIR in materials models particles scenes scripts surfaces sound; do 
      cp -r --link "${C}"/${A}/${A/${P}/}/${DIR} "${C}"/${A}/ 2> /dev/null
    done
    rm -fr "${C}"/${A}/${A/${P}/}
  fi
}
convert_to_utf8() {
  iconv -f WINDOWS-1250 -t UTF-8 ${1} > utf8.out
  mv utf8.out ${1}
}
MAKE_ASSET_PACK()
{
  A=${P}"${1/*\//}"
  cd "${C}"
  if [ ${A} == ${P}${B} ] || [[ -z ${B} && ! -e ${A}/${A}.txt ]]; then
    if [ ! -z ${DELETE} ] && [ ! -z ${B} ] && [ -e ${A}/${A}.txt ]; then
      header ${A}" | deleting... {*}"
      rm -fr ${A}/* "${G}"/${A}/*
      unset DELETE
    fi
    if [ ! -e ${A}/${A}.txt ]; then
      mkdir -p ${A}/_cull/materials/dev ${A}/sounds "${G}"/${A}
      header ${A}" | initializing pack..." | tee ${A}/${A}.txt
      rsync -a --info=progress2 --prune-empty-dirs --exclude-from="${X}"/exclude_list.txt "${1}"/ ${A}/
      touch ${A}/gameinfo.txt
      {
        for VAR in "$@"; do
          if [[ ${VAR} == *.vpk* ]]; then
            extract_vpk "${1}"/"${VAR}"
          fi
        done
        for I in {1..9}; do
          cp "${X}"/blend_template.vmat ${A}/materials/blend-${A/${P}/}-0${I}.vmat
        done
        echo "\"AddonInfo\"{\"Dependencies\"{}}" > "${G}"/${A}/addoninfo.txt
        mv ${A}/sound/* ${A}/sounds 2> /dev/null
        rm -fr ${A}/sounds/vo ${A}/sounds/commentary
        cp "${X}"/default_cube.tga ../core/materials/default
        cp ../core/materials/dev/black_color.tga ${A}/materials/black.tga
        cp ../core/materials/dev/white_color.tga ${A}/materials/white.tga
        mv ${A}/materials/dev/* ${A}/_cull/materials/dev/ 2> /dev/null
        for FILE in "dev_normal.vtf" "dev_camera_shared.vmt" "null.vtf" "water*" \
        "invisible*" "replay_noise*" "dev_ram_512*" "reflectivity_*.tga" "dev_measuregeneric*.tga" \
        "flat_normal*" "fus_normal*" "flatnormal*" "pom_test*" "dev_com*monitor*" \
        "devnormalmap.vtf" "*wall*" "*floor*"  "cont_*" "dev_tvmonitor*" "dev_camera*" \
        "dev_combinescanline.vtf" "dev_scanline*" "dev_measurecrate*" \
        "dev_monitor.vtf" "dev_lower" "Blue_Building_textures_light.vtf"; do
          mv -v ${A}/_cull/materials/dev/${FILE} ${A}/materials/dev/ 2> /dev/null
        done ; echo
        find ${A}/ -not -path "${A}/_cull/*" -name "*\ *" -type d | tac | while read DIR; do
          if [[ "${DIR}" != *"/environment maps" ]] && [[ "${DIR}" != *"/Environment Maps" ]]; then
            mkdir -vp ${DIR// /_}
            mv "${DIR}"/* ${DIR// /_}/
            rmdir "${DIR}"
          fi
        done
        find ${A}/ -not -path "${A}/_cull/*" -name "*\ *" -type f | tac | while read FILE; do
          mv -v "${FILE}" $(echo "${FILE}" | sed -e "s: \.:\.:" -e "s: :_:g")
        done ; echo
        for FILE in $(find ${A}/scripts -name "soundscape*.*" -or -name "game_sound*.txt"); do convert_to_utf8 ${FILE} ; sed -i -e "s/\.\././g" -e "s/\`//g" ${FILE}; done
        for FILE in $(find ${A}/materials/console/ ${A}/materials/vgui/chapters/ ${A}/materials/vgui/backgrounds/ ${A}/materials/gamepadui/ \
        -name background0* -or -name background_menu.* -or -name loading_screen_background.* -or -name coopcommentary_chapter* -or -name background_menu_widescreen.* -or \
        -name loading.* -or -name intro.* -or -name intro_widescreen.* -or -name startup_loading.* -or -name startup.* -or -name console_background.* -or -name chapter* -type f 2> /dev/null); do
          if [[ ${FILE} != *-* ]]; then
            if [[ ${FILE} == *.vmt ]]; then
              FILE_SHORT1=${FILE/${A}\/materials\//}
              FILE_SHORT2=${FILE_SHORT1//\//\\\\}
              sed -i -e "s:${FILE_SHORT1/.vmt/}:${FILE_SHORT1/.vmt/}-${A/${P}/}:gi" -e "s:${FILE_SHORT2/.vmt/}:${FILE_SHORT2/.vmt/}-${A/${P}/}:gi" ${FILE}
            fi
            mv -v ${FILE} ${FILE/./-${A/${P}/}.}
          fi
        done 
      } | tee -a ${A}/${A}.txt
      PRE_IMPORT_FIXES ${A} 2> /dev/null; echo
    fi
    if [ -z ${INITIALIZE_ONLY} ]; then
      if [ -z ${SKIP_NOVTF} ]; then
        header ${A}" | converting textures..."
        ${W}/no_vtf-4.2.0/no_vtf.exe --ldr-format "tiff|tiff" --hdr-format pfm ${A}/materials/
      fi

      [ -z "${I_TYPES}" ] && I_TYPES="materials models particles scripts scenes"
      if [ "${I_TYPES}" != none ]; then
        for TYPE in ${I_TYPES}; do
          if [ -d ${A}/${TYPE} ]; then     
            header ${A}" | importing ${TYPE}..."
            rm -f ${A}/${A}_import_${TYPE}.log
            while ! grep -q "Looks like we are done" ${A}/${A}_import_${TYPE}.log 2> /dev/null; do
              if [ -e ${A}/${A}_import_${TYPE}.log ]; then
                echo ${A}": (waiting) retry: ${TYPE}_import... {*}"
                read PAUSE
              fi
              python "${W}"/source1import-0.3.12/utils/${TYPE}_import.py -i "${C}"/${A} -e "${C}"/${A} | tee -a ${A}/${A}_import_${TYPE}.log
            done
          fi
        done
      fi

      [ -z "${B_TYPES}" ] && B_TYPES="sounds soundevents scenes materials particles models"
      if [ "${B_TYPES}" != none ]; then
        for TYPE in ${B_TYPES}; do
          if [ -d ${A}/${TYPE} ]; then
            header ${A}" | building ${TYPE}..."
            rm -f ${A}/${A}_build_${TYPE}.log
            while ! grep -q "compiled," ${A}/${A}_build_${TYPE}.log 2> /dev/null; do
              if [ -e ${A}/${A}_build_${TYPE}.log ]; then
                FAIL=$(tac ${A}/${A}_build_${TYPE}.log | grep -m1 "^- " | cut -c 21- | sed -e "s:${A}\\\::" -e "s:\\\:/:g" -e $'s/\r$//')
                echo "build failure (${FAIL})"
                if [[ ${FAIL} == *.vmdl ]]; then
                  rm ${A}/${FAIL}
                else
                  mkdir -p ${A}/_cull/${FAIL%/*}
                  mv ${A}/"${FAIL}" ${A}/_cull/"${FAIL}".FAIL
                fi
              fi
              "${G}"/../bin/win64/resourcecompiler.exe -nominidumps -r -i "C:/Program Files (x86)/Steam/steamapps/common/SteamVR/tools/steamvr_environments/content/steamtours_addons/${A}/${TYPE}/*" >> ${A}/${A}_build_${TYPE}.log
            done
            tail ${A}/${A}_build_${TYPE}.log | grep -m1 " compiled, " ; echo
            if [ ${TYPE} = sounds ]; then
              rm -fr ${A}/sounds/*
            fi
            cat -s ${A}/${A}_build_${TYPE}.log | sed -e "/- steamtours_addons.*\.\(vpcf\|vmat\|vmdl\|vsndevts\|vtex\|wav\|WAV\|mp3\|MP3\|vmesh\|vagrp\|vseq\|vanim\|vphys\)/d" \
              -e "/CDataModel:/d" -e "/Leaking :/d" -e "/     - Found DXT5 texture/d" -e "/Parsed MP3/d" -e "/Compressing .*texture to/d" -e "/ (elapsed /d" -e "/File already exists/d" -e "/Failed to find compiler/d" -e "/models_ModelDocGameData/d" \
              | head -n -3 >> ${A}/${A}.txt
          fi
        done
      fi
    fi > >(tee -a ${A}/${A}.txt) 2> >(tee -a ${A}/${A}.txt >&2)
    rm -f ${A}/${A}_*_*.log 2> /dev/null
    rmdir ${A}/sound 2> /dev/null
  fi
  unset PRE_IMPORT_FIXES
}
##------------------------------------------------------------------------------ hl2
MAKE_ASSET_PACK "${S}/Half-Life 2/hl2" "hl2_misc_dir.vpk" "hl2_textures_dir.vpk" "hl2_sound_misc_dir.vpk"
##------------------------------------------------------------------------------ hl2mp
MAKE_ASSET_PACK "${S}/Half-Life 2 Deathmatch/hl2mp" "hl2mp_pak_dir.vpk"
##------------------------------------------------------------------------------ lostcoast
PRE_IMPORT_FIXES() {
  rm -fr ${1}/sounds/lostcoast
}
MAKE_ASSET_PACK "${S}/Half-Life 2/lostcoast" "lostcoast_pak_dir.vpk"
##------------------------------------------------------------------------------ episodic
MAKE_ASSET_PACK "${S}/Half-Life 2/episodic" "ep1_pak_dir.vpk"
##------------------------------------------------------------------------------ ep2
MAKE_ASSET_PACK "${S}/Half-Life 2/ep2" "ep2_pak_dir.vpk"
##------------------------------------------------------------------------------ cstrike
MAKE_ASSET_PACK "${S}/Counter-Strike Source/cstrike" "cstrike_pak_dir.vpk"
##------------------------------------------------------------------------------ dod
MAKE_ASSET_PACK "${S}/Day of Defeat Source/dod" "dod_pak_dir.vpk"
##------------------------------------------------------------------------------ left4dead2 - (serviet vmt might not get culled)
PRE_IMPORT_FIXES() {
  mv -v ${1}/materials/dons_decals/serviet_*.vmt ${1}/scripts/soundscapes_airport.txt ${1}/_cull
}
MAKE_ASSET_PACK "${S}/Left 4 Dead 2/left4dead2" "pak01_dir.vpk" "../left4dead2_dlc1/pak01_dir.vpk" "../left4dead2_dlc2/pak01_dir.vpk" "../left4dead2_dlc3/pak01_dir_BROKEN.vpk"  "../other_loose_files_check_serviet_bad_vmt.vpk"
##------------------------------------------------------------------------------ portal2
PRE_IMPORT_FIXES() {
  sed -i -e "s/.4\`/.4/" ${1}/materials/metal/black_wall_metal_005a_top.vmt ${1}/materials/nature/dirtfloor004d.vmt
}
MAKE_ASSET_PACK "${S}/Portal 2/portal2" "pak01_dir.vpk" "../portal2_dlc1/pak01_dir.vpk" "../portal2_dlc2/pak01_dir.vpk" "../other_loose_files_in_dlc_folders.vpk"
##------------------------------------------------------------------------------ portal_stories
PRE_IMPORT_FIXES() {
  mv -v ${1}/scripts/game_sounds_ps_virgil_autogenerated.txt ${1}/_cull
}
MAKE_ASSET_PACK "${S}/Portal Stories Mel/portal_stories" "pak01_dir.vpk"
##------------------------------------------------------------------------------ aperturetag
MAKE_ASSET_PACK "${S}/Aperture Tag/aperturetag" "pak01_dir.vpk"
##------------------------------------------------------------------------------ treason
MAKE_ASSET_PACK "${S}/Treason/treason"
##------------------------------------------------------------------------------ pm
PRE_IMPORT_FIXES() {
  for FILE in $(find ${1}/materials -iname "*.vmt"); do
    sed -i -e "/\[\$[xX]360\]/d" -e "s/\s*\[\$WIN32\]//" -e s:$'\x93':\":g -e s:$'\x94':\":g -e "s:\\\:/:g" ${FILE}  
  done
}
MAKE_ASSET_PACK "${S}/Bloody Good Time/pm" "../vpks/depot_2452_dir.vpk"
##------------------------------------------------------------------------------ dearesther
PRE_IMPORT_FIXES() {
  convert_to_utf8 ${1}/materials/esther/blends/b_sand_2_sanddune_001_trash.vmt
}
MAKE_ASSET_PACK "${S}/Dear Esther/dearesther"
##------------------------------------------------------------------------------ thestanleyparable
MAKE_ASSET_PACK "${S}/The Stanley Parable/thestanleyparable"
##------------------------------------------------------------------------------ dinodday
PRE_IMPORT_FIXES() {
  convert_to_utf8 ${1}/materials/decals/verboten.vmt
}
MAKE_ASSET_PACK "${S}/Dino D-Day/dinodday"
##------------------------------------------------------------------------------ berimbau
PRE_IMPORT_FIXES() {
  sed -i -e "s/Proxies\"/Proxies\"\{/" ${1}/materials/models/blades/caduceus/caduceus_flow.vmt ${1}/materials/models/blades/sonia/sonia_glow.vmt
  echo "}" >> ${1}/materials/models/blades/caduceus/caduceus_flow.vmt
  echo "}" >> ${1}/materials/models/blades/sonia/sonia_glow.vmt
}
MAKE_ASSET_PACK "${S}/Blade Symphony/berimbau"
##------------------------------------------------------------------------------ mm
PRE_IMPORT_FIXES() {
  mv -v ${1}/scripts/game_sounds_header.txt ${1}/_cull
  sed -i -e "/\/\//d" ${1}/materials/nature/water_l04.vmt ${1}/materials/nature/water_l05_b.vmt ${1}/materials/nature/water_l06_c.vmt ${1}/materials/nature/water_l05_b_regen.vmt ${1}/materials/nature/water_l05_a.vmt
}
MAKE_ASSET_PACK "${S}/Dark Messiah Might and Magic Single Player/mm" "../vpks/depot_2101_dir.vpk" "../vpks/depot_2103_dir.vpk" "../vpks/depot_2104_dir.vpk" "../vpks/depot_2105_dir.vpk" "../vpks/depot_2106_dir.vpk" "../vpks/depot_2107_dir.vpk" "../vpks/depot_2108_dir.vpk"
##------------------------------------------------------------------------------ se1
PRE_IMPORT_FIXES() {
  rm -fr ${1}/materials/models/hl2_materials ${1}/models/hl2_props
}
MAKE_ASSET_PACK "${S}/SiN Episodes Emergence/se1" "../vpks/depot_1301_dir.vpk" "../vpks/depot_1302_dir.vpk" "../vpks/depot_1303_dir.vpk"  "../vpks/depot_1304_dir.vpk"  "../vpks/depot_1305_dir.vpk" "../vpks/depot_1316_dir.vpk"
##------------------------------------------------------------------------------ frontend
MAKE_ASSET_PACK "${S}/Anarchy Arcade/frontend"
##------------------------------------------------------------------------------ garrysmod
MAKE_ASSET_PACK "${S}/GarrysMod/garrysmod" "garrysmod_dir.vpk"
##------------------------------------------------------------------------------ dystopia
MAKE_ASSET_PACK "${S}/Dystopia/dystopia"
##------------------------------------------------------------------------------ neotokyosource
MAKE_ASSET_PACK "${S}/NEOTOKYO/neotokyosource"
##------------------------------------------------------------------------------ mindlock
MAKE_ASSET_PACK "${S}/The Trap 2 Mindlock (beta)/mindlock"
##------------------------------------------------------------------------------ wilson_chronicles
MAKE_ASSET_PACK "${S}/Wilson Chronicles/wilson_chronicles"
##------------------------------------------------------------------------------ fromearth
MAKE_ASSET_PACK "${S}/From Earth/fromearth"
##------------------------------------------------------------------------------ consortium
PRE_IMPORT_FIXES() {
  rm -f ${1}/sounds/Zenlil_1/iss_sound/tree_group_45/"Pawn44+45_1-2-3-2+-0.wav" ${1}/_cull
}
MAKE_ASSET_PACK "${S}/Consortium/consortium"
##------------------------------------------------------------------------------ fof
MAKE_ASSET_PACK "${S}/Fistful of Frags/fof" "fof_dir.vpk" "fof2_dir.vpk"
##------------------------------------------------------------------------------ eye
PRE_IMPORT_FIXES() {
  if [ -e ${1}/materials/vgui/equipment/vgui_weapondefault_.vmt ]; then
    mv ${1}/materials/vgui/equipment/vgui_weapondefault.vmt ${1}/materials/vgui/equipment/vgui_weapondefault.vtf
    mv ${1}/materials/vgui/equipment/vgui_weapondefault_.vmt ${1}/materials/vgui/equipment/vgui_weapondefault.vmt
  fi
  convert_to_utf8 ${1}/materials/models/arches/candle_flame.vmt
  mv -v ${1}/scripts/game_sounds_reloads.txt ${1}/_cull
}
MAKE_ASSET_PACK "${S}/EYE/eye"
##------------------------------------------------------------------------------ dab
PRE_IMPORT_FIXES() {
  mv -v ${1}/materials/models/stormy/da_floorlight_01_nor.vmt ${1}/_cull
  for FILE in "weapons/v_models/mossberg590/diffuse.vmt" "shells/12gauge/shell_12gauge.vmt" "weapons/v_models/mossberg590/mossberg590.vmt" "weapons/v_models/mossberg590/shotgun_shell.vmt"; do
    convert_to_utf8 ${1}/materials/models/${FILE}
  done
}
MAKE_ASSET_PACK "${S}/Double Action/dab"
##------------------------------------------------------------------------------ ageofchivalry
MAKE_ASSET_PACK "${S}/Source SDK Base 2007/ageofchivalry"
##------------------------------------------------------------------------------ esmod
PRE_IMPORT_FIXES() {
  convert_to_utf8 ${1}/materials/models/props_es/terminals/monitor.vmt
}
MAKE_ASSET_PACK "${S}/Source SDK Base/esmod"
##------------------------------------------------------------------------------ estrangedact1
PRE_IMPORT_FIXES() {
  convert_to_utf8 ${1}/materials/models/www.gaming-models.de/baustellenset/baustellenbarke.vmt
}
MAKE_ASSET_PACK "${S}/Estranged Act I/estrangedact1" "estranged_pack_dir.vpk"
##------------------------------------------------------------------------------ insurgency
PRE_IMPORT_FIXES() {
  rm -fv ${1}/materials/nature/"water_revolt. " ${1}/materials/maps/terrain/"blend_af_peak_soil_03. "
  echo -e "$(sed -e "s:}::i" ${1}/materials/models/foliage/tree6_1.vmt)\n}" > ${1}/materials/models/foliage/tree6_1.vmt
  echo "}" >> ${1}/materials/models/player/temp.vmt
  sed -i -e "/\/[*]/,/[*]\//d" ${1}/materials/models/player/ins_player_shared.vmt
}
MAKE_ASSET_PACK "${S}/insurgency2/insurgency" "insurgency_misc_dir.vpk" "insurgency_materials_dir.vpk" "insurgency_models_dir.vpk" "insurgency_particles_dir.vpk" "insurgency_sound_dir.vpk"
##------------------------------------------------------------------------------ zps
PRE_IMPORT_FIXES() {
  convert_to_utf8 ${1}/materials/models/survivors/survivor3/ring.vmt
  sed -i -e "s:/round_light:/zp_round_light:" ${1}/materials/zpcustommaterials/lights/zp_round_light.vmt
  sed -i -e "s:\"\$basetexture\"\t\"buildings:\"\$basetexture\" \"zpcustommaterials/buildings:" ${1}/materials/zpcustommaterials/buildings/gen03.vmt
  sed -i -e "s:gib_vanessa_body_bump:bloody/gib_vanessa_body_bump:" ${1}/materials/models/survivors/vanessa/bloody/gib_vanessa_body_hair.vmt
  sed -i -e "s:gib_vanessa_hair_bump:bloody/gib_vanessa_hair_bump:" ${1}/materials/models/survivors/vanessa/bloody/gib_vanessa_hair.vmt
  sed -i -e "s:normal\":normalmap\":" ${1}/materials/models/survivors/survivor5/diffuse_infected.vmt
  sed -i -e "s:normal\":normalmap\":" ${1}/materials/models/survivors/survivor5/hair.vmt
  sed -i -e "s:_bump:_normal:" ${1}/materials/models/survivors/survivor4/bloody/gib_punker_hair_infected.vmt
  sed -i -e "s:_bump:_normal:" ${1}/materials/models/survivors/survivor4/bloody/gib_punker_hair.vmt
}
MAKE_ASSET_PACK "${S}/Zombie Panic Source/zps" "../vpks/zps_content_dir.vpk"
##------------------------------------------------------------------------------ nmrih
PRE_IMPORT_FIXES() {
  mv -v ${1}/particles/nmrih_molotov.pcf ${1}/_cull
}
MAKE_ASSET_PACK "${S}/nmrih/nmrih" "nmrih_dir.vpk"
##------------------------------------------------------------------------------ contagion
MAKE_ASSET_PACK "${S}/Contagion/contagion" "../vpks/materials_dir.vpk" "../vpks/models_dir.vpk" "../vpks/scripts_dir.vpk"
##------------------------------------------------------------------------------ gstringv2
MAKE_ASSET_PACK "${S}/G String/gstringv2" "gstringv2_dir.vpk"
##------------------------------------------------------------------------------ infra
PRE_IMPORT_FIXES() {
  rm -r ${1}/sounds/world/plane_overpass.wav
  mv -v ${1}/scripts/soundscapes_tunnel.txt ${1}/_cull
  convert_to_utf8 ${1}/materials/models/props_foliage/vines_001.vmt
}
MAKE_ASSET_PACK "${S}/infra/infra" "pak01_dir.vpk" "pak02_dir.vpk"
##------------------------------------------------------------------------------ csgo
PRE_IMPORT_FIXES() {
  convert_to_utf8 ${1}/materials/models/props_foliage/vines_001.vmt
}
MAKE_ASSET_PACK "${L}/Counter-Strike Global Offensive/csgo" "pak01_dir.vpk"
##------------------------------------------------------------------------------ bms
PRE_IMPORT_FIXES() {
  convert_to_utf8 ${1}/materials/models/xenians/houndeye/houndeye.vmt
}
MAKE_ASSET_PACK "${S}/Black Mesa/bms" "bms_materials_dir.vpk" "bms_models_dir.vpk" "bms_textures_dir.vpk" "bms_sounds_misc_dir.vpk" "bms_misc_dir.vpk"
##------------------------------------------------------------------------------ revelations - (pauses in particle import)
MAKE_ASSET_PACK "${S}/Revelations 2012/revelations"
##------------------------------------------------------------------------------ nucleardawn - (pauses in particle import, assuming false positive on '.' vmt)
PRE_IMPORT_FIXES() {
  convert_to_utf8 ${1}/materials/nightvision.vmt
  sed -i -e "s:\t\"\$detailscale:\t//\"\$detailscale:" ${1}/materials/models/rts_structures/rts_armoury/rts_armoury_ct_displays.vmt ${1}/materials/models/rts_structures/rts_armoury/rts_armoury_emp_displays.vmt
}
MAKE_ASSET_PACK "${S}/Nuclear Dawn/nucleardawn" "pak01_dir.vpk"
##------------------------------------------------------------------------------ ship
MAKE_ASSET_PACK "${S}/The Ship Single Player/ship" "../vpks/depot_2402_dir_BROKEN.vpk" "../vpks/depot_2405_dir.vpk"
##------------------------------------------------------------------------------ brainbread2
MAKE_ASSET_PACK "${S}/brainbread2/brainbread2" "../base/bb2_game_dir_BROKEN.vpk" "../base/misc_game_dir.vpk"
##------------------------------------------------------------------------------ empires - (locks on surfaceproperties conversion)
MAKE_ASSET_PACK "${S}/Empires/empires" "materials_dir.vpk" "materials_legacy_dir.vpk" "models_dir.vpk" "models_legacy_dir.vpk" "scripts_dir.vpk"
##------------------------------------------------------------------------------ tf - (pauses in particle import)
PRE_IMPORT_FIXES() {
  mv -v ${1}/scripts/game_sounds*.txt ${1}/_cull
  convert_to_utf8 ${1}/materials/models/player/items/demo/demo_parrot_s2.vmt
  convert_to_utf8 ${1}/materials/models/player/items/demo/demo_parrot_s3.vmt
}
MAKE_ASSET_PACK "${S}/Team Fortress 2/tf" "tf2_sound_misc_dir.vpk" "tf2_misc_dir.vpk" "tf2_textures_dir.vpk"
##------------------------------------------------------------------------------ tacint - (https://gamebanana.com/threads/191857)
PRE_IMPORT_FIXES() {
  mv -v ${1}/particles/ti_explodefx_props.pcf ${1}/_cull
}
MAKE_ASSET_PACK "${S}/TacticalIntervention/tacint" "___VPK/data_001_dir.vpk"
##------------------------------------------------------------------------------ zenozoik
MAKE_ASSET_PACK "${S}/ZenoClash/zenozoik" "_MANUAL_INSERTION_.vpk"
##------------------------------------------------------------------------------ swarm
MAKE_ASSET_PACK "${S}/Alien Swarm/swarm" "pak01_dir.vpk" "_MANUAL_INSERTION_.vpk" 
##------------------------------------------------------------------------------ p3
PRE_IMPORT_FIXES() {
  find ${1}/materials/ -name *.vmt | while read FILE; do convert_to_utf8 ${FILE}; done
}
MAKE_ASSET_PACK "${S}/Postal III/p3" "_MANUAL_INSERTION_.vpk"
##------------------------------------------------------------------------------ r1 - (https://github.com/harmonytf/HarmonyVPKTool/releases/ use mdl 49 on decompile)
MAKE_ASSET_PACK "${S}/r1" "_MANUAL_INSERTION_.vpk"
##------------------------------------------------------------------------------ hfs - (https://github.com/yretenai/HFSExtract/releases/tag/0.2.1
PRE_IMPORT_FIXES() {
  mv ${1}/scripts/game_sounds* ${1}/_cull
  mv ${1}/scripts/surfaceproperties.txt ${1}/_cull
  rm -fr ${1}/models/armor
  rm -fr ${1}/models/event
  rm -fr ${1}/models/rear
  rm -fr ${1}/materials/models/armor
  rm -fr ${1}/materials/models/event
  rm -fr ${1}/materials/models/rear
  find ${1}/materials/ -name *.vmt | while read FILE; do convert_to_utf8 ${FILE}; done
}
MAKE_ASSET_PACK "${S}/hfs"
##------------------------------------------------------------------------------ vampire (sdk for tth and model conversion)
PRE_IMPORT_FIXES() {
  mv ${1}/materials/skybox/hav* ${1}/_cull
}
MAKE_ASSET_PACK "${S}/vampire" "_MANUAL_INSERTION_.vpk"
##------------------------------------------------------------------------------ EXPERIMENTAL: cm2013
MAKE_ASSET_PACK "${S}/cm2013"
##------------------------------------------------------------------------------ hl1
PRE_IMPORT_FIXES() {
  mv ${1}/materials/skybox/xen9* ${1}/_cull
}
MAKE_ASSET_PACK "${S}/Half-Life 2/hl1" "hl1_pak_dir.vpk"
##------------------------------------------------------------------------------ hl1_hd
MAKE_ASSET_PACK "${S}/Half-Life 2/hl1_hd" "hl1_hd_pak_dir.vpk"
##------------------------------------------------------------------------------ snowdrop_escape
MAKE_ASSET_PACK "${S}/Snowdrop Escape/snowdrop_escape" "sde_materials_dir.vpk" "sde_models_dir.vpk"