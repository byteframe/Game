local skins = nil
local sounds = {
  "bot_beep",
  "CombineUpgradeStation.BeepLow",
  "Keycard.Success",
  "Keycard.Fail",
  "meeseeks_box_button",
  "Elevator_combine.Button_Call",
  "multitool_click",
  "XenInfest.Click",
  "Anim_CombineSlider.End",
  "Anim_CombineSlider.Tick",
  "HealthStation.MovementClicks", }
function ChangeSkin(playsound)
  if not skins then
    skins = { 0, {} }
    for i=1,thisEntity:Attribute_GetIntValue("skin_range", -1)+1 do
      skins[2][i]=i-1
    end
  end
  thisEntity:SetSkin(pick(skins))
  if playsound == true then
    if string.find(thisEntity:GetModelName(), 'television') ~= nil or string.find(thisEntity:GetModelName(), 'tv') ~= nil then
      EmitSoundOn("ButtonCombine.Fail_byteframe14", thisEntity)
     else
      EmitSoundOn(sounds[RandomInt(1, #sounds)], thisEntity)
    end
  end
end
function Activate() thisEntity:SetThink("ChangeSkin", self, 0.1) end
function OnTakeDamage(damageTable) ChangeSkin(true) end
function OnPickedUp(self, hand) ChangeSkin(true) end