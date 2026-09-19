--========================================
-- PART 1 - CORE / UI
--========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    Enabled = false,
    FOV = 180,
    AimSpeed = 0.85,
    TeamCheck = true,
    WallCheck = false,
    TargetPart = "Head"
}

local Colors = {
    Background = Color3.fromRGB(17, 12, 24),
    Panel = Color3.fromRGB(25, 18, 35),
    Purple = Color3.fromRGB(175, 100, 255),
    PurpleDark = Color3.fromRGB(100, 50, 155),
    Text = Color3.fromRGB(235, 225, 245),
    SubText = Color3.fromRGB(150, 135, 165),
    Green = Color3.fromRGB(100, 255, 160),
    Red = Color3.fromRGB(255, 80, 110)
}

local function GetGuiParent()
    local success, hui = pcall(function()
        return gethui()
    end)

    if success and hui then
        return hui
    end

    local CoreGui = game:GetService("CoreGui")

    if CoreGui then
        return CoreGui
    end

    return LocalPlayer:WaitForChild("PlayerGui")
end

local GuiParent = GetGuiParent()

pcall(function()
    local old = GuiParent:FindFirstChild("LunarAimAssist")
    if old then
        old:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LunarAimAssist"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = GuiParent

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 330, 0, 410)
Main.Position = UDim2.new(0.5, -165, 0.5, -205)
Main.BackgroundColor3 = Colors.Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Colors.Purple
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.25
MainStroke.Parent = Main

local Glow = Instance.new("ImageLabel")
Glow.Name = "Glow"
Glow.AnchorPoint = Vector2.new(0.5, 0.5)
Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
Glow.Size = UDim2.new(1, 45, 1, 45)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://5028857084"
Glow.ImageColor3 = Colors.Purple
Glow.ImageTransparency = 0.82
Glow.ZIndex = 0
Glow.Parent = Main

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 65)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 10
TopBar.Parent = Main

local LogoButton = Instance.new("TextButton")
LogoButton.Name = "LogoButton"
LogoButton.Size = UDim2.new(0, 42, 0, 42)
LogoButton.Position = UDim2.new(0, 12, 0.5, -21)
LogoButton.BackgroundTransparency = 1
LogoButton.BorderSizePixel = 0
LogoButton.Text = "🌙"
LogoButton.TextSize = 29
LogoButton.Font = Enum.Font.GothamBold
LogoButton.TextColor3 = Color3.fromRGB(190, 145, 255)
LogoButton.AutoButtonColor = false
LogoButton.ZIndex = 20
LogoButton.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Position = UDim2.new(0, 60, 0, 13)
Title.Size = UDim2.new(1, -145, 0, 23)
Title.BackgroundTransparency = 1
Title.Text = "Lunar Aim Assist"
Title.TextColor3 = Colors.Text
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 20
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Position = UDim2.new(0, 60, 0, 35)
Subtitle.Size = UDim2.new(1, -145, 0, 18)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Smooth camera assistance"
Subtitle.TextColor3 = Colors.SubText
Subtitle.TextSize = 10
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 20
Subtitle.Parent = TopBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 34, 0, 34)
MinimizeButton.Position = UDim2.new(1, -75, 0.5, -17)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(200, 180, 220)
MinimizeButton.TextSize = 22
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.AutoButtonColor = false
MinimizeButton.ZIndex = 20
MinimizeButton.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 34, 0, 34)
CloseButton.Position = UDim2.new(1, -40, 0.5, -17)
CloseButton.BackgroundTransparency = 1
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(200, 180, 220)
CloseButton.TextSize = 24
CloseButton.Font = Enum.Font.GothamBold
CloseButton.AutoButtonColor = false
CloseButton.ZIndex = 20
CloseButton.Parent = TopBar

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Position = UDim2.new(0, 15, 0, 78)
Content.Size = UDim2.new(1, -30, 1, -90)
Content.BackgroundTransparency = 1
Content.ZIndex = 5
Content.Parent = Main

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = Content

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircle.Size = UDim2.new(
    0,
    Settings.FOV * 2,
    0,
    Settings.FOV * 2
)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 0
FOVCircle.ZIndex = 2
FOVCircle.Parent = ScreenGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Colors.Purple
FOVStroke.Thickness = 1.5
FOVStroke.Transparency = 0.25
FOVStroke.Parent = FOVCircle

