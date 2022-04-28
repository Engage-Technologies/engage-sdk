local module = {}

-- Hndles the updating of a surface according to question information

function module.updateSurface(surfacePart, questionInfo)
	local textLabel = surfacePart.TextLabel
	local imageLabel = surfacePart.ImageLabel
	
	local function toggleDispaly(showText)
		if showText then
			textLabel.Visible = true
			imageLabel.Visible = false
		else
			textLabel.Visible = false
			imageLabel.Visible = true
		end
	end
	
	if questionInfo["text"] then
		textLabel.Text = questionInfo["text"]
		toggleDispaly(true)
	end
	if questionInfo["audio"] then
		print("There's audio")
	end
	if questionInfo["image"] then
		imageLabel.Image = "rbxassetid://" .. tostring(questionInfo["image"])
		imageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
		toggleDispaly(false)
	end
	
end

return module
