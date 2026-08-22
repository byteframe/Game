function FindPlayer()
  local found = false
  for k,v in pairs(Entities:FindAllByClassname("player")) do
    if thisEntity:IsTouching(v) then
      found = true
    end
  end
  return found
end
function ToggleTeleport(enable)
  if enable then
    for k,v in pairs(Entities:FindAllByNameWithin("*_switch_button*", thisEntity:GetAbsOrigin(), 128.0)) do
      DoEntFireByInstanceHandle(v, 'Unlock', nil, 0.0, self, self)
    end
    for k,v in pairs(Entities:FindAllByNameWithin("*dorm_relay*", thisEntity:GetAbsOrigin(), 96.0)) do
      DoEntFireByInstanceHandle(v, 'Trigger', nil, 0.0, self, self)
    end
  else
    for k,v in pairs(Entities:FindAllByNameWithin("*_switch_button*", thisEntity:GetAbsOrigin(), 128.0)) do
      DoEntFireByInstanceHandle(v, 'Lock', nil, 0.0, self, self)
    end
    for k,v in pairs(Entities:FindAllByNameWithin("*dorm_teleport*", thisEntity:GetAbsOrigin(), 96.0)) do
      DoEntFireByInstanceHandle(v, 'Disable', nil, 0.0, self, self)
    end
  end
end
function ThinkEnableA()
  DoEntFireByInstanceHandle(Entities:FindByNameNearest("*dormroom_light_switch_button*", thisEntity:GetAbsOrigin(), 96.0), "Unlock", nil, 0.0, self, self)
  DoEntFireByInstanceHandle(Entities:FindByNameNearest("*dormroom_light_switch_button*", thisEntity:GetAbsOrigin(), 96.0), "PressIn", nil, 0.125, self, self)
  for k,v in pairs(Entities:FindAllByNameWithin("*desklamp_button*", thisEntity:GetAbsOrigin(), 384.0)) do
    if Contains(v:GetAbsOrigin(), thisEntity:GetAbsOrigin(), thisEntity:GetBounds()) then
      DoEntFireByInstanceHandle(v, 'PressIn', nil, 0.125, self, self)
    end
  end
  thisEntity:SetThink(function()
    if FindPlayer() then
      return 1.0
    end
    DoEntFireByInstanceHandle(Entities:FindByNameNearest("*door_func*", thisEntity:GetAbsOrigin(), 96.0), "Close", nil, 3.0, self, self)
  end, self, 1.0)
  ToggleTeleport(true)
end
function ThinkEnableB()
  thisEntity:SetThink(function()
    if FindPlayer() then
      return 1.0
    end
    for k,v in pairs(Entities:FindAllByNameWithin("*desklamp_button*", thisEntity:GetAbsOrigin(), 384.0)) do
      if Contains(v:GetAbsOrigin(), thisEntity:GetAbsOrigin(), thisEntity:GetBounds()) then
        DoEntFireByInstanceHandle(v, 'PressOut', nil, 0.125, self, self)
      end
    end
    DoEntFireByInstanceHandle(Entities:FindByClassnameNearest("info_visibility_box", thisEntity:GetAbsOrigin(), 96), "Enable", nil, 1.0, self, self)
    DoEntFireByInstanceHandle(Entities:FindByNameNearest("*dormroom_light_switch_button*", thisEntity:GetAbsOrigin(), 96), "PressOut", nil, 0.0, self, self)
    DoEntFireByInstanceHandle(Entities:FindByNameNearest("*dormroom_light_switch_button*", thisEntity:GetAbsOrigin(), 96), "Lock", nil, 0.125, self, self)
    DoEntFireByInstanceHandle(Entities:FindByNameNearest("*dormroom_cube_off*", thisEntity:GetAbsOrigin(), 96.0), "Disable", nil, 0.5, self, self)
    ToggleTeleport(false)
  end, self, 1.0)
end