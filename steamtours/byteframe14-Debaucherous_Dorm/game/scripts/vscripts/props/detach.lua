local detached = false
function OnPickedUp(self, hand)
  if not detached then
    detached = true
    if thisEntity:Attribute_GetIntValue("detach_type", 0) == 1 then
      EmitSoundOn('PhysImpact_Prop.Metal_Misc_Small_byteframe14', thisEntity)
    elseif thisEntity:Attribute_GetIntValue("detach_type", 0) == 2 then
      EmitSoundOn('PhysImpact_Prop.Paper_Newspaper_byteframe14', thisEntity)
    else
      EmitSoundOn('PhysImpact_Prop.Wood_Plank_byteframe14', thisEntity)
    end
  end
end