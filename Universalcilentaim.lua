--========================================
-- UNIVERSAL AIM ASSIST
-- FULL MENU
--========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--========================================
-- SETTINGS
--========================================

local Settings = {
    Enabled = false,
    FOV = 300,
    TeamCheck = true,
    WallCheck = false,
    HitPart = "Head",
    Smoothness = 0.15
}

--========================================
-- GUI
--========================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LunarAimAssist"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(300, 390)
Main.Position = UDim2.new(0.5, -150, 0.5, -195)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(145, 65, 220)
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

--========================================
-- TITLE BAR
--========================================

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 48)
TitleBar.BackgroundTransparency = 1
TitleBar.Active = true
TitleBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.fromOffset(15, 0)
Title.BackgroundTransparency = 1
Title.Text = "LUNAR AIM ASSIST"
Title.TextColor3 = Color3.fromRGB(240, 235, 250)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -100, 0, 16)
SubTitle.Position = UDim2.fromOffset(15, 29)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "UNIVERSAL AIM SYSTEM"
SubTitle.TextColor3 = Color3.fromRGB(145, 125, 165)
SubTitle.TextSize = 9
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TitleBar

--========================================
-- MINIMIZE
--========================================

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.fromOffset(30, 30)
MinimizeButton.Position = UDim2.new(1, -68, 0, 9)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Color3.fromRGB(220, 210, 235)
MinimizeButton.TextSize = 20
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(30, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 9)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 90, 110)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

--========================================
-- DRAG
--========================================

local Dragging = false
local DragStart
local StartPosition

TitleBar.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = input.Position
        StartPosition = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not Dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        local Delta = input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        Dragging = false
    end
end)

--========================================
-- CONTENT
--========================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -58)
Content.Position = UDim2.fromOffset(10, 52)
Content.BackgroundTransparency = 1
Content.Parent = Main

--========================================
-- AIM TOGGLE
--========================================

local AimButton = Instance.new("TextButton")
AimButton.Size = UDim2.new(1, 0, 0, 45)
AimButton.BackgroundColor3 = Color3.fromRGB(27, 27, 36)
AimButton.BorderSizePixel = 0
AimButton.Text = "AIM ASSIST     OFF"
AimButton.TextColor3 = Color3.fromRGB(230, 225, 240)
AimButton.TextSize = 13
AimButton.Font = Enum.Font.GothamBold
AimButton.Parent = Content

local AimCorner = Instance.new("UICorner")
AimCorner.CornerRadius = UDim.new(0, 9)
AimCorner.Parent = AimButton

--========================================
-- FOV
--========================================

local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(1, 0, 0, 22)
FOVLabel.Position = UDim2.fromOffset(0, 55)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "FOV: 300"
FOVLabel.TextColor3 = Color3.fromRGB(220, 215, 230)
FOVLabel.TextSize = 12
FOVLabel.Font = Enum.Font.GothamMedium
FOVLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVLabel.Parent = Content

local MinusButton = Instance.new("TextButton")
MinusButton.Size = UDim2.fromOffset(125, 35)
MinusButton.Position = UDim2.fromOffset(0, 80)
MinusButton.BackgroundColor3 = Color3.fromRGB(27, 27, 36)
MinusButton.BorderSizePixel = 0
MinusButton.Text = "−"
MinusButton.TextColor3 = Color3.fromRGB(235, 230, 245)
MinusButton.TextSize = 18
MinusButton.Font = Enum.Font.GothamBold
MinusButton.Parent = Content

local MinusCorner = Instance.new("UICorner")
MinusCorner.CornerRadius = UDim.new(0, 8)
MinusCorner.Parent = MinusButton

local PlusButton = Instance.new("TextButton")
PlusButton.Size = UDim2.fromOffset(125, 35)
PlusButton.Position = UDim2.fromOffset(135, 80)
PlusButton.BackgroundColor3 = Color3.fromRGB(27, 27, 36)
PlusButton.BorderSizePixel = 0
PlusButton.Text = "+"
PlusButton.TextColor3 = Color3.fromRGB(235, 230, 245)
PlusButton.TextSize = 18
PlusButton.Font = Enum.Font.GothamBold
PlusButton.Parent = Content