local CenterDot = Instance.new("Frame")
CenterDot.Name = "CenterDot"
CenterDot.AnchorPoint = Vector2.new(0.5, 0.5)
CenterDot.Position = UDim2.new(0.5, 0, 0.5, 0)
CenterDot.Size = UDim2.new(0, 5, 0, 5)
CenterDot.BackgroundColor3 = Colors.Purple
CenterDot.BackgroundTransparency = 0.1
CenterDot.BorderSizePixel = 0
CenterDot.ZIndex = 5
CenterDot.Parent = FOVCircle

local CenterCorner = Instance.new("UICorner")
CenterCorner.CornerRadius = UDim.new(1, 0)
CenterCorner.Parent = CenterDot

Main.Size = UDim2.new(0, 0, 0, 0)

TweenService:Create(
    Main,
    TweenInfo.new(
        0.65,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ),
    {
        Size = UDim2.new(0, 330, 0, 410)
    }
):Play()

task.spawn(function()
    while ScreenGui.Parent do
        TweenService:Create(
            LogoButton,
            TweenInfo.new(
                1,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                TextColor3 = Color3.fromRGB(220, 180, 255),
                Rotation = 8
            }
        ):Play()

        task.wait(1)

        TweenService:Create(
            LogoButton,
            TweenInfo.new(
                1,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                TextColor3 = Color3.fromRGB(175, 125, 240),
                Rotation = -8
            }
        ):Play()

        task.wait(1)
    end
end)

--========================================
-- PART 2 - CONTROLS / DRAG
--========================================

local function CreateControlButton(name, text, order)

    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, 0, 0, 43)
    Button.BackgroundColor3 = Colors.Panel
    Button.BackgroundTransparency = 0.05
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Colors.Text
    Button.TextSize = 12
    Button.Font = Enum.Font.GothamMedium
    Button.AutoButtonColor = false
    Button.LayoutOrder = order
    Button.ZIndex = 6
    Button.Parent = Content

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 11)
    Corner.Parent = Button

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Colors.PurpleDark
    Stroke.Thickness = 1
    Stroke.Transparency = 0.35
    Stroke.Parent = Button

    Button.MouseEnter:Connect(function()

        TweenService:Create(
            Button,
            TweenInfo.new(0.15),
            {
                BackgroundColor3 =
                    Color3.fromRGB(35, 24, 48)
            }
        ):Play()

        TweenService:Create(
            Stroke,
            TweenInfo.new(0.15),
            {
                Color = Colors.Purple,
                Transparency = 0
            }
        ):Play()
    end)

    Button.MouseLeave:Connect(function()

        TweenService:Create(
            Button,
            TweenInfo.new(0.15),
            {
                BackgroundColor3 = Colors.Panel
            }
        ):Play()

        TweenService:Create(
            Stroke,
            TweenInfo.new(0.15),
            {
                Color = Colors.PurpleDark,
                Transparency = 0.35
            }
        ):Play()
    end)

    Button.MouseButton1Down:Connect(function()

        TweenService:Create(
            Button,
            TweenInfo.new(0.08),
            {
                Size = UDim2.new(1, -4, 0, 39)
            }
        ):Play()
    end)

    Button.MouseButton1Up:Connect(function()

        TweenService:Create(
            Button,
            TweenInfo.new(
                0.12,
                Enum.EasingStyle.Back,
                Enum.EasingDirection.Out
            ),
            {
                Size = UDim2.new(1, 0, 0, 43)
            }
        ):Play()
    end)

    return Button
end

local AimButton = CreateControlButton(
    "AimButton",
    "Aim Assist: OFF",
    1
)

local FOVButton = CreateControlButton(
    "FOVButton",
    "FOV: " .. Settings.FOV,
    2
)

local SpeedButton = CreateControlButton(
    "SpeedButton",
    "Aim Speed: " ..
    math.floor(Settings.AimSpeed * 100) ..
    "%",
    3
)

local TeamButton = CreateControlButton(
    "TeamButton",
    "Team Check: ON",
    4
)

local WallButton = CreateControlButton(
    "WallButton",
    "Wall Check: OFF",
    5
)

local TargetButton = CreateControlButton(
    "TargetButton",
    "Target: Head",
    6
)

AimButton.MouseButton1Click:Connect(function()

    Settings.Enabled = not Settings.Enabled

    AimButton.Text =
        "Aim Assist: " ..
        (Settings.Enabled and "ON" or "OFF")

    AimButton.TextColor3 =
        Settings.Enabled
        and Colors.Green
        or Colors.Text
end)

