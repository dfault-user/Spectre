local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]
local Subsystem = require(script.Parent.Parent)
local Modules = {}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

return {
	NonAdmin = true,
	Description = "Kick a player",
	HookIdent = "MODKICK",
	Command = "kick",

	Exec = function(plr, args)
		print(args)
		Subsystem:Action({
			Type = "Kick",
			Reason = args[2],
			ActioningUser = plr,
			OffendingUser = Modules.PartialMatch(args[1]),
		})
	end,
}
