-- Server-side Bridge Functions

-- Get Player from Source
function SEBridge.GetPlayer(source)
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        return exports.ox_core:GetPlayer(source)
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        return SEBridge.Framework.Functions.GetPlayer(source)
    elseif framework == 'es_extended' then
        return SEBridge.Framework.GetPlayerFromId(source)
    elseif framework == 'se_core' then
        -- Your custom framework
        return SEBridge.Framework.GetPlayer(source)
    end
    
    return nil
end

-- Get Player Identifier
function SEBridge.GetPlayerIdentifier(source)
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        local player = exports.ox_core:GetPlayer(source)
        return player and player.get('identifier') or nil
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        local player = SEBridge.Framework.Functions.GetPlayer(source)
        return player and player.PlayerData.citizenid or nil
    elseif framework == 'es_extended' then
        local player = SEBridge.Framework.GetPlayerFromId(source)
        return player and player.identifier or nil
    elseif framework == 'se_core' then
        -- Your custom framework
        local player = SEBridge.Framework.GetPlayer(source)
        return player and player.identifier or nil
    end
    
    return nil
end

-- Get Player Name
function SEBridge.GetPlayerName(source)
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        local player = exports.ox_core:GetPlayer(source)
        return player and player.get('name') or GetPlayerName(source)
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        local player = SEBridge.Framework.Functions.GetPlayer(source)
        return player and player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname or GetPlayerName(source)
    elseif framework == 'es_extended' then
        local player = SEBridge.Framework.GetPlayerFromId(source)
        return player and player.getName() or GetPlayerName(source)
    elseif framework == 'se_core' then
        -- Your custom framework
        local player = SEBridge.Framework.GetPlayer(source)
        return player and player.getName() or GetPlayerName(source)
    end
    
    return GetPlayerName(source)
end

-- Get Player Job
function SEBridge.GetPlayerJob(source)
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        local player = exports.ox_core:GetPlayer(source)
        return player and player.get('job') or nil
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        local player = SEBridge.Framework.Functions.GetPlayer(source)
        return player and player.PlayerData.job or nil
    elseif framework == 'es_extended' then
        local player = SEBridge.Framework.GetPlayerFromId(source)
        return player and player.job or nil
    elseif framework == 'se_core' then
        -- Your custom framework
        local player = SEBridge.Framework.GetPlayer(source)
        return player and player.job or nil
    end
    
    return nil
end

-- Get Player Gang
function SEBridge.GetPlayerGang(source)
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        -- OX Core doesn't have gangs by default
        return nil
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        local player = SEBridge.Framework.Functions.GetPlayer(source)
        return player and player.PlayerData.gang or nil
    elseif framework == 'es_extended' then
        -- ESX doesn't have gangs by default
        return nil
    elseif framework == 'se_core' then
        -- Your custom framework
        local player = SEBridge.Framework.GetPlayer(source)
        return player and player.gang or nil
    end
    
    return nil
end

-- Get Player Money
function SEBridge.GetPlayerMoney(source, moneyType)
    moneyType = moneyType or 'cash'
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        local player = exports.ox_core:GetPlayer(source)
        if not player then return 0 end
        local accounts = player.getAccounts()
        return accounts[moneyType] or 0
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        local player = SEBridge.Framework.Functions.GetPlayer(source)
        if not player then return 0 end
        if moneyType == 'cash' then
            return player.PlayerData.money['cash'] or 0
        elseif moneyType == 'bank' then
            return player.PlayerData.money['bank'] or 0
        end
    elseif framework == 'es_extended' then
        local player = SEBridge.Framework.GetPlayerFromId(source)
        if not player then return 0 end
        if moneyType == 'cash' then moneyType = 'money' end
        return player.getAccount(moneyType).money
    elseif framework == 'se_core' then
        -- Your custom framework
        local player = SEBridge.Framework.GetPlayer(source)
        if not player then return 0 end
        return player.getMoney(moneyType)
    end
    
    return 0
end

