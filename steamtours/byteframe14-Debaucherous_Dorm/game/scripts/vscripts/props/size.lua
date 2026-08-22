local tick
local scale
local reversing
local interval
local increment
local ticks
function Spawn()
  scale = math.floor(thisEntity:GetAbsScale() * 10^0 + 0.5) / 10^0
end
function Size(_reversing, _interval, _increment, _ticks)
  reversing = _reversing
  interval = _interval
  increment = _increment or 0.002
  ticks = _ticks or 0
  tick = 0
  if scale <= 0 then
    scale = 0.0
  end
  thisEntity:SetThink(function()
    if (ticks == 0 or tick < ticks) and ( (reversing and scale >= 0) or (not reversing and scale <= 1) ) then
      tick = tick + 1
      if not reversing then
        scale = scale + increment
      else
        scale = scale - increment
      end
      thisEntity:SetAbsScale(scale)
      return interval
    end
  end, 'size', 0.0)
end