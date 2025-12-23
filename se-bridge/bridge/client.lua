-- Client-side Bridge Functions

-- Get Player Data
function SEBridge.GetPlayerData()
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        return Ox.GetPlayer()
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        return SEBridge.Framework.Functions.GetPlayerData()
    elseif framework == 'es_extended' then
        return SEBridge.Framework.GetPlayerData()
    elseif framework == 'se_core' then
        -- Your custom framework
        return SEBridge.Framework.GetPlayerData()
    end
    
    return nil
end

-- Get Player Job
function SEBridge.GetPlayerJob()
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        local player = Ox.GetPlayer()
        return player and player.get('job') or nil
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        local playerData = SEBridge.Framework.Functions.GetPlayerData()
        return playerData.job
    elseif framework == 'es_extended' then
        local playerData = SEBridge.Framework.GetPlayerData()
        return playerData.job
    elseif framework == 'se_core' then
        -- Your custom framework
        local playerData = SEBridge.Framework.GetPlayerData()
        return playerData.job
    end
    
    return nil
end

-- Get Player Gang (if applicable)
function SEBridge.GetPlayerGang()
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        -- OX Core doesn't have gangs by default
        return nil
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        local playerData = SEBridge.Framework.Functions.GetPlayerData()
        return playerData.gang
    elseif framework == 'es_extended' then
        -- ESX doesn't have gangs by default
        return nil
    elseif framework == 'se_core' then
        -- Your custom framework
        local playerData = SEBridge.Framework.GetPlayerData()
        return playerData.gang
    end
    
    return nil
end

-- Get Player Money
function SEBridge.GetPlayerMoney(moneyType)
    moneyType = moneyType or 'cash'
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        local player = Ox.GetPlayer()
        local accounts = player and player.getAccounts() or {}
        return accounts[moneyType] or 0
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        local playerData = SEBridge.Framework.Functions.GetPlayerData()
        if moneyType == 'cash' then
            return playerData.money['cash'] or 0
        elseif moneyType == 'bank' then
            return playerData.money['bank'] or 0
        end
    elseif framework == 'es_extended' then
        local playerData = SEBridge.Framework.GetPlayerData()
        for _, account in pairs(playerData.accounts) do
            if account.name == moneyType or (moneyType == 'cash' and account.name == 'money') then
                return account.money
            end
        end
    elseif framework == 'se_core' then
        -- Your custom framework
        local playerData = SEBridge.Framework.GetPlayerData()
        return playerData.money and playerData.money[moneyType] or 0
    end
    
    return 0
end

-- Show Notification
function SEBridge.Notify(message, type, duration)
    type = type or 'info'
    duration = duration or Config.NotificationDuration
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        lib.notify({
            title = 'Notification',
            description = message,
            type = type,
            duration = duration
        })
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        SEBridge.Framework.Functions.Notify(message, type, duration)
    elseif framework == 'es_extended' then
        SEBridge.Framework.ShowNotification(message, type, duration)
    elseif framework == 'se_core' then
        -- Your custom framework
        SEBridge.Framework.Notify(message, type, duration)
    else
        -- Fallback notification
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(message)
        EndTextCommandThefeedPostTicker(false, true)
    end
end

-- Show Advanced Notification
function SEBridge.NotifyAdvanced(data)
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        lib.notify(data)
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        SEBridge.Framework.Functions.Notify(data.description or data.message, data.type or 'info', data.duration or 5000)
    elseif framework == 'es_extended' then
        SEBridge.Framework.ShowNotification(data.description or data.message, data.type or 'info', data.duration or 5000)
    elseif framework == 'se_core' then
        -- Your custom framework
        SEBridge.Framework.NotifyAdvanced(data)
    else
        SEBridge.Notify(data.description or data.message, data.type, data.duration)
    end
end

-- Draw Text (3D Text)
function SEBridge.DrawText3D(coords, text)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local pCoords = GetEntityCoords(PlayerPedId())
    local distance = #(pCoords - coords)
    
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(x, y)
    end
end

-- Show Help Notification
function SEBridge.ShowHelpNotification(message)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

-- Progress Bar
function SEBridge.ProgressBar(data)
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        if lib.progressBar then
            return lib.progressBar({
                duration = data.duration,
                label = data.label,
                useWhileDead = data.useWhileDead or false,
                canCancel = data.canCancel or true,
                disable = data.disable or {
                    move = true,
                    car = true,
                    combat = true
                },
                anim = data.anim,
                prop = data.prop
            })
        end
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        if exports['progressbar'] then
            exports['progressbar']:Progress({
                name = data.name or 'se_progress',
                duration = data.duration,
                label = data.label,
                useWhileDead = data.useWhileDead or false,
                canCancel = data.canCancel or true,
                controlDisables = data.disable or {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = data.anim,
                prop = data.prop
            }, function(cancelled)
                if data.onFinish and not cancelled then
                    data.onFinish()
                elseif data.onCancel and cancelled then
                    data.onCancel()
                end
            end)
            return true
        end
    elseif framework == 'es_extended' then
        if exports['esx_progressbar'] then
            exports['esx_progressbar']:Progressbar(data.label, data.duration, {
                FreezePlayer = true,
                animation = data.anim,
                onFinish = data.onFinish,
                onCancel = data.onCancel
            })
            return true
        end
    elseif framework == 'se_core' then
        -- Your custom framework
        return SEBridge.Framework.ProgressBar(data)
    end
    
    -- Fallback - just wait
    Wait(data.duration)
    if data.onFinish then
        data.onFinish()
    end
    return true
end

-- Get Player Identifier
function SEBridge.GetPlayerIdentifier()
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        local player = Ox.GetPlayer()
        return player and player.get('identifier') or nil
    elseif framework == 'qbx_core' or framework == 'qb-core' then
        local playerData = SEBridge.Framework.Functions.GetPlayerData()
        return playerData.citizenid
    elseif framework == 'es_extended' then
        local playerData = SEBridge.Framework.GetPlayerData()
        return playerData.identifier
    elseif framework == 'se_core' then
        -- Your custom framework
        local playerData = SEBridge.Framework.GetPlayerData()
        return playerData.identifier
    end
    
    return nil
end

-- Has Job
function SEBridge.HasJob(jobName, grade)
    local job = SEBridge.GetPlayerJob()
    
    if not job then return false end
    
    if type(jobName) == 'table' then
        for _, name in pairs(jobName) do
            if job.name == name then
                if grade then
                    return job.grade.level >= grade
                end
                return true
            end
        end
        return false
    else
        if job.name == jobName then
            if grade then
                return job.grade.level >= grade
            end
            return true
        end
    end
    
    return false
end

-- Has Item (requires inventory bridge)
function SEBridge.HasItem(item, amount)
    amount = amount or 1
    -- This will be handled by inventory bridge
    return exports['se-bridge']:HasItem(item, amount)
end

-- Exports
exports('GetPlayerData', SEBridge.GetPlayerData)
exports('GetPlayerJob', SEBridge.GetPlayerJob)
exports('GetPlayerGang', SEBridge.GetPlayerGang)
exports('GetPlayerMoney', SEBridge.GetPlayerMoney)
exports('Notify', SEBridge.Notify)
exports('NotifyAdvanced', SEBridge.NotifyAdvanced)
exports('DrawText3D', SEBridge.DrawText3D)
exports('ShowHelpNotification', SEBridge.ShowHelpNotification)
exports('ProgressBar', SEBridge.ProgressBar)
exports('GetPlayerIdentifier', SEBridge.GetPlayerIdentifier)
exports('HasJob', SEBridge.HasJob)
exports('HasItem', SEBridge.HasItem)
