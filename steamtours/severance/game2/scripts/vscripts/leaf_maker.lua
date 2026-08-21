function Execute()
  local leaves = {};
  for k,v in pairs(Entities:FindAllByClassname('prop_destinations_physics')) do
    if string.find(v:GetModelName(), 'leaf_') then
      table.insert(leaves, v);
    end
  end
  if #leaves > 36 then
    leaves[RandomInt(1, #leaves)]:RemoveSelf()
  end
  thisEntity:SpawnEntity();
end