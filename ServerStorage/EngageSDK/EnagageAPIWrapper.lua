local module = {}

local HttpService = game:GetService("HttpService")

local ENGAGE_URL = " https://engageteach.herokuapp.com/gameplay/"
--local ENGAGE_URL = " http://localhost:5001/gameplay/"

local apiKey = script:GetAttribute("apiKey")
if apiKey == nil then
	print("[ERROR] API KEY IS NOT SET!")
end

local function testHttpEnabled()
	-- Ping a website to test if HTTP is enabled

	local success, message = pcall(function()
		HttpService:GetAsync("https://httpbin.org/")
	end)
	return success
end

local function parseBody(httpBody)
	if httpBody ~= "" then
		return HttpService:JSONDecode(httpBody) 
	end
	return nil
end

local function getRequest(uri_extension)
	local response = HttpService:RequestAsync(
		{
			Url = ENGAGE_URL .. uri_extension,
			Method = "GET",
			Headers = {
				["Authorization"] = "Bearer " .. apiKey
			}
		}
	)
	return {response.StatusCode, parseBody(response.Body)}
end

local function postRequest(uri_extension, bodyDict)
	local response = HttpService:RequestAsync(
		{
			Url = ENGAGE_URL .. uri_extension,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				["Authorization"] = "Bearer " .. apiKey
			},
			Body = HttpService:JSONEncode(bodyDict)
		}
	)
	return {response.StatusCode, parseBody(response.Body)}
end

local function putRequest(uri_extension, bodyDict, code)
	local response = HttpService:RequestAsync(
		{
			Url = ENGAGE_URL .. uri_extension,
			Method = "PUT",
			Headers = {
				["Content-Type"] = "application/json",
				["Authorization"] = "Bearer " .. code
			},
			Body = HttpService:JSONEncode(bodyDict)
		}
	)
	return {response.StatusCode, parseBody(response.Body)}
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
		print("Unable to connect to " .. ENGAGE_URL)
		print(resp)
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
		print("Unable to connect to " .. ENGAGE_URL)
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
		--else
		--	print(status)
		--	for key, value in pairs(msg) do
		--		print(key .. " " .. tostring(value))
		--	end
		--end
	else
		print("Unable to connect to " .. ENGAGE_URL)
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
		print("Unable to connect to " .. ENGAGE_URL)
	end

	return nil

end

function module.registerGame(code, developerId, developerName)

	local url = "register/" .. game.GameId

	local bodyDict = {
		["game_name"] = game.Name,
		["developer_id"] = developerId,
		["developer_name"] = developerName
	}

	local resp

	local function putRequestWrapper()
		resp = putRequest(url, bodyDict, code)
	end

	local success, message = pcall(putRequestWrapper)

	if success then
		local status = resp[1]
		if status == 204 then
			return true
		elseif status == 422 or status == 405 then
			print("[ERROR] API Key invalid")
		else
			print(tostring(message))
		end
	else
		print(message)
		local result = testHttpEnabled()
		if not result then
			print("[ERROR] HTTP is not enabled. Please enable in Game Settings to use the Teach Plugin & SDK.")
		else
			print("Teach Backend is down. Please wait a few minutes and try again.")
		end
	end

	return false
end

return module