w = require('fs'),
axios = require('axios'),
download = require('download'),
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
          get(F.slice(1)))))())))())