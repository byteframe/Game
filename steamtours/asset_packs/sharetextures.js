// paid 5 dollars to get texture master sets, downloaded all date folders with google drive in side quest client
// unziped with windows explorer
// removed preview images: find . -maxdepth 2 -type f -exec rm {} \;
// removed 1k: find . -type d -name "1K-*" -exec rm -fr {} \;
// removed 4k: find . -type d -name "4K-*" -exec rm -fr {} \;

// prep the following code by making asset_pack_sharetextures/materials/

fs = require('fs'),
adm_zip = require('adm-zip'),
download = require('download'),
disk = '/mnt/c/Users/byteframe/Desktop/' + '/asset_pack_sharetextures/materials/',
axios = require('axios'),
axios.get('https://www.sharetextures.com/textures/').then((res) => (
  data = '', Object.keys(res.data).forEach((d) => data += res.data[d]),
  categories = data.match(/href=\"\/category\/[a-z]*\"/g).map((item) => item.slice(16, -1)),
  (get_textures = (c = 0) =>
    (categories.length == c) ?
      console.log('done')
    : (categories[c].indexOf('sbsar') > -1) ?
      get_textures(c+1)
    : axios.get('https://www.sharetextures.com/category/' + categories[c]).then((res) => (
        data = '', Object.keys(res.data).forEach((d) => data += res.data[d]),
        textures = data.match(/href=\"\/textures\/[a-zA-Z0-9\_\-\/]*\/\"/g).map((item) => item.slice(16, -2).split('/')),
        (get_texture = (t = 0) =>
          (textures.length == t) ?
            get_textures(c+1)
          : (!fs.existsSync(disk + textures[t].join('/'))) ?
            axios.get('https://www.sharetextures.com/textures/' + textures[t].join('/')).then((res) => (
              data = '', Object.keys(res.data).forEach((d) => data += res.data[d]),
              file = data.match(/\/[a-zA-Z0-9\_\-]*-2K.zip/),
              (file && data.indexOf('Click here to login via Patreon') == -1) ? (
                console.log("https://files.sharetextures.com/file/Share-Textures" + file[0]),
                (!fs.existsSync(disk + textures[t][0])) &&
                  fs.mkdirSync(disk + textures[t][0]),
                fs.mkdirSync(disk + textures[t].join('/')),
                download('https://files.sharetextures.com/file/Share-Textures' + file[0], disk + textures[t].join('/')).then(() => (
                  zip = new adm_zip(disk + textures[t].join('/') + file[0]),
                  zip.getEntries().forEach((zip_entry) =>
                    (zip_entry.entryName.indexOf(".") > -1) && (
                      zip.extractEntryTo(zip_entry.entryName, disk + textures[t].join('/')),
                      fs.renameSync(disk + textures[t].join('/') + "/" + zip_entry.entryName,
                        disk + textures[t].join('/') + "/" + zip_entry.entryName.substring(zip_entry.entryName.indexOf('/'))))),
                  //fs.rmdirSync(disk + textures[t].join('/') + file[0].slice(0, -4)),
                  //fs.unlinkSync(disk + textures[t].join('/') + file[0]),
                  get_texture(t+1))))
              : get_texture(t+1)))
          : get_texture(t+1))())))()))

// finish with manual removal of empty dirs and zip files
/*
old_pbr_unziping() {
  PROJECT=/mnt/c/Program\ Files\ \(x86\)/Steam/steamapps/common/SteamVR/tools/steamvr_environments/content/steamtours_addons/byteframe13
  if [ -z ${3} ]; then
    echo "not enough input"
    exit 1
  fi
  NAME=${3}
  if [[ ${1} == *sharetextures* ]]; then
    NAME=${NAME}_ST
  fi
  echo "${PROJECT}"/materials/${2}/${NAME}
  if [ ! -d "${PROJECT}"/materials/${2}/${NAME} ]; then
    mkdir -p "${PROJECT}"/materials/${2}/${NAME}
    wget "${1}" -O "${NAME}".zip
    unzip -q -j "${NAME}".zip -x "*.usd*" "*_PREVIEW*" -d "${PROJECT}"/materials/${2}/${NAME}
    rm "${NAME}".zip
  fi
  cd "${PROJECT}"/materials/${2}/${NAME}
}
*/

      
      
///////////////////////

//freepbr has to go through each link to get the correct file/dir name to know whether or not to download it, at best could have ti stop shot once it finds one? backinf off for now
      
      
(get_page1 = (offset = 1) =>
  axios.get('https://freepbr.com/latest-pbr-texture-uploads-2/?product-page=' + offset).then((res) => (
    data = '',
    Object.keys(res.data).forEach((d) => data += res.data[d]),
    matches = data.match(/href="https:\/\/freepbr.com\/materials\/[a-zA-Z0-9-]*\/"/g),
    (matches == null) ?
      console.log('done')
    :(matches.filter((e, i) => i % 2 == 1 && !e.includes('download-all')).forEach((e) => console.log(e)),
      setTimeout(get_page123, 2000, offset+180)))).catch((error) => console.error(error)))();
      