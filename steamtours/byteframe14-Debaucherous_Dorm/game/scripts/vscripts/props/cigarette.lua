require('_shared')
local burning = false
local damp = false
local last_exhalation = -1
local state = 6
function SetParticlePosition()
  ParticleManager:SetParticleControlEnt(thisEntity:Attribute_GetIntValue('fire_particle_id', -1), 0, hand_attachment or thisEntity, PATTACH_POINT_FOLLOW, "flame"..state, thisEntity:GetAttachmentOrigin(state), true)
end
function Activate() thisEntity:Attribute_SetIntValue('state', state) end
held = false
function OnPickedUp(self, hand)
  held = true
end
function OnDropped(self, hand)
  held = false
end
function _Burn()
  if not burning and state > 1 and not damp then
    burning = true
    thisEntity:SetSkin(1)
    thisEntity:Attribute_SetIntValue('fire_particle_id', ParticleManager:CreateParticle("particles/candyshop/env/fx_candleflame_01_c_smoke_cigarettte.vpcf", PATTACH_CUSTOMORIGIN, nil))
    SetParticlePosition()
    thisEntity:SetThink(function()
      Ignite(thisEntity:GetAttachmentOrigin(state))
      return 0.30
    end, 'ignite')
    thisEntity:SetThink(function()
      thisEntity:SetThink(function()
        last_exhalation = last_exhalation -1
        if last_exhalation < 1 and held then
          local hmd_avatar = Entities:FindByClassnameNearest('prop_hmd_avatar', thisEntity:GetAbsOrigin(), 12.0)
          if hmd_avatar then
            EmitSoundOn("focus_inhale", thisEntity)
            thisEntity:SetThink(function()
              local exhalation = ParticleManager:CreateParticle("particles/fireworks/rocket_exhaust_smoke_small.vpcf", PATTACH_CUSTOMORIGIN, nil)
              local hmd = hmd_avatar:GetAbsOrigin()
              ParticleManager:SetParticleControlEnt(exhalation, 0, hmd_avatar, PATTACH_CUSTOMORIGIN, nil, Vector(0.0, 0.0, hmd.z-6.0), true)
              EmitSoundOn("focus_exhale", hmd_avatar)
              last_exhalation = 10
              if RandomInt(0,3) == 3 then
                EmitSoundOn("teengirl_cough", hmd_avatar)
              end
            end, 'exhale', 1.0)
          end
        end
        return 1.0
      end, 'inhale')
    end, 'startInhale', 3.0)
    thisEntity:SetThink(function()
      state = state - 1
      thisEntity:Attribute_SetIntValue('state', state)
      thisEntity:SetSingleMeshGroup("meshGroup_"..state)
      SetParticlePosition()
      if state == 0 then
        _Extinquish(false)
      else
        return RandomFloat(6.0, 8.0)
      end
    end, 'burn', 8.0)
  end
end
function thisEntity:Burn() _Burn() end
function _Extinquish(_damp)
  burning = false
  damp = _damp
  if damp then
    thisEntity:SetRenderColor(160,150,150)
  end
  thisEntity:SetThink(function() end, 'ignite')
  thisEntity:SetThink(function() end, 'inhale')
  thisEntity:SetThink(function() end, 'burn')
  thisEntity:SetSkin(0)
  ParticleManager:DestroyParticle(thisEntity:Attribute_GetIntValue('fire_particle_id', -1), false)
  thisEntity:Attribute_SetIntValue('fire_particle_id', -1)
end
function thisEntity:Extinquish(_damp) _Extinquish(_damp) end