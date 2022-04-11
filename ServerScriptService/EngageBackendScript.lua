local ServerStorage = game:GetService("ServerStorage")
local engageSDK = require(ServerStorage.EngageSDK.EngageSDKModule)
local engageSurfaceUpdater = require(ServerStorage.EngageSDK.SurfaceModule)
local CollectionService = game:GetService("CollectionService")
local numQuestionZones = script:GetAttribute("EngageNumZones")

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

local function findZoneComponents(zoneNum, matchingAttributes)
	-- matchingAttribute - array of substrings to match in "EngageType" attribute
	
	-- Loop through all tags
	local tagName = "QuestionZone" .. zoneNum

	local zoneObjects = CollectionService:GetTagged(tagName)
	
	local foundObjects = {}

	for _, zoneObj in ipairs(zoneObjects) do
		local components = findQuestionComponents(zoneObj)

		for _, component in ipairs(components) do
			local engageType = component:GetAttribute("EngageType")
			
			if engageType then
				for _, attribute in ipairs(matchingAttributes) do
					if engageType:match(attribute) then
						foundObjects[engageType] = component
					end
				end
			end
		end
	end
	
	return foundObjects
	
end

local function updateQuestionZone(zoneNum, playerId)
	-- Update question Zone
	
	if zoneNum > numQuestionZones then
		print("Cannot update zone: " .. tostring(zoneNum))
		return
	end

	-- Pull the new question
	questionZoneInfo[zoneNum] = engageSDK.getQuestion(playerId)
	
	-- Check for success in new question info
	if not questionZoneInfo[zoneNum] then
		return
	end

	-- Find the question and option zone components
	local zoneComponents = findZoneComponents(zoneNum, {"question", "option"})

	-- Update the surfaces	
	for key, value in pairs(zoneComponents) do
		engageSurfaceUpdater.updateSurface(value, questionZoneInfo[zoneNum][key])
	end

end

-- Add Responses
for zoneNum = 1, numQuestionZones do
	
	local zoneObjects = findZoneComponents(zoneNum, {"response"})
	
	-- Handle responses
	for key, responseObj in pairs(zoneObjects) do
		
		local db = true -- does this variable get replicated OR need to be a global table?
		
		local response = responseObj:GetAttribute("EngageType")
		local option = "option"..tostring( response:sub(-1, -1) )
		
		local function touched(touchedPart)
			local partParent = touchedPart.Parent
			-- Look for a humanoid in the parent
			local humanoid = partParent:FindFirstChildWhichIsA("Humanoid")
			if humanoid and db then
				db = false
				
				print("Zone " .. zoneNum .. ". You selected: " .. option)
				
				if not questionZoneInfo[zoneNum] then
					print("Question " .. tostring(zoneNum) .. " was never updated")
					return
				end
				local response = questionZoneInfo[zoneNum][option]
				
				local correct
				if response["isAnswer"] then
					correct = true
				else
					correct = false
					humanoid.Health = 0
				end
				
				local player = Players:GetPlayerFromCharacter(humanoid.Parent)
				local instanceId = questionZoneInfo[zoneNum]["question_instance_id"]
				
				engageSDK.leaveResponse(player.UserId, instanceId, response, correct, nil, nil)
				
				-- update the next question
				if correct then
					updateQuestionZone(zoneNum + 1, player.UserId)
				end
				
				wait(3)
				db = true
			end
			
		end
		
		responseObj.Touched:Connect(touched)
	end
end

updateQuestionZone(1, 3235295467)