local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]
local Subsystem = require(script.Parent.Parent)
local Modules = {}

for i,v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

return {
	NonAdmin = true,
	Description = "Announce a system message",
	HookIdent = "ANCSM",
	Command = "systemmessage",

	Exec = function(plr,args)
		Subsystem:PushMessage({
			MessagePresentation = "Message",
			MessageType = "System",
			String = table.concat(args,' ')
		},plr)
	end,
}
