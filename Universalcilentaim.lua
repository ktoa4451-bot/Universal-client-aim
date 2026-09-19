--========================================
-- LUNAR AIM ASSIST
--========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--========================================
-- SETTINGS
--========================================

local Settings = {
    Enabled = false,
    FOV = 180,
    Smoothness = 0.18,
    TeamCheck = true,
    WallCheck = false,
    TargetPart = "Head",
    HoldToAim = false,
    AimKey = Enum.UserInputType.MouseButton2
}

--========================================
-- GUI PARENT
--========================================

local function GetGuiParent()
    local parent

    pcall(function()
        if typeof(gethui) == "function" then
            parent = gethui()
        end
    end)

    if not parent then
        pcall(function()
            parent = game:GetService("CoreGui")
        end)
    end

    if not parent then
        parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    return parent
end

local GuiParent = GetGuiParent()

pcall(function()
    local old = GuiParent:FindFirstChild("LunarAimAssist")
    if old then
        old:Destroy()
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
-- FOV CIRCLE
--========================================

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOV"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.Size = UDim2.fromOffset(Settings.FOV * 2, Settings.FOV * 2)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = true
FOVCircle.ZIndex = 2
FOVCircle.Parent = ScreenGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Thickness = 2
FOVStroke.Color = Color3.fromRGB(180, 80, 255)
FOVStroke.Transparency = 0.15
FOVStroke.Parent = FOVCircle

--========================================
-- MAIN MENU
--========================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(310, 370)
Main.Position = UDim2.new(0.5, -155, 0.5, -185)
Main.BackgroundColor3 = Color3.fromRGB(16, 15, 23)
Main.BorderSizePixel = 0
Main.Active = true
Main.ZIndex = 10
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(150, 65, 220)
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

--========================================
-- TITLE
--========================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 0, 45)
Title.Position = UDim2.fromOffset(18, 5)
Title.BackgroundTransparency = 1
Title.Text = "LUNAR AIM ASSIST"
Title.TextColor3 = Color3.fromRGB(235, 225, 255)
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 11
Title.Parent = Main

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -40, 0, 22)
Subtitle.Position = UDim2.fromOffset(18, 38)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Camera targeting system"
Subtitle.TextColor3 = Color3.fromRGB(145, 140, 160)
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 11
Subtitle.Parent = Main

--========================================
-- CLOSE BUTTON
--========================================

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(30, 30)
Close.Position = UDim2.new(1, -38, 0, 9)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 100, 120)
Close.TextSize = 22
Close.Font = Enum.Font.GothamBold
Close.ZIndex = 12
Close.Parent = Main

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

--========================================
-- MINIMIZE
--========================================

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(30, 30)
Minimize.Position = UDim2.new(1, -70, 0, 9)
Minimize.BackgroundTransparency = 1
Minimize.Text = "−"
Minimize.TextColor3 = Color3.fromRGB(220, 210, 235)
Minimize.TextSize = 20
Minimize.Font = Enum.Font.GothamBold
Minimize.ZIndex = 12
Minimize.Parent = Main

local NormalSize = Main.Size
local Minimized = false

Minimize.MouseButton1Click:Connect(function()

    Minimized = not Minimized

    if Minimized then

        for _, obj in ipairs(Main:GetChildren()) do
            if obj:IsA("GuiObject")
                and obj ~= MainCorner
                and obj ~= MainStroke
                and obj ~= Title
                and obj ~= Close
                and obj ~= Minimize then

                obj.Visible = false
            end
        end

        Main.Size = UDim2.fromOffset(310, 48)
        Minimize.Text = "+"

    else

        Main.Size = NormalSize

        for _, obj in ipairs(Main:GetChildren()) do
            if obj:IsA("GuiObject") then
                obj.Visible = true
            end
        end

        Minimize.Text = "−"
    end
end)

--========================================
-- DRAG
--========================================

local Dragging = false
local DragStart
local StartPosition

Title.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = input.Position
        StartPosition = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not Dragging then return end

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
-- BUTTON CREATOR
--========================================

local function CreateButton(text, y)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -36, 0, 42)
    Button.Position = UDim2.fromOffset(18, y)
    Button.BackgroundColor3 = Color3.fromRGB(27, 25, 36)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(225, 220, 235)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamMedium
    Button.ZIndex = 11
    Button.Parent = Main

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 9)
    Corner.Parent = Button

    return Button
end

--========================================
-- AIM TOGGLE
--========================================

local AimButton = CreateButton("Aim Assist: OFF", 72)

local function UpdateAimButton()

    if Settings.Enabled then
        AimButton.Text = "Aim Assist: ON"
        AimButton.BackgroundColor3 = Color3.fromRGB(85, 45, 120)
    else
        AimButton.Text = "Aim Assist: OFF"
        AimButton.BackgroundColor3 = Color3.fromRGB(27, 25, 36)
    end
end

AimButton.MouseButton1Click:Connect(function()
    Settings.Enabled = not Settings.Enabled
    UpdateAimButton()
end)

--========================================
-- FOV CONTROL
--========================================

