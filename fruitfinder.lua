-- FRUIT RADAR — Roblox Studio prototype
-- GitHub-ready single-file UI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("FruitRadar")
if old then old:Destroy() end

local function New(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    o.Parent = parent
    return o
end

local function Corner(parent, radius)
    return New("UICorner", {CornerRadius = UDim.new(0, radius or 8)}, parent)
end

local function Stroke(parent, transparency)
    return New("UIStroke", {Transparency = transparency or 0.5, Thickness = 1}, parent)
end

local gui = New("ScreenGui", {
    Name = "FruitRadar", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

local main = New("Frame", {
    Size = UDim2.fromOffset(720, 470),
    Position = UDim2.new(.5, -360, .5, -235),
    BackgroundColor3 = Color3.fromRGB(14,16,22), BorderSizePixel = 0
}, gui)
Corner(main, 14); Stroke(main, .65)

local top = New("Frame", {Size = UDim2.new(1,0,0,72), BackgroundTransparency = 1}, main)
New("TextLabel", {
    Position = UDim2.fromOffset(22,10), Size = UDim2.fromOffset(400,30),
    BackgroundTransparency = 1, Text = "FRUIT RADAR", Font = Enum.Font.GothamBold,
    TextSize = 22, TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = Color3.fromRGB(245,247,255)
}, top)
New("TextLabel", {
    Position = UDim2.fromOffset(23,39), Size = UDim2.fromOffset(400,20),
    BackgroundTransparency = 1, Text = "Global Fruit Scanner • Studio Prototype",
    Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = Color3.fromRGB(135,141,158)
}, top)

local dot = New("Frame", {
    Position = UDim2.new(1,-130,0,25), Size = UDim2.fromOffset(9,9),
    BackgroundColor3 = Color3.fromRGB(70,220,135), BorderSizePixel = 0
}, top); Corner(dot,9)
local status = New("TextLabel", {
    Position = UDim2.new(1,-112,0,19), Size = UDim2.fromOffset(90,22),
    BackgroundTransparency = 1, Text = "ONLINE", Font = Enum.Font.GothamBold,
    TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = Color3.fromRGB(110,220,155)
}, top)

local dragging, dragStart, startPos = false, nil, nil
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)

local stats = New("Frame", {Position=UDim2.fromOffset(20,78),Size=UDim2.new(1,-40,0,76),BackgroundTransparency=1}, main)
local function stat(pos, label, value)
    local c = New("Frame", {Position=pos,Size=UDim2.fromOffset(210,68),BackgroundColor3=Color3.fromRGB(20,23,31),BorderSizePixel=0}, stats)
    Corner(c,10); Stroke(c,.82)
    New("TextLabel", {Position=UDim2.fromOffset(14,9),Size=UDim2.fromOffset(180,18),BackgroundTransparency=1,Text=label,Font=Enum.Font.Gotham,TextSize=11,TextColor3=Color3.fromRGB(130,137,153),TextXAlignment=Enum.TextXAlignment.Left},c)
    return New("TextLabel", {Position=UDim2.fromOffset(14,28),Size=UDim2.fromOffset(180,30),BackgroundTransparency=1,Text=value,Font=Enum.Font.GothamBold,TextSize=21,TextColor3=Color3.fromRGB(240,243,250),TextXAlignment=Enum.TextXAlignment.Left},c)
end
local serversValue=stat(UDim2.fromOffset(0,0),"SERVERS SCANNED","0")
local fruitsValue=stat(UDim2.fromOffset(220,0),"FRUITS FOUND","0")
local bestValue=stat(UDim2.fromOffset(440,0),"BEST FIND","None")

local results=New("Frame", {Position=UDim2.fromOffset(20,166),Size=UDim2.new(1,-40,0,225),BackgroundColor3=Color3.fromRGB(18,21,28),BorderSizePixel=0},main)
Corner(results,10); Stroke(results,.84)
New("TextLabel", {Position=UDim2.fromOffset(15,10),Size=UDim2.fromOffset(250,22),BackgroundTransparency=1,Text="FRUIT RADAR",Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Color3.fromRGB(224,228,238),TextXAlignment=Enum.TextXAlignment.Left},results)
local scroll=New("ScrollingFrame", {Position=UDim2.fromOffset(10,38),Size=UDim2.new(1,-20,1,-48),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,CanvasSize=UDim2.new()},results)
local layout=New("UIListLayout", {Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder},scroll)

local function addFruit(d)
    local c=New("Frame", {Size=UDim2.new(1,-5,0,58),BackgroundColor3=Color3.fromRGB(23,27,36),BorderSizePixel=0},scroll)
    Corner(c,8)
    New("TextLabel", {Position=UDim2.fromOffset(12,7),Size=UDim2.fromOffset(190,20),BackgroundTransparency=1,Text="🍈  "..d.name,Font=Enum.Font.GothamBold,TextSize=13,TextColor3=Color3.fromRGB(240,243,250),TextXAlignment=Enum.TextXAlignment.Left},c)
    New("TextLabel", {Position=UDim2.fromOffset(12,29),Size=UDim2.fromOffset(330,18),BackgroundTransparency=1,Text=d.sea.."  •  "..d.server,Font=Enum.Font.Gotham,TextSize=10,TextColor3=Color3.fromRGB(135,141,158),TextXAlignment=Enum.TextXAlignment.Left},c)
    New("TextLabel", {Position=UDim2.new(1,-250,0,8),Size=UDim2.fromOffset(235,18),BackgroundTransparency=1,Text="📍 "..d.position,Font=Enum.Font.Gotham,TextSize=10,TextColor3=Color3.fromRGB(160,166,182),TextXAlignment=Enum.TextXAlignment.Right},c)
    New("TextLabel", {Position=UDim2.new(1,-250,0,29),Size=UDim2.fromOffset(235,18),BackgroundTransparency=1,Text="VALUE  "..d.value,Font=Enum.Font.GothamBold,TextSize=10,TextColor3=Color3.fromRGB(110,220,155),TextXAlignment=Enum.TextXAlignment.Right},c)
    scroll.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+8)
end

local controls=New("Frame", {Position=UDim2.fromOffset(20,400),Size=UDim2.new(1,-40,0,52),BackgroundTransparency=1},main)
local function button(txt,pos,w)
    local b=New("TextButton", {Position=pos,Size=UDim2.fromOffset(w,42),BackgroundColor3=Color3.fromRGB(28,32,42),BorderSizePixel=0,AutoButtonColor=false,Text=txt,Font=Enum.Font.GothamBold,TextSize=11,TextColor3=Color3.fromRGB(225,229,239)},controls)
    Corner(b,8); Stroke(b,.82)
    b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(.15),{BackgroundColor3=Color3.fromRGB(38,43,55)}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(.15),{BackgroundColor3=Color3.fromRGB(28,32,42)}):Play() end)
    return b
