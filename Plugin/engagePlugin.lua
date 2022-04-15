-- Create a new toolbar section titled "Custom Script Tools"
local Selection = game:GetService("Selection")
local CollectionService = game:GetService("CollectionService")

local toolbar = plugin:CreateToolbar("Learn 1.0.0")

local newWidgetButton = toolbar:CreateButton("Learn", "Launch Roblox Learn Plugin", "rbxassetid://9341661015")
newWidgetButton.ClickableWhenViewportHidden = true

-- Create new "DockWidgetPluginGuiInfo" object
local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,  -- Widget will be initialized in floating panel
	false,   -- Widget will be initially enabled
	true,  -- Don't override the previous enabled state
	200,    -- Default width of the floating window
	300,    -- Default height of the floating window
	150,    -- Minimum width of the floating window
	150     -- Minimum height of the floating window
)

local learnWidget = plugin:CreateDockWidgetPluginGui("Roblox Learn Widget", widgetInfo)
learnWidget.Title = "Roblox Learn Widget"

local function onWidgetLaunch()
	learnWidget.Enabled = true	
end
newWidgetButton.Click:Connect(onWidgetLaunch)

local Plugin = PluginManager():CreatePlugin()
local apiKey = Plugin:GetSetting("apiKey")

local apiKeyFrame = Instance.new("Frame", learnWidget)
local questionFrame = Instance.new("Frame", learnWidget)
local installFrame = Instance.new("Frame", learnWidget)
local surfacePlacementFrame = Instance.new("Frame", learnWidget)

local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local engageSDK
local backendScript

-- Question Zone attributes
local zoneBox
local surfaceEditObject
local previousZoneNumber -- used by when modifying the textbox number

local function findMissingFiles()
	-- Check the EngageSDK and EngageBackendScript have been installed
	backendScript = ServerScriptService:FindFirstChild("EngageBackendScript")
	if not backendScript then
		return "ServerScriptService/EngageBackendScript"
	end
	local ServerStorage = game:GetService("ServerStorage")
	if not ServerStorage:FindFirstChild("EngageSDK") then
		return "ServerStorage/EngageSDK"
	end
	return nil
end

local function setVisibleFrame(frame)
	apiKeyFrame.Visible = false
	questionFrame.Visible = false
	installFrame.Visible = false
	surfacePlacementFrame.Visible = false
	
	if frame == "api" then
		apiKeyFrame.Visible = true
	elseif frame == "question" then
		questionFrame.Visible = true
	elseif frame == "surface" then
		surfacePlacementFrame.Visible = true
	else
		installFrame.Visible = true
	end
end

local function decideAvailableFrames()
	-- Decides which frames are available to run next
	
	-- Get the Engage API Code
	if not apiKeyFrame then
		setVisibleFrame("api")
	elseif findMissingFiles() then	
		setVisibleFrame("install")
	else
		engageSDK = require( ServerStorage.EngageSDK.EngageSDKModule )
		setVisibleFrame("question")
	end
end

local function getCurrentZoneNumber()
	return tonumber(zoneBox.Text)
end

local function setCurrentZoneNumber(zoneNumber)
	zoneBox.Text = tostring(zoneNumber)
	previousZoneNumber = zoneNumber
end

local function getMaxZoneNumber()
	return backendScript:GetAttribute("EngageZones")
end

local function incrementMaxZoneNumber()	
	local numZones = getMaxZoneNumber()
	local newNumZones = numZones + 1
	backendScript:SetAttribute("EngageZones", newNumZones)
	setCurrentZoneNumber(newNumZones)
	return newNumZones
end

