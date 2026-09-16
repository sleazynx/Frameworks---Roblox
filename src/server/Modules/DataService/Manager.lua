local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ModuleLoader = require(ReplicatedStorage:WaitForChild("ModuleLoader"))

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

local Template

function Manager:onLoad()
    Template = ModuleLoader:Get("DataService.Template")
end

local function deepCopy(tbl)
	local copy = {}

	for key, value in pairs(tbl) do
		if type(value) == "table" then
			copy[key] = deepCopy(value)
		else
			copy[key] = value
		end
	end

	return copy
end

local function resetTable(current, defaults, ignored)
	for key, defaultValue in pairs(defaults) do

		-- Skip ignored values
		if ignored[key] then
			continue
		end

		if type(defaultValue) == "table" then

			if type(current[key]) ~= "table" then
				current[key] = {}
			end

			resetTable(current[key], defaultValue, ignored)

		else
			current[key] = defaultValue
		end
	end
end

local function resolvePath(player: Player, path: string)
	local profile = Manager.Profiles[player]
	if not profile then print("Failed to find profile for player", player) return end

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

function Manager.ResetPlayer(player, ignoredStats)

	local profile = Manager.Profiles[player]
	if not profile then
		return
	end

	ignoredStats = ignoredStats or {}

	resetTable(profile.Data, Template, ignoredStats)

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
