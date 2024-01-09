axios = require('axios'),
(get_page = (offset = 0) =>
  axios.get('https://ambientcg.com/list?type=Material&sort=Latest&offset=' + offset + '&limit=180').then((res) => (
    data = '',
    Object.keys(res.data).forEach((d) => data += res.data[d]),
    matches = data.match(/\/view\?id=[A-Za-z0-9\_\-\+\=]+\"/g),
    (matches == null) ?
      console.log('done')
    :(matches.map((e) => e.slice(9, -1)).forEach((match) => (
      console.log("mkdir -p " + match),
      console.log("wget https://ambientcg.com/get?file=" + match + "_2K-PNG.zip -O" + " " + match + "_2K-PNG.zip"),
      console.log("unzip " + match + "_2K-PNG.zip -d " + match + " && rm " + match + "_2K-PNG.zip"))),
      setTimeout(get_page, 2000, offset+180)))).catch((error) => console.error(error)))();