-- Add Money
function SEBridge.AddMoney(source, moneyType, amount, reason)
    moneyType = moneyType or 'cash'
    reason = reason or 'Unknown'
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        local player = exports.ox_core:GetPlayer(source)
        if player then
            return player.addAccount(moneyType, amount, reason)
        end
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        local player = SEBridge.Framework.Functions.GetPlayer(source)
        if player then
            return player.Functions.AddMoney(moneyType, amount, reason)
        end
    elseif framework == 'es_extended' then
        local player = SEBridge.Framework.GetPlayerFromId(source)
        if player then
            if moneyType == 'cash' then moneyType = 'money' end
            return player.addAccountMoney(moneyType, amount, reason)
        end
    elseif framework == 'se_core' then
        -- Your custom framework
        local player = SEBridge.Framework.GetPlayer(source)
        if player then
            return player.addMoney(moneyType, amount, reason)
        end
    end
    
    return false
end

-- Remove Money
function SEBridge.RemoveMoney(source, moneyType, amount, reason)
    moneyType = moneyType or 'cash'
    reason = reason or 'Unknown'
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        local player = exports.ox_core:GetPlayer(source)
        if player then
            return player.removeAccount(moneyType, amount, reason)
        end
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        local player = SEBridge.Framework.Functions.GetPlayer(source)
        if player then
            return player.Functions.RemoveMoney(moneyType, amount, reason)
        end
    elseif framework == 'es_extended' then
        local player = SEBridge.Framework.GetPlayerFromId(source)
        if player then
            if moneyType == 'cash' then moneyType = 'money' end
            return player.removeAccountMoney(moneyType, amount, reason)
        end
    elseif framework == 'se_core' then
        -- Your custom framework
        local player = SEBridge.Framework.GetPlayer(source)
        if player then
            return player.removeMoney(moneyType, amount, reason)
        end
    end
    
    return false
end

-- Add Item
function SEBridge.AddItem(source, item, amount, metadata)
    amount = amount or 1
    metadata = metadata or {}
    -- This will be handled by inventory bridge
    return exports['se-bridge']:AddItem(source, item, amount, metadata)
end

-- Remove Item
function SEBridge.RemoveItem(source, item, amount, metadata)
    amount = amount or 1
    metadata = metadata or {}
    -- This will be handled by inventory bridge
    return exports['se-bridge']:RemoveItem(source, item, amount, metadata)
end

-- Has Item
function SEBridge.HasItem(source, item, amount)
    amount = amount or 1
    -- This will be handled by inventory bridge
    return exports['se-bridge']:HasItem(source, item, amount)
end

-- Get Item Count
function SEBridge.GetItemCount(source, item)
    -- This will be handled by inventory bridge
    return exports['se-bridge']:GetItemCount(source, item)
end

-- Notify Player
function SEBridge.Notify(source, message, type, duration)
    type = type or 'info'
    duration = duration or Config.NotificationDuration
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Notification',
            description = message,
            type = type,
            duration = duration
        })
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        TriggerClientEvent('QBCore:Notify', source, message, type, duration)
    elseif framework == 'es_extended' then
        TriggerClientEvent('esx:showNotification', source, message, type, duration)
    elseif framework == 'se_core' then
        -- Your custom framework
        TriggerClientEvent('se_core:notify', source, message, type, duration)
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { message }
        })
    end
end

-- Get Players
function SEBridge.GetPlayers()
    local framework = SEBridge.FrameworkName
    local players = {}
    
    if framework == 'ox_core' then
        return exports.ox_core:GetPlayers()
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        return SEBridge.Framework.Functions.GetPlayers()
    elseif framework == 'es_extended' then
        local xPlayers = SEBridge.Framework.GetExtendedPlayers()
        for _, xPlayer in pairs(xPlayers) do
            table.insert(players, xPlayer.source)
        end
        return players
    elseif framework == 'se_core' then
        -- Your custom framework
        return SEBridge.Framework.GetPlayers()
    end
    
    -- Fallback
    for _, playerId in ipairs(GetPlayers()) do
        table.insert(players, tonumber(playerId))
    end
    return players
end

