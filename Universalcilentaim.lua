--========================================
-- UNIVERSAL AIM ASSIST
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
    FOV = 300,
    TeamCheck = true,
    WallCheck = false,
    HitPart = "Head",
    Smoothness = 0.15,
    HoldToAim = false,
    AimKey = Enum.UserInputType.MouseButton2
}

local HoldingAim = false

--========================================
-- FOV CIRCLE
--========================================

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "AimAssistFOV"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Size = UDim2.fromOffset(Settings.FOV * 2, Settings.FOV * 2)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 0
FOVCircle.Visible = false
FOVCircle.Parent = LocalPlayer:WaitForChild("PlayerGui")

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Thickness = 1.5
FOVStroke.Transparency = 0.15
FOVStroke.Color = Color3.fromRGB(190, 80, 255)
FOVStroke.Parent = FOVCircle

--========================================
-- HELPERS
--========================================

local function GetCamera()
    Camera = workspace.CurrentCamera
    return Camera
end

local function IsAlive(player)
    if not player then
        return false
    end

    local character = player.Character
    if not character then
        return false
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    return humanoid and humanoid.Health > 0
end

local function IsFriendly(player)
    if not player or player == LocalPlayer then
        return true
    end

    if not Settings.TeamCheck then
        return false
    end

    if LocalPlayer.Team and player.Team then
        return LocalPlayer.Team == player.Team
    end

    return false
end

--========================================
-- WALL CHECK
--========================================

local function IsVisible(part)
    local camera = GetCamera()

    if not camera or not part then
        return false
    end

    local character = LocalPlayer.Character

    local origin = camera.CFrame.Position
    local direction = part.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {
        character
    }
    params.IgnoreWater = true

    local result = workspace:Raycast(
        origin,
        direction,
        params
    )

    if not result then
        return true
    end

    return result.Instance:IsDescendantOf(part.Parent)
end

--========================================
-- GET TARGET PART
--========================================

local function GetTargetPart(character)
    if not character then
        return nil
    end

    local preferred = character:FindFirstChild(Settings.HitPart)

    if preferred and preferred:IsA("BasePart") then
        return preferred
    end

    local fallback = character:FindFirstChild("HumanoidRootPart")

    if fallback and fallback:IsA("BasePart") then
        return fallback
    end

    return nil
end

--========================================
-- FIND CLOSEST TARGET
--========================================

local function GetClosestTarget()
    local camera = GetCamera()

    if not camera then
        return nil
    end

    local viewport = camera.ViewportSize

    local center = Vector2.new(
        viewport.X / 2,
        viewport.Y / 2
    )

    local closestPlayer = nil
    local closestPart = nil
    local closestDistance = Settings.FOV

    for _, player in ipairs(Players:GetPlayers()) do

        if player ~= LocalPlayer
            and IsAlive(player)
            and not IsFriendly(player) then

            local character = player.Character
            local part = GetTargetPart(character)

            if part then

                local screenPosition, onScreen =
                    camera:WorldToViewportPoint(part.Position)

                if onScreen and screenPosition.Z > 0 then

                    local screenPoint = Vector2.new(
                        screenPosition.X,
                        screenPosition.Y
                    )

                    local distance =
                        (screenPoint - center).Magnitude

                    if distance <= closestDistance then

                        local valid = true

                        if Settings.WallCheck then
                            valid = IsVisible(part)
                        end

                        if valid then
                            closestDistance = distance
                            closestPlayer = player
                            closestPart = part
                        end
                    end
                end
            end
        end
    end

    return closestPlayer, closestPart
end

--========================================
-- AIM STATE
--========================================

local function ShouldAim()
    if not Settings.Enabled then
        return false
    end

    if Settings.HoldToAim and not HoldingAim then
        return false
    end

    return true
end

--========================================
-- AIM UPDATE
--========================================

RunService.RenderStepped:Connect(function()

    local camera = GetCamera()

    if not camera then
        return
    end

    local viewport = camera.ViewportSize

    FOVCircle.Position = UDim2.fromOffset(
        viewport.X / 2,
        viewport.Y / 2
    )

    FOVCircle.Size = UDim2.fromOffset(
        Settings.FOV * 2,
        Settings.FOV * 2
    )

    FOVCircle.Visible = Settings.Enabled

    if not ShouldAim() then
        return
    end

    local _, targetPart = GetClosestTarget()

    if not targetPart then
        return
    end

    local targetPosition = targetPart.Position

    local targetCFrame = CFrame.lookAt(
        camera.CFrame.Position,
        targetPosition
    )

    camera.CFrame = camera.CFrame:Lerp(
        targetCFrame,
        math.clamp(Settings.Smoothness, 0.01, 1)
    )
end)

--========================================
-- INPUT
--========================================

UserInputService.InputBegan:Connect(function(input, processed)

    if processed then
        return
    end

    if input.UserInputType == Settings.AimKey then
        HoldingAim = true
    end
end)

UserInputService.InputEnded:Connect(function(input)

    if input.UserInputType == Settings.AimKey then
        HoldingAim = false
    end
end)

--========================================
-- PUBLIC CONTROLS
--========================================

getgenv().LunarAimAssist = {

    Toggle = function(state)
        Settings.Enabled = state == true
    end,

    SetFOV = function(value)
        Settings.FOV = math.clamp(
            tonumber(value) or 300,
            25,
            1000
        )
    end,

    SetSmoothness = function(value)
        Settings.Smoothness = math.clamp(
            tonumber(value) or 0.15,
            0.01,
            1
        )
    end,

    SetTeamCheck = function(state)
        Settings.TeamCheck = state == true
    end,

    SetWallCheck = function(state)
        Settings.WallCheck = state == true
    end,

    SetHitPart = function(part)
        if part == "Head"
            or part == "UpperTorso"
            or part == "Torso"
            or part == "HumanoidRootPart" then

            Settings.HitPart = part
        end
    end,

    SetHoldToAim = function(state)
        Settings.HoldToAim = state == true
    end,

    GetSettings = function()
        return Settings
    end
}

print("Universal Aim Assist loaded.")
