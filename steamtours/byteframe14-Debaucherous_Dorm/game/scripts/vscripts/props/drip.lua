local is_held = false
local playing_sound = false
function OnPickedUp(self, hand)
  is_held = true
  thisEntity:SetThink(function()
    if is_held then
      if thisEntity:GetForwardVector().z < 0.2 then
        if not playing_sound then
          EmitSoundOn('XenInfest.EradicatedXenDrippingChild_byteframe14', thisEntity)
          playing_sound = true
        end
        local e = ParticleManager:CreateParticle("particles/environment/xen_drip_01_small_single.vpcf", PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControlEnt(e, 0, thisEntity, PATTACH_POINT_FOLLOW, nil, thisEntity:GetAbsOrigin(), true)
      else
        StopSound()
      end
      return 1.5
    end
  end, '0', 1.0)
end
function StopSound()
  StopSoundOn('XenInfest.EradicatedXenDrippingChild_byteframe14', thisEntity)
  playing_sound = false
end
function OnDropped(self, hand)
  is_held = false
  StopSound()
end
