local PlayerLib = {
    SpectreSettings = require(script.Parent.Parent.Settings),
    RequiringObject = nil,
}

function PlayerLib:CheckAccess(Player: Player)
	
end

return function(Req: LuaSourceContainer)
    PlayerLib.RequiringObject = Req
    return PlayerLib
end