local hand = nil
local hand_id = -1
local hand_attachment = nil
local is_firing = false
local particlename = "particles/environment/xen_drip_01_small_single.vpcf"
local scale = nil
function Precache(context)
  PrecacheParticle(particlename, context)
end
function Activate()
  scale = thisEntity:GetModelScale()
end
function SetEquipped(self, pHand, nHandID, phand_attachment, pPlayer)
  hand = pHand
  hand_id = nHandID
  hand_attachment = phand_attachment
  pPlayer:AllowTeleportFromHand(hand_id, true)
  local skin = RandomInt(0,1)
  thisEntity:SetSkin(skin)
  hand_attachment:SetSkin(skin)
  local scale = RandomFloat(scale, 1.1)
  thisEntity:SetModelScale(scale)
  hand_attachment:SetModelScale(scale)
  return true
end
function SetUnequipped()
  hand = nil
  hand_id = -1
  hand_attachment = nil
  return true
end
function OnHandleInput(input)
  local nIN_TRIGGER = IN_USE_HAND1; if (hand_id == 0) then nIN_TRIGGER = IN_USE_HAND0 end;
  local nIN_GRIP = IN_GRIP_HAND1; if (hand_id == 0) then nIN_GRIP = IN_GRIP_HAND0 end;
  if input.buttonsPressed:IsBitSet(nIN_TRIGGER) then
    input.buttonsPressed:ClearBit(nIN_TRIGGER)
    EmitSoundOn("XenInfest.ShellSquishSm_byteframe14", hand_attachment)
    is_firing = true
    hand:SetThink(function()
      if is_firing then
        hand:FireHapticPulse(5)
        return 0.3
      end
    end, self, 0.25)
    local e = ParticleManager:CreateParticle(particlename, PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControlEnt(e, 0, hand_attachment, PATTACH_POINT_FOLLOW, "innerUrethra", hand_attachment:GetAbsOrigin(), true)
  end
  if input.buttonsReleased:IsBitSet(nIN_TRIGGER) then
    is_firing = false
    input.buttonsReleased:ClearBit(nIN_TRIGGER)
  end
  if input.buttonsReleased:IsBitSet(nIN_GRIP) then
    is_firing = false
    input.buttonsReleased:ClearBit(nIN_GRIP)
  end
  return input
end