local function buildApiKeyFrame()
	apiKeyFrame.Size = UDim2.new(1, 0, 1, 0)

	local websiteFrame = Instance.new("Frame", apiKeyFrame)
	websiteFrame.BorderSizePixel = 0
	websiteFrame.Position = UDim2.new(0, 0, 0.15, 0)
	websiteFrame.Size = UDim2.new(1, 0, 0.25, 0)
	websiteFrame.Visible = true

	-- Website Label
	local websiteLabel = Instance.new("TextLabel", websiteFrame)
	websiteLabel.BorderSizePixel = 0
	websiteLabel.Size = UDim2.new(1, 0, 0.6, 0)
	websiteLabel.Visible = true
	websiteLabel.TextScaled = true
	websiteLabel.Text = "RobloxLearn.com"

	-- Website Logo
	local motoLabel = Instance.new("TextLabel", websiteFrame)
	motoLabel.BorderSizePixel = 0
	motoLabel.Position = UDim2.new(0, 0, 0.6, 0)
	motoLabel.Size = UDim2.new(1, 0, 0.4, 0)
	motoLabel.Visible = true
	motoLabel.TextScaled = true
	motoLabel.Text = "Educational Rails for the Metaverse"

	-- API Key Box
	local apiKeyBox = Instance.new("TextBox", apiKeyFrame)
	apiKeyBox.AnchorPoint = Vector2.new(0.5, 0)
	apiKeyBox.Position = UDim2.new(0.5, 0, 0.5, 0)
	apiKeyBox.Size = UDim2.new(0.75, 0, 0.2, 0)
	apiKeyBox.PlaceholderText = "API Key"
	apiKeyBox.TextScaled = true
	apiKeyBox.Text = "API Key"

	local function onConnect()
		local code = apiKeyBox.Text

		-- Attempt to connect to backend
		if code ~= "" then
			print("Connecting with " .. code)
			apiKey = code
			Plugin:SetSetting("apiKey", apiKey)
			decideAvailableFrames()
		end
	end

	apiKeyBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			onConnect()
		else
			if apiKeyBox.Text == "" then
				apiKeyBox.Text = "API Key"
			end
		end
	end)
end