FOVButton.MouseButton1Click:Connect(function()

    local values = {
        100,
        140,
        180,
        220,
        260,
        320
    }

    local index = 1

    for i, value in ipairs(values) do
        if value == Settings.FOV then
            index = i
            break
        end
    end

    index += 1

    if index > #values then
        index = 1
    end

    Settings.FOV = values[index]

    FOVButton.Text =
        "FOV: " .. Settings.FOV

    TweenService:Create(
        FOVCircle,
        TweenInfo.new(
            0.25,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            Size = UDim2.new(
                0,
                Settings.FOV * 2,
                0,
                Settings.FOV * 2
            )
        }
    ):Play()
end)

SpeedButton.MouseButton1Click:Connect(function()

    local values = {
        0.35,
        0.50,
        0.65,
        0.80,
        0.95,
        1
    }

    local index = 1

    for i, value in ipairs(values) do
        if value == Settings.AimSpeed then
            index = i
            break
        end
    end

    index += 1

    if index > #values then
        index = 1
    end

    Settings.AimSpeed = values[index]

    SpeedButton.Text =
        "Aim Speed: " ..
        math.floor(Settings.AimSpeed * 100) ..
        "%"
end)

TeamButton.MouseButton1Click:Connect(function()

    Settings.TeamCheck = not Settings.TeamCheck

    TeamButton.Text =
        "Team Check: " ..
        (Settings.TeamCheck and "ON" or "OFF")

    TeamButton.TextColor3 =
        Settings.TeamCheck
        and Colors.Green
        or Colors.Text
end)

WallButton.MouseButton1Click:Connect(function()

    Settings.WallCheck = not Settings.WallCheck

    WallButton.Text =
        "Wall Check: " ..
        (Settings.WallCheck and "ON" or "OFF")

    WallButton.TextColor3 =
        Settings.WallCheck
        and Colors.Green
        or Colors.Text
end)

TargetButton.MouseButton1Click:Connect(function()

    if Settings.TargetPart == "Head" then
        Settings.TargetPart = "HumanoidRootPart"
    else
        Settings.TargetPart = "Head"
    end

    TargetButton.Text =
        "Target: " ..
        Settings.TargetPart
end)

--========================================
-- MAIN WINDOW DRAG
--========================================

local Dragging = false
local DragStart = nil
local StartPosition = nil

TopBar.InputBegan:Connect(function(input)

    if IsMinimized then
        return
    end

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
    or input.UserInputType ==
        Enum.UserInputType.Touch then

        Dragging = true
        DragStart = input.Position
        StartPosition = Main.Position
    end
end)

TopBar.InputEnded:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
    or input.UserInputType ==
        Enum.UserInputType.Touch then

        Dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not Dragging then
        return
    end

    if input.UserInputType ~=
        Enum.UserInputType.MouseMovement
    and input.UserInputType ~=
        Enum.UserInputType.Touch then
        return
    end

    local Delta =
        input.Position - DragStart

    Main.Position = UDim2.new(
        StartPosition.X.Scale,
        StartPosition.X.Offset + Delta.X,
        StartPosition.Y.Scale,
        StartPosition.Y.Offset + Delta.Y
    )
end)

--========================================
-- FOV ANIMATION
--========================================

task.spawn(function()

    while ScreenGui.Parent do

        TweenService:Create(
            FOVStroke,
            TweenInfo.new(
                0.8,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Transparency = 0.55,
                Thickness = 2
            }
        ):Play()

        TweenService:Create(
            CenterDot,
            TweenInfo.new(
                0.8,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Size = UDim2.new(0, 8, 0, 8)
            }
        ):Play()

        task.wait(0.8)

        TweenService:Create(
            FOVStroke,
            TweenInfo.new(
                0.8,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Transparency = 0.2,
                Thickness = 1.5
            }
        ):Play()

        TweenService:Create(
            CenterDot,
            TweenInfo.new(
                0.8,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Size = UDim2.new(0, 5, 0, 5)
            }
        ):Play()

        task.wait(0.8)
    end
end)

--========================================
-- PART 3 - TARGET / TEAM CHECK / MINIMIZE
--========================================

