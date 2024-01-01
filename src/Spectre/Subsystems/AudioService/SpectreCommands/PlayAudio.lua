local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")
local Spectre = ServerScriptService["Spectre"]
local SpectreAudio = require(script.Parent.Parent)
local Modules = {}

local MessageService = require(Spectre["Subsystems"]["MessageService"])

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
		
		local asset
		
		if #args > 0 and tonumber(args[1])~=nil then
			asset = MarketplaceService:GetProductInfo(tonumber(args[1]),Enum.InfoType.Asset)
			
			sObj.SoundId = `rbxassetid://{args[1]}`
			
			MessageService:PushMessage({
				MessagePresentation = "Hint",
				MessageType = "Standard",
				String = `Now playing {asset.Name} ({args[1]})`
			}, plr)
			
			sObj:Play()
			
		end
	end,
}