local function buildQuestionFrame()
	questionFrame.Size = UDim2.new(1, 0, 1, 0)

	local logoLabel = Instance.new("TextLabel", questionFrame)
	logoLabel.BorderSizePixel = 0
	logoLabel.Size = UDim2.new(1, 0, 0.15, 0)
	logoLabel.Text = "Roblox Learn"
	logoLabel.TextScaled = true

	local function buildZoneFrame()
		local zoneFrame = Instance.new("Frame", questionFrame)
		zoneFrame.Position = UDim2.new(0,0,0.15, 0)
		zoneFrame.Size = UDim2.new(1,0,0.25, 0)
		zoneFrame.BorderSizePixel = 0

		local zoneLabel = Instance.new("TextLabel", zoneFrame)
		zoneLabel.AnchorPoint = Vector2.new(0.5 ,0)
		zoneLabel.BorderSizePixel = 0
		zoneLabel.Position = UDim2.new(0.15, 0, 0, 0)
		zoneLabel.Size = UDim2.new(0.2, 0, 1, 0)
		zoneLabel.Text = "Zone"
		zoneLabel.TextScaled = true
		
		local function adjustSurfaceGuiZone(oldZone, newZone)
			local selection = Selection:Get()
			local oldTag = "QuestionZone" .. tostring(oldZone)
			for i, selected in ipairs(selection) do
				if CollectionService:HasTag(selected, oldTag) then
					CollectionService:RemoveTag(selected, oldTag)
					CollectionService:AddTag(selected, "QuestionZone" .. tostring(newZone))

					-- we need to refresh the text of any objects
					local surfaceGUI = selected:FindFirstChildWhichIsA("SurfaceGui")
					if surfaceGUI then
						for i, child in pairs(surfaceGUI:GetDescendants()) do
							if child:isA("TextLabel") then
								local newText, replaced = child.Text:gsub("z" ..tostring(oldZone), "z"..tostring(newZone))
								child.Text = newText
							end
						end
					end
				end
			end
		end

		zoneBox = Instance.new("TextBox", zoneFrame)
		zoneBox.AnchorPoint = Vector2.new(0.5 ,0)
		zoneBox.BorderSizePixel = 0
		zoneBox.Position = UDim2.new(0.35, 0, 0, 0)
		zoneBox.Size = UDim2.new(0.2, 0, 1, 0)
		zoneBox.Text = tostring(getMaxZoneNumber())
		zoneBox.PlaceholderText = "#"
		zoneBox.TextScaled = true
		-- TODO callback on changing the zone number..
		zoneBox.FocusLost:Connect(function(enterPressed)
			
			local newNum
			local success, errorMsg = pcall(function()
				newNum = tonumber(zoneBox.Text)
			end)
			
			if newNum > getMaxZoneNumber() then
				newNum = incrementMaxZoneNumber()
			end
			
			if newNum then
				adjustSurfaceGuiZone(previousZoneNumber, newNum)
			else
				setCurrentZoneNumber(newNum)
				print("[ERROR] Unable to convert input to a number")
			end
			
		end)

		local upZoneButton = Instance.new("ImageButton", zoneFrame)
		upZoneButton.AnchorPoint = Vector2.new(0.5, 0)
		upZoneButton.BorderSizePixel = 0
		upZoneButton.Position = UDim2.new(0.55, 0, 0, 0)
		upZoneButton.Size = UDim2.new(0.15, 0, 0.5, 0)
		upZoneButton.Image = "rbxassetid://29563813"
		
		upZoneButton.MouseButton1Click:Connect(function()
			-- Get the new zone number
			-- Check if it's less than the maxZoneNumber and increment
			local oldZoneNum = getCurrentZoneNumber()
			local newZoneNum = getCurrentZoneNumber() + 1
			if newZoneNum > getMaxZoneNumber() then
				incrementMaxZoneNumber()
			end
			setCurrentZoneNumber(newZoneNum)
			adjustSurfaceGuiZone(oldZoneNum, newZoneNum)
		end)

		local downZoneButton = Instance.new("ImageButton", zoneFrame)
		downZoneButton.AnchorPoint = Vector2.new(0.5, 0)
		downZoneButton.BorderSizePixel = 0
		downZoneButton.Position = UDim2.new(0.55, 0, 0.5, 0)
		downZoneButton.Rotation = 180
		downZoneButton.Size = UDim2.new(0.15, 0, 0.5, 0)
		downZoneButton.Image = "rbxassetid://29563813"
		
		downZoneButton.MouseButton1Click:Connect(function()
			local oldZoneNum = getCurrentZoneNumber()
			local newZoneNum = math.max( getCurrentZoneNumber() - 1, 1)
			setCurrentZoneNumber(newZoneNum)
			adjustSurfaceGuiZone(oldZoneNum, newZoneNum)
		end)

		--local newZoneButton = Instance.new("ImageButton", zoneFrame)
		--newZoneButton.BorderSizePixel = 0
		--newZoneButton.AnchorPoint = Vector2.new(0.5, 0.5)
		--newZoneButton.Position = UDim2.new(0.625, 0, 0.5, 0)
		--newZoneButton.Size = UDim2.new(0.25, 0, 0.75, 0)
		--newZoneButton.Image = "rbxassetid://456014731"
		--newZoneButton.ScaleType = Enum.ScaleType.Fit

		local checkButton = Instance.new("TextButton", zoneFrame)
		checkButton.AnchorPoint = Vector2.new(0.5, 0)
		checkButton.BorderSizePixel = 0
		checkButton.Position = UDim2.new(0.85, 0, 0, 0)
		checkButton.Size = UDim2.new(0.25, 0, 1, 0)
		checkButton.Text = "Check"
		checkButton.TextScaled = true
	end
	buildZoneFrame()

	local function buildOptionsFrame()
		local optionsFrame = Instance.new("Frame", questionFrame)
		optionsFrame.AnchorPoint = Vector2.new(0.5, 0)
		optionsFrame.Position = UDim2.new(0.5, 0, 0.48, 0)
		optionsFrame.Size = UDim2.new(1, 0, 0.5, 0)
		optionsFrame.BorderSizePixel = 0

		local uiGridLayout = Instance.new("UIGridLayout", optionsFrame)
		uiGridLayout.CellPadding = UDim2.new(0.018, 0,0.1, 0)
		uiGridLayout.CellSize = UDim2.new(0.179, 0,0.45, 0)
		uiGridLayout.FillDirection = Enum.FillDirection.Horizontal
		uiGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
		
		local questionButton = Instance.new("TextButton", optionsFrame)
		questionButton.Text = "Question"
		questionButton.TextScaled = true

		local option1Button = Instance.new("TextButton", optionsFrame)
		option1Button.Text = "Option 1"
		option1Button.TextScaled = true

		local option2Button = Instance.new("TextButton", optionsFrame)
		option2Button.Text = "Option 2"
		option2Button.TextScaled = true

		local option3Button = Instance.new("TextButton", optionsFrame)
		option3Button.Text = "Option 3"
		option3Button.TextScaled = true

		local allButton = Instance.new("TextButton", optionsFrame)
		allButton.Text = "All"
		allButton.TextScaled = true

		local leftSpace = Instance.new("TextLabel", optionsFrame)
		leftSpace.BorderSizePixel = 0
		leftSpace.Text = ""

		local response1Button = Instance.new("TextButton", optionsFrame)
		response1Button.Text = "Response 1"
		response1Button.TextScaled = true

		local response2Button = Instance.new("TextButton", optionsFrame)
		response2Button.Text = "Response 2"
		response2Button.TextScaled = true

		local response3Button = Instance.new("TextButton", optionsFrame)
		response3Button.Text = "Response 3"
		response3Button.TextScaled = true
		
		--local function redrawButtons()
		--	local zoneComponents = engageSDK.findZoneComponents(getCurrentZoneNumber(), {"question", "option","response"})
			
		--	local alreadyPlacedColor = Color3.fromRGB(0, 0, 0)
		--	local notPlacedColor = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
			
		--	-- Question Button
		--	if zoneComponents["question"] then
		--		questionButton.BackgroundColor3 = alreadyPlacedColor
		--	else
		--		questionButton.BackgroundColor3 = notPlacedColor
		--	end
			
		--	-- Option1 Button
		--	if zoneComponents["option1"] then
		--		option1Button.BackgroundColor3 = alreadyPlacedColor
		--	else
		--		option1Button.BackgroundColor3 = notPlacedColor
		--	end
			
		--	-- Option2 Button
		--	if zoneComponents["option2"] then
		--		option2Button.BackgroundColor3 = alreadyPlacedColor
		--	else
		--		option2Button.BackgroundColor3 = notPlacedColor
		--	end
			
		--	-- Option3 Button
		--	if zoneComponents["option3"] then
		--		option3Button.BackgroundColor3 = alreadyPlacedColor
		--	else
		--		option3Button.BackgroundColor3 = notPlacedColor
		--	end
			
		--	-- Response1 Button
		--	if zoneComponents["response1"] then
		--		response1Button.BackgroundColor3 = alreadyPlacedColor
		--	else
		--		response1Button.BackgroundColor3 = notPlacedColor
		--	end
			
		--	-- Response2 Button
		--	if zoneComponents["response2"] then
		--		response2Button.BackgroundColor3 = alreadyPlacedColor
		--	else
		--		response2Button.BackgroundColor3 = notPlacedColor
		--	end
			
		--	-- Response3 Button
		--	if zoneComponents["response3"] then
		--		response3Button.BackgroundColor3 = alreadyPlacedColor
		--	else
		--		response3Button.BackgroundColor3 = notPlacedColor
		--	end
		--end
		--redrawButtons()
		
		local function createNewFrame(parent, componentType)
			local componentFrame = Instance.new("Frame", parent)
			componentFrame:SetAttribute("EngageType", componentType:lower())
			componentFrame.Size = UDim2.new(1,0,1,0)
			componentFrame.Name = componentType .. "Frame"
			componentFrame.BackgroundTransparency = 1
			local imageLabel = Instance.new("ImageLabel", componentFrame)
			imageLabel.Size = UDim2.new(1,0,1,0)
			imageLabel.ScaleType = Enum.ScaleType.Stretch
			imageLabel.Visible = false
			imageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			imageLabel.BackgroundTransparency = 1
			imageLabel.AnchorPoint = Vector2.new(0.5,0.5)
			imageLabel.Position = UDim2.new(0.5,0,0.5,0)
			local textLabel = Instance.new("TextLabel", componentFrame)
			textLabel.Size = UDim2.new(1,0,1,0)
			textLabel.TextScaled = true
			textLabel.Text = "z" .. tostring(getCurrentZoneNumber()) .. " " .. componentType:gsub("Option", "o")
			textLabel.Visible = true
			textLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			textLabel.BackgroundTransparency = 1
			return componentFrame
		end

		local function handleNewComponent(component, onlyAdd)
			onlyAdd = onlyAdd or false

			-- Check correct selection
			local selection = Selection:Get()
			if #selection > 1 then
				print("[ERROR] Only select one object to place the question/option on.")
				return
			end
			local componentObj = selection[1]

			-- Check we have tagged this object
			local tagName = "QuestionZone" .. tostring(getCurrentZoneNumber())
			if not CollectionService:HasTag(componentObj, tagName) then
				CollectionService:AddTag(componentObj, tagName)
			end

			-- Check if we have a surface GUI
			local surfaceGUI = componentObj:FindFirstChildWhichIsA("SurfaceGui")
			if not surfaceGUI then
				surfaceGUI = Instance.new("SurfaceGui", componentObj)
				surfaceGUI.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
				setVisibleFrame("surface")
			end
			surfaceEditObject = surfaceGUI

			local zoneComponents = engageSDK.findZoneComponents(getCurrentZoneNumber(), {"question", "option"})

			-- All components on our surface
			local allComponents = {}
			for key, value in pairs(zoneComponents) do
				if value.Parent == surfaceGUI then
					allComponents[key] = value
				end
			end

			-- Check if component is already present to remove it
			if allComponents[component:lower()] and not onlyAdd then
				allComponents[component:lower()]:Destroy()
				allComponents[component:lower()] = nil
			elseif allComponents[component:lower()] then
				-- Do nothing..
			else
				allComponents[component:lower()] = createNewFrame(surfaceGUI, component)
			end

			local numComponents = 0
			for key, value in pairs(allComponents) do
				numComponents += 1
			end

			local optionsHeight = 1.0
			local numOptions = numComponents
			if allComponents["question"] ~= nil and numComponents > 1 then
				optionsHeight = 0.5
				numOptions = numComponents - 1
				allComponents["question"].Size = UDim2.new(1,0,0.5,0)
			elseif allComponents["question"] then
				-- Just a question
				allComponents["question"].Size = UDim2.new(1,0,1,0)
			end

			local count = 0
			local sizeIncrement = 1 / numOptions
			for i, option in ipairs({"option1", "option2", "option3"}) do
				if allComponents[option] then
					allComponents[option].Size = UDim2.new(sizeIncrement, 0, optionsHeight, 0)
					allComponents[option].Position = UDim2.new(sizeIncrement * count, 0, 1 - optionsHeight, 0)
					count += 1
				end
			end

			-- Update button colors
			--redrawButtons()
		end
		
		local function addResponse(responseType)
			-- Check correct selection
			local selection = Selection:Get()
			if #selection > 1 then
				print("[ERROR] Only select one object to place the question/option on.")
				return
			end
			local componentObj = selection[1]

			-- Check we have tagged this object
			local tagName = "QuestionZone" .. tostring(getCurrentZoneNumber())
			if not CollectionService:HasTag(componentObj, tagName) then
				CollectionService:AddTag(componentObj, tagName)
			end
			
			if componentObj:GetAttribute("EngageType") ~= nil then
				componentObj:SetAttribute("EngageType", nil)
			else
				componentObj:SetAttribute("EngageType", responseType)
			end
		end
		
		-- Callbacks
		questionButton.MouseButton1Click:Connect(function()			
			handleNewComponent("Question")
		end)
		option1Button.MouseButton1Click:Connect(function()
			handleNewComponent("Option1")
		end)
		option2Button.MouseButton1Click:Connect(function()
			handleNewComponent("Option2")
		end)
		option3Button.MouseButton1Click:Connect(function()
			handleNewComponent("Option3")
		end)
		allButton.MouseButton1Click:Connect(function()
			handleNewComponent("Question", true)
			handleNewComponent("Option1", true)
			handleNewComponent("Option2", true)
			handleNewComponent("Option3", true)
		end)
		response1Button.MouseButton1Click:Connect(function()
			addResponse("response1")
		end)
		response2Button.MouseButton1Click:Connect(function()
			addResponse("response2")
		end)
		response3Button.MouseButton1Click:Connect(function()
			addResponse("response3")
		end)

	end
	buildOptionsFrame()

