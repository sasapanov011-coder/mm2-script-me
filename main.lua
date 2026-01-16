--[[ 
  DELTA HUB: WINTER EDITION ❄️ 
  Функции: ESP (Роли), AutoFarm, Плавный UI
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()

local Window = Library:CreateWindow({
   Name = "Delta Winter ❄️ | MM2 Hub",
   LoadingTitle = "Загрузка снежинок...",
   LoadingSubtitle = "by Gemini AI",
   ConfigurationSaving = { Enabled = false }
})

local Main = Window:CreateTab("Главная 🏠")

-- Функция ESP (Подсветка)
local function UpdateESP()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            -- Удаляем старую подсветку, если есть
            if v.Character:FindFirstChild("Highlight") then v.Character.Highlight:Destroy() end
            
            local Highlight = Instance.new("Highlight", v.Character)
            Highlight.OutlineTransparency = 0
            Highlight.FillTransparency = 0.5
            
            -- Проверка ролей
            if v.Backpack:FindFirstChild("Knife") or v.Character:FindFirstChild("Knife") then
                Highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Убийца (Красный)
            elseif v.Backpack:FindFirstChild("Gun") or v.Character:FindFirstChild("Gun") then
                Highlight.FillColor = Color3.fromRGB(0, 0, 255) -- Шериф (Синий)
            else
                Highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Мирный (Зеленый)
            end
        end
    end
end

Main:CreateButton({
   Name = "Включить ESP (Роли игроков)",
   Callback = function()
       UpdateESP()
       game:GetService("RunService").RenderStepped:Connect(UpdateESP)
   end,
})

-- Автофарм (Телепорт по монетам)
Main:CreateToggle({
   Name = "Авто-фарм монет 💰",
   CurrentValue = false,
   Callback = function(Value)
       _G.Farm = Value
       while _G.Farm do
           wait(0.1)
           local Container = workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("CoinContainer")
           if Container then
               for _, coin in pairs(Container:GetChildren()) do
                   if _G.Farm and coin:FindFirstChild("TouchInterest") then
                       game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = coin.CFrame
                       wait(0.3) -- Пауза для плавности и против кика
                   end
               end
           end
       end
   end,
})

Main:CreateLabel("Если не работает — нажми кнопку ESP повторно")
