Logs = Logs or {}
local BridgeServerConfig = BridgeServerConfig or Require("settings/serverConfig.lua")

local logHandlers = {
    fivemerr = function(logData)
        local fivemerrData = {
            level = "info",
            message = tostring(logData),
            resource = GetInvokingResource() or GetCurrentResourceName(),

        }
        PerformHttpRequest("https://api.fivemerr.com/v1/logs", function(code, text, headers)
            if code ~= 200 then
                print(("Failed to send log to Fivemerr API (HTTP %d): Please verify your API key is correct and the service is available."):format(code))
            else
                print("Log successfully sent to Fivemerr")
            end
        end, 'POST', json.encode(fivemerrData), {
            ['Content-Type'] = 'application/json',
            ['Authorization'] = BridgeServerConfig.FivemerrApiKey
        })
    end,

    qb = function(message)
        TriggerEvent('qb-log:server:CreateLog', GetCurrentResourceName(), GetInvokingResource(), 'green', message, false)
    end,

    ox_lib = function(message)
        lib.logger(GetInvokingResource(), GetCurrentResourceName(), message)
    end,

    ["built-in"] = function(message)
        PerformHttpRequest(BridgeServerConfig.WebhookURL, function(err, text, headers) end, 'POST', json.encode({
            username = "Community_Bridge's Logger",
            avatar_url = 'https://avatars.githubusercontent.com/u/192999457?s=400&u=da632e8f64c85def390cfd1a73c3b664d6882b38&v=4',
            embeds = { {
                color = "15769093",
                title = GetInvokingResource(),
                thumbnail = { url = BridgeServerConfig.EmbedLogo },
                fields = {
                    {
                        name = 'Log Message',
                        value = "```" .. message .. "```",
                        inline = false,
                    }
                },
                timestamp = os.date('!%Y-%m-%dT%H:%M:%S'),
            } }
        }), { ['Content-Type'] = 'application/json' })
    end
}

---@deprecated Use Logs.CreateLog instead (deprecated 9/1/25)
Logs.Send = function(src, message)
    print("^1Deprecated^0 function 'Logs.Send' called. Please use 'Logs.CreateLog' instead.")
    Logs.CreateLog(message)
end

---@deprecated Use Logs.CreateLog instead (deprecated 9/1/25)
Logs.Notify = function(src, url, image, message)
    print("^1Deprecated^0 function 'Logs.Notify' called. Please use 'Logs.CreateLog' instead.")
    Logs.CreateLog(message)
end

Logs.CreateLog = function(logData)
    local handler = logHandlers[BridgeServerConfig.LogSystem]
    if handler then handler(logData) end
end

exports('Logs', Logs)
return Logs