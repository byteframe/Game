require('_shared')
math.randomseed(Time())
local objects = {
  objects1 = { 0, {
    {    "prop_destinations_tool", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/props_gameplay/controllers/vr_controller_brush.vmdl", vscripts = "tools/tagmarker" } },
    {    "prop_destinations_tool", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/props_gameplay/freeze_tool001.vmdl", vscripts = "tools/freeze_tool" } },
    {    "prop_destinations_tool", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/props_gameplay/airbrush_tool.vmdl", vscripts = "tools/color_tool" } },
    {    "prop_destinations_tool", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/props_gameplay/drone_controller001.vmdl", vscripts = "tools/drone" } },
    {    "prop_destinations_tool", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/props_gameplay/colour_picker_tool.vmdl", vscripts = "tools/color_tool" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/props/ration_bar.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/props_office/calculator.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/calculator/calculator.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/unconid/atari/cartridge_atari_1_obj.vmdl", vscripts = "props/skin", skin_range = 5 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/unconid/atari/cartridge_atari_2_obj.vmdl", vscripts = "props/skin", skin_range = 3 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/unconid/atari/cartridge_atari_3_obj.vmdl", vscripts = "props/skin", skin_range = 3 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/unconid/atari/cartridge_atari_4_obj.vmdl", vscripts = "props/skin", skin_range = 3 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 270, 0), noprecache = true, model = "models/unconid/n64/n64_cartridge_obj.vmdl", vscripts = "props/skin", skin_range = 9 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 90),  noprecache = true, model = "models/unconid/genesis/genesis_cartridge_obj.vmdl", vscripts = "props/skin", skin_range = 10 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 90),  noprecache = true, model = "models/unconid/snes/snes_cartridge_obj.vmdl", vscripts = "props/skin", skin_range = 20 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.85 0.85 0.85", _angles = QAngle(0, 0, 90), noprecache = true, model = "models/unconid/nes/nes_cartridge_obj.vmdl", vscripts = "props/skin", skin_range = 23 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 90),  noprecache = true, model = "models/unconid/pc_models/floppy_3_5_obj.vmdl", vscripts = "props/skin", skin_range = 4 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 90),  noprecache = true, model = "models/props/brazzersdvd.vmdl", vscripts = "props/skin", skin_range = 313, } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/themask/sbmp/store/money/obj_money_stack_fbx.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/w_models/weapons/w_eq_adrenaline.vmdl" } },
    {    "prop_destinations_tool", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  90, 0, 0),  noprecache = true, model = "models/props_items/zippo_closed001_dmx.vmdl", vscripts = "tools/lighter" } },
    {    "prop_destinations_tool", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  90, 0, 0),  noprecache = true, model = "models/props/interior_deco/tabletop_lighter_dmx.vmdl", vscripts = "tools/lighter" } },
    {    "prop_destinations_tool", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  90, 0, 0),  noprecache = true, model = "models/themask/sbmp/groceries/tobacco/cigarettes_01_pack.vmdl", vscripts = "tools/cigarette_pack" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 270, 0),  noprecache = true, model = "models/themask/sbmp/medic/medicine/medx.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 90, 0),  model = "models/themask/sbmp/medic/medicine/akers_medicine.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 270, 0),  model = "models/themask/sbmp/medic/medicine/akers_medicine_2.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(  0, 90, 0),  noprecache = true, model = "models/themask/sbmp/medic/medicine/mentats.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.6 0.6 0.6", _angles = QAngle(  90, 0, 0),  model = "models/w_models/weapons/w_eq_bile_flask.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(90, 90, 0),   noprecache = true, model = "models/themask/sbmp/furniture/bathroom/bottle_5.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/props_junk/junk_glue.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  90, 0, 0),  model = "models/necrotales/store/products_hanging01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  90, 0, 0),  noprecache = true, model = "models/props/interior_deco/tabletop_gluebottle.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.7 0.7 0.7", _angles = QAngle(  90, 0, 0),  model = "models/dildo/dildo.vmdl", vscripts = "props/random_color", chance = 0.5 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle( 0, 270, 0),  model = "models/props_se/junk/gel.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/props_tse/props_furniture/floppy_disk1.vmdl", vscripts = "props/skin", skin_range = 7 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.7 0.7 0.7", _angles = QAngle(   0, 0, 0),  model = "models/props_tse/props_furniture/vhs.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, -90),  noprecache = true, model = "models/themask/sbmp/furniture/kitchen_items/diner_hotsauce.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.2 1.2 1.2", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/themask/sbmp/furniture/ashtrays/btr_ashtray_metal_01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle( -90, 0, 0),  model = "models/necrotales/store/products_hanging01.vmdl", vscripts = "props/skin", skin_range = 2 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  90, 0, 0),  noprecache = true, model = "models/breakable_props/bottle_o_gin.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/props/interior_deco/tabletop_stapler.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/props/interior_deco/tabletop_paintbrush.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/props/interior_deco/tabletop_pencase02.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/props/interior_deco/tabletop_hairbrush.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/props/interior_deco/tabletop_leatherfolder.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.7 0.7 0.7", _angles = QAngle(   0, 0, 0),  noprecache = true, model = "models/sm_carrot/sm_carrot.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.7 0.7 0.7", _angles = QAngle(   0, 0, 0),  model = "models/scenery/misc/clothing/lubricant.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.8 0.8 0.8", _angles = QAngle( 0, 0, -90),  model = "models/themask/sbmp/clothing/accessories/perfumeset2.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle(90, 0, 0),    model = "models/themask/sbmp/clothing/accessories/perfumeset3.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 2.000), scales = "0.9 0.9 0.9", _angles = QAngle(0, 270, 90),  model = "models/scenery/misc/tsengs/box1.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 2.000), scales = "0.9 0.9 0.9", _angles = QAngle(0, 270, 90),  model = "models/scenery/misc/tsengs/box2.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 2.000), scales = "0.9 0.9 0.9", _angles = QAngle(0, 270, 90),  model = "models/scenery/misc/tsengs/box3.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 2.000), scales = "0.9 0.9 0.9", _angles = QAngle(0, 270, 90),  model = "models/scenery/misc/tsengs/box4.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.4 0.4 0.4", _angles = QAngle(   0, 0, 0),  model = "models/scenery/misc/tsengs/bottle1.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.4 0.4 0.4", _angles = QAngle(   0, 0, 0),  model = "models/scenery/misc/tsengs/bottle2.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.4 0.4 0.4", _angles = QAngle(   0, 0, 0),  model = "models/scenery/misc/tsengs/bottle3.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.8 0.8 0.8", _angles = QAngle( -90, 0, 0),  model = "models/props_tse/props_furniture/sackboy_dmx.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle( -90, 0, 0),  model = "models/nt/props_street/rabbit_doll.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  90, 0, 0),  noprecache = true, model = "models/themask/sbmp/groceries/bottles_alc/flask_01_dmx.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/characters/bolt-on/glasses/mavrodi_glass.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/characters/bolt-on/glasses/dude_glass_01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/characters/bolt-on/glasses/dude_glass_02.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/characters/bolt-on/glasses/glass_01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/characters/bolt-on/glasses/glass_02.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/characters/bolt-on/glasses/glass_03.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/characters/bolt-on/glasses/glass_04.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/characters/bolt-on/glasses/glass_05.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/characters/bolt-on/glasses/glass_06.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/characters/bolt-on/glasses/glass_07.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/characters/bolt-on/glasses/glass_08.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/props_items/toothpile_1.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(   0, 0, 0),  model = "models/props/interior_deco/tabletop_cd.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle(  90, 0, 0),  model = "models/pornworld/pw_doll_box_01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle(  90, 0, 0),  model = "models/pornworld/pw_doll_box_02.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle(  90, 0, 0),  model = "models/pornworld/sex_set_01b_gib.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle(  90, 0, 0),  model = "models/gibs/sex_set_02b_stuff_gib_03.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle(   0, 0, 0),  model = "models/pornworld/sex_set_01a_gib.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle(  90, 0, 0),  model = "models/small_things/sex_toy_05.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, -90),  model = "models/sex_please_sex_shop/sex_please_sex_shop_vibrator_small.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.4 0.4 0.4", _angles = QAngle(   0, 0, 0),  model = "models/weapons/w_models/w_damageboost.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.4 0.4 0.4", _angles = QAngle(   0, 0, 0),  model = "models/weapons/w_models/w_speedboost.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.4 0.4 0.4", _angles = QAngle(   0, 0, 0),  model = "models/weapons/w_models/w_invisibility.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.4 0.4 0.4", _angles = QAngle(   0, 0, 0),  model = "models/weapons/w_models/w_armour.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle(   0, 0, 0),  model = "models/sex_please_sex_shop/sex_please_sex_shop_belt.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.3 1.3 1.3", _angles = QAngle(   0, 0, 0),  model = "models/sex_please_sex_shop/sex_please_sex_shop_dick_boxes_1.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.3 1.3 1.3", _angles = QAngle(   0, 0, 0),  model = "models/sex_please_sex_shop/sex_please_sex_shop_dick_boxes_2.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.3 1.3 1.3", _angles = QAngle(   0, 0, 0),  model = "models/sex_please_sex_shop/sex_please_sex_shop_dick_boxes_3.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.3 1.3 1.3", _angles = QAngle(   0, 0, 0),  model = "models/sex_please_sex_shop/sex_please_sex_shop_dick_boxes_4.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.3 1.3 1.3", _angles = QAngle(   0, 0, 0),  model = "models/sex_please_sex_shop/sex_please_sex_shop_dick_boxes_5.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.3 1.3 1.3", _angles = QAngle(   0, 0, 0),  model = "models/sex_please_sex_shop/sex_please_sex_shop_dick_boxes_6.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.3 1.3 1.3", _angles = QAngle(   0, 0, 0),  model = "models/sex_please_sex_shop/sex_please_sex_shop_dick_boxes_7.vmdl" } },
  } },
  objects2 = { 0, {
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle( 0, 0, 0),  noprecache = true, model = "models/props/butter_carton_empty_1.vmdl", vscripts = "props/skin", skin_range = 3 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.2 0.2 0.2", _angles = QAngle( 0, 0, -90),  noprecache = true, model = "models/props_harvest/drugs_cocaine_bag.vmdl" } },
    {    "prop_destinations_tool", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  90, 0, 0),  noprecache = true, model = "models/props_items/zippo_closed001_dmx.vmdl", vscripts = "tools/lighter" } },
    {    "prop_destinations_tool", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  90, 0, 0),  noprecache = true, model = "models/props/interior_deco/tabletop_lighter_dmx.vmdl", vscripts = "tools/lighter" } },
    {     "prop_physics_override", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(90, 0, 0),    noprecache = true, model = "models/props/low_poly_gold_coin_7a40d686492545d1a6f6bd0c487f1cb9.vmdl" } },
    {     "prop_physics_override", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(90, 0, 0),    noprecache = true, model = "models/props/low_poly_gold_coin_7a40d686492545d1a6f6bd0c487f1cb9.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),    model = "models/themask/sbmp/sport/minigolf/bank_obj_minigolf_ball.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),    model = "models/props_school/school_smallprops/paper_ball_01.vmdl", vscripts = "props/random_color",  } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, -90),  noprecache = true, model = "models/ivancorn/gtaiv/electrical/phones/cellphone_badger_crappy_obj.vmdl", vscripts = "props/skin_with_pickup", skin_range = 2 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, -90),  noprecache = true, model = "models/ivancorn/gtaiv/electrical/phones/cellphone_panoramic_tinkle_obj.vmdl", vscripts = "props/skin_with_pickup", skin_range = 2 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.1 1.1 1.1", _angles = QAngle( 0, 0, -90),  noprecache = true, model = "models/ivancorn/gtaiv/electrical/phones/cellphone_whiz_gold_obj.vmdl", vscripts = "props/skin_with_pickup", skin_range = 2 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, -90),  noprecache = true, model = "models/ivancorn/gtaiv/electrical/phones/phone_mobile_badger_touchscreen_obj.vmdl", vscripts = "props/skin_with_pickup", skin_range = 16 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, -90),  noprecache = true, model = "models/ivancorn/gtaiv/electrical/phones/cellphone_whiz_highspeed_obj.vmdl", vscripts = "props/skin_with_pickup", skin_range = 3 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, -90),  noprecache = true, model = "models/ivancorn/gtaiv/electrical/phones/cellphone_badger_obj.vmdl", vscripts = "props/skin_with_pickup", skin_range = 10 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, -90),  noprecache = true, model = "models/ivancorn/gtaiv/electrical/phones/cellphone_thelostdamned_obj.vmdl", vscripts = "props/skin_with_pickup", skin_range = 10 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90, 0, 0),   noprecache = true, model = "models/themask/sbmp/electronics_items/smartphones/obj_mobilephone.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90, 0, 0),   noprecache = true, model = "models/props_office/mobile_phone_001.vmdl", vscripts = "props/skin_with_pickup", skin_range = 1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.2 1.2 1.2", _angles = QAngle( 0, 0, 0),    noprecache = true, model = "models/lt_c/tech/cellphone_obj.vmdl", vscripts = "props/skin_with_pickup", skin_range = 10 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.8 0.8 0.8", _angles = QAngle(-90, 0, 0),   noprecache = true, model = "models/unconid/iphone7/iphone7_pro_obj.vmdl", vscripts = "props/skin_with_pickup", skin_range = 3 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.3 1.3 1.3", _angles = QAngle(-90, 0, 0),   noprecache = true, model = "models/themask/sbmp/electronics_items/smartphones/sphone_tb_sg.vmdl", vscripts = "props/skin_with_pickup", skin_range = 3 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    model = "models/items/keys_002.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    noprecache = true, model = "models/props_items/chocolatebar_01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    model = "models/items/keys_003.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.2 1.2 1.2", _angles = QAngle( 0, 0, 0),    model = "models/props_items/tealight001_dmx.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    model = "models/items/keys_003b.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    model = "models/props/hotel/hotel_keychain.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    model = "models/props_items/nutritionbar001.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    noprecache = true, model = "models/props_items/bonbon_01.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    noprecache = true, model = "models/props_items/bonbon_02.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    noprecache = true, model = "models/props_items/bonbon_03.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    noprecache = true, model = "models/props_items/bonbon_04.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    model = "models/props_items/bonbon_05.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.3 0.3 0.3", _angles = QAngle(90, 0, 0),    model = "models/pornworld/pw_pocket_pet_box_01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle(90, 0, 0),    model = "models/pornworld/sex_set_01c_gib1.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle(90, 0, 0),    model = "models/pornworld/sex_set_01c_gib2.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle( 0, 0, 0),    model = "models/sm_sealife_shells/sm_sealife_shell_a.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle( 0, 0, 0),    model = "models/sm_sealife_shells/sm_sealife_shell_b.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle( 0, 0, 0),    model = "models/sm_sealife_shells/sm_sealife_shell_c.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle( 0, 0, 0),    model = "models/sm_sealife_shells/sm_sealife_shell_b2.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    model = "models/props_items/matchbox001.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.6 0.6 0.6", _angles = QAngle( 0, 0, 0),    model = "models/sm_matchbook/sm_matchbook_a.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.6 0.6 0.6", _angles = QAngle( 0, 0, 0),    model = "models/sm_matchbook/sm_matchbook_b.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    noprecache = true, model = "models/props/interior_deco/tabletop_pills_foil.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.66 0.66 0.66", _angles = QAngle(-90,0, 0), noprecache = true, model = "models/unconid/gameboy/gameboy_cartridge_obj.vmdl", vscripts = "props/skin", skin_range = 8 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.66 0.66 0.66", _angles = QAngle(-90,0, 0), noprecache = true, model = "models/unconid/gameboy/gameboy_color_cartridge_obj.vmdl", vscripts = "props/skin", skin_range = 8 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    model = "models/props_items/cassette_tape001.vmdl", vscripts = "props/skin", skin_range = 2 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    model = "models/unconid/cassette_tape/cassette_tape_obj.vmdl", vscripts = "props/skin", skin_range = 2 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    noprecache = true, model = "models/props/playboy_condoms_e693881879084237b00f469980ed22a7_orange.vmdl", vscripts = "props/skin", skin_range = 4 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    noprecache = true, model = "models/props/playboy_condoms_e693881879084237b00f469980ed22a7_orange2.vmdl", vscripts = "props/skin", skin_range = 4 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 0),    noprecache = true, model = "models/sex_please_sex_shop/sex_please_sex_shop_condom.vmdl", vscripts = "props/skin", skin_range = 3 } },
    {    "prop_destinations_tool", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  90, 0, 0),  noprecache = true, model = "models/props_items/zippo_closed001_dmx.vmdl", vscripts = "tools/lighter" } },
    {    "prop_destinations_tool", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  90, 0, 0),  noprecache = true, model = "models/props/interior_deco/tabletop_lighter_dmx.vmdl", vscripts = "tools/lighter" } },
    {     "prop_physics_override", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(90, 0, 0),    noprecache = true, model = "models/props/low_poly_gold_coin_7a40d686492545d1a6f6bd0c487f1cb9.vmdl" } },
    {     "prop_physics_override", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(90, 0, 0),    noprecache = true, model = "models/props/low_poly_gold_coin_7a40d686492545d1a6f6bd0c487f1cb9.vmdl" } },
  } },
  objects_bottle = { 0, {
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/props/coffee_box.vmdl", vscripts = "props/skin", skin_range = 1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/props/can_1.vmdl", vscripts = "props/skin", skin_range = 5 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),    noprecache = true, model = "models/themask/sbmp/furniture/dishes/cup_coffee_paper.vmdl", vscripts = "props/random_color",  } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),    noprecache = true, model = "models/props/interior_deco/tabletop_papercup.vmdl", vscripts = "props/random_color",  } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),    model = "models/props/interior_deco/tabletop_papercup_broken.vmdl", vscripts = "props/random_color",  } },
    {     "prop_physics_override", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(90, 0, 0),    noprecache = true, model = "models/props/low_poly_gold_coin_7a40d686492545d1a6f6bd0c487f1cb9.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/bottles_alc/glass_alcoholbottle_twb_dup.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/bottles_alc/glass_alcoholbottle_twc_dup.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/bottles_alc/glass_alcoholbottle_twd_dup.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 6.530), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/bottles_alc/wine_bottle_01.vmdl", vscripts = "props/skin", skin_range = 8 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/bottles_alc/wine_bottle_02.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/bottles_soda/barracks_bottle_bwa.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/bottles_alc/wine_bottle_04.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/bottles_alc/bobrovsbestmoonshine.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/bottles_soda/food_trash_bottle_water_01.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/bottles_soda/food_trash_bottle_soda_04.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/bottles_soda/food_trash_bottle_soda_03.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/bottles_soda/food_trash_bottle_soda_02.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/bottles_soda/food_trash_bottle_soda_01.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/bottles_soda/food_trash_bottle_juice_01.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/cans_soda/food_trash_can_soda_03.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/cans_soda/waterpurified_sg.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/cans_soda/food_trash_can_soda_02.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/cans_soda/food_trash_can_soda_01.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/themask/sbmp/groceries/cans_soda/ace_can_cola_01.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/props/plastic_bottle_4.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/props/plastic_bottle_4.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/props/plastic_bottle_4.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0), model = "models/props_items/candle_01_phys_dmx.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0), model = "models/props_tse/props_furniture/candle01_tiny_dmx.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/props/distillery/bottle_vodka.vmdl", vscripts = "props/skin", skin_range = 1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 6.000), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/props/junk/wine_bottle.vmdl", vscripts = "props/skin", skin_range = 2 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/props_junk/bottle_003.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/props/beer_bottle_1_empty.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/breakable_props/bottle_o_gin.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), model = "models/props/milk_carton_1.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0), model = "models/props_junk/milkcarton_001_static.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/props_items/milkcarton001.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.5 0.5 0.5", _angles = QAngle(0.0, 0.0, 0), model = "models/sm_camp_bottle/sm_camp_bottle.vmdl", vscripts = "props/random_color"} },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "0.7 0.7 0.7", _angles = QAngle(0.0, 0.0, 0), noprecache = true, model = "models/props/cs_militia/bottle01.vmdl", } },
  } },
  objects_roll = { 0, {
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, -90),  noprecache = true, model = "models/props/interior_deco/interior_bathroom_toiletroll_001.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, -90),  noprecache = true, model = "models/props/interior_deco/interior_bathroom_toiletroll_002.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, -90),  model = "models/props/interior_deco/interior_bathroom_toiletroll_003.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, -90),  noprecache = true, model = "models/props/interior_deco/interior_maintenance_paper_towels_001.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, -90),  noprecache = true, model = "models/props/interior_deco/interior_maintenance_paper_towels_002.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, -90),  noprecache = true, model = "models/props/interior_deco/interior_maintenance_paper_towels_003.vmdl", } },
  }, },
  objects_chip = { 0, {
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), _scales = "1.0 1.0 1.0", _angles = QAngle(0, 270, 0),  model = "models/chip_bags/chip_bag_fbx.vmdl", vscripts = "props/skin", skin_range = 31, scale_flex = "0.3" } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0.125), _scales = "1.0 1.0 1.0", _angles = QAngle(0, 270, 0),  model = "models/chip_bags/chip_bag_2_fbx.vmdl", vscripts = "props/skin", skin_range = 17, scale_flex = "0.3" } },
  } },
  objects_book = { 0, {
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 0),  noprecache = true, model = "models/props/vogue_magazines_bf47eea601784059aa52f2929a0c9ada.vmdl", vscripts = "props/skin", skin_range = 11 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(0, 270, 0),  noprecache = true, model = "models/props/harpers_bazaar_magazines_a2d952cd645e4288ab7f80fa2ca9ec13.vmdl", vscripts = "props/skin", skin_range = 11 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 90),  noprecache = true, model = "models/props/brazzersdvd.vmdl", vscripts = "props/skin", skin_range = 313, } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle(0, 0, 0),    noprecache = true, model = "models/props/vinyls_2_1aba987598d54da783e95be32a9388b4.vmdl", vscripts = "props/skin", skin_range = 50 } },
    { "prop_destinations_physics", { _origin = Vector(6.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(0,270,180),  model = "models/barbell3/hentaimag/hentaimag_fbx.vmdl", vscripts = "props/skin", skin_range = 23 } },
    { "prop_destinations_physics", { _origin = Vector(6.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 90, 0),  model = "models/barbell3/hentaimag/hentaimag_fbx.vmdl", vscripts = "props/skin", skin_range = 23 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 270, 0), model = "models/traincar_interior/traincar_clipboard.vmdl", vscripts = "props/skin", skin_range = 2 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.9 0.9 0.9", _angles = QAngle( 0, 0, 90),  model = "models/books/book01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.9 0.9 0.9", _angles = QAngle( 0, 0, 0),   model = "models/ff_models/bibel.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.9 0.9 0.9", _angles = QAngle( 0, 0, 90),  model = "models/books/diary01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle(  0, 0, 0),  model = "models/items/computerbookhighgrade/ground/computerbookhighgrade.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 0),  model = "models/props_furniture/comic_cover.vmdl", vscripts = "props/skin", skin_range = 5 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle(0, 270, 0),  model = "models/props_se/storage/book_1.vmdl", vscripts = "props/skin", skin_range = 15 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle(0, 270, 0),  model = "models/props_se/storage/book_2.vmdl", vscripts = "props/skin", skin_range = 3 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 0),  model = "models/props/alyx_hideout/book_kleiner.vmdl", vscripts = "props/skin", skin_range = 1 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.8 0.8 0.8", _angles = QAngle(  0, 0, 0),  model = "models/sm_books/sm_book01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.6 0.6 0.6", _angles = QAngle(  0, 0, 0),  model = "models/sm_books/sm_book02.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.8 0.8 0.8", _angles = QAngle(  0, 0, 0),  model = "models/sm_books/sm_book03.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.8 0.8 0.8", _angles = QAngle(  0, 0, 0),  model = "models/sm_books/sm_book04.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(0, 270, 0),  model = "models/slasherin/last_year/props/retro-pack/sm_yearbook_01a.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.9 0.9 0.9", _angles = QAngle(0, 270, 0),  model = "models/props_clutter/book_001.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.9 0.9 0.9", _angles = QAngle(0, 270, 0),  model = "models/props_clutter/book_002.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.9 0.9 0.9", _angles = QAngle(0, 270, 0),  model = "models/props_clutter/book_003.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.1 1.1 1.1", _angles = QAngle(0, 270, 0),  model = "models/props_clutter/book_004.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.1 1.1 1.1", _angles = QAngle(0, 270, 0),  model = "models/props_clutter/book_005.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.9 0.9 0.9", _angles = QAngle(0, 270, 0),  model = "models/props_clutter/book_006.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.4 1.4 1.4", _angles = QAngle(0, 270, 0),  model = "models/props_clutter/book_007.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 0, 90),  noprecache = true, model = "models/props_clutter/book_008.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 0, 90),  model = "models/props_clutter/book_009.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 0, 90),  model = "models/props_clutter/book_010.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 0, 90),  model = "models/props_furniture/book001.vmdl", vscripts = "props/skin", skin_range = 5 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 0),  model = "models/themask/sbmp/furniture/bookstuff/sm_spirits_book_01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 0),  model = "models/props/interior_deco/tabletop_notebook.vmdl", skin = 1, vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 0),  model = "models/props_items/notepad001.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 0),  model = "models/props/alyx_hideout/book_cover.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(0, 270, 0),  model = "models/themask/sbmp/furniture/bookstuff/sm_famous_killers_book_01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 0),  model = "models/themask/sbmp/furniture/bookstuff/sm_book_00_sg.vmdl", vscripts = "props/skin", skin_range = 22 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle( 0, 90, 0),  model = "models/props_easteregg/book_aw.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 1.000), scales = "0.3 0.3 0.3", _angles = QAngle(0, 270, 0),  model = "models/pornworld/posterbook_01a.vmdl", vscripts = "props/skin", skin_range = 3 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 0),  model = "models/props/de_aztec/hr_aztec/aztec_archaeology/aztec_archaeology_tools_notebook_01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 0),  noprecache = true, model = "models/props_school/school_smallprops/school_notebook_03.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle(  0, 0, 0),  model = "models/props_school/school_smallprops/school_notebook_04.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(  0,90, 0),  model = "models/themask/sbmp/furniture/officestuff/sm_alexander_notebook_01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 0, -90), noprecache = true, model = "models/themask/sbmp/furniture/bookstuff/base_book_01a.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 0, -90), model = "models/themask/sbmp/furniture/bookstuff/base_book_01b.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 0, -90), model = "models/themask/sbmp/furniture/bookstuff/base_book_02a.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 0, -90), noprecache = true, model = "models/themask/sbmp/furniture/bookstuff/base_book_02b.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 0, -90), noprecache = true, model = "models/themask/sbmp/furniture/bookstuff/base_book_03a.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 0, -90), noprecache = true, model = "models/themask/sbmp/furniture/bookstuff/base_book_03b.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 0, -90), noprecache = true, model = "models/themask/sbmp/furniture/bookstuff/base_book_04a.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 0, -90), noprecache = true, model = "models/themask/sbmp/furniture/bookstuff/base_book_04b.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 0, -90), noprecache = true, model = "models/themask/sbmp/furniture/bookstuff/base_book_05a.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 0, -90), noprecache = true, model = "models/themask/sbmp/furniture/bookstuff/base_book_05b.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 0, -90), model = "models/themask/sbmp/furniture/bookstuff/base_book_06a.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.7 0.7 0.7", _angles = QAngle( 0, 0, -90), noprecache = true, model = "models/themask/sbmp/furniture/bookstuff/base_book_06b.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle( -90, 0, 0), model = "models/themask/sbmp/furniture/bookstuff/sm_bible_01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle( -90, 0, 0), model = "models/themask/sbmp/furniture/bookstuff/obj_book_alice.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.8 0.8 0.8", _angles = QAngle(  0, 0, 0),  model = "models/themask/sbmp/furniture/bookstuff/obj_room_book_02_sg.vmdl", vscripts = "props/skin", skin_range = 1 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "0.8 0.8 0.8", _angles = QAngle(  0, 0, 0),  model = "models/themask/sbmp/furniture/bookstuff/obj_room_book_03_sg.vmdl", vscripts = "props/skin", skin_range = 1 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 0),  noprecache = true, model = "models/themask/sbmp/furniture/bookstuff/s_book_bible.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 0),  model = "models/themask/sbmp/furniture/bookstuff/s_book_black.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 0),  model = "models/themask/sbmp/furniture/bookstuff/s_book_green.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 0),  model = "models/themask/sbmp/furniture/bookstuff/sm_abigail_bible.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(-90, 0, 0),  model = "models/themask/sbmp/furniture/bookstuff/sm_hymn_book_01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.000), scales = "1.0 1.0 1.0", _angles = QAngle(0, 270, 0),  model = "models/themask/sbmp/furniture/bookstuff/sm_tabloid.vmdl" } },
  } },
  objects_dresser_flats = { 0, {
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.11), scales = "0.3 0.3 0.3", _angles = QAngle(0.0, 0.0, 0.0), model = "models/props_interiors/clothing_pile1.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.11), scales = "0.3 0.3 0.3", _angles = QAngle(0.0, 0.0, 0.0), model = "models/props_interiors/clothing_pile2.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.11), scales = "0.3 0.3 0.3", _angles = QAngle(0.0, 0.0, 0.0), model = "models/props_interiors/clothing_pile3.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.11), scales = "0.3 0.3 0.3", _angles = QAngle(0.0, 0.0, 0.0), model = "models/props_interiors/clothing_pile4.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.11), scales = "0.3 0.3 0.3", _angles = QAngle(0.0, 0.0, 0.0), model = "models/props_interiors/clothing_pile5.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.30), scales = "0.4 0.4 0.4", _angles = QAngle(0.0, 0.0, 0.0), model = "models/scenery/misc/clothing/clothing3.vmdl" , solid = 0 } },
  } },
  objects_dresser_flats_alt = { 0, {
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.250), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 270, 0.0),  model = "models/s_prop/gen/furni/clothing/bikini_bra_dmx.vmdl", vscripts = "props/random_color", skin = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.250), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 270, 0.0),  model = "models/s_prop/gen/furni/clothing/bikini_bra_dmx.vmdl", vscripts = "props/random_color", skin = 1 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.250), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 100, 0.0),  model = "models/props/de_nuke/hr_nuke/nuke_clothes/nuke_gloves_individual.vmdl" } },
  } },
  objects_dresser = { 0, {
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.85 0.85 0.85", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props/hotel/towels_stack_small_1.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 1.0), scales = "0.65 0.65 0.65", _angles = QAngle(0.0, 0.0, 0.0),  noprecache = true, model = "models/themask/sbmp/clothing/folded/home_towels_01a.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 1.0), scales = "0.65 0.65 0.65", _angles = QAngle(0.0, 0.0, 0.0),  noprecache = true, model = "models/themask/sbmp/clothing/folded/home_towels_01b.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 1.0), scales = "0.65 0.65 0.65", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/themask/sbmp/clothing/folded/home_towels_01c.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.1), scales = "0.55 0.55 0.55", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clothing/pants-1.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 3.0), scales = "0.55 0.55 0.55", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clothing/pants-2.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 3.0), scales = "0.55 0.55 0.55", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clothing/pants-3.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.55 0.55 0.55", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clothing/shirt_pile-1.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.55 0.55 0.55", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clothing/shirt_pile-2.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.55 0.55 0.55", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clothing/shirt_pile-3.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.55 0.55 0.55", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clothing/shirt_pile-4.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clothing/shirt_pile-5.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.4 0.4 0.4", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clothing/shirt_pile-8.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.35 0.35 0.35", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/themask/scenebuildthemes/furniture/clothes/sm_clothes_pile_joy_01_fbx.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.35 0.35 0.35", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/themask/scenebuildthemes/furniture/clothes/sm_clothes_pile_01_fbx.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.8 0.8 0.8", _angles = QAngle( 0.0, 0.0, 0.0),  model = "models/themask/sbmp/clothing/folded/sm_linen_pile_01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.6 0.6 0.6", _angles = QAngle( 0.0, 0.0, 0.0),  model = "models/themask/sbmp/furniture/laundry/clothes_pile.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  noprecache = true, model = "models/props_alien/clothpile01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  noprecache = true, model = "models/props_alien/clothpile02.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_alien/clothpile05.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_alien/clothpile06.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.7 0.7 0.7", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_alien/clothpile07.vmdl" } },
  } },
  objects_dresser_small = { 0, {
    {     "prop_physics_override", { _origin = Vector(0, 0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(90, 0, 0),    noprecache = true, model = "models/props/low_poly_gold_coin_7a40d686492545d1a6f6bd0c487f1cb9.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "0.2 0.2 0.2", _angles = QAngle( 90, 0.0, 0.0),  noprecache = true, model = "models/nt/props_street/sign_sex.vmdl", vscripts = "props/skin_with_pickup", skin_range = 15 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0.0, 0.0, 0.0), noprecache = true, model = "models/props/vogue_magazines_bf47eea601784059aa52f2929a0c9ada.vmdl", vscripts = "props/skin", skin_range = 11 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0.0, 0.0, 0.0), noprecache = true, model = "models/props/harpers_bazaar_magazines_a2d952cd645e4288ab7f80fa2ca9ec13.vmdl", vscripts = "props/skin", skin_range = 11 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle( 0.0, 0.0, 90),  noprecache = true, model = "models/props/brazzersdvd.vmdl", vscripts = "props/skin", skin_range = 313, } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0.0, 0.0),  noprecache = true, model = "models/themask/sbmp/medic/tools_surgery/sm_mu_glove_box_01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(-90, 0.0, 0.0),  model = "models/pornworld/pw_doll_01.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(-90, 0.0, 0.0),  model = "models/pornworld/pw_doll_02.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(-90, 0.0, 0.0),  model = "models/player/holiday/facemasks/facemask_zombie_fortune_plastic_dmx.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(-90, 0.0, 0.0),  model = "models/player/holiday/facemasks/facemask_porcelain_doll_kabuki_dmx.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(-90, 0.0, 0.0),  model = "models/player/holiday/facemasks/facemask_devil_plastic_dmx.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "0.9 0.9 0.9", _angles = QAngle(-90, 0.0, 0.0),  model = "models/player/holiday/facemasks/porcelain_doll_dmx.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0),  model = "models/env/decor/mrx_masks/mask_b.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90, 0.0, 0.0),  model = "models/characters/bolt_on/masks/mask_tiger_dmx.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/scenery/misc/clothing/condoms1.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/scenery/misc/clothing/condoms2.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/themask/sbmp/clothing/accessories/s_cemetery_jewelry_a.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/themask/sbmp/clothing/accessories/s_cemetery_jewelry_b.vmdl" } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.100), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0),  noprecache = true, model = "models/themask/scenebuildthemes/furniture/clothes/sm_clothes_dirty_03.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 1.125), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  noprecache = true, model = "models/props/vinyls_2_1aba987598d54da783e95be32a9388b4.vmdl", vscripts = "props/skin", skin_range = 50 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 1.125), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 270, 180),  model = "models/barbell3/hentaimag/hentaimag_fbx.vmdl", vscripts = "props/skin", skin_range = 23 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 1.125), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 90.0, 0.0), model = "models/barbell3/hentaimag/hentaimag_fbx.vmdl", vscripts = "props/skin", skin_range = 23 } },
  } },
  objects_dresser_large = { 0, {
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.7 0.7 0.7", _angles = QAngle(0.0, 0.0, 0.0),    model = "models/props_alien/clothpile08.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.7 0.7 0.7", _angles = QAngle(0.0, 0.0, 0.0),    model = "models/props_alien/clothpile09.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.7 0.7 0.7", _angles = QAngle(0.0, 0.0, 0.0),    model = "models/props_alien/clothpile10.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0),    model = "models/props_alien/clothpile11.vmdl" } },
  } },
  objects_paper = { 0, {
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_a.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_b.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_c.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_d.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_e.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_f.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_g.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_h.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_i.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_j.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_k.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_l.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_m.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_n.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_o.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_p.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_q.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_r.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_s.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(-90.0, 0.0, 0.0),  model = "models/polyhaven/postcard_set_01_t.vmdl" } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.2 1.2 1.2", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/items/linedpaper/ground/linedpaper.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/traincar_interior/traincar_paper_4.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/traincar_interior/traincar_paper.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.0 1.0 1.0", _angles = QAngle(-90, 90.0, 0.0), model = "models/props_items/polaroid_01.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.0 1.0 1.0", _angles = QAngle(-90, 90.0, 0.0), model = "models/props_items/polaroid_02.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.0 1.0 1.0", _angles = QAngle(-90, 90.0, 0.0), model = "models/props_items/polaroid_03.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.0 1.0 1.0", _angles = QAngle(-90, 90.0, 0.0), model = "models/props_items/polaroid_04.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.0 1.0 1.0", _angles = QAngle(-90, 90.0, 0.0), model = "models/props_items/polaroid_05.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/scenery/misc/paper/paper1.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/scenery/misc/paper/paper2.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/scenery/misc/paper/paper3.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/scenery/misc/paper/paper4.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_school/school_smallprops/paper_sheet.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.2 1.2 1.2", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/items/bailbond/ground/bailbond.vmdl", solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.2 1.2 1.2", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_parable/papers_7.vmdl", vscripts = "props/skin", skin_range = 5, solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_parable/papers_2_hahaha_this_is_fun.vmdl", vscripts = "props/skin", skin_range = 6, solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_items/paper_pile001.vmdl", vscripts = "props/skin", skin_range = 2, solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_corruption/papers_001.vmdl", vscripts = "props/skin", skin_range = 5, solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "0.5 0.5 0.5", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_office/paper_a2.vmdl", vscripts = "props/skin", skin_range = 30, solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_corruption/paper_a4_001.vmdl", vscripts = "props/skin", skin_range = 30, solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_office/paper_a4.vmdl", vscripts = "props/skin", skin_range = 14, solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clutter/note_003.vmdl", vscripts = "props/skin", skin_range = 10, solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props/story/maintenance/est_note_maintenance_1.vmdl", vscripts = "props/skin", skin_range = 7, solid = 0 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.075), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props/story/maintenance/est_note_maintenance_2.vmdl", vscripts = "props/skin", skin_range = 7, solid = 0 } },
  } },
  objects_bureau_clothes = { 0, {
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, -43.5), scales = "0.5 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clothing/shirt_line-1.vmdl",  vscripts = "props/skin", skin_range = 1 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, -43.5), scales = "0.5 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clothing/shirt_line-1b.vmdl", vscripts = "props/skin", skin_range = 1 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, -43.5), scales = "0.5 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clothing/shirt_line-1c.vmdl", vscripts = "props/skin", skin_range = 1 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, -43.5), scales = "0.5 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clothing/shirt_line-1d.vmdl", vscripts = "props/skin", skin_range = 1 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, -48.5), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clothing/shirt_line-1h.vmdl", vscripts = "props/skin", skin_range = 1 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, -43.5), scales = "0.5 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clothing/shirt_line-1e.vmdl", vscripts = "props/skin", skin_range = 1 } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, -43.0), scales = "0.5 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0),  model = "models/props_clothing/shirt_line-1f.vmdl", vscripts = "props/skin", skin_range = 1 } },
  } },
  objects_floor = { 0, {
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_garbages/litter/pile_circular-1.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_garbages/litter/pile_circular-1b.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_garbages/litter/pile_circular-1c.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_garbages/litter/pile_circular-2.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_garbages/litter/pile_circular-2b.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_garbages/litter/pile_circular-2c.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_garbages/litter/pile_circular-3.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", noprecache = true, model = "models/props_school/paperpile_a.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_school/paperpile_b.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_school/paperpile_c.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "0.5 0.5 0.5", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_parable/papers_mess.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_parable/papers_1.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_parable/papers_2.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_parable/papers_2_hiding_secrets.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_parable/papers_2_once_you_go_secret.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_parable/papers_2_william_is_great.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_parable/papers_2_you_never_go_becret.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_parable/papers_3.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_parable/papers_4.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/props_parable/papers_5.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/env/misc/letterpilea/letterpilea.vmdl", solid = 0, zero_angle = true } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.200), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0), targetname = "rug_prop", model = "models/env/misc/letterpileb/letterpileb.vmdl", solid = 0, zero_angle = true } },
  } },
  objects_remote = { 0, {
    {    "prop_destinations_tool", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  noprecache = true, model = "models/themask/sbmp/furniture/electronics/tv_remote_obj.vmdl", vscripts = "tools/clicker", change = 0.5 } },
    {    "prop_destinations_tool", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  noprecache = true, model = "models/props_tse/props_furniture/remote01_obj.vmdl", vscripts = "tools/clicker", change = 0.5 } },
    {    "prop_destinations_tool", { _origin = Vector(0.0, 0.0, 0.125), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0),  noprecache = true, model = "models/props_items/tvremote001_fbx.vmdl", vscripts = "tools/clicker", change = 0.5 } },
  } },
  objects_futon_1 = { 0, {
    { "prop_destinations_physics", { _origin = Vector(-2.0, -24.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(8.0, 270.0, 0), model = "models/props_furniture/pillow001.vmdl", chance = 0.65 } },
    { "prop_destinations_physics", { _origin = Vector( 2.0, -24.0, 0.0), scales = "0.9 0.9 0.9", _angles = QAngle(8.0, 270.0, 0), model = "models/props_items/pillow001.vmdl", chance = 0.65 } },
  } },
  objects_futon_2 = { 0, {
    { "prop_destinations_physics", { _origin = Vector( -2.0, -30.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(8.0, 270.0, 0), model = "models/props/de_mirage/pillow_b.vmdl", chance = 0.35 } },
    { "prop_destinations_physics", { _origin = Vector(  2.0, -30.0, 0.0), scales = "0.5 0.5 0.5", _angles = QAngle(8.0, 270.0, 0), model = "models/props_map_structures/villa/villa_pillow_01.vmdl", vscripts = "props/skin", skin_range = 2, chance = 0.35 } },
  } },
  objects_futon_3 = { 0, {
    { "prop_destinations_physics", { _origin = Vector(-2.0, -36.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(8.0, 270.0, 0), model = "models/themask/sbmp/furniture/cushions/gnb_pillow_02.vmdl", chance = 0.75 } },
    { "prop_destinations_physics", { _origin = Vector( 2.0, -36.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(8.0, 270.0, 0), model = "models/themask/sbmp/furniture/cushions/gs_twoface_cameo_pillow.vmdl", chance = 0.333 } },
  } },
  objects_futon_4 = { 0, {
    { "prop_destinations_physics", { _origin = Vector( -2.0, 34.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(8.0, 270.0, 0), model = "models/props/de_mirage/pillow_a.vmdl", chance = 0.65 } },
    { "prop_destinations_physics", { _origin = Vector(  2.0, 34.0, 0.0), scales = "0.8 0.8 0.8", _angles = QAngle(8.0, 270.0, 0), model = "models/props/de_mirage/pillow_c.vmdl", chance = 0.65, vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector( -2.0, 34.0, 0.0), scales = "0.7 0.7 0.7", _angles = QAngle(8.0, 270.0, 0), model = "models/themask/sbmp/furniture/cushions/pillow_deco_a.vmdl", vscripts = "props/random_color", chance = 0.65 } },
    { "prop_destinations_physics", { _origin = Vector(  2.0, 34.0, 0.0), scales = "0.8 0.8 0.8", _angles = QAngle(8.0, 270.0, 0), model = "models/props/de_boathouse/pillow02.vmdl", chance = 0.65 } },
    { "prop_destinations_physics", { _origin = Vector( -2.0, 34.0, 0.0), scales = "0.9 0.9 0.9", _angles = QAngle(8.0, 270.0, 0), model = "models/props/de_boathouse/pillow01.vmdl", chance = 0.65 } },
    { "prop_destinations_physics", { _origin = Vector( -2.0, 34.0, 0.0), scales = "0.5 0.5 0.5", _angles = QAngle(0.0, 90, 0.0),  model = "models/cityhall/love_bed_pillow.vmdl", chance = 0.420 } },
  } },
  objects_futon_5 = { 0, {
    { "prop_destinations_physics", { _origin = Vector(  0.0, 0.0, 0.0), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 270, 0.0),  model = "models/barbell3/bodypillow/bodypillow_fbx.vmdl", vscripts = "props/skin", skin_range = 9, chance = 0.2 } },
  } },
  objects_mattress_1 = { 0, {
    { "prop_destinations_physics", { _origin = Vector(-2.0, 34.0, 0.0), scales = "0.5 0.5 0.5", _angles = QAngle(0.0, 90, 0.0),   model = "models/cityhall/love_bed_pillow.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector( 2.0, 34.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 270, 0.0),  noprecache = true, model = "models/props_clutter/pillow.vmdl", vscripts = "props/skin props/random_color", skin_range = 1 } },
    { "prop_destinations_physics", { _origin = Vector(-2.0, 34.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 270, 0.0),  model = "models/props_furniture/pillow002.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector( 2.0, 34.0, 0.0), scales = "1.2 1.2 1.2", _angles = QAngle(0.0, 270, 0.0),  model = "models/barbell3/pillow/pillowhd_fbx.vmdl", vscripts = "props/skin", skin_range = 9 } },
  } },
  objects_mattress_2 = { 0, {
    { "prop_destinations_physics", { _origin = Vector(-12.0, -20.0, 0.0), _scales = "1.0 1.0 1.0", _angles = QAngle(0, 0 ,0),     model = "models/polyhaven/throw_pillows_01_a.vmdl", chance = 0.2 } },
    { "prop_destinations_physics", { _origin = Vector(-12.0, -20.0, 0.0), _scales = "1.0 1.0 1.0", _angles = QAngle(0, 0 ,0),     model = "models/polyhaven/throw_pillows_01_b.vmdl", chance = 0.2 } },
    { "prop_destinations_physics", { _origin = Vector(-12.0, -20.0, 0.0), _scales = "1.0 1.0 1.0", _angles = QAngle(0, 0 ,0),     model = "models/props_items/pillow002.vmdl", vscripts = "props/random_color" } },
  } },
  objects_mattress_3 = { 0, {
    { "prop_destinations_physics", { _origin = Vector(-12.0, 18.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(8.0, 270.0, 0), model = "models/props_furniture/pillow001.vmdl", chance = 0.5 } },
    { "prop_destinations_physics", { _origin = Vector(-12.0, 18.0, 0.0), scales = "0.9 0.9 0.9", _angles = QAngle(8.0, 270.0, 0), model = "models/props_items/pillow001.vmdl", chance = 0.5 } },
  } },
  objects_mattress_4 = { 0, {
    { "prop_destinations_physics", { _origin = Vector(16.0, -18.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(8.0, 270.0, 0), model = "models/props/de_mirage/pillow_b.vmdl", chance = 0.3 } },
    { "prop_destinations_physics", { _origin = Vector(16.0, -18.0, 0.0), scales = "0.5 0.5 0.5", _angles = QAngle(8.0, 270.0, 0), model = "models/props_map_structures/villa/villa_pillow_01.vmdl", vscripts = "props/skin", skin_range = 2, chance = 0.3 } },
  } },
  objects_mattress_5 = { 0, {
    { "prop_destinations_physics", { _origin = Vector(8.0   -24.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(8.0, 270.0, 0), model = "models/themask/sbmp/furniture/cushions/gnb_pillow_02.vmdl", chance = 0.5 } },
    { "prop_destinations_physics", { _origin = Vector(-8.0, -24.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(8.0, 0.0, 0.0), model = "models/themask/sbmp/furniture/cushions/gs_twoface_cameo_pillow.vmdl", chance = 0.333 } },
  } },
  objects_mattress_6 = { 0, {
    { "prop_destinations_physics", { _origin = Vector(-6.0,-36.0, 0), scales = "1.0 1.0 1.0", _angles = QAngle(8.0, 270.0, 0),    model = "models/props/de_mirage/pillow_a.vmdl", chance = 0.5 } },
    { "prop_destinations_physics", { _origin = Vector(6.0, -36.0, 0), scales = "0.8 0.8 0.8", _angles = QAngle(8.0, 270.0, 0),    model = "models/props/de_mirage/pillow_c.vmdl", chance = 0.5, vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(-6.0,-36.0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(8.0, 270.0, 0),    model = "models/themask/sbmp/furniture/cushions/pillow_deco_a.vmdl", vscripts = "props/random_color", chance = 0.5 } },
    { "prop_destinations_physics", { _origin = Vector(6.0, -36.0, 0), scales = "0.8 0.8 0.8", _angles = QAngle(8.0, 270.0, 0),    model = "models/props/de_boathouse/pillow02.vmdl", chance = 0.5 } },
    { "prop_destinations_physics", { _origin = Vector(-6.0,-36.0, 0), scales = "0.9 0.9 0.9", _angles = QAngle(8.0, 270.0, 0),    model = "models/props/de_boathouse/pillow01.vmdl", chance = 0.5 } },
  } },
  objects_tree = { 0, {
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.25 0.25 0.25",       _angles = QAngle(0, 0, 0), model = "models/props_foliage/maple_tree_medium001.vmdl" } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.4 0.4 0.4",          _angles = QAngle(0, 0, 0), noprecache = true, model = "models/props_foliage/mall_small_palm01.vmdl" } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.5875 0.5875 0.5875", _angles = QAngle(0, 0, 0), model = "models/props_foliage/fir_tree_young_01.vmdl" } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.75 0.75 0.75",       _angles = QAngle(0, 0, 0), model = "models/props_foliage/fir_tree_young_02.vmdl" } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.425 0.425 0.425",    _angles = QAngle(0, 0, 0), model = "models/props_foliage/fir_tree_young_03.vmdl" } },
    {              "prop_dynamic", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.2 0.2 0.2",          _angles = QAngle(0, 0, 0), model = "models/props_foliage/tree_deciduous_04.vmdl" } },
  } },
  objects_mailbox = { 0, {
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "1.0 1.0 1.0", _angles = QAngle(  0, 0, 0), noprecache = true, model = "models/props/brazzersdvd.vmdl", vscripts = "props/skin", skin_range = 313 } },
  } },
  objects_bathroom = { 0, {
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 0.0, 0.0), model = "models/siege/prop_shampoo0.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.7 0.7 0.7", _angles = QAngle(0.0, 0.0, 0.0), model = "models/siege/prop_shampoo1.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "2.0 2.0 2.0", _angles = QAngle(0.0, 0.0, 0.0), model = "models/props_items/soap_bar.vmdl", } },
    {    "prop_destinations_tool", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/props/dishwasher_soap_bottle.vmdl", color = "175 0 0", vscripts = "tools/dishsoap props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "2.0 2.0 2.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/props/masseffectlubedirtyazure.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "2.0 2.0 2.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/props/masseffectlubedivinenectar.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "2.0 2.0 2.0", _angles = QAngle(0.0, 0.0, 321), noprecache = true, model = "models/props/masseffectlubemirandalawson.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "2.0 2.0 2.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/props/masseffectlubequarian.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "2.0 2.0 2.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/props/masseffectlubesweetstrawberry.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/props/interior_deco/tabletop_hairbrush.vmdl", } },
    {    "prop_destinations_tool", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0), model = "models/props_items/shampoo001_dmx.vmdl", vscripts = "tools/handsoap props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 3.5), scales = "0.7 0.7 0.7", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/props_se/storage/jar02b.vmdl", } },
    {    "prop_destinations_tool", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/themask/sbmp/furniture/bathroom/sm_soap_dispenser_bathroom_01_dmx.vmdl", vscripts = "tools/handsoap props/random_color" } },
    {    "prop_destinations_tool", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/props_interiors/soap_dispenser_dmx.vmdl", vscripts = "tools/handsoap props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/themask/sbmp/furniture/bathroom/bottle_1.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/themask/sbmp/furniture/bathroom/bottle_2.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/themask/sbmp/furniture/bathroom/bottle_3.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/themask/sbmp/furniture/bathroom/bottle_4.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/themask/sbmp/furniture/bathroom/bottle_5.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/themask/sbmp/furniture/bathroom/bubblebath_mesh_sg.vmdl", vscripts = "props/skin", skin_range = 3 } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0), model = "models/scenery/misc/tsengs/bottle1.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0), model = "models/scenery/misc/tsengs/bottle2.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0), model = "models/scenery/misc/tsengs/bottle3.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 2.0), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 270, 90),  model = "models/scenery/misc/tsengs/box1.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 2.0), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 270, 90),  model = "models/scenery/misc/tsengs/box2.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 2.0), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 270, 90),  model = "models/scenery/misc/tsengs/box3.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 2.0), scales = "0.9 0.9 0.9", _angles = QAngle(0.0, 270, 90),  model = "models/scenery/misc/tsengs/box4.vmdl" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 3.0), scales = "0.5 0.5 0.5", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/themask/sbmp/medic/medicine/pill_bottle_3p.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.6 0.6 0.6", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/themask/sbmp/medic/medicine/dlc_vprasalghul_hospital_pharmacy_pillbottle02.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/themask/sbmp/groceries/milk_baby/babybottleclean01milk.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/props/zoo/medicine_bottle.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.8 0.8 0.8", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/polyhaven/plastic_bottle_gallon.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/themask/sbmp/medic/tools_surgery/sm_mu_glove_box_01.vmdl", } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "1.0 1.0 1.0", _angles = QAngle(0.0, 0.0, 0.0), noprecache = true, model = "models/props/interior_deco/interior_bathroom_soap_001a.vmdl", vscripts = "props/random_color" } },
    { "prop_destinations_physics", { _origin = Vector(0.0, 0.0, 0.0), scales = "0.7 0.7 0.7", _angles = QAngle(0.0, 0.0, 0.0), model = "models/scenery/misc/clothing/lubricant.vmdl" } },
  } },
  objects_dragon = { 0, {
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_axel.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_blaze.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_bruiser.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_chance.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_clayton.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_crackers.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_david.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_demagorgon.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_demon.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_dexter.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_diego.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_echo.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_elden.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_fenrir.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_flint.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_glyph.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_gunner.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_hanns.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_hunter.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_ika.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_kage.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_kelvin.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_kippy.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_nocturne.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_nova.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_nox.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_pearce.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_pretzal.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_razor.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_rex.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_ridley.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_scorn.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_sleipnir.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_stan.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_terra.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_trent.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_vasu.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_virgil.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_xar.vmdl", chance = 0.1 } },
    { "prop_destinations_physics", { _origin = Vector(0, 0, 0), scales = "0.7 0.7 0.7", _angles = QAngle(-90, 0.0, 0.0), model = "models/LordAardvark/SFM/props/toys/fbx/baddragon_xerxes.vmdl", chance = 0.1 } },
  } },
}
function Precache(context)
  for k1,v1 in pairs(objects) do
   if not v1[3] then
     for k,v in pairs(v1[2]) do
       if not v[2]["noprecache"] or GetMapName() ~= 'maps/byteframe14' then
         PrecacheModel(v[2]["model"], context)
       end
     end
   end
  end
  PrecacheModel("models/props_interiors/clotheshanger01.vmdl", context)
  PrecacheModel("models/props/de_nuke/hr_nuke/nuke_clothes/nuke_tank_top.vmdl", context)
  PrecacheModel("models/props/de_nuke/hr_nuke/nuke_clothes/nuke_overall.vmdl", context)
  PrecacheModel("models/props/interior_furniture/interior_mattress_001b_single.vmdl", context)
  PrecacheModel("models/props/interior_furniture/interior_mattress_cover_001_single.vmdl", context)
  PrecacheModel("models/props/interior_furniture/interior_bed_sheet_001_single.vmdl", context)
  PrecacheModel("models/props_office/blinds_001_20_b.vmdl", context)
  PrecacheModel("models/props_office/blinds_001_44_b.vmdl", context)
  PrecacheModel("models/dormroom_bed_bottom.vmdl", context)
