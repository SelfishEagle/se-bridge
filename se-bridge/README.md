# SE-Bridge - Universal Framework Bridge

A comprehensive bridge script for FiveM that provides a unified API across multiple frameworks and inventory systems.

**Current Version:** 1.0.0  
**Automatic Updates:** Configured via GitHub Releases

## Supported Frameworks
- **ox_core** - Full support
- **qbx_core** - Full support
- **qb-core** - Full support
- **ESX (es_extended)** - Full support
- **se_core** - Ready for your custom framework (template included)
- **Standalone** - Fallback mode when no framework is detected

## Supported Inventory Systems
- **ox_inventory**
- **qb-inventory**
- **ps-inventory**
- **qs-inventory**
- **core_inventory**
- Framework default inventories

## Installation

1. Download or clone this repository
2. Place the `se-bridge` folder in your FiveM resources directory
3. **Important:** Update `version_config.lua` with your GitHub username (see [GITHUB_SETUP.md](GITHUB_SETUP.md))
4. Add `ensure se-bridge` to your server.cfg **BEFORE** any scripts that use it
5. Restart your server

```cfg
# Example server.cfg
ensure ox_core  # or your framework
ensure ox_inventory  # or your inventory system
ensure se-bridge  # <-- Load this before your scripts
ensure your-script-here
```

## Features

### Automatic Detection
- Automatically detects which framework is running
- Automatically detects which inventory system is installed
- No configuration needed for supported frameworks
- Extensible for custom frameworks

### Universal API
Write your scripts once, and they'll work across all supported frameworks:

```lua
-- Instead of writing framework-specific code:
if Framework == 'ESX' then
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addMoney(100)
elseif Framework == 'QB' then
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney('cash', 100)
end

-- Write universal code:
exports['se-bridge']:AddMoney(source, 'cash', 100)
```

## Client-Side Functions

### Player Data
```lua
-- Get all player data
local playerData = exports['se-bridge']:GetPlayerData()

-- Get player job
local job = exports['se-bridge']:GetPlayerJob()
-- Returns: { name = 'police', grade = { level = 2, name = 'Officer' } }

-- Get player gang (if applicable)
local gang = exports['se-bridge']:GetPlayerGang()

-- Get player money
local cashAmount = exports['se-bridge']:GetPlayerMoney('cash')
local bankAmount = exports['se-bridge']:GetPlayerMoney('bank')

-- Get player identifier
local identifier = exports['se-bridge']:GetPlayerIdentifier()

-- Check if player has job
local hasJob = exports['se-bridge']:HasJob('police')
local hasJobWithGrade = exports['se-bridge']:HasJob('police', 2)
local hasMultipleJobs = exports['se-bridge']:HasJob({'police', 'ambulance'})
```

### Notifications
```lua
-- Simple notification
exports['se-bridge']:Notify('Hello World!', 'success', 5000)
-- Types: 'success', 'error', 'info', 'warning'

-- Advanced notification
exports['se-bridge']:NotifyAdvanced({
    title = 'Title Here',
    description = 'Message here',
    type = 'success',
    duration = 5000
})

-- Help notification
exports['se-bridge']:ShowHelpNotification('Press ~INPUT_CONTEXT~ to interact')
```

### Progress Bars
```lua
exports['se-bridge']:ProgressBar({
    duration = 5000,
    label = 'Doing something...',
    useWhileDead = false,
    canCancel = true,
    disable = {
        move = true,
        car = true,
        combat = true
    },
    anim = {
        dict = 'amb@world_human_hammering@male@base',
        clip = 'base'
    },
    onFinish = function()
        print('Finished!')
    end,
    onCancel = function()
        print('Cancelled!')
    end
})
```

### 3D Text
```lua
-- Draw 3D text at coordinates
local coords = vector3(0.0, 0.0, 0.0)
exports['se-bridge']:DrawText3D(coords, 'Text here')
```

