---@class InventoryUtils : SharedInventoryUtils
local inventory = Luxu.require("bridge.shared.inventory")
local VRP = Framework.name == "vrp" and Framework.object.adapter or nil

local function isResourceRunning(resource)
    return GetResourceState(resource) == "started"
end

local function getItemAmount(item)
    if type(item) ~= "table" then return 0 end

    local amount = tonumber(item.amount or item.count or item.quantity or 0) or 0
    if amount <= 0 then return 0 end

    return math.floor(amount)
end

local function normalizeItems(items)
    local normalized = {}
    if type(items) ~= "table" then return normalized end

    for key, item in pairs(items) do
        if type(item) == "table" and item.name then
            local amount = getItemAmount(item)
            if amount > 0 then
                normalized[#normalized + 1] = {
                    name = tostring(item.name),
                    amount = amount,
                    slot = tonumber(item.slot) or tonumber(key),
                    metadata = item.metadata or item.info,
                }
            end
        end
    end

    table.sort(normalized, function(a, b)
        if a.slot and b.slot then return a.slot < b.slot end
        if a.slot then return true end
        if b.slot then return false end
        return a.name < b.name
    end)

    return normalized
end

---@param source number
---@return table<number, table>
function inventory.getPlayerItems(source)
    local playerObj = Luxu.player.getPlayerObject(source)
    if not playerObj then return {} end

    local result = {}
    if Framework.name == 'ox' then
        result = exports.ox_inventory:GetInventoryItems(source) --[[ @as table ]]
    elseif isResourceRunning("tgiann-inventory") then
        result = exports["tgiann-inventory"]:GetPlayerItems(source)
    elseif Framework.name == 'qb' or Framework.name == 'qbx' then
        result = playerObj.PlayerData.items
    elseif Framework.name == 'esx' then
        result = playerObj.getInventory()
    elseif Framework.name == 'vrp' then
        result = VRP.getInventory(source)
    elseif isResourceRunning("one_inventory") then
        result = exports.one_inventory:GetInventoryItems(source)
    else
        result = {} --[[ CUSTOM FRAMEWORK ]]
    end

    local formated = {}

    for k, item in pairs(result) do
        if item and item.name then
            item.amount = item.amount or item.count
            item.image = item.image
            formated[k] = item
        end
    end

    return formated
end

---@param source number
function inventory.addItem(source, item, amount, metadata, slot)
    local playerObj = Luxu.player.getPlayerObject(source)
    if not playerObj then return false end

    if isResourceRunning('ox_inventory') then
        exports.ox_inventory:AddItem(source, item, amount, metadata, slot, nil)
    elseif isResourceRunning("origen_inventory") then
        exports.origen_inventory:AddItem(source, item, amount, slot, metadata)
    elseif isResourceRunning('ak47_inventory') then
        exports['ak47_inventory']:AddItem(source, item, amount, slot, metadata)
    elseif isResourceRunning('ak47_qb_inventory') then
        exports['ak47_qb_inventory']:AddItem(source, item, amount, slot, metadata)
    elseif isResourceRunning('core_inventory') then
        local identifier = Luxu.player.getCharId(playerObj)
        local inventory = 'content-' .. identifier:gsub(':', '')
        exports['core_inventory']:addItem(inventory, item, amount, metadata, "content")
    elseif isResourceRunning('qs-inventory') then
        exports['qs-inventory']:AddItem(source, item, amount, slot, metadata)
    elseif isResourceRunning("tgiann-inventory") then
        exports["tgiann-inventory"]:AddItem(source, item, amount)
    elseif isResourceRunning("codem-inventory") then
        exports["codem-inventory"]:AddItem(source, item, amount, slot, metadata)
    elseif isResourceRunning("jaksam_inventory") then
        exports['jaksam_inventory']:addItem(source, item, amount, metadata, slot)
    elseif isResourceRunning("one_inventory") then
        exports.one_inventory:AddItem(source, item, amount, nil, metadata, slot)

    else
        if Framework.name == "qb" or Framework.name == "qbx" then
            playerObj.Functions.AddItem(item, amount, slot, metadata)
        elseif Framework.name == "esx" then
            local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.addInventoryItem(item, amount)
        elseif Framework.name == "vrp" then
            return VRP.giveItem(source, item, amount)
        end
    end
    return true
