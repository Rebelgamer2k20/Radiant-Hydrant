--====================================================--
--                   R A D I A N T   D E V
--====================================================--

CreateThread(function()
    local resource = GetCurrentResourceName()
    local version = GetResourceMetadata(resource, "version", 0)
    local communityID = "1392750221532069988"
    local githubRaw = "https://raw.githubusercontent.com/Rebelgamer2k20/Radiant-Hydrant/refs/heads/main/radiant%20hydrants/version.json"

    -- Console colors
    local RED    = "^1"
    local GREEN  = "^2"
    local BLUE   = "^4"
    local WHITE  = "^7"
    local CYAN   = "^5"

    -- Detect game build
    local gameBuild = tonumber(GetConvarInt("sv_enforceGameBuild", 0))
    if gameBuild == 0 then
        local build = tonumber(GetGameBuildNumber())
        if build then gameBuild = build end
    end

    PerformHttpRequest(githubRaw, function(err, latestVersion, headers)
        if not latestVersion then 
            print("^1[RADIANT DEV] ERROR: Could not reach GitHub for version check.^7")
            return 
        end

        latestVersion = latestVersion:gsub("%s+", "")

        local versionColor = (version == latestVersion) and GREEN or RED
        local buildColor = (gameBuild >= 2699) and GREEN or RED
        local buildStatus = (gameBuild >= 2699)
            and "SUPPORTED (≥ 2699)"
            or "UNSUPPORTED (< 2699)"

        -- ASCII Logo
        local ascii = [[
██████   █████  ██████  ██  █████  ███    ██ ████████
██   ██ ██   ██ ██   ██ ██ ██   ██ ████   ██    ██   
██████  ███████ ██   ██ ██ ███████ ██ ██  ██    ██   
██   ██ ██   ██ ██   ██ ██ ██   ██ ██  ██ ██    ██   
██   ██ ██   ██ ██████  ██ ██   ██ ██   ████    ██    
              R A D I A N T   D E V E L O P M E N T
        ]]

        print(" ")
        print("┌──────────────────────────────────────────────────────────────┐")
        print("│" .. CYAN .. ascii .. WHITE)
        print("├──────────────────────────────────────────────────────────────┤")
        print("│  COMMUNITY ID: " .. CYAN .. communityID .. WHITE)
        print("│--------------------------------------------------------------│")
        print("│  INSTALLED VERSION: " .. versionColor .. version .. WHITE)
        print("│  LATEST STABLE:     " .. BLUE .. latestVersion .. WHITE)
        print("│--------------------------------------------------------------│")
        print("│  GAME BUILD: " .. buildColor .. gameBuild .. WHITE .. " → " .. buildColor .. buildStatus .. WHITE)
        print("│  (Minimum Required: 2699)")
        print("├──────────────────────────────────────────────────────────────┤")
        print("│  Updates & Support: https://forum.cfx.re/u/radiant-development │")
        print("└──────────────────────────────────────────────────────────────┘")
        print(" ")
    end, "GET")
end)
