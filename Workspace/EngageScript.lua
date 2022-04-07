-- Load the event this script listens for
local ServerStorage = game:GetService("ServerStorage")
local EngageEvents = ServerStorage.EngageSDK.Events
local question_type = script:GetAttribute("type")
local zone = script:GetAttribute("zone")
local myEventName = "EngageEventZone_" .. zone
local myEvent = EngageEvents:FindFirstChild(myEventName)

local frame = script.Parent
local textLabel = frame.TextLabel

myEvent.Event:Connect(function(message)
	print(myEventName .. " Received!")
	print(message)
end)