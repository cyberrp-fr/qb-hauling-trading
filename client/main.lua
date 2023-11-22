-- VARIABLES 
local QBCore = exports["qb-core"]:GetCoreObject()
local Locations = {}

local isPlayerInZone = false
local helpTextShowing = false

local currentVisitedLocationData
local playerData

local lastUsedVehicle -- vehicle that player was in last
local vehiclePlate
local spaceAvailableInVehicle = 0

---------------
-- FUNCTIONS --
---------------
local function loadModel(model)
    if type(model) == 'number' then
        model = model
    else
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end

local function waitForEntity(entity)
    while not DoesEntityExist(entity) do
        Wait(100)
    end
end

local function CreateBlip(blipData)
    local blip = AddBlipForCoord(blipData.coords.x, blipData.coords.y, blipData.coords.z)
    SetBlipSprite(blip, blipData.sprite)
    SetBlipDisplay(blip, blipData.display)
    SetBlipScale(blip, blipData.scale)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, blipData.color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(blipData.label)
    EndTextCommandSetBlipName(blip)
end

local function createPed(name, pos, scenario)
    loadModel(name)

    local ped = CreatePed(0, GetHashKey(name), pos.xyz, pos.w, false)
    waitForEntity(ped)
    Wait(500)
    SetPedDefaultComponentVariation(ped)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    TaskStartScenarioInPlace(ped, scenario, 0, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    return ped
end

local function createLocations()
    for k,loc in pairs(Config.Locations) do
        -- is enabled ?
        if loc.enabled and Locations[loc.name] == nil then
            Locations[loc.name] = {}
            Locations[loc.name]["ped"] = createPed(loc.ped, loc.pos, loc.pedScenario)
            Locations[loc.name]["pos"] = loc.pos
            Locations[loc.name]["name"] = loc.name

            if loc.blip ~= nil and loc.blip.enabled == true then
                CreateBlip(loc.blip)
            end
        end
    end
end

local function deleteLocations()
    for k,loc in pairs(Locations) do
        if DoesEntityExist(loc.ped) then
            DeleteEntity(loc.ped)
        end
    end
end

local function retrieveCurrentVisitedLocationData(locationName)
    local done = false
    local result
    QBCore.Functions.TriggerCallback("qb-import-export:server:getLocationData", function(data)
        result = data
        done = true
    end, locationName)

    while not done do
        Wait(100)
    end

    return result
end

local function playerHasHowManyItems(playerData, itemName)
    for k, item in pairs(playerData.items) do
        if item.name == itemName then
            return item.amount
        end
    end

    return 0
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

-- MENUS (qb-menu)
local function openMainMenu(location)
    if location == nil then
        QBCore.Functions.Notify("no location nearby", "error")
        return
    end

    local locationData = retrieveCurrentVisitedLocationData(location["name"])
    currentVisitedLocationData = locationData

    playerData = QBCore.Functions.GetPlayerData()

    local consumedItems = Config.Functions.GetConsumedItems(location["name"])
    local producedItems = Config.Functions.GetProducedItems(location["name"])
    for k,v in pairs(consumedItems) do
        consumedItems[k] = Lang:t("item_price." .. v, {amount = locationData.consumes[v]["demandPrice"]})
    end
    for k,v in pairs(producedItems) do
        producedItems[k] = Lang:t("item_price." .. v, {amount = locationData.produces[v]["price"]})
    end
    local consumedTxt = table.concat(consumedItems, "<br> - ")
    local producedTxt = table.concat(producedItems, "<br> - ")

    local txt = Lang:t("menu.header", {items = consumedTxt, soldItems = producedTxt})
    txt = txt .. "<br><br>" .. Lang:t("info.header_bottom")

    local menu = {
        {
            header = Lang:t("location." .. location["name"]),
            isMenuHeader = true,
            txt = txt
        }
    }

    -- if this location buys products
    if next(locationData.consumes) ~= nil then
        local hasAny = false
        local vehicleHasAny = false
        local vehicleItems
        if lastUsedVehicle ~= 0 then
            vehiclePlate = GetVehicleNumberPlateText(lastUsedVehicle)
            local resolved = false
            QBCore.Functions.TriggerCallback("qb-import-export:server:vehicle:getTrunkItems", function (items)
                vehicleItems = items
                resolved = true
            end, vehiclePlate)

            while not resolved do Wait(100) end
        end

        for key, product in pairs(locationData.consumes) do
            if QBCore.Functions.HasItem(product["name"], 1) then
                hasAny = true
            end

            if vehicleItems ~= nil then
                for k, v in pairs(vehicleItems) do
                    if v["name"] == product["name"] then
                        vehicleHasAny = true
                        break
                    end
                end
            end
        end

        if hasAny or vehicleHasAny then
            table.insert(menu, {
                header = Lang:t("info.resell"),
                txt = Lang:t("info.resell_help"),
                params = {
                    event = "qb-import-export:client:resellMenu",
                    args = {
                        vehicleItems = vehicleItems,
                        playerHasAny = hasAny,
                        vehicleHasAny = vehicleHasAny,
                        vehiclePlate = vehiclePlate
                    }
                }
            })

            -- table.insert(menu, {
            --     header = Lang:t("info.show_your_inventory"),
            --     txt = Lang:t("info.show_your_inventory_text"),
            --     params = {
            --         event = "qb-import-export:client:showInventory"
            --     }
            -- })
        end
    end

    if next(locationData.produces) ~= nil then
        table.insert(menu, {
            header = Lang:t("info.acquisition"),
            txt = Lang:t("info.acquisition_help"),
            params = {
                event = "qb-import-export:client:acquisitionMenu",
                args = {
                    location = location
                }
            }
        })
    end

    local headerTxt = Lang:t("info.close")
    local headerTxtHelp = nil
    if next(menu, 1) == nil then
        headerTxt = Lang:t("info.nothing_to_do")
        headerTxtHelp = Lang:t("info.nothing_to_do_help")
    end

    table.insert(menu, {
        header = headerTxt,
        txt = headerTxtHelp,
        params = {
            event = "qb-import-export:client:menu:close"
        }
    })

    exports["qb-menu"]:openMenu(menu)
end

local function closeMenu()
    exports["qb-menu"]:closeMenu()
end

-----------
-- LOOPS --
-----------

local isMenuOpened = false
local function playerInLocationLoop(location)
    CreateThread(function ()
        while isPlayerInZone do
            -- check if player came with vehicle
            local ped = PlayerPedId()
            if Config.AllowLoadingIntoVehicle then
                lastUsedVehicle = GetVehiclePedIsIn(ped, true)
                if lastUsedVehicle ~= 0 then
                    local coords = GetEntityCoords(lastUsedVehicle)
                    local playerCoords = GetEntityCoords(ped)
                    local dist = #(playerCoords - coords)
    
                    if dist > 30.0 then
                        lastUsedVehicle = 0
                    end
                end
            end

            if IsControlJustPressed(0, 51) then
                openMainMenu(location)
                isMenuOpened = true
            end

            Wait(1)
        end
    end)
end

local function startMainLoop()
    Wait(1000)
    CreateThread(function ()
        createLocations()
        while true do
            local playerPedId = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPedId)
            local playerHeading = GetEntityHeading(playerPedId)

            local nearAny = false
            local nearLocation = nil
            for k,loc in pairs(Locations) do
                local dist = #(playerCoords - loc.pos.xyz)
                local neededHeading
                if loc.pos.w >= 180.0 then
                    neededHeading = loc.pos - vector4(0.0, 0.0, 0.0, 180.0)
                else
                    local pedHeading = loc.pos.w
                    local deg = 180.0 - pedHeading
                    pedHeading = 360.0
                    neededHeading = pedHeading - vector4(0.0, 0.0, 0.0, deg)
                end

                local min = (neededHeading - vector4(0.0, 0.0, 0.0, 30.0)).w
                local max = (neededHeading + vector4(0.0, 0.0, 0.0, 30.0)).w
                -- if dist < 20.0 then
                --     print("min: ", min)
                --     print("max: ", max)
                --     print("dist: ", dist)
                -- end
                if dist <= 1.6 and (playerHeading >= min and playerHeading <= max) then
                    nearAny = true
                    nearLocation = loc
                end
            end

            isPlayerInZone = nearAny

            if isPlayerInZone then
                if not helpTextShowing then
                    exports["qb-core"]:DrawText(Lang:t("info.press_see_manifest"), "left")
                    helpTextShowing = true
                    playerInLocationLoop(nearLocation)
                end
            else
                if isMenuOpened then
                    closeMenu()
                    isMenuOpened = false
                end
                if helpTextShowing then
                    exports["qb-core"]:HideText()
                    helpTextShowing = false
                end
            end

            Wait(1000)
        end
    end)
