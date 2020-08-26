door = nil;
tparea = nil;

function activate()
  local doors = Entities:FindAllByClassname( 'prop_dynamic' )
  for _, entity in ipairs( doors ) do
    door = entity;
  end
  EntFireByHandle( self, door, "SetPlaybackRate", "0.0", 0.001 )
  EntFireByHandle( self, door, "SetAnimation", "door_open_combined" )
  door:RedirectOutput( "OnAnimationDone", "OnLatchDone", thisEntity )
  local remappers = Entities:FindAllByClassname( 'point_value_remapper' )
  for _, entity in ipairs( remappers ) do
    print( entity:GetName() )
    entity:RedirectOutput( 'OnEngage', 'OnEngage', thisEntity )
    entity:RedirectOutput( 'OnDisengage', 'OnDisengage', thisEntity )
  end
  local tpareas = Entities:FindAllByClassname( 'vr_teleport_area' )
  for _, entity in ipairs( tpareas ) do
    if entity:GetName() == 'door_0_area' then
      print( entity:GetName() )
      tparea = entity
    end
  end
end

function OnLatchDone( )
  print( 'OnLatchDone()' )
	door:DisconnectRedirectedOutput( "OnAnimationDone", "OnLatchDone", thisEntity )
  EntFireByHandle( self, tparea, "Enable", "", 1.0 )
   turn light off
end

function OnDisengage( )
  EntFireByHandle( self, door, "SetPlaybackRate", "-1.0", 0.001 )
end

function OnEngage( )
  EntFireByHandle( self, door, "SetPlaybackRate", "1.0", 0.001 )
end

-- by names!?
-- get sounds working hopefully in point remapper
-- name everything, door, remapper, light, tp mesh, etc