end

function inventory.removeItem(source, item, amount, slot)
    local playerObj = Luxu.player.getPlayerObject(source)
    if not playerObj then return false end

    if isResourceRunning('ox_inventory') then
        exports.ox_inventory:RemoveItem(source, item, amount)
    elseif isResourceRunning('origen_inventory') then
        exports.origen_inventory:RemoveItem(source, item, amount)
    elseif isResourceRunning('ak47_inventory') then
        exports['ak47_inventory']:RemoveItem(source, item, amount)
    elseif isResourceRunning('ak47_qb_inventory') then
        exports['ak47_qb_inventory']:RemoveItem(source, item, amount)
    elseif isResourceRunning('core_inventory') then
        local identifier = Luxu.player.getCharId(playerObj)
        local inventory = 'content-' .. identifier:gsub(":", "")
        exports['core_inventory']:removeItem(inventory, item, tonumber(amount))
    elseif isResourceRunning('qs-inventory') then
        exports['qs-inventory']:RemoveItem(source, item, amount)
    elseif isResourceRunning("tgiann-inventory") then
        exports["tgiann-inventory"]:RemoveItem(source, item, amount)
    elseif isResourceRunning("jaksam_inventory") then
        exports["jaksam_inventory"]:removeItem(source, item, amount, nil, slot)
    elseif isResourceRunning("codem-inventory") then
        exports["codem-inventory"]:RemoveItem(source, item, amount, slot)
    elseif isResourceRunning("one_inventory") then
        exports.one_inventory:RemoveItem(source, item, amount, slot)
    else
        if Framework.name == "qb" or Framework.name == "qbx" then
            playerObj.Functions.RemoveItem(item, amount)
        elseif Framework.name == "esx" then
            local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.removeInventoryItem(item, amount)
        elseif Framework.name == "vrp" then
            return VRP.takeItem(source, item, amount)
        end
    end
end

function inventory.clearPlayerItems(source)
    local playerObj = Luxu.player.getPlayerObject(source)
    if not playerObj then return false end

    for _, item in ipairs(normalizeItems(inventory.getPlayerItems(source))) do
        local ok, result = pcall(inventory.removeItem, source, item.name, item.amount, item.slot)
        if not ok or result == false then
            return false
        end
    end

    return true
end

function inventory.setPlayerItems(source, items)
    local playerObj = Luxu.player.getPlayerObject(source)
    if not playerObj then return false end

    local normalized = normalizeItems(items)
    if not inventory.clearPlayerItems(source) then
        return false
    end

    for _, item in ipairs(normalized) do
        local ok, result = pcall(inventory.addItem, source, item.name, item.amount, item.metadata, item.slot)
        if not ok or result == false then
            return false
        end
    end

    return true
end

---@return boolean
function inventory.canCarryItem(source, item, amount)
    local playerObj = Luxu.player.getPlayerObject(source)
    if not playerObj then return false end

    if isResourceRunning('ox_inventory') then
        return exports.ox_inventory:CanCarryItem(source, item, amount) == true
    elseif isResourceRunning("origen_inventory") then
        return exports.origen_inventory:CanCarryItem(source, item, amount)
    elseif isResourceRunning("ak47_inventory") then
        return exports['ak47_inventory']:CanAddItem(source, item, amount)
    elseif isResourceRunning('ak47_qb_inventory') then
        return exports['ak47_qb_inventory']:CanAddItem(source, item, amount)
    elseif isResourceRunning('core_inventory') then
        local identifier = Luxu.player.getCharId(playerObj)
        local inventory = 'content-' .. identifier:gsub(":", "")
        return exports['core_inventory']:canCarry(inventory, item, amount)
    elseif isResourceRunning('qs-inventory') then
        return exports['qs-inventory']:CanCarryItem(source, item, amount)
    elseif isResourceRunning("tgiann-inventory") then
        return exports["tgiann-inventory"]:CanCarryItem(source, item, amount)
    elseif isResourceRunning("jaksam_inventory") then
        return exports["jaksam_inventory"]:canCarryItem(source, item, amount)
    elseif isResourceRunning("codem-inventory") then
        local itemList = exports["codem-inventory"]:GetItemList()
        local itemData = itemList[item]
        if not itemData then return false end
        return exports["codem-inventory"]:CanCarryItem(source, item, amount)
    elseif isResourceRunning("one_inventory") then
        return exports.one_inventory:CanCarryItem(source, item, amount)

    else
        if Framework.name == "qb" or Framework.name == "qbx" then
            local totalWeight = QBCore.Player.GetTotalWeight(playerObj.PlayerData.items)
            local info = QBCore.Shared.Items[item:lower()]
            return (totalWeight + (info['weight'] * amount)) <= 120000
        elseif Framework.name == "esx" then
            local xPlayer = ESX.GetPlayerFromId(source)
            return xPlayer.canCarryItem(item, amount)
        elseif Framework.name == "vrp" then
            return VRP.canCarryItem(source, item, amount)
        end
    end
    return true