end

------------
-- EVENTS --
------------
AddEventHandler("onResourceStop", function (resource)
    if resource == GetCurrentResourceName() then
        deleteLocations()
    end
end)

AddEventHandler("onResourceStart", function (resource)
    if resource == GetCurrentResourceName() then
        startMainLoop()
    end
end)

-- This event is fired when the player is loaded on the map, meaning when he chooses his character and spawns on the map.
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    startMainLoop()
end)

RegisterNetEvent("qb-import-export:client:openSaleStock", function ()
    local shopContent = {
        label = Lang:t("location." .. currentVisitedLocationData["name"]),
        items = {}
    }

    local slot = 1
    for key, product in pairs(currentVisitedLocationData.produces) do
        table.insert(shopContent.items, {
            ["slot"] = slot,
            ["name"] = product["name"],
            ["info"] = {},
            ["type"] = "item",
            ["amount"] = product["stock"],
            ["price"] = product["price"]
        })

        slot = slot + 1
    end

    closeMenu()

    TriggerServerEvent("inventory:server:OpenInventory", "shop", "import_export~" .. currentVisitedLocationData["name"], shopContent)
end)


RegisterNetEvent("qb-import-export:client:acquisitionMenu", function (data)
    local location = data.location
    local locationData = retrieveCurrentVisitedLocationData(location["name"])
    currentVisitedLocationData = locationData

    playerData = QBCore.Functions.GetPlayerData()

    local consumedItems = Config.Functions.GetConsumedItems(location["name"])
    local producedItems = Config.Functions.GetProducedItems(location["name"])
    for k,v in pairs(consumedItems) do
        consumedItems[k] = Lang:t("item_price." .. v, {amount = locationData.consumes[v]["demandPrice"]})
    end
    for k,v in pairs(producedItems) do
        producedItems[k] = Lang:t("item_price." .. v, {amount = locationData.produces[v]["price"]})
    end
    local consumedTxt = table.concat(consumedItems, "<br> - ")
    local producedTxt = table.concat(producedItems, "<br> - ")

    local txt = Lang:t("menu.header", {items = consumedTxt, soldItems = producedTxt})
    txt = txt .. "<br><br>" .. Lang:t("info.header_bottom")

    local menu = {
        {
            header = Lang:t("location." .. location["name"]),
            isMenuHeader = true,
            txt = txt
        }
    }

    if next(locationData.produces) ~= nil then
        table.insert(menu, {
            header = Lang:t("info.see_sale_stock"),
            txt = Lang:t("info.see_sale_stock_text"),
            params = {
                event = "qb-import-export:client:openSaleStock"
            }
        })
    end

    -- vehicle
    if lastUsedVehicle ~= 0 and lastUsedVehicle ~= nil then
        vehiclePlate = GetVehicleNumberPlateText(lastUsedVehicle)
        local vehicleTrunkData = VehicleTrunk.GetTrunkData(GetVehicleClass(lastUsedVehicle))

        -- retrieve space available in vehicle trunk
        local callbackResolved = false
        local vehicleData = { plate = vehiclePlate, maxweight = vehicleTrunkData.maxweight }
        QBCore.Functions.TriggerCallback("qb-inventory:server:GetAvailableTrunkSpace", function (result)
            spaceAvailableInVehicle = result.availableSpace
            callbackResolved = true
        end, vehicleData)

        while not callbackResolved do
            Wait(100)
        end

        table.insert(menu, {
            header = Lang:t("info.load_into_truck"),
            txt = Lang:t("info.load_into_truck_text"),
            params = {
                event = "qb-import-export:client:LoadIntoTruckMenu"
            }
        })
    end

    local headerTxt = Lang:t("info.return")
    local headerTxtHelp = nil
    if next(menu, 1) == nil then
        headerTxt = Lang:t("info.nothing_to_do")
        headerTxtHelp = Lang:t("info.nothing_to_do_help")
    end

    table.insert(menu, {
        header = headerTxt,
        txt = headerTxtHelp,
        params = {
            event = "qb-import-export:client:menu:open"
        }
    })

    exports["qb-menu"]:openMenu(menu)
end)

