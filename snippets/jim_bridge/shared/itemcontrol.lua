-- Find the local InvFunc = { ... } table. Add this massive block inside of it to completely route all Jim scripts to their one_inventory counterparts.

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
