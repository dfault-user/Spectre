local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]
local Modules = {}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

local PlayerLib = {
	RequiringObject = nil,
}

function PlayerLib:CheckAccess(
	CurrentAccessTable, Player: Player
)
	local ReturnChannel = {
		Role = "Player",
		CommandLevel = 0
	}
	
	for CurRole,CurArray in pairs(CurrentAccessTable) do
		if table.find(CurArray.Grants, `{Player.Name}:{Player.UserId}`) then
			ReturnChannel = {
				Role = CurRole,
				CommandLevel = CurArray.CommandLevel
			}
		end
	end
	
	return ReturnChannel
end

return function(RequiringObject: LuaSourceContainer)
	PlayerLib.RequiringObject = RequiringObject
    return PlayerLib
end 