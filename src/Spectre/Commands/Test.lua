local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]
local Modules = {}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

return {
	RoleLevel = 0,
	Description = "Test command",
	HookIdent = "TST",
	Aliases = {
		"test",
		"tst"	
	},

	Exec = function(plr, ...) print(...) end,
}