local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]
local Subsystem = require(script.Parent.Parent)
local Modules = {}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

return {
	RoleLevel = 2,
	Description = "Announce a message",
	HookIdent = "ANCM",
	Aliases = {
		"message",
		"m"
	},

	Exec = function(plr, args)
		Subsystem:PushMessage({
			MessagePresentation = "Message",
			MessageType = "Standard",
			String = table.concat(args, " "),
		}, plr)
	end,
}
