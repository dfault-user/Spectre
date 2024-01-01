local ServerScriptService = game:GetService("ServerScriptService")
local Spectre = ServerScriptService["Spectre"]
local Subsystem = require(script.Parent.Parent)
local Modules = {}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

return {
	NonAdmin = true, -- Is this command for admins or not?
	Description = "Make an example", -- This is currently unused, but will be later
	HookIdent = "EXM", -- All Spectre commands have a hook identifier
	Command = "exm", -- Actual command call

	Exec = function(plr, ...)
		local Size = Subsystem:Test(table.concat(..., " "))
		return Size
	end,
}
