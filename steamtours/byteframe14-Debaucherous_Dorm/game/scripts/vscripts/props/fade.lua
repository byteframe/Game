local start
local target
local alpha
local duration
local steps
local lowering
local active = 0
function SetAlpha(init)
  if alpha > 0  and init then
    DoEntFireByInstanceHandle(thisEntity, 'Enable', "", 0, nil, nil)
  elseif alpha <= 0 then
    DoEntFireByInstanceHandle(thisEntity, 'Disable', "", 0, nil, nil)
  end
  thisEntity:SetRenderAlpha(alpha)
end
function Fade(_duration, _start, _target, _steps, delay, init)
  if active == 0 then
    active = 1
    duration = _duration or 2.5
    start = _start or 255
    target = _target or 0
    alpha = _start or 255
    steps = _steps or 5
    delay = delay or 0.0
    init = init or false
    lowering = start > target or false
    if init then
      SetAlpha(true)
    end
    thisEntity:SetThink(function()
      if lowering then
        alpha = alpha - steps
      else
        alpha = alpha + steps
      end
      if lowering and alpha >= target then
        SetAlpha()
        return duration/abs(start-target/steps)
      elseif not lowering and alpha <= target then
        SetAlpha()
        return duration/abs(start-target/steps)
      else
        active = 0
      end
    end, self, delay)
  end
end