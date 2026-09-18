-- FRUIT RADAR — REAL CURRENT-SERVER SCANNER
-- Roblox Studio / an experience you control.
-- NO fake fruit data or fake values.
--
-- Expected:
-- Workspace
--   └─ Fruits
--       ├─ FruitObject
--       └─ ...
--
-- A fruit may be a BasePart or Model. The UI uses the object's
-- actual Name, position, and distance from the local character.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local FOLDER_NAME = "Fruits"
local SCAN_INTERVAL = 0.25
local ESP_ENABLED = true

local old = playerGui:FindFirstChild("FruitRadar")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "FruitRadar"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(760, 500)
main.Position = UDim2.new(0.5, -380, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(7, 18, 12)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

local ms = Instance.new("UIStroke", main)
ms.Color = Color3.fromRGB(60, 225, 120)
ms.Transparency = 0.65

local mg = Instance.new("UIGradient", main)
mg.Rotation = 90
mg.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(11, 32, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 12, 8))
})

local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 78)
top.BackgroundTransparency = 1
top.Parent = main

local title = Instance.new("TextLabel")
title.Position = UDim2.fromOffset(24, 13)
title.Size = UDim2.fromOffset(500, 30)
title.BackgroundTransparency = 1
title.Text = "FRUIT RADAR"
title.Font = Enum.Font.GothamBold
title.TextSize = 25
title.TextColor3 = Color3.fromRGB(232, 255, 239)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

local sub = Instance.new("TextLabel")
sub.Position = UDim2.fromOffset(25, 43)
sub.Size = UDim2.fromOffset(500, 20)
sub.BackgroundTransparency = 1
sub.Text = "CURRENT SERVER  •  REAL OBJECT SCANNER"
sub.Font = Enum.Font.GothamMedium
sub.TextSize = 10
sub.TextColor3 = Color3.fromRGB(100, 195, 130)
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.Parent = top

local dot = Instance.new("Frame")
dot.Position = UDim2.new(1, -128, 0, 29)
dot.Size = UDim2.fromOffset(10, 10)
dot.BackgroundColor3 = Color3.fromRGB(70, 235, 130)
dot.BorderSizePixel = 0
dot.Parent = top
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

local status = Instance.new("TextLabel")
status.Position = UDim2.new(1, -110, 0, 23)
status.Size = UDim2.fromOffset(90, 22)
status.BackgroundTransparency = 1
status.Text = "LIVE"
status.Font = Enum.Font.GothamBold
status.TextSize = 10
status.TextColor3 = Color3.fromRGB(105, 230, 145)
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = top

local function makeStat(x, label)
    local card = Instance.new("Frame")
    card.Position = UDim2.fromOffset(x, 85)
    card.Size = UDim2.fromOffset(220, 62)
    card.BackgroundColor3 = Color3.fromRGB(10, 27, 17)
    card.BorderSizePixel = 0
    card.Parent = main
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 11)

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Color3.fromRGB(45, 145, 78)
    stroke.Transparency = 0.55

    local l = Instance.new("TextLabel")
    l.Position = UDim2.fromOffset(13, 8)
    l.Size = UDim2.fromOffset(190, 17)
    l.BackgroundTransparency = 1
    l.Text = label
    l.Font = Enum.Font.GothamMedium
    l.TextSize = 10
    l.TextColor3 = Color3.fromRGB(110, 165, 125)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = card

    local v = Instance.new("TextLabel")
    v.Position = UDim2.fromOffset(13, 27)
    v.Size = UDim2.fromOffset(195, 27)
    v.BackgroundTransparency = 1
    v.Text = "0"
    v.Font = Enum.Font.GothamBold
    v.TextSize = 19
    v.TextColor3 = Color3.fromRGB(225, 255, 235)
    v.TextXAlignment = Enum.TextXAlignment.Left
    v.Parent = card

    return v
end

local fruitCount = makeStat(20, "FRUITS DETECTED")
local nearest = makeStat(260, "NEAREST FRUIT")
local scanState = makeStat(500, "SCAN STATUS")

local panel = Instance.new("Frame")
panel.Position = UDim2.fromOffset(20, 157)
panel.Size = UDim2.new(1, -40, 0, 275)
panel.BackgroundColor3 = Color3.fromRGB(7, 20, 12)
panel.BorderSizePixel = 0
panel.Parent = main
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 13)

local ps = Instance.new("UIStroke", panel)
ps.Color = Color3.fromRGB(38, 115, 65)
ps.Transparency = 0.6

local header = Instance.new("TextLabel")
header.Position = UDim2.fromOffset(16, 10)
header.Size = UDim2.fromOffset(300, 22)
header.BackgroundTransparency = 1
header.Text = "LIVE FRUIT OBJECTS"
header.Font = Enum.Font.GothamBold
header.TextSize = 11
header.TextColor3 = Color3.fromRGB(210, 247, 220)
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = panel

local scroll = Instance.new("ScrollingFrame")
scroll.Position = UDim2.fromOffset(10, 39)
scroll.Size = UDim2.new(1, -20, 1, -49)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(60, 195, 105)
scroll.CanvasSize = UDim2.fromOffset(0, 0)
scroll.Parent = panel

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

local espObjects = {}

local function positionOf(object)
    if object:IsA("BasePart") then
        return object.Position
    elseif object:IsA("Model") then
        return object:GetPivot().Position
    end
end

local function adorneeOf(object)
    if object:IsA("BasePart") then
        return object
    elseif object:IsA("Model") then
        return object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart", true)
    end
end

