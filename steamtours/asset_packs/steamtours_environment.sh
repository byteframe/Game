#!/bin/sh

S=/mnt/s/SteamLibrary/steamapps/common
D=/mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/common
C=${D}/SteamVR/tools/steamvr_environments/content/steamtours_addons
G=${D}/SteamVR/tools/steamvr_environments/game/steamtours_addons
W=/mnt/d/Work/Game/steamtours/asset_packs/scripts
X=/mnt/d/Work/Game/steamtours/asset_packs
N=/mnt/c/Program\ Files/Notepad++/notepad++.exe

# XXX xxxxxxxxxxxxx
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
  g_vReflectanceRange "[0.000 1.000]"
  TextureAmbientOcclusion ___AO___
  TextureGlossiness ___GLOSS___
  TextureMetalness ___METAL___
  TextureReflectance "materials/default/default_refl.tga"
}
EOF
)
function ZZZ_TEST()
{
  MOD=zzz_test
  cd "${C}"/${MOD}/materials/models
  for DIR in *; do
    if [ ${DIR} != "props" ] && [ ${DIR} != "character" ] && [ ${DIR} != "alternate" ]; then
      cd "${C}"/${MOD}/materials/models/${DIR}
      echo -e "-------- ${MOD}/materials/models/${DIR} --------\n"
      for FILE in *.vmat; do
        sed -i 's/\r$//' ${FILE}
          TINT=$(cat ${FILE} | grep g_vColorTint  | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}')
         COLOR=$(cat ${FILE} | grep TextureColor  | sed -e 's:\\:/:g' | awk '{print $NF}')
        NORMAL=$(cat ${FILE} | grep TextureNormal | sed -e 's:\\:/:g' | awk '{print $NF}')
         METAL=$(ls ${FILE//.vmat/_metal}.* 2> /dev/null)
         GLOSS=$(ls ${FILE//.vmat/_gloss}.* 2> /dev/null)
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
        if [ -z ${NORMAL} ] || [ "${NORMAL}" == "\"materials/default/default_normal.tga\"" ] || [ "${NORMAL}" == "___NORMAL___" ]; then
          NORMAL=$(ls ${FILE//.vmat/_normal}.* 2> /dev/null)
          if [ -z ${NORMAL} ]; then
            NORMAL="\"materials/default/default_normal.tga\""
          else
            echo "found ${DIR}/${NORMAL}"
            NORMAL="\"materials/models/${DIR}/${NORMAL}\""
          fi
        fi
        if [ -z "${TINT}" ]; then
          TINT="\"[1.000000 1.000000 1.000000 0.000000]\""
        fi
        if [ -z "${GLOSS}" ]; then
          GLOSS="\"materials/default/default_gloss.tga\""
        else
          echo "found ${DIR}/${GLOSS}"
          GLOSS="\"materials/models/${DIR}/${GLOSS}\""
        fi
        if [ -z "${METAL}" ]; then
          METAL="\"materials/default/default_metal.tga\""
        else
          echo "found ${DIR}/${METAL}"
          METAL="\"materials/models/${DIR}/${METAL}\""
        fi
        if [ -z "${AO}" ]; then
          AO="\"materials/default/default_ao.tga\""
        else
          echo "found ${DIR}/${AO}"
          AO="\"materials/models/${DIR}/${AO}\""
        fi
        echo -e "${MATERIAL}" > ${FILE}
        sed -i -e "s:___COLOR___:${COLOR}:" -e "s:___NORMAL___:${NORMAL}:" -e "s:___TINT___:${TINT}:" -e "s:___GLOSS___:${GLOSS}:" -e "s:___METAL___:${METAL}:" -e "s:___AO___:${AO}:" ${FILE}
        if [ ${AO} != "\"materials/default/default_ao.tga\"" ]; then
          sed -i -e "s://F_INDIRECT:F_INDIRECT:" ${FILE}
        fi
      done

      # find unused texture files
      find . -name "*.vmat" -exec cat {} \; | grep "materials/" > texture_files_used
      for FILE in $(find . -not -name "*.vmat" -not -name "*.vmt" -not -name "*.txt" -not -name texture_files_used); do
        if ! grep -qi ${FILE} texture_files_used; then
          echo "unused: ${DIR}/${FILE}"
        fi
      done
      rm texture_files_used
    fi
  done
}

# take modified hammer properties and apply to vmdl
function alter_vmdl()
{
  cd "${C}"/${MOD}
  sed -i 's/\r$//' maps/model_strip.vmap.txt
  cat maps/model_strip.vmap.txt | while read LINE; do
    sed -i \
      -e "s:m_flFbxScale = .*:m_flFbxScale = $(echo ${LINE} | awk '{print $4}'):" \
      -e "s:m_flQCScale = .*:m_flQCScale = $(echo ${LINE} | awk '{print $4}'):" \
      -e "s:m_vOrigin = .*:m_vOrigin = \[ $(echo ${LINE} | awk '{print $1}'), $(echo ${LINE} | awk '{print $2}'), -$(echo ${LINE} | awk '{print $3}') \]:" \
      $(echo ${LINE} | awk '{print $7}')
  done
}

# finds roughness maps and inverts them for use as gloss
function roughness_to_gloss()
{
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
function reflectance_change()
{
  find . -type f -name "*.vmat" | while read FILE; do
    if ! grep -q g_vReflectanceRange ${FILE}; then
      sed -i -e 's:\.vfx":\.vfx"\n\tg_vReflectanceRange "[0.000 0.050]":' ${FILE}
    elif echo ${FILE} | grep -qi metal_disabled; then
      sed -i -e '/g_vReflectanceRange/c\  g_vReflectanceRange "[0.500 0.750]"' ${FILE}
    else
      sed -i -e '/g_vReflectanceRange/c\  g_vReflectanceRange "[0.000 0.050]"' ${FILE}
    fi
  done
}
function reflectance_reset()
{
  ADDON=${1}
  if [ ! -z ${1} ] && [ -d "${C}"/${ADDON} ]; then
    cd "${C}"/${ADDON}
    if [ ${ADDON} != hlvr ]; then
      find . -type f -name "*.vmat" -exec sed -i -e '/g_vReflectanceRange/c\  g_vReflectanceRange "[0.000 1.000]"' {} \;
    else
      find . -type f -name "*.vmat" -exec sed -i -e 's:g_vReflectanceRange "\[0.000 0.050\]":g_vReflectanceRange "[0.000 1.000]":' {} \;
    fi
    "${G}"/../bin/win64/resourcecompiler.exe -nominidumps -r -i "C:/Program Files (x86)/Steam/steamapps/common/SteamVR/tools/steamvr_environments/content/steamtours_addons/${ADDON}/${TYPE}/*"
    ( cd "${G}"/../bin/win64 ; ./steamtourscfg.exe -addon ${ADDON} -retail -useappid SteamVRAppID -vconport 29009 -disable_qaccessible -nominidumps -dev -developer +sv_cheats 1 -novr)
  fi
}

# find materials marked as edited
function find_edited_materials()
{
  for SRC in /mnt/d/Source /mnt/s; do
    cd "${SRC}"
    find . -mindepth 1 -maxdepth 1 -type d -not -name "System Volume Information" -not -name "_*" -not -name "\$RECYCLE.BIN" | while read DIR; do
      find ${DIR} -name "*.vmat" | while read FILE; do
        if [[ ${DIR} == source1import_* ]]; then
          grep -H "//" "${FILE}"
        else
          grep -H "////" "${FILE}"
        fi
        if ! grep -qE "g_vReflectanceRange[[:space:]]*\"\[0.000 1.000\]\"" "${FILE}"; then
          grep -H g_vReflectanceRange "${FILE}"
        fi
      done
    done
  done | tee /mnt/c/Users/byteframe/Desktop/modified_materials.txt
}

# sync: modified from list, blend/top level
function backup_modifed_materials()
{
  cd /mnt/d/Source
  for FILE in $(cat /mnt/c/Users/byteframe/Desktop/modified_materials.txt); do
    cp /mnt/d/Source/"${FILE}" /mnt/t/Source/"${FILE}"
  done
  find . -mindepth 1 -maxdepth 1 -type d -not -name "System Volume Information" -not -name "_*" -not -name "\$RECYCLE.BIN" | while read DIR; do
    cp ${DIR}/materials/*.* /mnt/t/${DIR}/materials
  done
}

# clear thumbnail cache before backup and existence check
function handle_cache_bins()
{
  cd /mnt/v
  for DIR in *; do
    if [ -e ${DIR}/tools_thumbnail_cache.bin ]; then
      cp /dev/null ${DIR}/tools_thumbnail_cache.bin
    fi
    if [ ! -e ${DIR}/tools_asset_info.bin ]; then
      echo ${DIR} warning: has no asset info bin file
    fi
  done
}

# rsync backup [/mnt/v /mnt/x | /mnt/s /mnt/p | /mnt/l /mnt/p/____l_backup | /mnt/s /mnt/r | /mnt/l /mnt/r/____l_backup | /mnt/d/Source /mnt/t/Source]
function rsync_addons()
{
  SRC=${1}
  DST=${2}
  unset N
  [ -z ${3} ] && N=n
  cd "${SRC}"
  for DIR in $(find . -maxdepth 1 -type d -not -name "System Volume Information" -not -name "_*" -not -name "\$RECYCLE.BIN" -not -name "." | sed "s|^\./||"); do
    if [ ! -d ${DST}/"${DIR}" ]; then
      echo "ERROR: destination directory not present"
    else
      echo -e "\n#---- ${DIR} ----\n"
      echo rsync --delete -lruv${N} ${SRC}/"${DIR}"/ ${DST}/"${DIR}"
    fi
  done
}

# compile_test_addon
function compile_test_addon()
{
  cd "${C}"
  ADDON=zzz_test
  [ ! -z "${1}" ] && ADDON=${1}
  "${W}"/no_vtf-5.1.1/no_vtf.exe --ldr-format "tiff|tiff" --hdr-format pfm ${ADDON}/materials/
  touch "${ADDON}"/gameinfo.txt
  for TYPE in materials models particles; do 
    if [ -d "${C}"/${ADDON}/${TYPE} ]; then
      python "${W}"/source1import-0.3.12/utils/${TYPE}_import.py -i "${C}"/${ADDON} -e "${C}"/${ADDON}
      "${G}"/../bin/win64/resourcecompiler.exe -nominidumps -r -i "C:/Program Files (x86)/Steam/steamapps/common/SteamVR/tools/steamvr_environments/content/steamtours_addons/${ADDON}/${TYPE}/*"
    fi
  done
}

# check_source1import_errors
function check_source1import_errors()
{
  cd "${C}"
  for DIR in source1import_*/materials; do
    find ${DIR} -name *.vmat \
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
function blend_maker()
{
  if [ -z "${1}" ] || [ -z "${2}" ] || [ -z "${3}" ] \
  || [ ! -e "${1}" ] || [ ! -e "${2}" ] || [ ! -e "${3}" ]; then
    echo "FAILURE: missing parameters or files"
  else
    AO=$(cat "${1}" | grep TextureAmbientOcclusion | sed -e 's:\\:/:g' | awk ' {print $NF}')
    cat $(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)/blend_template.vmat | 
      sed $([ ! -z ${AO} ] && echo "-e s:////F_INDIRECT_TEXTURES:F_INDIRECT_TEXTURES: -e s:////TextureAmbientOcclusion:TextureAmbientOcclusion${AO}:" || echo) -e "s:TextureAmbientOcclusion:TextureAmbientOcclusion :" \
          -e  "s:___COLOR0___:$(cat "${1}" | grep TextureColor  | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e  "s:___COLOR1___:$(cat "${2}" | grep TextureColor  | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e  "s:___COLOR2___:$(cat "${3}" | grep TextureColor  | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e  "s:___GLOSS0___:$(cat "${1}" | grep TextureGloss  | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e  "s:___GLOSS1___:$(cat "${2}" | grep TextureGloss  | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e  "s:___GLOSS2___:$(cat "${3}" | grep TextureGloss  | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e "s:___NORMAL0___:$(cat "${1}" | grep TextureNormal | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e "s:___NORMAL1___:$(cat "${2}" | grep TextureNormal | sed -e 's:\\:/:g' | awk ' {print $NF}'):" \
          -e "s:___NORMAL2___:$(cat "${3}" | grep TextureNormal | sed -e 's:\\:/:g' | awk ' {print $NF}'):"
  fi
}

# convert gif images to jpg
function convert_gif()
{
  ADDON=${4}
  [ -z ${4} ] && ADDON=byteframe14
  for FILE in $(find "${C}"/${ADDON} -name "*.gif"); do ffmpeg -y -i "${FILE}" "${FILE/gif/jpg}"; done
  find "${C}"/${ADDON} -name "*.gif" -exec rm -v {} \;
  for FILE in $(find "${C}"/${ADDON} -name "*.vmat"); do sed -i -e "s:.gif\":.jpg\":" "${FILE}"; done
  for FILE in $(find "${C}"/${ADDON} -name "*.vmat"); do
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

# create vr_simple material from image url
function simple_material_maker()
{
  if [ ! -z ${1} ]; then
    DIR=$(echo ${1} | sed -e "s:.*//::" -e "s:/.*::" -e "s:www.::" -e "s:\.::g")
    [ ! -z ${2} ] && DIR="${2}"
    FILE=${1/*\//}
    [ -z ${3} ] && FILE="${FILE/*=/}"
    FILE="${FILE//-/_}"
    ADDON=${4}
    [ -z ${4} ] && ADDON=byteframe14
    [ ! -d "${C}"/${ADDON}/materials/"${DIR}" ] && mkdir "${C}"/${ADDON}/materials/"${DIR}"
    wget -O "${C}"/${ADDON}/materials/"${DIR}"/"${FILE}" "${1}"
    echo -e "Layer0\n{\n\tshader\t\"vr_simple.vfx\"\n\tTextureColor\t\"materials/${DIR}/${FILE}\"\n}" \
      > "${C}"/${ADDON}/materials/"${DIR}"/"${FILE/./}".vmat
  fi
}