local PlusCorner = Instance.new("UICorner")
PlusCorner.CornerRadius = UDim.new(0, 8)
PlusCorner.Parent = PlusButton

--========================================
-- TEAM CHECK
--========================================

local TeamButton = Instance.new("TextButton")
TeamButton.Size = UDim2.new(1, 0, 0, 38)
TeamButton.Position = UDim2.fromOffset(0, 125)
TeamButton.BackgroundColor3 = Color3.fromRGB(27, 27, 36)
TeamButton.BorderSizePixel = 0
TeamButton.Text = "TEAM CHECK     ON"
TeamButton.TextColor3 = Color3.fromRGB(225, 220, 235)
TeamButton.TextSize = 12
TeamButton.Font = Enum.Font.GothamMedium
TeamButton.Parent = Content

local TeamCorner = Instance.new("UICorner")
TeamCorner.CornerRadius = UDim.new(0, 8)
TeamCorner.Parent = TeamButton

--========================================
-- WALL CHECK
--========================================

local WallButton = Instance.new("TextButton")
WallButton.Size = UDim2.new(1, 0, 0, 38)
WallButton.Position = UDim2.fromOffset(0, 170)
WallButton.BackgroundColor3 = Color3.fromRGB(27, 27, 36)
WallButton.BorderSizePixel = 0
WallButton.Text = "WALL CHECK     OFF"
WallButton.TextColor3 = Color3.fromRGB(225, 220, 235)
WallButton.TextSize = 12
WallButton.Font = Enum.Font.GothamMedium
WallButton.Parent = Content

local WallCorner = Instance.new("UICorner")
WallCorner.CornerRadius = UDim.new(0, 8)
WallCorner.Parent = WallButton

--========================================
-- HIT PART
--========================================

local HitPartButton = Instance.new("TextButton")
HitPartButton.Size = UDim2.new(1, 0, 0, 38)
HitPartButton.Position = UDim2.fromOffset(0, 215)
HitPartButton.BackgroundColor3 = Color3.fromRGB(27, 27, 36)
HitPartButton.BorderSizePixel = 0
HitPartButton.Text = "TARGET PART     HEAD"
HitPartButton.TextColor3 = Color3.fromRGB(225, 220, 235)
HitPartButton.TextSize = 12
HitPartButton.Font = Enum.Font.GothamMedium
HitPartButton.Parent = Content

local HitCorner = Instance.new("UICorner")
HitCorner.CornerRadius = UDim.new(0, 8)
HitCorner.Parent = HitPartButton

--========================================
-- SMOOTHNESS
--========================================

local SmoothLabel = Instance.new("TextLabel")
SmoothLabel.Size = UDim2.new(1, 0, 0, 22)
SmoothLabel.Position = UDim2.fromOffset(0, 260)
SmoothLabel.BackgroundTransparency = 1
SmoothLabel.Text = "SMOOTHNESS: 15%"
SmoothLabel.TextColor3 = Color3.fromRGB(220, 215, 230)
SmoothLabel.TextSize = 11
SmoothLabel.Font = Enum.Font.GothamMedium
SmoothLabel.TextXAlignment = Enum.TextXAlignment.Left
SmoothLabel.Parent = Content

local SmoothMinus = Instance.new("TextButton")
SmoothMinus.Size = UDim2.fromOffset(125, 35)
SmoothMinus.Position = UDim2.fromOffset(0, 285)
SmoothMinus.BackgroundColor3 = Color3.fromRGB(27, 27, 36)
SmoothMinus.BorderSizePixel = 0
SmoothMinus.Text = "−"
SmoothMinus.TextColor3 = Color3.fromRGB(235, 230, 245)
SmoothMinus.TextSize = 18
SmoothMinus.Font = Enum.Font.GothamBold
SmoothMinus.Parent = Content

