clear
OVERWRITE=yes
find . -type f -name "*.vmat.backup" | while read VMAT_BACKUP; do
  VMAT=${VMAT_BACKUP/.backup/}
  SHADER=$(cat ${VMAT_BACKUP} | grep -io [a-z_0-9]*.vfx)
  if [ ! -e ${VMAT} ] || ! grep -q vr_standard.vfx ${VMAT} || [ ${OVERWRITE} = yes ]; then
    cat ${VMAT_BACKUP} | sed \
      -e 's:vr_glass.vfx":vr_standard.vfx"\n\t"F_TRANSLUCENT"\t"1"\n\t"F_GLASS"\t"1":' \
      -e 's:vr_simple_blend_to_xen_membrane.vfx":vr_standard.vfx"\n\t"F_BLEND"\t"1":' \
      -e 's:vr_simple_2layer_parallax.vfx":vr_standard.vfx"\n\t"F_BLEND"\t"1":' \
      -e 's:vr_simple_3layer_parallax.vfx":vr_standard.vfx"\n\t"F_BLEND"\t"2":' \
      -e 's:vr_simple_2way_blend.vfx":vr_standard.vfx"\n\t"F_BLEND"\t"1":' \
      -e 's:vr_simple_blend_to_triplanar.vfx":vr_standard.vfx"\n\t"F_BLEND"\t"1":' \
      -e 's:vr_static_overlay.vfx":vr_standard.vfx"\n\t"F_TRANSLUCENT"\t"1"\n\t"F_OVERLAY"\t"1":' \
      -e 's:vr_projected_decals.vfx":vr_standard.vfx"\n\t"F_TRANSLUCENT"\t"1"\n\t"F_OVERLAY"\t"1":' \
      -e 's:TextureColorA:TextureColor:' \
      -e 's:TextureColorB:TextureLayer1Color:' \
      -e 's:TextureColorC:TextureLayer2Color:' \
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
        > ${VMAT}
    grep 'Roughness"' ${VMAT} | while read LINE; do
      ROUGH=$(echo ${LINE} | awk '{$1=""; print $0}' | sed -e 's:"::g' -e 's:\[::' -e 's:\]::' | xargs)
      GLOSS=${ROUGH/./__inverted.}
      if ! echo ${LINE} | grep -q .png; then
        GLOSS="["$(echo $(bc <<< $(echo ${ROUGH} | awk '{print $1}')-1.000 | sed -e s:-:0:) $(bc <<< $(echo ${ROUGH} | awk '{print $2}')-1.000 | sed -e s:-:0:) $(bc <<< $(echo ${ROUGH} | awk '{print $3}')-1.000 | sed -e s:-:0:) 0.000000)"]"
      elif [ -e ${ROUGH} ] && [ ! -e ${GLOSS} ]; then
        ffmpeg -hide_banner -y -nostats -loglevel 0 -i ${ROUGH} -vf negate ${GLOSS} < /dev/null
      fi
      LINE=${LINE//[/\\[}
      sed -i -e "s:${LINE//]/\\]}:$(echo ${LINE} | awk '{print $1}')\t\"${GLOSS}\":" ${VMAT}
    done
    sed -i -e 's:Roughness:Glossiness:g' ${VMAT}
    if grep -q TextureAmbientOcclusion ${VMAT} && ! grep -q F_INDIRECT_TEXTURES ${VMAT}; then
      sed -i -e 's:.vfx":.vfx"\n\t"F_INDIRECT_TEXTURES"\t"2\":' ${VMAT}
    fi
    if grep -q Metalness ${VMAT} && ! grep -q F_SPECULAR ${VMAT}; then
      sed -i -e 's:.vfx":.vfx"\n\t"F_SPECULAR"\t"1":' ${VMAT}
    fi
    if grep -q F_SPECULAR ${VMAT} && ! grep -q F_SPECULAR_CUBE_MAP ${VMAT}; then
      sed -i -e 's:"F_SPECULAR"\t"1":"F_SPECULAR"\t"1"\n\t"F_SPECULAR_CUBE_MAP"\t"1":' ${VMAT}
    fi
    cat ${VMAT} | grep ".*.png" | while read LINE; do
      FILE=$(echo ${LINE} | awk '{print $2}' | sed -e 's:"::g')
      if [ ! -e ${FILE} ]; then
        echo 'missing texture: ' + ${LINE}
        sed -i -e "s:${LINE}://${LINE}:" ${VMAT}
      fi
    done
    if ! grep -q vr_standard.vfx ${VMAT}; then
      sed -i -e "s:.*\.vfx:\"shader\"\t\"vr_standard.vfx:" ${VMAT}
    fi
    if ! grep -q g_vReflectanceRange ${VMAT}; then
      sed -i -e 's:\.vfx":\.vfx"\n\tg_vReflectanceRange "[0.000 1.000]":' ${VMAT}
    fi
    echo "------------------------------------------------------------------------" ${VMAT_BACKUP}
    diff ${VMAT_BACKUP} ${VMAT}
    echo "------------------------------------------------------------------------" ${VMAT}
  fi
done | tee hlvr_transform_$(date +%s).txt