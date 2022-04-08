-- Load the event this script listens for
local ServerStorage = game:GetService("ServerStorage")
local EngageEvents = ServerStorage.EngageSDK.Events
local question_type = script:GetAttribute("type")
local zone = script:GetAttribute("zone")
local myEventName = "EngageEventZone_" .. zone
local myEvent = EngageEvents:FindFirstChild(myEventName)

local frame = script.Parent
local textLabel = frame.TextLabel

-- I should hollow out this script as much as I can...
-- Load as much of it as possible in a module script

myEvent.Event:Connect(function(message)
	print(myEventName .. " Received!")
	print(message)
	local relevantTable = message[question_type]
	if relevantTable["text"] then
		textLabel.Text = relevantTable["text"]
	end
	if relevantTable["audio"] then
		print("There's audio")
	end
	if relevantTable["image"] then
		print("There's an image")
	end
end)