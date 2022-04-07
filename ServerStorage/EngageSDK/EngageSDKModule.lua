local module = {}

local HttpService = game:GetService("HttpService")
local ENGAGE_URL = "http://127.0.0.1:5001/gameplay/"

local function getRequest(uri_extension)
	local response = HttpService:RequestAsync(
		{
			Url = ENGAGE_URL .. uri_extension,
			Method = "GET"
		}
	)

	return {response.StatusCode, response.Body}
end

local function postRequest(uri_extension, bodyDict)
	local response = HttpService:RequestAsync(
		{
			Url = ENGAGE_URL .. uri_extension,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json"  -- When sending JSON, set this!
			},
			Body = HttpService:JSONEncode(bodyDict)
		}
	)

	return {response.StatusCode, response.Body}
end

function module.addPlayer(player)

	local url = "join/" .. game.GameId

	local bodyDict = {
		["player_id"] = player.UserId,
		["player_name"] = player.Name
	}

	local resp

	local function postRequestWrapper()
		resp = postRequest(url, bodyDict)
	end

	local success, message = pcall(postRequestWrapper)

	if success then
		local status = resp[1]
		if status == 204 then
			return true
		end
	else
		print(message)
	end

	return nil
end

function module.removePlayer(player)

	local url = "leave/" .. game.GameId

	local bodyDict = {
		["player_id"] = player.UserId
	}

	local resp

	local function postRequestWrapper()
		resp = postRequest(url, bodyDict)
	end

	local success, message = pcall(postRequestWrapper)

	if success then
		local status = resp[1]
		if status == 204 then
			return true
		end
	else
		print(message)
	end

	return nil
end

function module.getQuestion(player_id)
	
	local url = "questions/" .. game.GameId .. "/" .. player_id

	local resp

	local function getRequestWrapper()
		resp = getRequest(url)
	end

	local success, message = pcall(getRequestWrapper)

	if success then
		local status = resp[1]
		local msg = resp[2]
		if status == 200 then
			return msg
		end
	else
		print(message)
	end
	
	return nil
	
end

function module.leaveResponse(player_id, instace_id, response, correct, started_at, answered_at)

	local url = "responses/" .. game.GameId .. "/" .. player_id

	local bodyDict = {
		["player_id"] = player_id,
		["question_instance_id"] = instace_id,
		["response"] = response,
		["correct"] = correct
	}
	if started_at then
		bodyDict["started_at"] = started_at
	end
	if answered_at then
		bodyDict["answered_at"] = answered_at
	end

	local resp

	local function postRequestWrapper()
		resp = postRequest(url, bodyDict)
	end

	local success, message = pcall(postRequestWrapper)

	if success then
		local status = resp[1]
		if status == 204 then
			return true
		end
	else
		print(message)
	end

	return nil

end

return module