end

---@return boolean
function inventory.hasItem(source, item, amount)
    local playerObj = Luxu.player.getPlayerObject(source)
    if not playerObj then return false end

    if isResourceRunning('ox_inventory') then
        local count = exports.ox_inventory:GetItem(source, item, nil, true)
        return count >= amount
    elseif isResourceRunning('origen_inventory') then
        return exports.origen_inventory:HasItem(source, item, amount)
    elseif isResourceRunning('ak47_inventory') then
        return exports['ak47_inventory']:GetAmount(source, item) >= amount
    elseif isResourceRunning('ak47_qb_inventory') then
        return exports['ak47_qb_inventory']:GetAmount(source, item) >= amount
    elseif isResourceRunning('core_inventory') then
        local identifier = Luxu.player.getCharId(playerObj)
        local inventory = 'content-' .. identifier:gsub(":", "")
        local item = exports['core_inventory']:getItem(inventory, item)
        local count = item and item.amount or 0
        return count >= amount
    elseif isResourceRunning('qs-inventory') then
        local count = exports['qs-inventory']:GetItemTotalAmount(source, item)
        return count >= amount
    elseif isResourceRunning("codem-inventory") then
        return exports["codem-inventory"]:CheckItemValid(source, item, amount)
    elseif isResourceRunning("tgiann-inventory") then
        return exports["tgiann-inventory"]:HasItem(source, item, amount)
    elseif isResourceRunning("jaksam_inventory") then
        return exports['jaksam_inventory']:hasItem(source, item, amount)
    elseif isResourceRunning("one_inventory") then
        return exports.one_inventory:HasItem(source, item, amount)

    else
        if Framework.name == "qb" or Framework.name == "qbx" then
            local items = playerObj.PlayerData.items
            local count = 0
            for _, v in pairs(items) do
                if item == v.name then
                    count = count + v.amount
                end
            end
            return count >= amount
        elseif Framework.name == "esx" then
            local xPlayer = ESX.GetPlayerFromId(source)
            return xPlayer.getInventoryItem(item).count >= amount
        elseif Framework.name == "vrp" then
            return VRP.getItemCount(source, item) >= amount
        end
    end
    return false
end

function inventory.getItemCount(source, item)
    local playerObj = Luxu.player.getPlayerObject(source)
    if not playerObj then return 0 end

    if isResourceRunning('ox_inventory') then
        return exports.ox_inventory:GetItem(source, item, nil, true)
    elseif isResourceRunning('origen_inventory') then
        return exports.origen_inventory:GetItemCount(source, item)
    elseif isResourceRunning('ak47_inventory') then
        return exports['ak47_inventory']:GetAmount(source, item)
    elseif isResourceRunning('ak47_qb_inventory') then
        return exports['ak47_qb_inventory']:GetAmount(source, item)
    elseif isResourceRunning('core_inventory') then
        local identifier = Luxu.player.getCharId(playerObj)
        local inventory = 'content-' .. identifier:gsub(":", "")
        local itemData = exports['core_inventory']:getItem(inventory, item)
        return itemData and itemData.amount or 0
    elseif isResourceRunning('qs-inventory') then
        return exports['qs-inventory']:GetItemTotalAmount(source, item)
    elseif isResourceRunning("codem-inventory") then
        return exports["codem-inventory"]:GetItemCount(source, item)
    elseif isResourceRunning("tgiann-inventory") then
        return exports["tgiann-inventory"]:GetItemCount(source, item)
    elseif isResourceRunning("jaksam_inventory") then
        return exports['jaksam_inventory']:getTotalItemAmount(source, item)
    elseif isResourceRunning("one_inventory") then
        return exports.one_inventory:GetItemCount(source, item)
    else
        if Framework.name == "qb" or Framework.name == "qbx" then
            local items = playerObj.PlayerData.items
            local count = 0
            for _, v in pairs(items) do
                if item == v.name then
                    count = count + v.amount
                end
            end
            return count
        elseif Framework.name == "esx" then
            local xPlayer = ESX.GetPlayerFromId(source)
            return xPlayer.getInventoryItem(item).count
        elseif Framework.name == "vrp" then
            return VRP.getItemCount(source, item)
        end
    end
    return 0
