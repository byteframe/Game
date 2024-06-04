#============================================================================== v3 changelog

  - new source1import with slimmer initial changes (continues to allow all shaders and correcting cubemap)
  - more intricate pack suffix/prefix and deletion routine
  - only run prep phase one in init
  - logging touchups throughout, dont pause on header, mute utf conversion,
  - ignore more junk in rysnc call
  - allowing tool materials now in import_blacklist
  - set up blend material templates during init
  - only nag about model insertion (now a parameter) in init phase
  - hardeneded space fixing and background routines, sparinng "environment maps" folder
  - ignore cull directory in whitespace fixing
  - remove vtf case conversion find, move xbox360 sed to asset_pack_pm
  - use novtf now (tiff/pfm) with subsquent python script modifications
  - employ 'skip_no_vtf' variable
  - remove vtf checker bash (vtf deletions now manual)
  - allow discrete build/import types with itypes/builds variable
  - more verbose import bash loop
  - auto blacklist models and other resources that fail to build (so dont remove talk.wav in init)
  - remove -v from resource compilter call and announce completion line
  - delete (non culled) sounds upon completion of sounds build and remove empty dir when finished
  - trim lots of non error output from build logs
  - dont extract vo vpks and erase dont cull portal 2 vo sounds
  - removed bash code to check for 4.vfx(fixed) and None and the bit that would do replacements on missing (rt) textures
  - use option to replace missing textures with default white
  - ignore material proxies fully now, so not modifying that code
  - rely on (and fix) extra vmat opportunity on proected decal shader instead of forcing vr standard
  - invert gloss masks genereted by python for basealphaenvmapmask correcting many materials
  - check all major valve games for files (hl2>episodic>ep2>cstrike>dod>left4dead2>portal2) when trying to find a file and/or make a mask
  - untest: recreate masks even if they exist
  - stronger file mark for created masks ("___")
  - check vicinity of vmt for missing texture files before searching other games
  - and do assosicated hardening, flourishing on file finding logic (backslash fix somewhere in there) ++
  - workaround python assuming csgo is for cs2
  - silence many instances of benign output from scripts
  - dont require srctools library in models.py
  - various touchups and additional file clutches throughout
  + errata: didnt really skip import stuff like scenes if the dir wasnt empty, so there's alot of empty content/game results (scenes.image mostly)
  +  for DIR in source1import_*/scenes; do if [ $(ls -l "${DIR}" | wc -l) = 2 ]; then echo ${DIR}; fi; done

# ============================================================================== logs

log_backup() {
  for FILE in source1import_*/source1import_*.txt; do
    if [[ ${FILE} != *"source1import_name_remap_table.txt" ]]; then
      cp ${FILE} /home/byteframe/Desktop
    fi
  done
}
for FILE in source1import_*/source1import_*.txt; do
  if [[ ${FILE} != *"source1import_name_remap_table.txt" ]]; then
    cp /home/byteframe/Desktop/$(basename ${FILE}) ${FILE}
  fi
done
for FILE in source1import_*/source1import_*.txt; do
  if [[ ${FILE} != *"source1import_name_remap_table.txt" ]]; then
    sed -i -e '/^$/N;/^\n$/D' "${FILE}"
  fi
done

# ============================================================================== check asset bins

cd "${G}"
for DIR in source1import_*; do
  if [ -e ${DIR}/tools_thumbnail_cache.bin ]; then
    rm -v ${DIR}/tools_thumbnail_cache.bin
  fi
  if [ ! -e ${DIR}/tools_asset_info.bin ]; then
    echo ${DIR} has no asset info
  fi
done

# ============================================================================== delete vtf

