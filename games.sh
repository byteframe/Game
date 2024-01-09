#!/bin/sh

# TODO FIXME NEW SLACK: do lots native on arch, only install if playing on euclid

SRC="/mnt/Datavault/Game/Computer"
APPS="$HOME/.local/share/applications"
PFILES="$HOME/.wine/drive_c/Program Files"
export SETUP_CDROM="/mnt/tmp"

#chmod bin files
install_game()
{
  if [ $1 = "ends in .iso" ]; then
    #if []; then
      umount /mnt/tmp
    fi
    mount -o loop "${SRC}/$1" /mnt/tmp
    if [ ! -z $2 ]; then
      if [ $2 = "ends in .sh" ]; then
        #sh
      fi
    elif [ -e /mnt/tmp/setup.exe ]; then
      #export WINEPREFIX (check this)
      #WINEPREFIX="$????" WINEDLLOVERRIDES="winemenubuilder.exe=d" winecfg
      #if archimedes
        #wine_regedit direct3d "OffscreenRenderingMode" "backbuffer"
        #wine_regedit direct3d "VideoMemorySize" "16"
      #else if euclid
        #wine_regedit direct3d "VideoMemorySize" "1024"
      #fi
    else
      echo "no setup program in iso"
    fi
  elif [ $1 = "ends in .sh" ]; then
    #sh
  fi
}

# xfce Games shit
launcher()
{
  if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ]; then
    echo "launcher: missing input"
  else
    echo -e "[Desktop Entry]\nName=$1\nType=Application" > "$5"
    echo -e "Exec=$2\nPath=$3\nIcon=$4\nCategories=Application;Game;" >> "$5"
  fi
}

tweak_wine_launcher()
{
  if [ -z $1 ] || [ -z $2 ]; then
    echo "tweak_wine_launcher: missing input $1|$2"
  else
    cp $APPS/wine/Programs/$1 $HOME/$2
    sed -i -e 's/env WINEPREFIX/env WINEDEBUG="-all" WINEPREFIX/' $2
    echo "Categories=Application;Game;" >> "$2"
    chmod +x $2
    mv $2 $APPS/
  fi
}

