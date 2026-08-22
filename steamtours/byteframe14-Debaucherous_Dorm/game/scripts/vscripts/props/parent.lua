function Parent()
  local classname = 'func_button'
  if thisEntity:Attribute_GetIntValue("parent_type", 2) == 1 then
    classname = 'func_door_rotating'
  end
  local parent = Entities:FindByClassnameNearest(classname, thisEntity:GetAbsOrigin(), thisEntity:Attribute_GetIntValue("parent_distance", 24))
  if parent then
    thisEntity:SetParent(parent, "")
  end
end
function Spawn() thisEntity:SetThink("Parent", self, 0.125) end