local FOVButton = CreateButton("FOV: " .. Settings.FOV, 122)

FOVButton.MouseButton1Click:Connect(function()

    Settings.FOV += 25

    if Settings.FOV > 500 then
        Settings.FOV = 50
    end

    FOVButton.Text = "FOV: " .. Settings.FOV

    FOVCircle.Size =
        UDim2.fromOffset(Settings.FOV * 2, Settings.FOV * 2)
end)

--========================================
-- SMOOTHNESS
--========================================

local SmoothButton =
    CreateButton("Smoothness: " .. Settings.Smoothness, 172)

SmoothButton.MouseButton1Click:Connect(function()

    Settings.Smoothness += 0.05

    if Settings.Smoothness > 0.8 then
        Settings.Smoothness = 0.05
    end

    Settings.Smoothness =
        math.floor(Settings.Smoothness * 100) / 100

    SmoothButton.Text =
        "Smoothness: " .. Settings.Smoothness
end)

--========================================
-- TEAM CHECK
--========================================

local TeamButton =
    CreateButton("Team Check: ON", 222)

TeamButton.MouseButton1Click:Connect(function()

    Settings.TeamCheck = not Settings.TeamCheck

    TeamButton.Text =
        "Team Check: " ..
        (Settings.TeamCheck and "ON" or "OFF")
end)

--========================================
-- WALL CHECK
--========================================

local WallButton =
    CreateButton("Wall Check: OFF", 272)

WallButton.MouseButton1Click:Connect(function()

    Settings.WallCheck = not Settings.WallCheck

    WallButton.Text =
        "Wall Check: " ..
        (Settings.WallCheck and "ON" or "OFF")
end)

--========================================
-- TARGET CHECK
--========================================

local TargetButton =
    CreateButton("Target: HEAD", 322)

TargetButton.MouseButton1Click:Connect(function()

    if Settings.TargetPart == "Head" then
        Settings.TargetPart = "UpperTorso"
    elseif Settings.TargetPart == "UpperTorso" then
        Settings.TargetPart = "HumanoidRootPart"
    else
        Settings.TargetPart = "Head"
    end

    TargetButton.Text =
        "Target: " ..
        string.upper(Settings.TargetPart)
end)

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
-- WALL CHECK
--========================================

local function CanSeePart(Part)

    if not Settings.WallCheck then
        return true
    end

    local Character = LocalPlayer.Character

    if not Character then
        return false
    end

    local Origin = Camera.CFrame.Position
    local Direction = Part.Position - Origin

    local Params = RaycastParams.new()
    Params.FilterType = Enum.RaycastFilterType.Exclude
    Params.FilterDescendantsInstances = {
        Character
    }

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

--========================================
-- FIND TARGET
--========================================

local function GetClosestTarget()

    local Character = LocalPlayer.Character

    if not Character then
        return nil
    end

    local Center =
        Vector2.new(
            Camera.ViewportSize.X / 2,
            Camera.ViewportSize.Y / 2
        )

    local Closest = nil
    local ClosestDistance = Settings.FOV

    for _, Player in ipairs(Players:GetPlayers()) do

        if IsEnemy(Player) then

            local TargetCharacter = Player.Character

            if TargetCharacter then

                local Humanoid =
                    TargetCharacter:FindFirstChildOfClass("Humanoid")

                local Part =
                    TargetCharacter:FindFirstChild(Settings.TargetPart)

                if Humanoid
                    and Humanoid.Health > 0
                    and Part
                    and Part:IsA("BasePart") then

                    local ScreenPosition, OnScreen =
                        Camera:WorldToViewportPoint(
                            Part.Position
                        )

                    if OnScreen and ScreenPosition.Z > 0 then

                        local Distance =
                            (
                                Vector2.new(
                                    ScreenPosition.X,
                                    ScreenPosition.Y
                                ) - Center
                            ).Magnitude

                        if Distance <= ClosestDistance then

                            if CanSeePart(Part) then
                                ClosestDistance = Distance
                                Closest = Part
                            end
                        end
                    end
                end
            end
        end
    end

    return Closest
end

--========================================
-- AIM SYSTEM
--========================================

local HoldingAim = false

UserInputService.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton2 then

        HoldingAim = true
    end
end)

UserInputService.InputEnded:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton2 then

        HoldingAim = false
    end
end)

RunService.RenderStepped:Connect(function()

    FOVCircle.Visible = true

    FOVCircle.Size =
        UDim2.fromOffset(
            Settings.FOV * 2,
            Settings.FOV * 2
        )

    if not Settings.Enabled then
        return
    end

    if Settings.HoldToAim and not HoldingAim then
        return
    end

    local Target = GetClosestTarget()

    if not Target then
        return
    end

    local CameraPosition = Camera.CFrame.Position

    local TargetCFrame =
        CFrame.lookAt(
            CameraPosition,
            Target.Position
        )

    Camera.CFrame =
        Camera.CFrame:Lerp(
            TargetCFrame,
            Settings.Smoothness
        )
end)

--========================================
-- LOADED
--========================================

print("Lunar Aim Assist loaded.")
