-- ███████╗████████╗ █████╗ ███████╗██╗  ██╗
-- ██╔════╝╚══██╔══╝██╔══██╗██╔════╝██║  ██║
-- ███████╗   ██║   ███████║███████╗███████║
-- ╚════██║   ██║   ██╔══██║╚════██║██╔══██║
-- ███████║   ██║   ██║  ██║███████║██║  ██║
-- ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
local inventoryAutoFind = function()
    local inventoriesList = {
        'ox_inventory',
        'qb-inventory',
        'origen_inventory',
        'tgiann-inventory',
        'one_inventory',
    }
    
    for _, inventoryName in ipairs(inventoriesList) do
        if GetResourceState(inventoryName) == 'started' then
            return inventoryName
        end
    end

    return 'none'
end