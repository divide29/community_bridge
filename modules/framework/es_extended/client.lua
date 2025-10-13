---@diagnostic disable: duplicate-set-field
if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports.es_extended:getSharedObject()
Callback = Callback or Require("lib/callback/shared/callback.lua")

Framework = Framework or {}

local cachedItemList = nil

--- This is an internal function, its here to attempt to emulate qbs shared items mainly. This should not be used outside of bridge.
Framework.ItemList = function()
    if cachedItemList then return cachedItemList end
    local items = Callback.Trigger('community_bridge:Callback:GetFrameworkItems', false)
    cachedItemList = { Items = items.Items or {} }
    return cachedItemList
end

---This will get the name of the framework being used (if a supported framework).
---@return string
Framework.GetFrameworkName = function()
    print("This is depricated, please use Framework.GetResourceName() instead.")
    return Framework.GetResourceName()
end

---This will get the name of the in use resource.
---@return string
Framework.GetResourceName = function()
    return 'es_extended'
end

---This will return true if the player is loaded, false otherwise.
---This could be useful in scripts that rely on player loaded events and offer a debug mode to hit this function.
---@return boolean
Framework.GetIsPlayerLoaded = function()
    return ESX.IsPlayerLoaded()
end

--- This is an internal function, do not use this outside of bridge as there is no standard format between the frameworks.
--- @return table
Framework.GetPlayerData = function()
    return ESX.GetPlayerData()
end

---This will return a table of all the jobs in the framework.
---@return table
Framework.GetFrameworkJobs = function()
    local jobs = Callback.Trigger('community_bridge:Callback:GetFrameworkJobs', false)
    return jobs
end

---This will get the players birth date
---@return string
Framework.GetPlayerDob = function()
    local playerData = Framework.GetPlayerData()
    local dob = playerData.dateofbirth
    return dob
end

---This will return the players metadata for the specified metadata key.
---@param metadata table | string
---@return table | string | number | boolean
Framework.GetPlayerMetaData = function(metadata)
    return Framework.GetPlayerData().metadata[metadata]
end

---This will send a notification to the player.
---@param message string
---@param type string
---@param time number
---@return nil
Framework.Notify = function(message, type, time)
    return ESX.ShowNotification(message, type, time)
end

---Will Display the help text message on the screen
---@param message string
---@param _position unknown
---@return nil
Framework.ShowHelpText = function(message, _position)
    return exports.esx_textui:TextUI(message, "info")
end

---This will hide the help text message on the screen
---@return nil
Framework.HideHelpText = function()
    return exports.esx_textui:HideUI()
end

---This will get the players identifier (citizenid) etc.
---@return string
Framework.GetPlayerIdentifier = function()
    local playerData = Framework.GetPlayerData()
    return playerData.identifier
end

---This will get the players name (first and last).
---@return string
---@return string
Framework.GetPlayerName = function()
    local playerData = Framework.GetPlayerData()
    return playerData.firstName, playerData.lastName
end

---Depricated : This will return the players job name, job label, job grade label and job grade level
---@return string
---@return string
---@return string
---@return string
Framework.GetPlayerJob = function()
    print("This is depricated, please use Framework.GetPlayerJobData() instead.")
    local jobData = Framework.GetPlayerJobData()
    return jobData.jobName, jobData.jobLabel, jobData.gradeName, jobData.gradeRank
end

--- @description This will return the players job name, job label, job grade label job grade level,
--- boss status, and duty status in a table
--- @return table
Framework.GetPlayerJobData = function()
    local playerData = Framework.GetPlayerData()
    local jobData = playerData.job
    local isBoss = (jobData.grade_name == "boss")
    return {
        jobName = jobData.name,
        jobLabel = jobData.label,
        gradeName = jobData.grade_name,
        gradeLabel = jobData.grade_label,
        gradeRank = jobData.grade,
        boss = isBoss,
        onDuty = jobData.onduty,
    }
end

--This is an internal function to get status data
--- @param search string
Framework.GetStatusData = function(search)
    local playerData = Framework.GetPlayerData()
    if not playerData then return 0 end
    local status = playerData.variables.status
    for _, entry in ipairs(status) do
        if entry.name == search then
            return entry.percent or 0
        end
    end
    return 0
end

