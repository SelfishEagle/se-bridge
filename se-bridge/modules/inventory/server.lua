-- Inventory Bridge - Server Side
local InventorySystem = nil
local InventoryName = 'Unknown'

-- Detect Inventory System
CreateThread(function()
    Wait(1000)
    
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

-- Add Item
function AddInventoryItem(source, item, amount, metadata)
    amount = amount or 1
    metadata = metadata or {}
    
    if InventoryName == 'ox_inventory' then
        return InventorySystem:AddItem(source, item, amount, metadata)
    elseif InventoryName == 'qb-inventory' or InventoryName == 'ps-inventory' then
        local player = SEBridge.GetPlayer(source)
        if player then
            return player.Functions.AddItem(item, amount, false, metadata)
        end
    elseif InventoryName == 'qs-inventory' then
        return InventorySystem:AddItem(source, item, amount, nil, metadata)
    elseif InventoryName == 'core_inventory' then
        return InventorySystem:addItem(source, item, amount, metadata)
    end
    
    -- Framework fallback
    local framework = SEBridge.FrameworkName
    if framework == 'qbx_core' or framework == 'qb-core' then
        local player = SEBridge.GetPlayer(source)
        if player then
            return player.Functions.AddItem(item, amount, false, metadata)
        end
    elseif framework == 'es_extended' then
        local player = SEBridge.GetPlayer(source)
        if player then
            player.addInventoryItem(item, amount)
            return true
        end
    end
    
    return false
end

-- Remove Item
function RemoveInventoryItem(source, item, amount, metadata)
    amount = amount or 1
    metadata = metadata or {}
    
    if InventoryName == 'ox_inventory' then
        return InventorySystem:RemoveItem(source, item, amount, metadata)
    elseif InventoryName == 'qb-inventory' or InventoryName == 'ps-inventory' then
        local player = SEBridge.GetPlayer(source)
        if player then
            return player.Functions.RemoveItem(item, amount, false, metadata)
        end
    elseif InventoryName == 'qs-inventory' then
        return InventorySystem:RemoveItem(source, item, amount, nil, metadata)
    elseif InventoryName == 'core_inventory' then
        return InventorySystem:removeItem(source, item, amount, metadata)
    end
    
    -- Framework fallback
    local framework = SEBridge.FrameworkName
    if framework == 'qbx_core' or framework == 'qb-core' then
        local player = SEBridge.GetPlayer(source)
        if player then
            return player.Functions.RemoveItem(item, amount)
        end
    elseif framework == 'es_extended' then
        local player = SEBridge.GetPlayer(source)
        if player then
            player.removeInventoryItem(item, amount)
            return true
        end
    end
    
    return false
end

-- Get Item Count
function GetInventoryItemCount(source, item)
    if InventoryName == 'ox_inventory' then
        return InventorySystem:GetItemCount(source, item)
    elseif InventoryName == 'qb-inventory' or InventoryName == 'ps-inventory' then
        local player = SEBridge.GetPlayer(source)
        if player then
            local itemData = player.Functions.GetItemByName(item)
            return itemData and itemData.amount or 0
        end
    elseif InventoryName == 'qs-inventory' then
        local count = InventorySystem:GetItemTotalAmount(source, item)
        return count or 0
    elseif InventoryName == 'core_inventory' then
        return InventorySystem:getItemCount(source, item)
    end
    
    -- Framework fallback
    local framework = SEBridge.FrameworkName
    if framework == 'qbx_core' or framework == 'qb-core' then
        local player = SEBridge.GetPlayer(source)
        if player then
            local itemData = player.Functions.GetItemByName(item)
            return itemData and itemData.amount or 0
        end
    elseif framework == 'es_extended' then
        local player = SEBridge.GetPlayer(source)
        if player then
            local itemData = player.getInventoryItem(item)
            return itemData and itemData.count or 0
        end
    end
    
    return 0
end

-- Has Item
function HasInventoryItem(source, item, amount)
    amount = amount or 1
    local count = GetInventoryItemCount(source, item)
    return count >= amount
end

-- Get Item
function GetInventoryItem(source, item)
    if InventoryName == 'ox_inventory' then
        return InventorySystem:GetItem(source, item)
    elseif InventoryName == 'qb-inventory' or InventoryName == 'ps-inventory' then
        local player = SEBridge.GetPlayer(source)
        if player then
            return player.Functions.GetItemByName(item)
        end
    elseif InventoryName == 'qs-inventory' then
        return InventorySystem:GetItemByName(source, item)
    elseif InventoryName == 'core_inventory' then
        return InventorySystem:getItem(source, item)
    end
    
    -- Framework fallback
    local framework = SEBridge.FrameworkName
    if framework == 'qbx_core' or framework == 'qb-core' then
        local player = SEBridge.GetPlayer(source)
        if player then
            return player.Functions.GetItemByName(item)
        end
    elseif framework == 'es_extended' then
        local player = SEBridge.GetPlayer(source)
        if player then
            return player.getInventoryItem(item)
        end
    end
    
    return nil
end

-- Register Stash
function RegisterStash(id, label, slots, weight, owner)
    if InventoryName == 'ox_inventory' then
        InventorySystem:RegisterStash(id, label, slots, weight, owner)
    elseif InventoryName == 'qb-inventory' or InventoryName == 'ps-inventory' then
        -- QB/PS inventory handles stashes dynamically
    elseif InventoryName == 'qs-inventory' then
        -- QS inventory handles stashes dynamically
    end
end

-- Can Carry Item
function CanCarryItem(source, item, amount)
    amount = amount or 1
    
    if InventoryName == 'ox_inventory' then
        return InventorySystem:CanCarryItem(source, item, amount)
    elseif InventoryName == 'qb-inventory' or InventoryName == 'ps-inventory' then
        -- QB/PS don't have native can carry check, return true
        return true
    elseif InventoryName == 'qs-inventory' then
        return InventorySystem:CanCarryItem(source, item, amount)
    end
    
    return true
end

-- Exports
exports('AddItem', AddInventoryItem)
exports('RemoveItem', RemoveInventoryItem)
exports('GetItemCount', GetInventoryItemCount)
exports('HasItem', HasInventoryItem)
exports('GetItem', GetInventoryItem)
exports('RegisterStash', RegisterStash)
exports('CanCarryItem', CanCarryItem)
