-- Create a new toolbar section titled "Custom Script Tools"


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
		zoneLabel.BorderSizePixel = 0
		zoneLabel.Size = UDim2.new(0.2, 0, 1, 0)
		zoneLabel.Text = "Zone"
		zoneLabel.TextScaled = true
		
		local zoneBox = Instance.new("TextBox", zoneFrame)
		zoneBox.BorderSizePixel = 0
		zoneBox.Position = UDim2.new(0.2, 0, 0, 0)
		zoneBox.Size = UDim2.new(0.2, 0, 1, 0)
		zoneBox.Text = "" -- TODO get number of zones -- run a check?
		zoneBox.PlaceholderText = "#"
		zoneBox.TextScaled = true
		
		local upZoneButton = Instance.new("ImageButton", zoneFrame)
		upZoneButton.BorderSizePixel = 0
		upZoneButton.Position = UDim2.new(0.4, 0, 0, 0)
		upZoneButton.Size = UDim2.new(0.1, 0, 0.5, 0)
		upZoneButton.Image = "rbxassetid://29563813"
		
		local downZoneButton = Instance.new("ImageButton", zoneFrame)
		downZoneButton.BorderSizePixel = 0
		downZoneButton.Position = UDim2.new(0.4, 0, 0.5, 0)
		downZoneButton.Rotation = 180
		downZoneButton.Size = UDim2.new(0.1, 0, 0.5, 0)
		downZoneButton.Image = "rbxassetid://29563813"
		
		local newZoneButton = Instance.new("ImageButton", zoneFrame)
		newZoneButton.BorderSizePixel = 0
		newZoneButton.Position = UDim2.new(0.5, 0, 0, 0)
		newZoneButton.Size = UDim2.new(0.25, 0, 1, 0)
		newZoneButton.Image = "rbxassetid://456014731"
		newZoneButton.ScaleType = Enum.ScaleType.Fit
		
		local checkButton = Instance.new("TextButton", zoneFrame)
		checkButton.BorderSizePixel = 0
		checkButton.Position = UDim2.new(0.75, 0, 0, 0)
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
		
	end
	buildOptionsFrame()
	
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
buildQuestionFrame()

if apiKeyFrame then
	apiKeyFrame.Visible = true
	questionFrame.Visible = false
else
	apiKeyFrame.Visible = false
	questionFrame.Visible = true
end
syncGuiColors(learnWidget:GetDescendants())