end
function SpawnAtTargets(E, g, z, x, y, q)
  x = x or 0.0
  y = y or 0.0
  z = z or 0.0
  q = q or 1
  s = s or false
  for k,v in pairs(Entities:FindAllByName("*"..g.."*")) do
    local t = v:GetName()
    for r=1,q do
      local e = pick(E)
      if not e[2]["chance"] or RandomFloat(0.0, 1.0) < e[2]["chance"] then
        if e[2]["scale_flex"] then
          local scale = tonumber(string.sub(e[2]["_scales"], 1, 3)) + RandomFloat(0.0, tonumber(e[2]["scale_flex"]))
          e[2]["scales"] = scale.." "..scale.." "..scale
        end
        e[2]["angles"] = v:GetAngles() + e[2]["_angles"]
        if e[2]["zero_angle"] then
          e[2]["angles"] = Vector(0.0, RandomFloat(0.0, 360.0), 0.0)
        end
        e[2]["origin"] = (v:GetAbsOrigin() + Vector(x, y, z)) + e[2]["_origin"]
        if e[1] == "prop_destinations_physics" then
          e[2]["spawnflags#1"] = "1"
          e[2]["minhealthdmg"] = "999"
        elseif e[1] == "prop_dynamic" then
          if e[2]["vscripts"] then
            e[2]["vscripts"] = e[2]["vscripts"].." props/parent"
          else
            e[2]["vscripts"] = "props/parent"
          end
          e[2]["solid"] = "0"
        end
        if e[2]["vscripts"] and string.find(e[2]["vscripts"], "random_color") then
          local color = pick(colors[RandomInt(1,2)])
          e[2]["color"] = color[1].." "..color[2].." "..color[3]
        end
        _e = SpawnEntityFromTableSynchronous(e[1], e[2])
        if e[2]["skin_range"] then
          _e:Attribute_SetIntValue('skin_range', e[2]["skin_range"])
        end
      end
    end
  end
