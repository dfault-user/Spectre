-- TODO beta-1
TeleportService 	= {}
Players 			= game:GetService("Players")
RealTeleportService = game:GetService("TeleportService")

function TeleportService:ShiftPlayers(player1: Player, player2: Player)
    local player1Character = workspace[`{player1.Name}`]
	local player2Character = workspace[`{player2.Name}`]
    local player1CFrame = player1Character["HumanoidRootPart"].CFrame
	local player2CFrame = player2Character["HumanoidRootPart"].CFrame
	
	player1CFrame = player2CFrame
end

function TeleportService:WarpToPlace(placeId: number, Player: Player)
	if Player and placeId then 
		local Teleport = RealTeleportService:TeleportAsync(placeId, {Player})
	end
end

TeleportService.API = {
	ShiftPlayers = TeleportService.ShiftPlayers,
	WarpToPlace = TeleportService.WarpToPlace()
}

return TeleportService