end

local function buildInstallFrame()
	installFrame.BorderSizePixel = 0
	installFrame.Size = UDim2.new(1,0,1,0)
	
	local line1Label = Instance.new("TextLabel", installFrame)
	line1Label.BorderSizePixel = 0
	line1Label.Size = UDim2.new(1,0,0.2,0)
	line1Label.Text = "Missing Installation File(s):"
	line1Label.TextScaled = true
	
	local missingFilesLabel = Instance.new("TextLabel", installFrame)
	missingFilesLabel.BorderSizePixel = 0
	missingFilesLabel.Position = UDim2.new(0,0,0.25,0)
	missingFilesLabel.Size = UDim2.new(1,0,0.1,0)
	local missingFiles = findMissingFiles()
	if missingFiles then
		missingFilesLabel.Text = "'" .. missingFiles .. "'"
	end
	missingFilesLabel.TextScaled = true
	
	local line2Label = Instance.new("TextLabel", installFrame)
	line2Label.BorderSizePixel = 0
	line2Label.Size = UDim2.new(1,0,0.1,0)
	line2Label.Position = UDim2.new(0,0,0.4,0)
	line2Label.Text = "Please go to"
	line2Label.TextScaled = true
	
	local githubBox = Instance.new("TextBox", installFrame)
	githubBox.BorderSizePixel = 0
	githubBox.Position = UDim2.new(0,0,0.5,0)
	githubBox.Size = UDim2.new(1,0,0.1,0)
	githubBox.Text = "https://github.com/Engage-Technologies/engage-sdk"
	githubBox.TextScaled = true
	githubBox.TextEditable = false
	githubBox.Selectable = true
	githubBox.ClearTextOnFocus = false
	
	local line3Label = Instance.new("TextLabel", installFrame)
	line3Label.BorderSizePixel = 0
	line3Label.Position = UDim2.new(0, 0, 0.6, 0)
	line3Label.Size = UDim2.new(1,0,0.1,0)
	line3Label.Text = "for installation instructions."
	line3Label.TextScaled = true
	
	local updateButton = Instance.new("TextButton", installFrame)
	updateButton.AnchorPoint = Vector2.new(0.5,0)
	updateButton.BorderSizePixel = 1
	updateButton.Position = UDim2.new(0.5, 0, 0.75, 0)
	updateButton.Selectable = true
	updateButton.Size = UDim2.new(0.5, 0, 0.2, 0)
	updateButton.Text = "Recheck Install"
	updateButton.TextScaled = true
	
	updateButton.MouseButton1Click:Connect(function()
		
		local missingFile = findMissingFiles()
		if missingFile then
			missingFilesLabel.Text = "'" .. missingFile .. "'"
		else
			setVisibleFrame("question")
		end
	end)
	
