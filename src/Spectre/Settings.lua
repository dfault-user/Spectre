export type AccessLevel = "Player" | "VIP" | "Moderator" | "Administrator" | "Owner"
local Players = game:GetService("Players")
Settings = {
	Seperator = "/",

	AccessLevel = {
		Owner = {
			`{Players:GetNameFromUserIdAsync(game.CreatorId)}.{game.CreatorId}`, -- "Control22:18875912"
		},

		Administrator = {

		},

		Moderator = {

		},

		VIP = {
			
		}
	},

	Banned = {},
	Blacklist = {},
}

return Settings
-- ps
