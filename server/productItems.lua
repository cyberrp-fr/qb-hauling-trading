
-- this function is called in `server/main.lua` on start, this is here done to lower installation difficulty 
function RegisterProducts()
    local itemName = Config.Products.AGRICULTURAL_SUPPLIES
    local item = {['name'] = itemName, ['label'] = Lang:t("item." .. itemName), ['weight'] = 5000, ['type'] = 'item', ['image'] = 'agricultural_supplies.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = Lang:t("description." .. itemName )}
    exports['qb-core']:AddItem(itemName, item)

    --------------------------------------------------------------------

    itemName = Config.Products.MEDICAL_SUPPLIES
    item = {['name'] = itemName, ['label'] = Lang:t("item." .. itemName), ['weight'] = 3000, ['type'] = 'item', ['image'] = 'medical_supplies.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = Lang:t("description." .. itemName )}
    exports['qb-core']:AddItem(itemName, item)

    --------------------------------------------------------------------

    itemName = Config.Products.BERYL
    item = {['name'] = itemName, ['label'] = Lang:t("item." .. itemName), ['weight'] = 800, ['type'] = 'item', ['image'] = 'beryl.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = Lang:t("description." .. itemName )}
    exports['qb-core']:AddItem(itemName, item)

    --------------------------------------------------------------------

    itemName = Config.Products.CHLORINE
    item = {['name'] = itemName, ['label'] = Lang:t("item." .. itemName), ['weight'] = 5000, ['type'] = 'item', ['image'] = 'chlorine.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = Lang:t("description." .. itemName )}
    exports['qb-core']:AddItem(itemName, item)

    --------------------------------------------------------------------

    itemName = Config.Products.COAL
    item = {['name'] = itemName, ['label'] = Lang:t("item." .. itemName), ['weight'] = 1000, ['type'] = 'item', ['image'] = 'coal.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = Lang:t("description." .. itemName )}
    exports['qb-core']:AddItem(itemName, item)

    --------------------------------------------------------------------

    itemName = Config.Products.CHEMICAL_COOLANT
    item = {['name'] = itemName, ['label'] = Lang:t("item." .. itemName), ['weight'] = 5000, ['type'] = 'item', ['image'] = 'chemical_coolant.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = Lang:t("description." .. itemName )}
    exports['qb-core']:AddItem(itemName, item)

    --------------------------------------------------------------------

    itemName = Config.Products.HYDROGEN
    item = {['name'] = itemName, ['label'] = Lang:t("item." .. itemName), ['weight'] = 5000, ['type'] = 'item', ['image'] = 'hydrogen.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = Lang:t("description." .. itemName )}
    exports['qb-core']:AddItem(itemName, item)

    --------------------------------------------------------------------

    itemName = Config.Products.CONSTRUCTION_SUPPLIES
    item = {['name'] = itemName, ['label'] = Lang:t("item." .. itemName), ['weight'] = 3500, ['type'] = 'item', ['image'] = 'construction_supplies.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = false, ['combinable'] = nil, ['description'] = Lang:t("description." .. itemName )}
    exports['qb-core']:AddItem(itemName, item)

end
