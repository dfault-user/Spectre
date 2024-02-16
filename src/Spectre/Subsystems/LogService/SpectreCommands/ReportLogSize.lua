local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]
local Subsystem = require(script.Parent.Parent)
local Modules = {}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

return {
	RoleLevel = 4,
	Description = "Report LogSize",
	HookIdent = "RLS",
	Aliases = {
		"logsize",
	},

	Exec = function(plr, ...)
		local Size = Subsystem:GetSize()
		print(Size)
		return Size
	end,
}
