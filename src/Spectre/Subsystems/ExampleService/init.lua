-- This is an example Spectre subsystem.
--

-- Do some variable initialization if you have to
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")
local Spectre = ServerScriptService["Spectre"]
local Modules = {}

-- Pull all Spectre modules (Also optional, but it's probably a good idea )
for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[`Spectre.{v.Name}`] = require(v)
end

-- Pull our own modules
for i, v in pairs(script["SpectreModules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

-- Subsystems required for operation
-- (This is optional if your service does not rely on any subsystems, but most services should subscribe to the LogService at least)
local Subsystems = {
	LogService = require(Spectre["Subsystems"]["LogService"]),
}
-- Push to Spectre compartment in LogService
Subsystems.LogService:Push("Spectre", {
	Origin = "ExampleService",
	LoadedModules = Modules,
	Ready = true,
})

-- Initialize service table
local ExampleService = {}

-- Add method to service
function ExampleService:Test(...)
	Modules.Output(`{script.Name}`, `Example fired: {...}`)
	return ...
end

-- This is used to push an not-API API to Spectre for inclusion in _G.Spectre later
-- This is very much optional, all services will load without an API attached
ExampleService.API = {
	Test = ExampleService.Test,
}

return ExampleService -- All services are ModuleScripts
