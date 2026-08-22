require('_shared')
local bounds
local radius
local child
function Activate()
  bounds = thisEntity:GetBounds()
  radius = math.max(abs(bounds["Mins"][1])+bounds["Maxs"][1], abs(bounds["Mins"][2])+bounds["Maxs"][2], abs(bounds["Mins"][3])+bounds["Maxs"][3])
  thisEntity:SetThink(function()
    EnableProps(false)
  end, self, 2.5)
end
function EnableProps(enable)
  for k,v in pairs(Entities:FindAllByClassnameWithin("prop_destinations_physics", thisEntity:GetAbsOrigin(), radius)) do
    if v:entindex() ~= thisEntity:entindex() and Contains(v:GetCenter(), thisEntity:GetAbsOrigin(), bounds) then
      v:EnableUse(enable)
    end
  end
  for k,v in pairs(Entities:FindAllByClassnameWithin("info_particle_system", thisEntity:GetAbsOrigin(), radius)) do
    if Contains(v:GetCenter(), thisEntity:GetAbsOrigin(), bounds) then
      if enable then
        DoEntFireByInstanceHandle(v, 'Start', "", 0, nil, nil)
      else
        DoEntFireByInstanceHandle(v, 'StopPlayEndCap', "", 0, nil, nil)
      end
    end
  end
end