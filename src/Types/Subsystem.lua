--!strict

local Subsystem = {}
Subsystem.__index = Subsystem

export type Class = typeof(
	setmetatable({} :: {
	Name: string,
    Module: ModuleScript
}, Subsystem)
)

function Subsystem.new(Name: string, Module: ModuleScript)
	return setmetatable({
		Name = Name,
		Module = require(Module)
	}, Subsystem)
end

return Subsystem