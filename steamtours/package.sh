#!/bin/sh
source /mnt/d/Work/Game/steamtours/asset_packs/steamtours_environment.sh

cd "${G}"
A=byteframe14
[ ! -z ${1} ] && A=${1}
B=${A}_assets
[ ! -z ${2} ] && B=${2}
MAP=${3}
if [ ! -e "${G}"/${A}/maps/${MAP}.txt ]; then
  echo "ERROR: resourcefile not found"
  exit 1
elif [ ! -e "${G}"/${A}/dev_addoninfo.txt ]; then
  echo "ERROR: dev_addoninfo.txt not found"
  exit 1
fi
EXTRACT=true
[ -z ${4} ] && unset EXTRACT
PACKS=$(tac "${G}"/${A}/dev_addoninfo.txt | grep -o "\"[a-z0-9_]*\"" | awk 'length >=5' | sed -e "s/\"//g")\ steamtours\ core
[ -z ${5} ] && PACKS="${PACKS} ${A}"
DRYRUN=true
[ ! -z ${6} ] && unset DRYRUN
REMAKE_LISTS=true
[ -z ${7} ] && unset REMAKE_LISTS
update_vpk_lists
declare -A FILES
for P in ${PACKS}; do
  if [ ${P} != ${B} ]; then
    if [ ${P} = "steamtours" ]; then
      DIR=../steamtours
    elif [ ${P} = "core" ]; then
      DIR=../core
    elif [ -d ${P} ]; then
      DIR=${P}
      if [ ! -e "${DIR}"/vpk_list.txt ] || [ ! -s "${DIR}"/vpk_list.txt ] || [ ! -z ${REMAKE_LISTS} ]; then
        echo "generating vpk_list for: "${P}
        cd "${G}"/${P} ; find -L * -type f > vpk_list.txt ; cd "${G}"
      fi
    else
      DIR="${U}"/${P}
    fi
    FILES[${P}]="$(cat "${DIR}"/vpk_list.txt)"
  fi
done
function parse_vmat() {
  if [[ ${1} == *.vmat ]] && [[ -e "${C}"/${P}/${1} ]]; then
    mkdir -p "${C}"/${B}/$(dirname ${1})
    cp -vn "${C}"/${P}/${1} "${C}"/${B}/${1}
    cat "${C}"/${P}/${1} | sed -e 's/\r$//' | grep -E "\.(png|jpg|tga|exr|tiff)\"" | grep -vE "materials/(default)" | sed -e "s:.*[[:space:]]\"::" -e 's:"::g' -e "s:\\\:/:g" | awk '!seen[$0]++' | while read TEXTURE; do
      TEXTURE="${TEXTURE//&/\\&}"
      mkdir -p "${C}"/${B}/$(dirname ${TEXTURE})
      cp -vn "${C}"/${P}/${TEXTURE} "${C}"/${B}/${TEXTURE}
      [ -e "${C}"/${P}/${TEXTURE%.*}.txt ] && \
        cp -vn "${C}"/${P}/${TEXTURE%.*}.txt "${C}"/${B}/${TEXTURE%.*}.txt
    done
  elif [[ ${P} =~ ^[0-9]+ ]] || [ -e ${P}/${1}_c ]; then
    mkdir -p ${B}/$(dirname ${1})
    [ ! -e ${B}/${1}_c ] && \
      ${METHOD}${1}_c ${B}/$(dirname ${1})
    return 1
  fi
  return 0
}
shopt -s nocasematch
cat "${G}"/${A}/maps/${MAP}.txt | sed 's/\r$//' | grep external\ resource | grep -v "(maps/" | grep -v "_bakeresourcecache" | awk '!seen[$0]++' | while read LINE; do
  unset FOUND
  FILE1=${LINE:63:(-1)}
  for P in ${PACKS}; do
    if [[ ${FILES[${P}]} == *${FILE1}_c* ]]; then
      echo "# ${P} | ${FILE1}"
      if [ -z ${DRYRUN} ] && [ ${P} != steamtours ] && [ ${P} != core ] && [ ${P} != steamvr_home ] \
      && ( [ ! -z ${EXTRACT} ] || ! [[ ${P} =~ ^[0-9]+ ]] ); then
        METHOD="cp -v ${P}/"
        [[ ${P} =~ ^[0-9]+ ]] && METHOD="vpk_extract ../../../../../../workshop/content/250820/${P}/${P}.vpk . no "
        parse_vmat ${FILE1} || children ${FILE1} ${B} parse_vmat\ 
      fi
      FOUND=yes
      break
    fi
  done
  [ -z ${FOUND} ] && echo "#### ERROR: file not found: ${FILE1}"
done 2> >(tee ${B}_cp_errors__$(date +%s).log >&2)