if [ `hostname` = "4archimedes" ]; then
  install_game "Aliens vs. Predator/Aliens vs. Predator"
  sh /mnt/Datavault/Game/Computer/Aliens vs. Predator/Aliens vs. Predator 1.0 Linux Installer.run
  sed -i -e "s/versus/vs./" /usr/share/applications/liflg_org-avp_1.desktop

  install_game "Doom/Doom Collector's Edition"
  wget http://doomlegacy.sourceforge.net/releases/doomlegacy_144_alpha2_linux2.6_32bit.zip
  unzip doomlegacy_144_alpha2_linux2.6_32bit.zip -d /opt
  rm doomlegacy_144_alpha2_linux2.6_32bit.zip
  mv /opt/doomlegacy_144_alpha2 /opt/doomlegacy
  cp "/mnt/tmp/Final Doom/plutonia.wad" /opt/doomlegacy
  echo "cd /opt/doomlegacy && doomlegacy -iwad plutonia.wad" > /opt/doomlegacy/doomlegacy.sh
  chmod +x /opt/doomlegacy/doomlegacy.sh
  launcher "Doom" "/opt/doomlegacy/doomlegacy" "/opt/doomlegacy" "/opt/doomlegacy/doom.xpm" "/usr/share/applications/doomlegacy.desktop"

  install_game "Duke Nukem 3D/Duke Nukem 3D, Atomic Edition"
  sh "${SRC}/Duke Nukem 3D/Duke Nukem 3D, Atomic Edition Linux Installer.run"
  sed -i -e 's/Categories=Application;X-Redhat-Base;/Categories=Application;Game;/' /usr/share/applications/duke3d.desktop

  install_game "Heretic, Shadows of the Serpent Riders"
  wget http://sourceforge.net/project/downloading.php?group_id=4501&filename=hheretic-0.2.2-x86-linux.tgz
  tar -xzf hheretic-0.2.2-x86-linux.tgz -C /opt/ && rm hheretic-0.2.2-x86-linux.tgz
  mv /opt/hheretic-0.2.2-x86-linux /opt/heretic
  cp /mnt/tmp/HERETIC/HERETIC.WAD /opt/heretic/heretic.wad
  echo "cd /opt/heretic && hheretic-gl -width 1024 -height 768" > /opt/heretic/heretic.sh
  chmod +x /opt/heretic/heretic.sh
  cp "/mnt/Datavault/Image/Game/Icon/Heretic.png" /opt/heretic/heretic.png
  chmod 644 /opt/heretic/heretic.png
  launcher "Heretic" "/opt/heretic.sh" "/opt/heretic" "/opt/heretic/heretic.png" "/usr/share/applications/heretic.desktop"

  install_game "Heretic II Linux"
  sh "${SRC}/Heretic II/Heretic II 1.06c Linux Installer.run"
  sed -i -e "s/Name=Heretic 2/Name=Heretic II/" /usr/share/applications/liflg_org-heretic2_1.desktop
  sed -i -e "s/.dynamic//" /usr/share/applications/liflg_org-heretic2_1.desktop
  sed -i -e "s/\"//" /usr/share/applications/liflg_org-heretic2_1.desktop
  rm /opt/heretic2/base/spanish-1.pak

  install_game "Hexen/Hexen, Beyond Heretic"
  wget http://sourceforge.net/project/downloading.php?group_id=4501&filename=hhexen-1.6.2-x86-linux.tgz
  tar -xzf hhexen-1.6.2-x86-linux.tgz -C /opt/ && rm hhexen-1.6.2-x86-linux.tgz
  mv /opt/hhexen-1.6.2-x86-linux /opt/hexen
  cp /mnt/tmp/HEXENCD/HEXEN.WAD /opt/hexen/hexen.wad
  echo "cd /opt/hexen && hhexen-gl -width 1024 -height 768" > /opt/hexen/hexen.sh
  chmod +x /opt/hexen/hexen.sh
  cp "/mnt/Datavault/Image/Game/Icon/Hexen.png" /opt/hexen/hexen.png
  chmod 644 /opt/hexen/hexen.png
  launcher "Hexen" "/opt/hexen.sh" "/opt/hexen" "/opt/hexen/hexen.png" "/usr/share/applications/hexen.desktop"

  install_game "Hexen II/Hexen II"
  sh "${SRC}/Hexen II/Hexen II 1.4.3 Linux Installer.run"
  sed -i -e 's/^Name=Hexen II for Linux/Name=Hexen II/' /usr/share/applications/hexen2.desktop
  sed -i -e 's/h2launcher/hexen2.sh/' /usr/share/applications/hexen2.desktop
  echo "cd /opt/hexen2 && glhexen2" > /opt/hexen2/hexen2.sh
  chmod +x /opt/hexen2/hexen2.sh
  cp "/mnt/Datavault/Image/Game/Icon/Hexen II.png" /opt/hexen/hexen2.png
  chmod 644 /opt/hexen2/hexen2.png

  install_game "Kingpin, Life of Crime/Kingpin, Life of Crime"
  sh "${SRC}/Kingpin, Life of Crime/Kingpin, Life of Crime 1.20 Linux Installer.run"
  cp "${SRC}/Kingpin, Life of Crime/Kingpin Loopback.iso" /opt/kingpin/kploopback.iso
  mkdir -p /opt/kingpin/kploopback
  echo "echo \"kingpin.x86 0 0 direct\" > /proc/asound/card0/pcm0p/oss" >> /etc/rc.d/rc.local
  echo "mount -t iso9660 -o loop,ro,users /opt/kingpin/kploopback.iso /opt/kingpin/kploopback" >> /etc/rc.d/rc.local

  install_game "Quake/Quake"
  wget http://disenchant.net/files/engine/tyrquake-0.61.tar.gz
  tar -xzf tyrquake-0.61.tar.gz ; rm tyrquake-0.61.tar.gz
  mkdir -p /opt/quake /opt/quake/id1
  ( cd tyrquake-0.61
    make
    cp tyr-quake tyr-glquake tyr-qwcl tyr-glqwcl /opt/quake
  )
  rm -fr tyrquake-0.61
  cp /mnt/tmp/Data/ID1/PAK0.PAK /opt/quake/id1/pak0.pak
  cp /mnt/tmp/Data/ID1/PAK1.PAK /opt/quake/id1/pak1.pak
  install_game "Quake/Quake Mission Pack 1, Scourge of Armagon"
  cp -R /mnt/tmp/hipnotic /opt/quake/
  rm /opt/quake/hipnotic/quake.exe
  cp /mnt/Datavault/Image/Game/Icon/Quake.png /opt/quake/quake.png
  chmod 644 /opt/quake/quake.png
  echo "cd /opt/quake && tyr-quake -game hipnotic" > /opt/quake/quake.sh
  chmod +x /opt/quake/quake.sh
  launcher "Quake" "/opt/quake/quake.sh" "/opt/quake" "/opt/quake/quake.png" "/usr/share/applications/quake.desktop"

  install_game "Quake II/Quake II"
  wget http://icculus.org/quake2/files/quake2-r0.16.1.tar.gz
  tar -xzf quake2-r0.16.1.tar.gz && rm quake2-r0.16.1.tar.gz
  cd quake2-r0.16.1
  sed -i -e "s/BUILD_CTFDLL=YES/BUILD_CTFDLL=NO/" Makefile
  sed -i -e "s/BUILD_GLX=YES/BUILD_GLX=NO/" Makefile
  make
  mkdir -p /opt/quake2/baseq2
  mv releasei386/gamei386.so /opt/quake2/baseq2/
  mv releasei386/ref_*.so releasei386/quake2 releasei386/sdlquake2 /opt/quake2
  cp /mnt/tmp/Install/Data/baseq2/pak0.pak /mnt/tmp/Install/Data/baseq2/video /opt/quake2/baseq2/
  wget ftp://ftp.idsoftware.com/idstuff/quake2/q2-3.20-x86-full.exe
  mv baseq2/pak1.pak baseq2/pak2.pak baseq2/players/ /opt/quake2/baseq2/
  cd .. ; rm -fr quake2-r0.16.1
  cp "/mnt/Datavault/Image/Game/Icon/Quake II.png" /opt/quake2/quake2.png
  chmod 644 /opt/quake2/quake2.png
  echo "cd /opt/quake2 && quake2" > /opt/quake2/quake2.sh
  chmod +x /opt/quake2/quake2.sh
  launcher "Quake II" "/opt/quake2/quake2.sh" "/opt/quake2" "/opt/quake2/quake2.png" "/usr/share/applications/quake2.desktop"
  echo "echo \"quake2 0 0 direct\" > /proc/asound/card0/pcm0p/oss" >> /etc/rc.d/rc.local

  install_game "Quake III Arena/Quake III Arena"
  sh "${SRC}/Quake III Arena/Quake III Arena 1.36-7.1 Linux Engine Installer.run"
  sh "${SRC}/Quake III Arena/Quake III Arena 1.32-9 Linux Data Installer.run"
  sed -i -e 's/Name=ioquake3/Name=Quake III Arena/' /usr/share/applications/ioquake3.desktop

  install_game "Return to Castle Wolfenstein/Return to Castle Wolfenstein 1.41b Linux Installer.run"
  tar -xjf "${SRC}/Return to Castle Wolfenstein/Return to Castle Wolfenstein Data Files.tar.bz2" -C /opt/rtcw/main/
  rm /usr/share/applications/wolfsp.desktop /usr/share/applications/wolfmp.desktop
  sed -i -e 's/^Name=wolfenstein/Name=Wolfenstein/' /usr/share/applications/wolf.desktop
  sed -i -e 's/^Exec=\/opt\/rtcw\/\/wolf/Exec=\/opt\/rtcw\/\/wolfsp/' /usr/share/applications/wolf.desktop

  install_game "Rise of the Triad/Rise of the Triad"
  tar -xzf "Rise of the Triad/rott-1.1.1.tar.gz"
  mkdir /opt/rott
  ( cd rott-1.1.1/rott
    sed -i -e 's/^#define SHAREWARE   1/#define SHAREWARE   0/' develop.h
    sed -i -e 's/^#define SUPERROTT   0/#define SUPERROTT   1/' develop.h
    make
    cp rott ../misc/rott.xpm /opt/rott
  )
  rm -fr rott-1.1.1
  cp /mnt/tmp/ROTTINST/DARKWAR.WAD /mnt/tmp/ROTTINST/REMOTE1.RTS /opt/rott/
  echo "cd /opt/rott && rott" > /opt/rott/rott.sh
  chmod +x /opt/rott/rott.sh
  launcher "Rise of the Triad" "/opt/rott/rott.sh" "/opt/rott" "/opt/rott/rott.xpm" "/usr/share/applications/rott.desktop"

  install_game "Rune/Rune Linux"
  sh /mnt/tmp/setup.sh
  cp "${SRC}/Rune/rune" -O /opt/rune/rune
  chmod +x /opt/rune/rune
  launcher "Rune" "/opt/rune/rune" "/opt/rune" "/opt/rune/icon.xpm" "/usr/share/applications/rune.desktop"

  install_game "Serious Sam, The Second Encounter/Serious Sam, The Second Encounter"
  sh "${SRC}/Serious Sam, The Second Encounter/Serious Sam, The Second Encounter 1.07beta1 Linux Installer.run"
  sed -i -e 's/^Name=Serious Sam: The Second Encounter/Name=Serious Sam/' /usr/share/applications/ssamtse.desktop
  sed -i -e 's/;Games;/;Game;/' /usr/share/applications/ssamtse.desktop

  install_game "Shadow Warrior"
  wget http://slackbuilds.org/slackbuilds/13.37/games/jfsw.tar.gz
  tar -xzf jfsw.tar.gz && rm jfsw.tar.gz
  cd jfsw
  wget http://static.jonof.id.au/dl/buildport/jfsw_src_20051009.zip
  wget http://static.jonof.id.au/dl/buildport/jfbuild_src_20051009.zip
  ./jfsw.SlackBuild
  cd
  mkdir /opt/sw
  tar -xzf /tmp/jfsw-20051009-i486-1_SBo.tgz && rm /tmp/jfsw-20051009-i486-1_SBo.tgz /tmp/SBo
  cp jfsw-20051009-i486-1_SBo/usr/games/sw /opt/sw/sw
  cp jfsw-20051009-i486-1_SBo/usr/share/pixmaps/jfsw.png /opt/sw/sw.png
  cp jfsw-20051009-i486-1_SBo/usr/share/applications/jfsw.application /usr/share/applications/sw.desktop
  sed -i -e 's/Name=JFShadowWarrior/Name=Shadow Warrior/' /usr/share/applications/sw.desktop
  sed -i -e 's/usr\/games\/sw/opt\/sw\/sw.sh/' /usr/share/applications/sw.desktop
  sed -i -e 's/Icon=jfsw/Icon=\/opt\/sw\/sw.png/' /usr/share/applications/sw.desktop
  rm -fr install usr
  cp /mnt/tmp/swinst/SW.GRP /opt/sw/sw.grp
  echo "cd /opt/sw && sw" > /opt/sw/sw.sh
  chmod +x /opt/sw/sw.sh

  install_game "Sin/Sin Linux"
  sh /mnt/tmp/setup.sh
  wget http://www.swanson.ukfsn.org/loki/loki_compat_libs-1.4.tar.bz2
  tar -xjf loki_compat_libs-1.4.tar.bz2 -C /opt/sin; rm loki_compat_libs-1.4.tar.bz2
  mv /opt/sin/Sin.sh /opt/sin/sin.sh
  mkdir -p /opt/sin/sinloopback
  cp "${SRC}/Sin/Sin Loopback.iso" "/opt/sin/sinloopback.iso"
  echo "mount -t iso9660 -o loop,ro,users /opt/sin/sinloopback.iso /opt/sin/sinloopback" >> /etc/rc.d/rc.local
  echo "cd /opt/sin;LD_PRELOAD=Loki_Compat/libstdc++-3-libc6.2-2-2.10.0.so:Loki_Compat/libsmpeg-0.4.so.0.1.3 ./sin.exe" > /opt/sin/sin.sh
  launcher "Sin" "/opt/sin/sin.sh" "/opt/sin" "/opt/sin/icon.xpm" "/usr/share/applications/sin.desktop"

  install_game "Soldier of Fortune/Soldier of Fortune Linux"
  sh "${SRC}/Soldier of Fortune/Soldier of Fortune 1.06a Linux Installer.bin"

  install_game "Wolfenstein 3D"
  wget http://www.alice-dsl.net/mkroll/bins/Wolf4SDL-1.7-src.zip
  unzip Wolf4SDL-1.7-src.zip ; rm Wolf4SDL-1.7-src.zip
  cd Wolf4SDL-1.7-src && make && cd
  mkdir /opt/wolf3d
  cp Wolf4SDL-1.7-src/wolf3d /opt/wolf3d/wolf3d && rm -fr Wolf4SDL-1.7-src
  cp /mnt/tmp/PROGRAM\ FILES/Wolfenstein\ 3D/wolf3d/AUDIOHED.WL6 /opt/wolf3d/audiohed.wl6
  cp /mnt/tmp/PROGRAM\ FILES/Wolfenstein\ 3D/wolf3d/AUDIOT.WL6 /opt/wolf3d/audiot.wl6
  cp /mnt/tmp/PROGRAM\ FILES/Wolfenstein\ 3D/wolf3d/GAMEMAPS.WL6 /opt/wolf3d/gamemaps.wl6
  cp /mnt/tmp/PROGRAM\ FILES/Wolfenstein\ 3D/wolf3d/MAPHEAD.WL6 /opt/wolf3d/maphead.wl6
  cp /mnt/tmp/PROGRAM\ FILES/Wolfenstein\ 3D/wolf3d/VGADICT.WL6 /opt/wolf3d/vgadict.wl6
  cp /mnt/tmp/PROGRAM\ FILES/Wolfenstein\ 3D/wolf3d/VGAGRAPH.WL6 /opt/wolf3d/vgagraph.wl6
  cp /mnt/tmp/PROGRAM\ FILES/Wolfenstein\ 3D/wolf3d/VGAHEAD.WL6 /opt/wolf3d/vgahead.wl6
  cp /mnt/tmp/PROGRAM\ FILES/Wolfenstein\ 3D/wolf3d/VSWAP.WL6 /opt/wolf3d/vswap.wl6
  echo "cd /opt/wolf3d && wolf3d" > /opt/wolf3d/wolf3d.sh
  chmod +x /opt/wolf3d/wolf3d.sh
  cp "/mnt/Datavault/Image/Game/Icon/Wolfenstein 3D.png" /opt/wolf3d/wolf3d.png
  chmod 644 /opt/wolf3d/wolf3d.png
  launcher "Wolfenstein 3D" "/opt/wolf3d/wolf3d.sh" "/opt/wolf3d" "/opt/wolf3d/wolf3d.png" "/usr/share/applications/wolf3d.desktop"

  install_game "Uplink 1.54.sh"
  sed -i -e 's/^Categories=Application;Games;X-Red-Hat-Base;/Categories=Application;Game;/' /usr/share/applications/uplink.desktop
  sed -i -e 's/^Name=uplink/Name=Uplink/' /usr/share/applications/uplink.desktop
  cp /mnt/Datavault/Image/Game/Icon/Uplink.png /opt/uplink/uplink.png
  chmod 644 /opt/uplink/uplink.png

  install_game "Deus Ex/Deus Ex.iso"
  sed -i -e 's/^CdPath=Z:\\mnt\\tmp/CdPath=..\//' $PFILES/Deus Ex/System/DeusEx.ini
  {
    echo "cpufreq-set -g performance
    echo sleep 2
    echo wine DeusEx.exe
    echo cpufreq-selector -g ondemand"
  } > "${PFILES}/Deus Ex/System/pdl-deusex.sh"
  sed -i -e 's/Play Deus Ex/Deus Ex/' "${APPS}/Deus Ex.desktop"
  tweak_wine_launcher "Deus Ex/Play Deus Ex.desktop" "Deus Ex.desktop"
  sed -i -e '/Exec=/d' "${APPS}/Deus Ex.desktop"
  echo "Exec=env WINEDEBUG=\"-all\" WINEPREFIX=\"/home/byteframe/.wine\" sh pdl-deusex.sh" >> "${APPS}/Deus Ex.desktop"
  cp "/mnt/Datavault/Image/Game/Icon/Deus Ex - 2.png" "$HOME/.local/share/icons/deusex.png"
  sed -i -e '/Icon=/d' "${APPS}/Deus Ex.desktop"
  echo "Icon=/home/byteframe/.local/share/icons/deusex.png" >> "${APPS}/Deus Ex.desktop"

  install_game "Diablo II/Diablo II"
  cp /mnt/tmp/d2music.mpq $PFILES/Diablo II/
  install_game "Diablo II/Diablo II, Lord of Destruction"
  cp /mnt/tmp/d2xmusic.mpq d2xvideo.mpq $PFILES/Diablo II/
  cp "${SRC}/Diablo II/Diablo II, Lord of Destruction 1.13c Patch.exe" $HOME/LODPatch.exe
  wine LODPatch.exe
  rm LODPatch.exe
  tweak_wine_launcher "Diablo II/Diablo II - Lord of Destruction.desktop" "Diablo II.desktop"
  sed -i -e 's/Diablo II - Lord of Destruction/Diablo II/' "${APPS}/Diablo II.desktop"

  install_game "Fallout 2/Fallout 2"
  tweak_wine_launcher "Black Isle/Fallout 2/Fallout2.desktop" "Fallout 2.desktop"
  sed -i -e 's/Name=Fallout2/Name=Fallout 2/' "${APPS}/Fallout 2.desktop"
  unzip "${SRC}/Fallout 2/Fallout 2 1.051 Custom Patch.zip"
  mv PATCH000.DAT "${PFILES}/Fallout 2/PATCH000.DAT"
  mv fallout2.exe "${PFILES}/Fallout 2/FALLOUT2.EXE"

  install_game "Grim Fandango/Grim Fandango"
  wine D:\\setup
  wine start /unix "${SRC}/Grim Fandango/Grim Fandango 1.01 Patch.exe"
  unzip "${SRC}/Grim Fandango/Grim Fandango Launcher 1.5.zip"
  tweak_wine_launcher "Grim Fandango/Play Grim Fandango.desktop" "Grim Fandango.desktop"

  install_game "Max Payne/Max Payne"
  tweak_wine_launcher "Remedy/Max Payne/Max Payne.desktop" "Max Payne.desktop"
  cp "/mnt/Datavault/Image/Game/Icon/Max Payne.png" "$HOME/.local/share/icons/maxpayne.png"

  install_game "StarCraft/StarCraft"
  install_game "StarCraft/StarCraft, Brood War"
  cp /mnt/tmp/install.exe $HOME/.wine/drive_c/Program\ Files/StarCraft/BroodWar.mpq
  cp "${SRC}/StarCraft/StarCraft, Brood War 1.161 Patch.exe" $HOME/BroodWarPatch.exe
  wine BroodWarPatch.exe ; rm BroodWarPatch.exe
  tweak_wine_launcher "Starcraft/Starcraft - Brood War.desktop" "Starcraft.desktop"
  sed -i -e 's/Name=Starcraft - Brood War/Name=StarCraft/' "${APPS}/Starcraft.desktop"

  install_game "Starsiege/Starsiege"
  wine "${SRC}/Starsiege/Starsiege 1004 Patch.exe"
  unzip "${SRC}/Starsiege/Starsiege 1004 NOCD.zip" -d "${PFILES}/Starsiege"
  cp -r /mnt/tmp/data "${PFILES}/Starsiege"
  sed -i -e "s/Dynamix\\\\/Program Files\\\\/" "${PFILES}/Starsiege/console.cs"
  tweak_wine_launcher "Starsiege/Starsiege.desktop" "Starsiege.desktop"

  install_game "Star Trek Voyager, Elite Force"
  tweak_wine_launcher "Raven/Star Trek Voyager Elite Force/Star Trek Voyager Elite Force Single Player.desktop" "Elite Force.desktop"
  sed -i -e 's/Name=Star Trek Elite Force Single Player/Name=Star Trek: Elite Force/' "${APPS}/Unreal Gold.desktop"
  unzip "${SRC}/Star Trek Voyager, Elite Force/Star Trek Voyager, Elite Force 1.1-1.2 NOCD"
  mv stvoy.exe /home/byteframe/.wine/drive_c/Program\ Files/Star Trek Voyager Elite Force/

  install_game "Unreal/Unreal Gold"
  tweak_wine_launcher "Unreal Gold/Play Unreal Gold.desktop" "Unreal Gold.desktop"
  sed -i -e 's/Name=Play Unreal Gold/Name=Unreal Gold/' "${APPS}/Unreal Gold.desktop"
  sed -i -e '/Exec=/d' "${APPS}/Unreal Gold.desktop"
  echo "Exec=env WINEDEBUG=\"-all\" WINEPREFIX=\"/home/byteframe/.wine\" sh \"/home/byteframe/.wine/drive_c/Program Files/Unreal Gold/System/unrealgold.sh\"" >> "${APPS}/Unreal Gold.desktop"
  {
    echo "cd ~/.wine/drive_c/Program Files/Unreal Gold/System"
    echo "sudo /usr/bin/cpufreq-set -g performance"
    echo "sleep 2"
    echo "wine Unreal.exe"
    echo "sudo /usr/bin/cpufreq-set -g ondemand"
  } > "${PFILES}/Unreal Gold/System/unrealgold.sh"

  install_game "Unreal Tournament/Unreal Tournament"
  wine "${SRC}/Unreal Tournament/Unreal Tournament 436 Patch.exe"
  tweak_wine_launcher "Unreal Tournament/Play Unreal Tournament.desktop" "Unreal Tournament.desktop"
  sed -i -e 's/Name=Play Unreal Tournament/Name=Unreal Tournament/' "${APPS}/Unreal Tournament.desktop"
  sed -i -e '/Exec=/d' "${APPS}/Unreal Tournament.desktop"
  echo "Exec=env WINEDEBUG=\"-all\" WINEPREFIX=\"/home/byteframe/.wine\" sh \"/home/byteframe/.wine/drive_c/Program Files/Unreal Tournament/System/unrealtournament.sh\"" >> "${APPS}/Unreal Tournament.desktop"
  {
    echo "cd ~/.wine/drive_c/Program Files/Unreal Tournament/System"
    echo "sudo /usr/bin/cpufreq-set -g performance"
    echo "sleep 2"
    echo "wine UnrealTournament.exe"
    echo "sudo /usr/bin/cpufreq-set -g ondemand"
  } > "${PFILES}/Unreal Tournament/System/unrealtournament.sh"
