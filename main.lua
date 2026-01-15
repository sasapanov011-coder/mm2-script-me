--[[ 
    Sasha Delta Hub
    Free | No Key | Open Source
]]

if game.CoreGui:FindFirstChild("SashaDeltaHub") then
    game.CoreGui.SashaDeltaHub:Destroy()
end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- UI (Mini Orion-like)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SashaDeltaHub"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.fromScale(0.32,0.45)
Frame.Position = UDim2.fromScale(0.34,0.27)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.Active = true
Frame.Draggable = true

local UIList = Instance.new("UIListLayout", Frame)
UIList.Padding = UDim.new(0,6)

local function Button(text, callback)
    local b = Instance.new("TextButton", Frame)
    b.Size = UDim2.fromScale(1,0.08)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(callback)
end

-- VARIABLES
local Flying = false
local Noclip = false
local AutoFarm = false
local Spin = false
local AimLock = false

-- FUNCTIONS

-- FLY
local BV, BG
local function ToggleFly()
    Flying = not Flying
    if Flying then
        BV = Instance.new("BodyVelocity", HumanoidRootPart)
        BV.MaxForce = Vector3.new(9e9,9e9,9e9)
        BV.Velocity = Vector3.zero

        BG = Instance.new("BodyGyro", HumanoidRootPart)
        BG.MaxTorque = Vector3.new(9e9,9e9,9e9)

        RunService.RenderStepped:Connect(function()
            if Flying then
                local cam = workspace.CurrentCamera
                BV.Velocity = cam.CFrame.LookVector * 60
                BG.CFrame = cam.CFrame
            end
        end)
    else
        if BV then BV:Destroy() end
        if BG then BG:Destroy() end
    end
end

-- NOCLIP
RunService.Stepped:Connect(function()
    if Noclip and Character then
        for _,v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- AUTOFARM (Coins)
task.spawn(function()
    while task.wait(0.4) do
        if AutoFarm then
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name:lower():find("coin") and v:IsA("BasePart") then
                    HumanoidRootPart.CFrame = v.CFrame
                    task.wait(0.1)
                end
            end
        end
    end
end)

-- SCP / MM2 HIGHLIGHT
local function ApplyRoleColors()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local h = Instance.new("Highlight", plr.Character)
            h.FillTransparency = 0.4

            if plr.Backpack:FindFirstChild("Knife") then
                h.FillColor = Color3.fromRGB(255,0,0) -- Killer
            elseif plr.Backpack:FindFirstChild("Gun") then
                h.FillColor = Color3.fromRGB(0,100,255) -- Sheriff
            else
                h.FillColor = Color3.fromRGB(0,255,0) -- Innocent
            end
        end
    end
end

-- SPIN
task.spawn(function()
    while task.wait() do
        if Spin then
            HumanoidRootPart.CFrame *= CFrame.Angles(0,math.rad(20),0)
        end
    end
end)

-- AIM TARGET
RunService.RenderStepped:Connect(function()
    if AimLock then
        local closest,dist
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local mag = (plr.Character.Head.Position - HumanoidRootPart.Position).Magnitude
                if not dist or mag < dist then
                    dist = mag
                    closest = plr
                end
            end
        end
        if closest then
            workspace.CurrentCamera.CFrame = CFrame.new(
                workspace.CurrentCamera.CFrame.Position,
                closest.Character.Head.Position
            )
        end
    end
end)

-- BUTTONS
Button("🚀 Fly", ToggleFly)
Button("👻 Noclip", function() Noclip = not Noclip end)
Button("🧠 AutoFarm Coins", function() AutoFarm = not AutoFarm end)
Button("🟥🟦🟩 SCP / MM2 ESP", ApplyRoleColors)
Button("🌀 Spin", function() Spin = not Spin end)
Button("🎯 Aim Target", function() AimLock = not AimLock end)
Button("🔁 Rejoin", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

print("Sasha Delta Hub Loaded")
