local hand = nil
local hand_id = -1
local hand_attachment = nil
local player = nil
local pickup = false
local is_firing = false
function SetEquipped(self, pHand, nHandID, pHandAttachment, pPlayer)
  hand = pHand
  hand_id = nHandID
  hand_attachment = pHandAttachment
  player = pPlayer
  is_firing = false
  player:AllowTeleportFromHand(hand_id, true)
  return true
end
function SetUnequipped()
  hand = nil
  hand_id = -1
  hand_attachment = nil
  player = nil
  is_firing = false
  pickup = false
  return true
end
function Click()
  local vecStartPos = hand_attachment:GetAttachmentOrigin(hand_attachment:ScriptLookupAttachment("shoot"))
  local direction = -hand_attachment:GetForwardVector()
  local vecEndPos = (vecStartPos+(direction*3000))
  local trace = { startpos = vecStartPos, endpos = vecEndPos, mask = nil, ignore = player }
  TraceLine(trace)
  if trace["hit"] == true then
    local targetEnt = trace["enthit"]
    if targetEnt then
      local vForce = trace["pos"] - vecStartPos
      vForce = vForce:Normalized()*100
      local hDamageInfo = CreateDamageInfo(player, player, vForce, trace["pos"], 1, DMG_BLAST)
      hDamageInfo:SetDamageForce(vForce)
      hDamageInfo:SetDamagePosition(trace["pos"])
      targetEnt:TakeDamage(hDamageInfo)
      DestroyDamageInfo(hDamageInfo)
    end
  end
  hand:FireHapticPulse(5)
  EmitSoundOn("multitool_click", thisEntity);
end
function OnHandleInput(input)
  local nIN_TRIGGER = IN_USE_HAND1; if (hand_id == 0) then nIN_TRIGGER = IN_USE_HAND0 end;
  local nIN_GRIP = IN_GRIP_HAND1; if (hand_id == 0) then nIN_GRIP = IN_GRIP_HAND0 end;
  if input.buttonsPressed:IsBitSet(nIN_TRIGGER) then
    input.buttonsPressed:ClearBit(nIN_TRIGGER)
    if not pickup then
      pickup = true
    else
      Click()
      hand:SetThink(function()
        if (is_firing == true) then
          Click()
          return 0.5
        end
        return nil
      end, self, 0.25 )
      is_firing = true
    end
  end
  if input.buttonsReleased:IsBitSet(nIN_TRIGGER) then
    input.buttonsReleased:ClearBit(nIN_TRIGGER)
    is_firing = false
  end
  if input.buttonsReleased:IsBitSet(nIN_GRIP) then
    input.buttonsReleased:ClearBit(nIN_GRIP)
    is_firing = false
  end
  return input
end