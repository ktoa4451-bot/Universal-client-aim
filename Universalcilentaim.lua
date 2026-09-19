--========================================
-- LUNAR AIM ASSIST
-- PART 1/4
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
    FOV = 180,
    AimSpeed = 0.85,
    TeamCheck = true,
    WallCheck = false,
    TargetPart = "Head",
    HoldToAim = false
}

--========================================
-- COLORS
--========================================

local Purple = Color3.fromRGB(170, 75, 255)
local PurpleDark = Color3.fromRGB(95, 35, 145)
local Background = Color3.fromRGB(13, 12, 19)
local Panel = Color3.fromRGB(22, 20, 31)
local Button = Color3.fromRGB(30, 27, 42)
local Text = Color3.fromRGB(235, 230, 245)
local Muted = Color3.fromRGB(145, 138, 160)

--========================================
-- GUI PARENT
--========================================

local function GetGuiParent()

    local Parent

    pcall(function()
        if typeof(gethui) == "function" then
            Parent = gethui()
        end
    end)

    if not Parent then
        pcall(function()
            Parent = game:GetService("CoreGui")
        end)
    end

    if not Parent then
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    return Parent
end

local GuiParent = GetGuiParent()

--========================================
-- REMOVE OLD VERSION
--========================================

pcall(function()

    local Old = GuiParent:FindFirstChild("LunarAimAssist")

    if Old then
        Old:Destroy()
    end

end)

--========================================
-- SCREEN GUI
--========================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LunarAimAssist"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = GuiParent

--========================================
-- MAIN WINDOW
--========================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.Size = UDim2.fromOffset(330, 410)
Main.BackgroundColor3 = Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.ZIndex = 10
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 17)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Purple
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.15
MainStroke.Parent = Main

--========================================
-- GLOW
--========================================

local Glow = Instance.new("Frame")
Glow.Name = "Glow"
Glow.AnchorPoint = Vector2.new(0.5, 0.5)
Glow.Position = UDim2.fromScale(0.5, 0.5)
Glow.Size = UDim2.new(1, 18, 1, 18)
Glow.BackgroundColor3 = Purple
Glow.BackgroundTransparency = 0.93
Glow.BorderSizePixel = 0
Glow.ZIndex = 9
Glow.Parent = Main

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(0, 20)
GlowCorner.Parent = Glow

--========================================
-- TOP BAR
--========================================

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 65)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 11
TopBar.Parent = Main

--========================================
-- LOGO BACKGROUND
--========================================

local LogoHolder = Instance.new("Frame")
LogoHolder.Size = UDim2.fromOffset(45, 45)
LogoHolder.Position = UDim2.fromOffset(12, 10)
LogoHolder.BackgroundColor3 = Color3.fromRGB(30, 23, 42)
LogoHolder.BorderSizePixel = 0
LogoHolder.ZIndex = 12
LogoHolder.Parent = TopBar

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = LogoHolder

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Purple
LogoStroke.Thickness = 1
LogoStroke.Transparency = 0.3
LogoStroke.Parent = LogoHolder

--========================================
-- MOON LOGO
--========================================

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.fromScale(1, 1)
Logo.BackgroundTransparency = 1
Logo.Text = "☾"
Logo.TextColor3 = Color3.fromRGB(190, 120, 255)
Logo.TextSize = 31
Logo.Font = Enum.Font.GothamBold
Logo.ZIndex = 13
Logo.Parent = LogoHolder

--========================================
-- TITLE
--========================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -115, 0, 27)
Title.Position = UDim2.fromOffset(68, 10)
Title.BackgroundTransparency = 1
Title.Text = "LUNAR AIM"
Title.TextColor3 = Text
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -115, 0, 20)
Subtitle.Position = UDim2.fromOffset(69, 35)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Universal Aim Assist"
Subtitle.TextColor3 = Muted
Subtitle.TextSize = 10
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 12
Subtitle.Parent = TopBar

--========================================
-- CLOSE BUTTON
--========================================

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(32, 32)
Close.Position = UDim2.new(1, -43, 0, 11)
Close.BackgroundColor3 = Color3.fromRGB(35, 23, 30)
Close.BorderSizePixel = 0
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 105, 125)
Close.TextSize = 21
Close.Font = Enum.Font.GothamBold
Close.ZIndex = 14
Close.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 9)
CloseCorner.Parent = Close

