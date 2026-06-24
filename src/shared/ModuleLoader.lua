-- ModuleLoader in ReplicatedStorage

--[[ 
Structure Example

ReplicatedStorage
├─ ModuleLoader
├─ Modules
│   ├─ ModuleA
│   └─ ModuleB
│   └─ Data
│      └─ UpgradeData
ServerScriptService
└─ Modules
    ├─ Managers
    └─ ModuleD
        └─ Services
            └─ UpgradeDataStarterPlayer
StarterPlayerScripts
└─ Modules
    ├─ Controller
    └─ ModuleF
]]


local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ModuleLoader = {}
ModuleLoader.__index = ModuleLoader

local modules = {} -- full path => module
local shortPaths = {} -- relative path => module
local priorities = {} -- table of {module, priority, path}
local loaded = false

-- Helper: repeatedly load all ModuleScripts in a folder
local function loadFolder(folder, rootFolder)
    if not folder or not rootFolder then return end

    for _, descendant in ipairs(folder:GetDescendants()) do
        if descendant:IsA("ModuleScript") then
            local success, module = pcall(require, descendant)
            if success then
                local fullPath = descendant:GetFullName()
                modules[fullPath] = module

                -- Create short path relative to root folder
                local relativePath = descendant:GetFullName():sub(#rootFolder:GetFullName() + 2) -- +2 skips the dot
                shortPaths[relativePath] = module

                -- Determine priority
                local priority = type(module.Priority) == "number" and module.Priority or 0
                table.insert(priorities, {module = module, priority = priority, path = relativePath})

                print("Loaded module:", relativePath, "Priority:", priority)
            else
                warn("Failed to load module:", descendant:GetFullName(), module)
            end
        end
    end
end

-- Sort priorities descending (higher priority first)
local function sortByPriority()
    table.sort(priorities, function(a, b)
        return a.priority > b.priority
    end)
end

-- Run onLoad functions based on priority
local function runOnLoad()
    for _, entry in ipairs(priorities) do
        if type(entry.module.onLoad) == "function" then
            task.spawn(function()
                entry.module:onLoad()
                print("onLoad executed for:", entry.path)
            end)
        end
    end
end

-- Main loader
function ModuleLoader:Load()
    if loaded then return end

    local foldersToLoad = {}

    -- Shared modules
    local sharedFolder = ReplicatedStorage:FindFirstChild("Modules")
    if sharedFolder then table.insert(foldersToLoad, sharedFolder) end

    -- Server modules
    if RunService:IsServer() then
        local serverFolder = ServerScriptService:FindFirstChild("Modules")
        if serverFolder then table.insert(foldersToLoad, serverFolder) end
    else
        -- Client modules
        local player = Players.LocalPlayer
        if player then
            local playerScripts = player:WaitForChild("PlayerScripts")
            local clientFolder = playerScripts:FindFirstChild("Modules")
            if clientFolder then table.insert(foldersToLoad, clientFolder) end
        end
    end

    -- Load all folders recursively
    for _, folder in ipairs(foldersToLoad) do
        loadFolder(folder, folder)
    end

    -- Sort modules by priority and run onLoad
    sortByPriority()
    runOnLoad()

    loaded = true
    print("ModuleLoader: All modules loaded successfully!")
end

-- Retrieve module by short path (relative to Modules folder)
function ModuleLoader:Get(path)
    local module = shortPaths[path]
    if not module then
        warn("Module not found:", path)
        print(path)
    end
    return module
end

-- Wait for loading to finish
function ModuleLoader:WaitForLoad()
    while not loaded do
        task.wait()
    end
end

return ModuleLoader