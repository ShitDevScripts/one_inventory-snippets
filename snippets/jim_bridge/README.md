### Inventory Setup
To use `one_inventory` with `jim_bridge`, follow these steps:

Navigate to the following directory:

`jim_bridge`

Place the `one_inventory` bridge snippets provided above inside the corresponding files (`starter.lua`, `frameworkCache.lua`, `shared/coreloader.lua`, and `shared/itemcontrol.lua`).

Save the files and restart the resource.

`jim_bridge` will now use `one_inventory` as its inventory system.

*script by Jimathy: https://github.com/jimathy*


## Breif At a shot
Here are the exact files and the specific code snippets added to each one for the `one_inventory` integration. You can copy and paste these directly into your documentation.

### 1. `starter.lua`
**Location:** Inside the `Exports = { ... }` table.
**Code Added:**
```lua
    OneInv = "one_inventory",
```

---

### 2. `frameworkCache.lua`
**Location 1:** Inside the `local itemFunc = { ... }` list (we placed this at the top of the list).
**Code Added:**
```lua
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
```

**Location 2:** Inside the `QBXExport` fallback block (around line 160) inside the `if not cache.Items then` check.
**Code Added:**
```lua
                if GetResourceState(Exports.OneInv):find("start") then
                    itemResource = Exports.OneInv
                    cache.Items = exports[Exports.OneInv]:GetAllItemDefinitions()
                    while not (cache.Items and next(cache.Items)) do
                        Wait(1000)
                        cache.Items = exports[Exports.OneInv]:GetAllItemDefinitions()
                    end
```

---

### 3. `shared/coreloader.lua`
**Location 1:** In the variable mapping near the top of the file.
**Code Added/Modified:**
```lua
OXInv, QBInv, PSInv, OneInv, CoreInv, CodeMInv, OrigenInv, TgiannInv, JPRInv =
    Exports.OXInv or "",
    Exports.QBInv or "",
    Exports.PSInv or "",
    Exports.OneInv or "",
    Exports.CoreInv or "",
    Exports.CodeMInv or "",
    Exports.OrigenInv or "",
    Exports.TgiannInv or "",
    Exports.JPRInv or ""
```

**Location 2:** Inside the item image processing loop (directly below the `if isStarted(OXInv)` block).
**Code Added:**
```lua
            elseif isStarted(OneInv) then
                for k, v in pairs(Items) do
                    local tempInfo = exports[OneInv]:GetItemDefinition(k)
                    Items[k].image = k..".png" -- Set default image
                    if tempInfo and tempInfo.image then
                        Items[k].image = tempInfo.image
                    end
                end
```

---

### 4. `shared/itemcontrol.lua`
**Location:** Inside the `local InvFunc = { ... }` table.
**Code Added:**
```lua
    {   invName = OneInv,
        removeItem =
            function(src, item, remamount)
                exports[OneInv]:RemoveItem(src, item, remamount, nil)
            end,
        addItem =
            function(src, item, amountToAdd, info, slot)
                exports[OneInv]:AddItem(src, item, amountToAdd, info, slot)
            end,
        setItemMetadata =
            function(data, src)
                exports[OneInv]:SetItemMetadata(src, data.slot, data.metadata)
            end,
        hasItem =
            function(item, amount, src)
                if src then
                    local serverItemCheck = exports[OneInv]:GetItemCount(src, item) or 0
                    return serverItemCheck >= amount, serverItemCheck
                else
                    local localItemCheck = exports[OneInv]:GetItemCount(item) or 0
                    return localItemCheck >= amount, localItemCheck
                end
            end,
        canCarry =
            function(itemTable, src)
                local resultTable = {}
                for k, v in pairs(itemTable) do
                    resultTable[k] = exports[OneInv]:CanCarryItem(src, k, v)
                end
                return resultTable
            end,
        getMaxInvWeight =
            function()
                return InventoryWeight
            end,
        getCurrentInvWeight =
            function(src)
                return exports[OneInv]:GetWeightHolding(src or source)
            end,
        getPlayerInv =
            function(src)
                return exports[OneInv]:GetInventoryItems(src or source)
            end,
        invImg =
            function(item)
                return "nui://"..OneInv.."/html/images/"..(Items[item].image or "")
            end,
        openShop =
            function(name, label, items)
                exports[OneInv]:OpenInventory('shop', name)
            end,
        serverOpenShop = function(shopName)
            exports[OneInv]:OpenInventory(source, 'shop', shopName)
        end,
        registerShop =
            function(name, label, items, society)
                exports[OneInv]:RegisterShop({
                    name = name,
                    label = label,
                    inventory = items,
                    jobs = society,
                })
            end,
        openStash =
            function(data)
                exports[OneInv]:OpenInventory('stash', { id = data.stash, label = data.label, slots = data.slots, maxWeight = data.maxWeight })
            end,
        clearStash =
            function(stashId)
                exports[OneInv]:ClearInventory('stash:'..stashId)
            end,
        getStash =
            function(stashName)
                local stash = exports[OneInv]:GetInventoryItems('stash:'..stashName)
                return type(stash) == "table" and stash or {}
            end,
        stashEditMetadata =
            function(stash, slot, metadata)
                exports[OneInv]:SetItemMetadata(stash, slot, metadata)
            end,
        stashAddItem =
            function(stashItems, stashName, items)

            end,
        stashRemoveItem =
            function(stashItems, stashName, items)
                for k, v in pairs(items) do
                    for _, name in pairs(stashName) do
                        local success = exports[OneInv]:RemoveItem('stash:'..name, k, v)
                        if success then
                            debugPrint("^6Bridge^7: ^2Removing ^3"..OneInv.." ^2Stash item^7:", k, v)
                            break
                        end
                    end
                end
            end,
        registerStash =
            function(name, label, slots, weight, owner, coords)
                -- Auto-created
            end,
    },
```
