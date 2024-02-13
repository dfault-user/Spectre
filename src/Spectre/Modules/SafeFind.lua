local function SafeFind(instance: Instance, find: string, classname: string)
	local FindSuccess, FindResult = pcall(function()
		local FindFirstChild = instance:FindFirstChild(find)
		
		if FindFirstChild then 
			if classname~=nil and instance:IsA(classname) then
				return FindFirstChild
			else
				return FindFirstChild
			end
		else
			return false
		end
	end)
	
	if FindSuccess and FindResult then
		return FindResult
	else
		warn("[SafeFind] Can't find requested child, dropping")
		return false
	end
end

return SafeFind