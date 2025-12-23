-- SE-Bridge Usage Examples
-- This file demonstrates how to use se-bridge in your scripts

--[[
    IMPORTANT: Add se-bridge as a dependency in your fxmanifest.lua:
    
    dependencies {
        'se-bridge'
    }
]]

-- ========================================
-- CLIENT-SIDE EXAMPLES
-- ========================================

-- Example 1: Get Player Job and Check
RegisterCommand('checkjob', function()
    local job = exports['se-bridge']:GetPlayerJob()
    
    if job then
        exports['se-bridge']:Notify('Your job: ' .. job.name .. ' - Grade: ' .. job.grade.level, 'info')
    else
        exports['se-bridge']:Notify('No job data found', 'error')
    end
end)

-- Example 2: Check if player has a specific job
RegisterCommand('amicop', function()
    local isCop = exports['se-bridge']:HasJob('police')
    
    if isCop then
        exports['se-bridge']:Notify('You are a police officer!', 'success')
    else
        exports['se-bridge']:Notify('You are not a police officer', 'error')
    end
end)

-- Example 3: Check multiple jobs with grade requirement
RegisterCommand('checkemergency', function()
    local isEmergency = exports['se-bridge']:HasJob({'police', 'ambulance', 'fire'}, 2)
    
    if isEmergency then
        exports['se-bridge']:Notify('You are emergency services with grade 2+', 'success')
    else
        exports['se-bridge']:Notify('You are not qualified emergency services', 'error')
    end
end)

-- Example 4: Get Player Money
RegisterCommand('checkmoney', function()
    local cash = exports['se-bridge']:GetPlayerMoney('cash')
    local bank = exports['se-bridge']:GetPlayerMoney('bank')
    
    exports['se-bridge']:NotifyAdvanced({
        title = 'Your Money',
        description = 'Cash: $' .. cash .. '\nBank: $' .. bank,
        type = 'info',
        duration = 5000
    })
end)

-- Example 5: Progress Bar with Animation
RegisterCommand('testprogress', function()
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
            exports['se-bridge']:Notify('Completed!', 'success')
        end,
        onCancel = function()
            exports['se-bridge']:Notify('Cancelled!', 'error')
        end
    })
end)

-- Example 6: 3D Text (use in a loop)
CreateThread(function()
    local coords = vector3(0.0, 0.0, 30.0) -- Example coordinates
    
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - coords)
        
        if distance < 10.0 then
            exports['se-bridge']:DrawText3D(coords, 'Press ~g~E~w~ to interact')
        end
        
        Wait(0)
    end
end)

-- Example 7: Check Inventory Item
RegisterCommand('checkwater', function()
    local hasWater = exports['se-bridge']:HasItem('water', 1)
    
    if hasWater then
        exports['se-bridge']:Notify('You have water!', 'success')
    else
        exports['se-bridge']:Notify('You need water!', 'error')
    end
end)

-- ========================================
-- SERVER-SIDE EXAMPLES
-- ========================================

-- Example 8: Give Money to Player
RegisterCommand('givemoney', function(source, args)
    if not args[1] or not args[2] then
        return exports['se-bridge']:Notify(source, 'Usage: /givemoney [amount] [type]', 'error')
    end
    
    local amount = tonumber(args[1])
    local moneyType = args[2] or 'cash'
    
    if exports['se-bridge']:AddMoney(source, moneyType, amount, 'Admin Command') then
        exports['se-bridge']:Notify(source, 'Added $' .. amount .. ' ' .. moneyType, 'success')
    else
        exports['se-bridge']:Notify(source, 'Failed to add money', 'error')
    end
end, true)

-- Example 9: Give Item to Player
RegisterCommand('giveitem', function(source, args)
    if not args[1] or not args[2] then
        return exports['se-bridge']:Notify(source, 'Usage: /giveitem [item] [amount]', 'error')
    end
    
    local item = args[1]
    local amount = tonumber(args[2])
    
    if exports['se-bridge']:AddItem(source, item, amount) then
        exports['se-bridge']:Notify(source, 'Added ' .. amount .. 'x ' .. item, 'success')
    else
        exports['se-bridge']:Notify(source, 'Failed to add item', 'error')
    end
end, true)

