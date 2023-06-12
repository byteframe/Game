# ==============================================================================
+ build list of vpk files from valve asset packs and core game content
  "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\bin\win64\vpk.exe" l XXX.vpk > C:\Users\byteframe\Desktop\XXX_vpk_list.txt
##------------------------------------------------------------------------------
+ extract vpk contents (materials/models) to desktop collate under one dir
+ rename/fix console/background+startup-loading* | vgui/chapters/chapter-* | vgui/backgrounds materials
+ negate files (see posts)
+ track pre-processed hl2 diff: { find XXX -type f | while read LINE; do     LINE=${LINE#*/};     if [ -e hl2/"${LINE}" ]; then       echo "${LINE}";     fi;   done } > /mnt/c/Users/byteframe/Desktop/XXX_conflicts_hl2.txt
+ merge hl2mp and lostcoast into hl2 but do not overwrite anything
+ convert textures from vtf to tga with vtfedit
+ stage files in steamtours_addons/content
+ edit global_vars.txt and convert models for each asset pack
##------------------------------------------------------------------------------
+ create convertedBumpmaps.txt in content/steamtours_addons/mod (hl2/portal2/left4dead2) or use hl2 one if building css/dod
+ run material script (from content mod dir with modname and materials location and end slash supplied, wsl hard codes)
+ if css/dod: edit gameinfo to point to steamtours_addons/asset_pack_hl2
+ run appropriate material seds 
+ build materials (with hand tweaks) then models in asset browser
##------------------------------------------------------------------------------
+ record tweaks and bash modifications and negations:
  { find asset_pack_XXX/materials/ -name *.vmat | while read LINE; do LINE=${LINE#*/}; diff  empty_steamvrhome/"${LINE}" asset_pack_XXX/"${LINE}" || echo "${LINE}"; done } > /mnt/c/Users/byteframe/Desktop/XXX_materials_diffs.txt
+ track hl2 diff: { find asset_pack_XXX -type f | while read LINE; do     LINE=${LINE#*/};     if [ -e /mnt/f/MISC/AAA_ASSET_PACKS/content/asset_pack_hl2/"${LINE}" ]; then       echo "${LINE}";     fi;   done } > /mnt/c/Users/byteframe/Desktop/XXX_processed_hl2_conflicts.txt
+ if css/dod/episodic/ep2: reset gameinfo
+ if portal2/l4d2/robotrepair: split asset pack
+ if l4d2 cull non-unique assets: { find asset_pack_left4dead2 -type f | while read LINE; do LINE=${LINE#*/}; if grep -q "${LINE}" /mnt/d/Work/Game/steamtours/asset_packs/vpk_result_*; then echo ${LINE}; fi; done } > /mnt/c/Users/byteframe/Desktop/left4dead2cull.txt`

# ============================================================================== mklink statement printer

cd /mnt/s/
for DIR in asset_pack_*; do
  mkdir -p "${GAME}"/${DIR/_/}
  mkdir ${DIR/_/}
  echo "\"AddonInfo\"{\"Dependencies\"{}}" > "${GAME}"/${DIR/_/}/addoninfo.txt;
  echo "mklink /j ${DIR/_/} S:\\${DIR}"
done
echo CD
echo CD "Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\content\steamtours_addons"

# ============================================================================== vampire material conversion

cd /mnt/s/AAA_DOWNLOAD/Vampire\ The\ Masquerade\ -\ Bloodlines/Patch_Extras/Developer\ Tools/Bloodlines\ SDK/SDKBinaries/tools/Texture\ Utils/
find /mnt/c/Users/byteframe/Desktop/materials/ -name *.tth | while read FILE; do
  if [ ! -e "${FILE/.tth/.vtf}" ]; then 
    cp "${FILE}" .
    if [ -e "${FILE/.tth/.ttz}" ]; then
      cp "${FILE/.tth/.ttz}" .
    fi
    ./TexConvert.exe "$(basename "${FILE}")" -tovtf
    rm "$(basename "${FILE}")"
    if [ -e "${FILE/.tth/.ttz}" ]; then
      rm "$(basename "${FILE/.tth/.ttz}")"
    fi
    mv -v "$(basename "${FILE/.tth/.vtf}")" $(dirname "${FILE}")
  fi
done

# ============================================================================== find some manual tweaks

find . -name *.vmat | while read FILE; do
  grep -PH "  Texture" "${FILE}"
  grep -PH "  \/\/Texture" "${FILE}"
  grep -PH "^Texture" "${FILE}"
  grep -PH "\t\/\/Texture" "${FILE}"
done
for DIR in asset_pack_*; do
  find ${DIR} -name *.neg
done

# ============================================================================== find various material errors

for DIR in asset_pack_*; do find ${DIR} -name *.vmat -exec grep -H "\.vmt\.tga\"" {} \;; done
for DIR in asset_pack_*; do find ${DIR}/ -name *.vmat -exec grep -H "models.tga" {} \;; done

# ============================================================================== find double texture references

for DIR in OOO_asset_pack_* asset_pack_*; do
  find ${DIR} -name "*.vmat" | while read LINE; do
    if [ $(grep \/TextureTranslucency "${LINE}" | wc -l) == '2' ]; then echo ${LINE}; fi;
    if [ $(grep \/TextureReflectance "${LINE}" | wc -l) == '2' ]; then echo ${LINE}; fi;
    if [ $(grep \/TextureSelfIllumMask "${LINE}" | wc -l) == '2' ]; then echo ${LINE}; fi;
  done
done

# =============================================================================== content dep mklink calls

cd "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\content"
mklink /j asset_pack_ship S:\asset_pack_ship
mklink /j asset_pack_zps S:\asset_pack_zps
mklink /j asset_pack_ep2 S:\asset_pack_ep2
mklink /j asset_pack_episodic S:\asset_pack_episodic
mklink /j asset_pack_hl2 S:\asset_pack_hl2
mklink /j asset_pack_cstrike S:\asset_pack_cstrike
mklink /j asset_pack_dod S:\asset_pack_dod
mklink /j asset_pack_portal2 S:\asset_pack_portal2
mklink /j asset_pack_left4dead2 S:\asset_pack_left4dead2

# =============================================================================== alternative invocations

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

# ============================================================================== VTF2TGA routine

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

# ============================================================================== old post-diff routine

generate_all_diffs()
{
  cd "${CONTENT}"
  for DIR in asset_pack*; do
    header ${DIR}
    find ${DIR}/ -name *.vmat -exec grep -H "//Texture" {} \;
  done
}

# ============================================================================== failed attempts

echo make_asset_pack asset_pack_hl1 3 "${SRC}/AAA_DOWNLOAD/Half-Life 2/hl1" asset_pack_hl2 "hl1_pak_dir.vpk+hl1"
echo make_asset_pack asset_pack_hl1_hd 3 "${SRC}/AAA_DOWNLOAD/Half-Life 2/hl1_hd" asset_pack_hl2 "hl1_hd_pak_dir.vpk+hl1"
echo make_asset_pack asset_pack_hl1mp 3 "${SRC}/AAA_DOWNLOAD/Half-Life 2/hl1mp" asset_pack_hl1,asset_pack_hl2 "hl1mp_pak_dir.vpk+hl1mp"
echo make_asset_pack asset_pack_ahl2 5 "${SRC}/AAA_DOWNLOAD/Action Source/ahl2" asset_pack_portal2,asset_pack_hl2,asset_pack_cstrike,asset_pack_dod,asset_pack_episodic,asset_pack_ep2,asset_pack_left4dead2 "materials.vpk+ahl2" "models.vpk+ahl2" "particles.vpk+ahl2"

# ============================================================================== scratch pad
https://steamcommunity.com/sharedfiles/filedetails/?id=2330670992

# ============================================================================== fbr results (oceanrock)

MISSING: metal -- concrete/pockedconcrete1
MISSING: metal -- floors/agedplanks1
MISSING: metal -- floors/industrial-tile1
MISSING: metal -- floors/mahogfloor
MISSING: metal -- floors/oakfloor_fb1
MISSING: metal -- floors/spaced-tiles1
MISSING: metal -- floors/stone-tile4b
UNKNOWN MATERIAL FILE TYPE: columned-lava-rock_emissive.png // COLOR: columned-lava-rock_albedo.png
MISSING: metal -- ground/grass1
UNKNOWN MATERIAL FILE TYPE: lava-and-rock_emissive.png // COLOR: lava-and-rock_albedo.png
MISSING: metal -- ground/pineneedles-ground
MISSING: ao -- ground/sand1
MISSING: ao -- ground/sandydrysoil4
MISSING: metal -- ground/spaced-tiles1
MISSING: metal -- ground/tidal-pool1
MISSING: ao -- metals/Aluminum-Scuffed
MISSING: ao -- metals/Copper-scuffed
MISSING: ao -- metals/gold-scuffed
MISSING: ao -- metals/greasy-metal-pan1
MISSING: ao -- metals/greasy-pan-2
MISSING: ao -- metals/grimy-metal
MISSING: ao -- metals/iron-rusted4
MISSING: ao -- metals/Iron-Scuffed
MISSING: ao -- metals/metal-slpotchy
MISSING: ao -- metals/oxidized-copper
MISSING: ao -- metals/pitted-rusted-metal1
MISSING: ao -- metals/rust-coated-metal
MISSING: ao -- metals/rustediron1-alt2
MISSING: ao -- metals/rustediron2
MISSING: ao -- metals/rustediron-streaks2
MISSING: normal -- metals/streakedmetal
MISSING: ao -- metals/streakedmetal
MISSING: ao -- metals/Titanium-Scuffed
MISSING: metal -- paths/pockedconcrete1
MISSING: ao -- rocks/granitesmooth1
MISSING: gloss -- rocks/lunar-rock-1
MISSING: ao -- rocks/marble-speckled
MISSING: gloss -- rocks/pebbled-counter
UNKNOWN MATERIAL FILE TYPE: slate2-tiled-ogl.png // COLOR: slate2-tiled-albedo2.png
MISSING: normal -- rocks/slate2-tiled4
MISSING: ao -- rocks/streaked-marble
UNKNOWN MATERIAL FILE TYPE: military-panel1-emissive_power.png // COLOR: military-panel1-albedo.png
MISSING: ao -- synthetic/plasticpattern1
MISSING: ao -- synthetic/synth-rubber
MISSING: ao -- wood/charcoal