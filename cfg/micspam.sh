PREFIX="${HOME}"/.local/share/Steam
#use FID instead and can watch localconfig.vdf for name changes?
NAME="byteframe"
LOG="${PREFIX}/SteamApps/ACCOUNTNAME/Team Fortress 2/tf/console.log"
# really need dmix device now

let LINE=$(wc -l "${LOG}" | grep -o ^[0-9]*)

while [ 4 ]; do
  unset NEWLINE
  let TEMP=LINE+1
  NEWLINE=$(tail --lines=+${TEMP} "${LOG}" | grep -n -m 1 "${NAME} :  " | grep -o "^[0-9]*")
  if [ ! -z ${NEWLINE} ]; then
    let LINE=LINE+NEWLINE
    echo echo \"$(sed -n "${LINE}p" "${LOG}" | sed -e "s/.*${NAME} :  //")\" \| /usr/bin/flite \
      > /tmp/pdl-idler.micspam
    ALSA_OSS_PCM_DEVICE=hw:1,0 aoss sh /tmp/pdl-idler.micspam
    rm -f /tmp/pdl-idler.micspam
  fi
  sleep 0.2
done
