local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]
local Subsystem = require(script.Parent.Parent)
local Modules = {}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

return {
	RoleLevel = 2,
	Description = "Teleport to a player",
	HookIdent = "TP2P",
	Aliases = {
		"tp2p",
		"goto",
	},

	Exec = function(Player: Player, args: {})
		local Target = Modules.PartialMatch(args[1])
		if Target then
			Subsystem:ShiftPlayers(Player, Target)
		end
	end
}