### Inventory
```lua
-- Check if player has item
local hasItem = exports['se-bridge']:HasItem('water', 1)

-- Open inventory
exports['se-bridge']:OpenInventory('stash', {
    id = 'mystash',
    label = 'My Stash'
})
```

## Server-Side Functions

### Player Management
```lua
-- Get player object
local player = exports['se-bridge']:GetPlayer(source)

-- Get player identifier
local identifier = exports['se-bridge']:GetPlayerIdentifier(source)

-- Get player name
local name = exports['se-bridge']:GetPlayerName(source)

-- Get player job
local job = exports['se-bridge']:GetPlayerJob(source)

-- Get player gang
local gang = exports['se-bridge']:GetPlayerGang(source)

-- Check if player has job
local hasJob = exports['se-bridge']:HasJob(source, 'police', 2)

-- Get all players
local players = exports['se-bridge']:GetPlayers()

-- Get players by job
local cops = exports['se-bridge']:GetPlayersByJob('police')
```

### Money Management
```lua
-- Get player money
local cash = exports['se-bridge']:GetPlayerMoney(source, 'cash')
local bank = exports['se-bridge']:GetPlayerMoney(source, 'bank')

-- Add money
exports['se-bridge']:AddMoney(source, 'cash', 100, 'Paycheck')

-- Remove money
exports['se-bridge']:RemoveMoney(source, 'bank', 50, 'Purchase')
```

### Inventory Management
```lua
-- Add item
exports['se-bridge']:AddItem(source, 'water', 1, {quality = 100})

-- Remove item
exports['se-bridge']:RemoveItem(source, 'water', 1)

-- Check if player has item
local hasItem = exports['se-bridge']:HasItem(source, 'water', 1)

-- Get item count
local count = exports['se-bridge']:GetItemCount(source, 'water')

-- Get item data
local item = exports['se-bridge']:GetItem(source, 'water')

-- Check if player can carry item
local canCarry = exports['se-bridge']:CanCarryItem(source, 'water', 5)

-- Register a stash
exports['se-bridge']:RegisterStash('mystash', 'My Stash', 50, 100000)
```

### Notifications (Server)
```lua
-- Notify a player
exports['se-bridge']:Notify(source, 'Message here', 'success', 5000)
```

### Callbacks
```lua
-- Create a callback
exports['se-bridge']:CreateCallback('myScript:getData', function(source, data)
    -- Process data
    return {success = true, data = someData}
end)

-- Call from client:
-- lib.callback.await('myScript:getData', false, {someData})
```

### Usable Items
```lua
-- Register usable item
exports['se-bridge']:RegisterUsableItem('water', function(source, item, metadata)
    print('Player ' .. source .. ' used water')
    exports['se-bridge']:RemoveItem(source, 'water', 1)
    -- Do something
end)
```

## Direct Access to Bridge

You can also access the bridge directly in your scripts:

```lua
-- Get the bridge object
local Bridge = exports['se-bridge']:GetBridge()

-- Get framework name
local frameworkName = exports['se-bridge']:GetFrameworkName()
print('Running on: ' .. frameworkName)
```

## Adding Your Custom Framework

To add support for your custom framework (`se_core`), edit these files:

1. **config.lua** - Already configured with `se_core`
2. **bridge/shared.lua** - Update `GetFrameworkObject()` function
3. **bridge/client.lua** - Add your framework's client functions
4. **bridge/server.lua** - Add your framework's server functions

Example for `se_core`:
```lua
elseif framework == 'se_core' then
    return exports.se_core:GetCoreObject()
```

## Configuration

Edit `config.lua` to customize:
- Framework detection priority
- Framework resource names
- Debug mode
- Notification settings

## Debug Mode

Enable debug mode in `config.lua` to see detailed information:
```lua
Config.Debug = true
```

This will print framework detection and bridge operations to the console.

## Examples

See `examples.lua` for complete examples of:
- Creating a simple shop system
- Player management
- Inventory operations
- Job checks
- And more!

## Support

For issues, questions, or contributions, please open an issue on GitHub.

## License

This bridge is open source and free to use in your FiveM projects.

---
