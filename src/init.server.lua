Players = game:GetService("Players")

local Command = require(script["Types"].Command)
type Command = Command.Class

Spectre = {
	Version = "rewrite-1",
	Settings = require(script["Settings"]),
	
	Commands = {
		["test"] = Command.new({
			"test"
		}, "Tests Spectre Rewrite",
		function(Player, Arguments)
			print(Player, Arguments)
		end)
	}

}

function Spectre:RegisterCommand(Player: Player, Command: Command)
	
end
