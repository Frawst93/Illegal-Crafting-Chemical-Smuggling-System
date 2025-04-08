-- FILE: client/cl_craftingbench.lua
-- Mainframe RP - Player Bench Crafting System (Client)
-- Description: Allows players to unlock & craft weapons if blueprint is learned

local QBCore = exports['qb-core']:GetCoreObject()
local playerBlueprints = {}

RegisterNetEvent('mainframe:blueprints:updateKnown')
AddEventHandler('mainframe:blueprints:updateKnown', function(knownBlueprints)
    playerBlueprints = knownBlueprints
end)

RegisterNetEvent('mainframe:blueprints:openCraftingBench')
AddEventHandler('mainframe:blueprints:openCraftingBench', function()
    local options = {}
    for blueprint, unlocked in pairs(playerBlueprints) do
        if unlocked then
            table.insert(options, {
                title = "Craft " .. blueprint,
                description = "Requires materials.",
                icon = "hammer",
                onSelect = function()
                    TriggerServerEvent('mainframe:blueprints:craftItem', blueprint)
                end
            })
        end
    end

    if #options == 0 then
        QBCore.Functions.Notify("You haven't unlocked any blueprints yet.", "error")
        return
    end

    lib.registerContext({
        id = 'crafting_bench',
        title = 'Weapon Bench',
        options = options
    })

    lib.showContext('crafting_bench')
end)

-- Usable item triggers this event when player uses a blueprint near a crafting bench
RegisterNetEvent('mainframe:blueprints:useItem')
AddEventHandler('mainframe:blueprints:useItem', function(itemName)
    TriggerServerEvent('mainframe:blueprints:learnBlueprint', itemName)
end)

-- Target zone or polyzone calls this to open the crafting UI
exports('OpenCraftingBench', function()
    TriggerEvent('mainframe:blueprints:openCraftingBench')
end)
