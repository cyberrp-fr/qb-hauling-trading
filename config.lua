Config = {}

-- This parameter if set to `true`, enables the feature which allows the products be loaded into your vehicle directly when you purchase.
Config.AllowLoadingIntoVehicle = false

Config.Products = {
    AGRICULTURAL_SUPPLIES = "agricultural_supplies",
    MEDICAL_SUPPLIES = "medical_supplies",
    BERYL = "beryl",
    CHLORINE = "chlorine",
    COAL = "coal",
    CHEMICAL_COOLANT = "chemical_coolant",
    HYDROGEN = "hydrogen",
    CONSTRUCTION_SUPPLIES = "construction_supplies",
}

Config.BasePrices = {
    [Config.Products.AGRICULTURAL_SUPPLIES] = 1000,
    [Config.Products.MEDICAL_SUPPLIES] = 5000,
    [Config.Products.BERYL] = 1000,
    [Config.Products.CHLORINE] = 3000,
    [Config.Products.COAL] = 1000,
    [Config.Products.CHEMICAL_COOLANT] = 2000,
    [Config.Products.HYDROGEN] = 4000,
    [Config.Products.CONSTRUCTION_SUPPLIES] = 4000
}

Config.Locations = {
    -- [1] = {
    --     name = "business_district",
    --     pos = vector4(-197.62, -571.18, 34.63, 69.14),
    --     enabled = false,
    --     ped = "",
    --     pedScenario = "",

    --     sells = {},
    --     buys = {}
    -- },

    [2] = {
        name = "port",
        pos = vector4(814.99, -2982.51, 5.01, 263.45),
        enabled = true,
        ped = "s_m_m_gentransport",
        pedScenario = "WORLD_HUMAN_CLIPBOARD",

        blip = {
            label = "Port",
            coords = vector3(814.99, -2982.51, 5.01),
            sprite = 475,
            scale = 0.65,
            color = 50,
            display = 4,
            enabled = true -- set to `true` if you want the blip
        },

        produces = {
            [Config.Products.AGRICULTURAL_SUPPLIES] = {["name"] = Config.Products.AGRICULTURAL_SUPPLIES,    ["stock"] = math.random(500, 1000), ["desiredStock"] = 1000, ["rate"] = 40},
            [Config.Products.MEDICAL_SUPPLIES]      = {["name"] = Config.Products.MEDICAL_SUPPLIES,         ["stock"] = math.random(500, 1000), ["desiredStock"] = 1000, ["rate"] = 30},
            [Config.Products.CONSTRUCTION_SUPPLIES] = {["name"] = Config.Products.CONSTRUCTION_SUPPLIES,    ["stock"] = math.random(500, 1000), ["desiredStock"] = 1000, ["rate"] = 50},
            [Config.Products.HYDROGEN]              = {["name"] = Config.Products.HYDROGEN,                 ["stock"] = math.random(500, 1000), ["desiredStock"] = 1000, ["rate"] = 45},
            [Config.Products.BERYL]                 = {["name"] = Config.Products.BERYL,                    ["stock"] = math.random(500, 1000), ["desiredStock"] = 1000, ["rate"] = 20},
            [Config.Products.CHLORINE]              = {["name"] = Config.Products.CHLORINE,                 ["stock"] = math.random(500, 1200), ["desiredStock"] = 1200, ["rate"] = 32},
            [Config.Products.COAL]                  = {["name"] = Config.Products.COAL,                     ["stock"] = math.random(500, 2000), ["desiredStock"] = 2000, ["rate"] = 43},
            [Config.Products.CHEMICAL_COOLANT]      = {["name"] = Config.Products.CHEMICAL_COOLANT,         ["stock"] = math.random(500, 2000), ["desiredStock"] = 2000, ["rate"] = 30},
        },
        consumes = {
            -- [Config.Products.BERYL]     = {["name"] = Config.Products.BERYL,    ["stock"] = math.random()},
            -- [Config.Products.CHLORINE] = Config.Products.CHLORINE,
            -- [Config.Products.COAL] = Config.Products.COAL,
        }
    },

    [3] = {
        name = "downtown_construction",
        pos = vector4(140.99, -379.02, 42.25, 54.08),
        enabled = true,
        ped = "s_m_y_construct_01",
        pedScenario = "WORLD_HUMAN_CLIPBOARD",

        blip = {
            label = "Downtown construction site",
            coords = vector3(140.99, -379.02, 42.25),
            sprite = 475,
            scale = 0.65,
            color = 50,
            display = 4,
            enabled = true -- set to `true` if you want the blip
        },

        produces = {},
        consumes = {
            [Config.Products.CONSTRUCTION_SUPPLIES] = {["name"] = Config.Products.CONSTRUCTION_SUPPLIES, ["stock"] = math.random(500, 2000), ["desiredStock"] = 2000, ["rate"] = 52, ["maximumPrice"] = 6000},
        }
    },

    [4] = {
        name = "power_plant",
        pos = vector4(2670.87, 1612.88, 23.49, 278.61),
        enabled = true,
        ped = "s_m_y_uscg_01",
        pedScenario = "WORLD_HUMAN_CLIPBOARD",

        blip = {
            label = "Power plant",
            coords = vector3(2670.87, 1612.88, 23.49),
            sprite = 475,
            scale = 0.65,
            color = 50,
            display = 4,
            enabled = true -- set to `true` if you want the blip
        },

        produces = {},
        consumes = {
            [Config.Products.BERYL]             = {["name"] = Config.Products.BERYL,            ["stock"] = math.random(1000, 3000),  ["desiredStock"] = 3000,  ["rate"] = 84,   ["maximumPrice"] = 1500},
            [Config.Products.CHLORINE]          = {["name"] = Config.Products.CHLORINE,         ["stock"] = math.random(1000, 3000),  ["desiredStock"] = 3000,  ["rate"] = 102,  ["maximumPrice"] = 3900},
            [Config.Products.COAL]              = {["name"] = Config.Products.COAL,             ["stock"] = math.random(1000, 10000), ["desiredStock"] = 10000, ["rate"] = 256,  ["maximumPrice"] = 1500},
            [Config.Products.HYDROGEN]          = {["name"] = Config.Products.HYDROGEN,         ["stock"] = math.random(1000, 3000),  ["desiredStock"] = 3000,  ["rate"] = 82,   ["maximumPrice"] = 5500},
            [Config.Products.CHEMICAL_COOLANT]  = {["name"] = Config.Products.CHEMICAL_COOLANT, ["stock"] = math.random(1000, 5000),  ["desiredStock"] = 5000,  ["rate"] = 132,  ["maximumPrice"] = 3000},
        }
    },

    [5] = {
        name = "downtown_hospital",
        pos = vector4(320.28, -559.85, 27.73, 17.57),
        enabled = true,
        ped = "s_m_m_ccrew_01",
        pedScenario = "WORLD_HUMAN_CLIPBOARD",

        blip = {
            label = "Downtown Hospital",
            coords = vector3(320.28, -559.85, 27.73),
            sprite = 475,
            scale = 0.65,
            color = 50,
            display = 4,
            enabled = true -- set to `true` if you want the blip
        },

        produces = {},
        consumes = {
            [Config.Products.MEDICAL_SUPPLIES] = {["name"] = Config.Products.MEDICAL_SUPPLIES, ["stock"] = math.random(1000, 5000), ["desiredStock"] = 5000, ["rate"] = 116, ["maximumPrice"] = 6500},
        }
    },

    [6] = {
        name = "humane_labs",
        pos = vector4(3513.17, 3755.85, 28.96, 355.64),
        enabled = true,
        ped = "s_m_m_scientist_01",
        pedScenario = "WORLD_HUMAN_CLIPBOARD",

        blip = {
            label = "Humane Labs",
            coords = vector3(3513.17, 3755.85, 28.96),
            sprite = 475,
            scale = 0.65,
            color = 50,
            display = 4,
            enabled = true -- set to `true` if you want the blip
        },

        produces = {
            [Config.Products.CHLORINE] = {["name"] = Config.Products.CHLORINE, ["stock"] = math.random(500, 1000), ["desiredStock"] = 1000, ["rate"] = 32},
            [Config.Products.HYDROGEN] = {["name"] = Config.Products.HYDROGEN, ["stock"] = math.random(500, 1000), ["desiredStock"] = 1000, ["rate"] = 36}
        },
        consumes = {
            [Config.Products.BERYL]             = {["name"] = Config.Products.BERYL,            ["stock"] = math.random(1000, 5000), ["desiredStock"] = 5000, ["rate"] = 132,   ["maximumPrice"] = 1700},
            [Config.Products.COAL]              = {["name"] = Config.Products.COAL,             ["stock"] = math.random(1000, 8000), ["desiredStock"] = 8000, ["rate"] = 196,   ["maximumPrice"] = 1400},
            [Config.Products.CHEMICAL_COOLANT]  = {["name"] = Config.Products.CHEMICAL_COOLANT, ["stock"] = math.random(1000, 7000), ["desiredStock"] = 7000, ["rate"] = 196,   ["maximumPrice"] = 2900}
        }
    },

    [7] = {
        name = "paleto_farms",
        pos = vector4(-6.04, 6274.32, 30.35, 199.1),
        enabled = true,
        ped = "s_m_y_dwservice_01",
        pedScenario = "WORLD_HUMAN_CLIPBOARD",

        blip = {
            label = "Paleto Farms",
            coords = vector3(-6.04, 6274.32, 30.35),
            sprite = 475,
            scale = 0.65,
            color = 50,
            display = 4,
            enabled = true -- set to `true` if you want the blip
        },

        produces = {},
        consumes = {
            [Config.Products.CONSTRUCTION_SUPPLIES] = {["name"] = Config.Products.CONSTRUCTION_SUPPLIES, ["stock"] = math.random(200, 1000), ["desiredStock"] = 1000, ["rate"] = 25, ["maximumPrice"] = 5500},
            [Config.Products.AGRICULTURAL_SUPPLIES] = {["name"] = Config.Products.AGRICULTURAL_SUPPLIES, ["stock"] = math.random(300, 1000), ["desiredStock"] = 1000, ["rate"] = 27, ["maximumPrice"] = 1900},
        }
    },

    [8] = {
        name = "military_base",
        pos = vector4(-1778.77, 3073.8, 31.81, 324.91),
        enabled = true,
        ped = "s_m_y_marine_03",
        pedScenario = "WORLD_HUMAN_CLIPBOARD",

        blip = {
            label = "Military Base",
            coords = vector3(-1778.77, 3073.8, 31.81),
            sprite = 475,
            scale = 0.65,
            color = 50,
            display = 4,
            enabled = true -- set to `true` if you want the blip
        },

        produces = {},
        consumes = {
            [Config.Products.CONSTRUCTION_SUPPLIES] = {["name"] = Config.Products.CONSTRUCTION_SUPPLIES, ["stock"] = math.random(1000, 10000), ["desiredStock"] = 10000, ["rate"] = 156, ["maximumPrice"] = 5800},
            [Config.Products.COAL]                  = {["name"] = Config.Products.COAL,                  ["stock"] = math.random(5000, 15000), ["desiredStock"] = 20000, ["rate"] = 256, ["maximumPrice"] = 1500},
            [Config.Products.CHLORINE]              = {["name"] = Config.Products.CHLORINE,              ["stock"] = math.random(5000, 15000), ["desiredStock"] = 15000, ["rate"] = 176, ["maximumPrice"] = 4000},
            [Config.Products.CHEMICAL_COOLANT]      = {["name"] = Config.Products.CHEMICAL_COOLANT,      ["stock"] = math.random(5000, 15000), ["desiredStock"] = 20000, ["rate"] = 256, ["maximumPrice"] = 3900},
            [Config.Products.HYDROGEN]              = {["name"] = Config.Products.HYDROGEN,              ["stock"] = math.random(5000, 15000), ["desiredStock"] = 15000, ["rate"] = 186, ["maximumPrice"] = 5500},
            [Config.Products.MEDICAL_SUPPLIES]      = {["name"] = Config.Products.MEDICAL_SUPPLIES,      ["stock"] = math.random(5000, 15000), ["desiredStock"] = 20000, ["rate"] = 176, ["maximumPrice"] = 6500},
        }
    },

    [9] = {
        name = "paleto_mill",
        pos = vector4(-567.94, 5253.49, 69.47, 93.77),
        enabled = true,
        ped = "s_m_m_gardener_01",
        pedScenario = "WORLD_HUMAN_CLIPBOARD",

        blip = {
            label = "Paleto Mill",
            coords = vector3(-567.94, 5253.49, 69.47),
            sprite = 475,
            scale = 0.65,
            color = 50,
            display = 4,
            enabled = true -- set to `true` if you want the blip
        },

        produces = {
            [Config.Products.BERYL]             = {["name"] = Config.Products.BERYL,            ["stock"] = math.random(500, 1000), ["desiredStock"] = 1000, ["rate"] = 24},
            [Config.Products.CHEMICAL_COOLANT]  = {["name"] = Config.Products.CHEMICAL_COOLANT, ["stock"] = math.random(500, 1000), ["desiredStock"] = 1000, ["rate"] = 22},
        },
        consumes = {
            [Config.Products.CONSTRUCTION_SUPPLIES] = {["name"] = Config.Products.CONSTRUCTION_SUPPLIES, ["stock"] = math.random(500, 5000),  ["desiredStock"] = 5000, ["rate"] = 52, ["maximumPrice"] = 5300},
            [Config.Products.COAL]                  = {["name"] = Config.Products.COAL,                  ["stock"] = math.random(1000, 6000), ["desiredStock"] = 6000, ["rate"] = 64, ["maximumPrice"] = 1500},
        },
    },

    [10] = {
        name = "grapeseed_farms",
        pos = vector4(1861.62, 4971.72, 52.16, 331.59),
        enabled = true,
        ped = "u_m_m_filmdirector",
        pedScenario = "WORLD_HUMAN_CLIPBOARD",

        blip = {
            label = "Grapeseed Farms",
            coords = vector3(1861.62, 4971.72, 52.16),
            sprite = 475,
            scale = 0.65,
            color = 50,
            display = 4,
            enabled = true -- set to `true` if you want the blip
        },

        produces = {},
        consumes = {
            [Config.Products.AGRICULTURAL_SUPPLIES] = {["name"] = Config.Products.AGRICULTURAL_SUPPLIES,    ["stock"] = math.random(500, 2000), ["desiredStock"] = 2000, ["rate"] = 58, ["maximumPrice"] = 2000},
            [Config.Products.CONSTRUCTION_SUPPLIES] = {["name"] = Config.Products.CONSTRUCTION_SUPPLIES,    ["stock"] = math.random(100, 500),  ["desiredStock"] = 500,  ["rate"] = 10, ["maximumPrice"] = 6000},
        }
    },

    [11] = {
        name = "weld_supply_co",
        pos = vector4(1167.17, -1349.69, 33.91, 256.86),
        enabled = true,
        ped = "s_m_m_postal_01",
        pedScenario = "WORLD_HUMAN_CLIPBOARD",

        blip = {
            label = "WELD Supply Co",
            coords = vector3(1167.17, -1349.69, 33.91),
            sprite = 475,
            scale = 0.65,
            color = 50,
            display = 4,
            enabled = true -- set to `true` if you want the blip
        },

        produces = {
            [Config.Products.CHLORINE]              = {["name"] = Config.Products.CHLORINE,         ["stock"] = math.random(1000, 5000), ["desiredStock"] = 5000, ["rate"] = 32},
            [Config.Products.HYDROGEN]              = {["name"] = Config.Products.HYDROGEN,         ["stock"] = math.random(1000, 5000), ["desiredStock"] = 7000, ["rate"] = 33},
            [Config.Products.CHEMICAL_COOLANT]      = {["name"] = Config.Products.CHEMICAL_COOLANT, ["stock"] = math.random(1000, 7000), ["desiredStock"] = 8000, ["rate"] = 39}
        },
        consumes = {
            [Config.Products.CONSTRUCTION_SUPPLIES] = {["name"] = Config.Products.CONSTRUCTION_SUPPLIES, ["stock"] = math.random(500, 5000),   ["desiredStock"] = 5000,  ["rate"] = 40, ["maximumPrice"] = 6000},
            [Config.Products.BERYL]                 = {["name"] = Config.Products.BERYL,                 ["stock"] = math.random(1000, 8000),  ["desiredStock"] = 8000,  ["rate"] = 67, ["maximumPrice"] = 2000},
            [Config.Products.COAL]                  = {["name"] = Config.Products.COAL,                  ["stock"] = math.random(5000, 17000), ["desiredStock"] = 17000, ["rate"] = 97, ["maximumPrice"] = 1400},
        },

    },

    [12] = {
        name = "oil_rig_center",
        pos = vector4(1693.15, -1589.54, 111.5, 75.47),
        enabled = true,
        ped = "s_m_y_garbage",
        pedScenario = "WORLD_HUMAN_CLIPBOARD",

        blip = {
            label = "OIL Rig Center",
            coords = vector3(1693.15, -1589.54, 111.5),
            sprite = 475,
            scale = 0.65,
            color = 50,
            display = 4,
            enabled = true -- set to `true` if you want the blip
        },

        produces = {
            [Config.Products.BERYL]            = {["name"] = Config.Products.BERYL,    ["stock"] = math.random(500, 2000), ["desiredStock"] = 2000, ["rate"] = 26},
        },
        consumes = {
            [Config.Products.CHEMICAL_COOLANT]      = {["name"] = Config.Products.CHEMICAL_COOLANT,      ["stock"] = math.random(5000, 15000), ["desiredStock"] = 15000, ["rate"] = 84, ["maximumPrice"] = 3000},
            [Config.Products.CHLORINE]              = {["name"] = Config.Products.CHLORINE,              ["stock"] = math.random(5000, 10000), ["desiredStock"] = 10000, ["rate"] = 62, ["maximumPrice"] = 4000},
            [Config.Products.HYDROGEN]              = {["name"] = Config.Products.HYDROGEN,              ["stock"] = math.random(5000, 11000), ["desiredStock"] = 11000, ["rate"] = 64, ["maximumPrice"] = 6000},
            [Config.Products.COAL]                  = {["name"] = Config.Products.COAL,                  ["stock"] = math.random(5000, 15000), ["desiredStock"] = 15000, ["rate"] = 88, ["maximumPrice"] = 1400},
            [Config.Products.CONSTRUCTION_SUPPLIES] = {["name"] = Config.Products.CONSTRUCTION_SUPPLIES, ["stock"] = math.random(5000, 15000), ["desiredStock"] = 15000, ["rate"] = 74, ["maximumPrice"] = 5500},
        }
    },

    [13] = {
        name = "windmill_center",
        pos = vector4(2495.04, 1586.91, 31.72, 288.15),
        enabled = true,
        ped = "s_m_y_uscg_01",
        pedScenario = "WORLD_HUMAN_CLIPBOARD",

        blip = {
            label = "Windmill center",
            coords = vector3(2495.04, 1586.91, 31.72),
            sprite = 475,
            scale = 0.65,
            color = 50,
            display = 4,
            enabled = true -- set to `true` if you want the blip
        },

        produces = {},
        consumes = {
            [Config.Products.CONSTRUCTION_SUPPLIES] = {["name"] = Config.Products.CONSTRUCTION_SUPPLIES, ["stock"] = math.random(2000, 5000),   ["desiredStock"] = 5000,  ["rate"] = 32, ["maximumPrice"] = 5444},
            [Config.Products.CHEMICAL_COOLANT]      = {["name"] = Config.Products.CHEMICAL_COOLANT,      ["stock"] = math.random(5000, 10000),  ["desiredStock"] = 10000, ["rate"] = 63, ["maximumPrice"] = 3300}
        }
    }
}

-- FUNCTIONS

Config.Functions = {}

Config.Functions.GetLocationByName = function (name)
    for k, loc in pairs(Config.Locations) do
        if loc["name"] == name then
            return loc
        end
    end

    return nil
end

Config.Functions.GetConsumedItems = function (locationName)
    local location = Config.Functions.GetLocationByName(locationName)
    local result = {}
    if location ~= nil then
        for k,v in pairs(location.consumes) do
            table.insert(result, v["name"])
        end
    end

    return result
end

Config.Functions.GetProducedItems = function (locationName)
    local location = Config.Functions.GetLocationByName(locationName)
    local result = {}
    if location ~= nil then
        for k,v in pairs(location.produces) do
            table.insert(result, v["name"])
        end
    end

    return result
end

Config.Functions.GetPriceDiffPercentage = function (product, currentPrice)
    local basePrice = Config.BasePrices[product]
    return ((currentPrice - basePrice) / (currentPrice)) * 100
end