# Spectre Services Definition
Spectre services extend Spectre's functions and command set as one would see fit. They usually look something like this.

## Example service
```lua
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
	Modules[v.Name] = require(v)
end

-- Pull our own modules
for i, v in pairs(script["SpectreModules"]:GetChildren()) do
	Modules[`{script.Name}.{v.Name}`] = require(v)
end

-- Subsystems requested for operation 
-- (This is optional if your service does not rely on any subsystems, but most services should subscribe to the LogService at least)
local Subsystems = {
	LogService = require(Spectre["Subsystems"]["LogService"]),
}

-- Push to Spectre compartment in LogService
Subsystems.LogService:Push("Spectre",{
	Origin = "ExampleService",
	Ready = true
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
	Test = ExampleService.Test
}

return ExampleService -- All services are ModuleScripts
```

To break it down, Spectre services are three things:
* Extensions to the Spectre command set
* Additions to Spectre's modules that are then usable by any other service and itself
* Extensions to Spectre's API that are then available to server-side scripts 

## LogService
When you start and then stop a test game with Spectre fully installed, you should see output similar to this spat out from the LogService:
```json
{
  "LogService": [
    {
      "LS_TIMESTAMP": 1707858436109,
      "Ready": true
    }
  ],
  "Spectre": [
    {
      "LS_TIMESTAMP": 1707858436109,
      "Ready": true,
      "Origin": "MessageService"
    },
    {
      "LS_TIMESTAMP": 1707858436109,
      "Ready": true,
      "Origin": "AudioService"
    },
    {
      "LS_TIMESTAMP": 1707858436111,
      "Ready": true,
      "LoadedModules": {
        "Spectre.RecursiveFreeze": null,
        "Spectre.DictLength": null,
        "Spectre.SafeFind": null,
        "TestModule": null,
        "Spectre.Output": null,
        "Spectre.PlayerExistsInTable": null
      },
      "Origin": "ExampleService"
    },
    {
      "LS_TIMESTAMP": 1707858436112,
      "Ready": true,
      "Origin": "ModService"
    }
  ]
}
```

The LogService works something like this:
```lua
local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]

local Subsystems = {
	LogService = require(Spectre["Subsystems"]["LogService"]),
} -- Pull the LogService from Spectre

LogService:Push("Spectre",
{
  Origin = "ExampleThing",
  Ready = true
})
```
The LogService allows for any arbitrary 'compartment' to be selected (it will be created if it does not already exist) and for any arbitrary object information (in a table) to be sent back to the LogService to be consumed and entered into record. This example just pushes to Spectre's compartment with a Origin and Ready object inside of a table that makes it clear to the logs that a service has started. Spectre may require a 'ready' signal of some kind to be sent to the logs at some point in order to keep that service registered in Subsystems.