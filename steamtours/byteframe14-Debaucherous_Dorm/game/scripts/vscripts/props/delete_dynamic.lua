local radius
function Activate()
  bounds = thisEntity:GetBounds()
  radius = math.max(abs(bounds["Mins"][1])+bounds["Maxs"][1], abs(bounds["Mins"][2])+bounds["Maxs"][2], abs(bounds["Mins"][3])+bounds["Maxs"][3])
end
function DeleteDynamic()
  for k,v in pairs(Entities:FindAllByClassnameWithin("prop_dynamic", thisEntity:GetAbsOrigin(), radius)) do
    if (string.find(v:GetModelName(), "shirt_line") or string.find(v:GetModelName(), "clotheshanger01")
    or string.find(v:GetModelName(), "nuke_tank_top") or string.find(v:GetModelName(), "nuke_overall")) then
      v:RemoveSelf()
    end
  end
end
function DeleteDynamicBed()
  for k,v in pairs(Entities:FindAllByClassnameWithin("prop_dynamic", thisEntity:GetAbsOrigin(), radius)) do
    if string.find(v:GetModelName(), "models/props/interior_furniture/interior_mattress")
    or string.find(v:GetModelName(), "models/props/interior_furniture/interior_bed_sheet") then
      v:RemoveSelf()
    end
  end
end
function DeleteDynamicUnderBed()
  local e = Entities:FindByNameNearest('*underbed_prop*', thisEntity:GetAbsOrigin(), radius)
  if e then
    e:RemoveSelf();
  end
end
function DeleteDynamicOnRug()
  local e = Entities:FindByNameNearest('*rug_prop*', thisEntity:GetAbsOrigin(), radius)
  if e then
    e:RemoveSelf();
  end
end