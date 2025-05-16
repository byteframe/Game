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

# backup to desktop
function backup()
{
  cd "${C}"/${MOD}/materials/models
  for DIR in *; do
    mkdir -p /mnt/c/Users/byteframe/Desktop/${DIR}_vmat_backup
    find ${DIR} -name "*.vmat" -exec cp {} /mnt/c/Users/byteframe/Desktop/${DIR}_vmat_backup \;
  done
  cd "${C}"/${MOD}/models
  for DIR in *; do
    mkdir -p /mnt/c/Users/byteframe/Desktop/${DIR}_vmdl_backup
    find ${DIR} -name "*.vmdl" -exec cp {} /mnt/c/Users/byteframe/Desktop/${DIR}_vmdl_backup \;
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