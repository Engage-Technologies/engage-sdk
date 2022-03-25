local Players = game:GetService("Players")

local HttpService = game:GetService("HttpService")
local ENGAGE_URL = "http://127.0.0.1:5002/gameplay/"

local function request(url, bodyDict)
	local response = HttpService:RequestAsync(
		{
			Url = url,  -- This website helps debug HTTP requests
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json"  -- When sending JSON, set this!
			},
			Body = HttpService:JSONEncode(bodyDict)
		}
	)
	
	return {response.Body, response.Body}
end

Players.PlayerAdded:Connect(function(player)
	
	local playerId = player.UserId
	local gameId = game.GameId
	local joinURL = ENGAGE_URL .. "join/" .. gameId .. "/" .. playerId
	
	local function playerAdd()
		request(joinURL, {})
	end
	
	
	local success, message = pcall(playerAdd)
	print(success)
	print(message)
	
	return true
end)