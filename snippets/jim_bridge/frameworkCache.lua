-- 1. Cache Items Hook Find local itemFunc = { ... } and add this chunk at the very top of the list. 
-- This tells the bridge how to fetch items and includes a retry loop if the database is slow to load during server startup.
    {   script = Exports.OneInv,
        cacheItem = function()
            local success, result = pcall(function()
                return exports[Exports.OneInv]:GetAllItemDefinitions()
            end)
            if success and result and next(result) then
                cache.Items = result
            else
                while not (cache.Items and next(cache.Items)) do
                    Wait(1000)
                    success, result = pcall(function()
                        return exports[Exports.OneInv]:GetAllItemDefinitions()
                    end)
                    if success and result and next(result) then
                        cache.Items = result
                    end
                end
            end
        end,
    },
