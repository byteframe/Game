#!/bin/sh

CONFIGS[0]="DM-Antalus?game=XGame.xDeathMatch ini=UT2004.ini log=ut2004.log"

ut2004ded_start() {
  echo "Starting UT2004 game server(s): ut2004ded.conf"

  if [ ! -e System/XAdmin.ini ]; then
    wget -c http://downloads.unrealadmin.org/UT2004/Server/dedicatedserver3339-bonuspack.zip
    unzip -q dedicatedserver3339-bonuspack.zip
    rm dedicatedserver3339-bonuspack.zip
    find Animations/ Help/ KarmaData/ Manual/ Maps/ Sounds/ Speech/ \
      StaticMeshes/ System/ Textures/ Web/ -type d -exec chmod 755 {} \;
    find Animations/ Help/ KarmaData/ Manual/ Maps/ Sounds/ Speech/ \
      StaticMeshes/ System/ Textures/ Web/ -type f -exec chmod 644 {} \;
    touch System/ut2004.log
    chmod +x System/ucc-bin
    echo "" > System/cdkey
    ( cd System
      ./ucc-bin server ${CONFIGS[$pos]} -nohomedir &
    )
    sleep 30
    stop
    sed -i -e "s/AdminName=\"Admin\"/AdminName=\"gameserver\"/" \
      -e "s/Password=\"Admin\"/Password=\"$GAMESERVER_PASSWD\"/" \
      System/XAdmin.ini
    chmod 600 System/XAdmin.ini
  fi

  for ((pos=0; pos < ${#CONFIGS[*]}; pos++)); do
    ( cd System
      screen -d -m -S ut2004ded$pos ./ucc-bin server ${CONFIGS[$pos]} -nohomedir &
    )
  done
}

ut2004ded_stop() {
  killall -q -v ucc-bin
  sleep 4
}

ut2004ded_restart() {
  ut2004ded_stop
  ut2004ded_start
}

case "$1" in
'start')
  ut2004ded_start
  ;;
'stop')
  ut2004ded_stop
  ;;
'restart')
  ut2004ded_restart
  ;;
*)
  echo "usage $0 start|stop|restart"
esac
