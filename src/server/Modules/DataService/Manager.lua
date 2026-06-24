local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Remotes

local Manager = {}
Manager.Profiles = {}

--[[
Converts string path "PlayerData/Level/Exp" into usable table reference like 
PlayerData = {
	Level = {
		Exp = 0,
		MaxExp = 100,
		Level = 1
	}
} ]]--

local function resolvePath(player: Player, path: string)
	local profile = Manager.Profiles[player]
	if not profile then return end

	local keys = string.split(path, "/")
	local current = profile.Data

	-- key[1] = PlayerData
	-- key[2] = Level
	-- key[3] = Exp
	-- #key = 3

	for i = 1, #keys - 1 do 
		current = current[keys[i]]
		if type(current) ~= "table" then return nil, nil end
	end

	local finalkey = keys[#keys] -- finalkey = Exp
	return current, finalkey
end

function Manager.AddValue(player: Player, path: string, amount: number)
	local targetTable, key = resolvePath(player, path)
	if targetTable and targetTable[key] ~= nil then
		targetTable[key] += amount
	end
end

function Manager.RemoveValue(player: Player, path: string, amount: number)
	local targetTable, key = resolvePath(player, path)
	if targetTable and targetTable[key] ~= nil then
		targetTable[key] -= amount
	end
end

function Manager.MultiplyValue(player: Player, path: string, amount: number)
	local targetTable, key = resolvePath(player, path)
	if targetTable and targetTable[key] ~= nil then
		targetTable[key] *= amount
	end
end

function Manager.SetValue(player: Player, path: string, value: any)
	local targetTable, key = resolvePath(player, path)
	if targetTable then
		targetTable[key] = value
	end
end

-- Accessor
function Manager.GetData(player: Player, path: string)
	local targetTable, key = resolvePath(player, path)
	if targetTable then
		return targetTable[key]
	end
end

-- Safe Remote Invocation Handling
Remotes.GetData.OnServerInvoke = function(player: Player, path: string)
	return Manager.GetData(player, path)
end

return Manager