local SmoothMinusCorner = Instance.new("UICorner")
SmoothMinusCorner.CornerRadius = UDim.new(0, 8)
SmoothMinusCorner.Parent = SmoothMinus

local SmoothPlus = Instance.new("TextButton")
SmoothPlus.Size = UDim2.fromOffset(125, 35)
SmoothPlus.Position = UDim2.fromOffset(135, 285)
SmoothPlus.BackgroundColor3 = Color3.fromRGB(27, 27, 36)
SmoothPlus.BorderSizePixel = 0
SmoothPlus.Text = "+"
SmoothPlus.TextColor3 = Color3.fromRGB(235, 230, 245)
SmoothPlus.TextSize = 18
SmoothPlus.Font = Enum.Font.GothamBold
SmoothPlus.Parent = Content

local SmoothPlusCorner = Instance.new("UICorner")
SmoothPlusCorner.CornerRadius = UDim.new(0, 8)
SmoothPlusCorner.Parent = SmoothPlus

--========================================
-- FOV VISUAL
--========================================

local FOVFrame = Instance.new("Frame")
FOVFrame.Name = "VisibleFOV"
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.BackgroundTransparency = 1
FOVFrame.BorderSizePixel = 0
FOVFrame.Visible = false
FOVFrame.ZIndex = 50
FOVFrame.Parent = ScreenGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVFrame

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.fromRGB(180, 80, 255)
FOVStroke.Thickness = 2
FOVStroke.Transparency = 0.15
FOVStroke.Parent = FOVFrame

--========================================
-- AIM FUNCTIONS
--========================================

local function IsFriendly(Player)

    if Player == LocalPlayer then
        return true
    end

    if not Settings.TeamCheck then
        return false
    end

    if LocalPlayer.Team and Player.Team then
        return LocalPlayer.Team == Player.Team
    end

    return false
end

local function IsAlive(Player)

    local Character = Player.Character

    if not Character then
        return false
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    return Humanoid and Humanoid.Health > 0
end

local function GetPart(Character)

    local Part = Character:FindFirstChild(Settings.HitPart)

    if Part and Part:IsA("BasePart") then
        return Part
    end

    return Character:FindFirstChild("HumanoidRootPart")
end

local function WallCheck(Part)

    if not Settings.WallCheck then
        return true
    end

    local Character = LocalPlayer.Character

    local Params = RaycastParams.new()
    Params.FilterType = Enum.RaycastFilterType.Exclude
    Params.FilterDescendantsInstances = {
        Character
    }

    local Origin = Camera.CFrame.Position
    local Direction = Part.Position - Origin

    local Result =
        workspace:Raycast(
            Origin,
            Direction,
            Params
        )

    if not Result then
        return true
    end

    return Result.Instance:IsDescendantOf(Part.Parent)
end

local function GetTarget()

    Camera = workspace.CurrentCamera

    if not Camera then
        return nil
    end

    local Viewport = Camera.ViewportSize

    local Center = Vector2.new(
        Viewport.X / 2,
        Viewport.Y / 2
    )

    local BestPart = nil
    local BestDistance = Settings.FOV

    for _, Player in ipairs(Players:GetPlayers()) do

        if Player ~= LocalPlayer
            and IsAlive(Player)
            and not IsFriendly(Player) then

            local Character = Player.Character
            local Part = GetPart(Character)

            if Part then

                local ScreenPosition, OnScreen =
                    Camera:WorldToViewportPoint(
                        Part.Position
                    )

                if OnScreen and ScreenPosition.Z > 0 then

                    local Point = Vector2.new(
                        ScreenPosition.X,
                        ScreenPosition.Y
                    )

                    local Distance =
                        (Point - Center).Magnitude

                    if Distance <= BestDistance
                        and WallCheck(Part) then

                        BestDistance = Distance
                        BestPart = Part
                    end
                end
            end
        end
    end

    return BestPart
end

--========================================
-- AIM LOOP
--========================================

