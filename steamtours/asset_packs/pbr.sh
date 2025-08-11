# select addon (lebedevartem, sharetextures, freepbr(fancy-scaled-gold-pbr), ambientcg, polyhaven, polyhaven-models, texturecan(653/650))
if [ -z ${1} ]; then
  echo "no arguments"
  exit 1
fi
PACK=${1}
if [ -z "${C}" ]; then
  echo "missing environmental variables"
  exit 0
fi

# ensure materials change directory
if [ ${PACK} = polyhaven_models ]; then
  PREFIX="models/polyhaven/"
  ROOT="${C}"/${PACK}/materials/models/polyhaven
else
  ROOT="${C}"/${PACK}/materials
fi
cd "${ROOT}" || exit 1

# extract zip files (ensure clean filenames)
for FILE in $(find . -name "*.zip"); do
  unzip -j ${FILE} -x '__MACOSX/*' -d $(echo ${FILE/.zip/} | sed -e s:_4k_.*::i)  && rm -v ${FILE}
done

# prune models and other cruft
find . -name "*.ini" -or -name "*.txt" -or -name "*.zip" -or -name "*.usda" -or -name "*.usdc" -or -name "*.mtlx" -or -name "*NormalDX.*" -or -name "*normal_directx_.*" -or -iname "*_preview.*" | while read LINE; do rm -v ${LINE}; done

# fix whitespace and dashes
find . -mindepth 2 -name "*\ *" -type d | while read FILE; do mv -v "${FILE}" "${FILE// /_}"; done
find . -name "*\ *" -type d | while read FILE; do mv -v "${FILE}" "${FILE// /_}"; done
find . -name "*\ *"  | while read FILE; do mv -v "${FILE}" "${FILE// /_}"; done
find . -name "*_-_*" | while read FILE; do mv -v "${FILE}" "${FILE//_-_/-}"; done
find . -name "*-_*"  | while read FILE; do mv -v "${FILE}" "${FILE//-_/-}"; done
find . -name "*_-*"  | while read FILE; do mv -v "${FILE}" "${FILE//_-/-}"; done

# remove directory suffixes
find . -type d -name "*_8K-JPG" | while read FILE; do mv -v "${FILE}" "${FILE//_8K-JPG/}"; done
find . -type d -name "*_4K-JPG" | while read FILE; do mv -v "${FILE}" "${FILE//_4K-JPG/}"; done
find . -type d -name "*_2K-JPG" | while read FILE; do mv -v "${FILE}" "${FILE//_2K-JPG/}"; done
find . -type d -name "*_8K-PNG" | while read FILE; do mv -v "${FILE}" "${FILE//_8K-PNG/}"; done
find . -type d -name "*_4K-PNG" | while read FILE; do mv -v "${FILE}" "${FILE//_4K-PNG/}"; done
find . -type d -name "*_2K-PNG" | while read FILE; do mv -v "${FILE}" "${FILE//_2K-PNG/}"; done
find . -type d -name "*-2K"     | while read FILE; do mv -v "${FILE}" "${FILE//-2K/}"; done
find . -type d -name "*-4K"     | while read FILE; do mv -v "${FILE}" "${FILE//-4K/}"; done
find . -type d -name "*-bl"     | while read FILE; do mv -v "${FILE}" "${FILE//-bl/}"; done
find . -type d -name "*_bl"     | while read FILE; do mv -v "${FILE}" "${FILE//_bl/}"; done

# empty directories
find . -type d -empty

# define base material file
OVERWRITE=no
MATERIAL=$(cat "${X}"/pbr_template.vmat)

