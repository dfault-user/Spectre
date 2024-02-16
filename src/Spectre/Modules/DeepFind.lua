local function DeepFind(t, key_to_find)
	for key, value in pairs(t) do
		if value == key_to_find then
			return true
		end
			if typeof(value) == "table" then
				return DeepFind(value, key_to_find)
			end
		end
		return false
	end

return DeepFind