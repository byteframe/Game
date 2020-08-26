-------------------------------------------------------------------------------- PREP
+ build list of vpk files from valve asset packs and core game content
+ "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\tools\steamvr_environments\game\bin\win64\vpk.exe" l XXX.vpk > C:\Users\byteframe\Desktop\XXX_vpk_list.txt
-------------------------------------------------------------------------------- ARRANGE
+ extract vpk contents to desktop collate under one root dir
+ rearrange background maps (check: find . -type f -name "background01-*" -exec grep basetexture {} \;)
+ lostcoast: fix materials/vgui/chapters/chapter1
+ negate files (see posts)
+ track pre-processed hl2 diff: { find XXX -type f | while read LINE; do     LINE=${LINE#*/};     if [ -e hl2/"${LINE}" ]; then       echo "${LINE}";     fi;   done } > /mnt/c/Users/byteframe/Desktop/XXX_conflicts_hl2.txt
+ merge hl2mp and lost cost into hl2 but do not overwrite anything
+ convert textures at root directory so it targets all games at once
+ delete vtf files
+ stage files in steamtours_addons/content
+ edit global_vars.txt and convert models for each asset pack
+ find . -name "*.vmdl" -exec sed -i -e "s/\"/\"models\//" {} \;
-------------------------------------------------------------------------------- BUILD
+ create convertedBumpmaps.txt (hl2/portal2/left4dead2) or use hl2 one if building css/dod
+ run material script
+ delete vmt
+ if css/dod: edit gameinfo to point to steamtours_addons/asset_pack_hl2
+ build materials
+ copy materials to empty_steamvrhome for comparison
+ tweak materials
+ record tweaks: { find asset_pack_XXX/materials/ -name *.vmat | while read LINE; do LINE=${LINE#*/}; diff  empty_steamvrhome/"${LINE}" asset_pack_XXX/"${LINE}" || echo "${LINE}"; done } > /mnt/c/Users/byteframe/Desktop/XXX_materials_diffs.txt
+ build models
-------------------------------------------------------------------------------- PUBLISH
+ track hl2 diff: { find asset_pack_XXX -type f | while read LINE; do     LINE=${LINE#*/};     if [ -e /mnt/f/MISC/AAA_ASSET_PACKS/content/asset_pack_hl2/"${LINE}" ]; then       echo "${LINE}";     fi;   done } > /mnt/c/Users/byteframe/Desktop/XXX_processed_hl2_conflicts.txt
+ if css/dod: reset gameinfo
+ if portal2/l4d2: split asset pack
+ if l4d2 cull non-unique assets: { find asset_pack_left4dead2 -type f | while read LINE; do LINE=${LINE#*/}; if grep -q "${LINE}" /mnt/d/Work/Game/steamtours/asset_packs/vpk_result_*; then echo ${LINE}; fi; done } > /mnt/c/Users/byteframe/Desktop/left4dead2cull.txt
+ publish
+ re-insert rejected model content files
-------------------------------------------------------------------------------- FUTURE