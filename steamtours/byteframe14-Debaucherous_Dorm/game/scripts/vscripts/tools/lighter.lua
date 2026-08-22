require('_shared')
local hand = nil
local hand_id = -1
local hand_attachment = nil
local active = false
local pickup = false
local open = false
local particle_name = "particles/candyshop/env/fx_candleflame_01_c_side_small.vpcf"
function SetEquipped(self, pHand, nHandID, pHandAttachment, pPlayer)
  hand = pHand
  hand_id = nHandID
  hand_attachment = pHandAttachment
  pPlayer:AllowTeleportFromHand(hand_id, true)
  return true
end
function SetUnequipped()
  hand = nil
  hand_id = -1
  hand_attachment = nil
  _Extinquish()
  open = false
  pickup = false
  return true
end
function OnHandleInput(input)
  local nIN_TRIGGER = IN_USE_HAND1; if (hand_id == 0) then nIN_TRIGGER = IN_USE_HAND0 end;
  local nIN_GRIP = IN_GRIP_HAND1; if (hand_id == 0) then nIN_GRIP = IN_GRIP_HAND0 end;
  if not active and input.buttonsPressed:IsBitSet(nIN_TRIGGER) then
    if not pickup then
      pickup = true
    else
      if hand_attachment:GetModelName() == "models/props_items/zippo_closed001_dmx.vmdl" and not open then
        open = true
        EmitSoundOn('lighter_open', thisEntity)
        hand_attachment:SetSingleMeshGroup('meshGroup_1')
      else
        input.buttonsPressed:ClearBit(nIN_TRIGGER)
        EmitSoundOn('lighter_strike', thisEntity)
        active = true
        thisEntity:Attribute_SetIntValue('fire_particle_id', ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, nil))
        hand_attachment["Extinquish"] = function() _Extinquish() end
        ParticleManager:SetParticleControlEnt(thisEntity:Attribute_GetIntValue('fire_particle_id', -1), 0, hand_attachment, PATTACH_POINT_FOLLOW, "flame", hand_attachment:GetAbsOrigin(), true)
        hand:FireHapticPulse(5)
        hand_attachment:SetThink(function()
          if active then
            Ignite(hand_attachment:GetAttachmentOrigin(1))
            return 0.35
          else
            ParticleManager:DestroyParticle(thisEntity:Attribute_GetIntValue('fire_particle_id', -1), false)
          end
        end, 'ignite', 0.25)
      end
    end
  end
  if input.buttonsReleased:IsBitSet(nIN_TRIGGER) then
    input.buttonsReleased:ClearBit(nIN_TRIGGER)
    _Extinquish()
  end
  if input.buttonsReleased:IsBitSet(nIN_GRIP) then
    input.buttonsReleased:ClearBit(nIN_GRIP)
  end
  return input
end
function _Extinquish(_is_wet)
  active = false
  ParticleManager:DestroyParticle(thisEntity:Attribute_GetIntValue('fire_particle_id', -1), false)
end
function thisEntity:Extinquish(_is_wet) _Extinquish(_is_wet) end