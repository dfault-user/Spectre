local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")
local Spectre = ServerScriptService["Spectre"]
local Modules = {}
local Subsystems = {
	LogService = require(Spectre["Subsystems"]["LogService"]),
}
for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

-- Typedefs
type ModerationAction = {
	Type: "Kick" | "Ban",
	Reason: string,
	ActioningUser: Player,
	OffendingUser: Player,
}

-- Subsystem
local ModService = {
	BanList = require(script["BanList"]),
}

local LogService = Subsystems["LogService"]

-- Funcdefs

function ModService:BanAPIEnabled()
	return Players.BanningEnabled
end

function ModService:Action(ModerationAction: ModerationAction)
	local ActionType = ModerationAction.Type
	local ActioningUser = ModerationAction.ActioningUser
	local OffendingUser = ModerationAction.OffendingUser
	local Reason = ModerationAction.Reason

	if OffendingUser.UserId == game.CreatorId then
		return false -- silently fail
	end

	if ActionType == "Kick" then
		OffendingUser:Kick(`[Spectre] Kicked for: {Reason}`)
	elseif ActionType == "Ban" then
		if ModService:BanAPIEnabled() then
			Players:BanAsync({
				UsersIds = {OffendingUser.UserId},
				PrivateReason = `[Spectre] Banned for: {Reason}`,
				DisplayReason = `[Spectre] Banned for: {Reason}`,
			})
		else
			ModService.BanList:Add(OffendingUser)
			OffendingUser:Kick(`[Spectre] Banned for: {Reason}`)
		end
	end

	Players.PlayerRemoving:Once(function(Player: Player)
		if Player == OffendingUser then
			LogService:Push("ModService", {
				ActionType = ActionType,
				Reason = Reason,
				ActioningUser = `{ActioningUser}`,
				OffendingUser = `{OffendingUser}`,
			})
		end
	end)
end

-- Watchdogs
function ModService.PlayerAdded(AddingPlayer: Player)
	local isBanned = ModService.BanList:IsBanned(AddingPlayer)
	if isBanned then
		Players.PlayerRemoving:Once(function(RemovingPlayer: Player)
			if RemovingPlayer == AddingPlayer then
				LogService:Push("ModService", {
					ActionType = "Ban",
					Reason = "Banned",
					ActioningUser = "Server",
					OffendingUser = `{RemovingPlayer}`,
				})
			end
		end)
		AddingPlayer:Kick(`[Spectre] Banned from server.`)
	end
end

Players.PlayerAdded:Connect(ModService.PlayerAdded)

Subsystems.LogService:Push("Spectre", {
	Origin = "ModService",
	Ready = true,
})

-- End bit
return ModService
