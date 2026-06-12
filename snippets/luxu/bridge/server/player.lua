function player:canCarryItem(source, playerObj, item, count)
    if GetResourceState("ox_inventory") == "started" then
        return exports.ox_inventory:CanCarryItem(source, item, count) == true
    elseif GetResourceState("origen_inventory") == "started" then
        return exports.origen_inventory:CanCarryItem(source, item, count)
    elseif GetResourceState("qs-inventory") == "started" then
        return exports['qs-inventory']:CanCarryItem(source, item, count)
    elseif GetResourceState("tgiann-inventory") == "started" then
        return exports["tgiann-inventory"]:CanCarryItem(source, item, count)
    elseif GetResourceState("core_inventory") == "started" then
        local inventory = 'content-' .. (self.getCharId(playerObj)):gsub(":", "")
        return exports['core_inventory']:canCarry(inventory, item, count)
    elseif Framework.name == "vrp" then
        return VRP.canCarryItem(source, item, count)
    elseif GetResourceState("one_inventory") == "started" then
        return exports.one_inventory:CanCarryItem(source, item, count)
    else
        return true
    end
end