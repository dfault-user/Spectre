local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]

BanList = {
	Bans = require(Spectre["Settings"]).Banned,
}

function BanList:Add(Player: Player)
	local UserId = Player.UserId

	if table.find(BanList.Bans, `{Player}:{UserId}`) then
		warn("Player already banned, silently dropping request")
		return true
	else
		table.insert(BanList.Bans, `{Player}:{UserId}`)
		return true
	end
end

function BanList:IsBanned(Player: Player)
	local UserId = Player.UserId

	if UserId ~= game.CreatorId then
		if table.find(BanList.Bans, `{Player}:{UserId}`) then
			return true
		else
			return false
		end
	else
		warn("Player is game creator, silently dropping")
	end
end

return BanList
