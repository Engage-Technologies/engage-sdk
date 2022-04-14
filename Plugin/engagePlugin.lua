-- Create a new toolbar section titled "Custom Script Tools"
local Selection = game:GetService("Selection")

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
local backendScript

-- Question Zone attributes
local zoneBox

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

local function getMaxZoneNumber()
	return backendScript:GetAttribute("EngageZones")
end

local function incrementMaxZoneNumber()
	
	-- We must have an object selected & we'll mark it with the zone number
	
	local numZones = getMaxZoneNumber()
	local newNumZones = numZones + 1
	backendScript:SetAttribute("EngageZones", newNumZones)
	zoneBox.Text = tostring(newNumZones)
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
		print("Connecting!")
		local code = apiKeyBox.Text

		-- Attempt to connect to backend
		if code ~= "" then
			print("Connecting with " .. code)
			apiKey = code
			Plugin:SetSetting("apiKey", apiKey)
			apiKeyFrame.Visible = false
			questionFrame.Visible = true
		end
	end

	apiKeyBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			onConnect()
		else
			--print("Focus lost but enter wasn't pressed")
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

		zoneBox = Instance.new("TextBox", zoneFrame)
		zoneBox.AnchorPoint = Vector2.new(0.5 ,0)
		zoneBox.BorderSizePixel = 0
		zoneBox.Position = UDim2.new(0.35, 0, 0, 0)
		zoneBox.Size = UDim2.new(0.2, 0, 1, 0)
		zoneBox.Text = tostring(getMaxZoneNumber())
		zoneBox.PlaceholderText = "#"
		zoneBox.TextScaled = true

		local upZoneButton = Instance.new("ImageButton", zoneFrame)
		upZoneButton.AnchorPoint = Vector2.new(0.5, 0)
		upZoneButton.BorderSizePixel = 0
		upZoneButton.Position = UDim2.new(0.55, 0, 0, 0)
		upZoneButton.Size = UDim2.new(0.15, 0, 0.5, 0)
		upZoneButton.Image = "rbxassetid://29563813"
		
		upZoneButton.MouseButton1Click:Connect(function()
			-- Get the new zone number
			-- Check if it's less than the maxZoneNumber and increment
			local newZoneNum = tonumber(zoneBox.Text) + 1
			if newZoneNum > getMaxZoneNumber() then
				incrementMaxZoneNumber()
			end
			zoneBox.Text = tostring(newZoneNum)
			-- TODO check if we have an object selected and change all of the selected Object's engageZone numbers
		end)

		local downZoneButton = Instance.new("ImageButton", zoneFrame)
		downZoneButton.AnchorPoint = Vector2.new(0.5, 0)
		downZoneButton.BorderSizePixel = 0
		downZoneButton.Position = UDim2.new(0.55, 0, 0.5, 0)
		downZoneButton.Rotation = 180
		downZoneButton.Size = UDim2.new(0.15, 0, 0.5, 0)
		downZoneButton.Image = "rbxassetid://29563813"
		
		downZoneButton.MouseButton1Click:Connect(function()
			local newZoneNum = math.max( tonumber(zoneBox.Text) - 1, 1)
			zoneBox.Text = tostring(newZoneNum)
			-- TODO same check about object selected and incrementing
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
		questionButton.MouseButton1Click:Connect(function()
			local selection = Selection:Get()
			if #selection > 1 then
				print("[ERROR] Only select one object to place the question on.")
				return
			end
			
			local questionObj = selection[1]
			
			local surfaceGUI = questionObj:FindFirstChildWhichIsA("SurfaceGui")
			if not surfaceGUI then
				surfaceGUI = Instance.new("SurfaceGui", questionObj)
				
			end
		end)

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

	end
	buildOptionsFrame()

end

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
			
		end
		
		local backButton = Instance.new("TextButton", frame)
		backButton.Text = "Back"
		backButton.TextScaled = true
		
		local bottomButton = Instance.new("TextButton", frame)
		bottomButton.Text = "Bottom"
		bottomButton.TextScaled = true
		
		local frontButton = Instance.new("TextButton", frame)
		frontButton.Text = "Front"
		frontButton.TextScaled = true
		
		local leftButton = Instance.new("TextButton", frame)
		leftButton.Text = "Left"
		leftButton.TextScaled = true
		
		local rightButton = Instance.new("TextButton", frame)
		rightButton.Text = "Right"
		rightButton.TextScaled = true
		
		local topButton = Instance.new("TextButton", frame)
		topButton.Text = "Topp"
		topButton.TextScaled = true
	end
	buildFrame()
	
	local doneButton = Instance.new("TextButton", surfacePlacementFrame)
	doneButton.Position = UDim2.new(0,0,0.8,0)
	doneButton.Size = UDim2.new(1,0,0.2,0)
	doneButton.Text = "Done"
	doneButton.TextScaled = true
	
end


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
buildQuestionFrame()

-- Get the Engage API Code
if not apiKeyFrame then
	setVisibleFrame("api")

-- Check that the module has been installed
elseif findMissingFiles() then	
	setVisibleFrame("install")
-- Everything is ready to go
else
	setVisibleFrame("question")
end

syncGuiColors(learnWidget:GetDescendants())