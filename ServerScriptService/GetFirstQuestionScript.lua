local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local engageSDKFolder = ServerStorage:FindFirstChild("EngageSDK")
local eventsFolder = engageSDKFolder:FindFirstChild("Events")
local newQuestionEvent = eventsFolder:FindFirstChild("NewQuestion")

Players.PlayerAdded:Connect(function(player)
	newQuestionEvent:Fire(1, player.UserId)
end
)