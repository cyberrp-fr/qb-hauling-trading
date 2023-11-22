local QBCore = exports["qb-core"]:GetCoreObject()
local DATA_FILE = "data/state.json"
local Locations
local stateLoaded = false


-- Add product items to qb-core shared object
RegisterProducts()

---------------
-- FUNCTIONS --
---------------

local function isValidItem(itemName)
    if Config.BasePrices[itemName] ~= nil then
        return true
    end

    return false
end

exports("isValidItem", isValidItem)

-- GET function of produced products of location
local function GetLocation(locationName)
    for i, loc in pairs(Locations) do
        if loc.enabled and loc.name == locationName then
            return loc
        end
    end

    return nil
end

local function GetProductFromLocation(locationData, productName)
    for k, item in pairs(locationData.produces) do
        if item["name"] == productName then return item end
    end

    return
end

local function vehicleHasHowManyItems(vehicleItems, itemName)
    local count = 0
    for k, item in pairs(vehicleItems) do
        if item.name == itemName then
            count = count + item.amount
        end
    end

    return count
end

-- deplete stock (called every x minutes)
local function updateDepletion()
    for i, loc in pairs(Locations) do
        -- ignore if disabled
        if loc.enabled then
            for key, product in pairs(loc.consumes) do
                if product["stock"] > 0 then
                    local rate = product["rate"]
                    product["stock"] = product["stock"] - rate
                    if product["stock"] < 0 then
                        product["stock"] = 0
                    end

                    Locations[i].consumes[key] = product
                end
            end
        end
    end
end

-- produce stock (called every x minutes)
local function updateProduction()
    for i, loc in pairs(Locations) do
        -- ignore disabled locations
        if loc.enabled then
            for key, product in pairs(loc.produces) do
                local rate = product["rate"]
                product["stock"] = product["stock"] + rate
                if product["stock"] > product["desiredStock"] then
                    product["stock"] = product["desiredStock"]
                end

                Locations[i].produces[key] = product
            end
        end
    end
end

-- update prices based on available stock of location (not basing on the demand of the whole market but just the given location)
local function updateSupplyDemand()
    for i, loc in pairs(Locations) do
        if loc.enabled then

            -- consumption prices
            for key, product in pairs(loc.consumes) do
                local basePrice = Config.BasePrices[product["name"]]
                local desiredStock = product["desiredStock"]
                local currentStock = product["stock"]

                local demand = desiredStock - currentStock
                local supply = currentStock
                local price = basePrice * (1 + (demand - supply) / supply)
                if price < basePrice then
                    price = basePrice
                end

                local minimumPrice = product["minimumPrice"]
                local maximumPrice = product["maximumPrice"]

                -- not more than basePrice * 2
                -- if price > (basePrice * 3) then
                --     price = basePrice * 3
                -- end

                if minimumPrice and price < minimumPrice then
                    price = minimumPrice
                end

                if maximumPrice and price > maximumPrice then
                    price = maximumPrice
                end

                Locations[i].consumes[key]["demandPrice"] = math.floor(price)
            end

            -- production prices
            for key, product in pairs(loc.produces) do
                local basePrice = Config.BasePrices[product["name"]]
                -- local desiredStock = product["desiredStock"]
                -- local currentStock = product["stock"]

                -- for now, price will base price of the product

                Locations[i].produces[key]["price"] = basePrice
            end
        end
    end
end

-----------
-- LOOPS --
-----------

local function MainLoop()
    local loaded = LoadResourceFile(GetCurrentResourceName(), DATA_FILE)
    if loaded ~= nil then
        Locations = json.decode(loaded)
    else
        Locations = Config.Locations
    end

    updateSupplyDemand()

    while true do
        updateDepletion()
        updateProduction()
        updateSupplyDemand()

        SaveResourceFile(GetCurrentResourceName(), DATA_FILE, json.encode(Locations))

        Wait(600000)
    end
end

------------
-- EVENTS --
------------

AddEventHandler("onResourceStart", function (resource)
    if resource ~= GetCurrentResourceName() then return end

    CreateThread(function ()
        MainLoop()
    end)
end)

-- AddEventHandler("onResourceStop", function (resource)
--     if resource ~= GetCurrentResourceName() then return end

--     SaveResourceFile(resource, DATA_FILE, json.encode(Locations))
-- end)

RegisterServerEvent("qb-import-export:server:sellProduct", function (data)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local locationName = data.locationName
    local product = data.item
    local amount = data.amount
    local price = data.price

    if not QBCore.Functions.HasItem(src, product, amount) then
        QBCore.Functions.Notify(src, Lang:t("error.cannot_sell_not_enough"), "error")
        return
    end

    player.Functions.RemoveItem(product, amount)
    player.Functions.AddMoney("bank", price, "import-export")

    TriggerEvent("qb-import-export:server:updateConsumptionStock", locationName, product, amount, "+") -- update stock of location (add the sold amount)
    TriggerClientEvent("qb-import-export:client:menu:open", src)
end)

