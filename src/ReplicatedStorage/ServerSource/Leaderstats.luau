local leaderstats = {}

function leaderstats.Create(player)
	local stats = Instance.new("Folder")
	stats.Name = "leaderstats"
	stats.Parent = player

	local level = Instance.new("IntValue")
	level.Name = "Aura"
	level.Value = 1
	level.Parent = stats

	local exp = Instance.new("IntValue")
	exp.Name = "Exp"
	exp.Value = 0
	exp.Parent = stats
end

return leaderstats
