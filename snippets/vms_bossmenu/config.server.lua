-- ██████╗ ███████╗ ██████╗ ██╗███████╗████████╗███████╗██████╗     ███████╗████████╗ █████╗ ███████╗██╗  ██╗
-- ██╔══██╗██╔════╝██╔════╝ ██║██╔════╝╚══██╔══╝██╔════╝██╔══██╗    ██╔════╝╚══██╔══╝██╔══██╗██╔════╝██║  ██║
-- ██████╔╝█████╗  ██║  ███╗██║███████╗   ██║   █████╗  ██████╔╝    ███████╗   ██║   ███████║███████╗███████║
-- ██╔══██╗██╔══╝  ██║   ██║██║╚════██║   ██║   ██╔══╝  ██╔══██╗    ╚════██║   ██║   ██╔══██║╚════██║██╔══██║
-- ██║  ██║███████╗╚██████╔╝██║███████║   ██║   ███████╗██║  ██║    ███████║   ██║   ██║  ██║███████║██║  ██║
-- ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝    ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
SV.registerAllStashes = function()
    if not Config.Inventory or Config.Inventory == 'none' then
        return
    end
    
    for jobName, v in pairs(Config.JobMenusSettings) do
        if v.allowStash and v.stashSettings then
            if Config.Inventory == "ox_inventory" then
                exports['ox_inventory']:RegisterStash(v.stashSettings.id, v.stashSettings.label, v.stashSettings.slots, v.stashSettings.weight, false, jobName)

            elseif Config.Inventory == "origen_inventory" then
                exports['origen_inventory']:registerStash(v.stashSettings.id, v.stashSettings.label, v.stashSettings.slots, v.stashSettings.weight, false, jobName)

            elseif Config.Inventory == "tgiann-inventory" then
                exports['tgiann-inventory']:RegisterStash(v.stashSettings.id, v.stashSettings.label, v.stashSettings.slots, v.stashSettings.weight)

            end
        end
    end
end

SV.openStash = function(src, jobName, stashSettings)
    if Config.Inventory == "qb-inventory" then
        exports['qb-inventory']:OpenInventory(src, stashSettings.id, {
            label = stashSettings.label,
            maxweight = stashSettings.weight,
            slots = stashSettings.slots
        })

    elseif Config.Inventory == "origen_inventory" then
        exports['origen_inventory']:OpenInventory(src, 'stash', stashSettings.id)
        
    elseif Config.Inventory == "tgiann-inventory" then
        exports['tgiann-inventory']:OpenInventory(src, 'stash', stashSettings.id, {
            maxweight = stashSettings.weight,
            slots = stashSettings.slots,
        })

    elseif Config.Inventory == "one_inventory" then
        exports['one_inventory']:OpenInventory(src, 'stash', stashSettings.id, {
            label = stashSettings.label,
            maxweight = stashSettings.weight,
            slots = stashSettings.slots
        })
    end
end