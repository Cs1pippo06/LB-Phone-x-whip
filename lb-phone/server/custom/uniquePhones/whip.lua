if Config.Item.Inventory ~= "whip" or not Config.Item.Unique or not Config.Item.Require then
    return
end

print("^2[lb-phone] WHIP Unique Inventory integration loaded (Server)^0")

---@param source number
---@return table
local function GetPhonesInInventory(source)
    return exports.whip_core:FindAllItems(source, Config.Item.Name or "phone") or {}
end

---Check if a player has a phone with a specific number
---@param source any
---@param phoneNumber string
---@return boolean
function HasPhoneNumber(source, phoneNumber)
    local phones = GetPhonesInInventory(source)
    for i = 1, #phones do
        if phones[i].metadata and phones[i].metadata.lbPhoneNumber == phoneNumber then
            return true
        end
    end
    return false
end

---Assign a phone number to a player's empty phone item
---@param source number
---@param phoneNumber string
---@return boolean success
function SetPhoneNumber(source, phoneNumber)
    local phones = GetPhonesInInventory(source)
    for i = 1, #phones do
        local phone = phones[i]
        if not phone.metadata or not phone.metadata.lbPhoneNumber then
            local newMeta = {
                lbPhoneNumber = phoneNumber,
                lbFormattedNumber = FormatNumber(phoneNumber),
            }
            local ok = exports.whip_core:SetItemMetadata(phone.addr, newMeta)
            if ok then
                debugprint("Assigned phone number " .. phoneNumber .. " to player " .. source)
                return true
            end
        end
    end
    return false
end

---@param source number
---@param phoneNumber string
---@param name string
function SetItemName(source, phoneNumber, name)
    local phones = GetPhonesInInventory(source)
    for i = 1, #phones do
        local phone = phones[i]
        if phone.metadata and phone.metadata.lbPhoneNumber == phoneNumber then
            local ok = exports.whip_core:SetItemMetadata(phone.addr, {
                lbPhoneName = name,
                lbFormattedNumber = FormatNumber(phoneNumber),
            })
            return ok == true
        end
    end
    return false
end

-- Register phone item use handler in whip_core
CreateThread(function()
    while GetResourceState("whip_core") ~= "started" do
        Wait(500)
    end

    local phoneItemName = Config.Item.Name or "phone"

    exports.whip_core:RegisterUseHandler(phoneItemName, function(source, _, slotData)
        local meta = slotData and slotData.metadata
        TriggerClientEvent("lb-phone:whipUsePhone", source, phoneItemName, slotData and slotData.slot or 1, meta)
        return false -- false keeps the item in inventory
    end)
end)
