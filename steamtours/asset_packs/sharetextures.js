w = require('fs'),
axios = require('axios'),
download = require('download'),
content = '/mnt/s/sharetextures/materials/',
game = '/mnt/w/sharetextures/materials/',
[ game, content ].forEach(e =>
  !w.existsSync(e) &&
    w.mkdirSync(e, { recursive: true })),
vmats = w.readdirSync(game).filter(e => !e.endsWith('.vmat_c')).concat(w.readdirSync(content).filter(e => !e.endsWith('.vmat'))),
adm_zip = require('adm-zip'),
axios.get('https://api2.sharetextures.com/api/v0/for-frontend/items?itemType=textures&sortBy=least_recent&page=1&perPage=2000').then(r => wasd = ( r.data))

  data = '', Object.keys(res.data).forEach((d) => data += res.data[d]),
  categories = data.match(/href=\"\/category\/[a-z]*\"/g).map((item) => item.slice(16, -1)),
  (get_textures = (c = 0) =>
    categories.length == c ?
      console.log('done')
    : categories[c].indexOf('sbsar') > -1 ?
      get_textures(c+1)
    : axios.get('https://www.sharetextures.com/category/' + categories[c]).then((res) => (
        data = '', Object.keys(res.data).forEach((d) => data += res.data[d]),
        textures = data.match(/href=\"\/textures\/[a-zA-Z0-9\_\-\/]*\/\"/g).map((item) => item.slice(16, -2).split('/')),
        (get_texture = (t = 0) =>
          textures.length == t ?
            get_textures(c+1)
          : !w.existsSync(disk + textures[t].join('/')) ?
            axios.get('https://www.sharetextures.com/textures/' + textures[t].join('/')).then((res) => (
              data = '', Object.keys(res.data).forEach((d) => data += res.data[d]),
              file = data.match(/\/[a-zA-Z0-9\_\-]*-2K.zip/),
              file && data.indexOf('Click here to login via Patreon') == -1 ? (
                console.log("https://files.sharetextures.com/file/Share-Textures" + file[0]),
                !w.existsSync(disk + textures[t][0]) &&
                  w.mkdirSync(disk + textures[t][0]),
                w.mkdirSync(disk + textures[t].join('/')),
                download('https://files.sharetextures.com/file/Share-Textures' + file[0], disk + textures[t].join('/')).then(() => (
                  zip = new adm_zip(disk + textures[t].join('/') + file[0]),
                  zip.getEntries().forEach((zip_entry) =>
                    zip_entry.entryName.indexOf(".") > -1 && (
                      zip.extractEntryTo(zip_entry.entryName, disk + textures[t].join('/')),
                      w.renameSync(disk + textures[t].join('/') + "/" + zip_entry.entryName,
                        disk + textures[t].join('/') + "/" + zip_entry.entryName.substring(zip_entry.entryName.indexOf('/'))))),
                  w.rmdirSync(disk + textures[t].join('/') + file[0].slice(0, -4)),
                  w.unlinkSync(disk + textures[t].join('/') + file[0]),
                  get_texture(t+1))))
              : get_texture(t+1)))
          : get_texture(t+1))())))()))