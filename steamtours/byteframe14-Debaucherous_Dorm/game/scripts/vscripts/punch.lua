require('_shared')
local effects = {
  { "particles/generic_fx/fx_dust.vpcf",  "prop_boxing_glove_impact_byteframe14", { "sounds/props/boxing_glove_impact_01.vsnd","sounds/props/boxing_glove_impact_02.vsnd","sounds/props/boxing_glove_impact_03.vsnd","sounds/props/boxing_glove_impact_04.vsnd", } },
  { "particles/impact_fx/impact_physics_dust.vpcf", "prop_boxing_glove_impact_byteframe14", { "sounds/props/boxing_glove_impact_01.vsnd","sounds/props/boxing_glove_impact_02.vsnd","sounds/props/boxing_glove_impact_03.vsnd","sounds/props/boxing_glove_impact_04.vsnd", } } }
function Precache(context)
  for k,v in pairs(effects) do
    PrecacheParticle(v[1], context)
    for k,v in pairs(v[3]) do
      PrecacheSoundFile(v, context)
    end
  end
end
function Punch(trigger)
  local effect = effects[RandomInt(1, #effects)]
  EmitSoundOn(effect[2], thisEntity)
  ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle(effect[1], PATTACH_CUSTOMORIGIN, nil), 0, thisEntity, PATTACH_CUSTOMORIGIN, nil, trigger.activator:GetAbsOrigin(), true);
end