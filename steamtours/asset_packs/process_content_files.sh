#!/bin/sh

if [ -z "${C}" ]; then
  echo "missing environmental variables"
  exit 0
fi

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

# finds a roughness map and makes an inverted copy and modify the material
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

# update vmat_c timestamps
function touch_vmatc()
{
  for FILE in *.vmat_c; do
    touch "${C}"/${1}/materials/${FILE/_c} -r ${FILE}
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

# replace missing transparency maps with the color (incorrect)
function replace_trans_with_color()
{
  find . -name "*.vmat" | while read VMAT; do
    grep -o "materials/.*\.png" ${VMAT} | while read FILE; do
      if [ ! -e "${FILE}" ] && [[ "${FILE}" != *"_rough.png" ]] && [[ "${FILE}" != *"_metal.png" ]]; then
        COLOR=$(echo $(grep "\"TextureColor\"" "${VMAT}" | sed -e "s:\"::g" -e s:TextureColor::))
        sed -i -e "s:${FILE}:${COLOR}:" "${VMAT}"
      fi
    done
  done
}

# find materials marked as edited
function find_edited_materials()
{
  for SRC in /mnt/d/Source /mnt/s; do
    cd "${SRC}"
    find . -mindepth 1 -maxdepth 1 -type d -not -name "System Volume Information" -not -name "_*" -not -name "\$RECYCLE.BIN" -not -name "*source1import_*" | while read DIR; do
      find ${DIR} -name "*.vmat" | while read FILE; do
        if [[ ${DIR} == source1import_* ]]; then
          grep -H "//" "${FILE}"
        else
          grep -H "////" "${FILE}"
        fi
      done
    done
  done
}

# sync: modified from list, blend/top level, whole addons excluding source1import
function backup_modifed_materials()
{
  cd /mnt/d/Source
  for FILE in $(cat /mnt/c/Users/byteframe/Desktop/cp.txt); do
    cp /mnt/d/Source/"${FILE}" /mnt/t/Source/"${FILE}"
  done
  find . -mindepth 1 -maxdepth 1 -type d -not -name "System Volume Information" -not -name "_*" -not -name "\$RECYCLE.BIN" | while read DIR; do
    cp ${DIR}/materials/*.* /mnt/t/${DIR}/materials
  done
}

# quick backup to desktop of vmat/vmdl files
function desktop_backup_vmat_vmdl()
{
  ADDON=${1}
  cd "${C}"/${ADDON}/materials/models
  for DIR in *; do
    mkdir -p /mnt/c/Users/byteframe/Desktop/${DIR}_vmat_backup
    find ${DIR} -name "*.vmat" -exec cp {} /mnt/c/Users/byteframe/Desktop/${DIR}_vmat_backup \;
  done
  cd "${C}"/${ADDON}/models
  for DIR in *; do
    mkdir -p /mnt/c/Users/byteframe/Desktop/${DIR}_vmdl_backup
    find ${DIR} -name "*.vmdl" -exec cp {} /mnt/c/Users/byteframe/Desktop/${DIR}_vmdl_backup \;
  done
}

# prints rsync commands for src/dst
function rsync_addons()
{
  N=n
  SRC=/mnt/v
  DST=/mnt/x
  cd "${SRC}"
  for DIR in $(find . -maxdepth 1 -type d -not -name "System Volume Information" -not -name "_*" -not -name "\$RECYCLE.BIN" -not -name "." -not -name "source1import_*" | sed "s|^\./||"); do
    if [ ! -d ${DST}/"${DIR}" ]; then
      echo "ERROR: destination directory not present"
    else
      echo -e "\n#---- ${DIR} ----\n"
      echo rsync --delete --size-only -lruv${N} ${SRC}/"${DIR}"/ ${DST}/"${DIR}"
    fi
  done
}