end

local function buildSurfacePlacementFrame()
	surfacePlacementFrame.BorderSizePixel = 0
	surfacePlacementFrame.Size = UDim2.new(1,0,1,0)
	
	local bannerLabel = Instance.new("TextLabel", surfacePlacementFrame)
	bannerLabel.Size = UDim2.new(1,0,0.2,0)
	bannerLabel.Text = "Select Surface Side"
	bannerLabel.TextScaled = true
	
	local frame = Instance.new("Frame", surfacePlacementFrame)
	frame.Position = UDim2.new(0,0,0.2,0)
	frame.Size = UDim2.new(1,0,0.6, 0)
	
	local function buildFrame()
		local uiGridLayout = Instance.new("UIGridLayout", frame)
		uiGridLayout.CellPadding = UDim2.new(0.03, 0, 0.05, 0)
		uiGridLayout.CellSize = UDim2.new(0.25, 0, 0.35, 0)
		uiGridLayout.FillDirection = Enum.FillDirection.Horizontal
		uiGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		
		local function surfaceSideCallback(surfaceSide)
			surfaceEditObject.Face = surfaceSide
		end
		
		local backButton = Instance.new("TextButton", frame)
		backButton.Text = "Back"
		backButton.TextScaled = true
		backButton.MouseButton1Click:Connect(function()
			surfaceSideCallback(Enum.NormalId.Back)
		end)
		
		local bottomButton = Instance.new("TextButton", frame)
		bottomButton.Text = "Bottom"
		bottomButton.TextScaled = true
		bottomButton.MouseButton1Click:Connect(function()
			surfaceSideCallback(Enum.NormalId.Bottom)
		end)
		
		local frontButton = Instance.new("TextButton", frame)
		frontButton.Text = "Front"
		frontButton.TextScaled = true
		frontButton.MouseButton1Click:Connect(function()
			surfaceSideCallback(Enum.NormalId.Front)
		end)
		
		local leftButton = Instance.new("TextButton", frame)
		leftButton.Text = "Left"
		leftButton.TextScaled = true
		leftButton.MouseButton1Click:Connect(function()
			surfaceSideCallback(Enum.NormalId.Left)
		end)
		
		local rightButton = Instance.new("TextButton", frame)
		rightButton.Text = "Right"
		rightButton.TextScaled = true
		rightButton.MouseButton1Click:Connect(function()
			surfaceSideCallback(Enum.NormalId.Right)
		end)
		
		local topButton = Instance.new("TextButton", frame)
		topButton.Text = "Top"
		topButton.TextScaled = true
		topButton.MouseButton1Click:Connect(function()
			surfaceSideCallback(Enum.NormalId.Top)
		end)
	end
	buildFrame()
	
	local doneButton = Instance.new("TextButton", surfacePlacementFrame)
	doneButton.Position = UDim2.new(0,0,0.8,0)
	doneButton.Size = UDim2.new(1,0,0.2,0)
	doneButton.Text = "Done"
	doneButton.TextScaled = true
	doneButton.MouseButton1Click:Connect(function()
		setVisibleFrame("question")
	end)
	
end

Selection.SelectionChanged:Connect(function()
	
	for i, selection in ipairs(Selection:Get()) do
		
		local tags = CollectionService:GetTags(selection)
		
		for j, tag in ipairs(tags) do
			
			if tag:match("QuestionZone") then
				
				local newZoneNum, replaced = tag:gsub("QuestionZone", "")
				setCurrentZoneNumber(tonumber(newZoneNum))
				return
			end
			
		end
	end	
end)


local function syncGuiColors(objects)
	local function setColors()
		for _, guiObject in pairs(objects) do

			if guiObject:isA("UIGridLayout") then
				continue
			end
			-- Sync background color
			guiObject.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)

			-- Skip objects
			if guiObject:isA("Frame") or guiObject:isA("ImageButton") then
				continue
			end
			-- Sync text color
			guiObject.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
			guiObject.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
		end
	end
	-- Run 'setColors()' function to initially sync colors
	setColors()
	-- Connect 'ThemeChanged' event to the 'setColors()' function
	settings().Studio.ThemeChanged:Connect(setColors)
end

buildApiKeyFrame()
buildInstallFrame()
buildSurfacePlacementFrame()
buildQuestionFrame()

decideAvailableFrames()

syncGuiColors(learnWidget:GetDescendants())