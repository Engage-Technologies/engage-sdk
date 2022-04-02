local Players = game:GetService("Players")

local HttpService = game:GetService("HttpService")
local ENGAGE_URL = "http://127.0.0.1:5002/"

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
	
	return {response.StatusCode, response.Body}
end

Players.PlayerAdded:Connect(function(player)
	
	local url = ENGAGE_URL .. "join/" .. game.GameId
	
	local bodyDict = {
		["player_id"] = player.UserId,
		["player_name"] = player.Name
	}
	
	local resp
	
	local function playerAdd()
		resp = request(url, bodyDict)
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

	local url = ENGAGE_URL .. "leave/" .. game.GameId

	local bodyDict = {
		["player_id"] = player.UserId
	}

	local resp

	local function playerAdd()
		resp = request(url, bodyDict)
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