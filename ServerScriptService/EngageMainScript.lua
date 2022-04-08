local ServerStorage = game:GetService("ServerStorage")
local engageSDK = require(ServerStorage.EngageSDK.EngageSDKModule)
local EngageEvents = ServerStorage.EngageSDK.Events

-- Oh! We should tag every script and add an attribute that indicates what question & option it is
-- then our plugin can loop through and check for errors -- where we've duplicated something twice, etc

local function shuffleOptions(questionInfo)
	-- Put the options and answer in a list and mix
	
	local answer = questionInfo["answer"]
	answer["is_answer"] = true -- mark this option as the answer
	local options = {answer}
	
	for key, value in pairs(questionInfo["options"]) do
		table.insert(options, value)
	end
	
	
	local function shuffleArray(arr)
		-- https://devforum.roblox.com/t/an-efficient-way-to-randomize-a-list-of-maps-or-items/223583/3
		local arrCopy = {unpack(arr)} -- # making copy of arr

		for i = 1, #arr do
			arr[i] = table.remove(arrCopy, math.random(#arrCopy))
		end
		return arr -- # arr has been shuffled, return back for convenience
	end
	
	local optionsShuffled = shuffleArray(options)
	questionInfo["options"] = optionsShuffled
	
	return questionInfo
end

-- Listen to events on the GetQuestion Topic
local function getQuestion(zone_number, player_id)
	
	-- Acquire new question information
	local questionInfo = engageSDK.getQuestion(player_id)
	local newQuestionInfo = shuffleOptions(questionInfo)
	
	-- Publish the topic as a new event to be received by all display
	
	local eventName = "EngageEventZone_" .. zone_number
	local event = EngageEvents:FindFirstChild(eventName)
	
	--event:Fire(newQuestionInfo)
	print("Fired!")
	
end


getQuestion(1, 3235295467)

--wait(3)
--print("leaving a response")
--engageSDK.leaveResponse(3235295467, 1, "a", true, nil, nil)

-- engageSDK.postResponse()