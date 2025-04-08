-- FILE: client/cl_blueprints.lua
-- Mainframe RP - Blueprint Mission Client Logic
-- Description: Handles mission spawning, NPC logic, and reward delivery

local QBCore = exports['qb-core']:GetCoreObject()
local activeMission = false

RegisterNetEvent('mainframe:blueprints:startMissionClient', function(missionKey, coords)
    if activeMission then
        QBCore.Functions.Notify("You are already on a mission!", "error")
        return
    end

    activeMission = true
    QBCore.Functions.Notify("Mission started: Check your GPS and follow objectives.", "primary")

    if missionKey == "smuggler_escort" then
        StartEscortMission(coords)
    elseif missionKey == "warehouse_breakin" then
        StartWarehouseRaid(coords)
    elseif missionKey == "intel_theft" then
        StartIntelTheft(coords)
    end
end)

function StartEscortMission(spawnCoords)
    -- [Escort mission logic would be here...]
end

function StartWarehouseRaid(coords)
    -- [Warehouse break-in logic would be here...]
end

function SpawnWarehouseGuards(center)
    -- [Warehouse NPC spawn logic...]
end

function StartIntelTheft(coords)
    -- [Intel theft mission logic...]
end

function SpawnIntelGuards(center)
    -- [Intel NPCs spawn and engage logic...]
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 100)
end
