local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")
local Spectre = ServerScriptService["Spectre"]
local SpectreAudio = require(script.Parent.Parent)
local Modules = {}

for i,v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

return {
	NonAdmin = true,
	Description = "Play audio",
	HookIdent = "AUDP",
	Command = "aplay",

	Exec = function(plr,args)
		local sObj = SpectreAudio:GetObject()
		if #args > 0 then
			local asset = MarketplaceService:GetProductInfo()
		end
	end,
}