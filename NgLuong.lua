-- RedZ-Style Blox Fruits Script: Auto Farm, Raid, Fruit Finder, Bounty, God Mode
-- Modified by NgLuong
-- Features: Auto Chest Collector, Auto Bounty, God Mode, ESP, Teleports, Anti-AFK

-- Thay đổi tên biến thư viện thành NgLuong và giữ nguyên link gốc
local NgLuong = loadstring(game:HttpGet("https://raw.githubusercontent.com/akichan-scripts/BloxfruitsScripts/refs/heads/main/Source.lua"))()
-- Thiết lập giao diện màu đỏ với BloodTheme
local Window = NgLuong.CreateLib("Blox Fruits - NgLuong Red Edition", "BloodTheme")

local Main = Window:NewTab("Main")
local MainSection = Main:NewSection("Auto Features")

local Player = game:GetService("Players").LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")

_G.AutoChest = false
_G.AutoBounty = false
_G.GodMode = false
_G.AutoEliteHunter = false
_G.AutoAwakening = false
_G.AutoFruitSniper = false

-- 💰 Auto Chest Collector (Stops on Fist of Darkness or God's Chalice)
function collectChests()
    while _G.AutoChest do
        for _, chest in pairs(game.Workspace:GetChildren()) do
            if not _G.AutoChest then break end -- Stop if AutoChest is turned off

            if chest:IsA("Model") and chest:FindFirstChild("Chest") then
                Player.Character.HumanoidRootPart.CFrame = chest.Chest.CFrame
                wait(0.2) -- Small delay to prevent teleport spam

                -- Check inventory for Fist of Darkness or God's Chalice
                for _, item in pairs(Player.Backpack:GetChildren()) do
                    if item:IsA("Tool") and (item.Name == "Fist of Darkness" or item.Name == "God's Chalice") then
                        _G.AutoChest = false
                        print("Rare item found! Stopping Auto Chest Collector.")
                        return -- Stop function when rare item is obtained
                    end
                end
            end
        end
        wait(2) -- Adjust delay for performance
    end
end

MainSection:NewToggle("Auto Chest Collector", "Teleports instantly to chests", function(state)
    _G.AutoChest = state
    if state then
        collectChests()
    end
end)

-- ⚔️ Auto Bounty Farming
function huntPlayers()
    while _G.AutoBounty do
        for _, enemy in pairs(game:GetService("Players"):GetPlayers()) do
            if enemy ~= Player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.CFrame = enemy.Character.HumanoidRootPart.CFrame
                wait(1)
            end
        end
        wait(5)
    end
end

MainSection:NewToggle("Auto Bounty", "Hunts players for bounty", function(state)
    _G.AutoBounty = state
    if state then
        huntPlayers()
    end
end)

-- 🛡️ God Mode (No Hit)
function enableGodMode()
    while _G.GodMode do
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid:SetAttribute("Health", math.huge) -- Makes player invincible
        end
        wait(1)
    end
end

MainSection:NewToggle("God Mode", "Become invincible!", function(state)
    _G.GodMode = state
    if state then
        enableGodMode()
    end
end)

-- 🏹 Auto Elite Hunter (Kills all Elite Bosses instantly)
function huntEliteBosses()
    while _G.AutoEliteHunter do
        for _, boss in pairs(game.Workspace:GetChildren()) do
            if boss:IsA("Model") and boss:FindFirstChild("HumanoidRootPart") and boss.Name:match("Diablo|Deandre|Urban") then
                Player.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame
                wait(0.2) -- Teleport delay
                
                -- Attack Elite Boss
                repeat
                    if boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                        game:GetService("VirtualUser"):CaptureController()
                        game:GetService("VirtualUser"):ClickButton1(Vector2.new()) -- Simulate attack
                    end
                    wait(0.5)
                until not boss:FindFirstChild("Humanoid") or boss.Humanoid.Health <= 0

                print("Elite Boss Defeated!")
            end
        end
        wait(5) -- Adjust delay for performance
    end
end

MainSection:NewToggle("Auto Elite Hunter", "Automatically kills all Elite Bosses", function(state)
    _G.AutoEliteHunter = state
    if state then
        huntEliteBosses()
    end
end)

-- 🌟 Auto Awakening (Instantly Awakens All Moves)
function awakenAllMoves()
    while _G.AutoAwakening do
        local awakenFrame = game:GetService("Players").LocalPlayer.PlayerGui.Awakening.Frame
        if awakenFrame and awakenFrame.Visible then
            for _, button in pairs(awakenFrame:GetChildren()) do
                if button:IsA("TextButton") and button.Text == "Awaken" then
                    button:Activate()
                end
            end
            print("Awakened all moves!")
        end
        wait(1)
    end
end

MainSection:NewToggle("Auto Awakening", "Instantly awakens all fruit moves", function(state)
    _G.AutoAwakening = state
    if state then
        awakenAllMoves()
    end
end)

-- 🍏 Auto Devil Fruit Sniper (Buys rare fruits instantly)
local rareFruits = {"Dragon", "Dough", "Leopard", "Venom", "Control", "Shadow"}

function buyRareFruit()
    while _G.AutoFruitSniper do
        local shop = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
        for _, fruit in pairs(shop) do
            if table.find(rareFruits, fruit.Name) then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFruit", fruit.Name)
                print("Bought rare fruit: " .. fruit.Name)
                _G.AutoFruitSniper = false -- Stop script after purchase
                return
            end
        end
        wait(5) -- Check the shop every 5 seconds
    end
end

MainSection:NewToggle("Auto Fruit Sniper", "Buys rare fruits from shop instantly", function(state)
    _G.AutoFruitSniper = state
    if state then
        buyRareFruit()
    end
end)

-- 🚀 Teleport Locations
local Teleport = Window:NewTab("Teleport")
local TeleportSection = Teleport:NewSection("Teleport Locations")

TeleportSection:NewButton("Teleport to First Sea", "Go to First Sea", function()
    Player.Character.HumanoidRootPart.CFrame = CFrame.new(2000, 50, 2000)
end)

TeleportSection:NewButton("Teleport to Second Sea", "Go to Second Sea", function()
    Player.Character.HumanoidRootPart.CFrame = CFrame.new(8000, 50, -8000)
end)

TeleportSection:NewButton("Teleport to Third Sea", "Go to Third Sea", function()
    Player.Character.HumanoidRootPart.CFrame = CFrame.new(12000, 50, -12000)
end)

-- 🛑 Anti-AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualInputManager:SendKeyEvent(true, "W", false, game)
    wait(1)
    VirtualInputManager:SendKeyEvent(false, "W", false, game)
end)