function create_material()
{
  # sift through texture files
  cd "${ROOT}"/${1}
  VMAT=${1/*\//}
  if [ ${OVERWRITE} == yes ] || [ ! -e ../${VMAT}.vmat ]; then
    unset COLOR AO GLOSS REFLECTANCE METAL NORMAL SELFILLUM ALPHA OPACITY
    for FILE in *.*; do
  
      # skip height maps and converted roughness maps
      if [[ ${FILE} != h.* ]] && [[ ${FILE} != H.* ]] \
      && [[ ${FILE} != *height* ]] && [[ ${FILE} != *Height* ]] \
      && [[ ${FILE} != *_disp_* ]] && [[ ${FILE} != *_*isplacement* ]] \
      && [[ ${FILE} != *__inverted* ]]; then
  
        # gather pbr
        if [[ ${FILE} == d.* ]] || [[ ${FILE} == D.* ]] \
        || [[ ${FILE} == *lbedo* ]] || [[ ${FILE} == *olor.* ]] || [[ ${FILE} == *alb.* ]] || [[ ${FILE} == *base*olor* ]] \
        || [[ ${FILE} == *diffuse* ]] || [[ ${FILE} == *Diffuse* ]] || [[ ${FILE} == *_diff_* ]] \
        || [[ ${FILE} == *_color_* ]] \
        || [[ ${FILE} == *_col_* ]] && [ ${PACK} != 'polyhaven' ]; then
          COLOR=${FILE}
        elif [[ ${FILE} == n.* ]] || [[ ${FILE} == N.* ]] \
        ||   [[ ${FILE} == *ormal* ]] || [[ ${FILE} == *-norrmal* ]] || [[ ${FILE} == *-norma-ogl* ]] || [[ ${FILE} == *-nmap-ogl* ]] \
        ||   [[ ${FILE} == *_nor_gl_* ]] \
        ||   [[ ${FILE} == *_normal_opengl_* ]] \
        ||   [[ ${FILE} == *_NormalGL* ]]; then
          NORMAL=${FILE}
        elif [[ ${FILE} == *mbient* ]] || [[ ${FILE} == *AO* ]] || [[ ${FILE} == *ao* ]] \
          || [[ ${FILE} == *mbient*cclusion* ]]; then
          AO=${FILE}
        elif [[ ${FILE} == i.* ]] || [[ ${FILE} == I.* ]] || [[ ${FILE} == e.* ]] \
          || [[ ${FILE} == *_IdMask.* ]] || [[ ${FILE} == *_ID* ]]; then
          SELFILLUM=${FILE}
        elif [[ ${FILE} == *_alpha_* ]] || [[ ${FILE} == *_opacity_* ]]; then
          ALPHA=${FILE}
        elif [[ ${FILE} == *_Opacity.* ]] || [[ ${FILE} == *_opacity.* ]]; then
          OPACITY=${FILE}
        elif [[ ${FILE} == *specular.* ]] || [[ ${FILE} == *Specular.* ]] || [[ ${FILE} == *_spec_* ]] \
          || [[ ${FILE} == *specularLevel.* ]]; then
          REFLECTANCE=${FILE}
  
        # invert roughness with ffmpeg for use as gloss map
        elif [[ ${FILE} == r.* ]] || [[ ${FILE} == R.* ]] \
          || [[ ${FILE} == *oughn*ess* ]] || [[ ${FILE} == *rough.* ]] || [[ ${FILE} == *-rough*.* ]] || [[ ${FILE} == *_rough_* ]]; then
          GLOSS=${FILE/.png/__inverted.png}
          GLOSS=${GLOSS/.tif/__inverted.tif}
          GLOSS=${GLOSS/.tiff/__inverted.tiff}
          GLOSS=${GLOSS/.jpg/__inverted.jpg}
          if [ ! -e ${GLOSS} ]; then
            ffmpeg -hide_banner -y -nostats -loglevel 0 -i ${FILE} -vf negate ${GLOSS} < /dev/null
          fi
  
        # or use gloss map if already present
        elif [[ ${FILE} == *_*lossiness* ]] || [[ ${FILE} == *_Gloss.* ]]; then
          GLOSS=${FILE}
          
        # find other maps first to reduce chance of mistaking the metal map
        elif [[ ${FILE} == m.* ]] || [[ ${FILE} == M.* ]] || [[ ${FILE} == *_metal_4k* ]] \
          || [[ ${FILE} == *etal*ness* ]] || [[ ${FILE} == *etal*ic* ]] || [[ ${FILE} == *metal.* ]]; then
          METAL=${FILE}
        elif [[ ${FILE} != *.vmat ]]; then
          echo "UNKNOWN MATERIAL FILE TYPE: ${FILE} // ${VMAT}"
        fi
      fi
    done
  
    # (re)write material file and compile
    if [ -z ${COLOR} ] && [ ${PACK} != 'polyhaven' ]; then
      echo "MISSING: color -- Skipping ${1}"
    else
      if [ -z ${COLOR} ]; then
        COLOR=$(ls -1 *_col*)
      fi
      VMAT_ORIG=${VMAT}
      for COLOR_FILE in ${COLOR}; do
        if [ $(echo ${COLOR} | wc -w) != 1 ]; then
          VMAT=${VMAT_ORIG}_$(echo ${COLOR_FILE} | grep -iEo col[l]?[_]?[0-9]+)
        fi
        echo "writing: ${VMAT}.vmat"
        echo -e "${MATERIAL}" > ../${VMAT}.vmat
        sed -i -e s:_COLOR_FILE_:${PREFIX}${1}/${COLOR_FILE}: ../${VMAT}.vmat
        if [ -z ${NORMAL} ]; then
          echo "MISSING: normal -- ${1}"
          sed -i -e s:_NORMAL_FILE_:default/default_normal.tga: ../${VMAT}.vmat
        else
          sed -i -e s:_NORMAL_FILE_:${PREFIX}${1}/${NORMAL}: ../${VMAT}.vmat
        fi
        if [ -z ${METAL} ]; then
          sed -i -e /TextureMetalness/d -e /F_METALNESS_TEXTURE/d ../${VMAT}.vmat
          sed -i -e 's/g_vMetalnessRange "\[0.000 1.000\]"/g_flMetalness "0.000"/' ../${VMAT}.vmat
        else
          sed -i -e s:_METAL_FILE_:${PREFIX}${1}/${METAL}: ../${VMAT}.vmat
        fi
        if [ -z ${AO} ]; then
          sed -i -e /TextureAmbientOcclusion/d ../${VMAT}.vmat
          sed -i -e /F_INDIRECT_TEXTURES/d ../${VMAT}.vmat
          sed -i -e /g_flAmbientOcclusionStrengthDirectDiffuse/d ../${VMAT}.vmat
          sed -i -e /g_flAmbientOcclusionStrengthDirectSpecular/d ../${VMAT}.vmat
        else
          sed -i -e s:_AO_FILE_:${PREFIX}${1}/${AO}: ../${VMAT}.vmat
        fi
        if [ -z ${GLOSS} ]; then
          sed -i -e s:_GLOSS_FILE_:default/default_gloss.tga: ../${VMAT}.vmat
        else
          sed -i -e s:_GLOSS_FILE_:${PREFIX}${1}/${GLOSS}: ../${VMAT}.vmat
        fi
        if [ -z ${REFLECTANCE} ]; then
          sed -i -e s:_REFLECTANCE_FILE_:default/default_refl.tga: ../${VMAT}.vmat
        else
          sed -i -e s:_REFLECTANCE_FILE_:${PREFIX}${1}/${REFLECTANCE}: ../${VMAT}.vmat
        fi
        if [ -z ${SELFILLUM} ]; then
          sed -i -e /F_SELF_ILLUM/d ../${VMAT}.vmat
          sed -i -e /SelfIllum/d ../${VMAT}.vmat
        else
          sed -i -e s:_SELFILLUM_FILE_:${PREFIX}${1}/${SELFILLUM}: ../${VMAT}.vmat
        fi
        if [ -z ${ALPHA} ]; then
          sed -i -e /F_ALPHA_TEST/d -e /g_flAlphaTestReference/d ../${VMAT}.vmat
        else
          sed -i -e /F_TRANSLUCENT/d -e /g_flOpacityScale/d -e s:_TRANS_FILE_:${PREFIX}${1}/${ALPHA}: ../${VMAT}.vmat
        fi
        if [ -z ${OPACITY} ]; then
          sed -i -e /F_TRANSLUCENT/d -e /g_flOpacityScale/d  ../${VMAT}.vmat
        else
          sed -i -e /F_ALPHA_TEST/d -e /g_flAlphaTestReference/d -e s:_TRANS_FILE_:${PREFIX}${1}/${OPACITY}: ../${VMAT}.vmat
        fi
        if [ -z ${ALPHA} ] && [ -z ${OPACITY} ]; then
          sed -i -e /TextureTranslucency/d ../${VMAT}.vmat
        fi
      done
    fi
  else
    echo "skipping: ${VMAT}.vmat"
  fi
}

# traverse two-level directory structure
cd "${ROOT}"
ls -d * | while read DIR; do
  if [ -d "${ROOT}"/${DIR} ]; then
    create_material ${DIR}
  fi
done