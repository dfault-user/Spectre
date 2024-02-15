local function PartialMatch(str:string)
	for _, player in ipairs(game.Players:GetPlayers()) do
		if string.match(player.Name:lower(), "^" .. str:lower()) then return player end
	end
end

return PartialMatch