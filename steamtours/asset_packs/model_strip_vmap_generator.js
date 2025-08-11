w = require('fs'),
m = '',
!process.argv[2] ? (
  skins = [],
  vmdl_files = w.readFileSync('vmdl_files', 'utf8').split('\n').filter(e => e.length > 1))
:(vmdl_files = [ process.argv[2].replace(/.*\/models\//, 'models/') ],
  skins = w.readFileSync(process.argv[2], 'utf-8').match(/m_name = "[a-zA-Z0-9_-]*/g).map(e => e.substr(10)).slice(1)),
(skins.length ? skins : vmdl_files).forEach((g, i) => (
  n =
  `
        "CMapEntity"
        {
          "id" "elementid" "AAAAAAAAA"
          "origin" "vector3" "XXXXXXXXX YYYYYYYYY 0"
          "angles" "qangle" "0 0 0"
          "scales" "vector3" "1 1 1"
          "nodeID" "int" "4"
          "referenceID" "uint64" "BBBBBBBBB"
          "children" "element_array" 
          [
          ]
          "editorOnly" "bool" "0"
          "force_hidden" "bool" "1"
          "transformLocked" "bool" "0"
          "variableTargetKeys" "string_array" 
          [
          ]
          "variableNames" "string_array" 
          [
          ]
          "relayPlugData" "DmePlugList"
          {
            "id" "elementid" "AAAAAAAAA"
            "names" "string_array" 
            [
            ]
            "dataTypes" "int_array" 
            [
            ]
            "plugTypes" "int_array" 
            [
            ]
            "descriptions" "string_array" 
            [
            ]
          }
          
          "connectionsData" "element_array" 
          [
          ]
          "entity_properties" "EditGameClassProps"
          {
            "id" "elementid" "AAAAAAAAA"
            "classname" "string" "prop_static"
            "model" "string" "MMMMMMMMM"
            "solid" "string" "6"
            "disableshadows" "string" "0"
            "screenspacefade" "string" "0"
            "skin" "string" "SSSSSSSSS"
            "lodlevel" "string" "-1"
            "fademindist" "string" "-1"
            "fademaxdist" "string" "0"
            "fadescale" "string" "1"
            "detailgeometry" "string" "0"
            "visoccluder" "string" "0"
            "baketoworld" "string" "0"
            "renderamt" "string" "255"
            "rendercolor" "string" "255 255 255"
            "lightingorigin" "string" ""
            "lightgroup" "string" ""
            "rendertocubemaps" "string" "1"
            "precomputelightprobes" "string" "1"
            "materialoverride" "string" ""
            "disableinlowquality" "string" "0"
            "lightmapscalebias" "string" "0"
            "bakelighting" "string" "-1"
            "renderwithdynamic" "string" "0"
          }
          
          "hitNormal" "vector3" "0 0 1"
          "isProceduralEntity" "bool" "0"
        },
  `,
  n = n.replace(/AAAAAAAAA/g, () => [...Array(36).keys()].map(e => e == '8' || e == '13' || e == '18' || e == '23' ? '-' : Math.floor(Math.random() * 16).toString(16)).join('')),
  n = n.replace(/BBBBBBBBB/g, () => "0x" + [...Array(16).keys()].map(e => Math.floor(Math.random() * 16).toString(16)).join('')),
  n = n.replace(/YYYYYYYYY/g, () => i*(process.argv[3] || 0)),
  n = n.replace(/XXXXXXXXX/g, () => 0),
  n = n.replace(/MMMMMMMMM/g, () => !process.argv[2] ? g : vmdl_files[0]),
  n = n.replace(/SSSSSSSSS/g, () => skins[i] || 'default'),
  m += n)),
console.log(w.readFileSync('/mnt/d/Work/Game/steamtours/asset_packs/model_strip_vmap_template.txt', 'utf8').replace('ZZZZZZZZZ', m));
