function _Censor(enable)
  for _,entity in pairs(Entities:FindAllByName("*dvdnope*")) do
    DoEntFireByInstanceHandle(entity, enable, "", 0, nil, nil)
  end
  for _,entity in pairs(Entities:FindAllByName("*scan*")) do
    DoEntFireByInstanceHandle(entity, enable, "", 0, nil, nil)
  end
  for _,entity in pairs(Entities:FindAllByName("*lewd*")) do
    DoEntFireByInstanceHandle(entity, enable, "", 0, nil, nil)
  end
  for _,entity in pairs(Entities:FindAllByName("*ragdoll*")) do
    DoEntFireByInstanceHandle(entity, enable, "", 0, nil, nil)
  end
end
function Uncensor()
  _Censor('Enable')
end
function Censor()
  _Censor('Disable')
end
function OnCensorEvent(eventSourceIndex, args )
  CustomNetTables:SetTableValue("censor", "enable", { value = args['key1'] })
  _Censor(args['key1'])
end
local changing_level = false
function OnChangelevelEvent(eventSourceIndex, args)
  if not changing_level then
    changing_level = true
    if GetMapName() == 'byteframe13' then
      SendToServerConsole("destinations_load_addon 3482263834 byteframe13_alpha");
    elseif GetMapName() == 'byteframe13_alpha' then
      SendToServerConsole("destinations_load_addon 3482263834 byteframe13_beta");
    elseif GetMapName() == 'byteframe13_beta' then
      SendToServerConsole("destinations_load_addon 3482263834 byteframe13_delta");
    elseif GetMapName() == 'byteframe13_delta' then
      SendToServerConsole("destinations_load_addon 3482263834 byteframe13_epsilon");
    elseif GetMapName() == 'byteframe13_epsilon' then
      SendToServerConsole("destinations_load_addon 3482263834 byteframe13_gamma");
    elseif GetMapName() == 'byteframe13_gamma' then
      SendToServerConsole("destinations_load_addon 3482263834 byteframe13_zeta");
    elseif GetMapName() == 'byteframe13_zeta' then
      SendToServerConsole("destinations_load_addon 3482263834 byteframe13_eta");
    elseif GetMapName() == 'byteframe13_eta' then
      SendToServerConsole("destinations_load_addon 3482263834 byteframe13_theta");
    elseif GetMapName() == 'byteframe13_theta' then
      SendToServerConsole("destinations_load_addon 3482263834 byteframe13_kappa");
    elseif GetMapName() == 'byteframe13_kappa' then
      SendToServerConsole("destinations_load_addon 3482263834 byteframe13_iota");
    elseif GetMapName() == 'byteframe13_iota' then
      SendToServerConsole("destinations_load_addon 3482263834 byteframe13_alpha");
    end
  end
end
function Activate()
  Convars:RegisterCommand('uncensor', Uncensor, 'uncensor', 0)
  Convars:RegisterCommand('censor', Censor, 'censor', 0)
  CustomGameEventManager:RegisterListener("changelevel_event", OnChangelevelEvent )
  CustomGameEventManager:RegisterListener("censor_event", OnCensorEvent )
end