end
function Activate()
  SpawnAtTargets(objects["objects_tree"], "object_spawner_tree")
  SpawnAtTargets(objects["objects_bottle"], "object_spawner_trash", 16.0, nil, nil, 3)
  SpawnAtTargets(objects["objects_futon_1"], "object_spawner_mattress", -24.0)
  SpawnAtTargets(objects["objects_futon_2"], "object_spawner_mattress", -16.0)
  SpawnAtTargets(objects["objects_futon_3"], "object_spawner_mattress", -12.0)
  SpawnAtTargets(objects["objects_futon_4"], "object_spawner_mattress", -8.0)
  SpawnAtTargets(objects["objects_futon_5"], "object_spawner_mattress", -32.0)
  SpawnAtTargets(objects["objects_futon_5"], "object_spawner_mattress", 4.0)
  SpawnAtTargets(objects["objects_mattress_1"], "object_spawner_mattress", 8.0)
  SpawnAtTargets(objects["objects_mattress_2"], "object_spawner_mattress", 12.0)
  SpawnAtTargets(objects["objects_mattress_3"], "object_spawner_mattress", 16.0)
  SpawnAtTargets(objects["objects_mattress_4"], "object_spawner_mattress", 20.0)
  SpawnAtTargets(objects["objects_mattress_5"], "object_spawner_mattress", 24.0)
  SpawnAtTargets(objects["objects_mattress_6"], "object_spawner_mattress", 28.0)
  SpawnAtTargets(objects["objects_remote"], "object_spawner_remote", nil, RandomFloat(-16.0, 16.0), RandomFloat(-16.0, 16.0), nil, true)
  SpawnAtTargets(objects["objects1"], "object_spawner_1")
  SpawnAtTargets(objects["objects2"], "object_spawner_2")
  SpawnAtTargets(objects["objects_bottle"], "object_spawner_bottle")
  SpawnAtTargets(objects["objects_roll"], "object_spawner_roll")
  SpawnAtTargets(objects["objects_chip"], "object_spawner_chip")
  SpawnAtTargets(objects["objects_book"], "object_spawner_book")
  SpawnAtTargets(objects["objects_dragon"], "object_spawner_dragon")
  SpawnAtTargets(objects["objects_floor"], "dormroom_spotlight", -121.30, RandomFloat(-16.0, 16.0), RandomFloat(-16.0, 16.0))
  SpawnAtTargets(objects["objects_book"], "desk_drawer_1_func", 2.0)
  SpawnAtTargets(objects["objects_paper"], "desk_drawer_1_func")
  SpawnAtTargets(objects["objects_book"], "desk_drawer_2_func", 2.0)
  SpawnAtTargets(objects["objects_paper"], "desk_drawer_2_func")
  SpawnAtTargets(objects["objects1"], "object_spawner_desk2",  1.5)
  SpawnAtTargets(objects["objects2"], "object_spawner_desk2",  3.0)
  SpawnAtTargets(objects["objects_roll"], "object_spawner_desk2",  3.0, RandomFloat(-4.0, 4.0), RandomFloat(-4.0, 4.0))
  SpawnAtTargets(objects["objects_chip"], "object_spawner_desk2",  4.0)
  SpawnAtTargets(objects["objects_book"], "object_spawner_desk2",  6.0)
  SpawnAtTargets(objects["objects_bathroom"], "object_spawner_bathroom", 0.0)
  for k,v in pairs(Entities:FindAllByName("*object_spawner_mailbox*")) do
    SpawnAtTargets(objects["objects_mailbox"], v:GetName(), nil, RandomFloat(-4, 4))
  end
  for k,v in pairs(Entities:FindAllByName("*object_spawner_bureau*")) do
    local origin = v:GetAbsOrigin()
    local angles = v:GetAngles()
    local forward = 'y'
    if abs(v:GetForwardVector().x) == 1 then
      forward = 'x'
    end
    if RandomInt(0,3) == 3 then
      if RandomInt(0,4) == 4 then
        local e = {
          model = "models/props/de_nuke/hr_nuke/nuke_clothes/nuke_tank_top.vmdl",
          origin = v:GetAbsOrigin(),
          angles = Vector(0, -90, 0),
          scales = "0.9375 0.9375 0.9375",
          vscripts = "props/random_color" }
        if forward =='y' then
          e["angles"] = Vector(0, -180, 0)
        end
        e.origin[forward] = origin[forward]-10
        SpawnEntityFromTableSynchronous("prop_dynamic", e)
        e["model"] = "models/props/de_nuke/hr_nuke/nuke_clothes/nuke_overall.vmdl"
        e["scales"] = "0.75 0.75 0.75"
        e.origin[forward] = origin[forward]+10
        SpawnEntityFromTableSynchronous("prop_dynamic", e)
      else
        local e = {
          model = "models/props_interiors/clotheshanger01.vmdl",
          scales = "0.5655 0.5655 0.5655",
          angles = angles,
          origin = v:GetAbsOrigin() }
        for r=1,4 do
          if RandomInt(0,1) == 1 then
            e.origin[forward] = origin[forward]+(RandomFloat(0.5, 3.0)+(3.0*r))
            SpawnEntityFromTableSynchronous("prop_dynamic", e)
          end
        end
        for r=1,4 do
          if RandomInt(0,1) == 1 then
            e.origin[forward] = origin[forward]-(RandomFloat(0.5, 3.0)+(3.0*r))
            SpawnEntityFromTableSynchronous("prop_dynamic", e)
          end
        end
      end
    else
      SpawnAtTargets(objects["objects_bureau_clothes"], v:GetName())
    end
  end
  for k,v in pairs(Entities:FindAllByName("*object_spawner_dresser*")) do
    SpawnAtTargets(objects["objects_dresser_flats"], v:GetName())
    if RandomInt(0,8) == 1 then
      SpawnAtTargets(objects["objects_dresser_flats_alt"], v:GetName())
    else
      SpawnAtTargets(objects["objects_dresser_small"], v:GetName(), 1.0, -6.0)
      SpawnAtTargets(objects["objects_dresser_small"], v:GetName(), 1.0, 6.0)
    end
    for r=1,4 do
      local z = 9.63
      if r > 1 then
        z = 9.75
      end
      SpawnAtTargets(objects["objects_dresser_flats"], v:GetName(), -(r*z))
      if RandomInt(0,3) == 1 then
        SpawnAtTargets(objects["objects_dresser_large"], v:GetName(), -(r*z))
      else
        SpawnAtTargets(objects["objects_dresser"], v:GetName(), -(r*z), -6.0)
        SpawnAtTargets(objects["objects_dresser"], v:GetName(), -(r*z), 6.0)
      end
    end
  end
  for k,v in pairs(Entities:FindAllByClassname("func_button")) do
    if RandomInt(0,6) == 0 and v:Attribute_GetIntValue("noauto", -1) ~= 1 then
      DoEntFireByInstanceHandle(v, "Press", nil, 5.0, self, self)
    end
  end
  for k,v in pairs(Entities:FindAllByName("*window_*")) do
    local origin = v:GetLocalOrigin()
    v:SetLocalOrigin(Vector(origin.x, origin.y, origin.z+RandomInt(3,14)))
  end
  local blinds = Entities:FindAllByModel("models/props_office/blinds_001_20.vmdl")
  for k,v in ipairs(Entities:FindAllByModel("models/props_office/blinds_001_44.vmdl")) do
    table.insert(blinds, v)
  end
  for k,v in pairs(blinds) do
    if RandomInt(0,1) == 1 then
      if v:GetModelName() == "models/props_office/blinds_001_20.vmdl" then
        v:SetModel("models/props_office/blinds_001_20_b.vmdl")
      else
        v:SetModel("models/props_office/blinds_001_44_b.vmdl")
      end
      local origin = v:GetLocalOrigin()
      v:SetLocalOrigin(Vector(origin.x, origin.y, origin.z-15.02))
    end
  end
  for k,v in ipairs(Entities:FindAllByModel("models/props/interior_furniture/interior_mattress_001_single.vmdl")) do
    local i = RandomInt(0,3)
    if i == 1 then
      v:SetModel("models/props/interior_furniture/interior_mattress_001b_single.vmdl")
      v:SetSkin(RandomInt(0,4))
      local origin = v:GetLocalOrigin()
      v:SetLocalOrigin(Vector(origin.x, origin.y, origin.z-1.5))
    elseif i == 2 then
      v:SetModel("models/props/interior_furniture/interior_mattress_cover_001_single.vmdl")
      v:SetSkin(RandomInt(0,1))
    elseif i == 3 then
      v:SetModel("models/props/interior_furniture/interior_bed_sheet_001_single.vmdl")
      v:SetSkin(RandomInt(0,7))
    else
      v:SetSkin(RandomInt(0,4))
    end
  end
  increment_youtube_index()
  CustomGameEventManager:RegisterListener("increment_youtube_index", increment_youtube_index)
end
local youtube_ids = {
  "122279","122548","122549","122553","122554","122614",
  "122557","122558","122559","122561","122610","122611","122613",
  "122615","122616","122617","122618","122655","124123", }
local youtube_videoid_index = #youtube_ids
function increment_youtube_index()
  if youtube_videoid_index == #youtube_ids then
    youtube_videoid_index = 1
    youtube_ids = shuffle(youtube_ids)
  else
    youtube_videoid_index = youtube_videoid_index + 1
  end
  CustomNetTables:SetTableValue("youtube_videoid", "key_1", { youtube_ids[youtube_videoid_index] })
end