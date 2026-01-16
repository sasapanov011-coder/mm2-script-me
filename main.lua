--==================================================
-- Sasha Hub | MM2 / SCP
-- Style: FourHub inspired
-- Executor: Delta
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")
local Cam = workspace.CurrentCamera

--================ UI CLEANUP ======================
pcall(function()
    game.CoreGui.SashaHub:Destroy()
end)

--================ MAIN UI =========================
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "SashaHub"

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromScale(0.42,0.52)
Main.Position = UDim2.fromScale(0.29,0.24)
Main.BackgroundColor3 = Color3.fromRGB(20,20,25)
Main.BackgroundTransparency = 0.08
Main.Active = true
Main.Draggable = true
Main.BorderSizePixel = 0

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,20)

--================ TOP BAR =========================
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.fromScale(1,0.1)
Top.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Top)
Title.Text = "FOURHUB • Sasha Edition"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(120,200,255)
Title.Size = UDim2.fromScale(0.7,1)
Title.BackgroundTransparency = 1

local function TopBtn(txt, pos, callback)
    local b = Instance.new("TextButton", Top)
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(35,35,40)
    b.Size = UDim2.fromScale(0.08,0.7)
    b.Position = pos
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    b.MouseButton1Click:Connect(callback)
end

-- Hide / Close
TopBtn("—", UDim2.fromScale(0.82,0.15), function()
    TweenService:Create(Main,TweenInfo.new(0.4),{
        Position = UDim2.fromScale(0.29,1.2)
    }):Play()
end)

TopBtn("X", UDim2.fromScale(0.91,0.15), function()
    Gui:Destroy()
end)

--================ CONTENT =========================
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.fromScale(1,0.9)
Content.Position = UDim2.fromScale(0,0.1)
Content.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", Content)
Layout.Padding = UDim.new(0,8)

local function Button(text, callback)
    local b = Instance.new("TextButton", Content)
    b.Size = UDim2.fromScale(0.96,0.075)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextScaled = true
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(32,32,38)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)

    b.MouseEnter:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.2),{
            BackgroundColor3 = Color3.fromRGB(45,45,55)
        }):Play()
    end)

    b.MouseLeave:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.2),{
            BackgroundColor3 = Color3.fromRGB(32,32,38)
        }):Play()
    end)

    b.MouseButton1Click:Connect(callback)
end

--================ STATES ==========================
local Fly, Noclip, AutoFarm = false,false,false

--================ FLY (ПЛАВНЫЙ) ===================
local BV, BG
local speed = 0

local function ToggleFly()
    Fly = not Fly
    if Fly then
        BV = Instance.new("BodyVelocity", HRP)
        BV.MaxForce = Vector3.new(1e9,1e9,1e9)

        BG = Instance.new("BodyGyro", HRP)
        BG.MaxTorque = Vector3.new(1e9,1e9,1e9)

        RunService.RenderStepped:Connect(function(dt)
            if Fly then
                speed = math.clamp(speed + 120*dt, 0, 80)
                local dir = Vector3.zero
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Cam.CFrame.RightVector end
                BV.Velocity = dir * speed
                BG.CFrame = Cam.CFrame
            end
        end)
    else
        speed = 0
        if BV then BV:Destroy() end
        if BG then BG:Destroy() end
    end
end

--================ NOCLIP ==========================
RunService.Stepped:Connect(function()
    if Noclip then
        for _,v in pairs(Char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

--================ AUTOFARM (ПЛАВНЫЙ, 3 СЕК) =======
task.spawn(function()
    while task.wait(3) do
        if AutoFarm then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find("coin") then
                    TweenService:Create(
                        HRP,
                        TweenInfo.new(1.2, Enum.EasingStyle.Sine),
                        {CFrame = v.CFrame}
                    ):Play()
                    task.wait(1.3)
                    break
                end
            end
        end
    end
end)

--================ MM2 / SCP ESP ==================
local function SCP()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            if p.Character:FindFirstChild("Highlight") then
                p.Character.Highlight:Destroy()
            end
            local h = Instance.new("Highlight", p.Character)
            h.FillTransparency = 0.35

            if p.Backpack:FindFirstChild("Knife") then
                h.FillColor = Color3.fromRGB(255,60,60)
            elseif p.Backpack:FindFirstChild("Gun") then
                h.FillColor = Color3.fromRGB(80,150,255)
            else
                h.FillColor = Color3.fromRGB(80,255,140)
            end
        end
    end
end

--================ BUTTONS =========================
Button("🚀 Fly (Smooth)", ToggleFly)
Button("👻 Noclip", function() Noclip = not Noclip end)
Button("🧠 AutoFarm (Smooth TP)", function() AutoFarm = not AutoFarm end)
Button("🟥🟦🟩 SCP / MM2 ESP", SCP)

print("🔥 Sasha Hub loaded (FourHub style)")
