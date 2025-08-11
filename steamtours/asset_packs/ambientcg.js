resolution = '4K',
format = 'PNG',
addon = '/mnt/v/ambientcg_' + resolution,
w = require('fs'),
axios = require('axios'),
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
          console.log("wget https://ambientcg.com/get?file=" + e + "_" + resolution + "-" + format + ".zip -O " + addon + "/" + e + "_" + resolution + "-" + format + ".zip")),
        setTimeout(get_page, 2000, offset+180)))).catch(x => console.error(x)))();