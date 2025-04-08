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
    local convoyModel = `stockade`
    RequestModel(convoyModel)
    while not HasModelLoaded(convoyModel) do Wait(0) end

    local convoyVeh = CreateVehicle(convoyModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, 180.0, true, false)
    local convoyDriver = CreatePedInsideVehicle(convoyVeh, 4, `s_m_m_security_01`, -1, true, false)
    SetDriverAbility(convoyDriver, 1.0)
    SetPedAsGroupMember(convoyDriver, GetPlayerGroup(PlayerPedId()))

    TaskVehicleDriveWander(convoyDriver, convoyVeh, 25.0, 786603)
    SetVehicleDoorsLocked(convoyVeh, 1)

    local destination = vector3(1386.62, 3609.82, 34.89)
    local blip = AddBlipForCoord(destination)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 5)

    QBCore.Functions.Notify("Escort the convoy and ensure it reaches the drop-off point.", "info")

    CreateThread(function()
        while #(GetEntityCoords(convoyVeh) - destination) > 15.0 do Wait(1000) end

        DeleteVehicle(convoyVeh)
        RemoveBlip(blip)
        TriggerServerEvent('mainframe:blueprints:completeEscortMission')
        QBCore.Functions.Notify("Mission Complete: You received a blueprint.", "success")
        activeMission = false
    end)
end

function StartWarehouseRaid(coords)
    QBCore.Functions.Notify("Travel to the warehouse and breach the back door.", "info")

    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, 539)
    SetBlipColour(blip, 1)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 1)

    local breached = false

    CreateThread(function()
        while not breached do
            Wait(0)
            local playerCoords = GetEntityCoords(PlayerPedId())
            if #(playerCoords - coords) < 3.5 then
                DrawText3D(coords.x, coords.y, coords.z, "[E] Shoot lock to enter")
                if IsPedArmed(PlayerPedId(), 6) and IsControlJustReleased(0, 38) then -- E key
                    breached = true
                    RemoveBlip(blip)
                    QBCore.Functions.Notify("You've breached the door, hostiles inside!", "warning")
                    SpawnWarehouseGuards(coords)
                end
            end
        end
    end)
end

function SpawnWarehouseGuards(center)
    local pedModel = `g_m_y_mexgoon_02`
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do Wait(0) end

    local spawnOffsets = {
        vector3(2, 1, 0), vector3(-2, 1, 0), vector3(1, -2, 0)
    }

    for _, offset in pairs(spawnOffsets) do
        local pos = center + offset
        local ped = CreatePed(4, pedModel, pos.x, pos.y, pos.z, 90.0, true, false)
        GiveWeaponToPed(ped, `weapon_microsmg`, 250, false, true)
        TaskCombatPed(ped, PlayerPedId(), 0, 16)
    end

    CreateThread(function()
        Wait(10000)
        QBCore.Functions.Notify("Collect the blueprint crate before reinforcements arrive!", "success")
        TriggerServerEvent('mainframe:blueprints:completeWarehouseMission')
        activeMission = false
    end)
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

-- TODO: Implement StartIntelTheft()
