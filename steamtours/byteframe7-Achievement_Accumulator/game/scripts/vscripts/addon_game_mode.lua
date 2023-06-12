require("utils/library")
require("utils/deepprint")

local items = {}

function Precache(context)
	PrecacheParticle("particles/tool_fx/cache_captured_confetti.vpcf", context)
end

function Activate()
  items = Entities:FindAllByClassname('prop_dynamic')
  thisEntity:SetThink("OnThink")
  ListenToGameEvent("player_spawn", OnPlayerSpawned, nil)
end

local players = {}
function OnPlayerSpawned(eventInfo)
	local player = GetPlayerFromUserID(eventInfo.userid)
	table.insert(players, player)
end

function OnThink()
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
                GameRules:GetGameModeEntity():UnlockItem(player, entity:GetName())
                print(entity:GetName())
                local particle = SpawnEntityFromTableSynchronous( "info_particle_system", {
                  origin = entity:GetAbsOrigin(),
                  start_active = "1",
                  effect_name = "particles/tool_fx/cache_captured_confetti.vpcf"
                })
                EmitSoundOn("win_prop", particle)
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