cd "${C}"
for DIR in source1import_*/materials; do
  if [[ ${DIR} != source1import_hl2* ]] && [[ ${DIR} != source1import_hl1* ]] && [[ ${DIR} != source1import_lostcoast* ]] && [[ ${DIR} != source1import_tf* ]] && [[ ${DIR} != source1import_hl2mp* ]] && [[ ${DIR} != source1import_episodic/* ]] && [[ ${DIR} != source1import_ep2* ]] && [[ ${DIR} != source1import_dod* ]] && [[ ${DIR} != source1import_cstrike* ]]; then
    for FILE in $(find ${DIR} -iname "*.VTF"); do
      if [ -e "${FILE/.vtf/.tiff}" ] || [ -e "${FILE/.vtf/.pfm}" ]; then
        echo rm -vf "${FILE}"
      fi
    done
  fi
done

# ============================================================================== mklink

echo "CD"
echo "CD Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\content\steamtours_addons"
cd /mnt/d/Source
for DIR in *; do
  mkdir ${DIR}
  echo "mklink /j ${DIR} D:\\Source\\${DIR}"
done

# ============================================================================== check materials (https://paste.ee/p/oJ7bJ)

for FILE in /mnt/g/assetpackv3rclogs/*; do
  echo "${FILE}"
  FILE2="${FILE/assetpackv3rclogs/assetpackv2logs}"
  grep "Total import" "${FILE2/source1import_/asset_pack_}"
  grep "Total import" "${FILE}"
  FILE3=$(basename ${FILE})
  grep "Total import" "${C}/$(echo ${FILE3} | sed -e s:.txt::)/${FILE3}"
  echo
done
for DIR in source1import_*/materials; do
  find ${DIR} -name *.vmat -exec grep  -H "\/\/" {} \
                           -exec grep  -H "\.vmt\.tga\"" {} \
                           -exec grep  -H "models.tga" {} \
                           -exec grep  -H "\"None\"" {} \
                           -exec grep  -H "4.vfx" {} \
                           -exec grep -PH "  Texture" "${FILE}" {} \
                           -exec grep -PH "  \/\/Texture" "${FILE}" {} \
                           -exec grep -PH "^Texture" "${FILE}" {} \
                           -exec grep -PH "\t\/\/Texture" "${FILE}" {} \
                           -exec grep  -H "\".\"" {} \;
done

# ============================================================================== vampire

cd /mnt/s/SteamLibrary/steamapps/common/Vampire\ The\ Masquerade\ -\ Bloodlines/Patch_Extras/Developer\ Tools/Bloodlines\ SDK/SDKBinaries/tools/Texture\ Utils/
WIN_PREFIX1="C:\\\\Users\\byteframe\\Desktop\\vampire\\materials"
find /mnt/c/Users/byteframe/Desktop/vampire/materials/ -name "*.tth" | while read FILE; do
  FILE_SHORT0="${FILE:49}"
  FILE_SHORT1="${FILE_SHORT0/.tth/.ttz}"
  FILE_NAME="$(basename ${FILE_SHORT0})"
  DIR="$(dirname ${FILE_SHORT0})"
  echo "copy \"${WIN_PREFIX1}\\${FILE_SHORT0//\//\\}\" ."
  echo "copy \"${WIN_PREFIX1}\\${FILE_SHORT1//\//\\}\" ."
  echo "TexConvert.exe \"${FILE_NAME}\" -tovtf"
  echo move "\"${FILE_NAME/.tth/.vtf}\" \"${WIN_PREFIX1}\\${DIR//\//\\}\""
  echo del "\"${FILE_NAME}\""
  echo del "\"${FILE_NAME/.tth/.ttz}\""
  echo
done > convert.bat

#============================================================================== v0 routines

+ build list of vpk files from valve asset packs and core game content
  "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\bin\win64\vpk.exe" l XXX.vpk > C:\Users\byteframe\Desktop\XXX_vpk_list.txt
#------------------------------------------------------------------------------
+ extract vpk contents (materials/models) to desktop collate under one dir
+ rename/fix console/background+startup-loading* | vgui/chapters/chapter-* | vgui/backgrounds materials
+ negate files (see posts)
+ track pre-processed hl2 diff: { find XXX -type f | while read LINE; do     LINE=${LINE#*/};     if [ -e hl2/"${LINE}" ]; then       echo "${LINE}";     fi;   done } > /mnt/c/Users/byteframe/Desktop/XXX_conflicts_hl2.txt
+ merge hl2mp and lostcoast into hl2 but do not overwrite anything
+ convert textures from vtf to tga with vtfedit
+ stage files in steamtours_addons/content
+ edit global_vars.txt and convert models for each asset pack
#------------------------------------------------------------------------------
+ create convertedBumpmaps.txt in content/steamtours_addons/mod (hl2/portal2/left4dead2) or use hl2 one if building css/dod
+ run material script (from content mod dir with modname and materials location and end slash supplied, wsl hard codes)
+ if css/dod: edit gameinfo to point to steamtours_addons/asset_pack_hl2
+ run appropriate material seds 
+ build materials (with hand tweaks) then models in asset browser
#------------------------------------------------------------------------------
+ record tweaks and bash modifications and negations:
  { find asset_pack_XXX/materials/ -name *.vmat | while read LINE; do LINE=${LINE#*/}; diff  empty_steamvrhome/"${LINE}" asset_pack_XXX/"${LINE}" || echo "${LINE}"; done } > /mnt/c/Users/byteframe/Desktop/XXX_materials_diffs.txt
+ track hl2 diff: { find asset_pack_XXX -type f | while read LINE; do     LINE=${LINE#*/};     if [ -e /mnt/f/MISC/AAA_ASSET_PACKS/content/asset_pack_hl2/"${LINE}" ]; then       echo "${LINE}";     fi;   done } > /mnt/c/Users/byteframe/Desktop/XXX_processed_hl2_conflicts.txt
+ if css/dod/episodic/ep2: reset gameinfo
+ if portal2/l4d2/robotrepair: split asset pack
+ if l4d2 cull non-unique assets: { find asset_pack_left4dead2 -type f | while read LINE; do LINE=${LINE#*/}; if grep -q "${LINE}" /mnt/d/Work/Game/steamtours/asset_packs/vpk_result_*; then echo ${LINE}; fi; done } > /mnt/c/Users/byteframe/Desktop/left4dead2cull.txt

# create source2 files (WSL)
python /mnt/d/Work/Game/steamtours/asset_packs/scripts/mdl_to_vmdl.py ${DIR/\//}
python /mnt/d/Work/Game/steamtours/asset_packs/scripts/vmt_to_vmat.py ${DIR/\//}
if [ -d ${DIR}/particles ]; then python source1import/utils/particles_import.py -i /mnt/s/${DIR} -e /mnt/s/${DIR}; fi

# create source2 files (WINDOWS)
set DIR=asset_pack_hl2
C:\Users\byteframe\AppData\Local\Programs\Python\Python310\python.exe D:\Work\Game\steamtours\asset_packs\scripts\mdl_to_vmdl.py %DIR%
C:\Users\byteframe\AppData\Local\Programs\Python\Python310\python.exe D:\Work\Game\steamtours\asset_packs\scripts\vmt_to_vmat.py %DIR%
C:\Users\byteframe\AppData\Local\Programs\Python\Python310\python.exe s:\source1import/utils/particles_import.py -i S:\%DIR% -e S:\%DIR%

# create source2 files (HYBRID)
/mnt/c/Users/byteframe/AppData/Local/Programs/Python/Python310/python.exe D:\\Work\\Game\\steamtours\\asset_packs\\scripts\\mdl_to_vmdl.py ${DIR/\//}
/mnt/c/Users/byteframe/AppData/Local/Programs/Python/Python310/python.exe D:\\Work\\Game\\steamtours\\asset_packs\\scripts\\vmt_to_vmat.py ${DIR/\//}
/mnt/c/Users/byteframe/AppData/Local/Programs/Python/Python310/python.exe S:\\source1import\\utils\\particles_import.py -i S:\\${DIR/\//} -e S:\\${DIR/\//}

# vtf2tga
cat "${CONTENT}"/../../game/steamtours/gameinfo.gi | grep asset_pack
SDK=/mnt/s/source1import/utils/shared/bin/vtf2tga/2013
SDK=/mnt/s/source1import/utils/shared/bin/vtf2tga/csgo
if [ ! -z ${VTF2TGA} ]; then
  find ${DIR/\//}/materials/ -name *.vtf | while read FILE; do
    if [ ! -e "${FILE/.vtf/.tga}" ]; then
      "${SDK}"/vtf2tga.exe -i "$(windows_path "${CONTENT}"/"${FILE}")"
    fi
  done
else

#============================================================================== v0 release notes

V0_RELEASE_NOTES=$(cat << EOF

Here are all the materials and models from Half-Life 2 (and assets from HL2:DM, and Lost Coast that didn't conflict overlaid on top) converted into the Source 2 format for use in your VR environments! I used https://github.com/Rectus/source2utils (with modifications of my own to the vmt script for blend materials iirc), and https://www.tophattwaffle.com/downloads/vtfedit/ to convert vtf files to tga.
There are also Day of Defeat: Source, and Counter-Strike: Source asset packs available! They were built with a set of the hl2 materials (as things like models and blend materials might reference a basic hl2 material). Furthermore, each game had various materials that were the same path and name as hl2 variants, but was different content (they were replaced). Originally, a copy (and resulting compilation and space-saving cull thereof) of the hl2 materials would accompany these asset packs, but recent versions of these asset packs are safely built with the hl2 materials segregated. This means that, unlike version 1, these asset packs will have their uniquely modified versions of materials retained, and as much space is saved as possible. These games (as well as TF2) shipped with a set of the hl2 assets, and so various map recreation projects will still need to also require the Half-Life-2 Asset Pack. See changenotes for the version 1 release blurb.
UPDATE: addoninfo.txt order of dependancies is followed here. If you include multiple packs, there might be various name conflicts, hopefully just between files identical, but sometimes not. The asset will be selected from the first addon it is found in as listed in your addoninfo.txt Also, the official Valve destinations/packs also tend to use alot of upscaled source 1 assets and/or filenames. The asset browser for your addon may (I'm not sure) only see one file. This shouldn't be a problem for most map makers, but is something to be aware of. 
To prevent cross contamination with default Source 2 base textures and tool resources, the following files were culled prior to building. Alot of the Source 2 special textures seem to have been renamed/moved to avoid this, but not all.

materials/
-- debug/debugempty
-- debug/particleerror
-- dev/bloom
-- dev/dev_measuredoor01
-- dev/dev_measuregeneric01
-- dev/dev_measuregeneric01b
-- dev/dev_normal
-- dev/downsample
-- dev/flat_normal
-- dev/graygrid
-- dev/reflectivity_*
-- editor/*
-- tools/*
-- models/editor/*
-- models/tools/*
-- vgui/hud/800corner*
-- vgui/white
-- vgui/white_additive
-- vr/*
models/
-- editor/*
-- tools/*

As for this asset pack, I was unable to get the following models to build. Many other human models would crash the asset browser, but would come out successful on the other side of a restart, but unfortunately not all of them. I am sad the vorigtaunt would not materialize, and that most of the human resistance npc's don't build, but I somehow got a few more to build than last time.

-- breen_monitor
-- vortigaunt
-- odessa
-- humans/group01/female[1,4,6]
-- humans/group01/male[1-9]
-- humans/group02/female[1,3,4,6]
-- humans/group02/male[1-9]
-- humans/group03/female_[3,4,5,6,7,8,9]
-- humans/group03/female_bloody_[2,3,4,6,7]
-- humans/group03/male_[2-9]
-- humans/group03/male_bloody_[1-9]_bloody
-- humans/group03m/*

Each game had various materials that were missing a texture map, or had an obvious typo, so those were corrected. Other than that, all vmat/vmdl files are the resulting output of the python scripts and nothing was processed through the tools and re-saved. Default reflection max was lowered (maybe too aggressively) to 0.030 down from 0.050.

Observe the following material changes here: https://paste.ee/p/BUpji

The Half-Life 2: Deathmatch and Lost-Cost VPKs for combined with hl2, but were set not to overwrite any files. Please see the following link for the full list of skipped file conflicts. https://paste.ee/p/djeZt 

ADDON: asset_pack_hl2
TOTAL: 4486 vmat_c files, 2286 vmdl_c files
================================================================================  cstrike
Here are all the materials and models from Counter-Strike: Source converted into the Source 2 format for use in your VR environments! Please see https://steamcommunity.com/sharedfiles/filedetails/?id=2094270469 for more information on these asset packs. Most importantly, a few models/materials will fail out as red outlines unless you subscribe to and include the Half-Life 2 pack.
Like the HL2 pack, certain tool/developer assets were not included, either because they were a duplicate, or seemed otherwise dubious to include. They include the following:

-- materials/dev/upscale
-- materials/tools/*
-- materials/models/shadertest/*
-- models/shadertest/*, 

I was unable to get the following models to build:

-- models/characters/hostage01
-- models/characters/hostage02

Observe the following material changes here: https://paste.ee/p/QJKlR and see this link for a list of potential file conflicts with the Half-Life 2 pack: https://paste.ee/p/koqMX

ADDON: asset_pack_cstrike
TOTAL: 3608 vmat_c files, 1407 vmdl_c files
================================================================================  dod
Here are all the materials and models from Day of Defeat: Source converted into the Source 2 format for use in your VR environments! Please see https://steamcommunity.com/sharedfiles/filedetails/?id=2094270469 for more information on these asset packs. Most importantly, a few models/materials will fail out as red outlines unless you subscribe to and include the Half-Life 2 pack.
Like the HL2 pack, certain tool/developer assets were not included, either because they were a duplicate, or seemed otherwise dubious to include. They include the following:

-- materials/dev/*
-- materials/debug/debugempty
-- materials/tools/*
-- materials/tools/editor/*
-- models/error

Observe the following material changes here: https://paste.ee/p/f9RVe and see this link for a list of potential file conflicts with the Half-Life 2 pack: https://paste.ee/p/MEk3k

ADDON: asset_pack_dod
TOTAL: 1394 vmat_c files, 818 vmdl_c files
================================================================================  portal2
ERRATA: This asset pack contains Source 1 tool textures that don't properly function in Source 2. This addon cannot be updated to correct this or assigned a lower priority in the dependancy list, so if you need to use a Source 2 tool texture, it must be extracted from core.vpk and put into your addon's game directory.
Here are all the materials from Portal 2 converted into the Source 2 format for use in your VR environments! Please see https://steamcommunity.com/sharedfiles/filedetails/?id=2094270469 for more information on these asset packs. Unlike other Valve titles, Portal 2 did not rely on a complete set of hl2 assets to function and uses comparatively fewer of those assets. I would have included the models in one download but it was too big for the VPK builder and it runs out of memory and crashes.
Observe the following material changes here: https://paste.ee/p/bDiH2

A list of all pre-processed content files shared by the hl2 asset pack can be found here: https://paste.ee/p/51sHs

ADDON: asset_pack_portal2_materials
TOTAL: 3131 vmat_c files

Here are all the models from Portal 2 converted into the Source 2 format for use in your VR environments! Please see https://steamcommunity.com/sharedfiles/filedetails/?id=2101453361 for more information on the Portal 2 asset packs.

ADDON: asset_pack_portal2_models
TOTAL: 2175 vmdl_c files
================================================================================  left4dead2
Here are all the materials (sans model files) from Left 4 Dead 2 converted into the Source 2 format for use in your VR environments! Please see https://steamcommunity.com/sharedfiles/filedetails/?id=2104098750 for more information on the Left 4 Dead 2 asset packs.
Like the HL2 pack, certain tool/developer assets were not included, either because they were a duplicate, or seemed otherwise dubious to include. They include the following:

materials/
-- debug/debugempty
-- debug/particleerror
-- dev/dev_measuredoor01
-- dev/dev_measuregeneric01
-- dev/dev_measuregeneric01b
-- dev/dev_normal
-- dev/flat_normal
-- dev/reflectivity_*
-- editor/*
-- tools/*
-- models/editor/*
-- models/props_debris/reflectivity_50b
-- models/props_fairgrounds/*reflectivity_50b
-- models/props_fortifications/reflectivity_50b
-- models/props_mill/reflectivity_50b
-- vgui/hud/800corner*
-- vgui/white
-- vgui/white_additive
models/
-- editor/*

Observe the following material changes here: https://paste.ee/p/8A8Vl

ADDON: asset_pack_left4dead2_materials
TOTAL: 2522 vmat_c files

Here are all the models (with material files) from Left 4 Dead 2 converted into the Source 2 format for use in your VR environments! Please see https://steamcommunity.com/sharedfiles/filedetails/?id=2094270469 for more information on these asset packs.
I would have included the materials in one download but this was too big for the VPK builder and it runs out of memory and crashes. This was the case with Portal 2. Unlike that game, L4D2 used many props and assets from prior Valve titles, like CSS and Half-Life 2. In trying to get the VPK build to finish, the materials for model files were put into this pack, but it was still not enough, so all compiled files from L4D2 that were found in any other asset pack was culled for release. Please include those other packs to fix a few missing textures, or to have access to all assets that were found in the Left 4 Dead game. Still, the Left 4 Dead variant of the file that I culled might have been newer, or had more material features, which is unfortunate, but likely marginal.
I could not get the following models to compile, including all the survivors. I have trouble with these character models!

-- c1_chargerexit\doors_glass_5
-- c1_chargerexit\doors_glass_6
-- c1_chargerexit\plywood_cent
-- c5_bridge_destruction\bridge_left_tower
-- c5_bridge_destruction\bridge_right_tower
-- c5m3_bridge_overpass_debris\bridgedebris_set_a
-- destruction_tanker\destruction_tanker_debris_1
-- destruction_tanker\destruction_tanker_debris_2
-- destruction_tanker\destruction_tanker_debris_4
-- hybridphysx\map1_tarp_4
-- hybridphysx\map1_tarp_3
-- hybridphysx\map1_tarp_2
-- hybridphysx\map1_tarp_1
-- hybridphysx\gasstationpart_5
-- hybridphysx\gasstationpart_4
-- hybridphysx\gasstationpart_3
-- hybridphysx\gasstationpart_1
-- hybridphysx\airliner_left_wing_secondary
-- hybridphysx\airliner_left_wing_secondary_4
-- hybridphysx\airliner_left_wing_secondary_3
-- hybridphysx\airliner_left_wing_secondary_2
-- hybridphysx\airliner_left_wing_secondary_1
-- infected\boomer
-- infected\boomette
-- infected\common_morph_test
-- infected\witch
-- props_destruction\general_dest_concrete_set
-- props_destruction\general_dest_roof_set
-- survivors\survivor_biker
-- survivors\survivor_biker_light
-- survivors\survivor_coach
-- survivors\survivor_gambler
-- survivors\survivor_manager
-- survivors\survivor_mechanic
-- survivors\survivor_manvet
-- survivors\survivor_producer
-- survivors\survivor_teenangst
-- survivors\survivor_teenangst_light

A list of all (compiled) files shared by other asset packs that were culled for this release can be found here: https://paste.ee/p/VM0rJ

ADDON: asset_pack_left4dead2_models
TOTAL: 4379 vmdl_c files, 2632 vmat_c
================================================================================  se1
Here are all the materials and models from Sin Episodes Emergence converted into the Source 2 format for use in your VR environments! Please see https://steamcommunity.com/sharedfiles/filedetails/?id=2094270469 for more information on these asset packs. In the case of this game, I did not (unlike cstrike/dod) build the mod referencing of a set of hl2 files, so, like Portal 2, the Sin Episodes pack contains various duplications of Half Life 2 content that shipped with the game. Culling the handfuls of cardboard boxes, etc, might have been desirable, but I don't have the ability (source files) or want to properly check against the base half life 2 game files. Also, Sin isn't really a addon(vpk wise) to Half-Life 2 like css/dod, came out way before Steam Pipe and Source 2013, is not a Valve game etc, so it might be proper to just ship all the files verbatim like here. This is all more of a personal note.
In any event, the amount of duplicated content seems quite small, everything builds (except the eyeballs and skys of course.) I used the default script converter refraction maximum of 0.050, instead of lowering it, as I want a bit more shininess in the map I'm working on.  I'm unsure at this point if the scripts I ran were the same ones from last time, or even if any improvements to them are available. I didn't have to do anything to get the (likely hl2) blend materials to work, and overall my procedure was honed and I built the pack in a night, I hope I didn't make a mistake. Some characters didn't build until typos were fixed, and some quick bash/sed fixed the missing files. The missing files seem to be endless amounts of alpha masks, and I presume this is junk output from the material converter script, and there are plenty of transparent materials properly converted. Finger's crossed.
The only content culled from release was the following debug/dev files:

-- materials/debug/
-- materials/engine/
-- materials/hlmv/
-- materials/shadertest/
-- materials/tools/
-- materials/vgui/hud
-- materials/models/editor/
-- models/editor/
-- models/error

Observe the following material changes (more like lost files): https://paste.ee/p/BTAOl A list of all pre-processed (before negation/cull) content files shared by the hl2 asset pack can be found here: https://paste.ee/p/LdqoD

ADDON: asset_pack_se1
TOTAL: 1104 vmdl_c files, 2713 vmat_c
================================================================================ se1 (new)
Here are all the materials and models from Sin Episodes Emergence converted into the Source 2 format for use in your VR environments! Please see the hl2 submission at https://steamcommunity.com/sharedfiles/filedetails/?id=2094270469 for more information on (older) asset packs.
This is a reupload of the Sin pack, using newer methodologies. See change notes for the original release blurb. My prior asset packs (hl2/css/dod/l4d2/p2) cannot be updated for some reason, likely because I shouldn't be uploading them, but I will fix what I can on what is present. These earlier uploads are still generally fine, however.
This and the later hl2 episode packs were assembled using more streamlined script code with better logging, more aggressive file culling, a particle conversion step, and includes many enhancements to the material script to find missing textures. The default refraction index is set to 0.0050, and missing reflection maps were replaced with normals if available.

[url=https://paste.ee/p/iyZGJ]code[/url], [url=https://paste.ee/p/xs1lH]extract[/url], [url=https://paste.ee/p/MVGua]whitespace[/url], [url=https://paste.ee/p/OTIYH]models[/url], [url=https://paste.ee/p/INATt]materials[/url], [url=https://paste.ee/p/DQ1SC]cull[/url], [url=https://paste.ee/p/c6XtB]diff[/url],

ADDON: asset_pack_se1
VPK: vpks/depot_1301_dir.vpk+se1, vpks/depot_1302_dir.vpk+se1, vpks/depot_1316_dir.vpk+se1
DEPS: asset_pack_hl2*, asset_pack_cstrike, asset_pack_dod
FILES: 973 vmdl_c, 2292 vmat_c
================================================================================ RobotRepair
Here is the ancillary portion of the Robot Repair asset pack containing models and materials and particles from The Lab experience, not segmented by Valve in the 'aperture' folder. The pack was seperated so it could be published as it was too large otherwise. See https://steamcommunity.com/sharedfiles/filedetails/?id=2727305630 for the other workshop item. These two packs don't strictly require one another, and also, some missing materials might be filled in if you use other Portal asset packs. Unlike my other asset packs, I did not convert any Source 1 content, as Robot Repair is a Source 2 engine game. The compiled map even loads in Steam VR, but naturally, everything is broken. 
This game (and the SteamVR performance test) had contained prior collections of test files, leaked content, and the like, but today is an assemblage of three collections of assets. Everything in the 'aperture' folder (found in the other workshop item) seems to be the new Portal themed content made for this experience (initially shown at GDC 2015). The second pool of content was called 'portal_2_imported', and is Valve having converted a small portion of Portal 2 Source 1 files, likely better than I could. (It is unknown if this content was enhanced in any way). Finally the 'vr' portion contained some various little bits left over from early Valve VR work, like controller models. See the SteamDB article data mining the SteamVR performance test for all the other juicy leaks since removed from public downloads.
For so few models/materials, this is a fairly large download, and you might consider using the Portal 2 asset packs to save space/bandwidth. Just about every piece of real content is included, save for close to 700 megabytes of high resolution dota 2 character skins that not come with any model files. Finally, the following debug/dev content was removed: 

-- models/dev
-- models/editor
-- materials/dev
-- materials/editor
-- materials/models/characters/hereos/
-- materials/vgui

ADDON: asset_pack_robotrepair
TOTAL: 437 vmat_c files, 137 vmdl_c files, 301 vpcf_c files

Here is the bulk portion of the Robot Repair asset pack containing models and materials from The Lab experience (already in Source 2 format) packaged for use in your VR environments! Please see https://steamcommunity.com/sharedfiles/filedetails/?id=2727290652 for more information on the Robot Repair asset packs.

ADDON: asset_pack_robotrepair_aperture
TOTAL: 284 vmat_c files, 133 vmdl_c files
================================================================================ episodic
Here are all the materials and models from Half-Life 2: Episode 1 converted into the Source 2 format for use in your VR environments! Please see https://steamcommunity.com/sharedfiles/itemedittext/?id=2737660237 for more information on these Half-Life Episode asset packs. I'm still working on the third one. Most importantly, you'll likely want to include the Half-Life 2 pack to satisfy some material dependencies.
Like the HL2 pack, certain tool/developer assets were not included, either because they were a duplicate, or seemed otherwise dubious to include. They include the following:

-- materials/dev/dev_monitor_simple
-- materials/dev/dev_monitoradditive

Observe the following material changes here: https://paste.ee/p/pC1k1 and see this link for a list of culled (by name) files already present in the Half-Life 2 pack: https://paste.ee/p/K3QEj

ADDON: asset_pack_episodic
TOTAL: 292 vmat_c files, 124 vmdl_c files
================================================================================ episodic (new)
Here are all the materials, models, and particles from Half-Life 2: Episode 1 converted into the Source 2 format for use in your VR environments! Please see the Sin submission at https://steamcommunity.com/sharedfiles/filedetails/?id=2726156711 for more information on this generation of asset packs.
This is a reupload of the original submission as it was remade using more recent methodologies. See change notes for the original release blurb. 

[url=https://paste.ee/p/iyZGJ]code[/url], [url=https://paste.ee/p/UlktB]extract[/url], [url=https://paste.ee/p/23TGE]models[/url], [url=https://paste.ee/p/xxJ2D]materials[/url], [url=https://paste.ee/p/FNvGO]particles[/url], [url=https://paste.ee/p/Jt6Hh]cull[/url], [url=https://paste.ee/p/eR4rn]diff[/url],

ADDON: asset_pack_episodic
VPK: ep1_pak_dir.vpk+episodic
DEPS: asset_pack_hl2*
FILES: 124 vmdl_c, 305 vmat_c, 2 vpcf_c
================================================================================ ep2
Here are all the materials and models from Half-Life 2: Episode 2 converted into the Source 2 format for use in your VR environments! Please see https://steamcommunity.com/sharedfiles/filedetails/?id=2094270469 for more information on these asset packs. Most importantly, you'll likely want to include the Half-Life 2 pack to satisfy some material dependencies.

Like the HL2 pack, certain tool/developer assets were not included, either because they were a duplicate, or seemed otherwise dubious to include. They include the following:

-- materials/dev/dev_energyflow

Show my work (rambling) time. This is all just notes for me really. Don't read it.

UPDATE: Ok, putting the hl2 source content into content/steamtours was a bad idea. It was the source of the endless recompilation of circular dependencies and made it so compiled materials did not save (I think). I wasn't able to see how screwed up it was until I published. I apparently forgot exactly how to stage the files with a gameinfo.gi entry since the time I made the css/dod packs, and I didn't keep enough records, so I ended up using a single 'Game' entry in the SearchPath. This satisfied some material content dependencies, but might not have been sufficient to deal with the duplicated assets between hl2 and ep2, which were causing problems, or maybe were the whole issue?. I had alot of trouble obtaining a proper 'write path', and that might have been because I needed a copy of the hl2 compiled files? No wait that doesn't make sense. My working theory about why I had to bang my head against the wall for a few days isn't very well developed.

To solve this and properly finish these asset packs, I had to cull duplicated hl2 content from the expansion packs, which is almost certainly the right thing to do anyway. I wanted to include it for completeness, or maybe they were new revisions of assets, but at the end of the day, it was almost assuredly just lazy duplication of files 20 years ago during the time when valve made games. I also culled content from ep2 that was in ep1. The end result is of the same robustness as all my other packs, I trust. Anywho...

I (re)learned alot making the two episode asset packs. Constructed in the same way as dod/strike, episodic and hl2 reference a set of half life 2 (source 2) content files (many other games often just sprinkle hl2 assets in and around their games assets). This approximates the file structure of original games/mods that used the Steam Pipe hl2 vpk files (preserving space) and is needed to support things like blend materials requiring original hl2 tga content files. With dod/cstrike I had set a separate entry in gameinfo.gi so it could find the hl2 source content files, but I forgot how to do that this time around, and found I could just put/link the materials and models directories into content/steamtours. This satisfies the asset browser/compiler, and I learned about this while at the same time learning you can do the same thing in game/steamtours, which (along with Source1Import.createStaticOverlays=1 in gameinfo.gi) allows hammer to fix the texture scale when importing Source 1 VMF map files! Previously one had to use a python script for this, and that still may be preferable (or at least easier). Also, one has to open the vmf from content/steamtours/maps and have the gameinfo.txt of the original gameinfo.txt in game/steamtours, so this is all cumbersome for sure. I still don't have the patience to port a Source 1 map, but actually got sdk_dod_flash to look pretty decent in just ten minutes from vmf conversion, but it would still take along time to do.

I barely touched the materials in episode 1, but had to fix a fair number of them by hand here in Episode 2. The lush foliage of white forest had some issues and is the real meat of this pack so I had to fix it. Original passes at these asset pack had me running big find/seds in bash to remove references to missing alpha channels and reflectance masks, but I ended up fixing everything by hand. Various spelling and errors and different file locations were fixed as per usual, but I ended up having to make my own alpha channels (maps?) by hand for around a dozen materials. Using The Gimp I would do a linear invert (everything becomes white, ctrl c, fill image with black, paste the white leave or whatever over it, and save to whatever_alpha.tga, and that seems to work. Close enough.

These packs were hard to build because the asset browser was continuously recompiling stuff (something related to human character models) over and over again in a circular fashion for most of the time in the background making everything run at like 2 frames. I imagine this was because of the bare content file function links in shoehorned into content/steamtours, but I don't really know. There was also issues when including the hl2 asset pack I've uploaded to the workshop, but that was necessary for anything, but was tripping me up early on. I had to swap back and forth between a 'tester' addon the mod I was working on while fixing things.

Most importantly for you, I _finally_ learned that ones game addon will select the first asset it finds based on the order of dependencies in addoninfo.txt. So if you include alot of these asset packs you can influence which version of a material or model you want to be selected. If I knew this at the start I might have just made each asset pack monolithic, space/downloads be damned, but oh well.

Overall, I'm generally a bit hazing on the erm, cohesiveness of my technique globally (for making all the different packs), but the end result wouldn't be much better no matter how ocd I got. In any event, I can't reupload the other ones anyway, it doesn't show up in my asset browser, and getting the hl2 assets to compile is a nightmare, I don't know how I did that one originally. Furthermore I found a new script (source1import on github) that can convert the soundscapes and particles, and the material script seems much better, but of course, it only supports Half Life Alyx's vr_complex shader. My current wip steamvr environment (which will take a very long time to make) will likely be my last submission before I quit steamvrtours and finally go whole hog on Roblox.

Observe the following material changes here: https://paste.ee/p/kWIu0 and see this link for a list of culled (by name) files already present in the Half-Life 2 and Episode 1 packs: https://paste.ee/p/yacU3

ADDON: asset_pack_ep2
TOTAL: 1060 vmat_c files, 809 vmdl_c files
================================================================================ ep2 (new)
Here are all the materials, models, and particles from Half-Life 2: Episode 2 converted into the Source 2 format for use in your VR environments! Please see the Sin submission at https://steamcommunity.com/sharedfiles/filedetails/?id=2726156711 for more information on this generation of asset packs.

This is a reupload of the original submission as it was remade using more recent methodologies. See change notes for the original release blurb.

[url=https://paste.ee/p/iyZGJ]code[/url], [url=https://paste.ee/p/Tn1W3]extract[/url], [url=https://paste.ee/p/B15D8]whitespace[/url], [url=https://paste.ee/p/itGP8]models[/url], [url=https://paste.ee/p/lj0cv]materials[/url], [url=https://paste.ee/p/vfU14]particles[/url], [url=https://paste.ee/p/qZPlq]cull[/url], [url=https://paste.ee/p/ZGvUD]diff[/url],

ADDON: asset_pack_ep2
VPK: ep2_pak_dir.vpk+ep2
DEPS: asset_pack_hl2*, asset_pack_episodic*
FILES: 809 vmdl_c, 1135 vmat_c, 621 vpcf_c
================================================================================

EOF
)
