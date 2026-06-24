# Frameworks - Roblox Modular Ecosystem

A lightweight, scalable, and decoupled game framework for Roblox Studio designed to optimize game infrastructure. Built with an external workflow focus using **Rojo**, **Wally**, and **ProfileService**, this ecosystem allows you to build reusable modules that drop seamlessly into any project.

---

## Key Framework Features

* **Priority-Based Script Bootstrapping:** Automatically scans, compiles, and loads `ModuleScripts` across shared, server, and client boundaries. Modules use custom execution hooks based on assigned priorities.
* **Deep-Path Data Architecture:** Wraps your player profiles with a dynamic path resolver. Instead of tracking flat indices, look up or mutate nested properties cleanly using a path string (e.g., `"Business/LemonStand/Level"`).
* **Robust Session Management:** Built directly on top of ProfileService, ensuring data resilience against duplicate server logging or sudden network disconnects.

---

## Repository Structure

```text
src/
├── shared/
│   └── ModuleLoader.lua       # Core framework dependency injection logic
│
├── server/
│   ├── ServerLoader.server.lua # Main server bootstrap initializer
│   └── Modules/
│       └── DataService/       # Componentized player profile service
│           ├── DataService.lua
│           ├── Manager.lua
│           └── Template.lua
│
└── client/
    └── ClientLoader.client.lua # Main client bootstrap initializer
```

---

## Getting Started & Installation

To initialize, compile, and synchronize this architecture locally into a Roblox Studio session, configure your local environment using the following steps:

1. **Clone the repository:**
```bash
git clone [https://github.com/sleazynx/Frameworks---Roblox.git](https://github.com/sleazynx/Frameworks---Roblox.git)

```

2. **Install external packages (ProfileService, etc.) via Wally:**
```bash
wally install

```

3. **Build the Roblox Place file from scratch:**
```bash
rojo build -o "Frameworks.rbxlx"

```

4. **Start the local Rojo synchronization engine:**
```bash
rojo serve

```

5. Open the newly generated `Frameworks.rbxlx` file inside Roblox Studio, open your Rojo plugin, and click **Connect** to begin active code synchronization.

For more technical help with your environment compiler, check out [the Rojo documentation](https://rojo.space/docs).

---

## Code Examples

### 1. Creating a Component Module

Your modules can specify a `.Priority` number. The `ModuleLoader` automatically sorts them (higher numbers run first) and executes an optional `.onLoad()` function asynchronously.

```lua
local InventoryService = {}
InventoryService.Priority = 50 -- Fires early based on load dependencies

function InventoryService.onLoad()
    print("Inventory system successfully initialized by framework!")
end

return InventoryService

```

### 2. Modifying Deeply Nested Player Statistics

Reach deeply nested data blocks anywhere instantly using unified paths:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ModuleLoader = require(ReplicatedStorage:WaitForChild("ModuleLoader"))

local DataManager = ModuleLoader:Get("DataService/Manager")

-- Modify data layers smoothly without breaking types or flat indexes
DataManager.AddValue(player, "Business/LemonStand/Level", 1)
DataManager.SetValue(player, "Business/SmallShop/Unlocked", true)
DataManager.AddValue(player, "PlayerStats/Cash", 500)

```

---

## Submitting System Requests

We are actively expanding this codebase into a comprehensive library of universal game components (e.g., weighted loot tables, interaction components via CollectionService tags, UI spring tweens).

If there is a core gameplay loop or utility mechanic you find yourself constantly rewriting across your games, please navigate to the **Issues** tab and submit a **Feature Request** using our public community template!

```

```