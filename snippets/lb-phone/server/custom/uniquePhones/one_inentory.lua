if Config.Item.Inventory ~= "one_inventory" or not Config.Item.Unique or not Config.Item.Require then
    return
end

---Format phone number for display
---@param number string
---@return string|nil
local function FormatNumber(number)
    if not number then
        return nil
    end

    local numStr = tostring(number)

    if #numStr == 7 then
        return string.sub(numStr, 1, 3) .. "-" .. string.sub(numStr, 4, 7)
    elseif #numStr == 10 then
        return string.sub(numStr, 1, 3) .. "-" .. string.sub(numStr, 4, 6) .. "-" .. string.sub(numStr, 7, 10)
    end

    return number
end

---@param source number
---@return table
local function GetPhonesInInventory(source)
    if Config.Item.Name then
        return exports.one_inventory:SearchInventory(source, Config.Item.Name) or {}
    end

    local phones = {}

    for i = 1, #Config.Item.Names do
        local items = exports.one_inventory:SearchInventory(source, Config.Item.Names[i].name) or {}

        for _, phone in pairs(items) do
            phones[#phones + 1] = phone
        end
    end

    return phones
end

---Check if a player has a phone with a specific number
---@param source any
---@param phoneNumber string
---@return boolean
function HasPhoneNumber(source, phoneNumber)
    debugprint("checking if " .. source .. " has a phone item with number", phoneNumber)

    local phones = GetPhonesInInventory(source)

    for i = 1, #phones do
        if phones[i]?.metadata?.lbPhoneNumber == phoneNumber then
            debugprint("they do")

            return true
        end
    end

    return false
end

---<b>Key:</b> source
---<br><b>Value:</b> slotId
---@type { [number]: number }
local usedPhoneSlots = {}

---@param payload table
RegisterNetEvent("one_inventory:onItemUsed", function(payload)
    if not IsItemAPhone(payload.item) then
        return
    end

    usedPhoneSlots[payload.source] = payload.slot

    SetTimeout(10000, function()
        if usedPhoneSlots[payload.source] == payload.slot then
            usedPhoneSlots[payload.source] = nil
        end
    end)
end)

---Assign a phone number to a player's empty phone item
---@param source number
---@param phoneNumber string
---@return boolean success
function SetPhoneNumber(source, phoneNumber)
    debugprint("setting phone number to", phoneNumber, "for", source)

    local slot = usedPhoneSlots[source]

    if slot then
        debugprint("Used slot:", slot)

        local phone = exports.one_inventory:GetSlot(source, slot)

        if phone and phone.metadata?.lbPhoneNumber == nil then
            phone.metadata = {
                lbPhoneNumber = phoneNumber,
                lbFormattedNumber = FormatNumber(phoneNumber),
                lbPhoneName = phone.metadata?.lbPhoneName or nil,
            }

            exports.one_inventory:SetItemMetadata(source, phone.slot, phone.metadata)
            debugprint("set phone number to", phoneNumber, "for", source, "using slot", slot)

            return true
        end
    end

    local phones = GetPhonesInInventory(source)

    for i = 1, #phones do
        local phone = phones[i]

        if phone and phone.metadata?.lbPhoneNumber == nil then
            phone.metadata = {
                lbPhoneNumber = phoneNumber,
                lbFormattedNumber = FormatNumber(phoneNumber),
                lbPhoneName = phone.metadata?.lbPhoneName or nil,
            }

            exports.one_inventory:SetItemMetadata(source, phone.slot, phone.metadata)
            debugprint("set phone number to", phoneNumber, "for", source)

            return true
        end
    end

    return false
end

---@param source number
---@param phoneNumber string
---@param name string
function SetItemName(source, phoneNumber, name)
    local phones = {}

    if Config.Item.Name then
        phones = exports.one_inventory:SearchInventory(source, Config.Item.Name) or {}
    else
        for i = 1, #Config.Item.Names do
            local items = exports.one_inventory:SearchInventory(source, Config.Item.Names[i].name) or {}

            for _, phone in pairs(items) do
                phones[#phones + 1] = phone
            end
        end
    end

    if not phones then
        return false
    end

    for i = 1, #phones do
        local phone = phones[i]

        if phone?.metadata?.lbPhoneNumber == phoneNumber then
            phone.metadata.lbPhoneName = name
            phone.metadata.lbFormattedNumber = FormatNumber(phoneNumber)

            exports.one_inventory:SetItemMetadata(source, phone.slot, phone.metadata)

            return true
        end
    end

    return false
end
