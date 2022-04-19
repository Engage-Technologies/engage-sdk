local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local engageSDKFolder = ServerStorage:FindFirstChild("EngageSDK")
local eventsFolder = engageSDKFolder:FindFirstChild("Events")
local newQuestionEvent = eventsFolder:FindFirstChild("NewQuestion")

-- Pull first 2 questions
Players.PlayerAdded:Connect(function(player)
	newQuestionEvent:Fire(1, player.UserId)
	newQuestionEvent:Fire(2, player.UserId) 
end
)