local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]
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
end

function SpectreAudio:GetObject()
	if SpectreAudio.Speaker ~= nil then
		return SpectreAudio.Speaker
	else 
		return false
	end
end

return SpectreAudio