RegisterNetEvent("qb-import-export:client:showInventory", function ()
    local consumedItems = Config.Functions.GetConsumedItems(currentVisitedLocationData["name"])
    local producedItems = Config.Functions.GetProducedItems(currentVisitedLocationData["name"])
    for k,v in pairs(consumedItems) do
        local currentPrice = currentVisitedLocationData.consumes[v]["demandPrice"]
        local basePrice = Config.BasePrices[v]
        -- local percentage = Config.Functions.GetPriceDiffPercentage(v, currentPrice)

        consumedItems[k] = Lang:t("item_price." .. v, {amount = currentPrice})
    end
    for k,v in pairs(producedItems) do
        producedItems[k] = Lang:t("item_price." .. v, {amount = currentVisitedLocationData.produces[v]["price"]})
    end
    local consumedTxt = table.concat(consumedItems, "<br> - ")
    local producedTxt = table.concat(producedItems, "<br> - ")

    local txt = Lang:t("menu.header", {items = consumedTxt, soldItems = producedTxt})
    txt = txt .. "<br><br>" .. Lang:t("info.header_bottom")

    local menu = {
        {
            header = Lang:t("location." .. currentVisitedLocationData["name"]),
            isMenuHeader = true,
            txt = txt
        }
    }

    for key, product in pairs(currentVisitedLocationData.consumes) do
        local amount = playerHasHowManyItems(playerData, product["name"])
        if amount > 0 then
            local demandPrice = math.ceil(product["demandPrice"])
            local totalPrice = math.ceil(demandPrice * amount)

            table.insert(menu, {
                header = Lang:t("info.sell_item", {amount = amount, item = Lang:t("item." .. product["name"]), price = totalPrice}),
                txt = Lang:t("info.sell_item_help", {per_unit_price = demandPrice}),
                params = {
                    isServer = true,
                    event = "qb-import-export:server:sellProduct",
                    args = {
                        locationName = currentVisitedLocationData["name"],
                        item = product["name"],
                        amount = amount,
                        price = totalPrice
                    }
                }
            })
        end
    end

    local headerTxt = Lang:t("info.close")
    local headerTxtHelp = nil
    if next(menu, 1) == nil then
        headerTxt = Lang:t("info.nothing_to_do")
        -- headerTxtHelp = Lang:t("info.nothing_to_do_help")
    end

    table.insert(menu, {
        header = headerTxt,
        txt = headerTxtHelp,
        params = {
            event = "qb-import-export:client:menu:close"
        }
    })

    exports["qb-menu"]:openMenu(menu)
end)

