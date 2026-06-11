if GetResourceState('one_inventory') ~= 'started' then return end

local INV = exports.one_inventory

function HasItem(item)
    return INV:HasItem(item)
end

function OpenStash(stashId)
    if not INV:OpenInventory('stash', { id = 'evidence-' .. stashId }) then
        TriggerServerEvent('kartik-mdt:server:loadEvidenceStashes', stashId)
        INV:OpenInventory('stash', { id = 'evidence-' .. stashId })
    end
end

function GetItemImage(name)
    return 'https://cfx-nui-one_inventory/web/images/' .. name .. '.png'
end

function getItemName(hash)
    local ok, def = pcall(function()
        return INV:GetItemDefinition(hash)
    end)
    if ok and def and def.label then
        return def.label
    end
    return nil
end
