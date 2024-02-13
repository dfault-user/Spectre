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

Spectre = {
	Version = "alpha-3",

	Settings = require(script["Settings"]),

	ChatHooks = {},

	Modules = {},

	Subsystems = {},

	Commands = {},
}

-- Load Spectre Modules
for i, v in pairs(Modules:GetChildren()) do
	Spectre.Modules[v.Name] = require(v)
end

-- Load Spectre Internal Commands
for i, v in pairs(Commands:GetChildren()) do
	Spectre.Commands[v.Name] = require(v)
end

-- Load Spectre Subsystems
for i, v in pairs(Subsystems:GetChildren()) do
	Spectre.Subsystems[v.Name] = require(v)
	local HasAddtCommands
	local Success, Result = pcall(v.FindFirstChildWhichIsA, v, "Folder", false)

	if Success and Result then
		HasAddtCommands = Result
	end

	if HasAddtCommands then
		for i, v in pairs(v:FindFirstChild("SpectreCommands"):GetChildren()) do
			Spectre.Commands[v.Name] = require(v)
		end
	end
end

Modules = Spectre.Modules
Commands = Spectre.Commands
Subsystems = Spectre.Subsystems
ExternalSubsystems = Spectre.ExternalSubsystems

Spectre.Modules.Output(
	"Init",
	`Kickstarted with {Modules.DictLength(Modules)} modules, {Modules.DictLength(Commands)} commands, and {Modules.DictLength(Subsystems)} subsystems`
)

function Spectre:isAdmin(Player: Player)
	return Spectre.Modules.PlayerExistsInTable(Player, Spectre.Settings.Admins)
end

function Spectre:RegisterCommand(
	Player: Player,
	CommandModule: {
		NonAdmin: boolean,
		Description: string,
		HookIdent: string,
		Command: string,
		Exec: any,
	}
)
	local isAdmin = Spectre:isAdmin(Player)
	if CommandModule.NonAdmin or isAdmin then
		local chStr = (`{CommandModule.Command}{Spectre.Settings.Seperator}`):lower()

		Spectre.ChatHooks[`{Player}`][`{CommandModule.HookIdent}`] = Player.Chatted:Connect(function(message)
			if message:sub(1, #chStr) == chStr then
				local arguments = message:sub(#chStr + 1):split(Spectre.Settings.Seperator)
				local s, e = pcall(CommandModule.Exec, Player, arguments)
				if not s and e then
					Spectre.Modules.Output(
						`{CommandModule.Command}`,
						`{Player} failed to execute command {CommandModule.Command}: {e}`
					)
					return false
				elseif s then
					Spectre.Modules.Output(
						`{CommandModule.Command}`,
						`{Player} executed command {CommandModule.Command} with arguments {table.concat(arguments,'/')}`
					)
					return true
				end
			end
		end)
	end

	return 1
end

local function PlayerAdded(plr: Player)
	pcall(function()
		if Spectre.ChatHooks[plr.Name] == nil then
			Spectre.ChatHooks[plr.Name] = {}
		else
			table.clear(Spectre.ChatHooks[plr.Name])
		end
	end)

	local registered = 0
	for cmdR, cmd in pairs(Spectre.Commands) do
		registered += Spectre:RegisterCommand(plr, cmd)
	end

	Spectre.Modules.Output("Init", `Registered {registered} commands for {plr}`)
end

local function PlayerRemoving(plr: Player)
	Spectre.Modules.Output("Detach",`Deregistered {Spectre.Modules.DictLength(Spectre.ChatHooks[`{plr}`])} commands from {plr}`)
	for i, v in pairs(Spectre.ChatHooks[`{plr}`]) do
		v:Disconnect()
	end
	Spectre.ChatHooks[`{plr}`] = nil
end

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoving)