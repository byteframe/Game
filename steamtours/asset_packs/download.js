// freepbr: https://freepbr.com/product/pea-gravel-pbr/
fs = require('fs'),
axios = require('axios'),
(get_page = (offset = 0, h = 'https://ambientcg.com/list?type=Material,Atlas,Decal&sort=Latest&offset=' + offset + '&limit=180') =>
  axios.get(h).then((res) => (
    console.log(h),
    data = '',
    Object.keys(res.data).forEach((d) => data += res.data[d]),
    matches = data.match(/\/view\?id=[A-Za-z0-9\_\-\+\=]+\"/g),
    (matches == null) ?
      console.log('done')
    :(matches.map((e) => e.slice(9, -1)).forEach((match) =>
      (!fs.existsSync('/mnt/d/Source/ambientcg/materials/' + match) && !fs.existsSync('/mnt/d/Source/ambientcg/materials/' + match + "_2K-PNG.zip")) && 
        console.log("wget https://ambientcg.com/get?file=" + match + "_2K-PNG.zip -O" + " " + match + "_2K-PNG.zip")),
      setTimeout(get_page, 2000, offset+180)))).catch((error) => console.error(error)))();
      
      
      
      //////////////////////////////////////////////////////////////////////////////// <<< then need to do a backup soon (I might be able to skip whole dirs if there is nothing modifieor I might try on srouce1import folders to just sync the modified vmats)
      
      
      
      
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
// prep the following code by making asset_pack_sharetextures/materials/

/*
pbr future:
  upgrade/add resolution for ambientcg
  want a blend maker function
  
asset pack future (post byteframe13):
  fuck the logging?
  find more ways to simplify,
  use crowbar to extract all model source? (whoa)
  improve texture quality with that whatever thing?
  still dubious on slipstream culling
*/
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

models/props_xen/nihil_chamber/nihil_pipeclamp_001a.vmdl
models/props_xen/instances/c4a3b2/c4a3b2_machine_scar006.vmdl
models/props_interloper/b_power_console_large_45.vmdl
models/props_biotec/biotec_culture_tank.vmdl
*/

      
      
      
      
      
      
      