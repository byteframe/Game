axios = require('axios'),
fs = require('fs'),
(get_page1 = (offset = 0) =>
  axios.get('https://ambientcg.com/list?type=Material&sort=Latest&offset=' + offset + '&limit=180').then((res) => {
    var data = '';
    Object.keys(res.data).forEach((d) => data += res.data[d]);
    var matches = data.match(/\.\/view\?id=[A-Za-z0-9\_\-\+\=]+\"/g);
    (matches != null && matches.length > 0) ?
      (check_match = (i = 0, match = matches[i].slice(10, -1)) =>
        (i >= matches.length-1) ?
          get_page1(offset+180)
        : (!fs.existsSync("/home/byteframe/ambientcg/" + match + "_2K-PNG.zip")&& !fs.existsSync("/home/byteframe/ambientcg/" + match + "_2K-JPG.zip")) ? (
          console.log("wget https://ambientcg.com/get?file=" + match + "_2K-PNG.zip -O" + " " + match + "_2K-PNG.zip\n"),
          check_match(i+1))
        : (axios.get('https://ambientcg.com/view?id=' + match).then((res) => {
            data = '';
            Object.keys(res.data).forEach((d) => data += res.data[d]);
            category = data.match(/category=[a-zA-Z]+/)[0].slice(9);
            (!fs.existsSync('/home/byteframe/ambientcg/' + category)) &&
              fs.mkdirSync('/home/byteframe/ambientcg/' + category);
            (!fs.existsSync('/home/byteframe/ambientcg/' + category + "/" + match)) &&
              fs.mkdirSync('/home/byteframe/ambientcg/' + category + "/" + match);
            (fs.existsSync("/home/byteframe/ambientcg/" + match + "_2K-PNG.zip")) ? 
              console.log("unzip /home/byteframe/ambientcg/" + match + "_2K-PNG.zip -d /home/byteframe/ambientcg/" + category + "/" + match)
            : console.log("unzip /home/byteframe/ambientcg/" + match + "_2K-JPG.zip -d /home/byteframe/ambientcg/" + category + "/" + match);
          }).catch((error) => console.error(error)),
          setTimeout(check_match, 3000, i+1))
      )()
    : console.log('done');
  }).catch((error) => console.error(error)))();