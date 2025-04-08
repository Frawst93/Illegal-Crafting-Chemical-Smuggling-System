-- FILE: server/sv_blueprints.lua
-- Mainframe RP - Criminal Blueprint + Crafting Expansion System (Server Side)
-- Framework: QBCore | Inventory: ox_inventory | UI: ox_lib
-- Description: Blueprint acquisition missions that reward lootable items used at player crafting benches

local QBCore = exports['qb-core']:GetCoreObject()

-- Mission Definitions
BlueprintMissions = {
    ["smuggler_escort"] = {
        label = "Smuggler Escort",
        description = "Escort a black market convoy through hostile zones.",
        blueprintReward = "bp_glock",
        coords = vector3(1100.25, -2005.64, 30.01),
        policeRequired = 3,
        alertMessage = "Black market convoy reported leaving LS Docks."
    },
    ["warehouse_breakin"] = {
        label = "Warehouse Break-In",
        description = "Breach a locked warehouse and extract blueprint crates guarded by armed NPCs.",
        blueprintReward = "bp_ext_mag",
        coords = vector3(745.92, -974.10, 24.91),
        policeRequired = 3,
        alertMessage = "Suspicious activity detected near commercial loading bays."
    },
    ["intel_theft"] = {
        label = "High-Value Intel Theft",
        description = "Hack an encrypted laptop at a mobile FIB van in Paleto.",
        blueprintReward = "bp_ak47",
        coords = vector3(-215.72, 6285.04, 31.49),
        policeRequired = 3,
        alertMessage = "Surveillance breach: FIB data center interference logged."
    }
}

function CanStartIllegalMission(source, minCops)
    local onlineCops = 0
    for _, playerId in ipairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(playerId)
        if xPlayer and xPlayer.PlayerData.job and xPlayer.PlayerData.job.name == 'police' and xPlayer.PlayerData.job.onduty then
            onlineCops = onlineCops + 1
        end
    end
    return onlineCops >= minCops
end

RegisterServerEvent('mainframe:blueprints:startMission')
AddEventHandler('mainframe:blueprints:startMission', function(missionKey)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local mission = BlueprintMissions[missionKey]
    if not mission then return end

    if not CanStartIllegalMission(src, mission.policeRequired) then
        TriggerClientEvent('QBCore:Notify', src, 'Not enough police on duty to start this mission.', 'error')
        return
    end

    TriggerClientEvent('mainframe:blueprints:startMissionClient', src, missionKey, mission.coords)
    TriggerEvent('mainframe:police:alertMission', mission.alertMessage, mission.coords)
end)
