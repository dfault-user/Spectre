-- TODO beta-1
TeleportService = {}

function TeleportService:ShiftPlayers(player1: Player, player2: Player)
    local player1Character = player1.Character
    local player2Character = player2.Character
    local player1CFrame = player1Character["HumanoidRootPart"].CFrame
    local player2CFrame = player2Character["HumanoidRootPart"].CFrame
end

TeleportService.API = {
    ShiftPlayers = TeleportService.ShiftPlayers
}

return TeleportService
