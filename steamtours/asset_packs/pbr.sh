# https://www.artstation.com/lebedevartem
PACK=lebedevartem

# https://ambientcg.com
PACK=ambientcg

# https://www.sharetextures.com/ # 404: marble-6/7-3 extras: 2021
PACK=sharetextures_extra
PACK=sharetextures

# https://freepbr.com (beige stonwork) *metal-splotchy fails @ normal+gloss
PACK=freepbr

# ensure materials directory
STEAMAPPS=/mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/common
CONTENT="${STEAMAPPS}"/SteamVR/tools/steamvr_environments/content/steamtours_addons
cd "${CONTENT}"/asset_pack_${PACK}/materials || exit 1

# prune models and other cruft
rm -vfr models
find . -name *.ini -exec rm -v {} \;
find . -name *.txt -exec rm -v {} \;
find . -name *.zip -exec rm -v {} \;
find . -name *.usda -exec rm -v {} \;
find . -name *.usdc -exec rm -v {} \;
find . -mindepth 3 -type d

# fix whitespace and dashes
find . -mindepth 2 -name "*\ *" -type d | while read FILE; do
  mv -v "${FILE}" "${FILE// /_}"
done
find . -name "*\ *" -type d | while read FILE; do
  mv -v "${FILE}" "${FILE// /_}"
done
find . -name "*\ *" | while read FILE; do
  mv -v "${FILE}" "${FILE// /_}"
done
find . -name "*_-_*" | while read LINE; do mv -v "${LINE}" "${LINE//_-_/-}"; done
find . -name "*-_*" | while read LINE; do mv -v "${LINE}" "${LINE//-_/-}"; done
find . -name "*_-*" | while read LINE; do mv -v "${LINE}" "${LINE//_-/-}"; done

# remove directory suffixes
find . -type d -name "*_2K-PNG" | while read LINE; do mv -v "${LINE}" "${LINE//_2K-PNG/}"; done
find . -type d -name "*-2K" | while read LINE; do mv -v "${LINE}" "${LINE//-2K/}"; done
find . -type d -name "*-bl" | while read LINE; do mv -v "${LINE}" "${LINE//-bl/}"; done
find . -type d -name "*_bl" | while read LINE; do mv -v "${LINE}" "${LINE//_bl/}"; done

# empty directories
find . -type d -empty

# define base material data
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

##============================================================================

