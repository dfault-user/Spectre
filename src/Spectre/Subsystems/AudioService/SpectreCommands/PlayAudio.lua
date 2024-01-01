local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]
local SpectreAudio = require(script.Parent.Parent)
local Modules = {}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

return {
	NonAdmin = true,
	Description = "Play audio",
	HookIdent = "AUDP",
	Command = "aplay",

	Exec = function(plr, args)
		local sObj = SpectreAudio:GetObject()

		if #args > 0 and tonumber(args[1]) ~= nil then
			if sObj.SoundId ~= `rbxassetid://{args[1]}` then
				sObj.SoundId = `rbxassetid://{args[1]}`
			else
				sObj:Play()
			end
		end
	end,
}
