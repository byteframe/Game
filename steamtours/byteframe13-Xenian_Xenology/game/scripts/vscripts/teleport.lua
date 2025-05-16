-- https://github.com/Rectus/destinations_playarea_example/blob/master/vscripts/teleport_player.lua
function OnTeleportTrigger(params)
  if params.activator and params.activator:GetClassname() == "player"	then
    print(CustomNetTables:GetTableValue("teleport", "point").value)
		local destination = Entities:FindByName(nil, CustomNetTables:GetTableValue("teleport", "point").value)
    -- FIXME should ensure destination point
      local anchor = params.activator:GetHMDAnchor()
      local localPlayerOrigin = anchor:GetOrigin() - params.activator:GetOrigin()
      anchor:SetOrigin(localPlayerOrigin + destination:GetOrigin())
    -- end
	end


end



function OnTeleportEvent( eventSourceIndex, args )
  CustomNetTables:SetTableValue("teleport", "point", { value = args['key1'] })
  entity = Entities:FindByName(nil, "*teleport_trigger*")
  DoEntFireByInstanceHandle(entity, 'Enable', "", 0, nil, nil)
end
  CustomGameEventManager:RegisterListener( "teleport_event", OnTeleportEvent )