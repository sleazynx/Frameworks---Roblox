-- ServerLoader in ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ModuleLoader = require(ReplicatedStorage:WaitForChild("ModuleLoader") :: ModuleScript)

-- Load all server and global modules
ModuleLoader:Load()
print("Server modules loaded!")