RegisterServerEvent("qb-import-export:server:vehicle:sellProduct", function (data)
    local src = source
    local locationName = data.locationName
    local productName = data.item
    local amount = data.amount
    local totalPrice = data.price
    local vehiclePlate = data.vehiclePlate

    if not vehiclePlate then
        QBCore.Functions.Notify(src, Lang:t("error.vehicle_plate_error"), "error")
        return
    end

    local vehicleItems = exports["qb-inventory"]:getTrunkItems(vehiclePlate)
    local itemCount = vehicleHasHowManyItems(vehicleItems, productName)
    if itemCount < amount then
        QBCore.Functions.Notify(src, Lang:t("error.not_enough_inventory"), "error")
        return
    end

    -- remove items from vehicle trunk
    local cleanedInv = {}
    for k, item in pairs(vehicleItems) do
        if item["name"] ~= productName then
            cleanedInv[item["slot"]] = item
        end
    end

    -- set vehicle trunk
    exports["qb-inventory"]:addTrunkItems(vehiclePlate, cleanedInv)
    exports["qb-inventory"]:saveVehicleTrunkIfOwned(vehiclePlate) -- force db save for owned vehicles

    -- pay player for this sale
    local Player = QBCore.Functions.GetPlayer(src)
    local reason = "[qb-import-export] user \"" .. Player.PlayerData.name .. "\" sold x".. tostring(amount) .. " " .. productName .. " at location: " .. locationName
    Player.Functions.AddMoney("bank", totalPrice, reason)

    -- update stock
    TriggerEvent("qb-import-export:server:updateConsumptionStock", locationName, productName, amount, "+")
end)

-- update stock after player purchase
RegisterServerEvent("qb-import-export:server:updateProductionStock", function (locationName, itemName, amount, type)
    amount = tonumber(amount)
    for k, loc in pairs(Locations) do
        if loc["name"] == locationName then
            for pName, product in pairs(loc.produces) do
                if product["name"] == itemName then
                    if type == "-" and product["stock"] >= amount then
                        product["stock"] -= amount
                    elseif type == "+" then
                        product["stock"] += amount
                    end

                    Locations[k].produces[pName] = product
                end
            end
        end
    end

    updateSupplyDemand()
end)

RegisterServerEvent("qb-import-export:server:updateConsumptionStock", function (locationName, itemName, amount, type)
    amount = tonumber(amount)
    for k, loc in pairs(Locations) do
        if loc["name"] == locationName then
            for pName, product in pairs(loc.consumes) do
                if product["name"] == itemName then
                    if type == "-" and product["stock"] >= amount then
                        product["stock"] -= amount
                    elseif type == "+" then
                        product["stock"] += amount
                    end

                    Locations[k].consumes[pName] = product
                end
            end
        end
    end

    updateSupplyDemand()
end)

RegisterServerEvent("qb-import-export:server:buyProductAndLoadIntoTruck", function (data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local locationName = data.locationName
    local productName = data.productName
    local amount = data.amount
    local vehiclePlate = data.vehiclePlate

    local location = GetLocation(locationName)
    if not location or next(location.produces) == nil then
        QBCore.Functions.Notify(src, Lang:t("error.location_does_not_sell_product"), "error")
        return
    end

    local product = GetProductFromLocation(location, productName)
    if not product then
        QBCore.Functions.Notify(src, Lang:t("error.location_does_not_sell_product"), "error")
        return
    end

    if product["stock"] < amount then
        QBCore.Functions.Notify(src, Lang:t("error.not_enough_stock"), "error")
        return
    end

    local totalPrice = amount * product["price"]
    local bankMoney = Player.Functions.GetMoney("bank")

    if bankMoney < totalPrice then
        QBCore.Functions.Notify(Lang:t("error.not_enough_money"), "error")
        return
    end

    local itemData = QBCore.Shared.Items[productName]

    local items = exports["qb-inventory"]:getTrunkItems(vehiclePlate)
    if items == nil then
        items = {}
    end

    local hasAlreadyItem = false
    local existingItem
    for k, v in pairs(items) do
        if v["name"] == productName then
            hasAlreadyItem = true
            existingItem = v
        end
    end

    if hasAlreadyItem then
        existingItem["amount"] = existingItem["amount"] + amount
        items[existingItem["slot"]] = existingItem

        exports["qb-inventory"]:addTrunkItems(vehiclePlate, items)

        -- payment
        local reason = "[qb-import-export] user \"" .. Player.PlayerData.name .. "\" bought x".. tostring(amount) .. " " .. productName .. " at location: " .. locationName
        Player.Functions.RemoveMoney("bank", totalPrice, reason)

        -- update stock
        TriggerEvent("qb-import-export:server:updateProductionStock", locationName, productName, amount, "-")

        return
    end

    local slot = 1
    local freeSlot = false
    for i = 1, 30, 1 do
        if items[i] == nil then
            slot = i
            freeSlot = true
            break
        end
    end
    if not freeSlot then
        QBCore.Functions.Notify(Lang:t("error.no_slots_available"), "error")
        return
    end

    items[1] = {
        name = itemData["name"],
        label = itemData["label"],
        description = itemData["description"],
        slot = slot,
        info = {},
        amount = amount,
        type = itemData["type"],
        weight = itemData["weight"],
        image = itemData["image"],
        unique = itemData["unique"],
        useable = itemData["useable"]
    }

    exports["qb-inventory"]:addTrunkItems(vehiclePlate, items)

    -- payment
    local reason = "[qb-import-export] user \"" .. Player.PlayerData.name .. "\" bought x".. tostring(amount) .. " " .. productName
    Player.Functions.RemoveMoney("bank", totalPrice, reason)

    -- update stock
    TriggerEvent("qb-import-export:server:updateProductionStock", locationName, productName, amount, "-")
end)


---------------
-- CALLBACKS --
---------------

QBCore.Functions.CreateCallback("qb-import-export:server:getLocationData", function(source, cb, locationName)
    cb(GetLocation(locationName))
end)

-- return trunk data of a vehicle identified by license plate
QBCore.Functions.CreateCallback("qb-import-export:server:vehicle:getTrunkItems", function (_, cb, plate)
    local items = exports["qb-inventory"]:getTrunkItems(plate)
    if items == nil then items = {} end

    cb(items)
end)