-- Get Players by Job
function SEBridge.GetPlayersByJob(jobName)
    local framework = SEBridge.FrameworkName
    local players = {}
    
    if framework == 'ox_core' then
        local allPlayers = exports.ox_core:GetPlayers()
        for _, player in pairs(allPlayers) do
            local job = player.get('job')
            if job and job.name == jobName then
                table.insert(players, player.source)
            end
        end
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        local allPlayers = SEBridge.Framework.Functions.GetPlayers()
        for _, playerId in pairs(allPlayers) do
            local player = SEBridge.Framework.Functions.GetPlayer(playerId)
            if player and player.PlayerData.job.name == jobName then
                table.insert(players, playerId)
            end
        end
    elseif framework == 'es_extended' then
        local xPlayers = SEBridge.Framework.GetExtendedPlayers('job', jobName)
        for _, xPlayer in pairs(xPlayers) do
            table.insert(players, xPlayer.source)
        end
    elseif framework == 'se_core' then
        -- Your custom framework
        players = SEBridge.Framework.GetPlayersByJob(jobName)
    end
    
    return players
end

-- Has Job
function SEBridge.HasJob(source, jobName, grade)
    local job = SEBridge.GetPlayerJob(source)
    
    if not job then return false end
    
    if type(jobName) == 'table' then
        for _, name in pairs(jobName) do
            if job.name == name then
                if grade then
                    return job.grade >= grade or job.grade.level >= grade
                end
                return true
            end
        end
        return false
    else
        if job.name == jobName then
            if grade then
                return job.grade >= grade or job.grade.level >= grade
            end
            return true
        end
    end
    
    return false
end

-- Register Server Callback
function SEBridge.CreateCallback(name, cb)
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        lib.callback.register(name, function(source, ...)
            return cb(source, ...)
        end)
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        SEBridge.Framework.Functions.CreateCallback(name, function(source, cb2, ...)
            cb2(cb(source, ...))
        end)
    elseif framework == 'es_extended' then
        SEBridge.Framework.RegisterServerCallback(name, function(source, cb2, ...)
            cb2(cb(source, ...))
        end)
    elseif framework == 'se_core' then
        -- Your custom framework
        SEBridge.Framework.CreateCallback(name, function(source, ...)
            return cb(source, ...)
        end)
    end
end

-- Register Usable Item
function SEBridge.RegisterUsableItem(item, cb)
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        exports.ox_inventory:registerUsableItem(item, function(source, item, metadata)
            cb(source, item, metadata)
        end)
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        SEBridge.Framework.Functions.CreateUseableItem(item, function(source, item)
            cb(source, item)
        end)
    elseif framework == 'es_extended' then
        SEBridge.Framework.RegisterUsableItem(item, function(source)
            cb(source, item)
        end)
    elseif framework == 'se_core' then
        -- Your custom framework
        SEBridge.Framework.RegisterUsableItem(item, function(source, item, metadata)
            cb(source, item, metadata)
        end)
    end
end

-- Get All Players Online
function SEBridge.GetAllPlayers()
    return SEBridge.GetPlayers()
end

-- Exports
exports('GetPlayer', SEBridge.GetPlayer)
exports('GetPlayerIdentifier', SEBridge.GetPlayerIdentifier)
exports('GetPlayerName', SEBridge.GetPlayerName)
exports('GetPlayerJob', SEBridge.GetPlayerJob)
exports('GetPlayerGang', SEBridge.GetPlayerGang)
exports('GetPlayerMoney', SEBridge.GetPlayerMoney)
exports('AddMoney', SEBridge.AddMoney)
exports('RemoveMoney', SEBridge.RemoveMoney)
exports('AddItem', SEBridge.AddItem)
exports('RemoveItem', SEBridge.RemoveItem)
exports('HasItem', SEBridge.HasItem)
exports('GetItemCount', SEBridge.GetItemCount)
exports('Notify', SEBridge.Notify)
exports('GetPlayers', SEBridge.GetPlayers)
exports('GetPlayersByJob', SEBridge.GetPlayersByJob)
exports('HasJob', SEBridge.HasJob)
exports('CreateCallback', SEBridge.CreateCallback)
exports('RegisterUsableItem', SEBridge.RegisterUsableItem)
exports('GetAllPlayers', SEBridge.GetAllPlayers)
