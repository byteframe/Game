w = require('fs'),
axios = require('axios'),
download = require('download'),
gm = require('gm');
const { default: isJpg } = await import("is-jpg");
texturecan = () => (
  content = '/mnt/s/texturecan/materials',
  game = '/mnt/w/texturecan/materials',
  [ game, content ].forEach(e => !w.existsSync(e) && w.mkdirSync(e, { recursive: true })),
  axios.get('https://www.texturecan.com/category/New/').then(r => 
    (get = (F = [...Array(+r.data.match(/\/details\/[0-9]*/)[0].substr(9)+1).keys()].slice(1)) =>
      F.length && 
        axios.get('https://www.texturecan.com/details/' + F[0] + '/').then(r => (
          r.data.includes("<a href=\"/category//\"") ?
            get(F.slice(1))
          : ((g = r.data.match(/\/downloads\/.+\//)[0].split('/')[2], h = r.data.match(/downloads\/.+?_4k_.+\.(zip|png)/i)[0]) => (
            w.existsSync(content + '/' + h.split('/')[2].replace(/_4k_.*.zip/, '')) ?
              get(F.slice(1))
            : download('https://www.texturecan.com/' + h, content).then(() => (
              console.log(F[0] + '_' + g),
              get(F.slice(1))))))())))()))
ambientcg = () => (
  resolution = '4K',
  format = 'PNG',
  addon = '/mnt/v/ambientcg',
  (get_page = (offset = 0, h = 'https://ambientcg.com/hx/asset-list?type=material,atlas,decal&sort=latest&offset=' + offset + '&limit=180') =>
    axios.get(h).then(res => (
      console.log(h),
      data = '',
      Object.keys(res.data).forEach(d => data += res.data[d]),
      matches = data.match(/\/view\?id=[A-Za-z0-9\_\-\+\=]+\"/g),
      matches == null ?
        console.log('for FILE in *.zip; do unzip -d "${FILE//.zip/}" ${FILE}; done')
      :(matches.map(e => e.slice(9, -1)).filter(e =>
        !e.match(/(Footsteps001|Smear001|Smear002|Fabric001|WoodFloor002|Tiles001|Paper002|Paper001|Gravel002|Gravel001|Asphalt002|Asphalt001|PavingStones001|RoadLines001|Concrete002|Concrete001|Bricks002|Bricks001)/)).forEach(e =>
          !w.existsSync(addon + '/materials/' + e) && !w.existsSync(addon + '/materials/' + e + "_" + resolution + "-" + format + ".zip") && 
            console.log("wget https://ambientcg.com/get?file=" + e + "_" + resolution + "-" + format + ".zip -O " + addon + "/materials/" + e + "_" + resolution + "-" + format + ".zip")),
          setTimeout(get_page, 2000, offset+180)))).catch(x => console.error(x)))());
polyhaven = () => (
  content = '/mnt/s/polyhaven/materials',
  game = '/mnt/v/polyhaven/materials',
  [ game, content ].forEach(e => !w.existsSync(e) && w.mkdirSync(e, { recursive: true })),
  vmats = w.readdirSync(game).filter(e => !e.endsWith('.vmat_c')).concat(w.readdirSync(content).filter(e => !e.endsWith('.vmat'))),
  axios.get('https://api.polyhaven.com/assets?t=textures').then(r =>
    (info = (G = Object.keys(r.data).filter(e => !vmats.includes(e)), files = []) =>
      G.length > 0 && axios.get('https://api.polyhaven.com/files/' + G[0]).then(r => (
        !w.existsSync(content + '/' + G[0]) &&
          w.mkdirSync(content + '/' + G[0]),
        (formats = [ [ 'Diffuse', 'png', 'diff' ],
          [ 'Displacement', 'png', 'disp' ],
          [ 'nor_gl', 'png', 'nor_gl' ],
          [ 'AO', 'png', 'ao' ],
          [ 'Metal', 'png', 'metal' ],
          [ 'Rough', 'png', 'rough' ] ]).forEach(e =>
          r.data.hasOwnProperty(e[0]) && !w.existsSync(content + '/' + G[0] + '/' + G[0] + '_' + G[2] + '_4k' + G[1]) &&
            files.push(r.data[e[0]]['4k'][e[1]].url)),
        !r.data.hasOwnProperty('Diffuse') && (
          files = files.concat(
            Object.keys(r.data).filter(e => e.match(/(col[0-9]+)/i) && !w.existsSync(content + '/' + G[0] + '/' + G[0] + '_' + e + '_4k' + formats[0][1])).
              map(e => r.data[e]['4k'][formats[0][1]].url))),
        files.length &&
          ((g = content + '/' + G[0] + '.vmat') =>
            w.existsSync(g) && (
              w.unlinkSync(g),
              console.log('deleted vmat file for: ' + g)))(),
        (get = (F = files) =>
          !F.length ?
            setTimeout(info, 2500, G.slice(1))
          : w.existsSync(content + '/' + G[0] + '/' + F[0].replace(/.*\//, '')) ?
            get(F.slice(1))
          : download(F[0], content + '/' + G[0]).then(() => (
            console.log(F[0]),
            get(F.slice(1)))))())))()))
polyhaven_models_old = () => (
  content = '/mnt/s/polyhaven_models',
  [ content + "/materials/models/polyhaven", content + "/models/polyhaven" ].forEach(e =>
    !w.existsSync(e) && w.mkdirSync(e, { recursive: true })),
  axios.get('https://api.polyhaven.com/assets?t=models').then(r =>
    (info = (G = Object.keys(r.data), files = []) =>
      G.length > 0 && axios.get('https://api.polyhaven.com/files/' + G[0]).then(r => (
        !w.existsSync(content + '/materials/models/polyhaven/' + G[0]) &&
          w.mkdirSync(content + '/materials/models/polyhaven/' + G[0]),
          files = files.concat(
            Object.keys(r.data).filter(e => !e.match(/(nor_dx|arm|usd|fbx|blend|gltf)/)).map(e => r.data[e]['4k']['png'].url)),
          files.push(r.data.fbx['4k'].fbx.url),
          global.write_vmdl &&
            w.writeFileSync(content + '/models/polyhaven/' + G[0] + ".vmdl",
              w.readFileSync('/mnt/d/Work/Game/steamtours/asset_packs/fbx_template.vmdl', 'utf-8').
                replace('__NAME__', G[0]).replace('__FBX__', 'models/polyhaven/' + G[0] + '_4k.fbx')),
          (get = (F = files) =>
            !F.length ?
              info(G.slice(1))
            :((d = F[0].endsWith('fbx') ? content + '/models/polyhaven' : content + '/materials/models/polyhaven/' + G[0],
               f = F[0].replace(/.*\//, '').replace('_4k.fbx', '.fbx')) => (
              F[0].endsWith('fbx') && (
                f = f.toLowerCase()),
              w.existsSync(d + "/" + f) ?
                get(F.slice(1))
              : download(F[0], d, { filename: f }).then(() => (
                get(F.slice(1)),
                console.log(F[0])))))())())))()))
(polyhaven_models = (G = [ 'fancy_picture_frame_01' ], resolution = '4k', content = '/mnt/c/Program Files (x86)/Steam/steamapps/common/SteamVR/tools/steamvr_environments/content/steamtours_addons/zzz_test') => (
  !Array.isArray(G) ? polyhaven_models([ G ], content)
  : !G.length ? axios.get('https://api.polyhaven.com/assets?t=models').then(r => polyhaven_models(Object.keys(r.data), content))
  :((files = []) =>
    axios.get('https://api.polyhaven.com/files/' + G[0]).then(r => (
      !w.existsSync(content + '/models/polyhaven/') &&
        w.mkdirSync(content + '/models/polyhaven/', { recursive: true }),
      !w.existsSync(content + '/materials/models/polyhaven/' + G[0]) &&
        w.mkdirSync(content + '/materials/models/polyhaven/' + G[0], { recursive: true }),
      files = files.concat(Object.keys(r.data).filter(e => !e.match(/(nor_dx|arm|usd|fbx|blend|gltf)/)).map(e => r.data[e][resolution]['png'].url)),
      files.push(r.data.fbx[resolution].fbx.url),
      w.writeFileSync(content + '/models/polyhaven/' + G[0] + ".vmdl",
        w.readFileSync('/mnt/d/Work/Game/steamtours/asset_packs/fbx_template.vmdl', 'utf-8').
          replace('m_pMaterialRemapList = null', 'm_pMaterialRemapList = \n\t{\n\t\tm_vMaterialRemapList = \n\t\t[\n\t\t\t{\n\t\t\t\tm_sSearchMaterial = "*"\n\t\t\t\tm_sReplaceMaterial = "materials/models/polyhaven/' + G[0].toLowerCase() + '.vmat"\n\t\t\t},\n\t\t]\n\t}').
          replace('__NAME__', G[0]).replace('__FBX__', 'models/polyhaven/' + G[0] + '.fbx')),
      (get = (F = files, m = '') =>
        !F.length ? (
          w.writeFileSync(content + "/materials/models/polyhaven/" + G[0] + ".vmat",
            "Layer0\n{\n  shader \"vr_standard.vfx\"\n  F_SPECULAR 1\n  F_SPECULAR_CUBE_MAP 1" + m + "\n}"),
          G.length > 1 && polyhaven_models(G.slice(1)))
        :((d = F[0].endsWith('fbx') ? content + '/models/polyhaven' : content + '/materials/models/polyhaven/' + G[0],
           f = F[0].replace(/.*\//, '').replace('_' + resolution + '.fbx', '.fbx').toLowerCase()) => (
          vmat_line = () =>
            f.includes("_diff_") ? m += "\n  TextureColor \"materials/models/polyhaven/" + G[0] + "/" + f + "\""
            : f.includes("_nor_gl_") ? m += "\n  TextureNormal \"materials/models/polyhaven/" + G[0] + "/" + f + "\""
            : f.match(/_(metallic|metal)_/) ? m += "\n  TextureReflectance \"materials/models/polyhaven/" + G[0] + "/" + f + "\"\n  g_vReflectanceRange \"[0.000 0.750]\"\n  F_METALNESS_TEXTURE 1\n  TextureMetalness \"materials/models/polyhaven/" + G[0] + "/" + f + "\""
            : f.match(/_(roughness|rough)_/) ? m += "\n  TextureGlossiness \"materials/models/polyhaven/" + G[0] + "/" + f.replace(/_(roughness|rough)_/, '_glossiness_') + "\""
            : f.includes("_ao_") ? m += "\n  F_INDIRECT_TEXTURES 2\n  TextureAmbientOcclusion \"materials/models/polyhaven/" + G[0] + "/" + f + "\""
            : f.includes("_opacity_") ? m += "\n  F_TRANSLUCENT 1\n  TextureTranslucency \"materials/models/polyhaven/" + G[0] + "/" + f + "\""
            : !f.includes('.fbx') && console.log('unknown texture: ' + f),
          w.existsSync(d + "/" + (F[0].match(/_(roughness|rough)_/) ? f.replace(/_(roughness|rough)_/, '_glossiness_') : f)) ? (
            vmat_line(),
            get(F.slice(1), m))
          : download(F[0], d, { filename: f }).then(() => (
            (buffer =>
              isJpg(buffer) && (
                console.log('isJpg: ' + f),
                w.renameSync(d + '/' + f, d + '/' + f.replace('png', 'jpg')),
                f = f.replace('png', 'jpg')))(w.readFileSync(d + '/' + f)),
            vmat_line(),
            F[0].match(/_(roughness|rough)_/) &&
              gm(d + '/' + f).negative().write(d + '/' + f.replace(/_(roughness|rough)_/, '_glossiness_'), x =>
                x ? console.log(x) : w.unlinkSync(d + '/' + f)),
            get(F.slice(1), m),
            console.log(F[0])))))())())))()))()
sharetextures = () => (
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
            : get_texture(t+1))())))())))