local function IsEnemy(player)

    if not player or player == LocalPlayer then
        return false
    end

    if not Settings.TeamCheck then
        return true
    end

    -- Normal Roblox team check
    if LocalPlayer.Team ~= nil
    and player.Team ~= nil then

        return LocalPlayer.Team ~= player.Team
    end

    -- TeamColor fallback
    if LocalPlayer.TeamColor ~= nil
    and player.TeamColor ~= nil then

        return LocalPlayer.TeamColor ~= player.TeamColor
    end

    -- If the game has no team information,
    -- don't incorrectly classify everyone
    -- as a teammate.
    return true
end

local function IsAlive(player)

    if not player then
        return false
    end

    local character = player.Character

    if not character then
        return false
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    return humanoid ~= nil
        and humanoid.Health > 0
end

local function CanSeePart(part)

    if not Settings.WallCheck then
        return true
    end

    if not part then
        return false
    end

    local origin =
        Camera.CFrame.Position

    local direction =
        part.Position - origin

    local params =
        RaycastParams.new()

    params.FilterType =
        Enum.RaycastFilterType.Exclude

    params.FilterDescendantsInstances = {
        LocalPlayer.Character,
        Camera
    }

    params.IgnoreWater = true

    local result =
        workspace:Raycast(
            origin,
            direction,
            params
        )

    if not result then
        return true
    end

    return result.Instance:IsDescendantOf(
        part.Parent
    )
end

local function GetTargetPart(character)

    if not character then
        return nil
    end

    local preferred =
        character:FindFirstChild(
            Settings.TargetPart
        )

    if preferred then
        return preferred
    end

    return character:FindFirstChild("Head")
        or character:FindFirstChild(
            "HumanoidRootPart"
        )
end

local function GetClosestTarget()

    local closestPlayer = nil
    local closestPart = nil
    local closestDistance = Settings.FOV

    Camera = workspace.CurrentCamera

    if not Camera then
        return nil, nil
    end

    local viewport =
        Camera.ViewportSize

    local center = Vector2.new(
        viewport.X / 2,
        viewport.Y / 2
    )

    for _, player in ipairs(
        Players:GetPlayers()
    ) do

        if IsEnemy(player)
        and IsAlive(player) then

            local part =
                GetTargetPart(
                    player.Character
                )

            if part then

                local position, visible =
                    Camera:WorldToViewportPoint(
                        part.Position
                    )

                if visible and position.Z > 0 then

                    local distance =
                        (
                            Vector2.new(
                                position.X,
                                position.Y
                            ) - center
                        ).Magnitude

                    if distance <= closestDistance
                    and CanSeePart(part) then

                        closestDistance = distance
                        closestPlayer = player
                        closestPart = part
                    end
                end
            end
        end
    end

    return closestPlayer, closestPart
end

local TargetIndicator = Instance.new("Frame")
TargetIndicator.Name = "TargetIndicator"
TargetIndicator.AnchorPoint = Vector2.new(0.5, 0.5)
TargetIndicator.Size = UDim2.new(0, 8, 0, 8)
TargetIndicator.BackgroundColor3 = Colors.Purple
TargetIndicator.BackgroundTransparency = 1
TargetIndicator.BorderSizePixel = 0
TargetIndicator.ZIndex = 20
TargetIndicator.Parent = ScreenGui

local TargetCorner = Instance.new("UICorner")
TargetCorner.CornerRadius = UDim.new(1, 0)
TargetCorner.Parent = TargetIndicator

local TargetStroke = Instance.new("UIStroke")
TargetStroke.Color = Colors.Purple
TargetStroke.Thickness = 2
TargetStroke.Transparency = 1
TargetStroke.Parent = TargetIndicator

RunService:BindToRenderStep(
    "LunarAimAssist",
    Enum.RenderPriority.Camera.Value + 1,
    function()

        Camera = workspace.CurrentCamera

        if not Camera then
            return
        end

        local viewport =
            Camera.ViewportSize

        FOVCircle.Position = UDim2.new(
            0,
            viewport.X / 2,
            0,
            viewport.Y / 2
        )

        if not Settings.Enabled then

            TargetIndicator.BackgroundTransparency = 1
            TargetStroke.Transparency = 1

            return
        end

        local targetPlayer, targetPart =
            GetClosestTarget()

        if not targetPlayer
        or not targetPart then

            TargetIndicator.BackgroundTransparency = 1
            TargetStroke.Transparency = 1

            return
        end

        local position, visible =
            Camera:WorldToViewportPoint(
                targetPart.Position
            )

        if not visible
        or position.Z <= 0 then

            TargetIndicator.BackgroundTransparency = 1
            TargetStroke.Transparency = 1

            return
        end

        TargetIndicator.Position =
            UDim2.new(
                0,
                position.X,
                0,
                position.Y
            )

        TargetIndicator.BackgroundTransparency = 0.15
        TargetStroke.Transparency = 0

        local cameraPosition =
            Camera.CFrame.Position

        local desired =
            CFrame.lookAt(
                cameraPosition,
                targetPart.Position
            )

        Camera.CFrame =
            Camera.CFrame:Lerp(
                desired,
                math.clamp(
                    Settings.AimSpeed,
                    0,
                    1
                )
            )
    end
)

