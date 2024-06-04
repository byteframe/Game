# select addon (lebedevartem,sharetextures_extra,sharetextures,freepbr,ambientcg)
if [ -z ${1} ]; then
  echo "no arguments"
  exit 1
fi
PACK=${1}

# ensure materials change directory
C=/mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/common/SteamVR/tools/steamvr_environments/content/steamtours_addons
cd "${C}"/${PACK}/materials || exit 1

# extract zip files (ensure clean filenames)
for FILE in $(find . -name "*.zip"); do
  mkdir -p ${FILE/.zip/}
  unzip -j -x ${FILE} -d ${FILE/.zip/}
done

# prune models and other cruft
find . -name "*.ini" -or -name "*.txt" -or -name "*.zip" -or -name "*.usda" -or -name "*.usdc" -or -name "*.mtlx" -or -name "*NormalDX.*" -or -iname "*_preview.*" | while read LINE; do rm -v ${LINE}; done

# fix whitespace and dashes
find . -mindepth 2 -name "*\ *" -type d | while read FILE; do mv -v "${FILE}" "${FILE// /_}"; done
find . -name "*\ *" -type d | while read FILE; do mv -v "${FILE}" "${FILE// /_}"; done
find . -name "*\ *"  | while read FILE; do mv -v "${FILE}" "${FILE// /_}"; done
find . -name "*_-_*" | while read FILE; do mv -v "${FILE}" "${FILE//_-_/-}"; done
find . -name "*-_*"  | while read FILE; do mv -v "${FILE}" "${FILE//-_/-}"; done
find . -name "*_-*"  | while read FILE; do mv -v "${FILE}" "${FILE//_-/-}"; done

# remove directory suffixes
find . -type d -name "*_2K-PNG" | while read FILE; do mv -v "${FILE}" "${FILE//_2K-PNG/}"; done
find . -type d -name "*-2K"     | while read FILE; do mv -v "${FILE}" "${FILE//-2K/}"; done
find . -type d -name "*-bl"     | while read FILE; do mv -v "${FILE}" "${FILE//-bl/}"; done
find . -type d -name "*_bl"     | while read FILE; do mv -v "${FILE}" "${FILE//_bl/}"; done

# empty directories
find . -type d -empty

# define base material file
OVERWRITE=no
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

