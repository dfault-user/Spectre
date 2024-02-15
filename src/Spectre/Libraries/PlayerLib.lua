local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]
local Modules = {}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

local PlayerLib = {
	RequiringObject = nil,
}

function PlayerLib:CheckAccess(CurrentAccessTable: {
	['Owner']: {}, ['Administrator']: {}, ['Moderator']: {}, ['VIP']: {}
	}, Player: Player)
	
	if CurrentAccessTable then
		for AccessDict, PlayersInDict  in pairs(CurrentAccessTable) do
			local PlayerHasAccess = (table.find(PlayersInDict, `{Player}.{Player.UserId}`) ~= nil)
			
			if PlayerHasAccess then
			return {
				HasAccess = PlayerHasAccess, 
				AccessLevel = `{AccessDict}`
			}
			else 
				return false
			end
		end
	end
	
end

return function(RequiringObject: LuaSourceContainer)
    return PlayerLib
end