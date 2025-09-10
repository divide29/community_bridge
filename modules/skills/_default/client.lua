---@diagnostic disable: duplicate-set-field
Skills = Skills or {}

XP_CACHE = {}

-- Calculate XP required for a level using RuneScape algorithm (with caching)
Skills.GetXPForLevel = function(level)
    if not level or level < 1 then return 0 end
    if level == 1 then return 0 end  -- Level 1 requires 0 XP

    -- Check cache first
    if XP_CACHE[level] then
        return XP_CACHE[level]
    end

    -- Calculate and cache
    local xp = 0
    for n = 1, level - 1 do
        xp = xp + math.floor(n + 300 * (2 ^ (n / 7)))
    end
    local result = math.floor(xp / 4)
    XP_CACHE[level] = result

    return result
end

-- Create a skill (for initialization)
Skills.Create = function(name, maxLevel, baseXP)
    if not name then return end
    Skills.All[name] = { name = name, maxLevel = maxLevel or 99, baseXP = baseXP or 50 }
    return Skills.All[name]
end

Skills.GetScaledXP = function(baseXP, playerLevel)
    return math.floor(baseXP * (1 + playerLevel * 0.05))
end

-- Get XP required to complete the current level
Skills.GetXPRequiredForLevel = function(level)
    if not level or level < 1 then return 0 end
    if level == 1 then return 83 end  -- Level 1 to 2 requires 83 XP
    return Skills.GetXPForLevel(level)
end

---This will get the skill level of the passed skill name. (returns 1 if not found)
---@param skillName string
---@return number
Skills.GetSkillLevel = function(skillName)
    if not skillName then return 0 end
    local plyrSkills = Framework.GetPlayerMetaData("community_bridge_skills")
    if not plyrSkills or not plyrSkills[skillName] then return 1 end
    return plyrSkills[skillName].level or 1
end

---This will get the skill xp of the passed skill name. (returns 1 if not found)
---@param skillName string
---@return number
Skills.GetXP = function(skillName)
    if not skillName then return 0 end
    local plyrSkills = Framework.GetPlayerMetaData("community_bridge_skills")
    if not plyrSkills or not plyrSkills[skillName] then return 1 end
    return plyrSkills[skillName].currentXP or 1
end

Skills.GetResourceName = function()
    return "default"
end

-- RegisterCommand("getfishingLevel", function(source, args)
--     local level = Skills.GetSkillLevel("fishing")
--     print("Client Fishing Level issssssssss  " .. level)
-- end, false)

return Skills