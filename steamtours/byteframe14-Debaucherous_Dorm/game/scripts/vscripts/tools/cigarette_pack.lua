local pickup = false
local hand = nil
local hand_id = nil
local hand_attachment = nil
local count = RandomInt(3,16)
local damp = false
function SetEquipped(self, pHand, nHandID, pHandAttachment, pPlayer)
  hand = pHand
  hand_id = nHandID
  hand_attachment = pHandAttachment
  pPlayer:AllowTeleportFromHand(nHandID, true)
  UpdateModel()
  return true
end
function SetUnequipped()
  hand = nil
  hand_id = nil
  hand_attachment = nil
  pickup = false
  return true
end
function UpdateModel()
  if count < 8 and count >= 0 then
    thisEntity:SetSingleMeshGroup("meshGroup_"..count)
    if hand_attachment then
      hand_attachment:SetSingleMeshGroup("meshGroup_"..count)
    end
  end
end
local colors = {
  { 255, 138, 138 },
  { 72, 207, 175 },
  { 255, 233, 148 },
  { 147, 231, 255 } }
function Activate()
  UpdateModel()
  local color = colors[RandomInt(1, #colors)]
  thisEntity:SetRenderColor(color[1], color[2], color[3])
end
function OnHandleInput(input)
  local nIN_TRIGGER = IN_USE_HAND1; if (hand_id == 0) then nIN_TRIGGER = IN_USE_HAND0 end;
  local nIN_GRIP = IN_GRIP_HAND1; if (hand_id == 0) then nIN_GRIP = IN_GRIP_HAND0 end;
  if input.buttonsPressed:IsBitSet(nIN_TRIGGER) then
    input.buttonsPressed:ClearBit(nIN_TRIGGER)
    if damp then
      EmitSoundOn("XenInfest.ShellSquishSm", thisEntity)
    else
      if count > 0 then
        if not pickup then
          pickup = true
        else
          if hand then
            hand:FireHapticPulse(5)
          end
          local angles = hand_attachment:GetAnglesAsVector()
          local cigarette = {
            model = "models/props/interior_deco/cigarette_001_segmented.vmdl",
            origin = hand_attachment:GetAttachmentOrigin(1),
            vscripts = "props/cigarette",
            angles = angles+Vector(90,0,0), }
          e = SpawnEntityFromTableSynchronous("prop_destinations_physics", cigarette)
          count = count -1
          UpdateModel()
          e:ApplyAbsVelocityImpulse(Vector(RandomFloat(0,5),RandomFloat(0,5),RandomFloat(35,70)))
          EmitSoundOn("PortalInhibitor.WhooshImpactLow", thisEntity)
        end
      end
    end
  end
  if input.buttonsReleased:IsBitSet(nIN_TRIGGER) then
    input.buttonsReleased:ClearBit(nIN_TRIGGER)
  end
  if input.buttonsReleased:IsBitSet(nIN_GRIP) then
    input.buttonsReleased:ClearBit(nIN_GRIP)
  end
  return input
end
function _Extinquish(_damp)
  damp = _damp
  if damp then
    local color = thisEntity:GetRenderColor()
    thisEntity:SetRenderColor(color.x-100, color.y-100, color.z-100)
  end
end
function thisEntity:Extinquish(_damp) _Extinquish(_damp) end
