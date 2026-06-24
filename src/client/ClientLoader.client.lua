-- ClientLoader in StarterPlayerScripts

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ModuleLoader = require(ReplicatedStorage:WaitForChild("ModuleLoader"))

-- Load all client and global modules
ModuleLoader:Load()
print("Client modules loaded!")