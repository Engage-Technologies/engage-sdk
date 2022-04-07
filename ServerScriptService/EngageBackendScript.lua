local ServerStorage = game:GetService("ServerStorage")
local engageSDK = require(ServerStorage.EngageSDK.EngageSDKModule)

local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	
	local url = "join/" .. game.GameId
	
	local bodyDict = {
		["player_id"] = player.UserId,
		["player_name"] = player.Name
	}
	
	local resp
	
	local function playerAdd()
		resp = engageSDK.postRequest(url, bodyDict)
	end
	
	
	local success, message = pcall(playerAdd)
	
	if success then
		local status = resp[1]
		local msg = resp[2]
		print(status)
		print(msg)
	end
	
	
	return true
end)

Players.PlayerRemoving:Connect(function(player)

	local url = "leave/" .. game.GameId

	local bodyDict = {
		["player_id"] = player.UserId
	}

	local resp

	local function playerAdd()
		resp = engageSDK.postRequest(url, bodyDict)
	end


	local success, message = pcall(playerAdd)

	if success then
		local status = resp[1]
		local msg = resp[2]
		print(status)
		print(msg)
	end


	return true
end)