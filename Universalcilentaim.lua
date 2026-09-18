--==================================================
-- SILENT AIM MENU v2
--==================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- НАСТРОЙКИ
--==================================================

local Settings = {
    SilentAim = false,
    FOV = 300,
    TeamCheck = true,
    WallCheck = false,
    KillCheck = false,
    HitPart = "Head"
}

--==================================================
-- ПРОВЕРКА СОЮЗНИКА
--==================================================

local function IsFriendly(player)
    if not player or player == LocalPlayer then return true end

    if Settings.TeamCheck then
        if LocalPlayer.Team and player.Team then
            if LocalPlayer.Team == player.Team then
                return true
            end
        end
    end

    return false
end

--==================================================
-- ПРОВЕРКА СТЕН
--==================================================

local function IsVisible(part)
    if not part or not Camera then return false end

    local origin = Camera.CFrame.Position
    local direction = part.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { LocalPlayer.Character }
    params.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, params)

    if not result then return true end

    return result.Instance:IsDescendantOf(part.Parent)
end

--==================================================
-- ПОИСК ЦЕЛИ
--==================================================

local function GetTarget()
    if not Camera then return nil end

    local viewport = Camera.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y / 2)

    local bestPlayer, bestPart, bestDist = nil, nil, math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if not IsFriendly(player) then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local part = char:FindFirstChild(Settings.HitPart)
                    if part and part:IsA("BasePart") then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen and screenPos.Z > 0 then
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                            if dist <= Settings.FOV and dist < bestDist then

                                local visible = true
                                if Settings.WallCheck then
                                    visible = IsVisible(part)
                                end

                                if visible then
                                    bestDist = dist
                                    bestPlayer = player
                                    bestPart = part
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return bestPlayer, bestPart
end

--==================================================
-- ХУК ВЫСТРЕЛА
--==================================================

local mt = getrawmetatable(game)
if mt and setreadonly and getnamecallmethod then
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if Settings.SilentAim and (method == "FireServer" or method == "InvokeServer") then
            local targetPlayer, targetPart = GetTarget()
            if targetPart then

                if Settings.KillCheck then
                    if targetPlayer and targetPlayer.Character then
                        local hum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health <= 0 then
                            return oldNamecall(self, ...)
                        end
                    end
                end

                for i, arg in ipairs(args) do
                    if typeof(arg) == "Vector3" then
                        args[i] = targetPart.Position
                    elseif typeof(arg) == "CFrame" then
                        args[i] = CFrame.new(targetPart.Position)
                    elseif typeof(arg) == "Instance" and arg:IsA("BasePart") then
                        args[i] = targetPart
                    end
                end
            end
            return oldNamecall(self, unpack(args))
        end

        return oldNamecall(self, ...)
    end)

    setreadonly(mt, true)
end

--==================================================
-- МЕНЮ
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SilentAimMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 260, 0, 320)
Main.Position = UDim2.new(0.5, -130, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(200, 45, 45)
Stroke.Thickness = 1.5
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Silent Aim"
Title.TextColor3 = Color3.fromRGB(245, 245, 250)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

local function CreateToggle(text, key, yPos)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -20, 0, 35)
    Row.Position = UDim2.new(0, 10, 0, yPos)
    Row.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    Row.BorderSizePixel = 0
    Row.Parent = Main

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 8)
    RowCorner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 50, 0, 24)
    Btn.Position = UDim2.new(1, -60, 0.5, -12)
    Btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(200, 45, 45) or Color3.fromRGB(48, 48, 55)
    Btn.BorderSizePixel = 0
    Btn.Text = Settings[key] and "ON" or "OFF"
    Btn.TextColor3 = Color3.fromRGB(245, 245, 250)
    Btn.TextSize = 11
    Btn.Font = Enum.Font.GothamBold
    Btn.Parent = Row

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        Btn.Text = Settings[key] and "ON" or "OFF"
        Btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(200, 45, 45) or Color3.fromRGB(48, 48, 55)
    end)
end

CreateToggle("Silent Aim", "SilentAim", 45)
CreateToggle("Team Check", "TeamCheck", 85)
CreateToggle("Wall Check", "WallCheck", 125)
CreateToggle("Kill Check", "KillCheck", 165)

-- FOV слайдер
local FOVRow = Instance.new("Frame")
FOVRow.Size = UDim2.new(1, -20, 0, 50)
FOVRow.Position = UDim2.new(0, 10, 0, 205)
FOVRow.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
FOVRow.BorderSizePixel = 0
FOVRow.Parent = Main

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(0, 8)
FOVCorner.Parent = FOVRow

local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(1, -20, 0, 20)
FOVLabel.Position = UDim2.new(0, 10, 0, 2)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "FOV: " .. Settings.FOV
FOVLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
FOVLabel.TextSize = 12
FOVLabel.Font = Enum.Font.GothamMedium
FOVLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVLabel.Parent = FOVRow

local MinusBtn = Instance.new("TextButton")
MinusBtn.Size = UDim2.new(0, 30, 0, 22)
MinusBtn.Position = UDim2.new(0, 10, 0, 24)
MinusBtn.BackgroundColor3 = Color3.fromRGB(48, 48, 55)
MinusBtn.BorderSizePixel = 0
MinusBtn.Text = "-"
MinusBtn.TextColor3 = Color3.fromRGB(245, 245, 250)
MinusBtn.TextSize = 14
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.Parent = FOVRow

local MinusCorner = Instance.new("UICorner")
MinusCorner.CornerRadius = UDim.new(0, 6)
MinusCorner.Parent = MinusBtn

local PlusBtn = Instance.new("TextButton")
PlusBtn.Size = UDim2.new(0, 30, 0, 22)
PlusBtn.Position = UDim2.new(0, 45, 0, 24)
PlusBtn.BackgroundColor3 = Color3.fromRGB(48, 48, 55)
PlusBtn.BorderSizePixel = 0
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(245, 245, 250)
PlusBtn.TextSize = 14
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.Parent = FOVRow

local PlusCorner = Instance.new("UICorner")
PlusCorner.CornerRadius = UDim.new(0, 6)
PlusCorner.Parent = PlusBtn

MinusBtn.MouseButton1Click:Connect(function()
    Settings.FOV = math.max(50, Settings.FOV - 25)
    FOVLabel.Text = "FOV: " .. Settings.FOV
end)

PlusBtn.MouseButton1Click:Connect(function()
    Settings.FOV = math.min(800, Settings.FOV + 25)
    FOVLabel.Text = "FOV: " .. Settings.FOV
end)

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 8)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Main

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("Silent Aim Menu v2 loaded.")
