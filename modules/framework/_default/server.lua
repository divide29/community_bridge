Framework = Framework or {}

local jobsRegisteredTable = {}
local invertedJobsRegisteredTable = {}

---This is an internal function that will be used to retrieve job counts later.
---@param jobName string
---@return number
Framework.GetJobCount = function(jobName)
    return #jobsRegisteredTable[jobName] or 0
end

---This will return a list of player sources for a given job.
---@param jobName string
---@return table
Framework.GetPlayerSourcesByJob = function(jobName)
    if not jobsRegisteredTable[jobName] then return {} end
    return jobsRegisteredTable[jobName]
end

---This will update the cached tables for job counts.
---This is used to track how many players are in a job.
---@param src number
---@param jobName string
Framework.AddJobCount = function(src, jobName)
    if not jobsRegisteredTable[jobName] then jobsRegisteredTable[jobName] = {} end
    if jobsRegisteredTable[jobName][src] then return false end
    jobsRegisteredTable[jobName][src] = true
    invertedJobsRegisteredTable[src] = jobName
    return true, #jobsRegisteredTable[jobName]
end

---This will return the job name for a given source.
---This is an internal function that will be used to retrieve job names in situations where player data is unavailable.
---@param src number
Framework.SearchJobCountBySource = function(src)
    if not invertedJobsRegisteredTable[src] then return nil end
    return invertedJobsRegisteredTable[src]
end

---This will remove the job count for a given source.
---@param src number
---@param jobName string | nil
Framework.RemoveJobCount = function(src, jobName)
    if not jobName then
        jobName = Framework.SearchJobCountBySource(src)
    end
    if not jobName then return false end
    if not jobsRegisteredTable[jobName] then return false end
    if not jobsRegisteredTable[jobName][src] then return false end
    invertedJobsRegisteredTable[src] = nil
    jobsRegisteredTable[jobName][src] = nil
    return true, #jobsRegisteredTable[jobName]
end

AddEventHandler('community_bridge:Server:OnPlayerJobChange', function(src, newJobName)
    local previousJob = Framework.SearchJobCountBySource(src)
    if previousJob then Framework.RemoveJobCount(src, previousJob) end
    if newJobName then Framework.AddJobCount(src, newJobName) end
end)

AddEventHandler('community_bridge:Server:OnPlayerUnload', function(src)
    Framework.RemoveJobCount(src)
end)

return Framework