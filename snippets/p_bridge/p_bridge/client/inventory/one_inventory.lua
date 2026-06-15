if (Config.Inventory == 'auto' and not checkResource('one_inventory')) or (Config.Inventory ~= 'auto' and Config.Inventory ~= 'one_inventory') then
    return
end

while not Bridge do
    Citizen.Wait(0)
end

if Config.Debug then
    lib.print.info('[Inventory] Loaded: one_inventory')
end

Bridge.Inventory = {}

Bridge.Inventory.openInventory = function(invType, data)
    if invType == 'shop' then
        local shopName = data
        if type(data) == 'table' then
            shopName = data.type or data.id or data.name
        end
        if type(shopName) == 'number' then
            return false
        end
        exports.one_inventory:OpenInventory('shop', shopName)
    else
        exports.one_inventory:OpenInventory(invType, data)
    end
end

Bridge.Inventory.getItemCount = function(itemName, metadata)
    return exports.one_inventory:SearchInventory('count', itemName, metadata or nil)
end

Bridge.Inventory.getItemData = function(itemName)
    local allItems = exports.one_inventory:GetAllItemDefinitions()
    local info = allItems[itemName]
    return info and {name = itemName, label = info.label, description = info.description, image = ('https://cfx-nui-one_inventory/web/images/%s.png'):format(itemName)}
end

Bridge.Inventory.getPlayerItems = function()
    return exports.one_inventory:GetInventoryItems()
end

-- Alias voor openShop (voor compatibiliteit)
Bridge.Inventory.openShop = function(shopName)
    print('[DEBUG] openShop called - shopName:', shopName)
    exports.one_inventory:OpenInventory('shop', shopName)
end