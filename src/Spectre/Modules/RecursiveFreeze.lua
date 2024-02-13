local function DeepFreeze(tabl)
	table.freeze(tabl)

	for k, v in pairs(tabl) do
		if typeof(v) == "table" and not table.isfrozen(v) then
			DeepFreeze(v)
		end
	end

end

return DeepFreeze
