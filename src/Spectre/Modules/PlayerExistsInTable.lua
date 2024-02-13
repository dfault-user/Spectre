return function(plr: Player, tbl: {})
	local exists = false

	for i, v in pairs(tbl) do
		if v == plr.Name then exists = true end
	end

	return exists
end
