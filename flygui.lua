-- Fly GUI v1 | LocalScript > StarterPlayerScripts
local plr = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local speed, flying = 150, false
local bv, bg

-- UI
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.ResetOnSpawn = false
local win = Instance.new("Frame", gui)
win.Size = UDim2.new(0,180,0,110)
win.Position = UDim2.new(0.5,-90,0,16)
win.BackgroundColor3 = Color3.fromRGB(20,20,20)
win.Active = true win.Draggable = true
Instance.new("UICorner", win).CornerRadius = UDim.new(0,10)

local bar = Instance.new("Frame", win)
bar.Size = UDim2.new(1,0,0,32) bar.BackgroundColor3 = Color3.fromRGB(40,80,255)
Instance.new("UICorner", bar).CornerRadius = UDim.new(0,10)
local ttl = Instance.new("TextLabel", bar)
ttl.Size = UDim2.new(1,0,1,0) ttl.BackgroundTransparency=1
ttl.Text="✈ Fly GUI" ttl.TextColor3=Color3.new(1,1,1)
ttl.Font=Enum.Font.GothamBold ttl.TextSize=15

local lbl = Instance.new("TextLabel", win)
lbl.Size=UDim2.new(1,0,0,22) lbl.Position=UDim2.new(0,0,0,36)
lbl.BackgroundTransparency=1 lbl.TextColor3=Color3.fromRGB(180,180,180)
lbl.Font=Enum.Font.Gotham lbl.TextSize=13 lbl.Text="Status: OFF"

local btn = Instance.new("TextButton", win)
btn.Size=UDim2.new(0.8,0,0,32) btn.Position=UDim2.new(0.1,0,0,68)
btn.BackgroundColor3=Color3.fromRGB(0,160,0)
btn.TextColor3=Color3.new(1,1,1) btn.Font=Enum.Font.GothamBold
btn.TextSize=13 btn.Text="Enable [F]"
Instance.new("UICorner", btn).CornerRadius=UDim.new(0,6)

-- Logic
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
        bg.MaxTorque = Vector3.new(1e5,1e5,1e5) bg.P=1e4
        btn.Text="Disable [F]" btn.BackgroundColor3=Color3.fromRGB(200,0,0)
        lbl.Text="Status: ON ✅"
    else
        if bv then bv:Destroy() end if bg then bg:Destroy() end
        btn.Text="Enable [F]" btn.BackgroundColor3=Color3.fromRGB(0,160,0)
        lbl.Text="Status: OFF"
    end
end

btn.MouseButton1Click:Connect(toggle)
UIS.InputBegan:Connect(function(i,g) if not g and i.KeyCode==Enum.KeyCode.F then toggle() end end)

RS.RenderStepped:Connect(function()
    if not flying or not bv then return end
    local cam = workspace.CurrentCamera
    local d = Vector3.zero
    if UIS:IsKeyDown(Enum.KeyCode.W) then d+=cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then d-=cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then d-=cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then d+=cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then d+=Vector3.new(0,1,0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d-=Vector3.new(0,1,0) end
    bv.Velocity = d.Magnitude>0 and d.Unit*speed or Vector3.zero
    bg.CFrame = cam.CFrame
end)
