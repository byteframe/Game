local hand = nil
local hand_id = -1
local hand_attachment = nil
local hand_attachment_dynamic = nil
local hand_attachment_dynamic_particle_a = nil
local hand_attachment_dynamic_particle_b = nil
local particle_a = "particles/environment/xen_drip_01_small_single_nofollow.vpcf"
local particle_b = "particles/candyshop/env/fx_env_radiator_steam_01_c_water_small.vpcf"
local rounds = RandomInt(8,16)
function Precache(context)
  PrecacheParticle(particle_a, context)
  PrecacheParticle(particle_b, context)
end
function Activate(context)
  local origin = thisEntity:GetAbsOrigin()
  local bounds = thisEntity:GetBoundingMaxs()
  local color = thisEntity:GetRenderColor()
  _hand_attachment_dynamic = {
    model = "models/props/dishwasher_soap_bottle.vmdl",
    origin = origin,
    angles = thisEntity:GetAngles(),
    solid = 0 }
  _hand_attachment_dynamic_particle_a = {
    effect_name = particle_a,
    origin = Vector(origin.x, origin.y, origin.z+bounds[3]),
    start_active = "0" }
  _hand_attachment_dynamic_particle_b = {
    effect_name = particle_b,
    origin = Vector(origin.x, origin.y, origin.z+bounds[3]+0.25),
    angles = Vector(270.0, 0.0, 0.0),
    start_active = "0" }
  hand_attachment_dynamic = SpawnEntityFromTableSynchronous("prop_dynamic", _hand_attachment_dynamic)
  hand_attachment_dynamic:SetRenderColor(color[1], color[2], color[3])
  hand_attachment_dynamic_particle_a = SpawnEntityFromTableSynchronous("info_particle_system", _hand_attachment_dynamic_particle_a)
  hand_attachment_dynamic_particle_b = SpawnEntityFromTableSynchronous("info_particle_system", _hand_attachment_dynamic_particle_b)
  hand_attachment_dynamic:SetParent(thisEntity, nil)
  hand_attachment_dynamic_particle_a:SetParent(hand_attachment_dynamic, nil)
  hand_attachment_dynamic_particle_b:SetParent(hand_attachment_dynamic, nil)
  thisEntity:SetRenderAlpha(0)
end
function SetEquipped(self, pHand, nHandID, phand_attachment, pPlayer)
  hand = pHand
  hand_id = nHandID
  hand_attachment = phand_attachment
  pPlayer:AllowTeleportFromHand(hand_id, true)
  hand_attachment_dynamic:SetParent(hand_attachment, nil)
  hand_attachment_dynamic:SetLocalAngles(45, 0, 0)
  hand_attachment_dynamic:SetLocalOrigin(Vector(-7, 0, -4))
  phand_attachment:SetRenderMode(10)
  return true
end
function SetUnequipped()
  hand = nil
  hand_id = -1
  hand_attachment_dynamic:SetParent(thisEntity, nil)
  hand_attachment_dynamic:SetLocalOrigin(Vector(0, 0, 0))
  hand_attachment_dynamic:SetLocalAngles(0, 0, 0)
  hand_attachment = nil
  pickup = false
  return true
end
function FireParticleB()
  EmitSoundOn("PhysPlayerCrush.Soap_Bottle_Oneshot", hand_attachment_dynamic)
  DoEntFireByInstanceHandle(hand_attachment_dynamic_particle_b, 'Start', "", 0, nil, nil)
  DoEntFireByInstanceHandle(hand_attachment_dynamic_particle_b, 'StopPlayEndCap', "", 0.3, nil, nil)
end
function OnHandleInput(input)
  local nIN_TRIGGER = IN_USE_HAND1; if (hand_id == 0) then nIN_TRIGGER = IN_USE_HAND0 end;
  local nIN_GRIP = IN_GRIP_HAND1; if (hand_id == 0) then nIN_GRIP = IN_GRIP_HAND0 end;
  if input.buttonsPressed:IsBitSet(nIN_TRIGGER) then
    input.buttonsPressed:ClearBit(nIN_TRIGGER)
    if not pickup then
      pickup = true
    else
      hand_attachment_dynamic:SetSequence("crush_1_amount_100")
      if hand_attachment_dynamic:GetUpVector().z < 0.01 and rounds >= 1 then
        rounds = rounds - 1
        DoEntFireByInstanceHandle(hand_attachment_dynamic_particle_a, 'Start', "", 0, nil, nil)
        DoEntFireByInstanceHandle(hand_attachment_dynamic_particle_a, 'StopPlayEndCap', "", 0.3, nil, nil)
        EmitSoundOn("XenInfest.ShellSquishSm_byteframe14", hand_attachment_dynamic)
        if RandomInt(0,4) == 3 then
          FireParticleB()
        end
      else
        FireParticleB()
      end
    end
  end
  if input.buttonsReleased:IsBitSet(nIN_TRIGGER) then
    hand_attachment_dynamic:SetSequence("crush_1_amount_0")
    input.buttonsReleased:ClearBit(nIN_TRIGGER)
  end
  if input.buttonsReleased:IsBitSet(nIN_GRIP) then
    input.buttonsReleased:ClearBit(nIN_GRIP)
  end
  return input
end