-- ███████╗████████╗ █████╗ ███████╗██╗  ██╗
-- ██╔════╝╚══██╔══╝██╔══██╗██╔════╝██║  ██║
-- ███████╗   ██║   ███████║███████╗███████║
-- ╚════██║   ██║   ██╔══██║╚════██║██╔══██║
-- ███████║   ██║   ██║  ██║███████║██║  ██║
-- ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
CL.OpenStash = function(jobName, stashSettings)
    if Config.Inventory == "ox_inventory" then
        exports.ox_inventory:openInventory('stash', {id = stashSettings.id})
    elseif Config.Inventory == "one_inventory" then
        exports.one_inventory:OpenInventory('stash', stashSettings.id)
    end
end