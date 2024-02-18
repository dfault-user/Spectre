# Spectre Services Definition
Spectre services extend Spectre's functions and command set as one would see fit. They usually look something like this.

## Example service
```lua
-- This is an example Spectre subsystem.
--

-- Do some variable initialization if you have to
-- This is an example Spectre subsystem.
--

-- Do some variable initialization if you have to
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")
local Spectre = ServerScriptService["Spectre"]
local Modules = {}

-- Subsystems required for operation
-- (This is optional if your service does not rely on any subsystems, but most services should subscribe to the LogService at least)
local Subsystems = {
	LogService = require(Spectre["Subsystems"]["LogService"]),
}

-- Pull all Spectre modules (Also optional, but it's probably a good idea )
for i, Module in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[`Spectre.{Module.Name}`] = require(Module)
	
	Subsystems.LogService:Push("ExampleService", {
		LoadedModule = Module.Name
	})
end-- Push to compartment in LogService

-- Pull our own modules
for i, Module in pairs(script["SpectreModules"]:GetChildren()) do
	Modules[Module.Name] = require(Module)
	
	Subsystems.LogService:Push("ExampleService", {
		LoadedModule = Module.Name
	})
end
-- Push to  compartment in LogService

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
      "LS_TIMESTAMP": 1708129384564,
      "Ready": true
    }
  ],
  "Spectre": [
    {
      "LS_TIMESTAMP": 1708129384564,
      "Ready": true,
      "Origin": "MessageService"
    },
    {
      "LS_TIMESTAMP": 1708129384564,
      "Ready": true,
      "Origin": "AudioService"
    },
    {
      "LS_TIMESTAMP": 1708129384565,
      "Ready": true,
      "Origin": "ModService"
    }
  ],
  "ExampleService": [
    {
      "LoadedModule": "DeepFind",
      "LS_TIMESTAMP": 1708129384564
    },
    {
      "LoadedModule": "DictLength",
      "LS_TIMESTAMP": 1708129384564
    },
    {
      "LoadedModule": "Output",
      "LS_TIMESTAMP": 1708129384564
    },
    {
      "LoadedModule": "PartialMatch",
      "LS_TIMESTAMP": 1708129384564
    },
    {
      "LoadedModule": "RecursiveFreeze",
      "LS_TIMESTAMP": 1708129384564
    },
    {
      "LoadedModule": "SafeFind",
      "LS_TIMESTAMP": 1708129384564
    },
    {
      "LoadedModule": "TestModule",
      "LS_TIMESTAMP": 1708129384564
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