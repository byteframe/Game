fs = require('fs'),
axios = require('axios'),
(get_page = (offset = 0, h = 'https://ambientcg.com/hx/asset-list?type=material,atlas,decal&sort=latest&offset=' + offset + '&limit=180') =>
  axios.get(h).then(res => (
    console.log(h),
    data = '',
    Object.keys(res.data).forEach((d) => data += res.data[d]),
    matches = data.match(/\/view\?id=[A-Za-z0-9\_\-\+\=]+\"/g),
    matches == null ?
      console.log('for FILE in *.zip; do unzip -d "${FILE//.zip/}" ${FILE}; done')
    :(matches.map((e) => e.slice(9, -1)).forEach((match) =>
      (!fs.existsSync('/mnt/d/Source/ambientcg/materials/' + match) && !fs.existsSync('/mnt/d/Source/ambientcg/materials/' + match + "_2K-PNG.zip")) && 
        console.log("wget https://ambientcg.com/get?file=" + match + "_2K-PNG.zip -O" + " " + match + "_2K-PNG.zip")),
      setTimeout(get_page, 2000, offset+180)))).catch((error) => console.error(error)))();