end
local scan=button("🔎  SCAN",UDim2.fromOffset(0,0),180)
local best=button("⚡  BEST FIND",UDim2.fromOffset(190,0),180)
local esp=button("👁  ESP",UDim2.fromOffset(380,0),120)
local close=button("×",UDim2.new(1,-70,0,0),50)

local demo={
    {name="Dragon",sea="3rd Sea",server="8F29A1",position="124, 36, -892",value="10.0M"},
    {name="Dough",sea="2nd Sea",server="A71C42",position="-421, 18, 267",value="2.8M"},
    {name="Leopard",sea="3rd Sea",server="B42D19",position="731, 71, -144",value="5.0M"},
}
local function scanDemo()
    status.Text="SCANNING"; dot.BackgroundColor3=Color3.fromRGB(255,190,70)
    for _,x in ipairs(scroll:GetChildren()) do if x:IsA("Frame") then x:Destroy() end end
    for i,d in ipairs(demo) do
        task.wait(.08); serversValue.Text=tostring(i); fruitsValue.Text=tostring(i)
        addFruit(d)
        if i==1 then bestValue.Text=d.name end
    end
    status.Text="ONLINE"; dot.BackgroundColor3=Color3.fromRGB(70,220,135)
end
scan.MouseButton1Click:Connect(scanDemo)
best.MouseButton1Click:Connect(function() status.Text="BEST FIND: "..bestValue.Text end)
esp.MouseButton1Click:Connect(function() status.Text="ESP READY (STUDIO)" end)
close.MouseButton1Click:Connect(function() gui:Destroy() end)
task.defer(scanDemo)
