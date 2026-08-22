function OnPickedUp()
  thisEntity:SetThink(function()
    local hmd_avatar = Entities:FindByClassnameNearest('prop_hmd_avatar', thisEntity:GetAbsOrigin(), 8.0)
    if hmd_avatar then
      EmitSoundOn("alien_eating", hmd_avatar)
      OnDropped()
      thisEntity:RemoveSelf()
    else
      return 0.1
    end
  end, 'eat')
end
function OnDropped() thisEntity:SetThink(function() end, 'eat') end