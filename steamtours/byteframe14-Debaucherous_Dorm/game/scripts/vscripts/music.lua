require('_shared')
math.randomseed(Time())
local tracks = { 0, {
  { 205, "Paul_Blackford__Spectrums__Sepia" },
  {  60, "Paul_Blackford__Vapor_Waves__Future_Acceleration" },
  {  60, "Paul_Blackford__Electro_Mysteries__Ice_Kingdom" },
  {  60, "Paul_Blackford__Electro_Mysteries__Heist_Highway" },
  {  60, "Paul_Blackford__Vapor_Waves_2__Cloud_Robotics" },
  {  60, "Paul_Blackford__Vapor_Waves_2__Artificial_Architecture" },
  { 164, "Paul_Blackford__Night_Shift__Esprit" },
  { 163, "Paul_Blackford__Night_Shift__Night_Shift" },
  { 183, "Paul_Blackford__Betamax__Business_Class" },
  { 186, "Paul_Blackford__Night_Shift__Smooth_My_Soul" },
  { 183, "Paul_Blackford__Original_Concept__Super_Fruhstuck" },
  { 193, "Paul_Blackford__Betamax__The_Homestretch" },
  { 192, "Paul_Blackford__Spectrums__Spectrums" },
  { 196, "Paul_Blackford__Night_Shift__Affogato" },
  { 201, "Paul_Blackford__Inception_EP__Eternity" },
  { 119, "Paul_Blackford__Betamax__Betamax" },
  { 202, "Paul_Blackford__Spectrums__Calipso" },
  { 203, "Paul_Blackford__Horizons__Rhythm_Quest" },
  { 203, "Paul_Blackford__Spectrums__Antartica" },
  { 205, "Paul_Blackford__Spectrums__Night_Crawler" },
  { 203, "Paul_Blackford__Betamax__Fortress" },
  { 203, "Paul_Blackford__Betamax__Neon_Shores" },
  { 203, "Paul_Blackford__Betamax__Footprints" },
  { 208, "Paul_Blackford__Betamax__Helix" },
  { 205, "Paul_Blackford__Betamax__Vindicators", },
  { 203, "Paul_Blackford__Light_Years__Hired_Guns" },
  { 219, "Paul_Blackford__Inception_EP__Fort_Neuro" },
  { 216, "Paul_Blackford__Horizons__Proteus_2" },
  { 225, "Paul_Blackford__Horizons__Nimbus" },
  { 225, "Paul_Blackford__Original_Concept__Friendly_Fyah" },
  { 268, "Paul_Blackford__Emma__October" },
} }
function Activate()
  Convars:RegisterCommand('change_music_track', ChangeMusicTrack, 'change_music_track', 0)
  ListenToGameEvent("player_connect", ChangeMusicTrack, nil)
  thisEntity:SetThink(ChangeMusicTrackThink, 'music', track_fade)
end
local track_change = false
local track_time = 999
local track = { -1, "" }
local track_fade = 3.0
function ChangeMusicTrack() track_change = true end
function ChangeMusicTrackThink()
  if track_change or track_time >= track[1]-track_fade then
    track_change = false
    if track_time == 999 then
      track = tracks[2][1]
    else
      track = pick(tracks)
    end
    track_time = 0
    print(track[2])
    DoEntFireByInstanceHandle(Entities:FindByName(nil, 'music_soundevent'), 'StopSound', '', 0.0, self, self)
    DoEntFireByInstanceHandle(Entities:FindByName(nil, 'music_soundevent'), 'SetSoundEventName', track[2], track_fade+0.25, self, self)
    DoEntFireByInstanceHandle(Entities:FindByName(nil, 'music_soundevent'), 'StartSound', '', track_fade+0.5, self, self)
    return track_fade+1.5
  else
    track_time = track_time+1
    return 1.0
  end
end