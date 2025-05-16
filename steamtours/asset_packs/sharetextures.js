// https://api2.sharetextures.com/api/v0/for-frontend/items?itemType=textures&sortBy=least_recent&page=17&perPage=2000
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
                  fs.rmdirSync(disk + textures[t].join('/') + file[0].slice(0, -4)),
                  fs.unlinkSync(disk + textures[t].join('/') + file[0]),
                  get_texture(t+1))))
              : get_texture(t+1)))
          : get_texture(t+1))())))()))