--========================================
-- MINIMIZE / RESTORE
--========================================

local IsMinimized = false
local Closing = false

local FullSize =
    UDim2.new(0, 330, 0, 410)

local MiniSize =
    UDim2.new(0, 64, 0, 64)

local function SetContentVisible(state)

    Content.Visible = state

    Title.Visible = state
    Subtitle.Visible = state
    CloseButton.Visible = state
    MinimizeButton.Visible = state
end

local function MinimizeMenu()

    if IsMinimized or Closing then
        return
    end

    IsMinimized = true

    SetContentVisible(false)

    -- TopBar becomes the complete mini window
    TopBar.Size =
        UDim2.new(1, 0, 1, 0)

    TweenService:Create(
        Main,
        TweenInfo.new(
            0.45,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        {
            Size = MiniSize
        }
    ):Play()

    TweenService:Create(
        LogoButton,
        TweenInfo.new(
            0.45,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            Position =
                UDim2.new(
                    0.5,
                    -26,
                    0.5,
                    -26
                ),

            Size =
                UDim2.new(
                    0,
                    52,
                    0,
                    52
                ),

            TextSize = 32
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
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            Size = FullSize
        }
    ):Play()

    TweenService:Create(
        LogoButton,
        TweenInfo.new(
            0.4,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            Position =
                UDim2.new(
                    0,
                    12,
                    0.5,
                    -21
                ),

            Size =
                UDim2.new(
                    0,
                    42,
                    0,
                    42
                ),

            TextSize = 29
        }
    ):Play()

    task.delay(0.2, function()

        if Closing then
            return
        end

        TopBar.Size =
            UDim2.new(
                1,
                0,
                0,
                65
            )

        SetContentVisible(true)
    end)
end

MinimizeButton.MouseButton1Click:Connect(
    MinimizeMenu
)

LogoButton.MouseButton1Click:Connect(function()

    if IsMinimized then
        RestoreMenu()
    end
end)

--========================================
-- MINI WINDOW DRAG
--========================================

local MiniDragging = false
local MiniDragStart = nil
local MiniStartPosition = nil

TopBar.InputBegan:Connect(function(input)

    if not IsMinimized then
        return
    end

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
    or input.UserInputType ==
        Enum.UserInputType.Touch then

        MiniDragging = true
        MiniDragStart = input.Position
        MiniStartPosition = Main.Position
    end
end)

TopBar.InputEnded:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
    or input.UserInputType ==
        Enum.UserInputType.Touch then

        MiniDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not IsMinimized
    or not MiniDragging then
        return
    end

    if input.UserInputType ~=
        Enum.UserInputType.MouseMovement
    and input.UserInputType ~=
        Enum.UserInputType.Touch then
        return
    end

    local delta =
        input.Position - MiniDragStart

    Main.Position = UDim2.new(
        MiniStartPosition.X.Scale,
        MiniStartPosition.X.Offset + delta.X,

        MiniStartPosition.Y.Scale,
        MiniStartPosition.Y.Offset + delta.Y
    )
end)

--========================================
-- BUTTON EFFECTS
--========================================

LogoButton.MouseEnter:Connect(function()

    TweenService:Create(
        LogoButton,
        TweenInfo.new(0.15),
        {
            TextSize =
                IsMinimized and 36 or 32,

            TextColor3 =
                Color3.fromRGB(
                    225,
                    190,
                    255
                )
        }
    ):Play()
end)

LogoButton.MouseLeave:Connect(function()

    TweenService:Create(
        LogoButton,
        TweenInfo.new(0.15),
        {
            TextSize =
                IsMinimized and 32 or 29,

            TextColor3 =
                Color3.fromRGB(
                    190,
                    145,
                    255
                )
        }
    ):Play()
end)

