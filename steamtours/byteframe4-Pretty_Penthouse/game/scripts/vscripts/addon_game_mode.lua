require("utils/library")
require("utils/deepprint")

local items = {}

function Precache(context)
	PrecacheParticle("particles/electric_fence_small_spark_1.vpcf", context)
	PrecacheParticle("particles/tool_fx/cache_captured_confetti.vpcf", context)
end

function ResetFallout()
  items = Entities:FindAllByName('fallout')
  CustomNetTables:SetTableValue("game", "count", { value = table.getn(items) })
  for i,entity in ipairs(items) do
    DoEntFireByInstanceHandle(entity, "StopGlowing", "", 0, nil, nil)
  end
end

function ChangeFortune()
	local particle = SpawnEntityFromTableSynchronous( "info_particle_system", {
		origin = Vector(40.0, -779.0, 5763.0),
		start_active = "1",
		effect_name = "particles/electric_fence_small_spark_1.vpcf"
	})
  EmitSoundOn("byteframe4_fortune", particle)
end

function Activate()
  ResetFallout()
  thisEntity:SetThink("OnThink")
  CustomGameEventManager:RegisterListener( "reset_fallout", ResetFallout)
  CustomGameEventManager:RegisterListener( "change_fortune", ChangeFortune)
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
                CustomNetTables:SetTableValue("game", "count", { value = table.getn(items)-1 })
                DoEntFireByInstanceHandle(entity, "StartGlowing", "", 0, nil, nil)
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