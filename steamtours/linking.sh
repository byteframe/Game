#!/bin/sh
# this makes game directories anew and suggests dos linking commands if the game backup was lost

cd /mnt/d/Source

for DIR in *; do
  mkdir -p "${G}"/${DIR}
  mkdir -p /mnt/v/${DIR}/materials
  mkdir -p /mnt/v/${DIR}/models
  mkdir -p /mnt/v/${DIR}/particles
  mkdir -p /mnt/v/${DIR}/scenes
  mkdir -p /mnt/v/${DIR}/sounds
  mkdir -p /mnt/v/${DIR}/scripts
  mkdir -p /mnt/v/${DIR}/soundevents
  echo "\"AddonInfo\"{\"Dependencies\"{}}" > /mnt/v/${DIR}/addoninfo.txt
  touch /mnt/v/${DIR}/demoheader.tmp
  touch /mnt/v/${DIR}/tools_asset_info.bin
  touch /mnt/v/${DIR}/tools_thumbnail_cache.bin
  echo "cd C:\\Program Files (x86)\\Steam\\steamapps\\common\\SteamVR\tools\\steamvr_environments\\game\\steamtours_addons\\${DIR}"
  echo "mklink /j materials v:\\${DIR}\\materials"
  echo "mklink /j models v:\\${DIR}\\models"
  echo "mklink /j particles v:\\${DIR}\\particles"
  echo "mklink /j sounds v:\\${DIR}\\sounds"
  echo "mklink /j scenes v:\\${DIR}\\scenes"
  echo "mklink /j scripts v:\\${DIR}\\scripts"
  echo "mklink /j soundevents v:\\${DIR}\\soundevents"
  echo "mklink addoninfo.txt v:\\${DIR}\\addoninfo.txt"
  echo "mklink demoheader.tmp v:\\${DIR}\\demoheader.tmp"
  echo "mklink tools_asset_info.bin v:\\${DIR}\\tools_asset_info.bin"
  echo "mklink tools_thumbnail_cache.bin v:\\${DIR}\\tools_thumbnail_cache.bin"
done