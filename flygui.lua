-- Fly GUI v1.1 | LocalScript > StarterPlayerScripts
local plr = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local speed, flying = 50, false
local bv, bg

-- UI
local gui = Instance.new("ScreenGui")
gui.Parent = plr:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local win = Instance.new("Frame", gui)
win.Size = UDim2.new(0, 220, 0, 210)
win.Position = UDim2.new(0.5, -110, 0, 16)
win.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
win.Active = true

Instance.new("UICorner", win).CornerRadius = UDim.new(0, 10)

-- Drag (thay cho Draggable deprecated)
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

-- Top bar
local bar = Instance.new("Frame", win)
bar.Size = UDim2.new(1, 0, 0, 32)
bar.BackgroundColor3 = Color3.fromRGB(40, 80, 255)
Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 10)

local ttl = Instance.new("TextLabel", bar)
ttl.Size = UDim2.new(1, 0, 1, 0)
ttl.BackgroundTransparency = 1
ttl.Text = "✈ Fly GUI"
ttl.TextColor3 = Color3.new(1, 1, 1)
ttl.Font = Enum.Font.GothamBold
ttl.TextSize = 15

-- Status
local lbl = Instance.new("TextLabel", win)
lbl.Size = UDim2.new(1, 0, 0, 22)
lbl.Position = UDim2.new(0, 0, 0, 36)
lbl.BackgroundTransparency = 1
lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
lbl.Font = Enum.Font.Gotham
lbl.TextSize = 13
lbl.Text = "Status: OFF"

-- Speed label
local speedLbl = Instance.new("TextLabel", win)
speedLbl.Size = UDim2.new(1, -20, 0, 20)
speedLbl.Position = UDim2.new(0, 10, 0, 60)
speedLbl.BackgroundTransparency = 1
speedLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLbl.Font = Enum.Font.Gotham
speedLbl.TextSize = 13
speedLbl.TextXAlignment = Enum.TextXAlignment.Left
speedLbl.Text = "Speed: " .. speed

-- Slider bg
local sliderBg = Instance.new("Frame", win)
sliderBg.Size = UDim2.new(1, -20, 0, 8)
sliderBg.Position = UDim2.new(0, 10, 0, 82)
sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 4)

-- Slider fill
local sliderFill = Instance.new("Frame", sliderBg)
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(40, 80, 255)
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 4)

-- Slider handle
local sliderHandle = Instance.new("TextButton", sliderBg)
sliderHandle.Size = UDim2.new(0, 16, 0, 16)
sliderHandle.Position = UDim2.new(0, -8, 0.5, -8)
sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderHandle.Text = ""
Instance.new("UICorner", sliderHandle).CornerRadius = UDim.new(1, 0)

-- Input box
local speedBox = Instance.new("TextBox", win)
speedBox.Size = UDim2.new(0.4, 0, 0, 26)
speedBox.Position = UDim2.new(0.55, 0, 0, 58)
speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 13
speedBox.Text = tostring(speed)
speedBox.ClearTextOnFocus = false
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 4)

-- Button
local btn = Instance.new("TextButton", win)
btn.Size = UDim2.new(0.8, 0, 0, 32)
btn.Position = UDim2.new(0.1, 0, 0, 140)
btn.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 13
btn.Text = "Enable [F]"
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

-- Slider logic
local minSpeed, maxSpeed = 1, 500

local function updateSlider()
	local pct = (speed - minSpeed) / (maxSpeed - minSpeed)
	sliderFill.Size = UDim2.new(pct, 0, 1, 0)
	sliderHandle.Position = UDim2.new(pct, -8, 0.5, -8)
end

local function setSpeed(input)
	local pct = math.clamp(
		(input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X,
		0, 1
	)
	speed = math.floor(minSpeed + pct * (maxSpeed - minSpeed))
	speedLbl.Text = "Speed: " .. speed
	speedBox.Text = speed
	updateSlider()
end

local draggingSlider = false

sliderHandle.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSlider = true
		setSpeed(i)
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSlider = false
	end
end)

UIS.InputChanged:Connect(function(i)
	if draggingSlider and i.UserInputType == Enum.UserInputType.MouseMovement then
		setSpeed(i)
	end
end)

sliderBg.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		setSpeed(i)
	end
end)

speedBox.FocusLost:Connect(function()
	local num = tonumber(speedBox.Text)
	if num then
		speed = math.clamp(math.floor(num), minSpeed, maxSpeed)
	end
	speedBox.Text = speed
	speedLbl.Text = "Speed: " .. speed
	updateSlider()
end)

updateSlider()

-- Fly
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

		btn.Text = "Disable [F]"
		btn.BackgroundColor3 = Color3.fromRGB(200,0,0)
		lbl.Text = "Status: ON"
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end

		btn.Text = "Enable [F]"
		btn.BackgroundColor3 = Color3.fromRGB(0,160,0)
		lbl.Text = "Status: OFF"
	end
end

btn.MouseButton1Click:Connect(toggle)

UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode == Enum.KeyCode.F then
		toggle()
	end
end)

RS.RenderStepped:Connect(function()
	if not flying or not bv then return end

	local cam = workspace.CurrentCamera
	local d = Vector3.zero

	if UIS:IsKeyDown(Enum.KeyCode.W) then d += cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.S) then d -= cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.A) then d -= cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.D) then d += cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.Space) then d += Vector3.new(0,1,0) end
	if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d -= Vector3.new(0,1,0) end

	bv.Velocity = d.Magnitude > 0 and d.Unit * speed or Vector3.zero
	bg.CFrame = cam.CFrame
end)
