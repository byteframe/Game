#!/bin/sh

PROJECT=/mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/common/SteamVR/tools/steamvr_environments/content/steamtours_addons/byteframe13
if [ -z ${3} ]; then
	echo "not enough input"
	exit 1
fi
NAME=${3}
if [[ ${1} == *sharetextures* ]]; then
  NAME=${NAME}_ST
fi
echo "${PROJECT}"/materials/${2}/${NAME}
if [ ! -d "${PROJECT}"/materials/${2}/${NAME} ]; then
	mkdir -p "${PROJECT}"/materials/${2}/${NAME}
	wget "${1}" -O "${NAME}".zip
	unzip -q -j "${NAME}".zip -x "*.usd*" "*_PREVIEW*" -d "${PROJECT}"/materials/${2}/${NAME}
	rm "${NAME}".zip
fi
MATERIAL=$(cat << EOF
Layer0
{
  shader "vr_standard.vfx"

  //---- Lighting ----
  F_INDIRECT_TEXTURES 2 // Ambient Occlusion Texture

  //---- Specular ----
  F_METALNESS_TEXTURE 1
  F_SPECULAR 1
  F_SPECULAR_CUBE_MAP 1 // In-game Cube Map

  //---- Translucent ----
  F_ALPHA_TEST 1

  //---- Self Illum ----
  F_SELF_ILLUM 1

  //---- Color ----
  g_vColorTint "[1.000000 1.000000 1.000000 0.000000]"
  g_vTexCoordOffset "[0.000 0.000]"
  g_vTexCoordScale "[1.000 1.000]"
  g_vTexCoordScrollSpeed "[0.000 0.000]"
  TextureColor "materials/_COLOR_FILE_"

  //---- Cube Map ----
  g_flCubeMapBlur "0.000"
  g_flCubeMapBrightness "1.000"

  //---- Lighting ----
  g_flAmbientOcclusionStrengthDirectDiffuse "1.000"
  g_flAmbientOcclusionStrengthDirectSpecular "1.000"
  g_flDirectionalLightmapMinZ "0.050"
  g_flDirectionalLightmapStrength "1.000"
  g_vMetalnessRange "[0.000 1.000]"
  g_vReflectanceRange "[0.000 1.000]"
  TextureAmbientOcclusion "materials/_AO_FILE_"
  TextureGlossiness "materials/_GLOSS_FILE_"
  TextureMetalness "materials/_METAL_FILE_"
  TextureReflectance "materials/_REFLECTANCE_FILE_"

  //---- Normal Map ----
  TextureNormal "materials/_NORMAL_FILE_"

  //---- Self Illum ----
  g_flSelfIllumScale "1.000"
  g_vSelfIllumScrollSpeed "[0.000 0.000]"
  g_vSelfIllumTint "[1.000000 1.000000 1.000000 0.000000]"
  TextureSelfIllumMask "materials/_SELFILLUM_FILE_"

  //---- Translucent ----
  g_flAlphaTestReference "0.500"
  TextureTranslucency "materials/_OPACITY_FILE_"
}
EOF
)
cd "${PROJECT}"/materials/${2}/${NAME}
for FILE in *.*; do 
	if [[ ${FILE} != h.* ]] && [[ ${FILE} != H.* ]] \
	&& [[ ${FILE} != *height* ]] && [[ ${FILE} != *Height* ]] && [[ ${FILE} != *__inverted* ]] \
	&& [[ ${FILE} != *_*isplacement* ]]; then
		if [[ ${FILE} == d.* ]] || [[ ${FILE} == D.* ]] \
		|| [[ ${FILE} == *lbedo* ]] || [[ ${FILE} == *olor.* ]] || [[ ${FILE} == *alb.* ]] || [[ ${FILE} == *base*olor* ]] \
		|| [[ ${FILE} == *diffuse* ]] || [[ ${FILE} == *Diffuse* ]]; then
			COLOR=${FILE}
		elif [[ ${FILE} == n.* ]] || [[ ${FILE} == N.* ]] \
		||   [[ ${FILE} == *ormal* ]] || [[ ${FILE} == *-norrmal* ]] || [[ ${FILE} == *-norma-ogl* ]] || [[ ${FILE} == *-nmap-ogl* ]] \
		||   [[ ${FILE} == *_NormalGL* ]]; then
			NORMAL=${FILE}
		elif [[ ${FILE} == *mbient* ]] || [[ ${FILE} == *AO* ]] || [[ ${FILE} == *ao* ]] \
			|| [[ ${FILE} == *mbient*cclusion* ]]; then
			AO=${FILE}
		elif [[ ${FILE} == i.* ]] || [[ ${FILE} == I.* ]] || [[ ${FILE} == e.* ]] \
			|| [[ ${FILE} == *_IdMask.* ]] || [[ ${FILE} == *_ID* ]]; then
			SELFILLUM=${FILE}
		elif [[ ${FILE} == *_Opacity.* ]] || [[ ${FILE} == *_opacity.* ]]; then
			OPACITY=${FILE}
		elif [[ ${FILE} == *specular.* ]] || [[ ${FILE} == *Specular.* ]] \
			|| [[ ${FILE} == *specularLevel.* ]]; then
			REFLECTANCE=${FILE}

		# invert roughness with ffmpeg for use as gloss map
		elif [[ ${FILE} == r.* ]] || [[ ${FILE} == R.* ]] \
			|| [[ ${FILE} == *oughn*ess* ]] || [[ ${FILE} == *rough.* ]] || [[ ${FILE} == *-rough*.* ]]; then
			GLOSS=${FILE/.png/__inverted.png}
			GLOSS=${GLOSS/.tif/__inverted.tif}
			GLOSS=${GLOSS/.jpg/__inverted.jpg}
			ffmpeg -hide_banner -y -loglevel error -i ${FILE} -vf negate ${GLOSS}
			rm ${FILE}

		# or use gloss map if already present
		elif [[ ${FILE} == *_*lossiness* ]] || [[ ${FILE} == *_Gloss.* ]]; then
			GLOSS=${FILE}
			
		# find other maps first to reduce chance of mistaking the metal map
		elif [[ ${FILE} == m.* ]] || [[ ${FILE} == M.* ]] \
			|| [[ ${FILE} == *etal*ness* ]] || [[ ${FILE} == *etal*ic* ]] || [[ ${FILE} == *metal.* ]]; then
			METAL=${FILE}
		else
			echo "UNKNOWN MATERIAL FILE TYPE: ${FILE} // COLOR: ${COLOR}"
			if [ -z ${COLOR} ]; then
				COLOR=${FILE}
			fi
		fi
	fi
