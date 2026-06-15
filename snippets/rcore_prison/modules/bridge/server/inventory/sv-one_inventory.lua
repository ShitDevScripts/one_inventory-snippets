ONE_INVENTORY_ITEMS_DEPLOY = {
    {
        name = 'sludgie',
        label = 'Sludgie',
        weight = 350,
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = 'prop_ld_can_01', pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
            usetime = 2500,
            notification = 'You quenched your thirst with a Coffee',
        },
    },
    {
        name = 'ecola_light',
        label = 'Ecola light',
        weight = 350,
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = 'prop_ld_can_01', pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
            usetime = 2500,
            notification = 'You quenched your thirst with a Coffee',
        },
    },
    {
        name = 'ecola',
        label = 'Ecola',
        weight = 350,
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = 'prop_ld_can_01', pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
            usetime = 2500,
            notification = 'You quenched your thirst with a Coffee',
        },
    },
    {
        name = 'coffee',
        label = 'Coffee',
        weight = 350,
        client = {
            status = { thirst = 200000 },
            anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
            prop = { model = 'prop_ld_can_01', pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
            usetime = 2500,
            notification = 'You quenched your thirst with a Coffee',
        },
    },
    {
        name = 'fries',
        label = 'Fries',
        weight = 350,
        client = {
            status = { hunger = 200000 },
            anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
            prop = { model = 'prop_food_cb_chips', pos = vec3(0.02, 0.02, -0.02), rot = vec3(0.0, 0.0, 0.0) },
            usetime = 2500,
            notification = 'You eat Fries',
        },
    },
    {
        name = 'pizza_ham',
        label = 'Pizza Ham',
        weight = 350,
        client = {
            status = { hunger = 200000 },
            anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
            prop = { model = 'prop_food_cb_chips', pos = vec3(0.02, 0.02, -0.02), rot = vec3(0.0, 0.0, 0.0) },
            usetime = 2500,
            notification = 'You eat Fries',
        },
    },
    {
        name = 'chips',
        label = 'Chips',
        weight = 350,
        client = {
            status = { hunger = 200000 },
            anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
            prop = { model = 'prop_food_cb_chips', pos = vec3(0.02, 0.02, -0.02), rot = vec3(0.0, 0.0, 0.0) },
            usetime = 2500,
            notification = 'You eat Chips',
        },
    },
    {
        name = 'donut',
        label = 'Donut',
        weight = 350,
        client = {
            status = { hunger = 200000 },
            anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
            prop = { model = 'prop_amb_donut', pos = vec3(0.02, 0.02, -0.02), rot = vec3(0.0, 0.0, 0.0) },
            usetime = 2500,
            notification = 'You eat Donut',
        },
    },
    {
        name = 'wire_cutter',
        label = 'cutter',
        weight = 100,
        stack = true,
        consume = 0,
        close = true,
    },
    {
        name = 'cigarrete',
        label = 'Cigarrete',
        weight = 100,
        stack = true,
        consume = 0,
        close = true,
    },
    {
        name = 'prison_tablet',
        label = 'Prison Tablet',
        weight = 100,
        stack = true,
        consume = 0,
        close = true,
    },
}

local ONE_INV = 'one_inventory'

local function vec3ToTable(v)
    if type(v) ~= 'vector3' and type(v) ~= 'userdata' then
        return v
    end
    return { x = v.x, y = v.y, z = v.z }
end

--- Maps ox-style item tables to one_inventory CreateItemsDefinition fields.
--- https://onestudios.gg/docs/server/exports#createitemsdefinition
--- https://onestudios.gg/docs/guides/usable-items
local function toOneInventoryDefinition(def)
    local one = {
        name = def.name,
        label = def.label or def.name,
        weight = def.weight or 0,
        unique = def.stack == false,
    }

    if def.consume ~= nil then
        one.consume = def.consume
    end

    if def.close ~= nil then
        one.close = def.close
    end

    local client = def.client
    if not client then
        return one
    end

    one.useTime = client.usetime
    one.notification = client.notification

    if client.status then
        one.statusHunger = client.status.hunger
        one.statusThirst = client.status.thirst
    end

    -- one_inventory normally references animationId/propId from the admin panel.
    -- Inline anim/prop are passed for runtime registration when supported.
    if client.anim then
        one.animation = {
            dict = client.anim.dict,
            clip = client.anim.clip,
        }
    end

    if client.prop then
        one.prop = {
            model = client.prop.model,
            pos = vec3ToTable(client.prop.pos),
            rot = vec3ToTable(client.prop.rot),
        }
    end

    return one
