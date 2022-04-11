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
local userSecret = Plugin:GetSetting("userSecret")

local apiKeyFrame = Instance.new("Frame", learnWidget)
apiKeyFrame.Visible = true
local questionFrame = Instance.new("Frame", learnWidget)
questionFrame.Visible = false

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
	
end

local function syncGuiColors(objects)
	print(objects)
	local function setColors()
		for _, guiObject in pairs(objects) do
			print(guiObject.Name)
			
			-- Sync background color
			guiObject.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
			
			if not guiObject:isA("Frame") then
				-- Sync text color
				guiObject.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
				guiObject.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
			end
		end
	end
	-- Run 'setColors()' function to initially sync colors
	setColors()
	-- Connect 'ThemeChanged' event to the 'setColors()' function
	settings().Studio.ThemeChanged:Connect(setColors)
end

buildApiKeyFrame()
buildQuestionFrame()
syncGuiColors(learnWidget:GetDescendants())