--==================================================
--  Sasha Hub | Delta Executor
--  MM2 / SCP / Universal
--  No Key | Free | Open Source
--==================================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")
local Cam = workspace.CurrentCamera

-- Cleanup
if game.CoreGui:FindFirstChild("SashaHub") then
    game.CoreGui.SashaHub:Destroy()
end

--==================================================
-- UI
--==================================================
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "SashaHub"

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromScale(0.35,0.5)
Main.Position = UDim2.fromScale(0.325,0.25)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.BackgroundTransparency = 1

TweenService:Create(Main,TweenInfo.new(0.4),{BackgroundTransparency=0}):Play()

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0,18)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.fromScale(1,0.1)
Title.Text = "🔥 Sasha Hub | MM2 / SCP"
Title.TextColor3 = Color3.fromRGB(0,255,150)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true

local List = Instance.new("UIListLayout", Main)
List.Padding = UDim.new(0,8)

--==================================================
-- Button creator
--==================================================
local function Button(txt,callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.fromScale(1,0.075)
    b.Text = txt
    b.Font = Enum.Font.Gotham
    b.TextScaled = true
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b)

    b.MouseEnter:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(45,45,45)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(30,30,30)}):Play()
    end)

    b.MouseButton1Click:Connect(callback)
end

--==================================================
-- STATES
--==================================================
local Fly = false
local Noclip = false
local AutoFarm = false
local Spin = false
local Aim = false

--==================================================
-- FLY + NOCLIP (НОРМАЛЬНЫЙ)
--==================================================
local BV, BG
local function ToggleFly()
    Fly = not Fly
    if Fly then
        BV = Instance.new("BodyVelocity",HRP)
        BV.MaxForce = Vector3.new(1e9,1e9,1e9)

        BG = Instance.new("BodyGyro",HRP)
        BG.MaxTorque = Vector3.new(1e9,1e9,1e9)

        RunService.RenderStepped:Connect(function()
            if Fly then
                local dir = Vector3.zero
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Cam.CFrame.RightVector end
                BV.Velocity = dir * 80
                BG.CFrame = Cam.CFrame
            end
        end)
    else
        if BV then BV:Destroy() end
        if BG then BG:Destroy() end
    end
end

RunService.Stepped:Connect(function()
    if Noclip then
        for _,v in pairs(Char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

--==================================================
-- AUTOFARM (летаешь + собираешь)
--==================================================
task.spawn(function()
    while task.wait(0.35) do
        if AutoFarm then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find("coin") then
                    HRP.CFrame = v.CFrame
                    task.wait(0.08)
                end
            end
        end
    end
end)

--==================================================
-- MM2 / SCP ESP
--==================================================
local function SCP()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            if p.Character:FindFirstChild("Highlight") then
                p.Character.Highlight:Destroy()
            end
            local h = Instance.new("Highlight",p.Character)
            h.FillTransparency = 0.35

            if p.Backpack:FindFirstChild("Knife") then
                h.FillColor = Color3.fromRGB(255,0,0)
            elseif p.Backpack:FindFirstChild("Gun") then
                h.FillColor = Color3.fromRGB(0,120,255)
            else
                h.FillColor = Color3.fromRGB(0,255,120)
            end
        end
    end
end

--==================================================
-- TARGET ПО НИКУ (УЛЕТАЕТ)
--==================================================
local function TargetPlayer(name)
    for _,p in pairs(Players:GetPlayers()) do
        if p.Name:lower():find(name:lower()) and p.Character then
            p.Character.HumanoidRootPart.Velocity = Vector3.new(0,500,0)
        end
    end
end

--==================================================
-- BUTTONS (их МНОГО, база под 50+)
--==================================================
Button("🚀 Fly", ToggleFly)
Button("👻 Noclip", function() Noclip = not Noclip end)
Button("🧠 AutoFarm Coins", function() AutoFarm = not AutoFarm end)
Button("🟥🟦🟩 SCP / MM2 ESP", SCP)
Button("🌀 Spin", function() Spin = not Spin end)
Button("🎯 Target (по нику)", function()
    TargetPlayer("player") -- меняешь ник в коде или дальше сделаем textbox
end)
Button("🔁 Rejoin", function()
    TeleportService:Teleport(game.PlaceId,LP)
end)

--==================================================
print("🔥 Sasha Hub Loaded Successfully")
