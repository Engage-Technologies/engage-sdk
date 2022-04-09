local ServerStorage = game:GetService("ServerStorage")
local engageSDK = require(ServerStorage.EngageSDK.EngageSDKModule)
local engageSurfaceUpdater = require(ServerStorage.EngageSDK.SurfaceModule)
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

-- Add Responses
local numTags = script:GetAttribute("EngageNumTags")
for zoneNum = 1, numTags do
	
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
				
				local response = questionZoneInfo[zoneNum][option]
				
				if response["isAnswer"] then
					print("You chose correctly!")
				else
					print("Wrong!")
				end				
				
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
	
	-- Pull the new question
	questionZoneInfo[zoneNum] = engageSDK.getQuestion(playerId)
	
	-- Find the question and option zone components
	local zoneComponents = findZoneComponents(zoneNum, {"question", "option"})
	
	-- Update the surfaces	
	for key, value in pairs(zoneComponents) do
		engageSurfaceUpdater.updateSurface(value, questionZoneInfo[zoneNum][key])
	end
	
end

updateQuestionZone(1, 3235295467)