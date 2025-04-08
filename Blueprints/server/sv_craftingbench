-- FILE: server/sv_craftingbench.lua
-- Mainframe RP - Server Logic for Blueprint Learning & Crafting
-- Description: Tracks blueprint progress and handles item crafting (no police alerts)

local QBCore = exports['qb-core']:GetCoreObject()
local playerBlueprints = {}

-- Helper to get or initialize player blueprint table
local function GetPlayerBlueprints(citizenId)
    if not playerBlueprints[citizenId] then
        playerBlueprints[citizenId] = {}
    end
    return playerBlueprints[citizenId]
end

-- Event: Learn a new blueprint by item use
RegisterServerEvent('mainframe:blueprints:learnBlueprint')
AddEventHandler('mainframe:blueprints:learnBlueprint', function(itemName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local blueprintKey = itemName:gsub("bp_", "")
    local cid = Player.PlayerData.citizenid
    local known = GetPlayerBlueprints(cid)

    if known[blueprintKey] then
        TriggerClientEvent('QBCore:Notify', src, 'You already know this blueprint.', 'error')
        return
    end

    known[blueprintKey] = true
    playerBlueprints[cid] = known

    Player.Functions.RemoveItem(itemName, 1)
    TriggerClientEvent('QBCore:Notify', src, 'Blueprint learned: ' .. blueprintKey, 'success')
    TriggerClientEvent('mainframe:blueprints:updateKnown', src, known)
end)

-- Event: Player opens crafting bench, send their known blueprints
QBCore.Functions.CreateCallback('mainframe:blueprints:getKnownBlueprints', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end
    local cid = Player.PlayerData.citizenid
    cb(GetPlayerBlueprints(cid))
end)

-- Event: Craft item if blueprint is known and materials are present
RegisterServerEvent('mainframe:blueprints:craftItem')
AddEventHandler('mainframe:blueprints:craftItem', function(itemKey)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local cid = Player.PlayerData.citizenid
    local known = GetPlayerBlueprints(cid)

    if not known[itemKey] then
        TriggerClientEvent('QBCore:Notify', src, 'You don't know how to craft this.', 'error')
        return
    end

    local required = {
        weapon_frame = 1,
        gun_oil = 1,
        spring_kit = 1,
        trigger = 1,
        gun_barrel = 1,
        stock = 1
    }

    for item, amount in pairs(required) do
        if not Player.Functions.GetItemByName(item) or Player.Functions.GetItemByName(item).amount < amount then
            TriggerClientEvent('QBCore:Notify', src, 'Missing materials: ' .. item, 'error')
            return
        end
    end

    -- Remove materials
    for item, amount in pairs(required) do
        Player.Functions.RemoveItem(item, amount)
    end

    -- Give crafted item (basic version assumes itemKey exists in shared items)
    Player.Functions.AddItem(itemKey, 1)
    TriggerClientEvent('QBCore:Notify', src, 'You crafted: ' .. itemKey, 'success')
end)