-- truck loading - final buy menu
RegisterNetEvent("qb-import-export:client:vehicle:buyProductMenu", function (data)
    local location = data.location
    local product = data.product
    local itemData = QBCore.Shared.Items[product["name"]]
    local buyLimit = math.floor(spaceAvailableInVehicle / itemData["weight"])

    local menu = {
        header = Lang:t("truck.buy_product_header", {product = Lang:t("item." .. product["name"]), stock = product["stock"], limit = buyLimit}),
        submitText = Lang:t("truck.confirm_buy"),
        inputs = {
            {
                text = Lang:t("truck.product_amount"),
                name = "amount",
                type = "number",
                isRequired = true
            }
        }
    }

    local input = exports["qb-input"]:ShowInput(menu)
    if input == nil then
        return
    end

    local amount = input.amount
    if not amount then
        QBCore.Functions.Notify(Lang:t("error.amount_error"), "error")
        return
    end
    amount = tonumber(amount)

    if amount > buyLimit then
        QBCore.Functions.Notify(Lang:t("error.not_enough_space_in_vehicle"), "error")
        return
    end

    local payload = {
        locationName = location["name"],
        productName = product["name"],
        amount = amount,
        vehiclePlate = vehiclePlate
    }
    TriggerServerEvent("qb-import-export:server:buyProductAndLoadIntoTruck", payload)
end)

