local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = script.Parent
local LogService = require(Spectre:WaitForChild("Subsystems"):WaitForChild("LogService"))
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(plr)
	local Character = plr.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild("Humanoid")
	Humanoid.StateChanged:Connect(function(old: Enum.HumanoidStateType, new: Enum.HumanoidStateType)
		LogService:Push("HumanoidState",{
			OldState = old.Name,
			NewState = new.Name
		})
	end)
end)

-- this is a test