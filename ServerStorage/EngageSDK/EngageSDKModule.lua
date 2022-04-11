local module = {}

local engageSDKFolder = script.Parent
local engageAPIWrapper = require(engageSDKFolder.EngageAPIWrapper)

function module.extractQuestionInfo(_type, option_num, message)
	local relevantTable
	if _type == "option" then
		return message["options"][option_num]
	end
	return message[_type]
	
end

local function shuffleOptions(questionInfo)
	-- Put the options and answer in a list and mix

	local answer = questionInfo["answer"]
	answer["isAnswer"] = true -- mark this option as the answer
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
	
	local newQuestionInfo = {
		["question_instance_id"] = questionInfo["question_instance_id"],
		["response_type"] = questionInfo["response_type"],
		["question"] = questionInfo["question"],
	}

	local optionsShuffled = shuffleArray(options)
	for i, value in ipairs(optionsShuffled) do
		newQuestionInfo["option" .. i] = value
	end

	return newQuestionInfo
end

-- Module functions
function module.addPlayer(player)
	engageAPIWrapper.addPlayer(player)
end

function module.removePlayer(player)
	engageAPIWrapper.addPlayer(player)
end

function module.getQuestion(playerId)

	-- Acquire new question information
	local questionInfo = engageAPIWrapper.getQuestion(playerId)
	if questionInfo then
		
		-- Shuffle options
		local newQuestionInfo = shuffleOptions(questionInfo)
		return newQuestionInfo
		
	end
	
end

function module.leaveResponse(playerId, instanceId, response, correct, startedAt, answeredAt)
	engageAPIWrapper.leaveResponse(playerId, instanceId, response, correct, startedAt, answeredAt)
end

return module