---This will get the hunger of a player
---@return number
Framework.GetHunger = function()
    local status = Framework.GetStatusData("hunger")
    return math.floor((status) + 0.5) or 0
end

---This will get the thirst of a player
---@return number
Framework.GetThirst = function()
    local status = Framework.GetStatusData("thirst")
    return math.floor((status) + 0.5) or 0
end

--- This is an internal function used as a fallback, please use the Inventory.HasItem instead.
--- @param item string
--- @return boolean
Framework.HasItem = function(item)
	local hasItem = ESX.SearchInventory(item, true)
	return hasItem > 0 and true or false
end

--- This is an internal function used as a fallback, please use the Inventory.GetItemCount instead.
--- @param item string
--- @return number
Framework.GetItemCount = function(item)
    local inventory = Framework.GetPlayerInventory()
    if not inventory then return 0 end
    return inventory[item].count or 0
end

--- This will return the item data for the specified item.
--- @param item string
--- @return table {name, label, stack, weight, description, image}
Framework.GetItemInfo = function(item)
    return {}, print("ESX has not implemented GetItemInfo for this framework. Please ensure the inventory you are using is supported and start order is correct.")
end

--- This is an internal function used as a fallback, please use the Inventory.GetPlayerInventory instead.
--- @return table {name, label, count, slot, metadata, stack, close, weight}
Framework.GetPlayerInventory = function()
    local playerData = Framework.GetPlayerData()
    if not playerData then return {} end
    local repack = {}
    for k, v in pairs(playerData.inventory) do
        repack[k] = {
            name = v.name,
            label = v.label,
            count = v.count,
            slot = 0,
            metadata = {},
            stack = false,
            close = v.usable or false,
            weight = v.weight or 0,
        }
    end
    return repack
end

---This will return the players money by type, I recommend not useing this as its the client and not secure or to be trusted.
---Use case is for a ui or a menu I guess.
---@param _type string
---@return number
Framework.GetAccountBalance = function(_type)
    local player = Framework.GetPlayerData()
    if not player then return 0 end
    local accounts = player.accounts
    if _type == 'cash' then _type = 'money' end
    for _, account in ipairs(accounts) do
        if account.name == _type then
            return account.money or 0
        end
    end
    return 0
end

--- @description This will return the vehicle properties for the specified vehicle
--- @param vehicle number
--- @return table
Framework.GetVehicleProperties = function(vehicle)
    if not vehicle or not DoesEntityExist(vehicle) then return {} end
    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
    return vehicleProps or {}
end

--- @description This will set the vehicle properties for the specified vehicle
--- @param vehicle number
--- @param properties table
--- @return boolean
Framework.SetVehicleProperties = function(vehicle, properties)
    if not vehicle or not DoesEntityExist(vehicle) then return false end
    if not properties then return false end
    if NetworkGetEntityIsNetworked(vehicle) then
        local vehNetID = NetworkGetNetworkIdFromEntity(vehicle)
        local entOwner = GetPlayerServerId(NetworkGetEntityOwner(vehNetID))
        if entOwner ~= GetPlayerServerId(PlayerId()) then
            NetworkRequestControlOfEntity(vehicle)
            local count = 0
            while not NetworkHasControlOfEntity(vehicle) and count < 3000 do
                Wait(1)
                count = count + 1
            end
        end
    end
    -- Every framework version does this just a diffrent key I guess?
    if properties.color1 and type(properties.color1) == 'table' then
        properties.customPrimaryColor = {properties.color1[1], properties.color1[2], properties.color1[3]}
        properties.color1 = nil
    end
    if properties.color2 and type(properties.color2) == 'table' then
        properties.customSecondaryColor = {properties.color2[1], properties.color2[2], properties.color2[3]}
        properties.color2 = nil
    end
    return true, ESX.Game.SetVehicleProperties(vehicle, properties)
end

--- @description This will get a players dead status
--- @return boolean
Framework.GetIsPlayerDead = function()
    local playerData = Framework.GetPlayerData()
    return playerData.dead
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    Wait(1500)
    TriggerEvent('community_bridge:Client:OnPlayerLoaded')
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    TriggerEvent('community_bridge:Client:OnPlayerUnload')
end)

RegisterNetEvent('esx:setJob', function(data)
    TriggerEvent('community_bridge:Client:OnPlayerJobUpdate', data.name, data.label, data.grade_label, data.grade)
end)

return Framework