-- Example 10: Check Player Job (Server)
RegisterCommand('checkplayerjob', function(source, args)
    local target = tonumber(args[1]) or source
    local job = exports['se-bridge']:GetPlayerJob(target)
    
    if job then
        exports['se-bridge']:Notify(source, 'Player job: ' .. job.name .. ' - Grade: ' .. (job.grade or job.grade.level), 'info')
    else
        exports['se-bridge']:Notify(source, 'Could not get job data', 'error')
    end
end, true)

-- Example 11: Get All Police Officers Online
RegisterCommand('getonlinecops', function(source)
    local cops = exports['se-bridge']:GetPlayersByJob('police')
    
    exports['se-bridge']:Notify(source, 'Online cops: ' .. #cops, 'info')
    
    for _, playerId in pairs(cops) do
        local name = exports['se-bridge']:GetPlayerName(playerId)
        print('Cop online: ' .. name .. ' (' .. playerId .. ')')
    end
end, true)

-- Example 12: Create a Callback
exports['se-bridge']:CreateCallback('myScript:buyItem', function(source, itemName, amount)
    local price = 100 * amount
    local playerMoney = exports['se-bridge']:GetPlayerMoney(source, 'cash')
    
    if playerMoney >= price then
        if exports['se-bridge']:RemoveMoney(source, 'cash', price, 'Item Purchase') then
            if exports['se-bridge']:AddItem(source, itemName, amount) then
                return {success = true, message = 'Purchase successful!'}
            else
                -- Refund if item add failed
                exports['se-bridge']:AddMoney(source, 'cash', price, 'Refund')
                return {success = false, message = 'Could not add item'}
            end
        end
    end
    
    return {success = false, message = 'Not enough money'}
end)

-- Client-side callback usage:
--[[
RegisterCommand('buywater', function()
    local result = lib.callback.await('myScript:buyItem', false, 'water', 1)
    
    if result.success then
        exports['se-bridge']:Notify(result.message, 'success')
    else
        exports['se-bridge']:Notify(result.message, 'error')
    end
end)
]]

-- Example 13: Register Usable Item
exports['se-bridge']:RegisterUsableItem('water', function(source, item)
    -- Remove the item
    exports['se-bridge']:RemoveItem(source, 'water', 1)
    
    -- Notify player
    exports['se-bridge']:Notify(source, 'You drank water!', 'success')
    
    -- Add health or other effects via client event
    TriggerClientEvent('myScript:drinkWater', source)
end)

-- Example 14: Job-Restricted Command
RegisterCommand('policemenu', function(source)
    if exports['se-bridge']:HasJob(source, 'police', 2) then
        -- Open police menu
        TriggerClientEvent('myScript:openPoliceMenu', source)
    else
        exports['se-bridge']:Notify(source, 'You must be a police officer with grade 2+', 'error')
    end
end)

-- Example 15: Transaction System
local function ProcessTransaction(source, target, amount)
    local sourceMoney = exports['se-bridge']:GetPlayerMoney(source, 'cash')
    
    if sourceMoney >= amount then
        if exports['se-bridge']:RemoveMoney(source, 'cash', amount, 'Transfer to ' .. target) then
            if exports['se-bridge']:AddMoney(target, 'cash', amount, 'Transfer from ' .. source) then
                
                local sourceName = exports['se-bridge']:GetPlayerName(source)
                local targetName = exports['se-bridge']:GetPlayerName(target)
                
                exports['se-bridge']:Notify(source, 'Sent $' .. amount .. ' to ' .. targetName, 'success')
                exports['se-bridge']:Notify(target, 'Received $' .. amount .. ' from ' .. sourceName, 'success')
                
                return true
            else
                -- Refund if target add failed
                exports['se-bridge']:AddMoney(source, 'cash', amount, 'Refund')
            end
        end
    else
        exports['se-bridge']:Notify(source, 'Not enough money', 'error')
    end
    
    return false
end

RegisterCommand('paycash', function(source, args)
    if not args[1] or not args[2] then
        return exports['se-bridge']:Notify(source, 'Usage: /paycash [playerid] [amount]', 'error')
    end
    
    local target = tonumber(args[1])
    local amount = tonumber(args[2])
    
    if target == source then
        return exports['se-bridge']:Notify(source, 'Cannot pay yourself', 'error')
    end
    
    ProcessTransaction(source, target, amount)
end)

-- Example 16: Simple Shop System
local ShopItems = {
    {item = 'water', label = 'Water', price = 10},
    {item = 'bread', label = 'Bread', price = 15},
    {item = 'phone', label = 'Phone', price = 500}
}

exports['se-bridge']:CreateCallback('myScript:getShopItems', function(source)
    return ShopItems
end)

exports['se-bridge']:CreateCallback('myScript:purchaseItem', function(source, itemData)
    local price = itemData.price
    local playerMoney = exports['se-bridge']:GetPlayerMoney(source, 'cash')
    
    if playerMoney >= price then
        if exports['se-bridge']:CanCarryItem(source, itemData.item, 1) then
            if exports['se-bridge']:RemoveMoney(source, 'cash', price, 'Shop Purchase') then
                if exports['se-bridge']:AddItem(source, itemData.item, 1) then
                    return {success = true, message = 'Purchase successful!'}
                else
                    exports['se-bridge']:AddMoney(source, 'cash', price, 'Refund')
                    return {success = false, message = 'Could not add item'}
                end
            end
        else
            return {success = false, message = 'Inventory full'}
        end
    end
    
    return {success = false, message = 'Not enough money'}
end)

-- Example 17: Admin Check with Job
local function IsAdmin(source)
    -- Check if player has admin job OR custom admin check
    return exports['se-bridge']:HasJob(source, 'admin') or IsPlayerAceAllowed(source, 'admin')
end

RegisterCommand('adminmenu', function(source)
    if IsAdmin(source) then
        TriggerClientEvent('myScript:openAdminMenu', source)
    else
        exports['se-bridge']:Notify(source, 'You do not have permission', 'error')
    end
end)

-- Example 18: Get Framework Info
RegisterCommand('getframework', function(source)
    local frameworkName = exports['se-bridge']:GetFrameworkName()
    exports['se-bridge']:Notify(source, 'Running on: ' .. frameworkName, 'info')
end, false)

--[[
    ========================================
    EXAMPLE: COMPLETE JOB SYSTEM
    ========================================
    
    This shows how to create a complete job system using se-bridge
]]

-- Define job locations
local JobLocations = {
    {
        job = 'miner',
        locations = {
            vector3(2952.5, 2777.5, 41.5),
            vector3(2946.5, 2785.5, 40.5),
        },
        item = 'stone',
        payment = 50,
        label = 'Mine Stone'
    }
}

-- Server-side job processing
RegisterNetEvent('myScript:completeJob', function(jobType)
    local source = source
    local job = JobLocations[jobType]
    
    if not job then return end
    
    -- Check if player has the required job
    if not exports['se-bridge']:HasJob(source, job.job) then
        return exports['se-bridge']:Notify(source, 'You do not have the required job', 'error')
    end
    
    -- Add item and money
    if exports['se-bridge']:AddItem(source, job.item, 1) then
        exports['se-bridge']:AddMoney(source, 'cash', job.payment, 'Job Payment')
        exports['se-bridge']:Notify(source, 'You received ' .. job.item .. ' and $' .. job.payment, 'success')
    else
        exports['se-bridge']:Notify(source, 'Inventory full', 'error')
    end
end)

print('^2[SE-Bridge Examples]^7 Loaded successfully!')
