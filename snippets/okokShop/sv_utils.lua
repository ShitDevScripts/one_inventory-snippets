
QBCore = exports['qb-core']:GetCoreObject()
Webhook = ''

function GetAccountMoney(xPlayer, account)
	local moneyCount = 0
	if account == "cash" then
		moneyCount = xPlayer.PlayerData.money.cash
	else
		moneyCount = xPlayer.PlayerData.money.bank
	end
	return moneyCount
end

function AddMoney(xPlayer, account, amount, storeID)
	xPlayer.Functions.AddMoney(account, tonumber(amount))
end

function RemoveMoney(xPlayer, account, amount, storeID)
	xPlayer.Functions.RemoveMoney(account, tonumber(amount))
end

function MySQLexecute(query, values, func)
	return MySQL.query(query, values, func)
end

function MySQLinsert(query, values, func)
	return MySQL.Async.insert(query, values, func)
end

function MySQLfetchAll(query, values, func)
	return MySQL.Sync.fetchAll(query, values, func)
end

function giveItem(Player, item, amount, metadata, slot)
    amount = tonumber(amount) or 1
    local source = Player.PlayerData.source
    -- One Inventory
    if GetResourceState('one_inventory') == 'started' then
        local ok, result = exports.one_inventory:AddItem(source, item, amount, metadata, slot)
        return ok == true or result == true
    end
    -- ox_inventory
    if GetResourceState('ox_inventory') == 'started' then
        return exports.ox_inventory:AddItem(source, item, amount, metadata, slot) == true
    end
    -- qs-inventory
    if GetResourceState('qs-inventory') == 'started' then
        return exports['qs-inventory']:AddItem(source, item, amount, slot, metadata) == true
    end
    -- QB / Qbox fallback (qb-inventory style)
    return Player.Functions.AddItem(item, amount, slot, metadata) == true
end

function canCarryIt(item, amount, xPlayer)
	amount = tonumber(amount) or 1
	local source = xPlayer.PlayerData.source
	-- One Inventory
	if GetResourceState('one_inventory') == 'started' then
		local canCarry = exports.one_inventory:CanCarryItem(source, item, amount)
		if not canCarry then notifyPocketsFull(source) end
		return canCarry
	end
	-- ox_inventory (Qbox default on many servers)
	if GetResourceState('ox_inventory') == 'started' then
		local canCarry = exports.ox_inventory:CanCarryItem(source, item, amount)
		if not canCarry then notifyPocketsFull(source) end
		return canCarry
	end
	-- qs-inventory
	if GetResourceState('qs-inventory') == 'started' then
		local canCarry = exports['qs-inventory']:CanCarryItem(source, item, amount)
		if not canCarry then notifyPocketsFull(source) end
		return canCarry
	end
	-- QB / Qbox fallback (qb-inventory / no modern inventory resource)
	local itemInfo = getItemInfo(item)
	if not itemInfo then
		notifyItemUnavailable(source, item)
		return false
	end
	local totalWeight = getPlayerCarryWeight(xPlayer)
	if (totalWeight + (itemInfo.weight * amount)) <= MAX_CARRY_WEIGHT then
		return true
	end
	notifyPocketsFull(source)
	return false