end

local function deployOneInventoryItems()
    if GetResourceState(ONE_INV) ~= 'started' then
        return
    end

    for i = 1, #ONE_INVENTORY_ITEMS_DEPLOY do
        local def = toOneInventoryDefinition(ONE_INVENTORY_ITEMS_DEPLOY[i])
        local ok = exports[ONE_INV]:CreateItemsDefinition(def)
        if not ok then
        end
    end
end

CreateThread(function()
  if Config.Inventories ~= Inventories.ONE then
    return
  end

  while GetResourceState(ONE_INV) ~= 'started' do
    Wait(200)
  end

  deployOneInventoryItems()

  Inventory.hasItem = function(client, item, amount)
    amount = amount or 1
    local itemAmount = exports[ONE_INV]:GetItemCount(client, item)
    return itemAmount and itemAmount >= amount or false
  end

  Inventory.DoesItemExist = function(itemName, playerId)
    local itemData = exports[ONE_INV]:GetItemDefinition(itemName)
    if itemData then
      return true
    end

    if ServerItems[itemName:upper()] then
      return true
    end

    return false
  end

  --- @return boolean success
  Inventory.addItem = function(client, item, amount, data)
    if not doesExportExistInResource(ONE_INV, 'AddItem') then
      return dbg.critical(
        'Inventory.addItem: AddItem export does not exist in one_inventory. Ensure one_inventory is started before this resource.'
      )
    end

    if not Inventory.DoesItemExist(item, client) then
      return dbg.critical(
        'Inventory.addItem: Attempted to add an item that does not exist in one_inventory - %s',
        item
      )
    end

    return exports[ONE_INV]:AddItem(client, item, amount, data) == true
  end

  Inventory.addMultipleItems = function(client, items)
    if not client or not items then
      return
    end

    local p = promise.new()

    if next(items) then
      for i = 1, #items, 1 do
        local item = items[i]

        if item and next(item) then
          Inventory.addItem(client, item.name, item.count, item.metadata)
        end

        if i >= #items then
          p:resolve(true)
        end
      end
    else
      p:resolve(false)
    end

    return Citizen.Await(p)
  end

  Inventory.removeItem = function(client, item, amount, data)
    return exports[ONE_INV]:RemoveItem(client, item, amount, data)
  end

  Inventory.registerUsableItem = function(name, cb)
    AddEventHandler('bridge:usedItem', function(playerId, itemName, slotId, metadata)
      if name == itemName then
        cb(playerId, itemName, slotId, metadata)
      end
    end)
  end

  AddEventHandler('one_inventory:onItemUsed', function(payload)
    if not payload or not payload.source or not payload.item then
      return
    end

    TriggerEvent(
      'bridge:usedItem',
      payload.source,
      payload.item,
      payload.slot,
      payload.metadata
    )
  end)

  local function safeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
    print('Error:', result)
    end
    return success, result
  end

  Inventory.getInventoryItems = function(playerId)
    local slots = exports[ONE_INV]:GetInventoryItems(playerId)
    local inventory, count = {}, 0

    if not slots then
      return inventory
    end

    for i = 1, #slots do
      local v = slots[i]
      if v.name and (v.count or 0) > 0 then
        count += 1
        inventory[count] = {
          name = v.name,
          count = v.count,
          slot = v.slot,
          metadata = v.metadata and next(v.metadata) and v.metadata or nil,
        }
      end
    end

    return inventory
  end

  Inventory.clearInventory = function(playerId)
    local state, _ = pcall(function()
      if Config.Stash.KeepItems and Inventory.KeepSessionItems and #Inventory.KeepSessionItems > 0 then
        local cleared = exports[ONE_INV]:ClearInventory(playerId, Inventory.KeepSessionItems)

        if not Inventory.KeepSessionItems['money'] or not Inventory.KeepSessionItems['cash'] then
          if Config.Framework == Framework.ESX then
            local money = safeCall(Framework.getMoney, playerId)

            if money and money > 0 then
              Framework.removeMoney(playerId, money)
            end
          end
        end

        return cleared
      end

      return exports[ONE_INV]:ClearInventory(playerId)
    end)

    return state
  end
end)
