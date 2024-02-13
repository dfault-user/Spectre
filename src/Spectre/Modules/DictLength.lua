local function Length(Table)
	local i = 0
	for _, v in pairs(Table) do
		i+=1
	end
	return i
end

return Length
