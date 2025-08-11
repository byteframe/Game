w = require('fs'),
axios = require('axios'),
download = require('download'),
content = '/mnt/l/polyhaven_models',
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
              console.log(F[0])))))())())))())