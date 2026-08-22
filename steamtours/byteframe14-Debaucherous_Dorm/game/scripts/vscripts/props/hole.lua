local speed = 0
local new_speed = 0
local active = false
local stopping = false
local stopping_speed = 2
function StartThink()
  if RandomInt(0,4) == 1 then
    thisEntity:GetChildren()[1]:SetSkin(1)
  else
    thisEntity:GetChildren()[1]:SetSkin(0)
  end
  speed = stopping_speed
  new_speed = stopping_speed
  thisEntity:SetThink(function()
    active = true
    if not stopping and speed == new_speed then
      new_speed = RandomInt(3,10)
    end
    if new_speed > speed then
      speed = speed + 1
    elseif new_speed < speed then
      speed = speed - 1
    end
    DoEntFireByInstanceHandle(thisEntity, "SetSpeed", tostring(speed), 0.0, self, self)
    if stopping and speed == new_speed then
      active = false
      thisEntity:SetThink("StartThink", self, 1.0)
    end
    if active then
      return 1.5
    end
  end, self, 0.0)
end
function StopThink()
  new_speed = stopping_speed
  stopping = true
end