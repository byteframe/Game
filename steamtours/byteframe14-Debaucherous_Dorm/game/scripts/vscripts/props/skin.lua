function ChangeSkin() thisEntity:SetSkin(RandomInt(0, thisEntity:Attribute_GetIntValue("skin_range", 0))) end
function Activate() thisEntity:SetThink("ChangeSkin", self, 0.1) end