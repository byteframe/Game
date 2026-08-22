require('_shared')
function Precache(context)
  PrecacheParticle("particles/water_splash_1_smaller.vpcf", context)
end
local splash_enabled = 0
function EnableSplash(enable)
  splash_enabled = enable or 1
end
function Splash(trigger)
  if splash_enabled == 1 then
    splash = ParticleManager:CreateParticle("particles/water_splash_1_smaller.vpcf", PATTACH_CUSTOMORIGIN, nil);
    local origin = trigger.activator:GetAbsOrigin();
    ParticleManager:SetParticleControlEnt(splash, 0, thisEntity, PATTACH_CUSTOMORIGIN, nil, Vector(origin.x, origin.y, thisEntity:GetOrigin().z+thisEntity:GetBoundingMaxs().z), true);
    EmitSoundOn("sink_drip_byteframe14", thisEntity)
  end
  if trigger.activator:GetModelName() == "models/hands/steamvr_hand_right.vmdl" or trigger.activator:GetModelName() == "models/hands/steamvr_hand_left.vmdl" then
    trigger.activator = trigger.activator:GetChildren()[1]
  end
  if trigger.activator["Extinquish"] then
    trigger.activator:Extinquish(true)
  end
  if trigger.activator:Attribute_GetIntValue("fire_particle_id", -1) ~= -1 then
    ParticleManager:DestroyParticle(trigger.activator:Attribute_GetIntValue("steam_particle_id", -1), false)
    ParticleManager:DestroyParticle(trigger.activator:Attribute_GetIntValue("smoke_particle_id", -1), false)
    ParticleManager:DestroyParticle(trigger.activator:Attribute_GetIntValue("fire_particle_id", -1), false)
    trigger.activator:Attribute_SetIntValue("fire_particle_id", -1)
    trigger.activator:SetThink(function() end, 'ignite')
  elseif string.find(trigger.activator:GetModelName(), "paper") then
    trigger.activator:SetRenderColor(175,175,175)
    trigger.activator:Attribute_SetIntValue('is_wet', 1)
  else
    for k,v in pairs(trigger.activator:GetChildren()) do
      if v:GetClassname() == 'info_particle_system' then
        DoEntFireByInstanceHandle(v, "Kill", nil, 0, self, self)
      end
    end
  end
end