local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Delta Hub: Winter Edition ❄️", "Lavender")

-- Стилизация под снежинки (тема)
local MainTab = Window:NewTab("Main/Farm")
local ESPSect = MainTab:NewSection("ESP & Visuals")

-- Функция для подсветки ролей в MM2
local function CreateESP(player, color, roleName)
    if player.Character and not player.Character:FindFirstChild("Highlight") then
        local Highlight = Instance.new("Highlight")
        Highlight.Parent = player.Character
        Highlight.FillColor = color
        Highlight.FillTransparency = 0.5
        Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    end
end

ESPSect:NewButton("Activate Roles ESP", "Подсветить Убийцу и Шерифа", function()
    while task.wait(2) do
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Backpack:FindFirstChild("Knife") or (v.Character and v.Character:FindFirstChild("Knife")) then
                CreateESP(v, Color3.fromRGB(255, 0, 0), "Murderer") -- Красный
            elseif v.Backpack:FindFirstChild("Gun") or (v.Character and v.Character:FindFirstChild("Gun")) then
                CreateESP(v, Color3.fromRGB(0, 0, 255), "Sheriff") -- Синий
            end
        end
    end
end)

-- Секция Автофарма
local FarmSect = MainTab:NewSection("Auto Farm")

FarmSect:NewToggle("Auto Collect Coins", "Плавно перемещает по монетам", function(state)
    getgenv().AutoFarm = state
    spawn(function()
        while getgenv().AutoFarm do
            task.wait()
            local coins = workspace:FindFirstChild("Normal") -- Для MM2
            if coins then
                for _, coin in pairs(coins:GetChildren()) do
                    if coin:IsA("TouchTransmitter") or coin:FindFirstChild("CoinVisual") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = coin.CFrame
                        task.wait(0.1)
                    end
                end
            end
        end
    end)
end)

-- Настройки интерфейса
local SettingsTab = Window:NewTab("Settings")
local SettingsSect = SettingsTab:NewSection("UI Config")

SettingsSect:NewKeybind("Toggle UI", "Нажми, чтобы скрыть", Enum.KeyCode.RightControl, function()
	Library:ToggleUI()
end)
