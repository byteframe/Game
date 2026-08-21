#!/bin/sh

D=/mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/common
C="${D}"/SteamVR/tools/steamvr_environments/content/steamtours_addons
G="${D}"/SteamVR/tools/steamvr_environments/game/steamtours_addons
S=/mnt/s/SteamLibrary/steamapps/common
L=/mnt/l/SteamLibrary/steamapps/common
X=/mnt/d/Work/Game/steamtours/asset_packs
U=/mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/workshop/content/250820
V=/mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/workshop/content/546560

# sanitize_scan_materials
MATERIAL=$(cat << EOF
// reset_vmat.sh

Layer0
{
  shader "vr_standard.vfx"

  //---- Color ----
  g_vColorTint ___TINT___
  g_vTexCoordOffset "[0.000 0.000]"
  g_vTexCoordScale "[1.000 1.000]"
  g_vTexCoordScrollSpeed "[0.000 0.000]"
  TextureColor ___COLOR___

  //---- Lighting ----
  g_flDirectionalLightmapMinZ "0.050"
  g_flDirectionalLightmapStrength "1.000"
  TextureGlossiness "materials/default/default_gloss.tga"

  //---- Normal Map ----
  TextureNormal ___NORMAL___
  
  //---- Specular ----
  //F_METALNESS_TEXTURE 1
  //F_SPECULAR 1
  //F_SPECULAR_CUBE_MAP 1
  
  //---- Cube Map ----
  g_flCubeMapBlur "0.000"
  g_flCubeMapBrightness "1.000"
  
  //---- Lighting ----
  //F_INDIRECT_TEXTURES 2
  g_flAmbientOcclusionStrengthDirectDiffuse "1.000"
  g_flAmbientOcclusionStrengthDirectSpecular "1.000"
  g_flDirectionalLightmapMinZ "0.050"
  g_flDirectionalLightmapStrength "1.000"
  g_flMetalness "0.000"
  g_vReflectanceRange "[0.000 0.1250]"
  TextureAmbientOcclusion ___AO___
  TextureGlossiness ___GLOSS___
  TextureMetalness ___METAL___
  TextureReflectance ___REFL___
}
EOF
)
function sanitize_scan_materials() {
  A=scans
  cd "${C}"/${A}/materials/models
  for DIR in *; do
    cd "${C}"/${A}/materials/models/${DIR}
    echo -e "-------- ${A}/materials/models/${DIR} --------\n"
    for FILE in *.vmat; do
      sed -i 's/\r$//' ${FILE}
      SHADER=vr_standard
        TINT=$(cat ${FILE} | grep g_vColorTint  | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}')
       COLOR=$(cat ${FILE} | grep TextureColor  | sed -e 's:\\:/:g' | awk '{print $NF}')
      NORMAL=$(cat ${FILE} | grep TextureNormal | sed -e 's:\\:/:g' | awk '{print $NF}')
       METAL=$(ls ${FILE//.vmat/_metal}.* 2> /dev/null)
       GLOSS=$(ls ${FILE//.vmat/_gloss}.* 2> /dev/null)
       REFL=$(ls ${FILE//.vmat/_SPC}.* 2> /dev/null)
          AO=$(ls ${FILE//.vmat/_ao}.* 2> /dev/null)
      if [ -z ${COLOR} ] || [ "${COLOR}" == "\"materials/default/default_color.tga\"" ] || [ "${COLOR}" == "___COLOR___" ]; then
        COLOR=$(ls ${FILE//.vmat/_color}.* 2> /dev/null)
        if [ -z ${COLOR} ]; then
          COLOR="\"materials/default/default_color.tga\""
        else
          echo "found ${DIR}/${COLOR}"
          COLOR="\"materials/models/${DIR}/${COLOR}\""
        fi
      fi
      if [ -z "${TINT}" ]; then
        TINT="\"[1.000000 1.000000 1.000000 0.000000]\""
      fi
      if [ -z ${NORMAL} ] || [ "${NORMAL}" == "\"materials/default/default_normal.tga\"" ] || [ "${NORMAL}" == "___NORMAL___" ]; then
        NORMAL=$(ls ${FILE//.vmat/_normal}.* 2> /dev/null)
        if [ -z ${NORMAL} ]; then
          NORMAL="\"materials/default/default_normal.tga\""
        else
          echo "found ${DIR}/${NORMAL}"
          NORMAL="\"materials/models/${DIR}/${NORMAL}\""
          SHADER=-${SHADER}
        fi
      else
        SHADER=-${SHADER}
      fi
      if [ -z "${REFL}" ]; then
        REFL="\"materials/default/default_refl.tga\""
      else
        echo "found ${DIR}/${REFL}"
        REFL="\"materials/models/${DIR}/${REFL}\""
        SHADER=-${SHADER}
      fi
      if [ -z "${GLOSS}" ]; then
        GLOSS="\"materials/default/default_gloss.tga\""
      else
        echo "found ${DIR}/${GLOSS}"
        GLOSS="\"materials/models/${DIR}/${GLOSS}\""
        SHADER=-${SHADER}
      fi
      if [ -z "${METAL}" ]; then
        METAL="\"materials/default/default_metal.tga\""
      else
        echo "found ${DIR}/${METAL}"
        METAL="\"materials/models/${DIR}/${METAL}\""
        SHADER=-${SHADER}
      fi
      if [ -z "${AO}" ]; then
        AO="\"materials/default/default_ao.tga\""
      else
        echo "found ${DIR}/${AO}"
        AO="\"materials/models/${DIR}/${AO}\""
        SHADER=-${SHADER}
      fi
      echo -e "${MATERIAL}" | sed -e "s:${SHADER}:vr_simple:" -e "s:___COLOR___:${COLOR}:" \
        -e "s:___NORMAL___:${NORMAL}:" -e "s:___TINT___:${TINT}:" -e "s:___GLOSS___:${GLOSS}:" -e "s:___METAL___:${METAL}:" -e "s:___AO___:${AO}:" -e "s:___REFL___:${REFL}:" > ${FILE}
      [ ${AO} != "\"materials/default/default_ao.tga\"" ] && \
        sed -i -e "s://F_INDIRECT:F_INDIRECT:" ${FILE}
      [ ${SHADER} != vr_standard ] && \
        sed -i -e "s://F_SPECULAR:F_SPECULAR:g" ${FILE}
      [ ${METAL} != "\"materials/default/default_metal.tga\"" ] && \
        sed -i -e "s://F_METALNESS_TEXTURE:F_METALNESS_TEXTURE:" ${FILE}
    done
    find . -name "*.vmat" -exec cat {} \; | grep "materials/" > texture_files_used
    for FILE in $(find . -not -name "*.vmat" -not -name "*.vmt" -not -name "*.txt" -not -name texture_files_used); do
      ! grep -qi ${FILE} texture_files_used && \
        echo "unused: ${DIR}/${FILE}"
    done
    rm texture_files_used
  done
}

# generate material group vmdl segment
function generate_skins() {
  I=-1
  find . -name "*.vmat" | while read FILE; do
    let "I=I+1"
    echo -e "\t\t\t\t{"
    echo -e "\t\t\t\t\tm_name = \"materialGroup_${I}\""
    echo -e "\t\t\t\t\tm_materialList ="
    echo -e "\t\t\t\t\t\t["
    echo -e "\t\t\t\t\t\t\t\"${FILE}\"",
    echo -e "\t\t\t\t\t\t]"
    echo -e "\t\t\t\t},"
  done
}

# take modified hammer properties and apply to vmdls
function alter_vmdl() {
  [ -z ${1} ] && A=zzz_test || A=${1}
  sed -i 's/\r$//' "${C}"/${A}/maps/model_strip.vmap.txt
  cat "${C}"/${A}/maps/model_strip.vmap.txt | while read LINE; do
    sed -i \
      -e "s:m_flFbxScale = .*:m_flFbxScale = $(echo ${LINE} | awk '{print $4}'):" \
      -e "s:m_flQCScale = .*:m_flQCScale = $(echo ${LINE} | awk '{print $4}'):" \
      -e "s:m_vOrigin = .*:m_vOrigin = \[ $(echo ${LINE} | awk '{print $1}'), $(echo ${LINE} | awk '{print $2}'), -$(echo ${LINE} | awk '{print $3}') \]:" \
      "${C}"/${A}/$(echo ${LINE} | awk '{print $7}')
  done
}

# finds roughness maps and invert them for use as gloss
function roughness_to_gloss() {
  find . -name *.vmat -exec grep -H Roughness {} \; | while read LINE; do
    LINEA=(${LINE//\"/})
    VMAT="${LINEA[0]:2:(-1)}"
    if [[ "${LINE}" == *".png"* ]]; then
      GLOSS="${LINEA[2]/.png/__inverted.png}"
      ffmpeg -hide_banner -y -nostats -loglevel 0 -i "${LINEA[2]}" -vf negate "${GLOSS}" < /dev/null
      sed -i -e "s:\"${LINEA[1]}\"\s*\"${LINEA[2]}\":\"$(echo ${LINEA[1]} | sed -e "s:Roughness:Glossiness:")\" \"${GLOSS}\":" "${VMAT}"
    else
      ROUGHA=($(echo ${LINE/*\[/} | sed -e "s:\]::" -e "s:\"::"))
      sed -i -e "s:${LINEA[1]}.*:$(echo ${LINEA[1]} | sed -e "s:Roughness:Glossiness:")\" \"[$(bc <<< ${ROUGHA[0]}-1.000 | sed -e s:-:0:) $(bc <<< ${ROUGHA[1]}-1.000 | sed -e s:-:0:) $(bc <<< ${ROUGHA[2]}-1.000 | sed -e s:-:0:)]\":" "${VMAT}"
    fi
  done
}

# modify reluctance values
function reflectance_reset() {
  if [ ! -z ${1} ]; then
    find "${C}"/${1}/ -type f -name "*.vmat" | while read FILE; do
      ! grep -q g_vReflectanceRange "${FILE}" && \
        sed -i -e 's:\.vfx":\.vfx"\n\tg_vReflectanceRange":' "${FILE}"
      sed -i -e '/g_vReflectanceRange/c\\tg_vReflectanceRange "[0.000 1.000]"' "${FILE}"
    done
    compile_addon ${1}
    load_addon ${1}
  fi
}

# find materials marked as edited
function find_edited_materials() {
  [ -z ${1} ] && unset SOURCE1IMPORT || SOURCE1IMPORT='"-not -name source1import*"'
  for SRC in /mnt/d/Source; do
    find ${SRC}/ -mindepth 1 -maxdepth 1 -type d -not -name "System Volume Information" -not -name "_*" -not -name "\$RECYCLE.BIN" ${CHECK_SOURCE1IMPORT} | while read DIR; do
      find ${DIR}/ -name "*.vmat" | while read FILE; do
        if [[ ${DIR} == */source1import_* ]]; then
          grep -H "//" "${FILE}"
        else
          grep -H "////" "${FILE}"
        fi
        ! grep -qE "g_vReflectanceRange[[:space:]]*\"\[0.000 1.000\]\"" "${FILE}" && \
          grep -H g_vReflectanceRange "${FILE}"
      done
    done
  done | tee /mnt/c/Users/byteframe/Desktop/modified_materials.txt
}

# sync: modified from list, blend/top level
function backup_modifed_materials() {
  for FILE in $(cat /mnt/c/Users/byteframe/Desktop/modified_materials.txt); do
    cp /mnt/d/Source/"${FILE}" /mnt/t/Source/"${FILE}"
  done
  find /mnt/d/Source/ -mindepth 1 -maxdepth 1 -type d -not -name "System Volume Information" -not -name "_*" -not -name "\$RECYCLE.BIN" | while read DIR; do
    cp ${DIR}/materials/*.* ${DIR/\/d/\/t}/materials
  done
}

# clear thumbnail cache before backup and existence check
function handle_cache_bins() {
  [ ! -z ${1} ] && DIRS=${1} || DIRS=$(find /mnt/v/ -mindepth 1 -maxdepth 1 -type d -not -name "System Volume Information" -not -name "_*" -not -name "\$RECYCLE.BIN")
  for DIR in ${DIRS}; do
    [ -e "${DIR}"/tools_thumbnail_cache.bin ] && \
      echo "cp /dev/null ${DIR}/tools_thumbnail_cache.bin"
    [ ! -e "${DIR}"/tools_asset_info.bin ] && [ ! -e "${DIR}"/readonly_tools_asset_info.bin ] && \
      echo "${DIR}" warning: has no asset info bin file
  done
}

# rsync backup [ /mnt/d/Source /mnt/t/Source | /mnt/v /mnt/s ]
function rsync_addons() {
  if [ ! -z ${1} ] && [ ! -z ${2} ]; then
    [ ! -z ${3} ] && unset N || N=n
    cd "${1}"
    for DIR in $(find . -maxdepth 1 -type d -not -name "source1import*" -not -name "System Volume Information" -not -name "_*" -not -name "\$RECYCLE.BIN" -not -name "." | sed "s|^\./||"); do
      if [ ! -d ${2}/"${DIR}" ]; then
        echo "ERROR: destination directory not present"
      else
        echo -e "\n#---- ${DIR} ----\n"
        rsync --delete -lruv${N} ${1}/"${DIR}"/ ${2}/"${DIR}"
        sleep 1
      fi
    done
  fi
}

# quick convert and compile of source1import addon
function compile_test_addon() {
  [ ! -z "${1}" ] && A=${1} || A=zzz_test
  ${X}/scripts/no_vtf-5.1.1/no_vtf.exe --ldr-format "tiff|tiff" --hdr-format pfm ${A}/materials/
  touch ${A}/gameinfo.txt
  for TYPE in materials models particles; do 
    if [ -d "${C}"/${A}/${TYPE} ]; then
      python /mnt/c/Program\ Files//source1import-0.3.12/utils/${TYPE}_import.py -i "${C}"/${A} -e "${C}"/${A}
      compile_addon ${A} ${TYPE}
    fi
  done
}

# check_source1import_errors
function check_source1import_errors() {
  for DIR in "${C}"/source1import_${1}*/materials; do
    find ${DIR}/ -name *.vmat \
      -exec grep  -H "\/\/" {} \
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
}

# blend_maker
function blend_maker() {
  if [ -z "${1}" ] || [ -z "${2}" ] || [ -z "${3}" ] \
  || [ ! -e "${1}" ] || [ ! -e "${2}" ] || [ ! -e "${3}" ]; then
    echo "FAILURE: missing parameters or files"
  else
    AO=$(cat "${1}" | grep TextureAmbientOcclusion | sed -e 's:\\:/:g' | awk ' {print $NF}')
    cat $(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)/blend_template.vmat | 
      sed $([ ! -z ${AO} ] && echo "-e s:////F_INDIRECT_TEXTURES:F_INDIRECT_TEXTURES: -e s:////TextureAmbientOcclusion:TextureAmbientOcclusion${AO}:" || echo) -e "s:TextureAmbientOcclusion:TextureAmbientOcclusion :" \
          -e  "s:___COLOR0___:$(cat "${1}" | grep TextureColor       | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e  "s:___COLOR1___:$(cat "${2}" | grep TextureColor       | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e  "s:___COLOR2___:$(cat "${3}" | grep TextureColor       | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e   "s:___REFL0___:$(cat "${1}" | grep TextureReflectance | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e   "s:___REFL1___:$(cat "${2}" | grep TextureReflectance | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e   "s:___REFL2___:$(cat "${3}" | grep TextureReflectance | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e  "s:___GLOSS0___:$(cat "${1}" | grep TextureGloss       | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e  "s:___GLOSS1___:$(cat "${2}" | grep TextureGloss       | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e  "s:___GLOSS2___:$(cat "${3}" | grep TextureGloss       | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e "s:___NORMAL0___:$(cat "${1}" | grep TextureNormal      | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e "s:___NORMAL1___:$(cat "${2}" | grep TextureNormal      | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e "s:___NORMAL2___:$(cat "${3}" | grep TextureNormal      | sed -e 's:\\:/:g' | awk ' {print $NF}'):"
  fi
}

# convert gif images to jpg and correct file extensions for png and jpg
function convert_gif() {
  [ -z ${4} ] && A=byteframe14 || A=${4}
  for FILE in $(find "${C}"/${A}/ -name "*.gif"); do
    ffmpeg -y -i "${FILE}" "${FILE/gif/jpg}"
  done
  find "${C}"/${A}/ -name "*.gif" -exec rm -v {} \;
  for FILE in $(find "${C}"/${A}/ -name "*.vmat"); do
    sed -i -e "s:.gif\":.jpg\":" "${FILE}"
    if [ ! -e "${G}"/media/${FILE}_c ]; then
      IMAGE=$(cat ${FILE} | grep -o materials.* | sed -e 's:"::')
      EXT=${IMAGE:(-3)}
      if [ ${EXT,,} = 'png' ] && file ${IMAGE} | grep -q 'JPEG image data' > /dev/null; then
        mv ${IMAGE} ${IMAGE:0:(-3)}jpg
        sed -i -e "s:${IMAGE}:${IMAGE:0:(-3)}jpg:" "${FILE}"
      elif [ ${EXT,,} = 'jpg' ] && file ${IMAGE} | grep -q 'PNG image data' > /dev/null; then
        mv ${IMAGE} ${IMAGE:0:(-3)}png
        sed -i -e "s:${IMAGE}:${IMAGE:0:(-3)}png:" "${FILE}"
      fi
    fi
  done
}

# create vr_simple material and vr_standard overlay from an image url
function simple_material_maker() {
  if [ ! -z ${1} ]; then
    DIR=$(echo ${1} | sed -e "s:.*//::" -e "s:/.*::" -e "s:www.::" -e "s:\.::g")
    [ ! -z ${2} ] && DIR="${2}"
    FILE=${1/*\//}
    [ -z ${3} ] && FILE="${FILE/*=/}"
    FILE="${FILE//-/_}"
    A=${4}
    [ -z ${4} ] && A=zzz_test
    [ ! -d "${C}"/${A}/materials/"${DIR}" ] && mkdir "${C}"/${A}/materials/"${DIR}"
    if [[ "${1}" == *"/original.jpg"* ]]; then
      FILE=$(echo "${1}" | sed -e "s:\/original\?.*::" -e "s:.*\/::" -e "s:-:_:g").jpg
      DIR=coverjunkie
    fi
    wget -O "${C}"/${A}/materials/"${DIR}"/"${FILE}" "${1/\&*/}"
    if [[ ${FILE} = *.webp ]]; then
      echo 'converting webp...'
      ffmpeg -i "${C}"/${A}/materials/"${DIR}"/"${FILE}" "${C}"/${A}/materials/"${DIR}"/"${FILE/.webp/.jpg}"
      rm "${C}"/${A}/materials/"${DIR}"/"${FILE}"
      FILE="${FILE/.webp/.jpg}"
    fi
    echo -e "Layer0\n{\n\tshader\t\"vr_simple.vfx\"\n\tTextureColor\t\"materials/${DIR}/${FILE}\"\n}" \
      > "${C}"/${A}/materials/"${DIR}"/"${FILE/.jpg/}".vmat
    [ ! -z ${MAKE_SIMPLE_OVERLAYS} ] &&
      echo -e "Layer0\n{\n\tshader\t\"vr_standard.vfx\"\n\tF_TRANSLUCENT\t\"1\"\n\tF_OVERLAY \"1\"\n\tTextureColor\t\"materials/${DIR}/${FILE}\"\n}" \
        > "${C}"/${A}/materials/"${DIR}"/"${FILE/.jpg/}"_overlay.vmat
  fi
}

# convert paths
function wsl_path() {
  echo ${1//\\/\/} | sed -e "s_C:/_/mnt/c/_"
}
function windows_path() {
  echo ${1//\//\\} | sed -e "s_\\\mnt\\\c_C:_"
}

# print list of files in a vpk
function vpk_list() {
  ( cd "$(dirname "${1}")" ; "${G}"/../bin/win64/vpk.exe l $(basename "${1}"))
}

# extract file from vpk
function vpk_extract() {
  [ ! -z "${2}" ] && DESTINATION="${2}" || DESTINATION="."
  [ "${3}" == yes ] && ND="" || ND="-nd"
  ~/.local/bin/vpk ${ND} -x "${DESTINATION}" -f "${4}" "${1}"
  return 1
}

# process dependency resources for a parent asset
declare -A SUBFILES
function children() {
  [ ! -z "${3}" ] && PREFIX="${3}" || PREFIX="echo "
  [ ! -z "${4}" ] && SUFFIX="${4}" || SUFFIX=""
  strings ${2}/${1}_c | grep -E "^(aperture|materials|models|particles)/.*\.(vpcf|vtex|vmat|vmesh|vphys|vseq|vagrp|vmorf|vanim)" | awk '!seen[$0]++' | while read SUBFILE; do
    if [ ${SUBFILE} != ${1} ] && ! [[ ${SUBFILES} == *${SUBFILE}* ]]; then
      SUBFILES+=(${SUBFILE})
      ${PREFIX}${SUBFILE}${SUFFIX} || children ${SUBFILE} ${2} "${PREFIX}" "${SUFFIX}"
    fi
  done
}

# update vpk_lists
function update_vpk_lists() {
  (
    cd "${G}"/../core/
    vpk_list pak01_dir.vpk > vpk_list.txt
    vpk_list pak02_dir.vpk >> vpk_list.txt
    cd "${G}"/../steamtours/
    vpk_list pak01_dir.vpk > vpk_list.txt
    vpk_list pak02_dir.vpk >> vpk_list.txt
    cd "${G}"/steamvr_home/
    vpk_list pak01_dir.vpk > vpk_list.txt
    cd /mnt/c/"Program Files (x86)"/Steam/steamapps/workshop/content/250820
    for DIR in *; do
      if [ -d ${DIR} ] && [ -e ${DIR}/${DIR}.vpk ] && [ -e ${DIR}/publish_data.txt ]; then
        vpk_list ${DIR}/${DIR}.vpk | sed -e 's/\r$//' > ${DIR}/_vpk_list.txt
        tr -d '\015' < ${DIR}/_vpk_list.txt > ${DIR}/vpk_list.txt
        rm ${DIR}/_vpk_list.txt
      fi
    done
  )
}

# load addon into tools
function load_addon() {
  ( cd "${G}"/../bin/win64 ; ./steamtourscfg.exe -addon ${1} -retail -useappid SteamVRAppID -vconport 29009 -disable_qaccessible -nominidumps -dev -developer +sv_cheats 1 -novr ${2})
}

# compile whole addon (including maps) or single resource type
function compile_addon() {
  ( "${G}"/../bin/win64/resourcecompiler.exe -nominidumps -r -i "C:/Program Files (x86)/Steam/steamapps/common/SteamVR/tools/steamvr_environments/content/steamtours_addons/${1}/${2}*" )
}

# find a file in one or more asset packs
function find_file() {
  for FILE in $*; do
    [ ${FILE:(-2)} == "_c" ] && TYPE="${G}" || TYPE="${C}"
    for P in "${TYPE}"/*; do
      [ -e "${P}/${FILE}" ] && \
        echo ${P}/${FILE}
    done
    if [ "${TYPE}" == "${G}" ]; then
      for DIR in core steamtours; do
        grep -q "${FILE}" "${G}"/../${DIR}/vpk_list.txt && \
          echo ${DIR} -- ${FILE}
      done
      for DIR in "${U}"/* ; do
        [ -e "${DIR}"/vpk_list.txt ] && grep -q "${FILE}" "${DIR}"/vpk_list.txt && \
          echo ${DIR##*/}.vpk -- ${FILE}
      done
    fi
  done
}

# generate a working set snippet from a list of files
function generate_working_set() {
  let I=0
  cat "${1}" | awk '!seen[$0]++' | while read FILE; do
    I=$((I+1))
    echo -e "\t\t\"${I}\""
    echo -e "\t\t{"
    echo -e "\t\t\t\"AssetPath\"\t\t\""${FILE}'"'
    echo -e "\t\t}"
  done
}

# find materials that only reference one texture file
function find_simple_materials() {
  find . -name "*.vmat" | while read FILE; do
    if [ $(grep -HE "\.(tga|jpg|png|tiff|tif)" "${FILE}" | grep -v materials/default | wc -l) == 1 ] && grep -q vr_standard "${FILE}" && ! grep -q F_OVERLAY "${FILE}"; then
      echo "${FILE:2}"
    fi
  done
}

# shows files in content not assigned in a vmat from within the pwd
function find_unused_texture_files() {
  mapfile TEXTURESA < <(find . -name "*.vmat" | while read VMAT; do
    for TEXTURE in $(grep -iHE "\.(tga|jpg|png|tiff|tif)" "${VMAT}" | grep -vi materials/default | awk '{print $3}'); do
      echo ${TEXTURE//\"/} | sed -e "s:\\\:/:g" | tr '[:upper:]' '[:lower:]'
    done
  done)
  mapfile TEXTURESB < <(
    for TEXTURE in $(find . -type f \( -iname \*.tga -o -iname \*.jpg -o -iname \*.png -o -iname \*.tif -o -iname \*.tiff \)); do
      echo ${TEXTURE:2} | tr '[:upper:]' '[:lower:]'
    done)
  for TEXTURE in ${TEXTURESB[@]}; do
    ! [[ ${TEXTURESA[@]} == *${TEXTURE}* ]] && \
      echo "ORPHAN FILE ON DISK: "${TEXTURE}
  done
}

# takes gif image and rolls it into an animated material ready for final correction
function gif_to_animated() {
  PREFIX=""
  [ ! -z ${2} ] && PREFIX=${2}
  ADDON=zzz_test/materials/animated
  [ ! -z ${3} ] && ADDON=${3}
  RESIZE=256
  [ ! -z ${4} ] && RESIZE=${4}
  if [ ! -z "${1}" ]; then
    if [ -e "${1}" ]; then
      DIR=${PREFIX}"$(echo ${1/.gif/} | sed -e s:.*/::)"
      mkdir -p "${C}"/"${ADDON}"/"${DIR}"
      ffmpeg -y -i "${1}" -vf mpdecimate "${1/.gif/_ff.gif}"
      WIDTH=$(identify -ping -format '%w' "${1/.gif/_ff.gif}" | head -c 3)
      HEIGHT=$(identify -ping -format '%h' "${1/.gif/_ff.gif}" | head -c 3)
      unset CROP
      [ ${WIDTH} != ${HEIGHT} ] && \
        CROP="-crop ${WIDTH}x${WIDTH}+0+0"
      convert "${1/.gif/_ff.gif}" -coalesce ${CROP} "${C}"/"${ADDON}"/"${DIR}"/"${DIR}_%03d.png" > /dev/null 2>&1
      rm "${1/.gif/_ff.gif}"
      let COUNT=$(ls -1 "${C}"/"${ADDON}"/"${DIR}"/ | wc -l)
      echo "${DIR}: ${COUNT} files ${WIDTH}x${HEIGHT}"
      if [ ${COUNT} == 0 ]; then
        return 1
      elif [ ${COUNT} -lt 72 ]; then
        for ((i = 0; i < 72-${COUNT} ; i++)); do
          cp "${C}"/"${ADDON}"/"${DIR}"/${DIR}_$(printf %03d $(echo $((COUNT-(i+2))) | sed s:-::)).png \
            "${C}"/"${ADDON}"/"${DIR}"/${DIR}_$(printf %03d $((COUNT+(i+1)))).png
        done
      elif [ ${COUNT} -gt 80 ]; then
        STEP=$(bc <<< "scale=3; ${COUNT}/64") LINE=0.0 LAST=999
        for FILE in "${C}"/"${ADDON}"/"${DIR}"/"${DIR}_"*.png; do
          LINE=$(bc <<< "scale=3; ${LINE}+1.0")
          NEXT=$(bc <<< "scale=1; ${LINE}/${STEP}")
          if [ "${NEXT/.*/}" != "${LAST/.*/}" ]; then
            LAST=${NEXT/.*/}
          else
            rm "${FILE}"
          fi
        done
      fi
      for FILE in "${C}"/"${ADDON}"/"${DIR}"/"${DIR}_"*.png; do
        convert "${FILE}" -resize ${RESIZE} "${FILE/.png/_${RESIZE}.png}" > /dev/null 2>&1
        rm "${FILE}"
      done
      { echo "sequence 0"
        echo "loop"
        let COUNT=0
        for FILE in "${C}"/"${ADDON}"/"${DIR}"/"${DIR}_"*.png; do
          let COUNT=COUNT+1
          if [ ${COUNT} -le 64 ]; then
            echo 'frame '"${DIR}"/$(echo ${FILE/*\//})' 1'
          else
            echo '//frame '"${DIR}"/$(echo ${FILE/*\//})' 1'
          fi
        done
      } > "${C}"/"${ADDON}"/"${DIR}".mks
      { echo -e 'Layer0'
        echo -e '{'
        echo -e '\tshader "vr_simple.vfx"'
        echo -e '\tF_TEXTURE_ANIMATION 1'
        echo -e '\tTextureColor "materials/'${ADDON/*materials\//}'/'"${DIR}".mks'"'
        echo -e '\tg_flAnimationTimeOffset "0.000"'
        echo -e '\tg_flAnimationTimePerFrame "0.150"'
        echo -e '\tg_nNumAnimationCells "64"'
        echo -e '\tg_vAnimationGrid "[1 1]"'
        echo -e '}'
      } > "${C}"/"${ADDON}"/"${DIR}".vmat
    fi
  fi
}

# shoehorns a vr_complex material into vr_standard
function vr_complex_transform() {
  if [ -z ${3} ]; then
    [ ! -e "${1}".backup ] && cp "${1}" "${1}".backup
    cat "${1}".backup | sed \
      -e 's:vr_glass.vfx":vr_standard.vfx"\n\t"F_TRANSLUCENT"\t"1"\n\t"F_GLASS"\t"1":' \
      -e 's:vr_simple_blend_to_xen_membrane.vfx":vr_standard.vfx"\n\t"F_BLEND"\t"1":' \
      -e 's:vr_simple_2layer_parallax.vfx":vr_standard.vfx"\n\t"F_BLEND"\t"1":' \
      -e 's:vr_simple_3layer_parallax.vfx":vr_standard.vfx"\n\t"F_BLEND"\t"2":' \
      -e 's:vr_simple_2way_blend.vfx":vr_standard.vfx"\n\t"F_BLEND"\t"1":' \
      -e 's:vr_simple_blend_to_triplanar.vfx":vr_standard.vfx"\n\t"F_BLEND"\t"1":' \
      -e 's:vr_static_overlay.vfx":vr_standard.vfx"\n\t"F_TRANSLUCENT"\t"1"\n\t"F_OVERLAY"\t"1":' \
      -e 's:vr_projected_decals.vfx":vr_standard.vfx"\n\t"F_TRANSLUCENT"\t"1"\n\t"F_OVERLAY"\t"1":' \
      -e 's:TextureColor1:TextureColor:' \
      -e 's:TextureColorA:TextureColor:' \
      -e 's:TextureColorB:TextureLayer1Color:' \
      -e 's:TextureColorC:TextureLayer2Color:' \
      -e 's:TextureNormal1:TextureNormal:' \
      -e 's:TextureNormalA:TextureNormal:' \
      -e 's:TextureNormalB:TextureLayer1Normal:' \
      -e 's:TextureRoughnessA:TextureRoughness:' \
      -e 's:TextureRoughnessB:TextureLayer1Roughness:' \
      -e 's:TextureMetalnessA:TextureMetalness:' \
      -e 's:TextureMetalnessB:TextureLayer1Metalness:' \
      -e 's:TextureReflectanceA:TextureReflectance:' \
      -e 's:TextureReflectanceB:TextureLayer1Reflectance:' \
      -e 's:TextureTintMaskA:TextureTintMask:' \
      -e 's:TextureTintMaskB:TextureLayer1TintMask:' \
      -e 's:TextureAmbientOcclusionA:TextureAmbientOcclusion:' \
      -e 's:TextureAmbientOcclusionB:TextureLayer1AmbientOcclusion:' \
      -e 's:"F_AMBIENT_OCCLUSION_TEXTURE"\s*"1":"F_INDIRECT_TEXTURES"\t"2":' \
      -e 's:"F_ENABLE_AMBIENT_OCCLUSION"\s*"1":"F_INDIRECT_TEXTURES"\t"2":' \
      -e 's:TextureGlossiness:OldGlossiness:' \
      -e 's:TextureTriplanarMask:TextureLayer1RevealMask:' \
      -e 's:TextureMask:TextureLayer1RevealMask:' \
      -e 's:g_flMetalnessA:g_flMetalness:' \
      -e 's:"TextureRoughness"\s*"materials/default/default_[a-zA-Z0-9]*_rough.png":"TextureGlossiness"\t"materials/default/default_gloss.tga":' \
        > "${1}"
    grep 'TextureRoughness' "${1}" | while read LINE; do
      ROUGH=$(echo ${LINE} | awk '{$1=""; print $0}' | sed -e 's:"::g' -e 's:\[::' -e 's:\]::' | xargs)
      GLOSS="${ROUGH/./__inverted.}"
      if ! echo ${LINE} | grep -E "(png|tga|jpg)"; then
        GLOSS="["$(echo $(bc <<< $(echo ${ROUGH} | awk '{print $1}')-1.000 | sed -e s:-:0:) $(bc <<< $(echo ${ROUGH} | awk '{print $2}')-1.000 | sed -e s:-:0:) $(bc <<< $(echo ${ROUGH} | awk '{print $3}')-1.000 | sed -e s:-:0:) 0.000000)"]"
      elif [ -e "${C}"/${2}/"${ROUGH}" ] && [ ! -e "${C}"/${2}/"${GLOSS}" ]; then
        ffmpeg -hide_banner -y -nostats -loglevel 0 -i "${C}"/${2}/"${ROUGH}" -vf negate "${C}"/${2}/"${GLOSS}" < /dev/null
      fi
      LINE=${LINE//[/\\[}
      sed -i -e "s:${LINE//]/\\]}:$(echo ${LINE} | awk '{print $1}')\t\"${GLOSS}\":" "${1}"
    done
    sed -i -e 's:Roughness:Glossiness:g' "${1}"
    grep -q TextureAmbientOcclusion "${1}" && ! grep -q F_INDIRECT_TEXTURES "${1}" && \
      sed -i -e 's:.vfx":.vfx"\n\t"F_INDIRECT_TEXTURES"\t"2\":' "${1}"
    if grep -q TextureMetalness "${1}"; then
      ! grep -q F_SPECULAR "${1}" && \
        sed -i -e 's:.vfx":.vfx"\n\t"F_SPECULAR"\t"1":' "${1}"
      ! grep -q F_METALNESS_TEXTURE "${1}" && ! grep -q F_BLEND "${1}" && \
        sed -i -e 's:.vfx":.vfx"\n\t"F_METALNESS_TEXTURE"\t"1":' "${1}"
      sed -i -e "s:\t\"TextureMetalness\":$(grep \"TextureMetalness\" "${1}" | sed s:TextureMetalness:TextureReflectance:)\n\t\"TextureMetalness\"": \
        -e "s:TextureLayer1Metalness:TextureLayer1Reflectance:" "${1}"
    fi
    grep -q F_SPECULAR "${1}" && ! grep -q F_SPECULAR_CUBE_MAP "${1}" && \
      sed -i -e 's:"F_SPECULAR"\t"1":"F_SPECULAR"\t"1"\n\t"F_SPECULAR_CUBE_MAP"\t"1":' "${1}"
    cat "${1}" | grep -E "Texture.*.(png|tga|jpg)" | while read LINE; do
      FILE=$(echo ${LINE} | awk '{print $2}' | sed -e 's:"::g')
      if [ ! -e "${C}"/${2}/${FILE} ]; then
        if [ -e "$(dirname "${1}")"/${FILE/*\//} ]; then
          mkdir -p "$(dirname "${C}"/${2}/${FILE})"
          mv "$(dirname "${1}")"/${FILE/*\//} "${C}"/${2}/${FILE}
        elif ! [[ ${FILE} == materials/default/* ]]; then
          echo 'missing texture: ' ${LINE}
        fi
        sed -i -e "s:${LINE}://${LINE}:" "${1}"
      fi
    done
    sed -i -e "s:\".*\.vfx\":\"shader\"\t\"vr_standard.vfx\":" "${1}"
    ! grep -q g_vReflectanceRange "${1}" && \
      sed -i -e 's:\.vfx":\.vfx"\n\tg_vReflectanceRange "[0.000 1.000]":' "${1}"
  fi
}

# extract/decompile resources from a source2 vpk
CLI="${X}"/scripts/cli-windows-x64/Source2Viewer-CLI.exe
DESTINATIONS_VPK="C:/Program Files (x86)/Steam/steamapps/common/Destinations/game/steamtours/pak01_dir.vpk"
ROBOTREPAIR_VPK="C:/Program Files (x86)/Steam/steamapps/common/The Lab/RobotRepair/vr/pak01_dir.vpk"
STEAMPAL_VPK="C:/Program Files (x86)/Steam/steamapps/common/Aperture Desk Job/game/steampal/pak01_dir.vpk"
CS2_VPK="C:/Program Files (x86)/Steam/steamapps/common/Counter-Strike Global Offensive/game/csgo/pak01_dir.vpk"
function source2_extract {
  VPK="C:/Program Files (x86)/Steam/steamapps/common/Half-Life Alyx/game/hlvr/pak01_dir.vpk"
  unset SKIP_VMAT_TRANSFORM
  if [ ! -z "${2}" ]; then
    if  [[ "${2}" == */steamtours/* ]] || [[ "${2}" == */RobotRepair/* ]]; then
      SKIP_VMAT_TRANSFORM=yes
    fi
    VPK=$(windows_path "${2}")
    if [[ "${VPK}" =~ ^[0-9]+$ ]]; then
      if [ -e "${U}"/${VPK}/${VPK}.vpk ]; then
        VPK=$(windows_path "C:/Program Files (x86)/Steam/steamapps/workshop/content/250820/${VPK}/${VPK}.vpk")
        SKIP_VMAT_TRANSFORM=yes
      else
        VPK=$(windows_path "C:/Program Files (x86)/Steam/steamapps/workshop/content/546560/${VPK}/${VPK}.vpk")
      fi
    fi
  fi
  ADDON=zzz_test
  [ ! -z "${3}" ] && ADDON=${3}
  FILES=$("${CLI}" -i "${VPK}" -f "${1}" -b REF | grep -E "[0-9A-F]{16}" | awk '{print $2}' | sed -e 's/\r$//')
  echo ; echo '=== [' ${1/vmdl_c/vmdl} ${FILES} ']' "4="${4} "5="${5}
  for FILE in ${1/vmdl_c/vmdl} ${FILES}; do
    echo '=== |'${FILE}
    if [[ "${FILE}" == *.vmat ]] && [ -z ${4} ]; then
      [ ! -e "${C}"/${ADDON}/"${FILE}" ] && \
        "${CLI}" -i "${VPK}" -f "${FILE}" -d -o "$(windows_path "${C}"/${ADDON}/)"
      vr_complex_transform "${C}"/${ADDON}/"${FILE}" ${ADDON} ${SKIP_VMAT_TRANSFORM}
    else
      if [[ "${FILE}" == *.vmdl  && ( "${VPK}" == *steampal* || "${VPK}" == *csgo* || ! -z ${5} ) ]]; then
        echo ---------------------------------------------------$FILE
        "${CLI}" -i "${VPK}" -f "${FILE}" -d -o "$(windows_path "${C}"/${ADDON}/)"
        [ ! -e "${C}"/${ADDON}/"${FILE}".backup ] && \
          cp "${C}"/${ADDON}/"${FILE}" "${C}"/${ADDON}/"${FILE}".backup
        MESHES=$(cat "${C}"/${ADDON}/"${FILE}".backup | grep -A3 -B1 RenderMeshFile \
          | sed -e "/_class/d" -e "s:filename = :\tm_meshFile = :" -e "s:name = :\tm_meshName = :")
        PHYSIC=$(cat "${C}"/${ADDON}/"${FILE}".backup | grep -A6 -B1 PhysicsHullFile \
          | sed -e "/_class/d" -e "s:filename = :m_meshFile = :" -e "s:name = :m_meshName = :")
        ATTACH=$(cat "${C}"/${ADDON}/"${FILE}".backup | grep -A7 -B1 '_class = "Attachment"' | sed -e "/_class/d" \
          -e "s:weight:\t\tm_flWeight:" -e "s:relative_origin:\t\tm_vTranslationOffset:" -e "s:relative_angles:\t\tm_vRotationOffset:" -e "s:parent_bone:\t\tm_influenceName:" \
          -e "s:name =:m_name =:" -e "s:ignore_rotation.*:m_influences = \n\t\t\t\t\t\t[\n\t\t\t\t\t\t\t{:" \
          -e "s:\t},:\t\t\t},\n\t\t\t\t\t\t]\n\t\t\t\t\t},:")
        ANIMS=$(cat "${C}"/${ADDON}/"${FILE}".backup | grep -A9 -B1 AnimFile \
          | sed -e "/_class/d" -e "s:source_filename = :m_Filepath = :" -e "s:children = :},:" -e "s:name = :m_Animationname = :" -e "s:hidden:m_bHidden:" \
          -e "s:fade_in_time = :m_sequenceParams = \n\t\t\t\t\t\t{\n\t\t\t\t\t\t\tm_flFadeInTime = :" -e "s:fade_out_time = :\tm_flFadeOutTime = :" \
          -e "s:looping =:}\n\t\t\t\t\t\tm_Loop = \n\t\t\t\t\t\\t{\n\t\t\t\t\t\t\tm_Loop = :" -e "s:delta =:}\n\t\t\t\t\t\tdelta =:")
        SKINS=$("${CLI}" -i "${VPK}" -f "${FILE}" -b DATA | sed -n '/m_materialGroups/,/^\t]/p' | sed -e "s:m_materials =:m_materialList =:" -e s/resource://)
        { echo -e '<!-- kv3 encoding:text:version{e21c7f3c-8a33-41c5-9977-a76d3a32aa0d} format:generic:version{7412167c-06e9-4698-aff2-e63eb59037e7} -->\n{'
          echo -e "\tm_meshList = \n\t{\n\t\tm_meshList = \n\t\t["
          echo -e "${MESHES}\n\t\t]\n\t}"
          echo -e "\tm_physicsMeshList = \n\t{\n\t\tm_meshList = \n\t\t["
          echo -e "${PHYSIC}\n\t\t]\n\t}"
          echo -e '\tm_pAttachmentLists = \n\t[\n\t\t{\n\t\t\tm_pObject = \n\t\t\t{\n\t\t\t\tm_name = ""\n\t\t\t\tm_attachments = \n\t\t\t\t[\n'"${ATTACH}"'\n\t\t\t\t]\n\t\t\t}\n\t\t},\n\t]'
          echo -e "\tm_pAnimGroup = \n\t{\n\t\tm_pObject = \n\t\t{\n\t\t\tm_Name = \"\"\n\t\t\tm_pBoneFlagList = \n\t\t\t{\n\t\t\t\tm_pObject = null\n\t\t\t}\n\t\t\tm_pSeqGroup = \n\t\t\t{\n\t\t\t\tm_pObject = null\n\t\t\t}\n\t\t\tm_pAnimGroups = [  ]\n\t\t\tm_Vanim = \n\t\t\t["
          echo -e "${ANIMS}"
          echo -e "\t\t\t]\n\t\t\tm_sScripts = [  ]\n\t\t\tm_folderNames = [  ]\n\t\t\tm_sCompileScripts = [  ]\n\t\t\tm_pActivityWhiteList = \n\t\t\t{\n\t\t\t\tm_pObject = null\n\t\t\t}\n\t\t}\n\t}"
          echo -e "\tm_pMaterialGroupList = \n\t{\n\t\tm_pObject = \n\t\t\t{\n${SKINS}\n\t\t\t}\n\t}"
          cat "${X}"/null.vmdl
        } | sed -e "/^--$/d" > "${C}"/${ADDON}/"${FILE}"
      else
        if [[ ( "${FILE}" != *.vtex || ! -z ${4} ) && ( "${FILE}" != *.vagrp || -z ${5} ) ]]; then
          "${CLI}" -i "${VPK}" -f "${FILE}" -o "$(windows_path "${G}"/${ADDON}/)"
        fi
        if [[ "${FILE}" == *.vmesh ]]; then
          for VMAT in $(${CLI} -i "$(windows_path "${G}"/${ADDON}/${FILE}_c)" -b REF | grep \.vmat | awk '{print $2'} | sed -e 's/\r$//'); do
            ( source2_extract ${VMAT} "${VPK}" ${ADDON} "${4}" "${5}" )
          done
          [ ! -z ${5} ] && \
            rm -v "${G}"/${ADDON}/"${FILE}"_c
        fi
      fi
    fi
  done
}