local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local MarketplaceService = game:GetService("MarketplaceService")
local Spectre = ServerScriptService["Spectre"]
local MessageService = require(Spectre["Subsystems"]["MessageService"])
local Modules = {
}
local Subsystems = {
	LogService = require(Spectre["Subsystems"]["LogService"]),
}

local SpectreAudio = {}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

Subsystems.LogService:Push("Spectre", {
	Origin = "AudioService",
	Ready = true,
})

if not workspace:FindFirstChild("SpectreAudio") then
	local sObj = Instance.new("Sound", workspace)
	sObj.Name = "SpectreAudio"

	SpectreAudio["Speaker"] = sObj
	SpectreAudio["SpeakerIdChanged"] = sObj:GetPropertyChangedSignal("SoundId")

	SpectreAudio["SpeakerIdChanged"]:Connect(function()
		sObj:Play()
	end)
end

function SpectreAudio:AssociateTrackChange(Source: Player | string)
	local sObj = SpectreAudio.Speaker
	local sTag = Modules.SafeFind(sObj, "Source")

	if 
		type(Source) == "userdata" and Source:IsA("Player")
	then
		sTag.Value = `plr.{Source :: string}`
	else
		sTag.Value = `cus.{Source:: string}`
	end

	return sTag
end

function SpectreAudio:GetObject()
	if SpectreAudio.Speaker then
		return SpectreAudio.Speaker
	else
		return false
	end
end

SpectreAudio.API = {
	GetObject = SpectreAudio.GetObject,
}

return SpectreAudio
