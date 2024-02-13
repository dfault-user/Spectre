-- This is an example Spectre subsystem.
-- It contains the following: an example function, and an example command.

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")
local Spectre = ServerScriptService["Spectre"]
local Modules = {}
local Subsystems = {
	LogService = require(Spectre["Subsystems"]["LogService"]),
}
for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

-- The above is boilerplate, and is recommended for access to all Spectre modules. If you need to require any subsystems like the LogService at this point, do it now.
Subsystems.LogService:Push("Spectre",{
	Origin = "ExampleService",
	Ready = true
})

local ExampleService = {}

function ExampleService:Test(...)
	Modules.Output(`{script.Name}`, `Example fired: {...}`)
	return ...
end

ExampleService.API = {
	Test = ExampleService.Test
}

return ExampleService -- All Spectre subsystems are ModuleScripts, and as such, need to return the subsystem to be valid