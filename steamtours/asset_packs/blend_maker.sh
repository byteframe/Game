#!/bin/sh

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