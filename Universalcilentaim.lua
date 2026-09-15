--========================================================
-- UNIVERSAL SILENT AIM - TEST BUILD
--========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    Enabled = true,
    FOV = 250,
    TargetPart = "Head",
    TeamCheck = true,
    VisibleCheck = true,
    Prediction = 0
}

--========================================================
-- GUI
--========================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "UniversalSilentAim"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(220, 135)
Main.Position = UDim2.new(0.5, -110, 0.5, -67)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Main.BorderSizePixel = 0
Main.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(130, 80, 220)
Stroke.Thickness = 1.5
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(14, 8)
Title.Size = UDim2.new(1, -28, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "Universal Silent Aim"
Title.TextColor3 = Color3.fromRGB(225, 215, 245)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Status = Instance.new("TextLabel")
Status.BackgroundTransparency = 1
Status.Position = UDim2.fromOffset(14, 34)
Status.Size = UDim2.new(1, -28, 0, 18)
Status.Font = Enum.Font.Gotham
Status.Text = "Silent Aim: ON"
Status.TextColor3 = Color3.fromRGB(170, 150, 205)
Status.TextSize = 11
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(1, -28, 0, 32)
Toggle.Position = UDim2.fromOffset(14, 58)
Toggle.BackgroundColor3 = Color3.fromRGB(55, 40, 80)
Toggle.BorderSizePixel = 0
Toggle.Text = "SILENT AIM  •  ON"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextColor3 = Color3.fromRGB(230, 220, 250)
Toggle.TextSize = 11
Toggle.AutoButtonColor = false
Toggle.Parent = Main

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 9)
ToggleCorner.Parent = Toggle

local FOVText = Instance.new("TextLabel")
FOVText.BackgroundTransparency = 1
FOVText.Position = UDim2.fromOffset(14, 98)
FOVText.Size = UDim2.new(1, -28, 0, 25)
FOVText.Font = Enum.Font.Gotham
FOVText.Text = "FOV: 250"
FOVText.TextColor3 = Color3.fromRGB(170, 165, 185)
FOVText.TextSize = 11
FOVText.TextXAlignment = Enum.TextXAlignment.Left
FOVText.Parent = Main


--========================================================
-- FOV
--========================================================

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOV"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.Size = UDim2.fromOffset(
    Config.FOV * 2,
    Config.FOV * 2
)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 0
FOVCircle.Parent = Gui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(145, 90, 230)
FOVStroke.Thickness = 1.5
FOVStroke.Transparency = 0.2
FOVStroke.Parent = FOVCircle


--========================================================
-- VISIBILITY CHECK
--========================================================

local function IsVisible(Character, Position)
    if not Config.VisibleCheck then
        return true
    end

    local Origin = Camera.CFrame.Position
    local Direction = Position - Origin

    local Params = RaycastParams.new()
    Params.FilterType = Enum.RaycastFilterType.Exclude
    Params.FilterDescendantsInstances = {
        LocalPlayer.Character
    }

    local Result = workspace:Raycast(
        Origin,
        Direction,
        Params
    )

    if not Result then
        return true
    end

    return Result.Instance:IsDescendantOf(Character)
end


--========================================================
-- TARGET
--========================================================

local function GetTarget()
    local MousePosition =
        UserInputService:GetMouseLocation()

    local BestTarget = nil
    local BestDistance = Config.FOV

    for _, Player in ipairs(Players:GetPlayers()) do

        if Player ~= LocalPlayer then

            if Config.TeamCheck
                and LocalPlayer.Team ~= nil
                and Player.Team == LocalPlayer.Team then
                continue
            end

            local Character = Player.Character

            if not Character then
                continue
            end

            local Humanoid =
                Character:FindFirstChildOfClass("Humanoid")

            if not Humanoid or Humanoid.Health <= 0 then
                continue
            end

            local Part =
                Character:FindFirstChild(Config.TargetPart)

            if not Part then
                Part =
                    Character:FindFirstChild("HumanoidRootPart")
            end

            if not Part then
                continue
            end

            local ScreenPosition, OnScreen =
                Camera:WorldToViewportPoint(
                    Part.Position
                )

            if not OnScreen then
                continue
            end

            local Distance =
                (
                    Vector2.new(
                        ScreenPosition.X,
                        ScreenPosition.Y
                    ) - MousePosition
                ).Magnitude

            if Distance <= BestDistance then

                if IsVisible(
                    Character,
                    Part.Position
                ) then

                    BestDistance = Distance
                    BestTarget = Part
                end
            end
        end
    end

    return BestTarget
end


--========================================================
-- TARGET TRACKING
--========================================================

local CurrentTarget = nil

RunService.RenderStepped:Connect(function()

    Camera = workspace.CurrentCamera

    if not Camera then
        return
    end

    FOVCircle.Position =
        UDim2.fromScale(0.5, 0.5)

    FOVCircle.Size =
        UDim2.fromOffset(
            Config.FOV * 2,
            Config.FOV * 2
        )

    FOVCircle.Visible = Config.Enabled

    FOVText.Text =
        "FOV: " .. tostring(Config.FOV)

    if not Config.Enabled then
        CurrentTarget = nil
        Status.Text = "Silent Aim: OFF"
        return
    end

    CurrentTarget = GetTarget()

    if CurrentTarget then
        Status.Text =
            "Target: " .. CurrentTarget.Parent.Name
    else
        Status.Text =
            "Silent Aim: ON • No target"
    end
end)


--========================================================
-- TOGGLE
--========================================================

Toggle.MouseButton1Click:Connect(function()

    Config.Enabled = not Config.Enabled

    if Config.Enabled then
        Toggle.Text = "SILENT AIM  •  ON"
        Toggle.BackgroundColor3 =
            Color3.fromRGB(55, 40, 80)
    else
        Toggle.Text = "SILENT AIM  •  OFF"
        Toggle.BackgroundColor3 =
            Color3.fromRGB(35, 35, 43)
    end
end)


--========================================================
-- DRAG
--========================================================

local Dragging = false
local DragStart
local StartPosition

Main.InputBegan:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position

        Input.Changed:Connect(function()

            if Input.UserInputState ==
                Enum.UserInputState.End then

                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)

    if not Dragging then
        return
    end

    if Input.UserInputType ~= Enum.UserInputType.MouseMovement
        and Input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local Delta =
        Input.Position - DragStart

    Main.Position = UDim2.new(
        StartPosition.X.Scale,
        StartPosition.X.Offset + Delta.X,
        StartPosition.Y.Scale,
        StartPosition.Y.Offset + Delta.Y
    )
end)

print("Universal Silent Aim loaded.")
