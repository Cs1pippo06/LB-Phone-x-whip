if Config.Framework ~= "whip" then
    return
end

print("^2[lb-phone] WHIP Framework integration loaded (Client)^0")

CreateThread(function()
    while not exports.whip_core or not exports.whip_core:IsPlayerLoaded() do
        Wait(500)
    end
    FrameworkLoaded = true
    FetchPhone()
end)

RegisterNetEvent('whip_core:client:playerLoaded', function()
    FrameworkLoaded = true
    FetchPhone()
end)

AddEventHandler('whip_core:player:loaded', function()
    FrameworkLoaded = true
    FetchPhone()
end)

RegisterNetEvent('whip_core:client:playerLogout', function()
    FrameworkLoaded = false
    LogOut()
end)

AddEventHandler('whip_core:player:logout', function()
    FrameworkLoaded = false
    LogOut()
end)

---@param itemName string
---@return boolean
function HasItem(itemName)
    return (exports.whip_core:GetItemCount(itemName) or 0) > 0
end

---@param jobs string[]
---@return boolean
function HasJob(jobs)
    local jobData = exports.whip_core:GetPlayerJob()
    if not jobData or not jobData.key then
        return false
    end
    for i = 1, #jobs do
        if jobs[i] == jobData.key then
            return true
        end
    end
    return false
end

AddCheck("openPhone", function()
    if exports.whip_core:IsPlayerDead() then
        return false
    end
    return true
end)