fi

if [ `hostname` = "4euclid" ]; then
  install_game "Amnesia, The Dark Descent 1.01.sh"
  sed -i -e "s/ - The Dark Descent//" /usr/share/applications/AmnesiaTheDarkDescent.desktop
  rm /usr/share/applications/AmnesiaTheDarkDescentManual.desktop

  install_game "Darwinia/Darwinia"
  sh /mnt/Datavault/Darwinia/Darwinia 1.3.0 Linux Installer.sh
  rm /opt/darwinia/lib/libgcc_s.so.1
  sed -i -e 's/^Name=darwinia/Name=Darwinia/' /usr/share/applications/darwinia.desktop

  install_game "Defcon 1.42.sh"

  install_game "Doom 3/Doom 3"
  sh "${SRC}/Doom 3/Doom 3 1.3.1.1304 Linux Installer.run"
  install_game "Doom 3/Doom 3, Resurrection of Evil"
  rm /usr/share/applications/doom3xp.desktop
  sed -i -e 's/^Name=DOOM III/Name=Doom 3/' /usr/share/applications/doom3.desktop
  sed -i -e 's/^Categories=Application;Games;X-Red-Hat-Base;/Categories=Categories=Application;Game;/' /usr/share/applications/doom3.desktop
  cp "/mnt/Datavault/Image/Game/Icon/Doom 3.xpm" "/opt/doom3/doom3.xpm"

  install_game "Enemy Territory, Quake Wars/Enemy Territory, Quake Wars"
  sh "${SRC}/Enemy Territory, Quake Wars/Enemy Territory, Quake Wars 1.5 Linux Installer.run"
  sed -i -e "s/ET: Quake Wars/ETQW/" /usr/share/applications/liflg_org-etqw_1.desktop

  install_game "Prey/Prey"
  sh "${SRC}/Prey/Prey Linux 02192009 Installer.bin"

  install_game "Quake 4/Quake 4"
  sh "${SRC}/Quake 4/Quake 4 1.4.2 Linux Installer.run"
  cp /mnt/tmp/Setup/Data/q4base/pak0*.pk4 /opt/quake4/q4base
  cp /mnt/tmp/Setup/Data/q4base/zpak_english.pk4 /opt/quake4/q4base
  cp "/mnt/Datavault/Image/Game/Icon/Quake 4.xpm" "/opt/quake4/quake4.xpm"
  launcher "Quake 4" "/opt/quake4/quake4" "/opt/quake4" "/opt/quake4/quake4.xpm" /usr/share/applications/quake4.desktop

  cp "/mnt/Datavault/Image/Game/Icon/Quake Live.png" "/usr/share/icons/quakelive.png"
  launcher "Quake Live" "firefox quakelive.com" "/tmp" "quakelive.png" /usr/share/applications/quakelive.desktop

  wget http://cdn.steampowered.com/download/SteamInstall.msi
  wine msiexec /i SteamInstall.msi
  rm SteamInstall.msi

#######################################################################################3###############
  #alien swarm
  #bioshock
  #css
  #dods
  #dxiw
  #farcry
  #half life 2 death
  #insurgency
  #killing floor
  #l4d
  #l4d2
  #portal
  #ro
  #ro2
  #steam
  #tf2
  #thief 3
  #ut3
  #zps
  #ss2
  #unreal2
  #unreal2004
  #wolfenstein 2009
  #SKPI: oblivion,fallout1,penumbra,postal2,sstfe,ss1,ss2,unreal2,ut2004,wolf2009
fi
