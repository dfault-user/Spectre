--!strict

local Command = {}
Command.__index = Command

export type Class = typeof(
	setmetatable({} :: {
	Aliases: {
		string
		},
	Description: string,
	
	Execute: (Player: Player, Arguments: {}) -> ()?,
}, Command)
)

function Command.new(Aliases: {string}, 
	Description: string, 
	Execute: (
		Player: Player, 
		Arguments: {}
	) -> ()
)
	return setmetatable({
		Aliases = Aliases,
		Description = Description,
		Execute = Execute
	}, Command)
end

return Command