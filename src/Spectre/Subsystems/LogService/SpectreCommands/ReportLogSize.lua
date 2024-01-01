local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]
local Subsystem = require(script.Parent.Parent)
local Modules = {}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

return {
	NonAdmin = true,
	Description = "Report LogSize",
	HookIdent = "RLS",
	Command = "logsize",

	Exec = function(plr, ...)
		local Size = Subsystem:GetSize()
		print(Size)
		return Size
	end,
}