function create_material()
{
  # sift through texture files
  VMAT=${1/*\//}
  cd "${C}"/${PACK}/materials/${1}
  if [ "${OVERWRITE}" == yes ] || [ ! -e ../${VMAT}.vmat ]; then
    unset COLOR AO GLOSS REFLECTANCE METAL NORMAL SELFILLUM OPACITY
    for FILE in *.*; do

      # skip height maps
      if [[ ${FILE} != h.* ]] && [[ ${FILE} != H.* ]] \
      && [[ ${FILE} != *height* ]] && [[ ${FILE} != *Height* ]] && [[ ${FILE} != *__inverted* ]] \
      && [[ ${FILE} != *_*isplacement* ]]; then

        # gather pbr
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
          GLOSS=${GLOSS/.tiff/__inverted.tiff}
          GLOSS=${GLOSS/.jpg/__inverted.jpg}
          ffmpeg -hide_banner -y -loglevel error -i ${FILE} -vf negate ${GLOSS}

        # or use gloss map if already present
        elif [[ ${FILE} == *_*lossiness* ]] || [[ ${FILE} == *_Gloss.* ]]; then
          GLOSS=${FILE}
          
        # find other maps first to reduce chance of mistaking the metal map
        elif [[ ${FILE} == m.* ]] || [[ ${FILE} == M.* ]] \
          || [[ ${FILE} == *etal*ness* ]] || [[ ${FILE} == *etal*ic* ]] || [[ ${FILE} == *metal.* ]]; then
          METAL=${FILE}
        elif [[ ${FILE} != *.vmat ]]; then
          echo "UNKNOWN MATERIAL FILE TYPE: ${FILE} // COLOR: ${COLOR}"
        fi
      fi
    done

    # (re)write material file and compile
    if [ -z ${COLOR} ]; then
      echo "MISSING: color -- ${1}"
    else
      echo "writing: ${VMAT}.vmat"
      echo -e "${MATERIAL}" > ../${VMAT}.vmat
      sed -i -e s:_COLOR_FILE_:${1}/${COLOR}: ../${VMAT}.vmat
      if [ -z ${NORMAL} ]; then
        echo "MISSING: normal -- ${1}"
        sed -i -e s:_NORMAL_FILE_:default/default_normal.tga: ../${VMAT}.vmat
      else
        sed -i -e s:_NORMAL_FILE_:${1}/${NORMAL}: ../${VMAT}.vmat
      fi
      if [ -z ${METAL} ]; then
        echo "MISSING: metal -- ${1}"
        sed -i -e /TextureMetalness/d -e /F_METALNESS_TEXTURE/d ../${VMAT}.vmat
        sed -i -e 's/g_vMetalnessRange "\[0.000 1.000\]"/g_flMetalness "0.000"/' ../${VMAT}.vmat
      else
        sed -i -e s:_METAL_FILE_:${1}/${METAL}: ../${VMAT}.vmat
      fi
      if [ -z ${AO} ]; then
        echo "MISSING: ao -- ${1}"
        sed -i -e /TextureAmbientOcclusion/d ../${VMAT}.vmat
        sed -i -e /F_INDIRECT_TEXTURES/d ../${VMAT}.vmat
        sed -i -e /g_flAmbientOcclusionStrengthDirectDiffuse/d ../${VMAT}.vmat
        sed -i -e /g_flAmbientOcclusionStrengthDirectSpecular/d ../${VMAT}.vmat
      else
        sed -i -e s:_AO_FILE_:${1}/${AO}: ../${VMAT}.vmat
      fi
      if [ -z ${GLOSS} ]; then
        echo "MISSING: gloss -- ${1}"
        sed -i -e s:_GLOSS_FILE_:default/default_gloss.tga: ../${VMAT}.vmat
      else
        sed -i -e s:_GLOSS_FILE_:${1}/${GLOSS}: ../${VMAT}.vmat
      fi
      if [ -z ${REFLECTANCE} ]; then
        echo "MISSING: reflectance -- ${1}"
        sed -i -e s:_REFLECTANCE_FILE_:default/default_refl.tga: ../${VMAT}.vmat
      else
        sed -i -e s:_REFLECTANCE_FILE_:${1}/${REFLECTANCE}: ../${VMAT}.vmat
      fi
      if [ -z ${SELFILLUM} ]; then
        sed -i -e /F_SELF_ILLUM/d ../${VMAT}.vmat
        sed -i -e /SelfIllum/d ../${VMAT}.vmat
      else
        echo "FOUND: selfillum -- ${1}"
        sed -i -e s:_SELFILLUM_FILE_:${1}/${SELFILLUM}: ../${VMAT}.vmat
      fi
      if [ -z ${OPACITY} ]; then
        sed -i -e /F_ALPHA_TEST/d -e /g_flAlphaTestReference/d -e /TextureTranslucency/d ../${VMAT}.vmat
      else
        echo "FOUND: opacity -- ${1}"
        sed -i -e s:_OPACITY_FILE_:${1}/${OPACITY}: ../${VMAT}.vmat
      fi
    fi
  fi
}

# traverse two-level directory structure
cd "${C}"/${PACK}/materials
find . -mindepth 1 -type d | while read LINE; do create_material ${LINE}; done

# errata: delete certain material files
function delete_selective()
{
  PACK=lebedevartem
  PACK=ambientcg
  cd /mnt/s/${PACK}/materials/
  for DIR1 in *; do
    cd /mnt/s/${PACK}/materials/${DIR1}
    for DIR2 in *; do
      if [[ ${DIR2} != *.vmat ]]; then
        cd /mnt/s/${PACK}/materials/${DIR2}
        if [ -e /mnt/s/${PACK}/materials/${DIR2}/*_ID* ] \
        || [ -e /mnt/s/${PACK}/materials/${DIR2}/*_IdMask* ] \
        || [ -e /mnt/s/asset_pack_lebedevartem/materials/${DIR2}/i.* ] \
        || [ -e /mnt/s/asset_pack_lebedevartem/materials/${DIR2}/e.* ] \
        || [ -e /mnt/s/asset_pack_lebedevartem/materials/${DIR2}/I.* ] \
        || [ -e /mnt/s/asset_pack_ambientcg/materials/${DIR2}/*_Opacity.* ]; then
          echo rm -v ../${VMAT}.vmat
        fi
      fi
    done
  done
}