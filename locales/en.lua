local Translations = {
    info = {
        ["press_see_manifest"] = "<b style=\"color: limegreen;\">[E]</b> to view the manifest",
        ["see_sale_stock"] = "See the stock",
        ["see_sale_stock_text"] = "See the stock of products for sale at this place.",
        ["show_your_inventory"] = "Resale",
        ["show_your_inventory_text"] = "See the price that this place offers for your goods.",
        ["header_bottom"] = "Tips: <br><small>To start right the trading of goods, the key is in anticipating the demand and being the first to satisfy it.</small>",

        ["sell_item"] = "Sell %{amount}x %{item} - total: $%{price}",
        ["sell_item_help"] = "<small><strong>Proposed price: $%{per_unit_price}</strong></small><br><small>This is the current market price, note that this price varies depending on the market supply and demand.</small>",
        ["close"] = "Close",
        ["return"] = "Return",
        ["nothing_to_do"] = "Nothing to do, close",
        ["nothing_to_do_help"] = "<small>You have no products to sell or this place does not seek what you have to sell.</small>",

        ["acquisition"] = "Purchase",
        ["acquisition_help"] = "Acquisition of products available at this location.",
        ["load_into_truck"] = "See the stock and load into my transport vehicle",
        ["load_into_truck_text"] = "The purchased goods will be directly loaded into your vehicle.",
        ["available_stock"] = "Available stock",

        ["resell"] = "Resale",
        ["resell_help"] = "Resale of products available in your inventory.",
        ["show_vehicle_inventory"] = "Vehicle inventory",
        ["show_vehicle_inventory_help"] = "See the prices offered for each product."
    },
    error = {
        ["amount_error"] = "Quantity must be at least \"1\".",
        ["not_enough_space_in_vehicle"] = "Not enough space in your vehicle.",
        ["location_does_not_sell_product"] = "The selected product does not seem to be sold at this place.",
        ["not_enough_stock"] = "Stock exhausted, unable to ensure this amount.",
        ["not_enough_money"] = "Not enough money in bank.",
    },
    success = {
    },
    location = {
        ["port"] = "Import Port",
        ["downtown_construction"] = "LS Construction",
        ["power_plant"] = "Electric power plant",
        ["downtown_hospital"] = "LS Hospital",
        ["humane_labs"] = "Humane Labs",
        ["paleto_farms"] = "Paleto Farms",
        ["military_base"] = "Zancudo Military Base",
        ["paleto_mill"] = "Paleto Industrial Factory",
        ["grapeseed_farms"] = "Grapeseed Farming",
        ["weld_supply_co"] = "LS Industrial WELD.CO",
        ["oil_rig_center"] = "Oil Rig Center",
        ["windmill_center"] = "Industrial Windmill Center"
    },
    menu = {
        ["header"] = "<br><strong>Bought goods:</strong> <br> - %{items} <br><br><strong>Goods sold:</strong> <br> - %{soldItems}",
        ["resell_header"] = "<br><strong>Bought goods:</strong> <br> - %{items}"
    },
    item = {
        [Config.Products.AGRICULTURAL_SUPPLIES] = "Agricultural supplies",
        [Config.Products.MEDICAL_SUPPLIES] = "Medical supplies",
        [Config.Products.BERYL] = "Beryl",
        [Config.Products.CHLORINE] = "Chlorine",
        [Config.Products.COAL] = "Coal",
        [Config.Products.CHEMICAL_COOLANT] = "Chemical coolant",
        [Config.Products.HYDROGEN] = "Hydrogen",
        [Config.Products.CONSTRUCTION_SUPPLIES] = "Construction supplies"
    },
    item_price = {
        [Config.Products.AGRICULTURAL_SUPPLIES] = "Agricultural supplies: $%{amount}",
        [Config.Products.MEDICAL_SUPPLIES] = "Medical supplies: $%{amount}",
        [Config.Products.BERYL] = "Beryl: $%{amount}",
        [Config.Products.CHLORINE] = "Chlorine: $%{amount}",
        [Config.Products.COAL] = "Coal: $%{amount}",
        [Config.Products.CHEMICAL_COOLANT] = "Chemical coolant: $%{amount}",
        [Config.Products.HYDROGEN] = "Hydrogen: $%{amount}",
        [Config.Products.CONSTRUCTION_SUPPLIES] = "Construction supplies: $%{amount}"
    },

    truck = {
        ["main_menu_header"] = "Space available in your vehicle: <strong>%{space} kg</strong><br><br>Products sold below:",
        ["item_help_text"] = "Stock: %{stock} - Price: %{price}",
        ["buy_product_header"] = "Purchase %{product}<br>In stock: %{stock}<br>Purchase limit: %{limit}",
        ["confirm_buy"] = "Confirm purchase",
        ["product_amount"] = "Quantity"
    },

    description = {
        [Config.Products.AGRICULTURAL_SUPPLIES] = "Agricultural supplies that you can resell in relevant regions.",
        [Config.Products.MEDICAL_SUPPLIES] = "Medical supplies that you can resell.",
        [Config.Products.BERYL] = "Material containing chemical components, you can respond to labs, factories and power plants.",
        [Config.Products.CHLORINE] = "Chemical gas tank that you can supply to labs, factories and power plants.",
        [Config.Products.COAL] = "1kg bag of charcoal, useful for labs, factories and power stations, they will buy it from you.",
        [Config.Products.CHEMICAL_COOLANT] = "Industrial chemical cooling liquid tank that you can resell.",
        [Config.Products.HYDROGEN] = "Industrial hydrogen tank that you can resell.",
        [Config.Products.CONSTRUCTION_SUPPLIES] = "Construction equipment which is useful almost everywhere, resell it at the best price."
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})