local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]
local Modules = {}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end
-- this is a test
return {
	AccessLevel = "Player",
	Description = "Test command",
	HookIdent = "TST",
	Command = "test",

	Exec = function(plr, ...) print(...) end,
}
