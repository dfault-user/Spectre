--[[
	Spectre, an extensible admin system

	MIT License

	Copyright (c) 2023 Brandan C. Delafuente
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local Modules = script["Modules"]
local Subsystems = script["Subsystems"]
local Commands = script["Commands"]
local Libraries = script["Libraries"]

Spectre = {
	Version = "beta-1",
	Settings = require(script["Settings"]),

	Libraries = {},

	Modules = {},

	Subsystems = {},

	Commands = {},

	ChatHooks = {}
}


function Include(ModuleScript: ModuleScript, Type: "Module" | "Subsystem" | "Library")
	local RequiredModule = require(ModuleScript)
	
	if Type == "Module" then
		Spectre.Modules[ModuleScript.Name] = RequiredModule
	elseif Type == "Subsystem" then
		Spectre.Subsystems[ModuleScript.Name] = RequiredModule
		local HasAddtCommands
		local HasAddtModules
	
		local AddtCommands = Modules.SafeFind(ModuleScript, "SpectreCommands", "Folder")
		local AddtModules = Modules.SafeFind(ModuleScript, "SpectreModules", "Folder")
	
		if AddtCommands then
			for _, Command in pairs(AddtCommands:GetChildren()) do
				local RequiredCommand = require(Command)
				Spectre.Commands[Command.Name] = RequiredCommand
			end
		end
	
		if AddtModules then
			for _, Module in pairs(AddtModules:GetChildren()) do
				if Spectre.Modules[Module.Name] then
					warn(`Attempting to deduplicate incoming module {Module.Name} from {ModuleScript.Name}`)
					local DedupName = `{Module.Name}.{ModuleScript.Name}`
					Spectre.Modules[DedupName] = RequiredModule
				else
					Spectre.Modules[Module.Name] = RequiredModule
				end
			end
		end
	elseif Type == "Library" then
		RequiredModule = require(ModuleScript)(script)
		Spectre.Libraries[ModuleScript.Name] = RequiredModule
	end
end

-- Load Spectre Libraries
for _, Library in pairs(Libraries:GetChildren()) do
	Include(Library, "Library")
end

-- Load Spectre Modules
for _, Module in pairs(Modules:GetChildren()) do
	Include(Module, "Module")
end

Libraries = Spectre.Libraries
Modules = Spectre.Modules
Modules.Output("Spectre", `Registered {Modules.DictLength(Modules)} internal modules`)

-- Load Spectre Internal Commands
for _, Command in pairs(Commands:GetChildren()) do
	Spectre.Commands[Command.Name] = require(Command)
end

-- Load Spectre Subsystems
for _, Subsystem in pairs(Subsystems:GetChildren()) do
	Include(Subsystem, "Subsystem")
end

Commands = Spectre.Commands
Subsystems = Spectre.Subsystems
Modules.Output(
	"Init",
	`Registered {Modules.DictLength(Modules)} modules and {Modules.DictLength(Subsystems)} subsystems`
)
-- Initialize Spectre as a global thing
_G.Spectre = {
	Modules = Modules,
	Subsystems = {},
}

-- Selectively add subsystems with an API to the global thing
for i, v in pairs(Subsystems) do
	local hasAPI = v["API"] ~= nil

	if hasAPI then _G.Spectre["Subsystems"][i] = v.API end
end

Spectre.Modules.Output(
	"Init",
	`Ready with {Modules.DictLength(Modules)} modules, {Modules.DictLength(Commands)} commands, and {Modules.DictLength(Subsystems)} subsystems`
)

function Spectre:hasAccess(Player: Player) 
	return Libraries.PlayerLib:CheckAccess(Spectre.Settings.Roles, Player)
end

function Spectre:RegisterCommand(
	Player: Player,
	CommandModule: {
		RoleLevel: number,
		Description: string,
		HookIdent: string,
		Aliases: {},
		Exec: any,
	}
)
		Spectre.ChatHooks[`{Player.Name}`][`{CommandModule.HookIdent}`] = {} 
		for _, Alias in ipairs(CommandModule.Aliases) do 
		local CommandTrigger = (`{Alias}{Spectre.Settings.Separator}`):lower()
			Player.Chatted:Connect(function(message)
			if message:sub(1, #CommandTrigger):lower() == CommandTrigger then
				local args = message:sub(#CommandTrigger + 1):split(Spectre.Settings.Seperator)
				local CommandExecutionSuccess, CommandExecutionReturnChannel = pcall(CommandModule.Exec, Player, args)
				if not CommandExecutionSuccess and CommandExecutionReturnChannel then
					Spectre.Modules.Output(
						`{CommandModule.HookIdent}:{Alias}`,
						`{Player} failed to execute command {CommandModule.HookIdent}:{Alias}: {CommandExecutionReturnChannel}`
					)
				elseif CommandExecutionSuccess then
				Spectre.Modules.Output(
						`{CommandModule.HookIdent}:{Alias}`,
						`{Player} executed command {CommandModule.HookIdent}:{Alias}" with arguments {table.concat(args, "/")}`
				)
				end
			end
			end)
		end

	return true
end

local function PlayerAdded(Player: Player)
	local PlayerAccessLevel = Spectre:hasAccess(Player)
	local PlayerRole = PlayerAccessLevel.Role
	local PlayerCommandPriority = PlayerAccessLevel.Priority
	pcall(function()
		if Spectre.ChatHooks[Player.Name] == nil then
			Spectre.ChatHooks[Player.Name] = {}
		else
			table.clear(Spectre.ChatHooks[Player.Name])
		end
	end)
	
	Player:SetAttribute("Spectre_AccessLevel",
		PlayerRole
	)
	
	for cmdR, cmd in pairs(Spectre.Commands) do
		if PlayerAccessLevel.Priority >= cmd.RoleLevel then
			Spectre:RegisterCommand(Player, cmd)
		end
	end

	Spectre.Modules.Output("Init", `Registered {Modules.DictLength(Spectre.ChatHooks[`{Player}`])} commands for {Player}`)
end

local function PlayerRemoving(plr: Player)
	
	for IndexTop, ChatHook in pairs(Spectre.ChatHooks[`{plr}`]) do
		for Index, Connection in pairs(ChatHook) do
			Connection:Disconnect()
		end
	end
	
	Spectre.Modules.Output(
		"Detach",
		`Deregistered {Modules.DictLength(Spectre.ChatHooks[`{plr}`])} commands from {plr}`
	)
	
	Spectre.ChatHooks[`{plr}`] = nil
end

for i,v in pairs(Players:GetPlayers()) do 
	PlayerAdded(v)
end

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoving)
