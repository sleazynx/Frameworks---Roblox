local test = {}
test.Priority = 10 -- This module runs early due to high priority

--[[ 
Retrieve other modules as such:

local ModuleLoader = require(game:GetService("ReplicatedStorage"):WaitForChild("ModuleLoader"))
local Data = ModuleLoader:Get("Service.Data")

-- Make sure ModuleLoader:Load() was called first. 
-- Preferably, ModuleLoader:Load() is called in ServerLoader or ClientLoader.

Note! you can still use the old require, but it's recommended to use the ModuleLoader's own retrieved function. 
This ensures the module is actually loaded before you try to use it.

If a module gets loaded first, but depends on another one, either:
1. Adjust the Priority of modules (recommended)
2. Or use ModuleLoader:WaitForLoad() to ensure all modules are loaded
]]

-- Optional: onLoad is executed automatically by the loader

function test.onLoad()
    print("Loaded hihi")
end

return test 