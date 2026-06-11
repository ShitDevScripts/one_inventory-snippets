if GetResourceState('one_inventory') ~= 'started' then return end
print('^2[MDT Bridge]^7 Detected Inventory: ^5one_inventory^7')

local INV = exports.one_inventory

function HasItem(source, item)
    return INV:HasItem(source, item)
end

function getStashItems(stashId)
    local stashItems = INV:GetInventoryItems('stash:evidence-' .. stashId)
    return stashItems or {}
end

RegisterNetEvent('kartik-mdt:server:loadEvidenceStashes', function(stashId, owner)
    INV:OpenInventory(source, 'stash', {
        id = 'evidence-' .. stashId,
        label = stashId,
        slots = 50,
        maxWeight = 100000,
        owner = owner,
    })
end)

function getItemName(hash)
    local ok, def = pcall(function()
        return INV:GetItemDefinition(hash)
    end)
    if ok and def and def.label then
        return def.label
    end
    return nil
end

INV:RegisterHook('beforeShopPurchase', function(payload)
    local itemName = payload and (payload.itemName or payload.item)
    if type(itemName) ~= 'string' or not string.find(itemName, 'WEAPON_') then return end
    CreateThread(function()
        local owner = GetPlayerData(payload.source).citizenId
        if not owner or not payload.metadata or not payload.metadata.serial then return end
        local imageurl = ('https://cfx-nui-one_inventory/web/images/%s.png'):format(itemName)
        local weaponLabel = getWeaponDisplayName(itemName)
        local success, result = pcall(function()
            return CreateWeaponInfo(payload.metadata.serial, imageurl, owner, weaponLabel)
        end)

        if not success then
            print('Error in creating weapon info in MDT: ' .. tostring(result))
        end
    end)
end)

-- One Inventory item editor: serverExport = "your_resource.useTracker"
exports('useTracker', function(src, itemName, slot, metadata)
    local source = src
    local PlayerData = GetPlayerData(source)

    if not PlayerData or not PlayerData.citizenId then
        print('Error: PlayerData is nil or citizenId is missing for source: ' .. tostring(source))
        return
    end

    local label = PlayerData.name
    local job = PlayerData.jobData.name

    TogglePlayer(source, label, job, PlayerData.citizenId)
end)

-- One Inventory item editor: serverExport = "your_resource.ToggleBodycam"
exports('ToggleBodycam', function(src, itemName, slot, metadata)
    local source = src
    local PlayerData = GetPlayerData(source)

    if not PlayerData or not PlayerData.citizenId then
        print('Error: PlayerData is nil or citizenId is missing for source: ' .. tostring(source))
        return
    end

    toggleBodycam(source)
end)
