#!/bin/sh
clear
cd ~/.wine/drive_c/Unreal/System
WINEDEBUG="-all" wine UCC.exe server vortex2.unr?game=JCoop4.JCoopGame?difficulty=4 LOG=jcoop.log INI=jcoop.ini &

# clear && WINEDEBUG=-all wine /windows/wine/Unreal/System/UCC.exe server vortex2.unr?game=Unreali.coopgame?difficulty=4 -useini ini=server.ini -uselog log=server.log &