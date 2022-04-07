local ServerStorage = game:GetService("ServerStorage")
local engageSDK = require(ServerStorage.EngageSDK.EngageSDKModule)

local Players = game:GetService("Players")

Players.PlayerAdded:Connect(
	engageSDK.addPlayer
)

Players.PlayerRemoving:Connect(
	engageSDK.removePlayer
)