local items = {}

function ResetFallout()
  items = Entities:FindAllByName('fallout')
  CustomNetTables:SetTableValue("game", "count", { value = table.getn(items) })
  for i,entity in ipairs(items) do
    DoEntFireByInstanceHandle(entity, "StopGlowing", "", 0, nil, nil)
  end
end

function Activate()
  ResetFallout()
  thisEntity:SetThink("OnThink")
  CustomGameEventManager:RegisterListener( "reset_fallout", ResetFallout)
end

function OnThink()
  local players = Entities:FindAllByClassname("player")
  for _,player in pairs(players) do
    local avatar = player:GetHMDAvatar()
    if avatar ~= nil then
      for handID = 0,1 do
        local hand = avatar:GetVRHand(handID)
        if hand ~= nil then
          for i,entity in ipairs(items) do
            if CalcDistanceBetweenEntityOBB(hand, entity) <= 1 then
              local IN_USE = hand:GetHandID() == 0 and IN_USE_HAND0 or IN_USE_HAND1
              if player:IsVRControllerButtonPressed(IN_USE) then
                CustomNetTables:SetTableValue("game", "count", { value = table.getn(items)-1 })
                DoEntFireByInstanceHandle(entity, "StartGlowing", "", 0, nil, nil)
                EmitGlobalSound("cachefinder_equip")
                if table.getn(items) == 1 then
                  EmitGlobalSound("win_prop")
                end
                table.remove(items, i)
              end
              break
            end
          end
        end
      end
    end
  end
  return 0.250
end