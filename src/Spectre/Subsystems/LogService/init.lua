local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")
local Spectre = ServerScriptService["Spectre"]
local Modules = {}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

Modules.Output(`{script.Name}`, "Waking up..")

local LogService = {

	Logs = {},
}

setmetatable(LogService.Logs, {
	__index = function(tbl, index)
		if rawget(tbl, index) == nil then
			rawset(tbl, index, {})
			return rawget(tbl, index)
		end
	end,
})

function LogService:Push(compartment: string, object: {})
	if LogService.Logs[compartment] == nil then
		LogService.Logs[compartment] = {}
	end

	object["LS_TIMESTAMP"] = DateTime.now().UnixTimestampMillis
	LogService.Logs[compartment][#LogService.Logs[compartment] + 1] = object
end

function LogService:PullAll()
	return LogService.Logs
end

function LogService:GetSize()
	return #HttpService:JSONEncode(LogService:PullAll())
end

LogService.API = {
	GetSize = LogService.GetSize,
	PullAll = LogService.PullAll,
	Push = LogService.Push
}

LogService:Push('LogService',{
	Ready = true
})

game:BindToClose(function()
	Modules.RecursiveFreeze(LogService:PullAll())
	print(HttpService:JSONEncode(LogService:PullAll()))
end)

return LogService