done

# write material file
VMAT="${PROJECT}"/materials/${2}/${NAME}.vmat
echo "writing: ${VMAT}"
echo -e "${MATERIAL}" > _${NAME}.vmat
if [ -z ${COLOR} ]; then
	echo "MISSING: color -- ${NAME}"
	sed -i -e s:_COLOR_FILE_:default/default_color.tga: _${NAME}.vmat
else
	sed -i -e s:_COLOR_FILE_:${2}/${NAME}/${COLOR}: _${NAME}.vmat
fi
if [ -z ${NORMAL} ]; then
	echo "MISSING: normal -- ${NAME}"
	sed -i -e s:_NORMAL_FILE_:default/default_normal.tga: _${NAME}.vmat
else
	sed -i -e s:_NORMAL_FILE_:${2}/${NAME}/${NORMAL}: _${NAME}.vmat
fi
if [ -z ${METAL} ]; then
	echo "MISSING: metal -- ${NAME}"
	sed -i -e /TextureMetalness/d _${NAME}.vmat
	sed -i -e /F_METALNESS_TEXTURE/d _${NAME}.vmat
	sed -i -e 's/g_vMetalnessRange "\[0.000 1.000\]"/g_flMetalness "0.000"/' _${NAME}.vmat
else
	sed -i -e s:_METAL_FILE_:${2}/${NAME}/${METAL}: _${NAME}.vmat
fi
if [ -z ${AO} ]; then
	echo "MISSING: ao -- ${NAME}"
	sed -i -e /TextureAmbientOcclusion/d _${NAME}.vmat
	sed -i -e /F_INDIRECT_TEXTURES/d _${NAME}.vmat
	sed -i -e /g_flAmbientOcclusionStrengthDirectDiffuse/d _${NAME}.vmat
	sed -i -e /g_flAmbientOcclusionStrengthDirectSpecular/d _${NAME}.vmat
else
	sed -i -e s:_AO_FILE_:${2}/${NAME}/${AO}: _${NAME}.vmat
fi
if [ -z ${GLOSS} ]; then
	echo "MISSING: gloss -- ${NAME}"
	sed -i -e s:_GLOSS_FILE_:default/default_gloss.tga: _${NAME}.vmat
else
	sed -i -e s:_GLOSS_FILE_:${2}/${NAME}/${GLOSS}: _${NAME}.vmat
fi
if [ -z ${REFLECTANCE} ]; then
	echo "MISSING: reflectance -- ${NAME}"
	sed -i -e s:_REFLECTANCE_FILE_:default/default_refl.tga: _${NAME}.vmat
else
	sed -i -e s:_REFLECTANCE_FILE_:${2}/${NAME}/${REFLECTANCE}: _${NAME}.vmat
fi
if [ -z ${SELFILLUM} ]; then
	sed -i -e /F_SELF_ILLUM/d _${NAME}.vmat
	sed -i -e /SelfIllum/d _${NAME}.vmat
else
	echo "FOUND: selfillum -- ${NAME}"
	sed -i -e s:_SELFILLUM_FILE_:${2}/${NAME}/${SELFILLUM}: _${NAME}.vmat
fi
if [ -z ${OPACITY} ]; then
	sed -i -e /F_ALPHA_TEST/d _${NAME}.vmat
	sed -i -e /g_flAlphaTestReference/d _${NAME}.vmat
	sed -i -e /TextureTranslucency/d _${NAME}.vmat
else
	echo "FOUND: opacity -- ${NAME}"
	sed -i -e s:_OPACITY_FILE_:${2}/${NAME}/${OPACITY}: _${NAME}.vmat
fi
mv -v _${NAME}.vmat "${VMAT}"
echo DONE