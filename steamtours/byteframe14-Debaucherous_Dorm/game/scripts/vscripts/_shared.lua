function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k,v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end
function shuffle(E)
  for i=#E, 2, -1 do
    local j = math.random(i)
    E[i], E[j] = E[j], E[i]
  end
  return E
end
function pick(E)
  if E[1] == 0 or E[1]-1 == #E[2] then
    E[1] = 1
    E[2] = shuffle(E[2])
  end
  E[1] = E[1]+1
  return E[2][E[1]-1]
end
function Contains(v, origin, bounds)
  if  v[1] > (origin[1]-abs(bounds["Mins"][1])) and v[1] < (origin[1]+bounds["Maxs"][1])
  and v[2] > (origin[2]-abs(bounds["Mins"][2])) and v[2] < (origin[2]+bounds["Maxs"][2])
  and v[3] > (origin[3]-abs(bounds["Mins"][3])) and v[3] < (origin[3]+bounds["Maxs"][3]) then
    return true
  end
  return false
end
local flame_bounds = { Mins = Vector(-1.0, -1.0, -1.0), Maxs = Vector(1.0, 1.0, 1.0) }
function select_fire_particle(v)
  local bounds = v:GetBounds()
  return "particles/log_fire_flames1_single_"..math.max(1, math.min(20, math.floor(math.max(abs(bounds["Mins"][2])+bounds["Maxs"][2], abs(bounds["Mins"][1])+bounds["Maxs"][1])))-1)..".vpcf"
end
function Ignite(flame)
  for k,v in pairs(Entities:FindAllInSphere(flame, 8.0)) do
    if v:GetModelName() == "models/props/interior_deco/cigarette_001_segmented.vmdl" then
      if Contains(flame, v:GetAttachmentOrigin(v:Attribute_GetIntValue('state', -1)), flame_bounds) then
        v:Burn()
      end
    elseif string.find(v:GetName(), "flame_point") and v:Attribute_GetIntValue('burning', -1) == -1 then
      if Contains(flame, v:GetAbsOrigin(), flame_bounds) then
        v:Attribute_SetIntValue("burning", 1)
        DoEntFireByInstanceHandle(v, "Start", nil, 0, self, self)
        v:SetThink(function()
          Ignite(v:GetAbsOrigin())
          return 0.35
        end, self, 0.0)
      end
    elseif v:GetClassname() == 'prop_destinations_physics' and v:ScriptLookupAttachment("candle") > 0 and v:Attribute_GetIntValue('burning', -1) == -1 then
      if Contains(flame, v:GetAttachmentOrigin(v:ScriptLookupAttachment("candle")), flame_bounds) then
        v:Attribute_SetIntValue("burning", 1)
        if v:GetModelName() == "models/lostcoast/props_monastery/candlestick_dmx.vmdl" then
          v:Attribute_SetIntValue("fire_particle_id", ParticleManager:CreateParticle("particles/candyshop/env/fx_candleflame_nosmoke_01.vpcf", PATTACH_CUSTOMORIGIN, nil))
        else
          v:Attribute_SetIntValue("fire_particle_id", ParticleManager:CreateParticle("particles/candyshop/env/fx_candleflame_01_c_side_small.vpcf", PATTACH_CUSTOMORIGIN, nil))
        end
        ParticleManager:SetParticleControlEnt(v:Attribute_GetIntValue("fire_particle_id", -1), 0, v, PATTACH_POINT_FOLLOW, "candle", v:GetAttachmentOrigin(v:ScriptLookupAttachment("candle")), true)
        v:SetThink(function()
          Ignite(v:GetAttachmentOrigin(v:ScriptLookupAttachment("candle")))
          return 0.35
        end, 'ignite', 0.0)
      end
    elseif (string.find(v:GetModelName(), "paper")
    or string.find(v:GetModelName(), "card")
    or string.find(v:GetModelName(), "cloth")
    or string.find(v:GetModelName(), "magazine")
    or string.find(v:GetModelName(), "money")
    or string.find(v:GetModelName(), "poster")
    or string.find(v:GetModelName(), "matchbook") or string.find(v:GetModelName(), "matchbox") )
    and not string.find(v:GetModelName(), "magazinerack") and not string.find(v:GetModelName(), "paperbin")
    and v:Attribute_GetIntValue('is_wet', -1) == -1 and v:Attribute_GetIntValue('burning', -1) == -1
    and Contains(flame, v:GetAbsOrigin(), v:GetBounds()) then
      v:Attribute_SetIntValue('burning', 1)
      v:Attribute_SetIntValue("fire_particle_id", ParticleManager:CreateParticle(select_fire_particle(v), PATTACH_CUSTOMORIGIN, nil))
      ParticleManager:SetParticleControlEnt(v:Attribute_GetIntValue("fire_particle_id", -1), 0, v, PATTACH_POINT_FOLLOW, nil, v:GetAbsOrigin(), true)
      if string.find(v:GetModelName(), "props/magazines/") or string.find(v:GetModelName(), "poster") then
        EmitSoundOn('Prop.CreepyBaby_byteframe14', v)
      end
      v:SetThink(function()
        v["color"] = (v["color"] or 255)-5
        v:SetRenderColor(v["color"], v["color"], v["color"])
        if v["color"] ~= 0 then
          return 0.035
        end
        ParticleManager:SetParticleControl(ParticleManager:CreateParticle("particles/fire01_embers_small_single_short.vpcf", PATTACH_CUSTOMORIGIN, nil), 0, v:GetAbsOrigin())
        ParticleManager:DestroyParticle(v:Attribute_GetIntValue("fire_particle_id", -1), true)
        v:SetThink(function() v:RemoveSelf() end, '00', 0.1)
      end, '0', 0.0)
    end
  end
end