(vogue = (h = 'https://archive.vogue.com/issue/19920301', d ='/home/byteframe/Desktop/vogue') =>
  axios.get(h).then(r =>
   ((img = r.data.match("https://.+?/vogueoutput.+?\.jpg")[0], f = img.replace(/.*\//, '')) =>
      download(img, d).then(() => (
        w.writeFileSync(d + "/" + f.replace(/\.jpg$/, ".vmat"), 'Layer0\n{\n  TextureColor "materials/vogue/' + f + '"\n}'),
        console.log(img),
        setTimeout(vogue, 1500, "https://archive.vogue.com" + r.data.match("Next Issue\" href=\"/issue/[0-9]*")[0].substr(18)))))())
  .catch(x => setTimeout(vogue, 10000, h)))()
coverjunkie_bulk_old = () => (
  content = '/mnt/c/Users/byteframe/Desktop/coverjunkie',
  axios.get('https://coverjunkie.com/all-magazine-titles/').then(r =>
    ((titles = (r.data.match(/href="\/magazines\/.+?"/g).map(e => e.slice(17, -1)))) =>
      (title = (t = 0, d = content + "/" + titles[t].replace(/-/g, '_')) => (
        !w.existsSync(d) &&
          w.mkdirSync(d, { recursive: true }),
        console.log("[ " + d + " ]"),
        axios.get('https://coverjunkie.com/magazines/' + titles[t]).then(r =>
          ((files = ((r.data.match(/src="https:\/\/coverjunkie.com\/wp-content\/uploads\/.+?"/g) || []).filter(e => !e.includes('COVERJUNKIE')).map(e => e.slice(5, -1)))) => 
            (file = (f = 0, filename = decodeURI(files[f]).replace(/.*\//, '').replace(/­/g, '_').replace(/-/g, '_').replace(".jpeg", ".jpg")) =>
              f == files.length ?
                setTimeout(title, (global.file_timeout || 2500), t+1)
              : w.existsSync(d + "/" + filename) ? 
                file(f+1)
              :(console.log(titles[t] + " | " + files[f]),
                download(encodeURI(files[f]), d, { filename: filename }).then(() => (
                  w.writeFileSync(d + "/" + filename.replace(/\..*/, '.vmat'), "\"Layer0\"\n{\n\t\"Shader\"\t\t\"vr_simple.vfx\"\n\t\"TextureColor\"\t\t\"materials/coverjunkie/" + titles[t] + "/" + filename + "\"\n}"),
                  setTimeout(file, (global.file_timeout || 300), f+1)))))())())
        .catch(x => (
          console.log(x.cause.code),
          setTimeout(title, (global.title_timeout || 3000), t)))))())()))