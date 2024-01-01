local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")
local Spectre = ServerScriptService["Spectre"]
local MessageService = require(Spectre["Subsystems"]["MessageService"])
local Modules = {}
local SpectreAudio = {}

for i,v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

Modules.Output(`{script.Name}`,"Waking up..")

if not workspace:FindFirstChild("SpectreAudio") then
	local sObj = Instance.new("Sound")
	sObj.Name = "SpectreAudio"
	sObj.Parent = workspace
	SpectreAudio["Speaker"] = sObj

	sObj:GetPropertyChangedSignal("SoundId"):Connect(function()
		sObj:Stop()
		wait(.1)
		sObj:Play()
	end)
end

function SpectreAudio:GetObject()
	if SpectreAudio.Speaker ~= nil then
		return SpectreAudio.Speaker
	else 
		return false
	end
end

return SpectreAudio


