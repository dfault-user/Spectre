local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]
local SpectreAudio = require(script.Parent.Parent)
local Modules = {}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

return {
	RoleLevel = 2,
	Description = "Pause audio",
	HookIdent = "AUDPL",
	Aliases = {
		"pause",
		"apause"
	},

	Exec = function(plr, args)
		local sObj = SpectreAudio:GetObject()
		sObj.Playing = not sObj.Playing
	end,
}