local function removeESP(object)
    if espObjects[object] then
        espObjects[object]:Destroy()
        espObjects[object] = nil
    end
end

local function addESP(object)
    if not ESP_ENABLED or espObjects[object] then return end
    local adornee = adorneeOf(object)
    if not adornee then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "FruitRadarESP"
    bb.Adornee = adornee
    bb.Size = UDim2.fromOffset(190, 42)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Parent = playerGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundColor3 = Color3.fromRGB(5, 25, 12)
    label.BackgroundTransparency = 0.12
    label.BorderSizePixel = 0
    label.Text = "🍈  " .. object.Name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(125, 255, 165)
    label.Parent = bb
    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", label)
    stroke.Color = Color3.fromRGB(65, 225, 110)
    stroke.Transparency = 0.35

    espObjects[object] = bb
end

local function clearCards()
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
end

local function addResult(data, order)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -5, 0, 56)
    card.BackgroundColor3 = Color3.fromRGB(10, 30, 17)
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.Parent = scroll
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Color3.fromRGB(43, 130, 70)
    stroke.Transparency = 0.65

    local name = Instance.new("TextLabel")
    name.Position = UDim2.fromOffset(12, 7)
    name.Size = UDim2.fromOffset(300, 20)
    name.BackgroundTransparency = 1
    name.Text = "🍈  " .. data.name
    name.Font = Enum.Font.GothamBold
    name.TextSize = 12
    name.TextColor3 = Color3.fromRGB(225, 255, 234)
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.Parent = card

    local p = Instance.new("TextLabel")
    p.Position = UDim2.fromOffset(12, 29)
    p.Size = UDim2.fromOffset(500, 18)
    p.BackgroundTransparency = 1
    p.Text = string.format("Position: %.0f, %.0f, %.0f", data.position.X, data.position.Y, data.position.Z)
    p.Font = Enum.Font.Gotham
    p.TextSize = 9
    p.TextColor3 = Color3.fromRGB(115, 165, 128)
    p.TextXAlignment = Enum.TextXAlignment.Left
    p.Parent = card

    local d = Instance.new("TextLabel")
    d.Position = UDim2.new(1, -180, 0, 18)
    d.Size = UDim2.fromOffset(165, 20)
    d.BackgroundTransparency = 1
    d.Text = tostring(data.distance) .. " studs"
    d.Font = Enum.Font.GothamBold
    d.TextSize = 10
    d.TextColor3 = Color3.fromRGB(105, 240, 145)
    d.TextXAlignment = Enum.TextXAlignment.Right
    d.Parent = card
end

local function getRoot()
    local character = player.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function scan()
    local folder = workspace:FindFirstChild(FOLDER_NAME)

    if not folder then
        clearCards()
        fruitCount.Text = "0"
        nearest.Text = "None"
        scanState.Text = "NO FOLDER"
        status.Text = "WAITING"
        dot.BackgroundColor3 = Color3.fromRGB(255, 190, 70)
        for object in pairs(espObjects) do removeESP(object) end
        return
    end

    local root = getRoot()
    local results = {}
    local seen = {}

    for _, object in ipairs(folder:GetChildren()) do
        local position = positionOf(object)
        if position then
            local distance = root and (root.Position - position).Magnitude or 0
            table.insert(results, {
                object = object,
                name = object.Name,
                position = position,
                distance = math.floor(distance + 0.5),
            })
            seen[object] = true
        end
    end

    table.sort(results, function(a, b)
        return a.distance < b.distance
    end)

    clearCards()

    for index, data in ipairs(results) do
        addResult(data, index)
        if ESP_ENABLED then addESP(data.object) end
    end

    for object in pairs(espObjects) do
        if not seen[object] then removeESP(object) end
    end

    fruitCount.Text = tostring(#results)
    nearest.Text = results[1] and results[1].name or "None"
    scanState.Text = "LIVE"
    status.Text = "LIVE"
    dot.BackgroundColor3 = Color3.fromRGB(70, 235, 130)
    scroll.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 8)
end

local controls = Instance.new("Frame")
controls.Position = UDim2.fromOffset(20, 443)
controls.Size = UDim2.new(1, -40, 0, 43)
controls.BackgroundTransparency = 1
controls.Parent = main

local function makeButton(text, x, width)
    local b = Instance.new("TextButton")
    b.Position = UDim2.fromOffset(x, 0)
    b.Size = UDim2.fromOffset(width, 39)
    b.BackgroundColor3 = Color3.fromRGB(12, 37, 21)
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.TextColor3 = Color3.fromRGB(205, 250, 218)
    b.Parent = controls
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)

    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(55, 165, 91)
    s.Transparency = 0.5

    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(20, 62, 35)
        }):Play()
    end)

    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(12, 37, 21)
        }):Play()
    end)

    return b
end

local rescan = makeButton("↻  RESCAN NOW", 0, 155)
local espToggle = makeButton("◉  ESP: ON", 165, 145)
local close = makeButton("×  CLOSE", 320, 120)

rescan.MouseButton1Click:Connect(scan)

espToggle.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    espToggle.Text = ESP_ENABLED and "◉  ESP: ON" or "○  ESP: OFF"

    if not ESP_ENABLED then
        for object in pairs(espObjects) do removeESP(object) end
    else
        scan()
    end
end)

close.MouseButton1Click:Connect(function()
    for object in pairs(espObjects) do removeESP(object) end
    gui:Destroy()
end)

local dragging = false
local dragStart
local startPosition

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

task.spawn(function()
    while gui.Parent do
        scan()
        task.wait(SCAN_INTERVAL)
    end
end)
