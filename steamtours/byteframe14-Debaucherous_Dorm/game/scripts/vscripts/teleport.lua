function Teleport(params)
  local hmd_anchor = params.activator:GetHMDAnchor()
  hmd_anchor:SetOrigin((hmd_anchor:GetOrigin() - params.activator:GetOrigin()) + thisEntity:GetChildren()[1]:GetOrigin())
end


