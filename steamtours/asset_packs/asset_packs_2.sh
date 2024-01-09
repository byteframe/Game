#!/bin/sh
D=/mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/common
S=/mnt/v/SteamLibrary/steamapps/common
C=${D}/SteamVR/tools/steamvr_environments/content/steamtours_addons
G=${D}/SteamVR/tools/steamvr_environments/game/steamtours_addons
W=/mnt/c/Users/byteframe/Downloads/source1import
X=/mnt/d/Work/Game/steamtours/asset_packs
N=/mnt/c/Program\ Files/Notepad++/notepad++.exe
P="" B=${1} V=v6
header() {
  echo -e "\n--------------------------------------------------------------------------------"
  echo ${1}
  echo "--------------------------------------------------------------------------------"
  sleep 1
}
extract_vpk() {
  header ${A}" | VPK ${1}" | tee -a ${A}/${A}.txt
  if ! ~/.local/bin/vpk -re "(models|materials|particles|sound|scripts|scenes|surfaces)/.*" -x "${C}"/${A} "${1}"; then
    echo -e "error in: ${1}, must extract manually\n" | tee -a ${A}/${A}.txt
    read PAUSE
  fi
  if [ -d "${C}"/${A}/${A:11} ]; then
    for DIR in materials models particles scenes scripts surfaces sound; do 
      cp -r --link "${C}"/${A}/${A:11}/${DIR} "${C}"/${A}/ 2> /dev/null
    done
    rm -fr "${C}"/${A}/${A:11}
  fi
}
convert_to_utf8() {
  iconv -f WINDOWS-1250 -t UTF-8 ${1} > utf8.out
  mv -v utf8.out ${1}
}
MAKE_ASSET_PACK()
{
  A=asset_pack_"${1/*\//}${P}"
  cd "${C}"
  if [ ${A} == "${B}" ] || [[ -z ${B} && ! -e ${A}/${A}.txt ]]; then
    if [ ! -z ${DELETE} ]; then
      header ${A}" | (waiting) CONFIRMING DELETE REQUEST... {*}"
      read PAUSE
      if [ ${PAUSE} != 'Y' ]; then
        exit 1
      fi
      rm -fr ${A}/* "${G}"/${A}/*
    fi
    if [ ! -e ${A}/${A}.txt ]; then
      mkdir -p ${A}
      header ${A}" | INITIALZING ASSET PACK... {*}" > ${A}/${A}.txt
      ( cd "${W}"; git diff >> "${C}"/${A}/${A}.txt )
      rsync -a --info=progress2 --prune-empty-dirs --exclude='*.bik' --exclude='maps/' --exclude='bin/' --exclude='media/' --exclude='resource/' --exclude="*.vpk" "${1}"/ ${A}/
      for VAR in "$@"; do
        if [[ ${VAR} == *.vpk* ]]; then
          extract_vpk "${1}"/"${VAR}"
        fi
      done
    fi
    if [ -z ${INITIALIZE_ONLY} ]; then
      header ${A}" | PREPPING SOURCE FILES {!}"
      mkdir -p ${A}/_cull/materials/dev ${A}/sounds "${G}"/${A}
      echo "\"AddonInfo\"{\"Dependencies\"{}}" > "${G}"/${A}/addoninfo.txt
      mv ${A}/sound/* ${A}/sounds
      sed -i -e "s/\.\././g" -e "s/\`//g" "${C}"/${A}/scripts/game_sounds*.txt
      mv -v ${A}/sounds/common/talk.wav ${A}/_cull 2> /dev/null
      cp "${X}"/default_cube.tga ../core/materials/default
      cp ../core/materials/dev/black_color.tga ${A}/materials/black.tga
      cp ../core/materials/dev/white_color.tga ${A}/materials/white.tga
      mv -v ${A}/materials/dev/* ${A}/_cull/materials/dev/
      for FILE in "dev_normal.vtf" "dev_camera_shared.vmt" "null.vtf" "water*" \
      "invisible*" "replay_noise*" "dev_ram_512*" "reflectivity_*.tga" "dev_measuregeneric*.tga" \
      "flat_normal*" "fus_normal*" "flatnormal*" "pom_test*" "dev_com*monitor*" \
      "devnormalmap.vtf" "*wall*" "*floor*"  "cont_*" "dev_tvmonitor*" "dev_camera*" \
      "dev_combinescanline.vtf" "dev_scanline*" "dev_measurecrate*" \
      "dev_monitor.vtf" "dev_lower" "Blue_Building_textures_light.vtf"; do
        mv -v ${A}/_cull/materials/dev/${FILE} ${A}/materials/dev/ 2> /dev/null
      done
      if [[ ${MODELS} = "_MANUAL_INSERTION_"* ]]; then
        echo ${A}": (waiting) pausing for manual model replacements..."
        read PAUSE
      fi
      find ${A}/ -name "*\ *" -type d | tac | while read DIR; do
        for FILE in "${DIR}"/*.vmt; do
          DIR_SHORT="${DIR/${A}\/materials\//}"
          sed -i -e "s:${DIR_SHORT}/:${DIR_SHORT// /_}/:gi" "${FILE}"
        done
        if [ -d "${DIR// /_}" ]; then
          mv -v "${DIR}"/* "${DIR// /_}"/
        else
          mv -v "${DIR}" "${DIR// /_}"
        fi
      done
      find ${A}/ -name "*\ *" -type f | tac | while read FILE; do
        if [[ "${FILE}" == *.vmt ]]; then
          FILE_SHORT1="${FILE/${A}\/materials\//}"
          FILE_SHORT2="${FILE_SHORT1// /_}"
          sed -i -e "s:${FILE_SHORT1/.vmt/}:${FILE_SHORT2/.vmt/}:gi" "${FILE}"
        fi
        mv -v "${FILE}" $(echo "${FILE// /_}" | sed -e "s:__:_:g")
      done
      for FILE in $(find ${A}/scripts -name "soundscape*.*" -or -name "game_sound*.txt"); do convert_to_utf8 ${FILE}; done
      for FILE in $(find ${A}/materials/ -name "*.VTF"); do mv -v ${FILE} ${FILE:0:(-4)}.vtf_; mv ${FILE:0:(-4)}.vtf_ ${FILE:0:(-4)}.vtf; done
      for FILE in $(find ${A}/materials/ -iname "*.vmt"); do sed -i -e "/\[\$[xX]360\]/d" -e "s/\s*\[\$WIN32\]//" -e s:$'\x93':\":g -e s:$'\x94':\":g -e "s:\\\:/:g" -e "s:environment maps:environment_maps:i" ${FILE}; done
      for FILE in $(find ${A}/materials/console/ ${A}/materials/vgui/chapters/ ${A}/materials/vgui/backgrounds/ -type f \
      -name background0* -or -name background_menu.* -or -name loading_screen_background.* -or -name coopcommentary_chapter* -or -name background_menu_widescreen.* -or \
      -name loading.* -or -name intro.* -or -name intro_widescreen.* -or -name startup_loading.* -or \
      -name startup.* -or -name console_background.* -or -name chapter*); do
        if [[ ${FILE} != *-* ]] && [ ! -d ${FILE} ]; then
          if [[ ${FILE} == *.vmt ]]; then
            FILE_SHORT=${FILE/${A}\/materials\//}
            sed -i -e "s:${FILE_SHORT/.vmt/}:${FILE_SHORT/.vmt/}-${A:11}:gi" ${FILE}
          fi
          mv -v ${FILE} ${FILE/./-${A:11}.}
        fi
      done

      header ${A}" | (waiting) NOW RUN VTFEDIT MANUALLY FOR TGA CONVERSION..."
      rm -fr "${W}"/../materials/${A}
      mv -v ${A}/materials/ "${W}"/../materials/${A}
      read PAUSE_FOR_MANUAL_VTFEDIT
      mv -v "${W}"/../materials/${A} ${A}/materials
      VTF_COUNT=0 TGA_COUNT=0
      for FILE in $(find ${A}/materials/ -iname "*.vtf"); do
        VTF_COUNT=$((VTF_COUNT+1))
        if [ -e ${FILE/.vtf/.tga} ]; then
          TGA_COUNT=$((TGA_COUNT+1))
          rm ${FILE}
        else
          echo "warning: vtf_edit did not convert: "${FILE}
        fi
      done
      echo -e "vtf count: "${VTF_COUNT}"\ntga count: "${TGA_COUNT}

      header ${A}" | RUNNING CONVERSION SCRIPTS..."
      PRE_IMPORT_FIXES
      for TYPE in materials models particles scripts scenes; do
        while ! grep -q "Looks like we are done" ${A}/${A}_import_${TYPE}.log 2> /dev/null; do
          if [ -e ${A}/${A}_import_${TYPE}.log ]; then
            echo ${A}": (waiting) retry: ${TYPE}_import..."
            read PAUSE
          fi
          python "${W}"/utils/${TYPE}_import.py -i "${C}"/${A} -e "${C}"/${A} | tee -a ${A}/${A}_import_${TYPE}.log
        done
      done

      header ${A}" | BLACKLISTING VMDLS FILES AND CHECKING VMATS..."
      for MODEL in ${MODELS}; do
        if [ -d ${A}/models/${MODEL} ]; then
          find ${A}/models/${MODEL}/ -name "*.vmdl" -exec sed -i -e "s/\.mdl/_mdl/" {} \;
        elif [ ${MODEL} != "_MANUAL_INSERTION_" ]; then
          sed -i -e "s/\.mdl/_mdl/" ${A}/models/${MODEL}.vmdl
        fi
      done
      for FILE in $(find ${A}/materials -name *.vmat); do
        if grep -q "\"None\"" ${FILE} || grep -q "4.vfx" ${FILE}; then
          echo -e ${FILE}"\n------------------------------------------------------"
          cat ${FILE}
          cat ${FILE/.vmat/.vmt}
        fi
        if grep -li "materials/_rt" ${FILE}; then
          sed -i_RT -e "/materials\/_rt/Id" ${FILE}
        fi
      done

      header ${A}" | BUILDING GAME FILES THEN CLEANING DIRECTORY..."
      for TYPE in sounds scenes materials particles models soundevents; do
        while ! grep -q "compiled," ${A}/${A}_build_${TYPE}.log 2> /dev/null; do
          if [ -e ${A}/${A}_build_${TYPE}.log ]; then
            echo ${A}": (waiting) retry: ${TYPE}_build..."
            read PAUSE
          fi
          "${G}"/../bin/win64/resourcecompiler.exe -nominidumps -v -r -i "C:/Program Files (x86)/Steam/steamapps/common/SteamVR/tools/steamvr_environments/content/steamtours_addons/${A}/${TYPE}/*" >> ${A}/${A}_build_${TYPE}.log
        done
        cat -s ${A}/${A}.txt ${A}/${A}_build_${TYPE}.log | sed -e "/File already exists/d" -e "/Failed to find compiler/d" > ${A}/_${A}.txt
        mv ${A}/_${A}.txt ${A}/${A}.txt
      done
      rm -fr ${A}/sounds/* ${A}/${A}_*_*.log
    fi > >(tee -a ${A}/${A}.txt) 2> >(tee -a ${A}/${A}.txt >&2)
  fi
  unset PRE_IMPORT_FIXES MODELS
}
##------------------------------------------------------------------------------ hl2
MODELS="alyx barney eli breen breen_monitor mossman monk odessa kleiner vortigaunt vortigaunt_slave humans/group01 humans/group02 humans/group03 humans/group03m props_animated_breakable/smokestack"
MAKE_ASSET_PACK "${S}/Half-Life 2/hl2" none "hl2_misc_dir.vpk" "hl2_textures_dir.vpk" "hl2_sound_misc_dir.vpk" "hl2_sound_vo_english_dir.vpk"
##------------------------------------------------------------------------------ hl2mp
MAKE_ASSET_PACK "${S}/Half-Life 2 Deathmatch/hl2mp" asset_pack_hl2 "hl2mp_pak_dir.vpk"
##------------------------------------------------------------------------------ lostcoast
MAKE_ASSET_PACK "${S}/Half-Life 2/lostcoast" asset_pack_hl2 "lostcoast_pak_dir.vpk"
##------------------------------------------------------------------------------ episodic
MODELS="alyx barney eli kleiner eli_monitor mossman kleiner_monitor"
MAKE_ASSET_PACK "${S}/Half-Life 2/episodic" asset_pack_hl2 "ep1_pak_dir.vpk"
##------------------------------------------------------------------------------ ep2
PRE_IMPORT_FIXES() {
  sed -i -e "s:skybox:nature:" ${A}/materials/nature/mountainscape.vmt ${A}/materials/nature/vista_card_12.vmt
}
MODELS="alyx barney eli kleiner alyx_interior vortigaunt vortigaunt_blue"
MAKE_ASSET_PACK "${S}/Half-Life 2/ep2" asset_pack_hl2 "ep2_pak_dir.vpk"
##------------------------------------------------------------------------------ dod
MAKE_ASSET_PACK "${S}/Day of Defeat Source/dod" asset_pack_hl2 "dod_pak_dir.vpk"
##------------------------------------------------------------------------------ cstrike
PRE_IMPORT_FIXES() {
  sed -i -e 's:nature/rockwall012a_normal:cs_havana/rockwall012a_normal:i' ${A}/materials/cs_havana/blendrockmoss002a.vmt
  sed -i -e 's:models\\\props\\\cs_office\\\computer2a:cs_havana/computer2a:i' ${A}/materials/cs_havana/computer2a.vmt
  sed -i -e 's:models\\\props\\\cs_office\\\computer2b:cs_havana/computer2b:i' ${A}/materials/cs_havana/computer2b.vmt
  sed -i -e 's:cs_office/filebox01file:cs_havana/filebox01file:i' ${A}/materials/cs_havana/filebox01file.vmt
  sed -i -e 's:overviews/fy_rockworld:cs_havana/fy_rockworld:i' ${A}/materials/cs_havana/fy_rockworld.vmt
  sed -i -e 's:buildings\\\gen02:cs_havana/gen02:i' ${A}/materials/cs_havana/gen02.vmt
  sed -i -e 's:fx\\\glow:cs_havana/glow:i' ${A}/materials/cs_havana/glow.vmt
  sed -i -e 's:models/cs_italy/ivy:cs_havana/ivy:i' ${A}/materials/cs_havana/ivy.vmt
  sed -i -e 's:models/cs_italy/ivy:cs_havana/ivy:i' ${A}/materials/cs_havana/ivy.vmt
  sed -i -e 's:models/cs_italy/ivyb:cs_havana/ivyb:i' ${A}/materials/cs_havana/ivyb.vmt
  sed -i -e 's:models/cs_italy/ivyb:cs_havana/ivyb:i' ${A}/materials/cs_havana/ivyb.vmt
  sed -i -e 's:models/de_dust/objects/palmbillboard:cs_havana/palmbillboard:i' ${A}/materials/cs_havana/palmbillboard.vmt
  sed -i -e 's:models/de_dust/objects/palm_tree01:cs_havana/palm_tree01:i' ${A}/materials/cs_havana/palm_tree01.vmt
  sed -i -e 's:models/props_pipes/pipemetal003a:cs_havana/pipemetal003a:i' ${A}/materials/cs_havana/pipemetal003a.vmt
  sed -i -e 's:models/cs_italy/planta:cs_havana/planta:i' ${A}/materials/cs_havana/planta.vmt
  sed -i -e 's:models/cs_italy/planta:cs_havana/planta:i' ${A}/materials/cs_havana/planta.vmt
  sed -i -e 's:models/cs_italy/plantb:cs_havana/plantb:i' ${A}/materials/cs_havana/plantb.vmt
  sed -i -e 's:models/cs_italy/plantb:cs_havana/plantb:i' ${A}/materials/cs_havana/plantb.vmt
  sed -i -e 's:models/cs_italy/railing:cs_havana/railing:i' ${A}/materials/cs_havana/railing.vmt
  sed -i -e 's:models/cs_italy/railing:cs_havana/railing:i' ${A}/materials/cs_havana/railing.vmt
  sed -i -e 's:nature/rockwall012a_normal:cs_havana/rockwall012a_normal:i' ${A}/materials/cs_havana/rockwall012a.vmt
  sed -i -e 's:models/pi_twig/twig:cs_havana/twig:i' ${A}/materials/cs_havana/twig.vmt
  sed -i -e 's:models/pi_twig/twig:cs_havana/twig:i' ${A}/materials/cs_havana/twig.vmt
  sed -i -e 's:cstrike/[{]2red_trellis02:cs_havana/\{2red_trellis02:i' ${A}/materials/cs_havana/\{2red_trellis02.vmt
  sed -i -e 's:cstrike/[{]blue:cs_havana/\{blue:i' ${A}/materials/cs_havana/\{blue.vmt
  sed -i -e 's:cstrike/[{]cstrike_le6lad:cs_havana/\{cstrike_le6lad:i' ${A}/materials/cs_havana/\{cstrike_le6lad.vmt
  sed -i -e 's:cstrike/[{]cstrike_oe4ven:cs_havana/\{cstrike_oe4ven:i' ${A}/materials/cs_havana/\{cstrike_oe4ven.vmt
  sed -i -e 's:cstrike/[{]hangingivy1:cs_havana/\{hangingivy1:i' ${A}/materials/cs_havana/\{hangingivy1.vmt
  sed -i -e 's:cstrike/[{]hangingivy2:cs_havana/\{hangingivy2:i' ${A}/materials/cs_havana/\{hangingivy2.vmt
  sed -i -e 's:cstrike/[{]hrpoint:cs_havana/\{hrpoint:i' ${A}/materials/cs_havana/\{hrpoint.vmt
  sed -i -e 's:cstrike/[{]invisible:cs_havana/\{invisible:i' ${A}/materials/cs_havana/\{invisible.vmt
  sed -i -e 's:cstrike/[{]k_rail01_hires:cs_havana/\{k_rail01_hires:i' ${A}/materials/cs_havana/\{k_rail01_hires.vmt
  sed -i -e 's:cstrike/[{]k_rail01_lores:cs_havana/\{k_rail01_lores:i' ${A}/materials/cs_havana/\{k_rail01_lores.vmt
  sed -i -e 's:cstrike/[{]ornategate:cs_havana/\{ornategate:i' ${A}/materials/cs_havana/\{ornategate.vmt
  sed -i -e 's:cstrike/[{]pylon:cs_havana/\{pylon:i' ${A}/materials/cs_havana/\{pylon.vmt
  sed -i -e 's:cstrike/[{]tk_plantlg:cs_havana/\{tk_plantlg:i' ${A}/materials/cs_havana/\{tk_plantlg.vmt
  sed -i -e 's:cstrike/[{]tk_plantsm:cs_havana/\{tk_plantsm:i' ${A}/materials/cs_havana/\{tk_plantsm.vmt
  sed -i -e 's:cstrike/[{]tk_railing:cs_havana/\{tk_railing:i' ${A}/materials/cs_havana/\{tk_railing.vmt
  sed -i -e 's:cstrike/[{]tk_steeldoor:cs_havana/\{tk_steeldoor:i' ${A}/materials/cs_havana/\{tk_steeldoor.vmt
  sed -i -e 's:cstrike/[{]tk_wwheel:cs_havana/\{tk_wwheel:i' ${A}/materials/cs_havana/\{tk_wwheel.vmt
}
MODELS="characters/hostage_01 characters/hostage_02 characters/hostage_03 characters/hostage_04"
MAKE_ASSET_PACK "${S}/Counter-Strike Source/cstrike" asset_pack_hl2 "cstrike_pak_dir.vpk"
##------------------------------------------------------------------------------ ship
MAKE_ASSET_PACK "${S}/The Ship Single Player/ship" asset_pack_hl2 "../vpks/depot_2402_dir.vpk" "../vpks/depot_2405_dir.vpk"
##------------------------------------------------------------------------------ pm
MAKE_ASSET_PACK "${S}/Bloody Good Time/pm" asset_pack_hl2 "../vpks/depot_2452_dir.vpk"
##------------------------------------------------------------------------------ dearesther
MAKE_ASSET_PACK "${S}/Dear Esther/dearesther" asset_pack_hl2
##------------------------------------------------------------------------------ thestanleyparable
MAKE_ASSET_PACK "${S}/The Stanley Parable/thestanleyparable" asset_pack_hl2
##------------------------------------------------------------------------------ dinodday
MAKE_ASSET_PACK "${S}/Dino D-Day/dinodday" asset_pack_hl2
##------------------------------------------------------------------------------ insurgency
PRE_IMPORT_FIXES() {
  echo -e "$(sed -e "s:}::i" ${A}/materials/models/foliage/tree6_1.vmt)\n}" > ${A}/materials/models/foliage/tree6_1.vmt
  echo "}" >> ${A}/materials/models/player/temp.vmt
  sed -i -e "/\/[*]/,/[*]\//d" ${A}/materials/models/player/ins_player_shared.vmt
}
MAKE_ASSET_PACK "${S}/insurgency2/insurgency" asset_pack_hl2 "insurgency_misc_dir.vpk" "insurgency_materials_dir.vpk" "insurgency_models_dir.vpk" "insurgency_particles_dir.vpk" "insurgency_sound_dir.vpk"
##------------------------------------------------------------------------------ revelations
PRE_IMPORT_FIXES() {
  mv -v ${A}/sounds/Revelations/Greg/Kulkukan_swing.wav ${A}/_cull 2> /dev/null
}
MODELS="players Revelations/priest/priest Revelations/MorphGun/gunmorph Revelations/weapons/viewmodels/v_gauntlet"
MAKE_ASSET_PACK "${S}/Revelations 2012/revelations" asset_pack_hl2
##------------------------------------------------------------------------------ berimbau
PRE_IMPORT_FIXES() {
  sed -i -e "s/Proxies\"/Proxies\"\{/" ${A}/materials/models/blades/caduceus/caduceus_flow.vmt ${A}/materials/models/blades/sonia/sonia_glow.vmt
  echo "}" >> ${A}/materials/models/blades/caduceus/caduceus_flow.vmt
  echo "}" >> ${A}/materials/models/blades/sonia/sonia_glow.vmt
}
MODELS="props_monastery/books* temple/tt_r* temple/tt_l* temple/tt_m* temple/gong temple/rock*"
MAKE_ASSET_PACK "${S}/Blade Symphony/berimbau" asset_pack_hl2
##------------------------------------------------------------------------------ mm
PRE_IMPORT_FIXES() {
  mv -v ${A}/scripts/game_sounds_header.txt ${A}/_cull 2> /dev/null
  sed -i -e "/\/\//d" ${A}/materials/nature/water_l04.vmt ${A}/materials/nature/water_l05_b.vmt ${A}/materials/nature/water_l06_c.vmt ${A}/materials/nature/water_l05_b_regen.vmt ${A}/materials/nature/water_l05_a.vmt
}
MAKE_ASSET_PACK "${S}/Dark Messiah Might and Magic Single Player/mm" asset_pack_hl2 "../vpks/depot_2101_dir.vpk" "../vpks/depot_2103_dir.vpk" "../vpks/depot_2104_dir.vpk" "../vpks/depot_2105_dir.vpk" "../vpks/depot_2106_dir.vpk" "../vpks/depot_2107_dir.vpk" "../vpks/depot_2108_dir.vpk"
##------------------------------------------------------------------------------ se1
PRE_IMPORT_FIXES() {
  rm -fvr ${A}/materials/models/hl2_materials ${A}/models/hl2_props
}
MAKE_ASSET_PACK "${S}/SiN Episodes Emergence/se1" asset_pack_hl2 "../vpks/depot_1301_dir.vpk" "../vpks/depot_1302_dir.vpk" "../vpks/depot_1303_dir.vpk"  "../vpks/depot_1304_dir.vpk"  "../vpks/depot_1305_dir.vpk" "../vpks/depot_1316_dir.vpk"
##------------------------------------------------------------------------------ frontend
MAKE_ASSET_PACK "${S}/Anarchy Arcade/frontend" asset_pack_hl2
##------------------------------------------------------------------------------ garrysmod
MODELS="hl1plr player/hostage"
MAKE_ASSET_PACK "${S}/GarrysMod/garrysmod" asset_pack_hl2 "fallbacks_dir.vpk" "garrysmod_dir.vpk"
##------------------------------------------------------------------------------ zenozoik
MODELS="_MANUAL_INSERTION_"
MAKE_ASSET_PACK "${S}/ZenoClash/zenozoik" asset_pack_hl2
##------------------------------------------------------------------------------ dystopia
MAKE_ASSET_PACK "${S}/Dystopia/dystopia" asset_pack_hl2
##------------------------------------------------------------------------------ neotokyosource
MAKE_ASSET_PACK "${S}/NEOTOKYO/neotokyosource" asset_pack_hl2
##------------------------------------------------------------------------------ mindlock
MAKE_ASSET_PACK "${S}/The Trap 2 Mindlock (beta)/mindlock" asset_pack_hl2
##------------------------------------------------------------------------------ eye
PRE_IMPORT_FIXES() {
  mv -v ${A}/materials/vgui/equipment/vgui_weapondefault_.vmt ${A}/materials/vgui/equipment/vgui_weapondefault.vmt 2> /dev/null
  convert_to_utf8 ${A}/materials/models/arches/candle_flame.vmt
  mv -v ${A}/scripts/game_sounds_reloads.txt ${A}/_cull
}
MAKE_ASSET_PACK "${S}/EYE/eye" asset_pack_hl2
##------------------------------------------------------------------------------ swarm
MODELS="_MANUAL_INSERTION_ aliens/drone/drone aliens/shieldbug/shieldbug aliens/harvester/harvester swarm/shieldbug/shieldbug swarm/drone/uberdrone swarm/drone/drone"
MAKE_ASSET_PACK "${S}/Alien Swarm/swarm" asset_pack_hl2 "pak01_dir.vpk"
##------------------------------------------------------------------------------ wilson_chronicles
MAKE_ASSET_PACK "${S}/Wilson Chronicles/wilson_chronicles" asset_pack_hl2
##------------------------------------------------------------------------------ fromearth
MODELS="breen kleiner mossman props_animated_breakable/smokestack aliens/scientist/female01 aliens/scientist/female02 aliens/police/female02 aliens/police/female03 aliens/police/male01 aliens/police/male02 aliens/police/male03 aliens/prisoner/female01"
MAKE_ASSET_PACK "${S}/From Earth/fromearth" asset_pack_hl2
##------------------------------------------------------------------------------ nucleardawn
PRE_IMPORT_FIXES() {
  sed -i -e "s:\t\"\$detailscale:\t//\"\$detailscale:" ${A}/materials/models/rts_structures/rts_armoury/rts_armoury_ct_displays.vmt ${A}/materials/models/rts_structures/rts_armoury/rts_armoury_emp_displays.vmt
}
MAKE_ASSET_PACK "${S}/Nuclear Dawn/nucleardawn" asset_pack_hl2 "pak01_dir.vpk"
##------------------------------------------------------------------------------ brainbread2
MAKE_ASSET_PACK "${S}/brainbread2/brainbread2" asset_pack_hl2 "../base/bb2_game_dir.vpk" "../base/misc_game_dir.vpk"
##------------------------------------------------------------------------------ fof
MODELS="elpaso/caboose elpaso/saloon_window1 elpaso/saloon_window3 elpaso/wtower elpaso/wtower2 elpaso/wtower2small"
MAKE_ASSET_PACK "${S}/Fistful of Frags/fof" asset_pack_hl2 "fof_dir.vpk" "fof2_dir.vpk"
##------------------------------------------------------------------------------ dab
PRE_IMPORT_FIXES() {
  mv -v ${A}/materials/models/stormy/da_floorlight_01_nor.vmt ${A}/_cull 2> /dev/null
  for FILE in "weapons/v_models/mossberg590/diffuse.vmt" "shells/12gauge/shell_12gauge.vmt" "weapons/v_models/mossberg590/mossberg590.vmt" "weapons/v_models/mossberg590/shotgun_shell.vmt"; do
    convert_to_utf8 ${A}/materials/models/${FILE}
  done
}
MODELS="characters/hostage_02"
MAKE_ASSET_PACK "${S}/Double Action/dab" asset_pack_hl2
##------------------------------------------------------------------------------ ageofchivalry
MAKE_ASSET_PACK "${S}/Source SDK Base 2007/ageofchivalry"
##------------------------------------------------------------------------------ esmod
PRE_IMPORT_FIXES() {
  convert_to_utf8 ${A}/materials/models/props_es/terminals/monitor.vmt
}
MODELS="capships/gm_destroyer_test"
MAKE_ASSET_PACK "${S}/Source SDK Base/esmod"
##------------------------------------------------------------------------------ estrangedact1
PRE_IMPORT_FIXES() {
  convert_to_utf8 ${A}/materials/models/www.gaming-models.de/baustellenset/baustellenbarke.vmt
}
MODELS="kleiner props_animated_breakable/smokestack weapons/v_pistol_dx7 humans/group01 humans/group02 humans/group03 humans/group03m"
MAKE_ASSET_PACK "${S}/Estranged Act I/estrangedact1" none "estranged_pack_dir.vpk"
##------------------------------------------------------------------------------ empires
MAKE_ASSET_PACK "${S}/Empires/empires" none "materials_dir.vpk" "materials_legacy_dir.vpk" "models_dir.vpk" "models_legacy_dir.vpk" "scripts_dir.vpk"
##------------------------------------------------------------------------------ consortium
PRE_IMPORT_FIXES() {
  mv -v ${A}/sounds/Zenlil_1/iss_sound/tree_group_45/"Pawn44+45_1-2-3-2+-0.wav" ${A}/_cull 2> /dev/null
}
MAKE_ASSET_PACK "${S}/Consortium/consortium" none
##------------------------------------------------------------------------------ zps
PRE_IMPORT_FIXES() {
  convert_to_utf8 ${A}/materials/models/survivors/survivor3/ring.vmt
  sed -i -e "s:/round_light:/zp_round_light:" ${A}/materials/zpcustommaterials/lights/zp_round_light.vmt
  sed -i -e "s:\"\$basetexture\"\t\"buildings:\"\$basetexture\" \"zpcustommaterials/buildings:" ${A}/materials/zpcustommaterials/buildings/gen03.vmt
  sed -i -e "s:gib_vanessa_body_bump:bloody/gib_vanessa_body_bump:" ${A}/materials/models/survivors/vanessa/bloody/gib_vanessa_body_hair.vmt
  sed -i -e "s:gib_vanessa_hair_bump:bloody/gib_vanessa_hair_bump:" ${A}/materials/models/survivors/vanessa/bloody/gib_vanessa_hair.vmt
  sed -i -e "s:normal\":normalmap\":" ${A}/materials/models/survivors/survivor5/diffuse_infected.vmt
  sed -i -e "s:normal\":normalmap\":" ${A}/materials/models/survivors/survivor5/hair.vmt
  sed -i -e "s:_bump:_normal:" ${A}/materials/models/survivors/survivor4/bloody/gib_punker_hair_infected.vmt
  sed -i -e "s:_bump:_normal:" ${A}/materials/models/survivors/survivor4/bloody/gib_punker_hair.vmt
}
MODELS="propper/harvest/cabinet_handle01 zpprops/farmhaydark zpprops/farmhaylight"
MAKE_ASSET_PACK "${S}/Zombie Panic Source/zps" asset_pack_hl2 "../vpks/zps_content_dir.vpk"
##------------------------------------------------------------------------------ nmrih
PRE_IMPORT_FIXES() {
  mv -v ${A}/particles/nmrih_molotov.pcf ${A}/particles/nmrih_molotov._pcf 2> /dev/null
  sed -i -e "s:Wally head :Wally_head_:gi" ${A}/materials/models/player/wally/nmrih_wally_glasses.vmt
  sed -i -e "s:Wally body normal:Wally_body_normal:gi" ${A}/materials/models/player/wally/wally_body_diffuse.vmt
  sed -i -e "s:ceiling light:ceiling_light:gi" ${A}/materials/models/props/hospital/ceiling_light_on.vmt
}
MODELS="props/interior/cereal_box props/objectives/cj_propanetank"
MAKE_ASSET_PACK "${S}/nmrih/nmrih" asset_pack_hl2 "nmrih_dir.vpk"
##------------------------------------------------------------------------------ gstringv2
PRE_IMPORT_FIXES() {
  mv -v ${A}/sounds/ambient/energy/spark4.wav ${A}/_cull 2> /dev/null
  mv -v ${A}/sounds/ambient/energy/spark5.wav ${A}/_cull 2> /dev/null
  mv -v ${A}/sounds/ambient/energy/zap7.wav ${A}/_cull 2> /dev/null
  mv -v ${A}/sounds/ambient/energy/zap8.wav ${A}/_cull 2> /dev/null
  mv -v ${A}/sounds/ambient/energy/zap9.wav ${A}/_cull 2> /dev/null
  mv -v ${A}/sounds/augmented/construction/scanner_track.wav ${A}/_cull 2> /dev/null
  mv -v ${A}/sounds/story_specific/equip_hum.wav ${A}/_cull 2> /dev/null
  mv -v ${A}/sounds/war/uneasy.wav ${A}/_cull 2> /dev/null
  mv -v ${A}/sounds/wasteland_soundscape_rain/thunder2.wav ${A}/_cull 2> /dev/null
  mv -v ${A}/sounds/weapons/physcannon/hold_loop.wav ${A}/_cull 2> /dev/null
  mv -v ${A}/materials/skybox/orbit_sky_cube.vtf ${A}/_cull 2> /dev/null
}
MAKE_ASSET_PACK "${S}/G String/gstringv2" asset_pack_hl2 "gstringv2_dir.vpk"
##------------------------------------------------------------------------------ contagion
MODELS="survivors/male/eugene survivors/male/eugene_young"
MAKE_ASSET_PACK "${S}/Contagion/contagion" asset_pack_hl2 "../vpks/materials_dir.vpk" "../vpks/models_dir.vpk" "../vpks/scripts_dir.vpk"
##------------------------------------------------------------------------------ tacint XXX forgot some cruft tgas in content, they are there now but not used in a build
PRE_IMPORT_FIXES() {
  mv -v ${A}/particles/ti_explodefx_props.pcf ${A}/_cull 2> /dev/null
}
MAKE_ASSET_PACK "${S}/TacticalIntervention/tacint" asset_pack_hl2 "data_001_dir.vpk"
##------------------------------------------------------------------------------ left4dead2
PRE_IMPORT_FIXES() {
  mv -v ${A}/materials/dons_decals/serviet_*.vmt ${A}/_cull 2> /dev/null
  mv -v ${A}/scripts/soundscapes_airport.txt ${A}/_cull 2> /dev/null
}
MODELS="c1_chargerexit/doors_glass_5 c1_chargerexit/doors_glass_6 c1_chargerexit/plywood_cent"
MODELS="${MODELS} c5_bridge_destruction/bridge_left_tower c5_bridge_destruction/bridge_right_tower c5m3_bridge_overpass_debris/bridgedebris_set_a"
MODELS="${MODELS} destruction_tanker/destruction_tanker_debris_1 destruction_tanker/destruction_tanker_debris_2 destruction_tanker/destruction_tanker_debris_4"
MODELS="${MODELS} hybridphysx/map1_tarp_4 hybridphysx/map1_tarp_3 hybridphysx/map1_tarp_2 hybridphysx/map1_tarp_1"
MODELS="${MODELS} hybridphysx/gasstationpart_5 hybridphysx/gasstationpart_4 hybridphysx/gasstationpart_3 hybridphysx/gasstationpart_2 hybridphysx/gasstationpart_1"
MODELS="${MODELS} hybridphysx/airliner_left_wing_secondary hybridphysx/airliner_fuselage_secondary_4 hybridphysx/airliner_fuselage_secondary_3 hybridphysx/airliner_fuselage_secondary_2 hybridphysx/airliner_fuselage_secondary_1"
MODELS="${MODELS} props_destruction/general_dest_concrete_set props_destruction/general_dest_roof_set"
MODELS="${MODELS} infected survivors/survivor_biker survivors/survivor_biker_light survivors/survivor_coach survivors/survivor_gambler survivors/survivor_manager survivors/survivor_mechanic survivors/survivor_producer survivors/survivor_namvet survivors/survivor_teenangst survivors/survivor_teenangst_light"
MAKE_ASSET_PACK "${S}/Left 4 Dead 2/left4dead2" none "pak01_dir.vpk" "../left4dead2_dlc1/pak01_dir.vpk" "../left4dead2_dlc2/pak01_dir.vpk" "../left4dead2_dlc3/pak01_dir.vpk"  "../other_loose_files.vpk"
##------------------------------------------------------------------------------ infra
PRE_IMPORT_FIXES() {
  mv -v ${A}/sounds/world/plane_overpass.wav ${A}/_cull 2> /dev/null
}
MAKE_ASSET_PACK "${S}/infra/infra" asset_pack_hl2 "pak01_dir.vpk" "pak02_dir.vpk"
##------------------------------------------------------------------------------ p3
PRE_IMPORT_FIXES() {
  find ${A}/materials/ -name *.vmt | while read FILE; do convert_to_utf8 ${FILE}; done
}
MODELS="_MANUAL_INSERTION_ characters"
MODELS="${MODELS} pornworld/sex_set_03_a pornworld/sex_set_03_a_damage pornworld/sex_set_03_b"
MODELS="${MODELS} pornworld/sex_set_03_b_damage pornworld/sex_set_03_c"
MODELS="${MODELS} pornworld/sex_set_03_c_damage pornworld/sex_set_03_d"
MODELS="${MODELS} pornworld/sex_set_03_d_damage pornworld/sex_set_04_a_damage"
MODELS="${MODELS} pornworld/sex_set_04_b pornworld/sex_set_04_b_damage"
MODELS="${MODELS} pornworld/sex_set_04_c pornworld/sex_set_04_c_damage"
MODELS="${MODELS} pornworld/sex_set_04_d pornworld/sex_set_04_d_damage"
MODELS="${MODELS} small_things/cow_pad small_things/drocha_01 small_things/office_papers_01_d_damage small_things/office_papers_01_i_damage small_things/office_papers_01_j_damage test/testHouse"
MODELS="${MODELS} weapons/bat/bat_rotate_flight weapons/bat/dat_rotate_flight"
MAKE_ASSET_PACK "${S}/Postal III/p3" asset_pack_hl2 "p3_english_stuff.vpk"
##------------------------------------------------------------------------------ csgo (OOD)
PRE_IMPORT_FIXES() {
  convert_to_utf8 ${A}/materials/models/props_foliage/vines_001.vmt
  mv -v ${A}/materials/de_mirage/ground/de_mirage_ground_tilec_blend_diffuse_.vmt ${A}/materials/de_mirage/ground/de_mirage_ground_tilec_blend_diffuse.vmt 2> /dev/null
  mv -v ${A}/materials/de_mirage/ground/de_mirage_ground_tileh_blend_diffuse_.vmt ${A}/materials/de_mirage/ground/de_mirage_ground_tileh_blend_diffuse.vmt 2> /dev/null
  mv -v ${A}/materials/de_mirage/ground/de_mirage_tileg_diffuse_.vmt ${A}/materials/de_mirage/ground/de_mirage_tileg_diffuse.vmt 2> /dev/null
  mv -v ${A}/materials/de_mirage/brick/de_mirage_brick_ver1_blend_diffuse_.vmt ${A}/materials/de_mirage/brick/de_mirage_brick_ver1_blend_diffuse.vmt 2> /dev/null
  mv -v ${A}/materials/de_mirage/base/de_mirage_base_trim_ver1_diffuse_.vmt ${A}/materials/de_mirage/base/de_mirage_base_trim_ver1_diffuse.vmt 2> /dev/null
}
MODELS="weapons/v_rif_m4a1_s player/custom_player/legacy/ctm_diver_varianta"
MAKE_ASSET_PACK "${S}/Counter-Strike Global Offensive/csgo" asset_pack_hl2 "pak01_dir.vpk"
##------------------------------------------------------------------------------ bms
PRE_IMPORT_FIXES() {
  convert_to_utf8 ${A}/materials/models/xenians/houndeye/houndeye.vmt
}
MODELS="player/mp_scientist humans/guard humans/guard_hurt humans/guard_02 humans/marine humans/marine_sg humans/marine_02 humans/marine_02_sg humans/masked_marine humans/masked_marine_02 humans/masked_marine_02_sg humans/masked_marine_sg humans/scientist_eli"
MODELS="${MODELS} player/mp_guard player/mp_guard_02 player/mp_marine player/mp_marine_02 player/mp_scientist_02"
MODELS="${MODELS} props_xen/c4a1a-island-c1a/c4a1a-island-c1a039 props_xen/c4a1a-island-c1a/c4a1a-island-c1a037 props_xen/c4a1a-island-c1a/c4a1a-island-c1a036 props_xen/c4a1a-island-c1a/c4a1a-island-c1a034 props_xen/c4a1a-island-c1a/c4a1a-island-c1a015 props_xen/c4a1a-island-c1a/c4a1a-island-c1a014 props_xen/c4a1a-island-c1a/c4a1a-island-c1a013 props_xen/c4a1a-island-c1a/c4a1a-island-c1a012 props_xen/c4a1a-island-c1a/c4a1a-island-c1a011 props_xen/c4a1a-island-c1a/c4a1a-island-c1a003"
MODELS="${MODELS} props_xen/rocks/crystals/c4a2a_crystal_cavern_cluster_large_1b props_xen/rocks/crystals/c4a2a_crystal_cavern_geode_1b props_xen/rocks/crystals/c4a2a_crystal_cavern_geode_small_1b props_xen/rocks/crystals/c4a2a_crystal_cavern_geode_small_1a"
MAKE_ASSET_PACK "${S}/Black Mesa/bms" asset_pack_hl2 "bms_materials_dir.vpk" "bms_models_dir.vpk" "bms_textures_dir.vpk" "bms_sounds_misc_dir.vpk" "bms_sound_vo_english_dir.vpk" "bms_misc_dir.vpk"
##------------------------------------------------------------------------------ portal2
PRE_IMPORT_FIXES() {
  mv -v ${A}/sounds/vo ${A}/_cull 2> /dev/null
  sed -i -e "s/.4\`/.4/" ${A}/materials/metal/black_wall_metal_005a_top.vmt ${A}/materials/nature/dirtfloor004d.vmt
}
MAKE_ASSET_PACK "${S}/Portal 2/portal2" none "pak01_dir.vpk" "../portal2_dlc1/pak01_dir.vpk" "../portal2_dlc2/pak01_dir.vpk" "../other_loose_files_in_dlc_folders.vpk"
##------------------------------------------------------------------------------ portal_stories
PRE_IMPORT_FIXES() {
  mv -v ${A}/scripts/game_sounds_ps_virgil_autogenerated.txt ${A}/_cull 2> /dev/null
}
MAKE_ASSET_PACK "${S}/Portal Stories Mel/portal_stories" asset_pack_portal2 "pak01_dir.vpk"
##------------------------------------------------------------------------------ aperturetag
MAKE_ASSET_PACK "${S}/Aperture Tag/aperturetag" asset_pack_portal2 "pak01_dir.vpk"
##------------------------------------------------------------------------------ EXPERIMENTAL: VAMPIRE XXX ttz/h smd+qc files erased, still version 2
MODELS="character/monster/animalism_beastform/animalism_beastform_mdl character/shared/male/allsequences_mdl character/shared/male/npc_allsequences_mdl character/shared/male/pcidles_allsequences_mdl character/shared/female/npc_allsequences_mdl character/shared/female/pcidles_allsequences_mdl character/shared/female/allsequences_mdl"
MAKE_ASSET_PACK "${S}/Vampire The Masquerade - Bloodlines/vampire" none
##------------------------------------------------------------------------------ EXPERIMENTAL: TF XXX models seemingly have to be done by hand cause of 260 character limit
PRE_IMPORT_FIXES() {
  convert_to_utf8 ${A}/materials/models/player/items/demo/demo_parrot_s2.vmt
  convert_to_utf8 ${A}/materials/models/player/items/demo/demo_parrot_s3.vmt
}
MAKE_ASSET_PACK "${S}/Team Fortress 2/tf" asset_pack_hl2 "tf2_sound_misc_dir.vpk"  "tf2_sound_vo_english_dir.vpk" "tf2_misc_dir.vpk" "tf2_textures_dir.vpk"
##------------------------------------------------------------------------------ EXPERIMENTAL: HFS #needed HFSExtract to work other script culls(kobald and vampire directory)!?
PRE_IMPORT_FIXES() {
  rm -fr ${A}/models/armor ${A}/materials/models/armor ${A}/_cull/ 2> /dev/null
  rm -fr ${A}/models/event ${A}/materials/models/event ${A}/_cull/ 2> /dev/null
  rm -fr ${A}/models/rear ${A}/materials/models/rear ${A}/_cull/ 2> /dev/null
  mv -v ${A}/models/weapon ${A}/_cull/ 2> /dev/null
  mv -v ${A}/models/materials/weapon ${A}/_cull/materials/ 2> /dev/null
  mkdir -p ${A}/materials/models/weapon ${A}/models/weapon 2> /dev/null
  mv -v ${A}/_cull/weapon/monster ${A}/models/weapon 2> /dev/null
  mv -v ${A}/_cull/weapon/npc ${A}/models/weapon 2> /dev/null
  mv -v ${A}/_cull/weapon/pet ${A}/models/weapon 2> /dev/null
  mv -v ${A}/_cull/materials/weapon/monster ${A}/materials/models/weapon 2> /dev/null
  mv -v ${A}/_cull/materials/weapon/npc ${A}/materials/models/weapon 2> /dev/null
  mv -v ${A}/_cull/materials/weapon/pet ${A}/materials/models/weapon 2> /dev/null
  rm -fr ${A}/_cull/weapon ${A}/_cull/materials/weapon
  find asset_pack_hfs/materials/ -name "*.vmat" -exec sed -i -e "s:TextureGlossiness\t\".\"://TextureGlossiness\t\".\":" {} \;
}
MAKE_ASSET_PACK "/mnt/c/Users/byteframe/Desktop/hfs/hfs" asset_pack_hl2
##------------------------------------------------------------------------------ EXPERIMENTAL: r1 (beta torrent)
MODELS="robots/marvin/marvin robots/marvin/marvin_no_jiggle_mdl weapons/arms/pov_pilot_female_dm"
MODELS="${MODELS} weapons/arms/pov_mcor_pilot_male_cq weapons/arms/pov_imc_pilot_male_cq"
MODELS="${MODELS} weapons/arms/pov_imc_spectre weapons/arms/pov_imc_pilot_male_dm weapons/arms/pov_pilot_female_cq weapons/arms/pov_pilot_female_br weapons/arms/pov_mcor_spectre_assault"
MODELS="${MODELS} weapons/arms/pov_mcor_pilot_male_dm weapons/arms/pov_mcor_pilot_male_br models/weapons/arms/pov_imc_pilot_male_br"
MAKE_ASSET_PACK "/mnt/c/Users/byteframe/Desktop/titanfall/r1"