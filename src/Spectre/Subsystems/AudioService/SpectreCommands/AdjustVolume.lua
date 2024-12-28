local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]
local SpectreAudio = require(script.Parent.Parent)
local Modules = {}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

return {
	RoleLevel = 2,
	Description = "Adjust the volume of any currently playing Spectre Audio",
	HookIdent = "AUDADJVOL",
	Aliases = {
		"pause",
		"apause"
	},

	Exec = function(plr, args)
		local sObj = SpectreAudio:GetObject()
		if sObj then
			sObj.Volume = tonumber(args[1])
		end
	end,
}
