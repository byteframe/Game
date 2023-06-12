D=/mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/common
E=/mnt/e/SteamLibrary/steamapps/common
C=${D}/SteamVR/tools/steamvr_environments/content/steamtours_addons
G=${D}/SteamVR/tools/steamvr_environments/game/steamtours_addons
W=/mnt/c/Users/byteframe/Downloads
header()
{
  echo -e "\n\n--------------------------------------------------------------------------------"
  echo ${1}
  echo "--------------------------------------------------------------------------------"
  sleep 1
}
extract_vpk_contents()
{
  if [ ! -e ~/.local/bin/vpk ] || [[ $(~/.local/bin/vpk -t "${1}") == *"Error:"* ]]; then
    echo -e "error in: ${1}, must extract manually\n"
    read PAUSE
  else
    ~/.local/bin/vpk -re "(models|materials|particles|sound|scripts|scenes|surfaces)/.*" -x "${C}"/${A} "${1}"
  fi
  if [ -d "${C}"/${A}/${A:11} ]; then
    cp -vr --link "${C}"/${A}/${A:11}/materials "${C}"/${A}/
    cp -vr --link "${C}"/${A}/${A:11}/models  "${C}"/${A}/
    cp -vr --link "${C}"/${A}/${A:11}/particles  "${C}"/${A}/
    cp -vr --link "${C}"/${A}/${A:11}/scenes  "${C}"/${A}/
    cp -vr --link "${C}"/${A}/${A:11}/scripts  "${C}"/${A}/
    cp -vr --link "${C}"/${A}/${A:11}/surfaces  "${C}"/${A}/
    cp -vr --link "${C}"/${A}/${A:11}/sound  "${C}"/${A}/
    rm -fr "${C}"/${A}/${A:11}
  fi
}
MAKE_ASSET_PACK()
{
  A=asset_pack_"${1/*\//}${SUFFIX}"
  if [ -n ${A} ] && [ -n "${2}" ] && [ ! -d "${C}"/${A} ] && [ ! -d "${G}"/${A} ]; then
    header "${A} | INITIALZING ASSET PACK..."
    cd "${C}"
    mkdir -p ${A} "${G}"/${A}
    rsync -av --prune-empty-dirs --exclude='demoheader.tmp' --exclude='*.cache' --exclude='*.bik' --exclude='*.vbsp' --exclude='*.rad' --exclude='maps/' --exclude='cfg/' --exclude='bin/' --exclude='media/' --exclude='shaders/' --exclude='resource/' --exclude="*.vpk*" "${1}"/* ${A}/ >> ${A}/${A}--extract.txt
    echo "" > ${A}/convertedBumpmaps.txt
    echo -e "gameContentRoot = C:\\\Program Files (x86)\\\Steam\\\steamapps\\\common\\\SteamVR\\\tools\\\steamvr_environments\\\content\\\steamtours_addons\\\\\nreflectanceRange = g_vReflectanceRange \"[0.000 0.050]\"" > ${A}/global_vars.txt
    echo "\"AddonInfo\"{\"Dependencies\"{}}" > "${G}"/${A}/addoninfo.txt
    for VAR in "$@"; do
      if [[ ${VAR} == *.vpk* ]]; then
        header "${A} | EXTRACTING ${1}"/"${VAR}" | tee -a ${A}/${A}--extract.txt
        extract_vpk_contents "${1}"/"${VAR}" >> ${A}/${A}--extract.txt 2>&1
      fi
    done
    find ${A}/materials/console/ ${A}/materials/vgui/chapters/ ${A}/materials/vgui/backgrounds/ -type f \
    -name background0* -or -name background_menu.* -or -name loading_screen_background.* -or -name coopcommentary_chapter* -or -name background_menu_widescreen.* -or \
    -name loading.* -or -name intro.* -or -name intro_widescreen.* -or -name startup_loading.* -or \
    -name startup.* -or -name console_background.* -or -name chapter* | while read FILE; do
      if [[ "${FILE}" != *-* ]] && [ ! -d "${FILE}" ]; then
        if [[ "${FILE}" == *.vmt ]]; then
          FILE_SHORT="${FILE/${A}\/materials\//}"
          sed -i -e "s:${FILE_SHORT/.vmt/}:${FILE_SHORT/.vmt/}-${A:11}:g" "${FILE}"
        fi
        mv -v "${FILE}" "${FILE/./-${A:11}.}" >> ${A}/${A}--extract.txt 2>&1
      fi
    done
    mv ${A}/sound ${A}/sounds
    
    header "${A} | CULLING BLACKLISTED FILES"
    {
      mv ${A}/materials/dev ${A}/
      mkdir -v ${A}/materials/dev
      mv -v ${A}/dev/flat_normal* ${A}/materials/dev/
      mv -v ${A}/dev/water_* ${A}/materials/dev/
      rm -fvr ${A}/dev ${A}/materials/engine ${A}/materials/debug ${A}/materials/tools ${A}/materials/editor ${A}/materials/models/editor ${A}/models/editor
      if [ ${A} == asset_pack_portal2 ]; then
        rm -fvr ${A}/sounds/vo
      elif [ ${A} == asset_pack_mm ]; then
        rm -v ${A}/scripts/game_sounds_header.txt
      elif [ ${A} == asset_pack_revelations ]; then
        rm -frv ${A}/sounds/Revelations/Greg/Kulkukan_swing.wav
      elif [ ${A} == asset_pack_dab ]; then
        rm -v ${A}/materials/models/stormy/da_floorlight_01_nor.vmt
      elif [ ${A} == asset_pack_left4dead2 ]; then
        rm -v ${A}/materials/dons_decals/serviet_*.vmt
      elif [ ${A} == asset_pack_se1 ]; then
        rm -fvr ${A}/materials/models/hl2_materials ${A}/models/hl2_props
      elif [ ${A} == asset_pack_gstringv2 ]; then
        rm -v ${A}/sounds/ambient/energy/spark4.wav
        rm -v ${A}/sounds/ambient/energy/spark5.wav
        rm -v ${A}/sounds/ambient/energy/zap7.wav
        rm -v ${A}/sounds/ambient/energy/zap8.wav
        rm -v ${A}/sounds/ambient/energy/zap9.wav
        rm -v ${A}/sounds/augmented/construction/scanner_track.wav
        rm -v ${A}/sounds/story_specific/equip_hum.wav
        rm -v ${A}/sounds/war/uneasy.wav
        rm -v ${A}/sounds/wasteland_soundscape_rain/thunder2.wav
        rm -v ${A}/sounds/weapons/physcannon/hold_loop.wav
      fi
      rm -frv ${A}/sounds/common/talk.wav
    } >> ${A}/${A}--cull.txt 2>&1

    header "${A} | NOW RUN VTFEDIT MANUALLY FOR VTF CONVERSION..."
    if [ ! -d "${W}"/materials ]; then
      mv ${A}/materials "${W}"/materials 
    fi
    read PAUSE_FOR_MANUAL_VTFEDIT
    if [ ! -d ${A}/materials ] && [ -d "${W}"/materials ]; then
      mv "${W}"/materials ${A}
    fi

    header "${A} | FIXING FILE WHITESPACE"
    find ${A}/ -name "*\ *" | tac | while read FILE; do
      mv -v "${FILE}" "${FILE// /_}" >> ${A}/${A}--whitespace.txt 2>&1
    done

    header "${A} | CLEANING SOURCE FILES"
    find ${A}/materials -name "*.vmt" -exec sed -i -e "s:\/\/.*::g" -e "/\[\$[xX]360\]/d" -e "s/\s*\[\$WIN32\]//" -e s:$'\x93':\":g -e s:$'\x94':\":g  {} \;
    sed -i -e "s/\.\././" "${C}"/${A}/scripts/game_sounds*.txt
    
    header "${A} | RUNNING CONVERSION SCRIPTS"
    python /mnt/d/Work/Game/steamtours/asset_packs/scripts/vmt_to_vmat.py "${C}"/${A} >> ${A}/${A}--materials.txt 2>&1
    python "${W}"/source1import-0.3.6/utils/models_import.py -i "${C}"/${A} -e "${C}"/${A} >> ${A}/${A}--models.txt 2>&1
    python "${W}"/source1import-0.3.6/utils/particles_import.py -i "${C}"/${A} -e "${C}"/${A} >> ${A}/${A}--particles.txt 2>&1
    python "${W}"/source1import-0.3.6/utils/scripts_import.py -i "${C}"/${A} -e "${C}"/${A} >> ${A}/${A}--scripts.txt 2>&1
    python "${W}"/source1import-0.3.6/utils/scenes_import.py -i "${C}"/${A} -e "${C}"/${A} >> ${A}/${A}--scenes.txt 2>&1
    
    header "${A} | CHECKING MATERIAL FILES AND BLACKLISTING MODELS"
    find ${A/\//}/materials -name "*.vmat" | while read FILE; do
      VMAT=$(grep -oe materials/.*\" ${FILE})
      for _FILE in ${VMAT//\"/ }; do
        unset FOUND
        for SEARCH in ${A} ${2/none/}; do
          if [ -e ${SEARCH}/${_FILE} ]; then
            FOUND=true
            break
          fi
        done
        if [ -z ${FOUND} ]; then
          echo "${FILE} --- ${_FILE}" >> ${A}/${A}--diff.txt 2>&1
          sed -i -e ":${_FILE}:g" ${FILE}
        fi
      done
      sed -i -e "s/F_RENDER_BACKFACES 1\"/F_RENDER_BACKFACES 1/" ${FILE}
    done
    for MODEL in ${MODELS}; do
      if [ -d ${A}/models/${MODEL} ]; then
        find ${A}/models/${MODEL}/ -name "*.vmdl" -exec sed -i -e "s/\.mdl/_mdl/" {} \;
      else
        sed -i -e "s/\.mdl/_mdl/" ${A}/models/${MODEL}.vmdl
      fi
    done

    header "${A} | BUILDING/MOVING COMPILED GAME FILES"
    for TYPE in materials models particles sounds soundevents scenes; do
      unset FINISHED
      while [ -z ${FINISHED} ]; do
        "${G}"/../bin/win64/resourcecompiler.exe -r -i "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\content\steamtours_addons\\\\${A}\\\\${TYPE}\*"
        echo "waiting (empty to retry): ${TYPE}..."
        read FINISHED
      done
    done
    if [ -d ${G}/${A}/scripts ]; then
      cp ${A}/scripts/surfaceproperties*.txt "${G}"/${A}/scripts
    fi
    if [ -d ${A}/scenes ]; then
      mv -v ${A}/scenes/* "${G}"/${A}/scenes
    fi
    cp ${A}/${A}*.txt ${A}/convertedBumpmaps.txt ${A}/source1import_name_remap_table.txt "${G}"/${A}/
    cp ${A}/gameinfo.txt "${G}"/${A}/${A}--gameinfo.txt
    
    header "${A} | DELETING VTF AND WAV FILES FROM CONTENT DIRECTORY"
    find ${A}/materials/ -name "*.vtf" -exec rm {} \;
    rm -fr ${A}/sounds
  fi
  unset MODELS
}
MODELS="players Revelations/priest/priest Revelations/MorphGun/gunmorph Revelations/weapons/viewmodels/v_gauntlet players/megan_v3 players/megan_v3_bg players/veteran_v3 players/veteran_v3_bg players/corey_v3 players/corey_v3_bg players/kelley_v3 players/kelley_v3_bg"
MAKE_ASSET_PACK "${E}/Revelations 2012/revelations" none
MODELS="props_monastery/books* temple/tt_r* temple/tt_l* temple/tt_m* temple/gong temple/rock*"
MAKE_ASSET_PACK "${E}/Blade Symphony/berimbau" none
MODELS="survivors/male/eugene survivors/male/eugene_young"
MAKE_ASSET_PACK "${E}/Contagion/contagion" none "../vpks/materials.vpk" "../vpks/models.vpk" "../vpks/scripts.vpk"
MODELS="weapons/v_rif_m4a1_s player/custom_player/legacy/ctm_diver_varianta player/custom_player/animset_t player/custom_player/animset_ct"
MAKE_ASSET_PACK "${E}/Counter-Strike Global Offensive/csgo" none "pak01_dir.vpk"
MAKE_ASSET_PACK "${E}/The Stanley Parable/thestanleyparable" none
MAKE_ASSET_PACK "${E}/Dear Esther/dearesther" none
MAKE_ASSET_PACK "${E}/Dino D-Day/dinodday" none
MAKE_ASSET_PACK "${E}/insurgency2/insurgency" none "insurgency_misc_dir.vpk" "insurgency_materials_dir.vpk" "insurgency_models_dir.vpk" "insurgency_particles_dir.vpk" "insurgency_sounds_dir.vpk"
MAKE_ASSET_PACK "${E}/The Ship Single Player/ship" none "../vpks/depot_2402_dir.vpk" "../vpks/depot_2405_dir.vpk"
MAKE_ASSET_PACK "${E}/Bloody Good Time/pm" none "../vpks/depot_2452_dir.vpk"
MAKE_ASSET_PACK "${E}/Dark Messiah Might and Magic Single Player/mm" none "../vpks/depot_2101_dir.vpk" "../vpks/depot_2103_dir.vpk" "../vpks/depot_2104_dir.vpk" "../vpks/depot_2105_dir.vpk" "../vpks/depot_2106_dir.vpk" "../vpks/depot_2107_dir.vpk" "../vpks/depot_2108_dir.vpk"
MODELS="breen kleiner mossman props_animated_breakable/smokestack"
MAKE_ASSET_PACK "${E}/From Earth/fromearth" none
MODELS="c1_chargerexit/doors_glass_5 c1_chargerexit/doors_glass_6 c1_chargerexit/plywood_cent"
MODELS="${MODELS} c5_bridge_destruction/bridge_left_tower c5_bridge_destruction/bridge_right_tower c5m3_bridge_overpass_debris/bridgedebris_set_a"
MODELS="${MODELS} destruction_tanker/destruction_tanker_debris_1 destruction_tanker/destruction_tanker_debris_2 destruction_tanker/destruction_tanker_debris_4"
MODELS="${MODELS} hybridphysx/map1_tarp_4 hybridphysx/map1_tarp_3 hybridphysx/map1_tarp_2 hybridphysx/map1_tarp_1"
MODELS="${MODELS} hybridphysx/gasstationpart_5 hybridphysx/gasstationpart_4 hybridphysx/gasstationpart_3 hybridphysx/gasstationpart_2 hybridphysx/gasstationpart_1"
MODELS="${MODELS} hybridphysx/airliner_left_wing_secondary hybridphysx/airliner_fuselage_secondary_4 hybridphysx/airliner_fuselage_secondary_3 hybridphysx/airliner_fuselage_secondary_2 hybridphysx/airliner_fuselage_secondary_1"
MODELS="${MODELS} props_destruction/general_dest_concrete_set props_destruction/general_dest_roof_set"
MODELS="${MODELS} infected survivors/survivor_biker survivors/survivor_biker_light survivors/survivor_coach survivors/survivor_gambler survivors/survivor_manager survivors/survivor_mechanic survivors/survivor_producer survivors/survivor_namvet survivors/survivor_teenangst survivors/survivor_teenangst_light"
MAKE_ASSET_PACK "${E}/Left 4 Dead 2/left4dead2" none "pak01_dir.vpk" "../left4dead2_dlc1/pak01_dir.vpk" "../left4dead2_dlc2/pak01_dir.vpk" "../left4dead2_dlc3/pak01_dir.vpk"  "../other_loose_files.vpk"
##------------------------------------------------------------------------------
MAKE_ASSET_PACK "${E}/Portal 2/portal2" none "pak01_dir.vpk" "../portal2_dlc1/pak01_dir.vpk" "../portal2_dlc2/pak01_dir.vpk"
MAKE_ASSET_PACK "${E}/Portal Stories Mel/portal_stories" asset_pack_portal2 "pak01_dir.vpk+portal_stories"
##------------------------------------------------------------------------------
MODELS="alyx eli breen breen_monitor mossman monk odessa vortigaunt vortigaunt_slave"
MODELS="${MODELS} humans/group01 humans/group02 humans/group03 humans/group03m"
MODELS="${MODELS} props_animated_breakable/smokestack"
MAKE_ASSET_PACK "${E}/Half-Life 2/hl2" none "hl2_misc_dir.vpk" "hl2_textures_dir.vpk" "hl2_sound_misc_dir.vpk" "hl2_sound_vo_english_dir.vpk"
##------------------------------------------------------------------------------
MAKE_ASSET_PACK "${E}/Half-Life 2 Deathmatch/hl2mp" asset_pack_hl2 "hl2mp_pak_dir.vpk"
MAKE_ASSET_PACK "${E}/Half-Life 2/lostcoast" asset_pack_hl2 "lostcoast_pak_dir.vpk"
MAKE_ASSET_PACK "${E}/Day of Defeat Source/dod" asset_pack_hl2 "dod_pak_dir.vpk"
MAKE_ASSET_PACK "${E}/SiN Episodes Emergence/se1" asset_pack_hl2 "../vpks/depot_1301_dir.vpk" "../vpks/depot_1302_dir.vpk" "../vpks/depot_1303_dir.vpk"  "../vpks/depot_1304_dir.vpk"  "../vpks/depot_1305_dir.vpk" "../vpks/depot_1316_dir.vpk"
MAKE_ASSET_PACK "${E}/Dystopia/dystopia" asset_pack_hl2
MAKE_ASSET_PACK "${E}/Anarchy Arcade/frontend" asset_pack_hl2
MAKE_ASSET_PACK "${E}/NEOTOKYO/neotokyosource" asset_pack_hl2
MAKE_ASSET_PACK "${E}/The Trap 2 Mindlock (beta)/mindlock" asset_pack_hl2
MAKE_ASSET_PACK "${E}/brainbread2/brainbread2" asset_pack_hl2 "../base/bb2_game_dir.vpk" "../base/misc_game_dir.vpk"
MAKE_ASSET_PACK "${E}/Nuclear Dawn/nucleardawn" asset_pack_hl2 "pak01_dir.vpk"
MAKE_ASSET_PACK "${E}/G String/gstringv2" asset_pack_hl2 "gstringv2_dir.vpk"
MAKE_ASSET_PACK "${E}/Wilson Chronicles/wilson_chronicles" asset_pack_hl2
MODELS="alyx eli kleiner eli_monitor mossman kleiner_monitor"
MAKE_ASSET_PACK "${E}/Half-Life 2/episodic" asset_pack_hl2 "ep1_pak_dir.vpk"
MODELS="alyx eli kleiner alyx_interior vortigaunt vortigaunt_blue"
MAKE_ASSET_PACK "${E}/Half-Life 2/ep2" asset_pack_hl2 "ep2_pak_dir.vpk"
MODELS="characters/hostage_01 characters/hostage_02 characters/hostage_03 characters/hostage_04"
MAKE_ASSET_PACK "${E}/Counter-Strike Source/cstrike" asset_pack_hl2 "cstrike_pak_dir.vpk"
MODELS="characters/hostage_02"
MAKE_ASSET_PACK "${E}/Double Action/dab" asset_pack_hl2
MODELS="propper/harvest/cabinet_handle01 zpprops/farmhaydark zpprops/farmhaylight"
MAKE_ASSET_PACK "${E}/Zombie Panic Source/zps" asset_pack_hl2 "../vpks/zps_content.vpk"
MODELS="props/interior/cereal_box props/objectives/cj_propanetank"
MAKE_ASSET_PACK "${E}/nmrih/nmrih" asset_pack_hl2 "nmrih_dir.vpk"
MODELS="aliens/drone/drone aliens/shieldbug/shieldbug aliens/harvester/harvester swarm/shieldbug/shieldbug swarm/drone/uberdrone swarm/drone/drone"
MAKE_ASSET_PACK "${E}/Alien Swarm/swarm" asset_pack_hl2 "pak01_dir.vpk"
MODELS="humans/guard humans/guard_hurt humans/guard_02 humans/marine humans/marine_sg humans/marine_02 humans/marine_02_sg humans/masked_marine humans/masked_marine_02 humans/masked_marine_02_sg humans/masked_marine_sg humans/scientist_eli"
MODELS="${MODELS} player/mp_guard player/mp_guard_02 player/mp_marine player/mp_marine_02 player/mp_scientist_02"
MODELS="${MODELS} props_xen/c4a1a-island-c1a/c4a1a-island-c1a039 props_xen/c4a1a-island-c1a/c4a1a-island-c1a036 props_xen/c4a1a-island-c1a/c4a1a-island-c1a034 props_xen/c4a1a-island-c1a/c4a1a-island-c1a015 props_xen/c4a1a-island-c1a/c4a1a-island-c1a014 props_xen/c4a1a-island-c1a/c4a1a-island-c1a013 props_xen/c4a1a-island-c1a/c4a1a-island-c1a012 props_xen/c4a1a-island-c1a/c4a1a-island-c1a011 props_xen/c4a1a-island-c1a/c4a1a-island-c1a003"
MODELS="${MODELS} props_xen/rocks/crystals/c4a2a_crystal_cavern_cluster_large_1b props_xen/rocks/crystals/c4a2a_crystal_cavern_geode_1b props_xen/rocks/crystals/c4a2a_crystal_cavern_geode_small_1b props_xen/rocks/crystals/c4a2a_crystal_cavern_geode_small_1a"
MAKE_ASSET_PACK "${E}/Black Mesa/bms" none "bms_materials_dir.vpk" "bms_models_dir.vpk" "bms_textures_dir.vpk" "bms_sounds_misc_dir.vpk" "bms_sound_vo_english_dir.vpk" "bms_misc_dir.vpk"
##------------------------------------------------------------------------------
MODELS="character/monster/animalism_beastform/animalism_beastform_mdl character/shared/male/allsequences_mdl character/shared/male/npc_allsequences_mdl character/shared/male/pcidles_allsequences_mdl character/shared/female/npc_allsequences_mdl character/shared/female/pcidles_allsequences_mdl character/shared/female/allsequences_mdl"
MAKE_ASSET_PACK "${E}/Vampire The Masquerade - Bloodlines/vampire"
MODELS="characters/monkey/monkey_animations characters/krotchy/krotchy characters/krotchynpc/krotchynpc characters/krotchynpc/krotchynpc_animations WAAAAAAAAAAAAAY fucked up somehow save for before vampire or something"
MAKE_ASSET_PACK "${E}/Postal III/p3" none "p3_english_stuff.vpk"
