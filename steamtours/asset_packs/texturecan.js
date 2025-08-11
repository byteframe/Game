w = require('fs'),
axios = require('axios'),
download = require('download'),
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
          w.existsSync(content + '/' + h.split('/')[2]) ?
            get(F.slice(1))
          : download('https://www.texturecan.com/' + h, content).then(() => (
            console.log(F[0] + '_' + g),
            get(F.slice(1))))))())))())