local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")
local Spectre = ServerScriptService["Spectre"]
local Modules = {}
local Subsystems = {
	LogService = require(Spectre["Subsystems"]["LogService"]),
}

for i, v in pairs(Spectre["Modules"]:GetChildren()) do
	Modules[v.Name] = require(v)
end

Modules.Output("MessageService", "Waking up..")

-- Typedefs
type MessageObject = {
	MessagePresentation: "Message" | "Hint",
	MessageType: "Standard" | "System",
	String: string,
}

-- Subsystem
local Announcements = {
	IncomingMessages = {},
}

setmetatable(Announcements.IncomingMessages, {
	__newindex = function(
		_,
		_,
		IncMsg: {
			Object: MessageObject,
			Player: Player,
		}
	)
		local MessageObject = IncMsg.Object
		local LogService = Subsystems["LogService"]
		local Player = IncMsg.Player :: Player
		local NewMsg = Instance.new(MessageObject.MessagePresentation)
		local String = ""

		if MessageObject.MessageType == "Standard" and Player then
			String = `[Spectre] {Player}: {MessageObject.String}`
		elseif MessageObject.MessageType == "System" then
			String = `[Spectre] {MessageObject.String}`
		end

		LogService:Push("Messages", {
			Player = `{Player}`,
			MessageType = MessageObject.MessageType,
			Message = MessageObject.String,
		})

		NewMsg.Text = String
		NewMsg.Parent = workspace

		delay(5, function()
			NewMsg:Destroy()
		end)
	end,
})

-- Funcdefs
function Announcements:PushMessage(MessageObject: MessageObject, Player: Player) -- Optional Player for black magic
	Announcements.IncomingMessages[1] = {
		Object = MessageObject,
		Player = Player,
	}
end

return Announcements
