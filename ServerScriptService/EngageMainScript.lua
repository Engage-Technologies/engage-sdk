local ServerStorage = game:GetService("ServerStorage")
local engageSDK = require(ServerStorage.EngageSDK.EngageSDKModule)
local EngageEvents = ServerStorage.EngageSDK.Events

-- Oh! We should tag every script and add an attribute that indicates what question & option it is
-- then our plugin can loop through and check for errors -- where we've duplicated something twice, etc


-- Listen to events on the GetQuestion Topic
local function getQuestion(zone_number, player_id)
	
	-- Acquire new question information
	local question_info = engageSDK.getQuestion(player_id)
	
	-- Publish the topic as a new event to be received by all display
	
	local eventName = "EngageEventZone_" .. zone_number
	local event = EngageEvents:FindFirstChild(eventName)
	event:Fire(question_info)
	print("Fired!")
	
end


getQuestion(1, 3235295467)

--wait(3)
--print("leaving a response")
--engageSDK.leaveResponse(3235295467, 1, "a", true, nil, nil)

-- engageSDK.postResponse()