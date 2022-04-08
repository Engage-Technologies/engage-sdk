local part = script.Parent

local db = true

local function onPartTouched(otherPart)
	-- Get the other part's parent
	local partParent = otherPart.Parent
	-- Look for a humanoid in the parent
	local humanoid = partParent:FindFirstChildWhichIsA("Humanoid")
	if humanoid and db then
		db = false
		print("Selecting!")
		-- Indicate response selected
		
		wait(3)
		db = true
	end
end

part.Touched:Connect(onPartTouched)