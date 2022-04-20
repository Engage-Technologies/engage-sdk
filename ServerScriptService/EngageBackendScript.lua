local ServerStorage = game:GetService("ServerStorage")
local engageSDK = require(ServerStorage.EngageSDK.EngageSDKModule)
local engageSurfaceUpdater = require(ServerStorage.EngageSDK.SurfaceModule)
local CollectionService = game:GetService("CollectionService")
local numQuestionZones = script:GetAttribute("EngageZones")

-- Updating Question From External Source
local engageSDKFolder = ServerStorage:FindFirstChild("EngageSDK")
local eventsFolder = engageSDKFolder:FindFirstChild("Events")
local newQuestionEvent = eventsFolder:FindFirstChild("NewQuestion")

-- Zone Information
local questionZoneInfo = {}

-- MACROS
local PULL_QUESTIONS_IN_ADVANCE = 2
local RESPONSE_TRANSPARENCY = 0.5 -- Needs to be increment of 0.1 or else float comparison doens't work

-- Add joining of players
local Players = game:GetService("Players")
Players.PlayerAdded:Connect(
	engageSDK.addPlayer
)

Players.PlayerRemoving:Connect(
	engageSDK.removePlayer
)

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
	local zoneComponents = engageSDK.findZoneComponents(zoneNum, {"question", "option"})

	-- Update the surfaces	
	for key, value in pairs(zoneComponents) do
		engageSurfaceUpdater.updateSurface(value, questionZoneInfo[zoneNum][key])
	end

end

local function changeObjectColor(obj, correct)
	if obj.Transparency == 1 then
		obj.Transparency = RESPONSE_TRANSPARENCY
	end
	
	local priorColor = obj.Color
	if correct then
		obj.Color = Color3.fromRGB(0, 255, 0)
	else
		obj.Color = Color3.fromRGB(255, 0, 0)
	end
	return priorColor
end

local function unchangeObjectColor(obj, priorColor)
	obj.Color = priorColor
	print(obj.Transparency)
	if obj.Transparency == RESPONSE_TRANSPARENCY then
		obj.Transparency = 1
	end
end

-- Connect to the New Question Event
newQuestionEvent.Event:Connect(updateQuestionZone)

-- Add Responses
for zoneNum = 1, numQuestionZones do

	local zoneObjects = engageSDK.findZoneComponents(zoneNum, {"response"})
	-- Handle responses
	for key, responseObj in pairs(zoneObjects) do

		local db = true -- does this variable get replicated OR need to be a global table?

		local response = responseObj:GetAttribute("EngageType")
		local option = "option"..tostring( response:sub(-1, -1) )

		local function touched(touchedPart)
			local partParent = touchedPart.Parent
			-- Look for a humanoid in the parent
			local humanoid = partParent:FindFirstChildWhichIsA("Humanoid")
			if humanoid and db and humanoid.Health > 0 then
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
				
				local priorColor = changeObjectColor(responseObj, correct)

				local player = Players:GetPlayerFromCharacter(humanoid.Parent)
				local instanceId = questionZoneInfo[zoneNum]["question_instance_id"]

				engageSDK.leaveResponse(player.UserId, instanceId, response, correct, nil, nil)

				-- update the next question
				if correct then
					updateQuestionZone(zoneNum + PULL_QUESTIONS_IN_ADVANCE, player.UserId)
				end

				wait(2)
				unchangeObjectColor(responseObj, priorColor)
				db = true
			end

		end

		responseObj.Touched:Connect(touched)
	end
end
