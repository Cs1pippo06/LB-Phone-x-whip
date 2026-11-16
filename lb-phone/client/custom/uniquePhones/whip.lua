if Config.Item.Inventory ~= "whip" or not Config.Item.Unique or not Config.Item.Require then
    return
end

print("^2[lb-phone] WHIP Unique Inventory integration loaded (Client)^0")

---@return table
local function GetPhonesInInventory()
    local inv = exports.whip_core:GetInventory()
    local phones = {}
    local itemName = Config.Item.Name or "phone"

    if inv and type(inv) == "table" then
        for _, slots in pairs(inv) do
            if type(slots) == "table" then
                for _, data in pairs(slots) do
                    if data and data.item == itemName then
                        phones[#phones + 1] = data
                    end
                end
            end
        end
    end

    return phones
end

---Get the first phone number found in the player's inventory
---@return string?
function GetFirstNumber()
    local phones = GetPhonesInInventory()
    for i = 1, #phones do
        local phone = phones[i]
        if phone and phone.metadata and phone.metadata.lbPhoneNumber then
            return phone.metadata.lbPhoneNumber
        end
    end
    return nil
end

---Check if the player has a phone with a specific number
---@param phoneNumber string
function HasPhoneNumber(phoneNumber)
    local phones = GetPhonesInInventory()
    for i = 1, #phones do
        local phone = phones[i]
        if phone and phone.metadata and phone.metadata.lbPhoneNumber == phoneNumber then
            return true, (GetPhoneItemVariationIndex and GetPhoneItemVariationIndex(phone.item)) or nil
        end
    end
    return false
end

---Handle using the phone item from inventory
RegisterNetEvent("lb-phone:whipUsePhone", function(itemName, slotId, metadata)
    debugprint("WHIP used phone item", itemName, slotId, metadata)

    local number = metadata and metadata.lbPhoneNumber
    local variation = Config.Item.Names and GetPhoneItemVariationIndex and GetPhoneItemVariationIndex(itemName)

    if number ~= currentPhone or number == nil then
        SetPhone(number, true)
        if variation then
            SetPhoneVariation(variation)
        end
    end

    ToggleOpen(not phoneOpen)

    if variation then
        SetPhoneVariation(variation)
    end
end)

---Watch for inventory changes (e.g. phone dropped/lost)
RegisterNetEvent("whip_core:client:inventoryUpdate", function()
    if not Config.Item.Unique or not Config.Item.Require then
        return
    end

    Wait(500)

    if currentPhone then
        if not HasPhoneItem(currentPhone) then
            SetPhone()
        end
    else
        local count = exports.whip_core:GetItemCount(Config.Item.Name or "phone") or 0
        if count > 0 then
            local firstNumber = GetFirstNumber()
            if firstNumber then
                SetPhone(firstNumber, true)
            end
        end
    end
end)
