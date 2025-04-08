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
    QBCore.Functions.Notify("Mission started: Escort the vehicle to its destination.", "primary")

    if missionKey == "smuggler_escort" then
        StartEscortMission(coords)
    elseif missionKey == "warehouse_breakin" then
        StartWarehouseRaid(coords)
    elseif missionKey == "intel_theft" then
        StartIntelTheft(coords)
    end
end)

function StartEscortMission(spawnCoords)
    local convoyModel = `stockade`
    RequestModel(convoyModel)
    while not HasModelLoaded(convoyModel) do Wait(0) end

    local convoyVeh = CreateVehicle(convoyModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, 180.0, true, false)
    local convoyDriver = CreatePedInsideVehicle(convoyVeh, 4, `s_m_m_security_01`, -1, true, false)
    SetDriverAbility(convoyDriver, 1.0)
    SetPedAsGroupMember(convoyDriver, GetPlayerGroup(PlayerPedId()))

    TaskVehicleDriveWander(convoyDriver, convoyVeh, 25.0, 786603)
    SetVehicleDoorsLocked(convoyVeh, 1)

    -- Mark destination
    local destination = vector3(1386.62, 3609.82, 34.89)
    local blip = AddBlipForCoord(destination)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 5)

    QBCore.Functions.Notify("Escort the convoy and ensure it reaches the drop-off point.", "info")

    CreateThread(function()
        while #(GetEntityCoords(convoyVeh) - destination) > 15.0 do
            Wait(1000)
        end

        -- Clean up
        DeleteVehicle(convoyVeh)
        RemoveBlip(blip)
        TriggerServerEvent('mainframe:blueprints:completeEscortMission')
        QBCore.Functions.Notify("Mission Complete: You received a blueprint.", "success")
        activeMission = false
    end)
end

-- TODO: Implement StartWarehouseRaid()
-- TODO: Implement StartIntelTheft()
