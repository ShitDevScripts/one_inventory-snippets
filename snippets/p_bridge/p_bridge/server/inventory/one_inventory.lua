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

--@param playerId: number [existing player id]
--@return items: table [{name: string, amount: number, metadata: table, slot: number}]
Bridge.Inventory.getPlayerItems = function(playerId)
    return exports.one_inventory:GetInventoryItems(playerId)
end

--@param prefix: string [prefix for the drop]
--@param items: table [name: string, count: number, metadata: table]
--@param coords: vector3 [drop coordinates]
Bridge.Inventory.CustomDrop = function(prefix, items, coords)
    exports.one_inventory:CreateDrop(coords, items)
end

--@param playerId: number [existing player id]
--@param itemName: string [item name]
--@param itemCount: number [amount of items to add]
--@param itemMetadata: table [item metadata, optional]
--@param itemSlot: number [item slot, optional]
Bridge.Inventory.addItem = function(playerId, itemName, itemCount, itemMetadata, itemSlot)
    return exports.one_inventory:AddItem(playerId, itemName, itemCount or 1, itemMetadata, itemSlot)
end

--@param playerId: number [existing player id]
--@param itemName: string [item name]
--@param itemCount: number [amount of items to add]
--@param itemMetadata: table [item metadata, optional]
--@param itemSlot: number [item slot, optional]
Bridge.Inventory.removeItem = function(playerId, itemName, itemCount, itemMetadata, itemSlot)
    return exports.one_inventory:RemoveItem(playerId, itemName, itemCount or 1, itemMetadata, itemSlot)
end

--@param playerId: number [existing player id]
--@param itemName: string [item name]
--@param itemMetadata: table [item metadata, optional]
--@return count: number [amount of items in inventory]
Bridge.Inventory.getItemCount = function(playerId, itemName, itemMetadata)
    return exports.one_inventory:GetItemCount(playerId, itemName, itemMetadata)
end

Bridge.Inventory.getItemSlot = function(playerId, slot)
    return exports.one_inventory:GetSlot(playerId, slot)
end

Bridge.Inventory.createShop = function(shopName, data)
    while GetResourceState('one_inventory') ~= 'started' do
        Citizen.Wait(100)
    end

    Citizen.Wait(100)
    data.name = shopName
    exports.one_inventory:RegisterShop(data)
end

Bridge.Inventory.openShop = function(playerId, shopName)
    if type(shopName) == 'number' then
        shopName = tostring(shopName)
    end
    return exports.one_inventory:OpenInventory(playerId, 'shop', shopName)
end

Bridge.Inventory.getItemData = function(itemName)
    return exports.one_inventory:GetItemDefinition(itemName)
end