-- Inventory Bridge - Client Side
local InventorySystem = nil
local InventoryName = 'Unknown'

-- Detect Inventory System
CreateThread(function()
    Wait(1000) -- Wait for resources to load
    
    if GetResourceState('ox_inventory') == 'started' then
        InventorySystem = exports.ox_inventory
        InventoryName = 'ox_inventory'
    elseif GetResourceState('qb-inventory') == 'started' then
        InventorySystem = exports['qb-inventory']
        InventoryName = 'qb-inventory'
    elseif GetResourceState('ps-inventory') == 'started' then
        InventorySystem = exports['ps-inventory']
        InventoryName = 'ps-inventory'
    elseif GetResourceState('qs-inventory') == 'started' then
        InventorySystem = exports['qs-inventory']
        InventoryName = 'qs-inventory'
    elseif GetResourceState('core_inventory') == 'started' then
        InventorySystem = exports.core_inventory
        InventoryName = 'core_inventory'
    end
    
    if InventorySystem then
        print('^2[SE-Bridge Inventory]^7 Detected: ^3' .. InventoryName .. '^7')
    else
        print('^3[SE-Bridge Inventory]^7 No inventory system detected, using framework default')
    end
end)

-- Has Item
function HasInventoryItem(item, amount)
    amount = amount or 1
    
    if InventoryName == 'ox_inventory' then
        local count = InventorySystem:GetItemCount(item)
        return count >= amount
    elseif InventoryName == 'qb-inventory' or InventoryName == 'ps-inventory' then
        local hasItem = InventorySystem:HasItem(item, amount)
        return hasItem ~= nil and hasItem
    elseif InventoryName == 'qs-inventory' then
        local items = InventorySystem:getUserInventory()
        for _, invItem in pairs(items) do
            if invItem.name == item and invItem.amount >= amount then
                return true
            end
        end
        return false
    elseif InventoryName == 'core_inventory' then
        return InventorySystem:hasItem(item, amount)
    end
    
    -- Framework fallback
    local framework = SEBridge.FrameworkName
    if framework == 'qbx_core' or framework == 'qb-core' then
        local playerData = SEBridge.Framework.Functions.GetPlayerData()
        for _, invItem in pairs(playerData.items) do
            if invItem.name == item and invItem.amount >= amount then
                return true
            end
        end
    elseif framework == 'es_extended' then
        local playerData = SEBridge.Framework.GetPlayerData()
        for _, invItem in pairs(playerData.inventory) do
            if invItem.name == item and invItem.count >= amount then
                return true
            end
        end
    end
    
    return false
end

-- Open Inventory
function OpenInventory(inventoryType, data)
    if InventoryName == 'ox_inventory' then
        if inventoryType == 'stash' then
            InventorySystem:openInventory('stash', data)
        elseif inventoryType == 'shop' then
            InventorySystem:openInventory('shop', data)
        end
    elseif InventoryName == 'qb-inventory' then
        if inventoryType == 'stash' then
            TriggerServerEvent('inventory:server:OpenInventory', 'stash', data.id, data)
        elseif inventoryType == 'shop' then
            TriggerServerEvent('inventory:server:OpenInventory', 'shop', data.id, data)
        end
    elseif InventoryName == 'ps-inventory' then
        if inventoryType == 'stash' then
            TriggerServerEvent('inventory:server:OpenInventory', 'stash', data.id, data)
        elseif inventoryType == 'shop' then
            TriggerEvent('inventory:client:SetCurrentStash', data.id)
            TriggerServerEvent('inventory:server:OpenInventory', 'shop', data.id, data)
        end
    end
end

-- Exports
exports('HasItem', HasInventoryItem)
exports('OpenInventory', OpenInventory)
