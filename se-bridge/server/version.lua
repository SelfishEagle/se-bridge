-- Version Checker for SE-Bridge
-- Configured for GitHub releases

local function CompareVersions(current, latest)
    local currentParts = {}
    local latestParts = {}
    
    -- Parse current version
    for part in string.gmatch(current, "%d+") do
        table.insert(currentParts, tonumber(part))
    end
    
    -- Parse latest version
    for part in string.gmatch(latest, "%d+") do
        table.insert(latestParts, tonumber(part))
    end
    
    -- Compare versions
    for i = 1, math.max(#currentParts, #latestParts) do
        local currentPart = currentParts[i] or 0
        local latestPart = latestParts[i] or 0
        
        if latestPart > currentPart then
            return true -- Update available
        elseif latestPart < currentPart then
            return false -- Current version is newer
        end
    end
    
    return false -- Versions are equal
end

local function CheckForUpdates()
    -- Always show current version on startup
    print("^2[SE-BRIDGE]^0 Version: ^3v" .. VersionConfig.CurrentVersion .. "^0")
    
    -- Check if external URL is provided
    if VersionConfig.CheckMethod ~= 'EXTERNAL' or not VersionConfig.VersionCheckURL or VersionConfig.VersionCheckURL == '' then
        print("^3[SE-BRIDGE]^0 Update checking disabled or not configured")
        print("^3[SE-BRIDGE]^0 Set VersionConfig.VersionCheckURL in version_config.lua to enable")
        return
    end
    
    -- Check if URL contains placeholder text
    if string.find(VersionConfig.VersionCheckURL, "YOUR-GITHUB-USERNAME") then
        print("^1[SE-BRIDGE]^0 ✗ Please update VersionCheckURL with your actual GitHub username!")
        print("^3[SE-BRIDGE]^0 Edit version_config.lua and replace 'YOUR-GITHUB-USERNAME'")
        return
    end
    
    -- Use PerformHttpRequest to check for updates from GitHub
    PerformHttpRequest(VersionConfig.VersionCheckURL, function(statusCode, response, headers)
        if statusCode == 200 then
            local data = json.decode(response)
            
            if not data then
                print("^1[SE-BRIDGE]^0 Could not parse GitHub release data")
                return
            end
            
            local latestVersion = nil
            local downloadUrl = nil
            local releaseNotes = nil
            
            -- GitHub releases format
            if data.tag_name then
                latestVersion = data.tag_name:gsub("v", "")
                downloadUrl = data.html_url or "https://github.com/your-repo/releases/latest"
                releaseNotes = data.body
            else
                print("^1[SE-BRIDGE]^0 Invalid GitHub release data format")
                return
            end
            
            if latestVersion then
                if CompareVersions(VersionConfig.CurrentVersion, latestVersion) then
                    print("^1========================================^0")
                    print("^1    SE-BRIDGE UPDATE AVAILABLE!^0")
                    print("^1========================================^0")
                    print("^3Current Version:^0 v" .. VersionConfig.CurrentVersion)
                    print("^2Latest Version:^0  v" .. latestVersion)
                    print("^3Download:^0 " .. downloadUrl)
                    
                    if releaseNotes then
                        print("^3What's New:^0")
                        -- Limit release notes to first 10 lines to avoid console spam
                        local lines = {}
                        for line in releaseNotes:gmatch("[^\r\n]+") do
                            table.insert(lines, line)
                            if #lines >= 10 then
                                table.insert(lines, "... (see GitHub for full release notes)")
                                break
                            end
                        end
                        print(table.concat(lines, "\n"))
                    end
                    print("^1========================================^0")
                else
                    print("^2[SE-BRIDGE]^0 ✓ You are running the latest version!")
                end
            end
        elseif statusCode == 404 then
            print("^1[SE-BRIDGE]^0 ✗ Could not check for updates - Repository or releases not found")
            print("^3[SE-BRIDGE]^0 Make sure:")
            print("^3[SE-BRIDGE]^0   1. Your GitHub repository exists")
            print("^3[SE-BRIDGE]^0   2. You have published at least one release")
            print("^3[SE-BRIDGE]^0   3. VersionCheckURL is correct in version_config.lua")
        elseif statusCode == 403 then
            print("^1[SE-BRIDGE]^0 ✗ GitHub API rate limit reached")
            print("^3[SE-BRIDGE]^0 Try again in a few minutes")
        else
            -- Silent fail for other errors
            print("^3[SE-BRIDGE]^0 Could not check for updates (Status: " .. tostring(statusCode) .. ")")
        end
    end, "GET", "", {["Content-Type"] = "application/json"})
end

-- Check for updates on resource start
CreateThread(function()
    Wait(2000) -- Wait 2 seconds after resource start
    CheckForUpdates()
end)

-- Export for manual checking
exports('CheckForUpdates', CheckForUpdates)

-- Command to manually check for updates
RegisterCommand('checkbridgeupdate', function(source, args, rawCommand)
    if source == 0 then -- Console only
        CheckForUpdates()
    end
end, true)