end

function inventory.getAllPlayersInventory()
    local result = {}
    if Framework.name == "qb" or Framework.name == "qbx" then
        for _, playerObj in pairs(Framework.object.Functions.GetQBPlayers()) do
            local items = playerObj.PlayerData.items

            -- Safety check
            for _, item in pairs(items) do
                item.amount = item.amount or item.count
                item.label = item.label or item.name
            end

            table.insert(result, {
                charId = playerObj.PlayerData.citizenid,
                name = playerObj.PlayerData.charinfo.firstname .. " " .. playerObj.PlayerData.charinfo.lastname,
                inventory = items
            })
        end
    elseif Framework.name == "esx" then
        if Framework.object.GetExtendedPlayers then
            for _, playerObj in pairs(Framework.object.GetExtendedPlayers()) do
                local items = playerObj.inventory

                for _, item in pairs(items) do
                    item.amount = item.amount or item.count
                    item.label = item.label or item.name
                end

                table.insert(result, {
                    charId = playerObj.identifier,
                    name = playerObj.getName(),
                    inventory = items
                })
            end
        else
            --- Fallback

            for _, src in ipairs(GetPlayers()) do
                local playerObj = Framework.object.getGetPlayerFromId(src)

                if playerObj then
                    local items = playerObj.inventory

                    for _, item in pairs(items) do
                        item.amount = item.amount or item.count
                        item.label = item.label or item.name
                    end

                    table.insert(result, {
                        charId = playerObj.identifier,
                        name = playerObj.getName(),
                        inventory = items
                    })
                end
            end
        end
    elseif Framework.name == "vrp" then
        return VRP.getAllPlayersInventory()
    end
    return result
end

---@param typeofStash "stash" | "trunk" | "glovebox"
---@param id string could be vehicle plate
function inventory.getStash(typeofStash, id)
    if isResourceRunning('ox_inventory') then
        if typeofStash == "stash" then

        else
            local playersTable = "player_vehicles"
            if Framework.name == "esx" then
                playersTable = "owned_vehicles"
            end

            local query = ("SELECT %s FROM %s WHERE plate = ?"):format(typeofStash, playersTable)

            local result = MySQL.prepare.await(query, { id })
            local items = result and json.decode(result) or {}
            return items
        end
    elseif isResourceRunning("jaksam_inventory") then
        if typeofStash == "trunk" or typeofStash == "glovebox" then
            return exports['jaksam_inventory']:getInventoryIdFromPlate(id, typeofStash)
        else
            return exports['jaksam_inventory']:getInventory(id)
        end
    elseif isResourceRunning("core_inventory") then
        return exports.core_inventory:getInventory("stash-" .. id)
    elseif isResourceRunning("one_inventory") then
        local invIdentifier
        if typeofStash == "stash" then
            invIdentifier = "stash:" .. id
        elseif typeofStash == "trunk" then
            invIdentifier = "trunk:" .. id
        elseif typeofStash == "glovebox" then
            invIdentifier = "glovebox:" .. id
        else
            return {}
        end

        local inventoryData = exports.one_inventory:GetInventory(invIdentifier)
        if not inventoryData or not inventoryData.slots then
            return {}
        end

        local items = {}
        for _, slot in ipairs(inventoryData.slots) do
            table.insert(items, {
                name = slot.name,
                count = slot.count,
                metadata = slot.metadata or {},
                slot = slot.slot
            })
        end
        return items
    end
    return {}
end

return inventory
