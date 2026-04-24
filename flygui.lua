-- Fly GUI v3 Style (Modern UI)

local plr = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local speed, flying = 50, false
local bv, bg

-- GUI
local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

-- Main Frame (glass style)
local win = Instance.new("Frame", gui)
win.Size = UDim2.new(0, 260, 0, 180)
win.Position = UDim2.new(0.5, -130, 0.5, -90)
win.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
win.BackgroundTransparency = 0.1
win.Active = true

Instance.new("UICorner", win).CornerRadius = UDim.new(0, 16)

-- Gradient
local grad = Instance.new("UIGradient", win)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40,80,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(120,40,255))
}

-- Shadow fake
local stroke = Instance.new("UIStroke", win)
stroke.Color = Color3.fromRGB(100,100,255)
stroke.Thickness = 1.5
stroke.Transparency = 0.5

-- Title
local title = Instance.new("TextLabel", win)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "✈ Fly GUI v3"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)

-- Status
local status = Instance.new("TextLabel", win)
status.Position = UDim2.new(0,0,0,40)
status.Size = UDim2.new(1,0,0,25)
status.BackgroundTransparency = 1
status.Text = "Status: OFF"
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(200,200,200)

-- Toggle Button (modern)
local btn = Instance.new("TextButton", win)
btn.Size = UDim2.new(0.8,0,0,40)
btn.Position = UDim2.new(0.1,0,0.65,0)
btn.BackgroundColor3 = Color3.fromRGB(60,200,120)
btn.Text = "ENABLE"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

-- Button gradient
local btnGrad = Instance.new("UIGradient", btn)
btnGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(60,200,120)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(40,150,255))
}

-- Drag
local dragging, dragInput, dragStart, startPos

win.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = win.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

win.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		win.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Toggle Fly
local function toggle()
	local chr = plr.Character
	if not chr then return end
	local hrp = chr:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	flying = not flying

	if flying then
		bv = Instance.new("BodyVelocity", hrp)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)

		bg = Instance.new("BodyGyro", hrp)
		bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
		bg.P = 1e4

		btn.Text = "DISABLE"
		status.Text = "Status: ON"
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end

		btn.Text = "ENABLE"
		status.Text = "Status: OFF"
	end
end

btn.MouseButton1Click:Connect(toggle)

UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode == Enum.KeyCode.F then
		toggle()
	end
end)

-- Fly movement
RS.RenderStepped:Connect(function()
	if not flying or not bv then return end

	local cam = workspace.CurrentCamera
	local d = Vector3.zero

	if UIS:IsKeyDown(Enum.KeyCode.W) then d = d + cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.S) then d = d - cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.A) then d = d - cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.D) then d = d + cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.new(0,1,0) end
	if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d = d - Vector3.new(0,1,0) end

	if d.Magnitude > 0 then
		bv.Velocity = d.Unit * speed
	else
		bv.Velocity = Vector3.zero
	end

	bg.CFrame = cam.CFrame
end)
