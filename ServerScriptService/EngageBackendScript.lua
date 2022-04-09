local ServerStorage = game:GetService("ServerStorage")
local engageSDK = require(ServerStorage.EngageSDK.EngageSDKModule)
local CollectionService = game:GetService("CollectionService")

-- Zone Information
local questionZoneInfo = {}

-- Add joining of players
local Players = game:GetService("Players")
Players.PlayerAdded:Connect(
	engageSDK.addPlayer
)

Players.PlayerRemoving:Connect(
	engageSDK.removePlayer
)

local function findQuestionComponents(obj)
	local components = {}
	for _, child in ipairs(obj:GetDescendants()) do
		if child:GetAttribute("EngageType") then
			table.insert(components, child)
		end
	end
	return components
end

-- Add Responses
local numTags = script:GetAttribute("EngageNumTags")
for i = 1, numTags do
	-- Loop through all tags
	local tagName = "QuestionZone" .. i
	
	local zoneObjects = CollectionService:GetTagged(tagName)
	
	local foundObjects = {
		["response1"] = false,
		["response2"] = false,
		["response3"] = false
	}
	
	for _, zoneObj in ipairs(zoneObjects) do
		local components = findQuestionComponents(zoneObj)
		
		for _, component in ipairs(components) do
			local engageType = component:GetAttribute("EngageType")
			if engageType:match("response") then
				foundObjects[engageType] = component
			end
		end
	end
	
	for key, value in pairs(foundObjects) do
		print(key .. " : " .. value.Name)
	end
	
	-- Error check, make sure we have everything...
	
	-- Handle Question Zone
	questionZoneInfo[tagName] = {
		["question_instance_id"] = 1,
		["response_type"] = "", -- assume we'll support more than multiple choice but plan for it initially
		["option1"] = {}, -- mark one of these as the answer
		["option2"] = {},
		["option3"] = {}
	}
	
	-- Handle responses
	for key, responseObj in pairs(foundObjects) do
		
		local db = true -- does this variable get replicated OR need to be a global table?
		
		local option = responseObj:GetAttribute("EngageType")
		
		local function touched(touchedPart)
			local partParent = touchedPart.Parent
			-- Look for a humanoid in the parent
			local humanoid = partParent:FindFirstChildWhichIsA("Humanoid")
			if humanoid and db then
				db = false
				print("You selected " .. option)
				
				-- Check if correct
				--if questionZoneInfo[tagName][option]["isAnswer"] then
				--	print("You chose correctly!")
				--else
				--	print("Wrong answer!")
				--end
				
				-- 
				
				-- we could send the http request from here! That would be simpler...
				--module.leaveResponse(player_id, instace_id, response, correct, started_at, answered_at)
				
				
				
				wait(3)
				db = true
			end
			
		end
		
		responseObj.Touched:Connect(touched)
	end
end

local function updateQuestionZone(zoneNum, playerId)
	-- Update question Zone
	
	local tagName = "QuestionInstance" .. zoneNum
	
	-- Pull the new question
	questionZoneInfo[tagName] = engageSDK.getQuestion(playerId)
	
	--questionZoneInfo[tagName] = {
	--	["instance_id"] = 1,
	--	["response_type"] = "", -- assume we'll support more than multiple choice but plan for it initially
	--	["option1"] = {}, -- mark one of these as the answer
	--	["option2"] = {},
	--	["option3"] = {}
	--}
	for key, value in pairs(questionZoneInfo[tagName]) do
		print(key .. " : " .. tostring(value))
	end
	
	-- Loop through & update objects
end

updateQuestionZone(1, 3235295467)