--========================================
-- MINIMIZE BUTTON
--========================================

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(32, 32)
Minimize.Position = UDim2.new(1, -81, 0, 11)
Minimize.BackgroundColor3 = Button
Minimize.BorderSizePixel = 0
Minimize.Text = "−"
Minimize.TextColor3 = Text
Minimize.TextSize = 19
Minimize.Font = Enum.Font.GothamBold
Minimize.ZIndex = 14
Minimize.Parent = TopBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 9)
MinimizeCorner.Parent = Minimize

--========================================
-- OPEN ANIMATION
--========================================

Main.Size = UDim2.fromOffset(280, 350)
Main.BackgroundTransparency = 1
MainStroke.Transparency = 1
Glow.BackgroundTransparency = 1

local OpenTween = TweenInfo.new(
    0.55,
    Enum.EasingStyle.Quint,
    Enum.EasingDirection.Out
)

TweenService:Create(
    Main,
    OpenTween,
    {
        Size = UDim2.fromOffset(330, 410),
        BackgroundTransparency = 0
    }
):Play()

TweenService:Create(
    MainStroke,
    OpenTween,
    {
        Transparency = 0.15
    }
):Play()

TweenService:Create(
    Glow,
    OpenTween,
    {
        BackgroundTransparency = 0.93
    }
):Play()

--========================================
-- LOGO ANIMATION
--========================================

task.spawn(function()

    while ScreenGui.Parent do

        local Up = TweenService:Create(
            LogoHolder,
            TweenInfo.new(
                1.2,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Rotation = 6,
                Size = UDim2.fromOffset(48, 48)
            }
        )

        local Down = TweenService:Create(
            LogoHolder,
            TweenInfo.new(
                1.2,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Rotation = -6,
                Size = UDim2.fromOffset(45, 45)
            }
        )

        Up:Play()
        Up.Completed:Wait()

        if not ScreenGui.Parent then
            break
        end

        Down:Play()
        Down.Completed:Wait()
    end

end)

--========================================
-- CLOSE ANIMATION
--========================================

Close.MouseButton1Click:Connect(function()

    local Tween = TweenService:Create(
        Main,
        TweenInfo.new(
            0.35,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.In
        ),
        {
            Size = UDim2.fromOffset(250, 300),
            BackgroundTransparency = 1
        }
    )

    Tween:Play()

    TweenService:Create(
        MainStroke,
        TweenInfo.new(0.25),
        {
            Transparency = 1
        }
    ):Play()

    Tween.Completed:Wait()

    ScreenGui:Destroy()
end)

print("Lunar Aim Assist loaded - Part 1")

--========================================
-- LUNAR AIM ASSIST
-- PART 2/4
--========================================

--========================================
-- DRAG SYSTEM
--========================================

local Dragging = false
local DragStart
local StartPosition

