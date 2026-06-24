local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ModuleLoader = require(ReplicatedStorage:WaitForChild("ModuleLoader") :: ModuleScript)

local DataService = {}
DataService.Priority = 100 -- High priority so data loads before other systems start

function DataService.onLoad()
    -- Safely retrieve our internal modules via the loader or relative paths
    local ProfileService = require(ServerScriptService.ServerPackages.ProfileService :: ModuleScript)
    local Template = ModuleLoader:Get("DataService.Template")
    local Manager = ModuleLoader:Get("DataService.Manager")

    local ProfileStore = ProfileService.GetProfileStore("PlayerData", Template) 

    local function GiveStats(player: Player)
        local profile = Manager.Profiles[player]
        if not profile then return end
        
        local leaderstats = Instance.new("Folder")
        leaderstats.Name = "leaderstats"
        leaderstats.Parent = player

        local Cash = Instance.new("NumberValue")
        Cash.Name = "Cash"
        Cash.Value = profile.Data.PlayerStats.Cash
        Cash.Parent = leaderstats
    end

    local function PlayerAdded(player: Player)
        local profile = ProfileStore:LoadProfileAsync("Player_"..player.UserId)
        if profile == nil then
            player:Kick("Data Issue, try again later.")
            return
        end
        
        profile:AddUserId(player.UserId)
        profile:Reconcile()
        profile:ListenToRelease(function()
            Manager.Profiles[player] = nil
            player:Kick("Data Issue, try again later.")
        end)
        
        if player:IsDescendantOf(Players) then
            Manager.Profiles[player] = profile
            GiveStats(player)
        else
            profile:Release()
        end
    end

    for _, player in Players:GetPlayers() do
        task.spawn(PlayerAdded, player)
    end

    Players.PlayerAdded:Connect(PlayerAdded)

    Players.PlayerRemoving:Connect(function(player: Player)
        local profile = Manager.Profiles[player]
        if not profile then return end
        profile:Release()
    end)
end

return DataService