local module = {}

local ServerStorage = game:GetService("ServerStorage")
local TeachSDKFolder = ServerStorage:WaitForChild("TeachSDK")
local TeachAPIWrapper = require(TeachSDKFolder:WaitForChild("TeachAPIWrapper"):Clone())
local CollectionService = game:GetService("CollectionService")

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
	TeachAPIWrapper.addPlayer(player)
end

function module.removePlayer(player)
	TeachAPIWrapper.removePlayer(player)
end

function module.getQuestion(playerId)

	-- Acquire new question information
	local questionInfo = TeachAPIWrapper.getQuestion(playerId)
	if questionInfo then

		-- Shuffle options
		local newQuestionInfo = shuffleOptions(questionInfo)
		return newQuestionInfo

	end

end

function module.leaveResponse(playerId, instanceId, response, correct, startedAt, answeredAt)
	TeachAPIWrapper.leaveResponse(playerId, instanceId, response, correct, startedAt, answeredAt)
end

local function findQuestionComponents(obj)
	local components = {obj}
	for _, child in ipairs(obj:GetDescendants()) do
		if child:GetAttribute("TeachType") then
			table.insert(components, child)
		end
	end
	return components
end

function module.findZoneComponents(zoneNum, matchingAttributes)
	-- matchingAttribute - array of substrings to match in "TeachType" attribute

	-- Loop through all tags
	local tagName = "QuestionZone" .. zoneNum

	local zoneObjects = CollectionService:GetTagged(tagName)

	local foundObjects = {}

	for _, zoneObj in ipairs(zoneObjects) do
		local components = findQuestionComponents(zoneObj)

		for _, component in ipairs(components) do
			local TeachType = component:GetAttribute("TeachType")

			if TeachType then
				for _, attribute in ipairs(matchingAttributes) do
					if TeachType:match(attribute) then
						foundObjects[TeachType] = component
					end
				end
			end
		end
	end

	return foundObjects

end

function module.registerGame(code, developerId, developerName)
	return TeachAPIWrapper.registerGame(code, developerId, developerName)
end


return module
