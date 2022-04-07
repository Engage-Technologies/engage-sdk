local module = {}

local HttpService = game:GetService("HttpService")
local ENGAGE_URL = "http://127.0.0.1:5001/gameplay/"

local function getRequest(url)
	local response = HttpService:RequestAsync(
		{
			Url = url,
			Method = "GET"
		}
	)

	return {response.StatusCode, response.Body}
end

local function postRequest(url, bodyDict)
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

function module.getQuestion(player_id)
	
	local url = ENGAGE_URL .. "questions/" .. game.GameId .. "/" .. player_id

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
	end
	
	return nil
	
end

return module