TopBar.InputBegan:Connect(function(input)

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
-- FOV CIRCLE
--========================================

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.Size = UDim2.fromOffset(Settings.FOV * 2, Settings.FOV * 2)
FOVCircle.BackgroundTransparency = 1
FOVCircle.ZIndex = 3
FOVCircle.Parent = ScreenGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Purple
FOVStroke.Thickness = 2
FOVStroke.Transparency = 0.18
FOVStroke.Parent = FOVCircle

--========================================
-- FOV GLOW
--========================================

local FOVGlow = Instance.new("Frame")
FOVGlow.AnchorPoint = Vector2.new(0.5, 0.5)
FOVGlow.Position = UDim2.fromScale(0.5, 0.5)
FOVGlow.Size = UDim2.fromOffset(
    Settings.FOV * 2 + 12,
    Settings.FOV * 2 + 12
)
FOVGlow.BackgroundTransparency = 1
FOVGlow.ZIndex = 2
FOVGlow.Parent = ScreenGui

local FOVGlowCorner = Instance.new("UICorner")
FOVGlowCorner.CornerRadius = UDim.new(1, 0)
FOVGlowCorner.Parent = FOVGlow

local FOVGlowStroke = Instance.new("UIStroke")
FOVGlowStroke.Color = Purple
FOVGlowStroke.Thickness = 5
FOVGlowStroke.Transparency = 0.8
FOVGlowStroke.Parent = FOVGlow

--========================================
-- FOV PULSE
--========================================

task.spawn(function()

    while ScreenGui.Parent do

        local PulseUp = TweenService:Create(
            FOVGlowStroke,
            TweenInfo.new(
                0.9,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Transparency = 0.55,
                Thickness = 7
            }
        )

        local PulseDown = TweenService:Create(
            FOVGlowStroke,
            TweenInfo.new(
                0.9,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Transparency = 0.82,
                Thickness = 4
            }
        )

        PulseUp:Play()
        PulseUp.Completed:Wait()

        if not ScreenGui.Parent then
            break
        end

        PulseDown:Play()
        PulseDown.Completed:Wait()
    end

end)

--========================================
-- BUTTON CREATOR
--========================================

local function CreateControlButton(
    TextValue,
    PositionY
)

    local ButtonFrame = Instance.new("TextButton")

    ButtonFrame.Size =
        UDim2.new(1, -36, 0, 43)

    ButtonFrame.Position =
        UDim2.fromOffset(18, PositionY)

    ButtonFrame.BackgroundColor3 =
        Button

    ButtonFrame.BorderSizePixel = 0

    ButtonFrame.AutoButtonColor = false

    ButtonFrame.Text =
        TextValue

    ButtonFrame.TextColor3 =
        Text

    ButtonFrame.TextSize =
        12

    ButtonFrame.Font =
        Enum.Font.GothamMedium

    ButtonFrame.TextXAlignment =
        Enum.TextXAlignment.Left

    ButtonFrame.ZIndex =
        12

    ButtonFrame.Parent =
        Main

    local Padding =
        Instance.new("UIPadding")

    Padding.PaddingLeft =
        UDim.new(0, 15)

    Padding.Parent =
        ButtonFrame

    local Corner =
        Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0, 10)

    Corner.Parent =
        ButtonFrame

    local Stroke =
        Instance.new("UIStroke")

    Stroke.Color =
        Color3.fromRGB(65, 55, 82)

    Stroke.Transparency =
        0.7

    Stroke.Thickness =
        1

    Stroke.Parent =
        ButtonFrame

    --====================================
    -- HOVER
    --====================================

    ButtonFrame.MouseEnter:Connect(function()

        TweenService:Create(
            ButtonFrame,
            TweenInfo.new(
                0.18,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            {
                BackgroundColor3 =
                    Color3.fromRGB(45, 35, 60)
            }
        ):Play()

        TweenService:Create(
            Stroke,
            TweenInfo.new(0.18),
            {
                Transparency = 0.25,
                Color = Purple
            }
        ):Play()

    end)

    ButtonFrame.MouseLeave:Connect(function()

        TweenService:Create(
            ButtonFrame,
            TweenInfo.new(
                0.22,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            {
                BackgroundColor3 =
                    Button
            }
        ):Play()

        TweenService:Create(
            Stroke,
            TweenInfo.new(0.22),
            {
                Transparency = 0.7,
                Color =
                    Color3.fromRGB(65, 55, 82)
            }
        ):Play()

    end)

    --====================================
    -- CLICK ANIMATION
    --====================================

    ButtonFrame.MouseButton1Down:Connect(function()

        TweenService:Create(
            ButtonFrame,
            TweenInfo.new(
                0.08,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                Size =
                    UDim2.new(
                        1,
                        -42,
                        0,
                        39
                    )
            }
        ):Play()

    end)

    ButtonFrame.MouseButton1Up:Connect(function()

        TweenService:Create(
            ButtonFrame,
            TweenInfo.new(
                0.14,
                Enum.EasingStyle.Back,
                Enum.EasingDirection.Out
            ),
            {
                Size =
                    UDim2.new(
                        1,
                        -36,
                        0,
                        43
                    )
            }
        ):Play()

    end)

    return ButtonFrame
end

--========================================
-- AIM BUTTON
--========================================

local AimButton =
    CreateControlButton(
        "Aim Assist     OFF",
        78
    )

local function UpdateAimButton()

    if Settings.Enabled then

        AimButton.Text =
            "Aim Assist     ON"

        AimButton.TextColor3 =
            Color3.fromRGB(
                210,
                160,
                255
            )

        AimButton.BackgroundColor3 =
            Color3.fromRGB(
                55,
                35,
                75
            )

    else

        AimButton.Text =
            "Aim Assist     OFF"

        AimButton.TextColor3 =
            Text

        AimButton.BackgroundColor3 =
            Button

    end

end

AimButton.MouseButton1Click:Connect(function()

    Settings.Enabled =
        not Settings.Enabled

    UpdateAimButton()

end)

--========================================
-- FOV BUTTON
--========================================

local FOVButton =
    CreateControlButton(
        "FOV             " .. Settings.FOV,
        128
    )

FOVButton.MouseButton1Click:Connect(function()

    Settings.FOV =
        Settings.FOV + 25

    if Settings.FOV > 500 then
        Settings.FOV = 50
    end

    FOVButton.Text =
        "FOV             " ..
        Settings.FOV

end)

--========================================
-- AIM SPEED BUTTON
--========================================

local SpeedButton =
    CreateControlButton(
        "Aim Speed       " ..
        string.format(
            "%.2f",
            Settings.AimSpeed
        ),
        178
    )

SpeedButton.MouseButton1Click:Connect(function()

    Settings.AimSpeed =
        Settings.AimSpeed + 0.05

    if Settings.AimSpeed > 1 then
        Settings.AimSpeed = 0.1
    end

    Settings.AimSpeed =
        math.floor(
            Settings.AimSpeed * 100
        ) / 100

    SpeedButton.Text =
        "Aim Speed       " ..
        string.format(
            "%.2f",
            Settings.AimSpeed
        )

end)

--========================================
-- TEAM CHECK BUTTON
--========================================

local TeamButton =
    CreateControlButton(
        "Team Check      ON",
        228
    )

TeamButton.MouseButton1Click:Connect(function()

    Settings.TeamCheck =
        not Settings.TeamCheck

    TeamButton.Text =
        "Team Check      " ..
        (Settings.TeamCheck
            and "ON"
            or "OFF")

end)

--========================================
-- WALL CHECK BUTTON
--========================================

local WallButton =
    CreateControlButton(
        "Wall Check      OFF",
        278
    )

WallButton.MouseButton1Click:Connect(function()

    Settings.WallCheck =
        not Settings.WallCheck

    WallButton.Text =
        "Wall Check      " ..
        (Settings.WallCheck
            and "ON"
            or "OFF")

end)

--========================================
-- TARGET BUTTON
--========================================

local TargetButton =
    CreateControlButton(
        "Target          HEAD",
        328
    )

TargetButton.MouseButton1Click:Connect(function()

    if Settings.TargetPart == "Head" then

        Settings.TargetPart =
            "UpperTorso"

    elseif Settings.TargetPart ==
        "UpperTorso" then

        Settings.TargetPart =
            "HumanoidRootPart"

    else

        Settings.TargetPart =
            "Head"

    end

    TargetButton.Text =
        "Target          " ..
        string.upper(
            Settings.TargetPart
        )

end)

print("Lunar Aim Assist loaded - Part 2")

--========================================
-- LUNAR AIM ASSIST
-- PART 3/4
--========================================

--========================================
-- TEAM CHECK
--========================================

local function IsEnemy(Player)

    if Player == LocalPlayer then
        return false
    end

    if not Settings.TeamCheck then
        return true
    end

    if LocalPlayer.Team and Player.Team then
        return LocalPlayer.Team ~= Player.Team
    end

    return true
end

--========================================
-- ALIVE CHECK
--========================================

local function IsAlive(Character)

    if not Character then
        return false
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
        return false
    end

    return Humanoid.Health > 0
end

--========================================
-- WALL CHECK
--========================================

local function CanSeePart(Part)

    if not Settings.WallCheck then
        return true
    end

    local Character =
        LocalPlayer.Character

    if not Character then
        return false
    end

    local Origin =
        Camera.CFrame.Position

    local Direction =
        Part.Position - Origin

    local Params =
        RaycastParams.new()

    Params.FilterType =
        Enum.RaycastFilterType.Exclude

    Params.FilterDescendantsInstances = {
        Character
    }

    Params.IgnoreWater = true

    local Result =
        workspace:Raycast(
            Origin,
            Direction,
            Params
        )

    if not Result then
        return true
    end

    return Result.Instance:IsDescendantOf(
        Part.Parent
    )
end

--========================================
-- TARGET PART
--========================================

local function GetTargetPart(Character)

    if not Character then
        return nil
    end

    local Part =
        Character:FindFirstChild(
            Settings.TargetPart
        )

    if Part and Part:IsA("BasePart") then
        return Part
    end

    return Character:FindFirstChild("Head")
        or Character:FindFirstChild("HumanoidRootPart")
end

--========================================
-- GET CLOSEST TARGET
--========================================

local function GetClosestTarget()

    if not Camera then
        return nil
    end

    local Viewport =
        Camera.ViewportSize

    local Center =
        Vector2.new(
            Viewport.X / 2,
            Viewport.Y / 2
        )

    local ClosestPart = nil
    local ClosestDistance =
        Settings.FOV

    for _, Player in
        ipairs(Players:GetPlayers()) do

        if IsEnemy(Player) then

            local Character =
                Player.Character

            if IsAlive(Character) then

                local Part =
                    GetTargetPart(Character)

                if Part then

                    local ScreenPosition,
                        OnScreen =
                        Camera:WorldToViewportPoint(
                            Part.Position
                        )

                    if OnScreen
                        and ScreenPosition.Z > 0 then

                        local ScreenPoint =
                            Vector2.new(
                                ScreenPosition.X,
                                ScreenPosition.Y
                            )

                        local Distance =
                            (
                                ScreenPoint -
                                Center
                            ).Magnitude

                        if Distance <=
                            ClosestDistance then

                            if CanSeePart(Part) then

                                ClosestDistance =
                                    Distance

                                ClosestPart =
                                    Part
                            end
                        end
                    end
                end
            end
        end
    end

    return ClosestPart
end

--========================================
-- AIM STATE
--========================================

local HoldingAim = false

UserInputService.InputBegan:Connect(
    function(Input, Processed)

        if Processed then
            return
        end

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton2 then

            HoldingAim = true
        end
    end
)

UserInputService.InputEnded:Connect(
    function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton2 then

            HoldingAim = false
        end
    end
)

--========================================
-- FOV ANIMATION
--========================================

local FOVPulse = 0

RunService.RenderStepped:Connect(
    function(Delta)

        FOVPulse =
            FOVPulse + Delta * 2.5

        local Pulse =
            (math.sin(FOVPulse) + 1) / 2

        FOVStroke.Transparency =
            0.12 + Pulse * 0.18

        FOVGlowStroke.Transparency =
            0.58 + Pulse * 0.20

        FOVGlowStroke.Thickness =
            4 + Pulse * 3

        FOVCircle.Size =
            UDim2.fromOffset(
                Settings.FOV * 2,
                Settings.FOV * 2
            )

        FOVGlow.Size =
            UDim2.fromOffset(
                Settings.FOV * 2 + 12,
                Settings.FOV * 2 + 12
            )

    end
)

--========================================
-- AIM SYSTEM
--========================================

RunService:BindToRenderStep(
    "LunarAimAssist",
    Enum.RenderPriority.Camera.Value + 1,
    function()

        if not Settings.Enabled then
            return
        end

        local Target =
            GetClosestTarget()

        if not Target then
            return
        end

        local CameraPosition =
            Camera.CFrame.Position

        local TargetPosition =
            Target.Position

        local TargetCFrame =
            CFrame.lookAt(
                CameraPosition,
                TargetPosition
            )

        local Speed =
            math.clamp(
                Settings.AimSpeed,
                0.01,
                1
            )

        Camera.CFrame =
            Camera.CFrame:Lerp(
                TargetCFrame,
                Speed
            )
    end
)

--========================================
-- TARGET INDICATOR
--========================================

local TargetIndicator =
    Instance.new("Frame")

TargetIndicator.Name =
    "TargetIndicator"

TargetIndicator.AnchorPoint =
    Vector2.new(0.5, 0.5)

TargetIndicator.Size =
    UDim2.fromOffset(8, 8)

TargetIndicator.BackgroundColor3 =
    Purple

TargetIndicator.BackgroundTransparency =
    0.15

TargetIndicator.BorderSizePixel =
    0

TargetIndicator.Visible =
    false

TargetIndicator.ZIndex =
    4

TargetIndicator.Parent =
    ScreenGui

local IndicatorCorner =
    Instance.new("UICorner")

IndicatorCorner.CornerRadius =
    UDim.new(1, 0)

IndicatorCorner.Parent =
    TargetIndicator

local IndicatorStroke =
    Instance.new("UIStroke")

IndicatorStroke.Color =
    Color3.fromRGB(
        240,
        210,
        255
    )

IndicatorStroke.Thickness =
    1.5

IndicatorStroke.Parent =
    TargetIndicator

--========================================
-- TARGET TRACKING
--========================================

RunService.RenderStepped:Connect(
    function()

        if not Settings.Enabled then

            TargetIndicator.Visible =
                false

            return
        end

        local Target =
            GetClosestTarget()

        if not Target then

            TargetIndicator.Visible =
                false

            return
        end

        local Position,
            Visible =
            Camera:WorldToViewportPoint(
                Target.Position
            )

        if Visible and Position.Z > 0 then

            TargetIndicator.Visible =
                true

            TargetIndicator.Position =
                UDim2.fromOffset(
                    Position.X,
                    Position.Y
                )

        else

            TargetIndicator.Visible =
                false
        end
    end
)

--========================================
-- ENABLE VISUAL STATE
--========================================

local function UpdateVisualState()

    if Settings.Enabled then

        FOVStroke.Color =
            Color3.fromRGB(
                190,
                90,
                255
            )

        FOVGlowStroke.Color =
            Color3.fromRGB(
                170,
                70,
                255
            )

    else

        FOVStroke.Color =
            Color3.fromRGB(
                120,
                75,
                160
            )

        FOVGlowStroke.Color =
            Color3.fromRGB(
                100,
                55,
                140
            )
    end
end

local OldAimButtonClick =
    AimButton.MouseButton1Click

-- Re-apply visual state when the button is used.
AimButton.MouseButton1Click:Connect(
    function()
        UpdateVisualState()
    end
)

UpdateVisualState()

print("Lunar Aim Assist loaded - Part 3")

--========================================
-- PART 4/4
--========================================

local IsMinimized = false
local Closing = false

local function SetContentVisible(state)
    for _, obj in ipairs(Main:GetChildren()) do
        if obj ~= TopBar
        and obj ~= LogoHolder
        and obj ~= Title
        and obj ~= Subtitle
        and obj ~= CloseButton
        and obj ~= MinimizeButton then

            if obj:IsA("GuiObject") then
                obj.Visible = state
            end
        end
    end
end

local function MinimizeMenu()
    if IsMinimized or Closing then
        return
    end

    IsMinimized = true

    SetContentVisible(false)

    TweenService:Create(
        Main,
        TweenInfo.new(
            0.45,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        {
            Size = UDim2.new(0, 72, 0, 72)
        }
    ):Play()

    TweenService:Create(
        LogoHolder,
        TweenInfo.new(
            0.35,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            Position = UDim2.new(0.5, -21, 0.5, -21)
        }
    ):Play()

    TweenService:Create(
        LogoHolder,
        TweenInfo.new(
            0.35,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            Size = UDim2.new(0, 42, 0, 42)
        }
    ):Play()

    TweenService:Create(
        Title,
        TweenInfo.new(0.2),
        {
            TextTransparency = 1
        }
    ):Play()

    TweenService:Create(
        Subtitle,
        TweenInfo.new(0.2),
        {
            TextTransparency = 1
        }
    ):Play()

    TweenService:Create(
        CloseButton,
        TweenInfo.new(0.2),
        {
            TextTransparency = 1
        }
    ):Play()

    TweenService:Create(
        MinimizeButton,
        TweenInfo.new(0.2),
        {
            TextTransparency = 1
        }
    ):Play()
end

local function RestoreMenu()
    if not IsMinimized or Closing then
        return
    end

    IsMinimized = false

    TweenService:Create(
        Main,
        TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        {
            Size = UDim2.new(0, 330, 0, 410)
        }
    ):Play()

    TweenService:Create(
        LogoHolder,
        TweenInfo.new(
            0.45,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            Position = UDim2.new(0, 15, 0.5, -20),
            Size = UDim2.new(0, 40, 0, 40)
        }
    ):Play()

    task.delay(0.2, function()
        if Closing then
            return
        end

        SetContentVisible(true)

        TweenService:Create(
            Title,
            TweenInfo.new(0.3),
            {
                TextTransparency = 0
            }
        ):Play()

        TweenService:Create(
            Subtitle,
            TweenInfo.new(0.3),
            {
                TextTransparency = 0
            }
        ):Play()

        TweenService:Create(
            CloseButton,
            TweenInfo.new(0.3),
            {
                TextTransparency = 0
            }
        ):Play()

        TweenService:Create(
            MinimizeButton,
            TweenInfo.new(0.3),
            {
                TextTransparency = 0
            }
        ):Play()
    end)
end

MinimizeButton.MouseButton1Click:Connect(function()
    MinimizeMenu()
end)

LogoHolder.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        if IsMinimized then
            RestoreMenu()
        end
    end
end)

local function CreateRipple(parent, position)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Position = UDim2.new(
        0,
        position.X,
        0,
        position.Y
    )
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
    ripple.BackgroundTransparency = 0.35
    ripple.BorderSizePixel = 0
    ripple.ZIndex = 50
    ripple.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple

    local tween = TweenService:Create(
        ripple,
        TweenInfo.new(
            0.55,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        {
            Size = UDim2.new(0, 180, 0, 180),
            BackgroundTransparency = 1
        }
    )

    tween:Play()

    tween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()

        local absolutePos = Main.AbsolutePosition

        CreateRipple(
            Main,
            Vector2.new(
                mousePos.X - absolutePos.X,
                mousePos.Y - absolutePos.Y
            )
        )
    end
end)

LogoHolder.MouseEnter:Connect(function()
    if IsMinimized then
        TweenService:Create(
            LogoHolder,
            TweenInfo.new(
                0.2,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                Size = UDim2.new(0, 47, 0, 47)
            }
        ):Play()
    end
end)

LogoHolder.MouseLeave:Connect(function()
    if IsMinimized then
        TweenService:Create(
            LogoHolder,
            TweenInfo.new(
                0.2,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                Size = UDim2.new(0, 42, 0, 42)
            }
        ):Play()
    end
end)

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(
        CloseButton,
        TweenInfo.new(0.15),
        {
            TextColor3 = Color3.fromRGB(255, 90, 120)
        }
    ):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(
        CloseButton,
        TweenInfo.new(0.15),
        {
            TextColor3 = Color3.fromRGB(200, 180, 220)
        }
    ):Play()
end)

MinimizeButton.MouseEnter:Connect(function()
    TweenService:Create(
        MinimizeButton,
        TweenInfo.new(0.15),
        {
            TextColor3 = Color3.fromRGB(190, 120, 255)
        }
    ):Play()
end)

MinimizeButton.MouseLeave:Connect(function()
    TweenService:Create(
        MinimizeButton,
        TweenInfo.new(0.15),
        {
            TextColor3 = Color3.fromRGB(200, 180, 220)
        }
    ):Play()
end)

local CenterDot = Instance.new("Frame")
CenterDot.Name = "CenterDot"
CenterDot.AnchorPoint = Vector2.new(0.5, 0.5)
CenterDot.Size = UDim2.new(0, 5, 0, 5)
CenterDot.BackgroundColor3 = Color3.fromRGB(190, 120, 255)
CenterDot.BackgroundTransparency = 0.1
CenterDot.BorderSizePixel = 0
CenterDot.ZIndex = 8
CenterDot.Parent = FOVCircle

local CenterDotCorner = Instance.new("UICorner")
CenterDotCorner.CornerRadius = UDim.new(1, 0)
CenterDotCorner.Parent = CenterDot

task.spawn(function()
    while ScreenGui.Parent do
        TweenService:Create(
            CenterDot,
            TweenInfo.new(
                0.7,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Size = UDim2.new(0, 8, 0, 8),
                BackgroundTransparency = 0.45
            }
        ):Play()

        task.wait(0.7)

        TweenService:Create(
            CenterDot,
            TweenInfo.new(
                0.7,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Size = UDim2.new(0, 5, 0, 5),
                BackgroundTransparency = 0.1
            }
        ):Play()

        task.wait(0.7)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    if Closing then
        return
    end

    Closing = true

    pcall(function()
        RunService:UnbindFromRenderStep("LunarAimAssist")
    end)

    TweenService:Create(
        Main,
        TweenInfo.new(
            0.4,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.In
        ),
        {
            Size = UDim2.new(0, 0, 0, 0)
        }
    ):Play()

    TweenService:Create(
        Main,
        TweenInfo.new(0.25),
        {
            BackgroundTransparency = 1
        }
    ):Play()

    TweenService:Create(
        Glow,
        TweenInfo.new(0.25),
        {
            ImageTransparency = 1
        }
    ):Play()

    TweenService:Create(
        FOVCircle,
        TweenInfo.new(0.25),
        {
            BackgroundTransparency = 1
        }
    ):Play()

    task.wait(0.45)

    if ScreenGui then
        ScreenGui:Destroy()
    end
end)

print("========================================")
print("Lunar Aim Assist loaded successfully")
print("Visible FOV: ON")
print("Animated UI: ON")
print("Aim Assist: READY")
print("========================================")