-- opens inventory menu for truck loading
RegisterNetEvent("qb-import-export:client:LoadIntoTruckMenu", function ()
    -- display stock menu
    local menu = {
        {
            header = Lang:t("info.available_stock") .. " - " .. Lang:t("location." .. currentVisitedLocationData["name"]),
            isMenuHeader = true,
            txt = Lang:t("truck.main_menu_header", {space = spaceAvailableInVehicle})
        }
    }

    QBCore.Functions.TriggerCallback("qb-import-export:server:getLocationData", function (locationData)
        if next(locationData.produces) ~= nil then
            for k, v in pairs(locationData.produces) do
                table.insert(menu, {
                    header = Lang:t("item." .. v["name"]),
                    txt = Lang:t("truck.item_help_text", {stock = v["stock"], price = v["price"]}),
                    params = {
                        event = "qb-import-export:client:vehicle:buyProductMenu",
                        args = {
                            product = v,
                            location = locationData
                        }
                    }
                })
            end
        end

        table.insert(menu, {
            header = Lang:t("info.return"),
            params = {
                event = "qb-import-export:client:acquisitionMenu",
                args = {
                    location = locationData
                }
            }
        })

        exports["qb-menu"]:openMenu(menu)
    end, currentVisitedLocationData["name"])
end)

-- show vehicle inventory
RegisterNetEvent("qb-import-export:client:showVehicleInventory", function (data)
    local vehicleItems = data.vehicleItems
    local menu = {
        {
            header = Lang:t("location." .. currentVisitedLocationData["name"]),
            isMenuHeader = true,
            -- txt = 
        }
    }

    for k, product in pairs(currentVisitedLocationData.consumes) do
        local amount = vehicleHasHowManyItems(vehicleItems, product["name"])
        if amount > 0 then
            local demandPrice = math.ceil(product["demandPrice"])
            local totalPrice = math.ceil(demandPrice * amount)

            table.insert(menu, {
                header = Lang:t("info.sell_item", {amount = amount, item = Lang:t("item." .. product["name"]), price = totalPrice}),
                txt = Lang:t("info.sell_item_help", {per_unit_price = demandPrice}),
                params = {
                    isServer = true,
                    event = "qb-import-export:server:vehicle:sellProduct",
                    args = {
                        locationName = currentVisitedLocationData["name"],
                        item = product["name"],
                        amount = amount,
                        price = totalPrice,
                        vehiclePlate = vehiclePlate
                    }
                }
            })
        end
    end

    local headerTxt = Lang:t("info.return")
    local headerTxtHelp = nil
    if next(menu, 1) == nil then
        headerTxt = Lang:t("info.nothing_to_do")
    end

    table.insert(menu, {
        header = headerTxt,
        txt = headerTxtHelp,
        params = {
            event = "qb-import-export:client:menu:open"
        }
    })

    exports["qb-menu"]:openMenu(menu)
end)

-- resell menu
RegisterNetEvent("qb-import-export:client:resellMenu", function (data)
    local items = data.vehicleItems
    local playerHasAny = data.playerHasAny
    local vehicleHasAny = data.vehicleHasAny
    local vehiclePlate = data.vehiclePlate

    local location = currentVisitedLocationData

    local consumedItems = Config.Functions.GetConsumedItems(location["name"])
    for k,v in pairs(consumedItems) do
        consumedItems[k] = Lang:t("item_price." .. v, {amount = location.consumes[v]["demandPrice"]})
    end
    local consumedTxt = table.concat(consumedItems, "<br> - ")

    local txt = Lang:t("menu.resell_header", {items = consumedTxt})
    -- txt = txt .. "<br><br>" .. Lang:t("info.header_bottom")

    local menu = {
        {
            header = Lang:t("location." .. location["name"]),
            isMenuHeader = true,
            txt = txt
        }
    }

    if playerHasAny then
        table.insert(menu, {
            header = Lang:t("info.show_your_inventory"),
            txt = Lang:t("info.show_your_inventory_text"),
            params = {
                event = "qb-import-export:client:showInventory"
            }
        })
    end

    if vehicleHasAny then
        table.insert(menu, {
            header = Lang:t("info.show_vehicle_inventory"),
            txt = Lang:t("info.show_vehicle_inventory_help"),
            params = {
                event = "qb-import-export:client:showVehicleInventory",
                args = {
                    vehicleItems = items,
                    vehicleHasAny = vehicleHasAny,
                    vehiclePlate = vehiclePlate
                }
            }
        })
    end

    table.insert(menu, {
        header = Lang:t("info.return"),
        params = {
            event = "qb-import-export:client:menu:open"
        }
    })

    exports["qb-menu"]:openMenu(menu)
end)

RegisterNetEvent("qb-import-export:client:menu:open", function ()
    openMainMenu(currentVisitedLocationData)
end)

RegisterNetEvent("qb-import-export:client:menu:close", function ()
    closeMenu()
end)