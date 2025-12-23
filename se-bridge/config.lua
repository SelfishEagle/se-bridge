Config = {}

-- Framework Detection Priority (checks in this order)
Config.FrameworkPriority = {
    'ox_core',
    'qbx_core',
    'qb-core',
    'es_extended',
    'se_core'
}

-- Framework Resource Names
Config.FrameworkResources = {
    ['ox_core'] = 'ox_core',
    ['qbx_core'] = 'qbx_core',
    ['qb-core'] = 'qb-core',
    ['es_extended'] = 'es_extended',
    ['se_core'] = 'se_core'
}

-- Debug Mode
Config.Debug = true

-- Notification Settings
Config.NotificationPosition = 'top-right' -- top, top-right, top-left, bottom, bottom-right, bottom-left
Config.NotificationDuration = 5000 -- milliseconds