RunService.RenderStepped:Connect(function()

    Camera = workspace.CurrentCamera

    if not Camera then
        return
    end

    local Viewport = Camera.ViewportSize

    FOVFrame.Position = UDim2.fromOffset(
        Viewport.X / 2,
        Viewport.Y / 2
    )

    FOVFrame.Size = UDim2.fromOffset(
        Settings.FOV * 2,
        Settings.FOV * 2
    )

    FOVFrame.Visible = Settings.Enabled

    if not Settings.Enabled then
        return
    end

    local Target = GetTarget()

    if not Target then
        return
    end

    local TargetCFrame =
        CFrame.lookAt(
            Camera.CFrame.Position,
            Target.Position
        )

    Camera.CFrame =
        Camera.CFrame:Lerp(
            TargetCFrame,
            Settings.Smoothness
        )
end)

--========================================
-- BUTTONS
--========================================

AimButton.MouseButton1Click:Connect(function()

    Settings.Enabled = not Settings.Enabled

    AimButton.Text =
        Settings.Enabled
        and "AIM ASSIST     ON"
        or "AIM ASSIST     OFF"

    FOVFrame.Visible = Settings.Enabled
end)

MinusButton.MouseButton1Click:Connect(function()

    Settings.FOV =
        math.max(50, Settings.FOV - 25)

    FOVLabel.Text =
        "FOV: " .. Settings.FOV
end)

PlusButton.MouseButton1Click:Connect(function()

    Settings.FOV =
        math.min(800, Settings.FOV + 25)

    FOVLabel.Text =
        "FOV: " .. Settings.FOV
end)

TeamButton.MouseButton1Click:Connect(function()

    Settings.TeamCheck = not Settings.TeamCheck

    TeamButton.Text =
        "TEAM CHECK     "
        .. (Settings.TeamCheck and "ON" or "OFF")
end)

WallButton.MouseButton1Click:Connect(function()

    Settings.WallCheck = not Settings.WallCheck

    WallButton.Text =
        "WALL CHECK     "
        .. (Settings.WallCheck and "ON" or "OFF")
end)

HitPartButton.MouseButton1Click:Connect(function()

    if Settings.HitPart == "Head" then
        Settings.HitPart = "UpperTorso"
    elseif Settings.HitPart == "UpperTorso" then
        Settings.HitPart = "HumanoidRootPart"
    else
        Settings.HitPart = "Head"
    end

    HitPartButton.Text =
        "TARGET PART     "
        .. string.upper(Settings.HitPart)
end)

SmoothMinus.MouseButton1Click:Connect(function()

    Settings.Smoothness =
        math.max(0.05, Settings.Smoothness - 0.05)

    SmoothLabel.Text =
        "SMOOTHNESS: "
        .. math.floor(Settings.Smoothness * 100)
        .. "%"
end)

SmoothPlus.MouseButton1Click:Connect(function()

    Settings.Smoothness =
        math.min(1, Settings.Smoothness + 0.05)

    SmoothLabel.Text =
        "SMOOTHNESS: "
        .. math.floor(Settings.Smoothness * 100)
        .. "%"
end)

--========================================
-- MINIMIZE
--========================================

local Minimized = false
local NormalSize = Main.Size

MinimizeButton.MouseButton1Click:Connect(function()

    Minimized = not Minimized

    if Minimized then

        Content.Visible = false
        SubTitle.Visible = false

        Main.Size = UDim2.fromOffset(300, 48)

        MinimizeButton.Text = "+"

    else

        Main.Size = NormalSize

        Content.Visible = true
        SubTitle.Visible = true

        MinimizeButton.Text = "−"
    end
end)

--========================================
-- CLOSE
--========================================

CloseButton.MouseButton1Click:Connect(function()

    Settings.Enabled = false

    if FOVFrame then
        FOVFrame:Destroy()
    end

    ScreenGui:Destroy()
end)

--========================================
-- START
--========================================

print("Lunar Universal Aim Assist loaded.")
