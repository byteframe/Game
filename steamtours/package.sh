#!/bin/sh

if [ -z "${G}" ]; then
  echo "FAIL: no environment!"
else
  ADDON=byteframe13
  MAP=byteframe13
  PACKS=$(tac "${G}"/${ADDON}/dev_addoninfo.txt | grep -o "\"[a-z0-9_]*\"" | awk 'length >=5' | sed -e "s/\"//g")\ steamtours\ core
  WORKSHOP="/mnt/c/Program Files (x86)/Steam/steamapps/workshop/content/250820"
  cd "${G}"
  if [ -z ${FILES_COMPLETED} ]; then
    unset FILES
    declare -A FILES
    printf "[GENERATING ASSET LISTS]"
    for PACK in ${PACKS}; do
      if [ ${PACK} != ${MAP}_assets ]; then
        printf ...${PACK}
        if [ ${PACK} = "steamtours" ]; then
          DIR=../steamtours
        elif [ ${PACK} = "core" ]; then
          DIR=../core
        elif [ -d ${PACK} ]; then
          DIR=${PACK}
        else
          DIR="${WORKSHOP}"/${PACK}
        fi
        if [ -e "${DIR}"/vpk_list.txt ]; then
          FILES[${PACK}]="$(cat "${DIR}"/vpk_list.txt)"
        else
          FILES[${PACK}]=$(find -L ${PACK} -type f)
        fi
      fi
    done
    FILES_COMPLETED=yes
  fi
  if [ ! -e resources_${MAP}.txt ]; then
    cat ${ADDON}/maps/${MAP}.txt | grep 'external resource' | grep -v "(maps/" | grep -v "_bakeresourcecache" | while read LINE; do
      echo ${LINE:44}
    done | awk '!seen[$0]++' > resources_${MAP}.txt
  fi
  cat resources_${MAP}.txt | while read LINE; do
    unset FOUND
    FILE1=${LINE:18:-1}
    for PACK in ${PACKS}; do
      if [[ ${FILES[${PACK}]} == */${FILE1}_c* ]]; then
        FOUND=yes
        echo "${PACK} | ${LINE}"
        if [ ${PACK} != "steamtours" ] && [ ${PACK} != "core" ] && [ ${PACK} != "steamvr_home" ] \
        && [ ${PACK} != "russells_lab" ] && [ ${PACK} != "c17_alleyway" ] && [ ${PACK} != "driftwood_htc" ] \
        && ! [[ ${PACK} =~ ^[0-9]+ ]]; then
          echo "   ---- ${PACK}/${FILE1}"_c
          strings ${PACK}/${FILE1}_c | grep -E "(materials|models|particles)/.*\.(vtex|vpcf|vmesh|vphys|vseq|vagrp|vmorf|vanim)" | awk '!seen[$0]++' | while read FILE2; do
            FILE2=$(echo ${FILE2} | cut --delimiter " " --fields 1)
            echo "   -- ${PACK}/${FILE2}_c"
            if [ ! -e ${PACK}/${FILE2}_c ]; then
              echo "ERROR: subfile not found: ${PACK}/${FILE2}_c"
            fi
          done
          if [[ ${FILE1} ==  *.vmdl ]] && [ -e ${PACK}/${FILE1/vmdl/vanim}_c ]; then
            echo "   -- ${PACK}/${FILE1/vmdl/vanim}_c"
          fi
        fi
        break
      fi
    done
    if [ -z ${FOUND} ]; then
      echo "ERROR: file not found: ${LINE}"
    fi
  done
fi