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
		function(Player: Player, Arguments: {})
			print(Player, Arguments)
		end)
	}

}
function Spectre:RegisterCommand(Player: Player, Command: Command)
	for _,Alias in Command.Aliases do
		local CommandTrigger = `{Spectre.Settings.Prefix}{Alias}`
		local Connection = Player.Chatted:Connect(function(Message: string)
			local Arguments = Message:sub(#CommandTrigger+2):split(',')
			if Message:sub(1,#CommandTrigger) == CommandTrigger then
				local ExecutionSuccess, ExecutionReturnChannel = pcall(Command.Execute, Player, Arguments)
				if ExecutionSuccess then
					print(`{Alias} fired successfully with arguments ({table.concat(Arguments,', ')})`)
				elseif not ExecutionSuccess and ExecutionReturnChannel then
					print(`{Alias} failed to fire ({ExecutionReturnChannel})`)
				else
					print('???')
				end
			end
		end)
	end
end

function Spectre.PlayerAdded(Player: Player)
	for _,Command in pairs(Spectre.Commands) do
		Spectre:RegisterCommand(Player, Command)
	end
end

Players.PlayerAdded:Connect(Spectre.PlayerAdded)
for i,Player in pairs(Players:GetPlayers()) do
	for _,Command in pairs(Spectre.Commands) do
		Spectre:RegisterCommand(Player, Command)
	end
end
