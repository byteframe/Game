local hand = nil
local hand_id = -1
local hand_attachment = nil
local particle_a = "particles/environment/xen_drip_01_small_single_nofollow.vpcf"
local rounds = RandomInt(24,32)
function Precache(context) PrecacheParticle(particle_a, context) end
function SetEquipped(self, pHand, nHandID, phand_attachment, pPlayer)
  hand = pHand
  hand_id = nHandID
  hand_attachment = phand_attachment
  pPlayer:AllowTeleportFromHand(hand_id, true)
  return true
end
function SetUnequipped()
  hand = nil
  hand_id = -1
  hand_attachment = nil
  pickup = false
  return true
end
function OnHandleInput(input)
  local nIN_TRIGGER = IN_USE_HAND1; if (hand_id == 0) then nIN_TRIGGER = IN_USE_HAND0 end;
  local nIN_GRIP = IN_GRIP_HAND1; if (hand_id == 0) then nIN_GRIP = IN_GRIP_HAND0 end;
  if input.buttonsPressed:IsBitSet(nIN_TRIGGER) and rounds > 0 then
    if not pickup then
      pickup = true
    else
      rounds = rounds - 1
      EmitSoundOn("XenInfest.ShellSquishSm_byteframe14", hand_attachment)
      hand:FireHapticPulse(5)
      ParticleManager:SetParticleControlEnt(
        ParticleManager:CreateParticle(particle_a, PATTACH_CUSTOMORIGIN, nil),
          0, hand_attachment, PATTACH_POINT_FOLLOW, "spout", hand_attachment:GetAbsOrigin(), true)
      input.buttonsPressed:ClearBit(nIN_TRIGGER)
    end
  end
  if input.buttonsReleased:IsBitSet(nIN_TRIGGER) then
    input.buttonsReleased:ClearBit(nIN_TRIGGER)
  end
  if input.buttonsReleased:IsBitSet(nIN_GRIP) then
    input.buttonsReleased:ClearBit(nIN_GRIP)
  end
end