local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]
local SpectreAudio = require(script.Parent.Parent)
local Modules = {}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

return {
	RoleLevel = 2,
	Description = "Play audio",
	HookIdent = "AUDP",
	Aliases = {
		"aplay",
		"play"
	},

	Exec = function(plr: Player, args: {})
		local sObj = SpectreAudio:GetObject()
		local sId = args[1]
		if #args > 0 and tonumber(sId) ~= nil then
			if sObj.SoundId ~= `rbxassetid://{sId}` then
				SpectreAudio:AssociateTrackChange(plr)
				sObj.SoundId = `rbxassetid://{sId}`
			else
				sObj:Play()
			end
		end
	end,
}
