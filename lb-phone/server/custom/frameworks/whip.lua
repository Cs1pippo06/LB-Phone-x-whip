if Config.Framework ~= "whip" then
    return
end

print("^2[lb-phone] WHIP Framework integration loaded (Server)^0")

function IsAdmin(source)
    return IsPlayerAceAllowed(source, "command.lbphone_admin") == 1 or exports.whip_core:HasDevTools(source)
end

---@param source number
---@return string | nil
function GetIdentifier(source)
    local charId = exports.whip_core:GetCharId(source)
    return charId and tostring(charId) or nil
end

---@param identifier string | number
---@return number?
function GetSourceFromIdentifier(identifier)
    local players = GetPlayers()
    for i = 1, #players do
        local src = tonumber(players[i])
        if src and tostring(exports.whip_core:GetCharId(src)) == tostring(identifier) then
            return src
        end
    end
    return nil
end

---@param source number
---@param itemName string
function HasItem(source, itemName)
    return exports.whip_core:HasItem(source, itemName, 1) == true
end

---Get a player's character name
---@param source number
---@return string # Firstname
---@return string # Lastname
function GetCharacterName(source)
    local fullName = exports.whip_core:GetPlayerFullName(source) or GetPlayerName(source)
    local first, last = fullName:match("^(%S+)%s*(.*)$")
    return first or fullName, last or ""
end

---Get the bank balance of a player
---@param source number
---@return integer
function GetBalance(source)
    local charId = exports.whip_core:GetCharId(source)
    if not charId then return 0 end
    local bal = exports.whip_core:GetBalance(charId)
    return bal and math.floor(bal) or 0
end

---Add money to a player's bank account
---@param source number
---@param amount integer
---@return boolean success
function AddMoney(source, amount)
    local charId = exports.whip_core:GetCharId(source)
    if not charId then return false end
    local acc = exports.whip_core:GetDefaultBankAccount(charId)
    if not acc then return false end
    local ok = exports.whip_core:BankSystemDeposit(acc.accountId, math.floor(amount), { reason = "LB Phone: Deposit" })
    return ok == true
end

---@param identifier string
---@param amount number
---@return boolean success
function AddMoneyOffline(identifier, amount)
    local charId = tonumber(identifier)
    if not charId or amount <= 0 then return false end
    local acc = exports.whip_core:GetDefaultBankAccount(charId)
    if not acc then return false end
    local ok = exports.whip_core:BankSystemDeposit(acc.accountId, math.floor(amount), { reason = "LB Phone: Offline deposit" })
    return ok == true
end

---Remove money from a player's bank account
---@param source number
---@param amount integer
---@return boolean success
function RemoveMoney(source, amount)
    local charId = exports.whip_core:GetCharId(source)
    if not charId then return false end
    local acc = exports.whip_core:GetDefaultBankAccount(charId)
    if not acc then return false end
    local ok = exports.whip_core:BankSystemWithdraw(acc.accountId, math.floor(amount), { reason = "LB Phone: Withdrawal / Payment" })
    return ok == true
end

---@param source number
---@return table[] vehicles An array of vehicles that the player owns
function GetPlayerVehicles(source)
    local charId = exports.whip_core:GetCharId(source)
    if not charId then return {} end
    local list = exports.whip_core:GetVehiclesOf(charId) or {}
    local out = {}
    for i = 1, #list do
        local v = list[i]
        out[#out + 1] = {
            plate = v.plate,
            model = v.model,
            stored = v.state == "garaged",
            garage = v.garage or "Garage",
        }
    end
    return out
end

---@param _source number
---@param plate string
---@return boolean
function DoesPlayerOwnVehicle(_source, plate)
    local charId = exports.whip_core:GetCharId(_source)
    if not charId then return false end
    local list = exports.whip_core:GetVehiclesOf(charId) or {}
    for i = 1, #list do
        if list[i].plate == plate then return true end
    end
    return false
end

---@param source number
---@param plate string
---@return table? vehicleData
function GetVehicle(source, plate)
    local charId = exports.whip_core:GetCharId(source)
    if not charId then return nil end
    local list = exports.whip_core:GetVehiclesOf(charId) or {}
    for i = 1, #list do
        if list[i].plate == plate then
            return {
                plate = v.plate,
                model = v.model,
                stored = v.state == "garaged",
                garage = v.garage or "Garage",
            }
        end
    end
    return nil
end

function GetJob(source)
    local job = exports.whip_core:GetPlayerJob(source)
    return job and job.key or "unemployed"
end
