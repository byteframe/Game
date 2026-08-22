local active = false
local ratio = 0.1
local speed = 0.1
local step = 0.1
local pause = 1.0
local interval = thisEntity:Attribute_GetFloatValue("jump_time", -1.0)*step
function Fan(i)
  interval = i*step
  speed = ratio
  reversing = false
  active = true
  thisEntity:SetThink(function()
    if not reversing then
      speed = speed + step
    else
      speed = speed - step
    end
    DoEntFireByInstanceHandle(thisEntity, "SetSpeed", tostring(speed), 0.0, self, self)
    if not reversing then
      if tostring(speed) == "1" then
        reversing = true
        return pause
      else
        return abs(interval)
      end
    elseif tostring(speed) == tostring(ratio) then
      active = false
      return nil
    else
      return abs(interval*0.5)
    end
  end, self, 0.0)
end