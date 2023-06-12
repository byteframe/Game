fs = require('fs'),
vdf = require('simple-vdf'),
colors = require('colors'),
request = require('request'),
Cheerio = require('cheerio'),
remotecache_vdf = vdf.parse(fs.readFileSync('C:\\Users\\byteframe\\Desktop\\remotecache.vdf.a', 'utf8'))['760'],
process.on('uncaughtException', (err) => console.log(err.stack)),
screenshots_vdf = vdf.parse(fs.readFileSync('C:\\Program Files (x86)\\Steam\\userdata\\752001\\760\\screenshots.vdf', 'utf8')).Screenshots;

// find screenshot files in cloud but not in vdf
screenshot_files = [],
Object.keys(screenshots_vdf).forEach((appid) =>
  Object.keys(screenshots_vdf[appid]).forEach((key) =>
    screenshot_files.push(screenshots_vdf[appid][key].filename))),
Object.keys(remotecache_vdf).forEach((key) =>
  (key.indexOf("_vr.jpg") == -1 && key.indexOf("/thumbnails/") == -1 && screenshot_files.indexOf(key) == -1) &&
    console.log(key));

// create culled remotecache vdf files (inactive)
cull_remotecache = () => (
  new_remotecache = { "760": {} },
  culled_remotecache = { "760": {} },
  Object.keys(remotecache_vdf).forEach((key) => (
    new_remotecache['760'][key] = remotecache_vdf[key],
    (key.match(/\d\d\d\d\d\d\d\d\d\d\d\d*\//)
    && key.indexOf('16098203768142692352') == -1
    && key.indexOf('17794472699079163904') == -1) && (
      new_remotecache['760'][key].syncstate = 3,
      culled_remotecache['760'][key] = remotecache_vdf[key])),
  fs.writeFileSync('new_remotecache.vdf', vdf.stringify(new_remotecache))));

// count vdf files and check for cloud status
total_vdf_count = 0,
vdf_counts = {},
moving = false,
path = "C:\\Program Files (x86)\\Steam\\userdata\\752001\\760\\remote\\",
Object.keys(screenshots_vdf).forEach((appid) =>
  (appid != 'shortcutnames') && (
    vdf_counts[appid] = [0,0,0],
    Object.keys(screenshots_vdf[appid]).forEach((file) => (
      vdf_counts[appid][1]++,
      (screenshots_vdf[appid][file].Permissions == 8) ? (
        vdf_counts[appid][0]++,
        total_vdf_count++,
        (!moving && !(screenshots_vdf[appid][file].filename in remotecache_vdf)) &&
          console.error("no upload reference in remotecache: " + screenshots_vdf[appid][file].filename))
      : (screenshots_vdf[appid][file].Permissions == 2) ?
        (screenshots_vdf[appid][file].filename in remotecache_vdf) &&
          console.error("unknown upload reference in remotecache: " + screenshots_vdf[appid][file].filename)
      : console.error("invalid permissions: " + screenshots_vdf[appid][file].filename),

      // move files and/or check filesystem existance
      (moving) ?
        (screenshots_vdf[appid][file].Permissions == 8 && fs.existsSync(path + screenshots_vdf[appid][file].filename)) &&
          fs.renameSync(path + screenshots_vdf[appid][file].filename, path + screenshots_vdf[appid][file].filename + ".pdl")
      :((fs.existsSync(path + screenshots_vdf[appid][file].filename + ".pdl")) &&
          fs.renameSync(path + screenshots_vdf[appid][file].filename + ".pdl", path + screenshots_vdf[appid][file].filename),
        (!fs.existsSync("C:\\Program Files (x86)\\Steam\\userdata\\752001\\760\\remote\\" + screenshots_vdf[appid][file].filename)) &&
          console.log('2D not on filesystem: ' + screenshots_vdf[appid][file].filename),
        (screenshots_vdf[appid][file].vrfilename && !fs.existsSync("C:\\Program Files (x86)\\Steam\\userdata\\752001\\760\\remote\\" + screenshots_vdf[appid][file].vrfilename)) &&
          console.log('VR not on filesystem: ' + screenshots_vdf[appid][file].vrfilename))))));

// get web appids and cross check
webcache = {},
(fs.existsSync('config-screenshots.json')) && (
  webcache = JSON.parse(fs.readFileSync('config-screenshots.json', 'utf8'))),
process.once('exit', (code) => fs.writeFileSync('config-screenshots.json', JSON.stringify(webcache, null, 2))),
process.on('SIGINT', process.exit, 0),
web_appids = {},
request('https://steamcommunity.com/id/byteframe/screenshots?view=grid', (error, response, body) => (
  web_appids.size = body.match(/Showing \d+ - \d+ of \d+/)[0].match(/\d+/g)[2],
  screenshot_web = Cheerio.load(body)('div.ellipsis'),
  screenshot_web.each((i, item) =>
    (i >= 3 && i < screenshot_web.length-2) ?
      web_appids[screenshot_web[i].attribs['onclick'].match(/\d+/)[0]] = 0 : null),
  delete web_appids['592408'],
  delete web_appids['409142'],
  Object.keys(web_appids).forEach((appid) =>
    (!appid in vdf_counts) &&
      console.error("no web appid in vdf: " + appid)),
  Object.keys(vdf_counts).forEach((appid) =>
    (vdf_counts[appid][0] > 0 && web_appids[appid] != 0 && appid != '17794472699079163904' && appid != '16098203768142692352') &&
      console.error("no vdf appid in web: " + appid)),

  // count web totals
  total_shas = [],
  verbose = false,
  (check_web_counts = (i = 0, shas = [], appid = Object.keys(web_appids)[i]) => (
    handle_appid = (data) => (
      vdf_counts[appid][2] = data.length,
      total_shas = total_shas.concat(data),
      ((result = "["+ appid + "]: " + vdf_counts[appid][0] + "/" + vdf_counts[appid][1] + "|" + vdf_counts[appid][2]) => (
        check_web_counts(i+1),
        (vdf_counts[appid][0] == vdf_counts[appid][1] && vdf_counts[appid][1] == vdf_counts[appid][2]) ? (
          webcache[appid] = data,
          (verbose) &&
            console.error((result + " >> COMPLETE").green))
        : (vdf_counts[appid][0] != vdf_counts[appid][2]) ? (
          console.error((result + " >> UPLOADED MISCOUNT").red),
          delete webcache[appid])
        : (vdf_counts[appid][1] != vdf_counts[appid][2]) ?
          (verbose) &&
            console.error((result + " >> INCOMPLETE").yellow)
        : console.error((result + " >> UNKNOWN").CYAN)))()),

    // record image checksums
    (i < Object.keys(web_appids).length-1) ?
      (webcache.hasOwnProperty(appid)) ?
        handle_appid(webcache[appid])
      : (request_screenshot_list = (p = 1) =>
        request('https://steamcommunity.com/id/byteframe/screenshots/?p=' + p + '&appid=' + appid + '&view=grid', (error, response, body, files = Cheerio.load(body)('.imgWallItem  ')) =>
          (files.length) ? (
            files.each((i, element, sha = element.attribs.style.replace(/.*\/ugc\/\d+\//, '').substr(0, 40)) =>
              shas.push(sha)),
            request_screenshot_list(p+1))
          : handle_appid(shas)))()

    // print final results
    :(console.log("total_shas_count+2+87: " + (""+(total_shas.length+2+87)).magenta),
      console.log("vdf_counts.length: " + (""+Object.keys(vdf_counts).length).blue + ", web_appids.length: " + (""+Object.keys(web_appids).length).magenta),
      console.log("total_vdf_count: " + (""+(total_vdf_count-2)).blue + ", web_appids.size: " + (""+(web_appids.size-1)).magenta))))()));