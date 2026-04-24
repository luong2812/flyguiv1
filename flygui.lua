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

-- Drag fix
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

-- Button
local btn = Instance.new("TextButton", win)
btn.Size = UDim2.new(0.8, 0, 0, 32)
btn.Position = UDim2.new(0.1, 0, 0, 140)
btn.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
btn.Text = "Enable [F]"

-- Fly toggle
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
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end

		btn.Text = "Enable [F]"
	end
end

btn.MouseButton1Click:Connect(toggle)

UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode == Enum.KeyCode.F then
		toggle()
	end
end)

-- FIX CHÍNH Ở ĐÂY
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
