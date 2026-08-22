require('_shared')
local max_cook = 30
local radius = -1.0
local particle_smoke = "particles/candyshop/env/fx_env_radiator_steam_01_c_wisps.vpcf"
local particle_steam = "particles/candyshop/env/fx_env_candygoop_c_steam.vpcf"
local bounds
local open = false
function Activate()
  bounds = thisEntity:GetBounds()
  radius = math.max(abs(bounds["Mins"][1])+bounds["Maxs"][1], abs(bounds["Mins"][2])+bounds["Maxs"][2], abs(bounds["Mins"][3])+bounds["Maxs"][3])
end
function Precache(context)
  for i = 1, 20 do
    PrecacheParticle("particles/log_fire_flames1_single_"..i..".vpcf", context)
  end
  PrecacheParticle(particle_smoke, context)
  PrecacheParticle(particle_steam, context)
end
function SetOpen(_open) open = _open end
function Cook(enable, delay)
  enable = enable or 1
  delay = delay or 0.0
  if enable == 0 then
    return thisEntity:SetThink(function() end, 'cook')
  end
  thisEntity:SetThink(function()
    for k,v in pairs(Entities:FindAllByClassnameWithin("prop_destinations_physics", thisEntity:GetAbsOrigin(), radius)) do
      if Contains(v:GetCenter(), thisEntity:GetAbsOrigin(), bounds) then
        local model = v:GetModelName()
        local bounds = v:GetBounds()
        if abs(bounds["Mins"][3])+bounds["Maxs"][3] < 8 and abs(bounds["Mins"][2])+bounds["Maxs"][2] < 20 and abs(bounds["Mins"][1])+bounds["Maxs"][1] < 20
        and string.find(model, '_pot') == nil and string.find(model, '_pan') == nil and string.find(model, '_tray') == nil and string.find(model, '_props_se/kitchen') == nil then
          local cook_time = v:Attribute_GetIntValue("cook_time", 255)
          if cook_time >= max_cook then
            v:Attribute_SetIntValue("cook_time", cook_time-1)
            v:SetRenderColor(cook_time-1, cook_time-1, cook_time-1)
            if v:Attribute_GetIntValue("cook_time", -1) == max_cook then
              local door = Entities:FindByClassnameWithin(nil, "func_door_rotating", thisEntity:GetAbsOrigin(), radius+6.0)
              if door and not open then
                for k,v in pairs(Entities:FindAllByNameWithin("*cook_particles*", thisEntity:GetAbsOrigin(), radius+6.0)) do
                  DoEntFireByInstanceHandle(v, "Start", nil, 0.5, self, self)
                end
              end
              local push = Entities:FindByClassnameWithin(nil, "trigger_push", thisEntity:GetAbsOrigin(), radius)
              if push then
                if door then
                  DoEntFireByInstanceHandle(door, "SetSpeed", "1000", 0.0, self, self)
                  DoEntFireByInstanceHandle(door, "Open", nil, 0.05, self, self)
                  EmitSoundOn('drone_explode', push)
                  DoEntFireByInstanceHandle(door, "SetSpeed", "300", 0.5, self, self)
                end
                DoEntFireByInstanceHandle(push, "Enable", nil, 0.1, self, self)
                DoEntFireByInstanceHandle(push, "Disable", nil, 0.5, self, self)
                thisEntity:SetThink(function() EmitSoundOn('Elevator_Apartment.Ding', push) end, 'ding', 0.4)
              end
              flame = ParticleManager:CreateParticle(select_fire_particle(v), PATTACH_POINT_FOLLOW, v)
              smoke = ParticleManager:CreateParticle(particle_smoke, PATTACH_POINT_FOLLOW, v)
              steam = ParticleManager:CreateParticle(particle_steam, PATTACH_POINT_FOLLOW, v)
              ParticleManager:SetParticleControlEnt(flame, 0, v, PATTACH_POINT_FOLLOW, nil, Vector(0, 0, 0), true)
              ParticleManager:SetParticleControlEnt(smoke, 0, v, PATTACH_POINT_FOLLOW, nil, Vector(0, 0, 0), true)
              ParticleManager:SetParticleControlEnt(steam, 0, v, PATTACH_POINT_FOLLOW, nil, Vector(0, 0, 0), true)
              v:Attribute_SetIntValue('fire_particle_id', flame)
              v:Attribute_SetIntValue('smoke_particle_id', smoke)
              v:Attribute_SetIntValue('steam_particle_id', steam)
              v:SetThink(function() ParticleManager:DestroyParticle(flame, false) end, 'stop_flame', RandomFloat(6.0, 16.0))
              v:SetThink(function() ParticleManager:DestroyParticle(smoke, false) end, 'stop_smoke', RandomFloat(8.0, 20.0))
              v:SetThink(function() ParticleManager:DestroyParticle(steam, false) end, 'stop_steam', RandomFloat(7.0, 16.0))
            end
          end
        end
      end
    end
    return 0.1
  end, 'cook', delay)
end