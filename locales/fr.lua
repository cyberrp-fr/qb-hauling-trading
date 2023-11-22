local Translations = {
    info = {
        ["press_see_manifest"] = "<b style=\"color: limegreen;\">[E]</b> pour voir le manifest",
        ["see_sale_stock"] = "Voir le stock de vente",
        ["see_sale_stock_text"] = "Voir le stock des produits en vente de ce lieu.",
        ["show_your_inventory"] = "Revente",
        ["show_your_inventory_text"] = "Voir le prix que vous propose ce lieu pour vos marchandises.",
        ["header_bottom"] = "Tips: <br><small>Démarrer le négoce de marchandises, la clé réside dans l'anticipation de la demande et d'être le premier à satisfaire celle-ci.</small>",

        ["sell_item"] = "Vendre %{amount}x %{item} - total: %{price}€",
        ["sell_item_help"] = "<small><strong>Prix proposé: %{per_unit_price}€</strong></small><br><small>C'est le prix actuel du marché, sachez que ce prix varie en fonction de l'offre et la demande du marché.</small>",
        ["close"] = "Fermer",
        ["return"] = "Retour",
        ["nothing_to_do"] = "Rien a faire, fermer",
        ["nothing_to_do_help"] = "<small>Vous n'avez pas de produits a vendre ou ce lieu ne cherche pas ce que vous avez a vendre.</small>",

        ["acquisition"] = "Achat",
        ["acquisition_help"] = "Acquisition de produits disponibles à cet emplacement.",
        ["load_into_truck"] = "Voir le stock et charger dans mon véhicule de transport",
        ["load_into_truck_text"] = "La marchandise achetée sera directement chargée dans votre véhicule.",
        ["available_stock"] = "Stock disponible",

        ["resell"] = "Revente",
        ["resell_help"] = "Revente de produits disponibles dans votre inventaire.",
        ["show_vehicle_inventory"] = "Inventaire véhicule",
        ["show_vehicle_inventory_help"] = "Voir les prix proposés pour chaque produit."
    },
    error = {
        ["amount_error"] = "Quantité doit etre defini au moins a \"1\".",
        ["not_enough_space_in_vehicle"] = "Pas assez d'espace dans votre véhicule.",
        ["location_does_not_sell_product"] = "Le produit selectionné ne semble pas être vendu a cet endroit.",
        ["not_enough_stock"] = "Stock epuisé, impossible d'assurer ce montant.",
        ["not_enough_money"] = "Pas assez d'argent en banque.",
    },
    success = {
    },
    location = {
        ["port"] = "Port d'import",
        ["downtown_construction"] = "LS Construction",
        ["power_plant"] = "Centrale éléctrique",
        ["downtown_hospital"] = "LS Hôpital",
        ["humane_labs"] = "Labo Humane",
        ["paleto_farms"] = "Paleto Farms",
        ["military_base"] = "Base Militaire Zancudo",
        ["paleto_mill"] = "Paleto usine industrielle",
        ["grapeseed_farms"] = "Grapeseed Farming",
        ["weld_supply_co"] = "LS Industrielle WELD.CO",
        ["oil_rig_center"] = "Centre de la plate-forme pétrolière",
        ["windmill_center"] = "Centre d'éoliennes industrielles"
    },
    menu = {
        ["header"] = "<br><strong>Marchandises recherchées:</strong> <br> - %{items} <br><br><strong>Marchandises vendues:</strong> <br> - %{soldItems}",
        ["resell_header"] = "<br><strong>Marchandises recherchées:</strong> <br> - %{items}"
    },
    item = {
        [Config.Products.AGRICULTURAL_SUPPLIES] = "Agrofourniture",
        [Config.Products.MEDICAL_SUPPLIES] = "Matériel médical",
        [Config.Products.BERYL] = "Béryl",
        [Config.Products.CHLORINE] = "Chlorine",
        [Config.Products.COAL] = "Charbon",
        [Config.Products.CHEMICAL_COOLANT] = "Liquide chimique de refroidissement",
        [Config.Products.HYDROGEN] = "Hydrogène",
        [Config.Products.CONSTRUCTION_SUPPLIES] = "Matériel de construction"
    },
    item_price = {
        [Config.Products.AGRICULTURAL_SUPPLIES] = "Agrofourniture: %{amount}€",
        [Config.Products.MEDICAL_SUPPLIES] = "Matériel médical: %{amount}€",
        [Config.Products.BERYL] = "Béryl: %{amount}€",
        [Config.Products.CHLORINE] = "Chlorine: %{amount}€",
        [Config.Products.COAL] = "Charbon: %{amount}€",
        [Config.Products.CHEMICAL_COOLANT] = "Liquide chimique de refroidissement: %{amount}€",
        [Config.Products.HYDROGEN] = "Hydrogène: %{amount}€",
        [Config.Products.CONSTRUCTION_SUPPLIES] = "Matériel de construction: %{amount}€"
    },

    truck = {
        ["main_menu_header"] = "Espace dispo dans votre véhicule: <strong>%{space} kg</strong><br><br>Les produits vendus ci-dessous:",
        ["item_help_text"] = "Stock: %{stock} - Prix: %{price}",
        ["buy_product_header"] = "Achat %{product}<br>En stock: %{stock}<br>Limite d'achat: %{limit}",
        ["confirm_buy"] = "Confirmer l'achat",
        ["product_amount"] = "Quantité"
    },

    description = {
        [Config.Products.AGRICULTURAL_SUPPLIES] = "Fournitures d'agriculture que vous pouvez revendre.",
        [Config.Products.MEDICAL_SUPPLIES] = "Matériel medical que vous pouvez revendre.",
        [Config.Products.BERYL] = "Matériel contenant des composants chimiques, vous pouvez revendre aux labos, usines et centrales éléctriques.",
        [Config.Products.CHLORINE] = "Réservoir Gaz chimique que vous pouvez revendre aux labos, usines et centrales éléctriques.",
        [Config.Products.COAL] = "Sac de charbon 1kg, utiles pour les labos, usines et centrales éléctriques, ils vous l'achèteront.",
        [Config.Products.CHEMICAL_COOLANT] = "Réservoir de liquide chimique industriel de refroidissement que vous pouvez revendre.",
        [Config.Products.HYDROGEN] = "Réservoir d'hydrogène industriel que vous pouvez revendre.",
        [Config.Products.CONSTRUCTION_SUPPLIES] = "Matériel de construciton qui est utile quasiment par tout, revendez le au meilleur prix."
    },
}

if GetConvar("qb_locale", "en") == "fr" then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end