# traverse two-level directory structure
cd "${CONTENT}"/asset_pack_${PACK}/materials
for DIR1 in *; do
  cd "${CONTENT}"/asset_pack_${PACK}/materials/${DIR1}
  for DIR2 in *; do
    if [ -d "${CONTENT}"/asset_pack_${PACK}/materials/${DIR1}/${DIR2} ]; then
      cd "${CONTENT}"/asset_pack_${PACK}/materials/${DIR1}/${DIR2}

      # sort material files
      rm -fv *_preview.* *_PREVIEW.* *NormalDX.*
      unset COLOR AO GLOSS REFLECTANCE METAL NORMAL SELFILLUM OPACITY
      if [ "${OVERWRITE}" == yes ] || [ ! -e ../${DIR2}.vmat ] ; then
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

        # (re)write material file
        echo "writing: ${DIR2}.vmat"
        echo -e "${MATERIAL}" > ../${DIR2}.vmat
        if [ -z ${COLOR} ]; then
          echo "MISSING: color -- ${DIR1}/${DIR2}"
          sed -i -e s:_COLOR_FILE_:default/default_color.tga: ../${DIR2}.vmat
        else
          sed -i -e s:_COLOR_FILE_:${DIR1}/${DIR2}/${COLOR}: ../${DIR2}.vmat
        fi
        if [ -z ${NORMAL} ]; then
          echo "MISSING: normal -- ${DIR1}/${DIR2}"
          sed -i -e s:_NORMAL_FILE_:default/default_normal.tga: ../${DIR2}.vmat
        else
          sed -i -e s:_NORMAL_FILE_:${DIR1}/${DIR2}/${NORMAL}: ../${DIR2}.vmat
        fi
        if [ -z ${METAL} ]; then
          echo "MISSING: metal -- ${DIR1}/${DIR2}"
          sed -i -e /TextureMetalness/d ../${DIR2}.vmat
          sed -i -e /F_METALNESS_TEXTURE/d ../${DIR2}.vmat
          sed -i -e 's/g_vMetalnessRange "\[0.000 1.000\]"/g_flMetalness "0.000"/' ../${DIR2}.vmat
        else
          sed -i -e s:_METAL_FILE_:${DIR1}/${DIR2}/${METAL}: ../${DIR2}.vmat
        fi
        if [ -z ${AO} ]; then
          echo "MISSING: ao -- ${DIR1}/${DIR2}"
          sed -i -e /TextureAmbientOcclusion/d ../${DIR2}.vmat
          sed -i -e /F_INDIRECT_TEXTURES/d ../${DIR2}.vmat
          sed -i -e /g_flAmbientOcclusionStrengthDirectDiffuse/d ../${DIR2}.vmat
          sed -i -e /g_flAmbientOcclusionStrengthDirectSpecular/d ../${DIR2}.vmat
        else
          sed -i -e s:_AO_FILE_:${DIR1}/${DIR2}/${AO}: ../${DIR2}.vmat
        fi
        if [ -z ${GLOSS} ]; then
          echo "MISSING: gloss -- ${DIR1}/${DIR2}"
          sed -i -e s:_GLOSS_FILE_:default/default_gloss.tga: ../${DIR2}.vmat
        else
          sed -i -e s:_GLOSS_FILE_:${DIR1}/${DIR2}/${GLOSS}: ../${DIR2}.vmat
        fi
        if [ -z ${REFLECTANCE} ]; then
          echo "MISSING: reflectance -- ${DIR1}/${DIR2}"
          sed -i -e s:_REFLECTANCE_FILE_:default/default_refl.tga: ../${DIR2}.vmat
        else
          sed -i -e s:_REFLECTANCE_FILE_:${DIR1}/${DIR2}/${REFLECTANCE}: ../${DIR2}.vmat
        fi
        if [ -z ${SELFILLUM} ]; then
          sed -i -e /F_SELF_ILLUM/d ../${DIR2}.vmat
          sed -i -e /SelfIllum/d ../${DIR2}.vmat
        else
          echo "FOUND: selfillum -- ${DIR1}/${DIR2}"
          sed -i -e s:_SELFILLUM_FILE_:${DIR1}/${DIR2}/${SELFILLUM}: ../${DIR2}.vmat
        fi
        if [ -z ${OPACITY} ]; then
          sed -i -e /F_ALPHA_TEST/d ../${DIR2}.vmat
          sed -i -e /g_flAlphaTestReference/d ../${DIR2}.vmat
          sed -i -e /TextureTranslucency/d ../${DIR2}.vmat
        else
          echo "FOUND: opacity -- ${DIR1}/${DIR2}"
          sed -i -e s:_OPACITY_FILE_:${DIR1}/${DIR2}/${OPACITY}: ../${DIR2}.vmat
        fi
      fi
    fi
  done
done

# delete certain material files
function delete_selective()
{
  PACK=asset_pack_lebedevartem
  PACK=asset_pack_ambientcg
  cd /mnt/s/${PACK}/materials/
  for DIR1 in *; do
    cd /mnt/s/${PACK}/materials/${DIR1}
    for DIR2 in *; do
      if [[ ${DIR2} != *.vmat ]]; then
        cd /mnt/s/${PACK}/materials/${DIR1}/${DIR2}
        if [ -e /mnt/s/${PACK}/materials/${DIR1}/${DIR2}/*_ID* ] \
        || [ -e /mnt/s/${PACK}/materials/${DIR1}/${DIR2}/*_IdMask* ] \
        || [ -e /mnt/s/asset_pack_lebedevartem/materials/${DIR1}/${DIR2}/i.* ] \
        || [ -e /mnt/s/asset_pack_lebedevartem/materials/${DIR1}/${DIR2}/e.* ] \
        || [ -e /mnt/s/asset_pack_lebedevartem/materials/${DIR1}/${DIR2}/I.* ] \
        || [ -e /mnt/s/asset_pack_ambientcg/materials/${DIR1}/${DIR2}/*_Opacity.* ]; then
          echo rm -v ../${DIR2}.vmat
        fi
      fi
    done
  done
}
