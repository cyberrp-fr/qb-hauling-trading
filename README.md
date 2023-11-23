QB Trading - Hauling script
===========================


## Description

A script which allows players to buy and sell various products at different locations and make a profit or loss based on current supply and demand.  
It implements a basic **supply & demand algorithm** that can be tweaked in `config.lua` file.

Products are bought and sold at relevant locations.  
Simple example, where do you reckon agricultural supplies are mostly needed ? Answer is on the north at places like **grapeseed farms** and **paleto bay**.

**Products**

- medical supplies
- construction supplies
- agricultural supplies
- chemical coolant
- hydrogen
- beryl
- coal
- chlorine

**Locations**

- port
- downtown construction site
- power plant
- downtown hospital
- humane labs
- paleto farms
- paleto mill
- military base
- grapeseed farms
- weld supply & co
- oil rig center
- windmill center


## Installation

#### Requirements

This script only works on the QBCore Framework.


#### Instructions


1. Place the image files from `assets/*` to **qb-inventory**, to the folder `qb-inventory/html/images/`

2. Copy & paste this code in `qb-inventory/server/main.lua` right below this function [here](https://github.com/qbcore-framework/qb-inventory/blob/main/server/main.lua#L1353)
```lua
local function getTrunkItems(plate)
	if not Trunks[plate] then return end

	return Trunks[plate].items
end
exports('getTrunkItems', getTrunkItems)
```

3. Now you can place this script folder `qb-hauling-trading` in your **resources** folder

4. Make sure that the `qb-hauling-trading` script is started, add `ensure qb-hauling-trading` line to `resources.cfg`.

At this point you should have it working.


## Discord
CyberRP Scripts: https://discord.gg/3SmVRVcDaf