MinimizeButton.MouseEnter:Connect(function()

    TweenService:Create(
        MinimizeButton,
        TweenInfo.new(0.15),
        {
            TextColor3 = Colors.Purple,
            TextSize = 27
        }
    ):Play()
end)

MinimizeButton.MouseLeave:Connect(function()

    TweenService:Create(
        MinimizeButton,
        TweenInfo.new(0.15),
        {
            TextColor3 =
                Color3.fromRGB(
                    200,
                    180,
                    220
                ),

            TextSize = 22
        }
    ):Play()
end)

CloseButton.MouseEnter:Connect(function()

    TweenService:Create(
        CloseButton,
        TweenInfo.new(0.15),
        {
            TextColor3 = Colors.Red,
            TextSize = 29
        }
    ):Play()
end)

CloseButton.MouseLeave:Connect(function()

    TweenService:Create(
        CloseButton,
        TweenInfo.new(0.15),
        {
            TextColor3 =
                Color3.fromRGB(
                    200,
                    180,
                    220
                ),

            TextSize = 24
        }
    ):Play()
end)

--========================================
-- CLOSE / CLEANUP
--========================================

CloseButton.MouseButton1Click:Connect(function()

    if Closing then
        return
    end

    Closing = true

    pcall(function()
        RunService:UnbindFromRenderStep(
            "LunarAimAssist"
        )
    end)

    TweenService:Create(
        Main,
        TweenInfo.new(
            0.4,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.In
        ),
        {
            Size =
                UDim2.new(0, 0, 0, 0)
        }
    ):Play()

    TweenService:Create(
        FOVStroke,
        TweenInfo.new(0.25),
        {
            Transparency = 1
        }
    ):Play()

    task.wait(0.45)

    if ScreenGui then
        ScreenGui:Destroy()
    end
end)

print("========================================")
print("Lunar Aim Assist loaded")
print("Visible FOV: ON")
print("Team Check: ON")
print("Wall Check: OFF")
print("Minimize: READY")
print("Moon Logo: READY")
print("========================================")

--========================================
-- MINI LOGO DRAG FIX
--========================================

local MiniDragging = false
local MiniDragMoved = false
local MiniDragStart
local MiniStartPosition
local MiniDragInput

local function UpdateMiniDrag(input)
    local Delta = input.Position - MiniDragStart

    if math.abs(Delta.X) > 5 or math.abs(Delta.Y) > 5 then
        MiniDragMoved = true
    end

    if MiniDragging then
        Main.Position = UDim2.new(
            MiniStartPosition.X.Scale,
            MiniStartPosition.X.Offset + Delta.X,
            MiniStartPosition.Y.Scale,
            MiniStartPosition.Y.Offset + Delta.Y
        )
    end
end

LogoButton.InputBegan:Connect(function(Input)
    if not Main:GetAttribute("Minimized") then
        return
    end

    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then

        MiniDragging = true
        MiniDragMoved = false
        MiniDragStart = Input.Position
        MiniStartPosition = Main.Position

        MiniDragInput = Input
    end
end)

LogoButton.InputChanged:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseMovement
    or Input.UserInputType == Enum.UserInputType.Touch then

        MiniDragInput = Input
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Input == MiniDragInput and MiniDragging then
        UpdateMiniDrag(Input)
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then

        if MiniDragging then
            MiniDragging = false

            if not MiniDragMoved then
                Main:SetAttribute("Minimized", false)

                TweenService:Create(
                    Main,
                    TweenInfo.new(
                        0.45,
                        Enum.EasingStyle.Back,
                        Enum.EasingDirection.Out
                    ),
                    {
                        Size = FullSize
                    }
                ):Play()

                task.delay(0.12, function()
                    if Main:GetAttribute("Minimized") == false then
                        SetContentVisible(true)

                        TopBar.Size = UDim2.new(1, 0, 0, 65)

                        LogoButton.Size = UDim2.new(0, 42, 0, 42)
                        LogoButton.Position = UDim2.new(0, 12, 0.5, -21)

                        Title.Visible = true
                        Subtitle.Visible = true
                        MinimizeButton.Visible = true
                        CloseButton.Visible = true
                    end
                end)
            end
        end
    end
end)

Main:SetAttribute("Minimized", false)
