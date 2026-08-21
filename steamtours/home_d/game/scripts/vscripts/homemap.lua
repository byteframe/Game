
local NUM_BACKGROUNDS = 6;
local m_nCurrentBackground = 1;
local m_flNextBackgroundUpdate = 0;

local m_flStartChangeFloorColor = 0;
local m_flEndChangeFloorColor = 0;

local m_currentFloorColor = Vector( 255, 255, 255 );
local m_prevFloorColor = Vector( 255, 255, 255 );
local m_nextFloorColor = Vector( 255, 255, 255 );

local m_floor = nil;
local m_floorHatch1 = nil;
local m_floorHatch2 = nil;
local m_floorHatch3 = nil;
local m_floorHatch4 = nil;
local m_lever = nil;
local floorColors = {}
floorColors[1] = Vector( 99, 99, 57 );
floorColors[2] = Vector( 53, 62, 67 );
floorColors[3] = Vector( 54, 70, 86 );
floorColors[4] = Vector( 124, 139, 144 );
floorColors[5] = Vector( 28, 36, 40 );
floorColors[6] = Vector( 60, 60, 70 );

-- 1 - 97, 97, 45
-- 2 - 53, 62, 67
-- 3 - 54, 70, 86
-- 4 - 124, 139, 144
-- 5 - 14, 41, 110
-- 6 - 60, 60, 70

function OnPlayerSpawned()
	m_floor = Entities:FindByName( nil, "floor" );
	m_floorHatch1 = Entities:FindByName( nil, "floor_hatch1" );
	m_floorHatch2 = Entities:FindByName( nil, "floor_hatch2" );
	m_floorHatch3 = Entities:FindByName( nil, "floor_hatch3" );
	m_floorHatch4 = Entities:FindByName( nil, "floor_hatch4" );
	m_lever = Entities:FindByName( nil, "lever01" );

	--PickRandomBackground();
	m_nCurrentBackground = RandomInt( 1, NUM_BACKGROUNDS );
	DoEntFire( "landscape", "SetDefaultAnimation", "Morph_0"..m_nCurrentBackground.."_end", 0, nil, nil );
	DoEntFire( "landscape", "SetSequence", "Morph_0"..m_nCurrentBackground.."_end", 0.01, nil, nil );

	DoEntFire( "soundscape_"..m_nCurrentBackground, "Enable", "", 0.1, nil, nil );
	
	local r = floorColors[m_nCurrentBackground].x;
	local g = floorColors[m_nCurrentBackground].y;
	local b = floorColors[m_nCurrentBackground].z;
		
	m_floor:SetRenderColor( r, g, b );
	m_floorHatch1:SetRenderColor( r, g, b );
	m_floorHatch2:SetRenderColor( r, g, b );
	m_floorHatch3:SetRenderColor( r, g, b );
	m_floorHatch4:SetRenderColor( r, g, b );
	m_lever:SetRenderColor( r, g, b );

	m_flNextBackgroundUpdate = Time() + RandomFloat( 18, 25 );

	GameRules:GetGameModeEntity():SetThink( CycleBackgroundThink );
end

function SetBackground( nIndex )
	if ( nIndex < 1 or nIndex > NUM_BACKGROUNDS ) then
		print( "SetBackground called, but index was out of range! ("..nIndex..")" );
		return;
	end

	local szSequenceName = "Morph_0"..nIndex;
	print( "SetBackground - "..szSequenceName );
	DoEntFire( "landscape", "SetDefaultAnimation", "Morph_0"..nIndex.."_end", 0, nil, nil );
	DoEntFire( "landscape", "SetSequence", "Morph_0"..nIndex, 0.01, nil, nil );
	
	for i=1, 6, 1 do
        DoEntFire( "soundscape_"..i, "Disable", "", 2.0, nil, nil );
    end
	
	DoEntFire( "soundscape_"..nIndex, "Enable", "", 27.0, nil, nil );
end

function CycleBackgroundThink()

	if ( m_flNextBackgroundUpdate < Time() ) then
		-- set the previous floor color before we increment
		m_prevFloorColor = floorColors[m_nCurrentBackground];

		-- increment the background index
		m_nCurrentBackground = m_nCurrentBackground + 1;
		if ( m_nCurrentBackground > NUM_BACKGROUNDS ) then
			-- do mod work?  loop around if we exceed the max
			m_nCurrentBackground = 1;
		end

		m_nextFloorColor = floorColors[m_nCurrentBackground];

		SetBackground( m_nCurrentBackground );

		m_flNextBackgroundUpdate = Time() + RandomFloat( 66, 75 );

		m_flStartChangeFloorColor = Time();
		m_flEndChangeFloorColor = m_flStartChangeFloorColor + 60;
	end

	if ( m_flStartChangeFloorColor < Time() and m_flEndChangeFloorColor > Time() ) then
		local flFrac = (Time() - m_flStartChangeFloorColor) / (m_flEndChangeFloorColor - m_flStartChangeFloorColor);

		local xColor = m_prevFloorColor.x + ((m_nextFloorColor.x - m_prevFloorColor.x)*flFrac);
		local yColor = m_prevFloorColor.y + ((m_nextFloorColor.y - m_prevFloorColor.y)*flFrac);
		local zColor = m_prevFloorColor.z + ((m_nextFloorColor.z - m_prevFloorColor.z)*flFrac);
		xColor = math.floor(xColor);
		yColor = math.floor(yColor);
		zColor = math.floor(zColor);

		--print( "FRACTION = "..flFrac..", COLOR = ("..xColor..", "..yColor..", "..zColor..")" );

		m_floor:SetRenderColor( xColor, yColor, zColor );
		m_floorHatch1:SetRenderColor( xColor, yColor, zColor );
		m_floorHatch2:SetRenderColor( xColor, yColor, zColor );
		m_floorHatch3:SetRenderColor( xColor, yColor, zColor );
		m_floorHatch4:SetRenderColor( xColor, yColor, zColor );
		m_lever:SetRenderColor( xColor, yColor, zColor );

	end

	return 0.1;
end