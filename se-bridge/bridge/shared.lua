SEBridge = {}
SEBridge.Framework = nil
SEBridge.FrameworkName = 'Unknown'

-- Debug print function
function SEBridge.Debug(...)
    if Config.Debug then
        print('^3[SE-Bridge Debug]^7', ...)
    end
end

-- Framework Detection
function SEBridge.DetectFramework()
    for _, frameworkName in ipairs(Config.FrameworkPriority) do
        local resourceName = Config.FrameworkResources[frameworkName]
        
        if GetResourceState(resourceName) == 'started' then
            SEBridge.FrameworkName = frameworkName
            SEBridge.Debug('Detected Framework:', frameworkName)
            return frameworkName
        end
    end
    
    SEBridge.Debug('No framework detected! Using standalone mode.')
    SEBridge.FrameworkName = 'standalone'
    return 'standalone'
end

-- Get Framework Object (called during initialization)
function SEBridge.GetFrameworkObject()
    local framework = SEBridge.FrameworkName
    
    if framework == 'ox_core' then
        return exports.ox_core
    elseif framework == 'qbx_core' then
        return exports.qbx_core -- QBX uses direct exports, no GetCoreObject
    elseif framework == 'qb-core' then
        return exports['qb-core']:GetCoreObject()
    elseif framework == 'es_extended' then
        return exports['es_extended']:getSharedObject()
    elseif framework == 'se_core' then
        -- Your custom framework initialization here
        return exports.se_core:GetCoreObject() -- Adjust as needed
    end
    
    return nil
end

-- Initialize Bridge
CreateThread(function()
    SEBridge.DetectFramework()
    SEBridge.Framework = SEBridge.GetFrameworkObject()
    
    if SEBridge.Framework then
        print('^2[SE-Bridge]^7 Successfully loaded with framework: ^3' .. SEBridge.FrameworkName .. '^7')
    else
        print('^3[SE-Bridge]^7 Running in standalone mode')
    end
end)

-- Export the bridge for other resources
exports('GetBridge', function()
    return SEBridge
end)

exports('GetFrameworkName', function()
    return SEBridge.FrameworkName
end)
