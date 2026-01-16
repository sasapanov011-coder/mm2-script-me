--// Sasha Hub MM2
--// by SashaPanov

if game.CoreGui:FindFirstChild("SashaHub") then
    game.CoreGui.SashaHub:Destroy()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SashaHub"

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromOffset(60,60)
openBtn.Position = UDim2.fromScale(0,0.4)
openBtn.Text = "S"
openBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
openBtn.Visible = false
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 28
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(520,360)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "🔥 Sasha Hub | MM2"
title.TextColor3 = Color3.fromRGB(0,255,120)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1

-- Buttons
local close = Instance.new("TextButton", main)
close.Text = "X"
close.Size = UDim2.fromOffset(40,30)
close.Position = UDim2.new(1,-45,0,5)
close.BackgroundColor3 = Color3.fromRGB(170,40,40)
close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", close)

local hide = Instance.new("TextButton", main)
hide.Text = "_"
hide.Size = UDim2.fromOffset(40,30)
hide.Position = UDim2.new(1,-90,0,5)
hide.BackgroundColor3 = Color3.fromRGB(60,60,60)
hide.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", hide)

-- Content
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-20,1,-60)
content.Position = UDim2.fromOffset(10,50)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0,8)

local function makeToggle(text, callback)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(1,0,0,36)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Instance.new("UICorner", b)
    local on = false
    b.MouseButton1Click:Connect(function()
        on = not on
        b.BackgroundColor3 = on and Color3.fromRGB(0,170,100) or Color3.fromRGB(35,35,35)
        callback(on)
    end)
end

-- FLY
local flyConn
makeToggle("🛸 Fly (Smooth)", function(v)
    if v then
        local hrp = LP.Character.HumanoidRootPart
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
        flyConn = RunService.RenderStepped:Connect(function()
            local dir = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
            bv.Velocity = dir * 60
        end)
    else
        if flyConn then flyConn:Disconnect() end
        if LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity"):Destroy()
        end
    end
end)

-- NOCLIP
makeToggle("👻 Noclip", function(v)
    RunService.Stepped:Connect(function()
        if v and LP.Character then
            for _,p in pairs(LP.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end)

-- AUTO FARM COINS (FLY)
makeToggle("🪙 AutoFarm Coins (Fly)", function(v)
    task.spawn(function()
        while v do
            for _,c in pairs(workspace:GetDescendants()) do
                if c.Name == "CoinContainer" then
                    LP.Character.HumanoidRootPart.CFrame =
                        c.CFrame + Vector3.new(0,3,0)
                    task.wait(0.1)
                end
            end
            task.wait()
        end
    end)
end)

-- SCP / ROLES
makeToggle("🧠 SCP ESP (Roles)", function(v)
    for _,plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr ~= LP then
            local hl = Instance.new("Highlight", plr.Character)
            if plr.Backpack:FindFirstChild("Knife") then
                hl.FillColor = Color3.fromRGB(255,0,0)
            elseif plr.Backpack:FindFirstChild("Gun") then
                hl.FillColor = Color3.fromRGB(0,0,255)
            else
                hl.FillColor = Color3.fromRGB(0,255,0)
            end
        end
    end
end)

-- Hide
hide.MouseButton1Click:Connect(function()
    main.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    openBtn.Visible = false
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
