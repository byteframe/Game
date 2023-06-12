#!/bin/sh
D=/mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/common
S=/mnt/s/SteamLibrary/steamapps/common
C=${D}/SteamVR/tools/steamvr_environments/content/steamtours_addons
G=${D}/SteamVR/tools/steamvr_environments/game/steamtours_addons
W=/mnt/c/Users/byteframe/Downloads/source1import-master
N=/mnt/c/Program\ Files/Notepad++/notepad++.exe
B=${1}
header()
{
  echo -e "\n--------------------------------------------------------------------------------"
  echo ${1}
  echo "--------------------------------------------------------------------------------"
  sleep 1
}
pause()
{
  if [ ! -z ${FAST} ]; then
    PAUSE=fast
    sleep 10
  else
    read PAUSE
  fi
}
extract_vpk()
{
  header "${A} | VPK ${1}" | tee -a ${A}/${A}.txt
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
convert_to_utf8()
{
  iconv -f WINDOWS-1250 -t UTF-8 ${1} > utf8.out
  mv -v utf8.out ${1}
}
MAKE_ASSET_PACK()
{
  A=asset_pack_"${1/*\//}${SUFFIX}"
  if [ ${A} == "${B}" ] || [[ -z ${B} && ! -d "${C}"/${A} && ! -d "${G}"/${A} ]]; then
    cd "${C}"
    if [ ! -z ${DELETE} ]; then
      header "${A} | (waiting) CONFIRMING DELETE REQUEST... {*}"
      read PAUSE
      if [ ${PAUSE} == 'Y' ]; then
        rm -fr ${A} "${G}"/${A}
      else
        exit 1
      fi
    fi
    if [[ ! -d "${C}"/${A} && ! -d "${G}"/${A} ]]; then
      header "${A} | INITIALZING ASSET PACK AND CULLING FILES... {*}"
      rsync -a --info=progress2 --prune-empty-dirs --exclude='*.bik' --exclude='maps/' --exclude='bin/' --exclude='media/' --exclude='resource/' --exclude="*.vpk*" "${1}"/* ${A}/
      for VAR in "$@"; do
        if [[ ${VAR} == *.vpk* ]]; then
          extract_vpk "${1}"/"${VAR}"
        fi
      done
    fi
    mkdir -p ${A}/_cull/materials/dev ${A}/sounds "${G}"/${A}
    if [ -z ${INITIALIZE_ONLY} ]; then
      {
        header "${A} | PREPPING SOURCE FILES {!}"
        mv ${A}/sound/* ${A}/sounds
        mv -v ${A}/materials/dev/* ${A}/_cull/materials/dev/
        for FILE in "dev_normal.vtf" "dev_camera_shared.vmt" "null.vtf" "water*"  "invisible*" "replay_noise*" "dev_ram_512*" \
        "flat_normal*" "fus_normal*" "flatnormal*" "pom_test*" "dev_com*monitor*" \
        "devnormalmap.vtf" "*wall*"  "*floor*"  "cont_*" "dev_tvmonitor*" \
        "dev_combinescanline.vtf"  "dev_scanline*"  "dev_measurecrate*" \
        "dev_monitor.vtf"  "dev_lower"  "Blue_Building_textures_light.vtf"; do
          mv -v ${A}/_cull/materials/dev/${FILE} ${A}/materials/dev/ 2> /dev/null
        done
        cp black.vtf white.vtf ${A}/materials/
        find ${A}/materials/ -name "*.VTF" | while read FILE; do mv ${FILE} ${FILE:0:(-4)}.vtf_; mv -v ${FILE:0:(-4)}.vtf_ ${FILE:0:(-4)}.vtf; done
        find ${A}/materials/ -name "*.vmt" -exec sed -i -e "/\[\$[xX]360\]/d" -e "s/\s*\[\$WIN32\]//" -e s:$'\x93':\":g -e s:$'\x94':\":g {} \;
        find ${A}/ -name "*\ *" -type d | tac | while read DIR; do
          for FILE in "${DIR}"/*.vmt; do
            DIR_SHORT="${DIR/${A}\/materials\//}"
            sed -i -e "s:${DIR_SHORT}:${DIR_SHORT// /_}:gi" "${FILE}"
          done
          mv -v "${DIR}" "${DIR// /_}"
        done
        find ${A}/ -name "*\ *" -type f | tac | while read FILE; do
          if [[ "${FILE}" == *.vmt ]]; then
            FILE_SHORT1="${FILE/${A}\/materials\//}"
            FILE_SHORT2="${FILE_SHORT1// /_}"
            sed -i -e "s:${FILE_SHORT1/.vmt/}:${FILE_SHORT2/.vmt/}:gi" "${FILE}"
          fi
          mv -v "${FILE}" "${FILE// /_}"
        done
        find ${A}/materials/console/ ${A}/materials/vgui/chapters/ ${A}/materials/vgui/backgrounds/ -type f \
        -name background0* -or -name background_menu.* -or -name loading_screen_background.* -or -name coopcommentary_chapter* -or -name background_menu_widescreen.* -or \
        -name loading.* -or -name intro.* -or -name intro_widescreen.* -or -name startup_loading.* -or \
        -name startup.* -or -name console_background.* -or -name chapter* | while read FILE; do
          if [[ "${FILE}" != *-* ]] && [ ! -d "${FILE}" ]; then
            if [[ "${FILE}" == *.vmt ]]; then
              FILE_SHORT="${FILE/${A}\/materials\//}"
              sed -i -e "s:${FILE_SHORT/.vmt/}:${FILE_SHORT/.vmt/}-${A:11}:gi" "${FILE}"
            fi
            mv -v "${FILE}" "${FILE/./-${A:11}.}"
          fi
        done
        mv -v ${A}/sounds/common/talk.wav ${A}/_cull 2> /dev/null
        sed -i -e "s/\.\././g" "${C}"/${A}/scripts/game_sounds*.txt
        find ${A}/scripts -name "soundscape*.*" -or -name "game_sound*.txt" | while read FILE; do convert_to_utf8 "${FILE}"; done
        if [ ! -z ${PRE_IMPORT_FIXES} ]; then
          PRE_IMPORT_FIXES
        fi

        header "${A} | (waiting) NOW RUN VTFEDIT MANUALLY FOR VTF CONVERSION..."
        check_vtf_conversion()
        {
          header "${A} | (${1}) CHECKING/DELETING CONVERTED VTF..."
          echo "vtf count: $(find ${A}/materials -name "*.vtf" | wc -l)"
          find ${A}/materials/ -name "*.vtf" | while read FILE; do
            if [ -e ${FILE/.vtf/.tga} ]; then
              rm ${FILE}
            else
              echo "warning: ${1} did not convert: ${FILE}"
            fi
          done
          echo "tga count: $(find ${A}/materials -name "*.tga" | wc -l)"
        }
        if [ ! -d "${W}"/../materials ]; then
          mv ${A}/materials "${W}"/../materials
        fi
        read PAUSE_FOR_MANUAL_VTFEDIT
        if [ ! -d ${A}/materials ] && [ -d "${W}"/../materials ]; then
          mv -v "${W}"/../materials ${A}
        fi
        check_vtf_conversion vtfedit
        python3 -m no_vtf -l tga -h pfm "${C}"/${A}/materials
        check_vtf_conversion no_vtf

        header "${A} | (waiting) RUNNING CONVERSION SCRIPTS AND BLACKLISTING MODEL..."
        pause
        for TYPE in materials models particles scripts scenes; do
          unset PAUSE
          while [ -z ${PAUSE} ]; do
            python "${W}"/utils/${TYPE}_import.py -i "${C}"/${A} -e "${C}"/${A}
            echo "${A}: waiting (empty to retry): ${TYPE}_import..."
            pause
          done
        done
        for MODEL in ${MODELS}; do
          if [ -d ${A}/models/${MODEL} ]; then
            find ${A}/models/${MODEL}/ -name "*.vmdl" -exec sed -i -e "s/\.mdl/_mdl/" {} \;
          else
            sed -i -e "s/\.mdl/_mdl/" ${A}/models/${MODEL}.vmdl
          fi
        done

        header "${A} | (waiting) CHECKING FOR VMAT ERRORS, THEN BUILDING GAME FILES..."
        find ${A}/materials -name *.vmat | while read FILE; do
          if grep -q "\"None\"" "${FILE}" || grep -q "4.vfx" "${FILE}"; then
            echo ${FILE}
            cat "${FILE}"
            cat "${FILE/.vmat/.vmt}"
          fi
        done
        cat "${G}"/../steamtours/gameinfo.gi | grep asset_pack
        pause
        for TYPE in sounds scenes materials particles models soundevents; do
          unset PAUSE
          while [ -z ${PAUSE} ]; do
            "${G}"/../bin/win64/resourcecompiler.exe -r -i "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\content\steamtours_addons\\\\${A}\\\\${TYPE}\*"
            echo "${A}: waiting (empty to retry): ${TYPE}..."
            pause
          done
        done
        echo "\"AddonInfo\"{\"Dependencies\"{}}" > "${G}"/${A}/addoninfo.txt
      } > >(tee -a ${A}/${A}.txt) 2> >(tee -a ${A}/${A}.txt >&2)
      sed -i "/Failed to find compiler/d" ${A}/${A}.txt
    fi
  fi
  unset PRE_IMPORT_FIXES MODELS
}
##------------------------------------------------------------------------------ dearesther
MAKE_ASSET_PACK "${S}/Dear Esther/dearesther" none
##------------------------------------------------------------------------------ thestanleyparable
MAKE_ASSET_PACK "${S}/The Stanley Parable/thestanleyparable" none
##------------------------------------------------------------------------------ dinodday
MAKE_ASSET_PACK "${S}/Dino D-Day/dinodday" none
##------------------------------------------------------------------------------ ship
MAKE_ASSET_PACK "${S}/The Ship Single Player/ship" none "../vpks/depot_2402_dir.vpk" "../vpks/depot_2405_dir.vpk"
##------------------------------------------------------------------------------ pm
PRE_IMPORT_FIXES()
{
  sed -i -e "s/.5\`/.5/" ${A}/scripts/game_sounds_weapons.txt
}
MAKE_ASSET_PACK "${S}/Bloody Good Time/pm" none "../vpks/depot_2452_dir.vpk"
##------------------------------------------------------------------------------ insurgency
PRE_IMPORT_FIXES()
{
  echo -e "$(sed -e "s:}::i" ${A}/materials/models/foliage/tree6_1.vmt)\n}" > ${A}/materials/models/foliage/tree6_1.vmt
  echo "}" >> ${A}/materials/models/player/temp.vmt
  sed -i -e "/\/[*]/,/[*]\//d" ${A}/materials/models/player/ins_player_shared.vmt
}
MAKE_ASSET_PACK "${S}/insurgency2/insurgency" none "insurgency_misc_dir.vpk" "insurgency_materials_dir.vpk" "insurgency_models_dir.vpk" "insurgency_particles_dir.vpk" "insurgency_sound_dir.vpk"
##------------------------------------------------------------------------------ revelations
PRE_IMPORT_FIXES()
{
  mv -v ${A}/sounds/Revelations/Greg/Kulkukan_swing.wav ${A}/_cull 2> /dev/null
}
MODELS="players Revelations/priest/priest Revelations/MorphGun/gunmorph Revelations/weapons/viewmodels/v_gauntlet"
MAKE_ASSET_PACK "${S}/Revelations 2012/revelations" none
##------------------------------------------------------------------------------ berimbau
PRE_IMPORT_FIXES()
{
  sed -i -e "s/Proxies\"/Proxies\"\{/" ${A}/materials/models/blades/caduceus/caduceus_flow.vmt
  echo "}" >> ${A}/materials/models/blades/caduceus/caduceus_flow.vmt
  sed -i -e "s/Proxies\"/Proxies\"\{/" ${A}/materials/models/blades/sonia/sonia_glow.vmt
  echo "}" >> ${A}/materials/models/blades/sonia/sonia_glow.vmt
}
MODELS="props_monastery/books* temple/tt_r* temple/tt_l* temple/tt_m* temple/gong temple/rock*"
MAKE_ASSET_PACK "${S}/Blade Symphony/berimbau" none
##------------------------------------------------------------------------------ mm
PRE_IMPORT_FIXES()
{
  mv -v ${A}/scripts/game_sounds_header.txt ${A}/_cull 2> /dev/null
  sed -i -e "/\/\//d" ${A}/materials/nature/water_l04.vmt
  sed -i -e "/\/\//d" ${A}/materials/nature/water_l05_b.vmt
  sed -i -e "/\/\//d" ${A}/materials/nature/water_l06_c.vmt
  sed -i -e "/\/\//d" ${A}/materials/nature/water_l05_b_regen.vmt
  sed -i -e "/\/\//d" ${A}/materials/nature/water_l05_a.vmt
}
MAKE_ASSET_PACK "${S}/Dark Messiah Might and Magic Single Player/mm" none "../vpks/depot_2101_dir.vpk" "../vpks/depot_2103_dir.vpk" "../vpks/depot_2104_dir.vpk" "../vpks/depot_2105_dir.vpk" "../vpks/depot_2106_dir.vpk" "../vpks/depot_2107_dir.vpk" "../vpks/depot_2108_dir.vpk"
##------------------------------------------------------------------------------ contagion
MODELS="survivors/male/eugene survivors/male/eugene_young"
PRE_IMPORT_FIXES()
{
  mv -v ${A}/materials/models/props_train_station/tower_sign01__diff.vmt ${A}/materials/models/props_train_station/tower_sign01_diff.vmt 2> /dev/null
  mv -v ${A}/materials/models/props_downtown/ciggerett__can01_diff.vtf ${A}/materials/models/props_downtown/ciggerett_can01_diff.vtf 2> /dev/null
  mv -v ${A}/materials/models/props_biotec/biotec_garden__sculpt.vmt ${A}/materials/models/props_biotec/biotec_garden_sculpt.vmt 2> /dev/null
}
MAKE_ASSET_PACK "${S}/Contagion/contagion" none "../vpks/materials_dir.vpk" "../vpks/models_dir.vpk" "../vpks/scripts_dir.vpk"
##------------------------------------------------------------------------------ eye
PRE_IMPORT_FIXES()
{
  mv -v ${A}/materials/vgui/equipment/vgui_weapondefault_.vmt ${A}/materials/vgui/equipment/vgui_weapondefault.vmt 2> /dev/null
  convert_to_utf8 ${A}/materials/models/arches/candle_flame.vmt
  mv -v ${A}/scripts/game_sounds_reloads.txt ${A}/_cull
}
MAKE_ASSET_PACK "${S}/EYE/eye" none
##------------------------------------------------------------------------------ zenozoik
MAKE_ASSET_PACK "${S}/ZenoClash/zenozoik" none
##------------------------------------------------------------------------------ left4dead2
PRE_IMPORT_FIXES()
{
  mv -v ${A}/materials/dons_decals/serviet_*.vmt ${A}/_cull 2> /dev/null
  mv -v ${A}/scripts/soundscapes_airport.txt ${A}/_cull 2> /dev/null
}
MODELS="breen kleiner mossman props_animated_breakable/smokestack aliens/scientist/female01 aliens/scientist/female02 aliens/police/female02 aliens/police/female03 aliens/police/male01 aliens/police/male02 aliens/police/male03 aliens/prisoner/female01"
MAKE_ASSET_PACK "${S}/From Earth/fromearth" none
##------------------------------------------------------------------------------
MODELS="c1_chargerexit/doors_glass_5 c1_chargerexit/doors_glass_6 c1_chargerexit/plywood_cent"
MODELS="${MODELS} c5_bridge_destruction/bridge_left_tower c5_bridge_destruction/bridge_right_tower c5m3_bridge_overpass_debris/bridgedebris_set_a"
MODELS="${MODELS} destruction_tanker/destruction_tanker_debris_1 destruction_tanker/destruction_tanker_debris_2 destruction_tanker/destruction_tanker_debris_4"
MODELS="${MODELS} hybridphysx/map1_tarp_4 hybridphysx/map1_tarp_3 hybridphysx/map1_tarp_2 hybridphysx/map1_tarp_1"
MODELS="${MODELS} hybridphysx/gasstationpart_5 hybridphysx/gasstationpart_4 hybridphysx/gasstationpart_3 hybridphysx/gasstationpart_2 hybridphysx/gasstationpart_1"
MODELS="${MODELS} hybridphysx/airliner_left_wing_secondary hybridphysx/airliner_fuselage_secondary_4 hybridphysx/airliner_fuselage_secondary_3 hybridphysx/airliner_fuselage_secondary_2 hybridphysx/airliner_fuselage_secondary_1"
MODELS="${MODELS} props_destruction/general_dest_concrete_set props_destruction/general_dest_roof_set"
MODELS="${MODELS} infected survivors/survivor_biker survivors/survivor_biker_light survivors/survivor_coach survivors/survivor_gambler survivors/survivor_manager survivors/survivor_mechanic survivors/survivor_producer survivors/survivor_namvet survivors/survivor_teenangst survivors/survivor_teenangst_light"
MAKE_ASSET_PACK "${S}/Left 4 Dead 2/left4dead2" none "pak01_dir.vpk" "../left4dead2_dlc1/pak01_dir.vpk" "../left4dead2_dlc2/pak01_dir.vpk" "../left4dead2_dlc3/pak01_dir.vpk"  "../other_loose_files.vpk"
##------------------------------------------------------------------------------ csgo
PRE_IMPORT_FIXES()
{
  mv -v ${A}/materials/de_mirage/ground/de_mirage_ground_tilec_blend_diffuse_.vmt ${A}/materials/de_mirage/ground/de_mirage_ground_tilec_blend_diffuse.vmt 2> /dev/null
  mv -v ${A}/materials/de_mirage/ground/de_mirage_ground_tileh_blend_diffuse_.vmt ${A}/materials/de_mirage/ground/de_mirage_ground_tileh_blend_diffuse.vmt 2> /dev/null
  mv -v ${A}/materials/de_mirage/ground/de_mirage_tileg_diffuse_.vmt ${A}/materials/de_mirage/ground/de_mirage_tileg_diffuse.vmt 2> /dev/null
  mv -v ${A}/materials/de_mirage/brick/de_mirage_brick_ver1_blend_diffuse_.vmt ${A}/materials/de_mirage/brick/de_mirage_brick_ver1_blend_diffuse.vmt 2> /dev/null
  mv -v ${A}/materials/de_mirage/base/de_mirage_base_trim_ver1_diffuse_.vmt ${A}/materials/de_mirage/base/de_mirage_base_trim_ver1_diffuse.vmt 2> /dev/null
}
MODELS="weapons/v_rif_m4a1_s player/custom_player/legacy/ctm_diver_varianta"
MAKE_ASSET_PACK "${S}/Counter-Strike Global Offensive/csgo" none "pak01_dir.vpk"
##------------------------------------------------------------------------------ portal2
PRE_IMPORT_FIXES()
{
  mv -v ${A}/sounds/vo ${A}/_cull 2> /dev/null
  sed -i -e "s/.4\`/.4/" ${A}/materials/metal/black_wall_metal_005a_top.vmt
  sed -i -e "s/.4\`/.4/" ${A}/materials/nature/dirtfloor004d.vmt
}
MAKE_ASSET_PACK "${S}/Portal 2/portal2" none "pak01_dir.vpk" "../portal2_dlc1/pak01_dir.vpk" "../portal2_dlc2/pak01_dir.vpk" "../other_loose_files_in_dlc_folders.vpk"
##------------------------------------------------------------------------------ portal_stories
PRE_IMPORT_FIXES()
{
  mv -v ${A}/scripts/game_sounds_ps_virgil_autogenerated.txt ${A}/_cull 2> /dev/null
}
MAKE_ASSET_PACK "${S}/Portal Stories Mel/portal_stories" asset_pack_portal2 "pak01_dir.vpk"
##------------------------------------------------------------------------------ hl2 TODO VPK_LINK_FIX:  hl2_sound_vo__00[0-4].vpk << hl2_sound_vo_english_00[0-4].vpk
MODELS="alyx barney eli breen breen_monitor mossman monk odessa kleiner vortigaunt vortigaunt_slave"
MODELS="${MODELS} humans/group01 humans/group02 humans/group03 humans/group03m"
MODELS="${MODELS} props_animated_breakable/smokestack"
MAKE_ASSET_PACK "${S}/Half-Life 2/hl2" none "hl2_misc_dir.vpk" "hl2_textures_dir.vpk" "hl2_sound_misc_dir.vpk" "hl2_sound_vo_english_dir.vpk"
##------------------------------------------------------------------------------ hl2mp
MAKE_ASSET_PACK "${S}/Half-Life 2 Deathmatch/hl2mp" asset_pack_hl2 "hl2mp_pak_dir.vpk"
##------------------------------------------------------------------------------ lostcoast
MAKE_ASSET_PACK "${S}/Half-Life 2/lostcoast" asset_pack_hl2 "lostcoast_pak_dir.vpk"
##------------------------------------------------------------------------------ dod
MAKE_ASSET_PACK "${S}/Day of Defeat Source/dod" asset_pack_hl2 "dod_pak_dir.vpk"
##------------------------------------------------------------------------------ se1
PRE_IMPORT_FIXES()
{
  rm -fvr ${A}/materials/models/hl2_materials ${A}/models/hl2_props
}
MAKE_ASSET_PACK "${S}/SiN Episodes Emergence/se1" asset_pack_hl2 "../vpks/depot_1301_dir.vpk" "../vpks/depot_1302_dir.vpk" "../vpks/depot_1303_dir.vpk"  "../vpks/depot_1304_dir.vpk"  "../vpks/depot_1305_dir.vpk" "../vpks/depot_1316_dir.vpk"
##------------------------------------------------------------------------------ garrysmod
MODELS="hl1plr player/hostage"
MAKE_ASSET_PACK "${S}/GarrysMod/garrysmod" asset_pack_hl2 "fallbacks_dir.vpk" "garrysmod_dir.vpk"
##------------------------------------------------------------------------------ dystopia
PRE_IMPORT_FIXES()
{
  sed -i -e "s:\"Proxies:\"OffProxies:" ${A}/materials/models/props/jackpoint_public_grid_bb.vmt
  sed -i -e "s:\"Proxies:\"OffProxies:" ${A}/materials/models/props/jackpoint_public_grid_rb.vmt
}
MAKE_ASSET_PACK "${S}/Dystopia/dystopia" asset_pack_hl2
##------------------------------------------------------------------------------ frontend
MAKE_ASSET_PACK "${S}/Anarchy Arcade/frontend" asset_pack_hl2
##------------------------------------------------------------------------------ neotokyosource
MAKE_ASSET_PACK "${S}/NEOTOKYO/neotokyosource" asset_pack_hl2
##------------------------------------------------------------------------------ mindlock
MAKE_ASSET_PACK "${S}/The Trap 2 Mindlock (beta)/mindlock" asset_pack_hl2
##------------------------------------------------------------------------------ brainbread2
MAKE_ASSET_PACK "${S}/brainbread2/brainbread2" asset_pack_hl2 "../base/bb2_game_dir.vpk" "../base/misc_game_dir.vpk"
##------------------------------------------------------------------------------ nucleardawn
PRE_IMPORT_FIXES()
{
  sed -i -e "s:\t\"\$detailscale:\t//\"\$detailscale:" ${A}/materials/models/rts_structures/rts_armoury/rts_armoury_ct_displays.vmt
  sed -i -e "s:\t\"\$detailscale:\t//\"\$detailscale:" ${A}/materials/models/rts_structures/rts_armoury/rts_armoury_emp_displays.vmt
}
MAKE_ASSET_PACK "${S}/Nuclear Dawn/nucleardawn" asset_pack_hl2 "pak01_dir.vpk"
##------------------------------------------------------------------------------ gstringv2
PRE_IMPORT_FIXES()
{
  mv -v  ${A}/materials/skybox/orbit_sky_cube.tga ${A}/_cull 2> /dev/null
  mv -v  ${A}/sounds/ambient/energy/spark4.wav ${A}/_cull 2> /dev/null
  mv -v  ${A}/sounds/ambient/energy/spark5.wav ${A}/_cull 2> /dev/null
  mv -v  ${A}/sounds/ambient/energy/zap7.wav ${A}/_cull 2> /dev/null
  mv -v  ${A}/sounds/ambient/energy/zap8.wav ${A}/_cull 2> /dev/null
  mv -v  ${A}/sounds/ambient/energy/zap9.wav ${A}/_cull 2> /dev/null
  mv -v  ${A}/sounds/augmented/construction/scanner_track.wav ${A}/_cull 2> /dev/null
  mv -v  ${A}/sounds/story_specific/equip_hum.wav ${A}/_cull 2> /dev/null
  mv -v  ${A}/sounds/war/uneasy.wav ${A}/_cull 2> /dev/null
  mv -v  ${A}/sounds/wasteland_soundscape_rain/thunder2.wav ${A}/_cull 2> /dev/null
  mv -v  ${A}/sounds/weapons/physcannon/hold_loop.wav ${A}/_cull 2> /dev/null
}
MAKE_ASSET_PACK "${S}/G String/gstringv2" asset_pack_hl2 "gstringv2_dir.vpk"
##------------------------------------------------------------------------------ episodic
MAKE_ASSET_PACK "${S}/Wilson Chronicles/wilson_chronicles" asset_pack_hl2
MODELS="alyx barney eli kleiner eli_monitor mossman kleiner_monitor"
MAKE_ASSET_PACK "${S}/Half-Life 2/episodic" asset_pack_hl2 "ep1_pak_dir.vpk"
##------------------------------------------------------------------------------ ep2
PRE_IMPORT_FIXES()
{
  sed -i -e "s:skybox:nature:" ${A}/materials/nature/mountainscape.vmt
  sed -i -e "s:skybox:nature:" ${A}/materials/nature/vista_card_12.vmt
}
MODELS="alyx eli kleiner alyx_interior vortigaunt vortigaunt_blue"
MAKE_ASSET_PACK "${S}/Half-Life 2/ep2" asset_pack_hl2 "ep2_pak_dir.vpk"
##------------------------------------------------------------------------------cstrike TODO escape these parens in the sed
PRE_IMPORT_FIXES()
{
  sed -i -e "s:nature/rockwall012a_normal:cs_havana/rockwall012a_normal:i" ${A}/materials/cs_havana/blendrockmoss002a.vmt
  sed -i -e "s:models\\\props\\\cs_office\\\computer2a:cs_havana/computer2a:i" ${A}/materials/cs_havana/computer2a.vmt
  sed -i -e "s:models\\\props\\\cs_office\\\computer2b:cs_havana/computer2b:i" ${A}/materials/cs_havana/computer2b.vmt
  sed -i -e "s:cs_office/filebox01file:cs_havana/filebox01file:i" ${A}/materials/cs_havana/filebox01file.vmt
  sed -i -e "s:overviews/fy_rockworld:cs_havana/fy_rockworld:i" ${A}/materials/cs_havana/fy_rockworld.vmt
  sed -i -e "s:buildings\\\gen02:cs_havana/gen02:i" ${A}/materials/cs_havana/gen02.vmt
  sed -i -e "s:fx\\\glow:cs_havana/glow:i" ${A}/materials/cs_havana/glow.vmt
  sed -i -e "s:models/cs_italy/ivy:cs_havana/ivy:i" ${A}/materials/cs_havana/ivy.vmt
  sed -i -e "s:models/cs_italy/ivy:cs_havana/ivy:i" ${A}/materials/cs_havana/ivy.vmt
  sed -i -e "s:models/cs_italy/ivyb:cs_havana/ivyb:i" ${A}/materials/cs_havana/ivyb.vmt
  sed -i -e "s:models/cs_italy/ivyb:cs_havana/ivyb:i" ${A}/materials/cs_havana/ivyb.vmt
  sed -i -e "s:models/de_dust/objects/palmbillboard:cs_havana/palmbillboard:i" ${A}/materials/cs_havana/palmbillboard.vmt
  sed -i -e "s:models/de_dust/objects/palm_tree01:cs_havana/palm_tree01:i" ${A}/materials/cs_havana/palm_tree01.vmt
  sed -i -e "s:models/props_pipes/pipemetal003a:cs_havana/pipemetal003a:i" ${A}/materials/cs_havana/pipemetal003a.vmt
  sed -i -e "s:models/cs_italy/planta:cs_havana/planta:i" ${A}/materials/cs_havana/planta.vmt
  sed -i -e "s:models/cs_italy/planta:cs_havana/planta:i" ${A}/materials/cs_havana/planta.vmt
  sed -i -e "s:models/cs_italy/plantb:cs_havana/plantb:i" ${A}/materials/cs_havana/plantb.vmt
  sed -i -e "s:models/cs_italy/plantb:cs_havana/plantb:i" ${A}/materials/cs_havana/plantb.vmt
  sed -i -e "s:models/cs_italy/railing:cs_havana/railing:i" ${A}/materials/cs_havana/railing.vmt
  sed -i -e "s:models/cs_italy/railing:cs_havana/railing:i" ${A}/materials/cs_havana/railing.vmt
  sed -i -e "s:nature/rockwall012a_normal:cs_havana/rockwall012a_normal:i" ${A}/materials/cs_havana/rockwall012a.vmt
  sed -i -e "s:models/pi_twig/twig:cs_havana/twig:i" ${A}/materials/cs_havana/twig.vmt
  sed -i -e "s:models/pi_twig/twig:cs_havana/twig:i" ${A}/materials/cs_havana/twig.vmt
  sed -i -e "s:cstrike/{2red_trellis02:cs_havana/{2red_trellis02:i" ${A}/materials/cs_havana/{2red_trellis02.vmt
  sed -i -e "s:cstrike/{blue:cs_havana/{blue:i" ${A}/materials/cs_havana/{blue.vmt
  sed -i -e "s:cstrike/{cstrike_le6lad:cs_havana/{cstrike_le6lad:i" ${A}/materials/cs_havana/{cstrike_le6lad.vmt
  sed -i -e "s:cstrike/{cstrike_oe4ven:cs_havana/{cstrike_oe4ven:i" ${A}/materials/cs_havana/{cstrike_oe4ven.vmt
  sed -i -e "s:cstrike/{hangingivy1:cs_havana/{hangingivy1:i" ${A}/materials/cs_havana/{hangingivy1.vmt
  sed -i -e "s:cstrike/{hangingivy2:cs_havana/{hangingivy2:i" ${A}/materials/cs_havana/{hangingivy2.vmt
  sed -i -e "s:cstrike/{hrpoint:cs_havana/{hrpoint:i" ${A}/materials/cs_havana/{hrpoint.vmt
  sed -i -e "s:cstrike/{invisible:cs_havana/{invisible:i" ${A}/materials/cs_havana/{invisible.vmt
  sed -i -e "s:cstrike/{k_rail01_hires:cs_havana/{k_rail01_hires:i" ${A}/materials/cs_havana/{k_rail01_hires.vmt
  sed -i -e "s:cstrike/{k_rail01_lores:cs_havana/{k_rail01_lores:i" ${A}/materials/cs_havana/{k_rail01_lores.vmt
  sed -i -e "s:cstrike/{ornategate:cs_havana/{ornategate:i" ${A}/materials/cs_havana/{ornategate.vmt
  sed -i -e "s:cstrike/{pylon:cs_havana/{pylon:i" ${A}/materials/cs_havana/{pylon.vmt
  sed -i -e "s:cstrike/{tk_plantlg:cs_havana/{tk_plantlg:i" ${A}/materials/cs_havana/{tk_plantlg.vmt
  sed -i -e "s:cstrike/{tk_plantsm:cs_havana/{tk_plantsm:i" ${A}/materials/cs_havana/{tk_plantsm.vmt
  sed -i -e "s:cstrike/{tk_railing:cs_havana/{tk_railing:i" ${A}/materials/cs_havana/{tk_railing.vmt
  sed -i -e "s:cstrike/{tk_steeldoor:cs_havana/{tk_steeldoor:i" ${A}/materials/cs_havana/{tk_steeldoor.vmt
  sed -i -e "s:cstrike/{tk_wwheel:cs_havana/{tk_wwheel:i" ${A}/materials/cs_havana/{tk_wwheel.vmt
}
MODELS="characters/hostage_01 characters/hostage_02 characters/hostage_03 characters/hostage_04"
MAKE_ASSET_PACK "${S}/Counter-Strike Source/cstrike" asset_pack_hl2 "cstrike_pak_dir.vpk"
##------------------------------------------------------------------------------ dab TODO SPACE FIX RENAME THE VMT TO VTF?
PRE_IMPORT_FIXES()
{
  rm -v ${A}/materials/models/stormy/da_floorlight_01_nor.vmt
  for FILE in "weapons/v_models/mossberg590/diffuse.vmt" "shells/12gauge/shell_12gauge.vmt" "weapons/v_models/mossberg590/mossberg590.vmt" "weapons/v_models/mossberg590/shotgun_shell.vmt"; do
    convert_to_utf8 ${A}/materials/models/${FILE}
  done
  sed -i -e "s:\\\:/:g" ${A}/materials/models/props/lhda/pol/body_texture.vmt
  sed -i -e "s:\\\:/:g" ${A}/materials/models/props/lhda/pol/door_texture.vmt
  sed -i -e "s:\\\:/:g" ${A}/materials/models/props/lhda/pol/wheel_texture.vmt
  sed -i -e "s:\\\:/:g" ${A}/materials/models/props/lhda/pol/windtext.vmt
  sed -i -e "s:\\\:/:g" ${A}/materials/models/weapons/v_models/Jarheads_m16a2/556.vmt
  sed -i -e "s:\\\:/:g" ${A}/materials/models/weapons/v_models/Jarheads_m16a2/fore.vmt
  sed -i -e "s:\\\:/:g" ${A}/materials/models/weapons/v_models/Jarheads_m16a2/upper.vmt
  sed -i -e "s:\\\:/:g" ${A}/materials/models/weapons/v_models/Jarheads_m16a2/lower.vmt
  sed -i -e "s:\\\:/:g" ${A}/materials/models/weapons/v_models/twinkie_1911/frame.vmt
  sed -i -e "s:\\\:/:g" ${A}/materials/models/weapons/v_models/twinkie_1911/slide.vmt
}
MODELS="characters/hostage_02"
MAKE_ASSET_PACK "${S}/Double Action/dab" asset_pack_hl2
##------------------------------------------------------------------------------zps
PRE_IMPORT_FIXES()
{
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
##------------------------------------------------------------------------------ nmrih TODO SPACE FIX
PRE_IMPORT_FIXES()
{
  mv -v ${A}/particles/nmrih_molotov.pcf ${A}/particles/nmrih_molotov._pcf 2> /dev/null
  sed -i -e "s:\\\:/:g" -e "s:Wally head :Wally_head_:gi"  ${A}/materials/models/player/wally/nmrih_wally_glasses.vmt
  sed -i -e "s:\\\:/:g" ${A}/materials/models/nmr_zombie/julie/body_diffuse_z.vmt
  sed -i -e "s:\\\:/:g" ${A}/materials/models/nmr_zombie/julie/head_diffuse_z.vmt
  sed -i -e "s:\\\:/:g" -e "s:Wally body normal:Wally_body_normal:gi" ${A}/materials/models/player/wally/wally_body_diffuse.vmt
  sed -i -e "s:\\\:/:g" ${A}/materials/models/player/wally/wally_head_diffuse.vmt
  sed -i -e "s:\\\:/:g" ${A}/materials/models/player/wally/wally_head_diffuse_zom.vmt
  sed -i -e "s:\\\:/:g" ${A}/materials/models/player/wally/wally_body_diffuse_zom.vmt
  sed -i -e "s:\\\:/:g" -e "s:ceiling light:ceiling_light:gi" ${A}/materials/models/props/hospital/ceiling_light_on.vmt
}
MODELS="props/interior/cereal_box props/objectives/cj_propanetank"
MAKE_ASSET_PACK "${S}/nmrih/nmrih" asset_pack_hl2 "nmrih_dir.vpk"
##------------------------------------------------------------------------------ SWARM SKIPPING V4
MODELS="aliens/drone/drone aliens/shieldbug/shieldbug aliens/harvester/harvester swarm/shieldbug/shieldbug swarm/drone/uberdrone swarm/drone/drone"
MAKE_ASSET_PACK "${S}/Alien Swarm/swarm" asset_pack_hl2 "pak01_dir.vpk"
##------------------------------------------------------------------------------ BMS TODO VPK_LINK_FIX: bms_sound_vo__00[0-3].vpk << bms_sound_vo_english_00[0-3].vpk )
PRE_IMPORT_FIXES()
{
  convert_to_utf8 ${A}/materials/models/xenians/houndeye/houndeye.vmt
}
MODELS="player/mp_scientist humans/guard humans/guard_hurt humans/guard_02 humans/marine humans/marine_sg humans/marine_02 humans/marine_02_sg humans/masked_marine humans/masked_marine_02 humans/masked_marine_02_sg humans/masked_marine_sg humans/scientist_eli"
MODELS="${MODELS} player/mp_guard player/mp_guard_02 player/mp_marine player/mp_marine_02 player/mp_scientist_02"
MODELS="${MODELS} props_xen/c4a1a-island-c1a/c4a1a-island-c1a039 props_xen/c4a1a-island-c1a/c4a1a-island-c1a037 props_xen/c4a1a-island-c1a/c4a1a-island-c1a036 props_xen/c4a1a-island-c1a/c4a1a-island-c1a034 props_xen/c4a1a-island-c1a/c4a1a-island-c1a015 props_xen/c4a1a-island-c1a/c4a1a-island-c1a014 props_xen/c4a1a-island-c1a/c4a1a-island-c1a013 props_xen/c4a1a-island-c1a/c4a1a-island-c1a012 props_xen/c4a1a-island-c1a/c4a1a-island-c1a011 props_xen/c4a1a-island-c1a/c4a1a-island-c1a003"
MODELS="${MODELS} props_xen/rocks/crystals/c4a2a_crystal_cavern_cluster_large_1b props_xen/rocks/crystals/c4a2a_crystal_cavern_geode_1b props_xen/rocks/crystals/c4a2a_crystal_cavern_geode_small_1b props_xen/rocks/crystals/c4a2a_crystal_cavern_geode_small_1a"
MAKE_ASSET_PACK "${S}/Black Mesa/bms" asset_pack_hl2 "bms_materials_dir.vpk" "bms_models_dir.vpk" "bms_textures_dir.vpk" "bms_sounds_misc_dir.vpk" "bms_sound_vo_english_dir.vpk" "bms_misc_dir.vpk"
##------------------------------------------------------------------------------ vampire SKIPPING V4
MODELS="character/monster/animalism_beastform/animalism_beastform_mdl character/shared/male/allsequences_mdl character/shared/male/npc_allsequences_mdl character/shared/male/pcidles_allsequences_mdl character/shared/female/npc_allsequences_mdl character/shared/female/pcidles_allsequences_mdl character/shared/female/allsequences_mdl"
MAKE_ASSET_PACK "${S}/Vampire The Masquerade - Bloodlines/vampire" none
##------------------------------------------------------------------------------ p3 SKIPPING V4
PRE_IMPORT_FIXES()
{
  find asset_pack_p3/materials/ -name *.vmt | while read FILE; do convert_to_utf8 ${FILE}; done
}
MODELS="characters"
MODELS="${MODELS} pornworld/sex_set_03_a pornworld/sex_set_03_a_damage pornworld/sex_set_03_b"
MODELS="${MODELS} pornworld/sex_set_03_b_damage pornworld/sex_set_03_c"
MODELS="${MODELS} pornworld/sex_set_03_c_damage pornworld/sex_set_03_d"
MODELS="${MODELS} pornworld/sex_set_03_d_damage pornworld/sex_set_04_a_damage"
MODELS="${MODELS} pornworld/sex_set_04_b pornworld/sex_set_04_b_damage"
MODELS="${MODELS} pornworld/sex_set_04_c pornworld/sex_set_04_c_damage"
MODELS="${MODELS} pornworld/sex_set_04_d pornworld/sex_set_04_d_damage"
MODELS="${MODELS} small_things/cow_pad small_things/drocha_01 small_things/office_papers_01_d_damage small_things/office_papers_01_i_damage small_things/office_papers_01_j_damage test/testHouse"
MODELS="${MODELS} weapons/bat/bat_rotate_flight weapons/bat/dat_rotate_flight"
MAKE_ASSET_PACK "${S}/Postal III/p3" none "p3_english_stuff.vpk"
##------------------------------------------------------------------------------