end
-- Buy Store Event
QBCore.Functions.CreateCallback(Config.EventPrefix..':buyStore', function (source, cb, id, name, price, currency)
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(_source)
	local PlayerName = xPlayer.PlayerData.charinfo.firstname .. " " .. xPlayer.PlayerData.charinfo.lastname
	local bankMoney = GetAccountMoney(xPlayer, 'bank')
	local businessPrice = 0
	local count = 0
	local itemsList = {}

	if bankMoney >= price then
		MySQL.query('SELECT * FROM okokshop_stores WHERE owner = @owner', {
			['@owner'] = xPlayer.PlayerData.citizenid,
		}, function(owning)

			if #owning < Config.MaxShopsPerPlayer then
				for k,v in pairs(Config.Stores) do
					if v.id == id then
						businessPrice = v.price
					end
				end

				for k,v in pairs(Config.Stores) do

					if id == v.id then
						for k2,v2 in pairs(Config.AvailableItems) do
							if v2.type == v.type then
								table.insert(itemsList, {
									name = v2.name,
									label = v2.label,
									price = v2.price,
									amount = v2.amount
								})
							end
						end
					end
				end

				for k,v in pairs(itemsList) do
                    count = count + v.amount
					v.sold = 0
                end

				MySQL.update('UPDATE okokshop_stores SET owner = @owner, owner_name = @name, business_price = @business_price, current_stock = @current_stock, items = @items WHERE store_id = @store_id AND owner IS NULL', {
					['@owner'] = xPlayer.PlayerData.citizenid,
					['@name'] = xPlayer.PlayerData.charinfo.firstname.." "..xPlayer.PlayerData.charinfo.lastname,
					['@store_id'] = id,
					['@business_price']	= businessPrice,
					['@current_stock'] = count,
					['@items'] = json.encode(itemsList),
				}, function (rowsChanged)
					RemoveMoney(xPlayer, 'bank', price)
					TriggerClientEvent(Config.EventPrefix..":updateStoresOwned", -1)
					TriggerClientEvent(Config.EventPrefix..':notification', _source, _okok('bought_store').title, interp(_okok('bought_store').text, {name = name, price = price}), _okok('bought_store').type, _okok('bought_store').time)
					cb(true)
					if Config.UseOkokBanking then
						TriggerEvent('okokBanking:AddNewTransaction', _okok('translations').shop, _okok('translations').shop, PlayerName, xPlayer.PlayerData.citizenid, price, _okok('translations').buybusiness)
					end
					if Webhook ~= '' and Config.BuyBusinessWebhook then
						local identifierlist = ExtractIdentifiers(_source)
						local data = {
							playerid = _source,
							identifier = identifierlist.license:gsub("license2:", ""),
							discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
							color = Config.BuyBusinessWebhookColor,
							type = "buyBusiness",
							action = "Bought a business",
							item = id,
							price = price,
							title = "Shop - Business",
						}
						discordWebhook(data)
					end
				end)
			else
				TriggerClientEvent(Config.EventPrefix..':notification', _source, _okok('max_stores').title, _okok('max_stores').text, _okok('max_stores').type, _okok('max_stores').time)
			end
		end)
	else
		TriggerClientEvent(Config.EventPrefix..':notification', _source, _okok('not_enough_money').title, _okok('not_enough_money').text, _okok('not_enough_money').type, _okok('not_enough_money').time)
		cb(false)
	end
end)


-- Webhooks
function discordWebhook(data)
	local information = {}

	if data.type == 'buyBusiness' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Price:** '..data.price..' ' .. Config.Currency .. '\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'sellBusiness' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Received:** '..data.price..' ' .. Config.Currency .. '\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'deposit' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Deposited:** '..data.price..' ' .. Config.Currency .. '\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'withdraw' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Withdrawn:** '..data.price..' ' .. Config.Currency .. '\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'hire' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Employee name:** '..data.employee_name..'\n**Employee identifier:** '..data.employee_id..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'fire' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Employee name:** '..data.employee_name..'\n**Employee identifier:** '..data.employee_id..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'fireMyself' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Employee name:** '..data.employee_name..'\n**Employee identifier:** '..data.employee_id..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'changeRank' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Employee Name:** '..data.employee_name..'\n**Employee Identifier:** '..data.employee_id..'\n**Rank:** '..data.rank..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'newOrder' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Amount:** '..data.amount..'L\n**Price:** '..data.reward.. ' ' ..Config.Currency.. '\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'orderAccepted' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Employee Name:** '..data.employee_name..'\n**Employee Identifier:** '..data.employee_id..'\n\n**Order ID:** '..data.orderID..'\n**Reward:** '..data.amount..' ' ..Config.Currency.. '\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'orderCanceled' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Employee Name:** '..data.employee_name..'\n**Employee Identifier:** '..data.employee_id..'\n\n**Order ID:** '..data.orderID..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'buyItem' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Bought:** '..data.itemNames..' \n**Final Price:** '..data.payment.. '' .. Config.Currency .. '\n**Payment Method:** ' .. data.paymentMethod .. '\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'exploitDetectedItem' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Customer Name:** '..data.employee_name..'\n**Customer Identifier:** '..data.employee_id..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'exploitDetectedPrice' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Customer Name:** '..data.employee_name..'\n**Customer Identifier:** '..data.employee_id..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	end
	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = Config.BotName, embeds = information}), {['Content-Type'] = 'application/json'})
end