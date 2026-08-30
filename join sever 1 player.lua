--==================================================
-- NGUEYN DUY XG - SERVER HOP ✅ MENU CŨ KÉO ĐƯỢC NỮA
--==================================================

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- ========= CÀI ĐẶT =========
local DRAG_SMOOTH = 0.4 -- Tốc độ kéo (nhỏ = chậm hơn)

--==================================================
-- SERVER HOP
--==================================================
local function ServerHop()
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local selServer, cursor = nil, nil

    local function getServers(c)
        local ok, data = pcall(function() return game:HttpGet(url..(c and "&cursor="..c or "")) end)
        if not ok then return {data={}} end
        return HttpService:JSONDecode(data)
    end

    repeat
        local list = getServers(cursor)
        if list.data and #list.data>0 then selServer = list.data[math.random(#list.data)] end
        cursor = list.nextPageCursor
    until selServer

    if selServer and selServer.playing < selServer.maxPlayers and selServer.id~=game.JobId then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, Player)
    end
end

--==================================================
-- GUI
--==================================================
local Gui = Instance.new("ScreenGui")
Gui.Name = "NDXG"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = game:GetService("CoreGui")

--==================================================
-- NÚT NỔI - KÉO ĐƯỢC
--==================================================
local Btn = Instance.new("TextButton")
Btn.Name = "FloatBtn"
Btn.Parent = Gui
Btn.Size = UDim2.new(0, 50, 0, 50)
Btn.Position = UDim2.new(0.02, 0, 0.5, -25)
Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Btn.Text = "😀"
Btn.TextColor3 = Color3.new(1,1,1)
Btn.TextSize = 24
Btn.Font = Enum.Font.GothamBold
Btn.AutoLocalize = false
Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)

-- === KÉO NÚT ===
local btnDrag, btnStartPos, btnStartPosUdim = false, Vector2.new(), UDim2.new()
local btnCX, btnCY = Btn.Position.X.Offset, Btn.Position.Y.Offset

Btn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        btnDrag = true
        btnStartPos = i.Position
        btnStartPosUdim = Btn.Position
        btnCX, btnCY = btnStartPosUdim.X.Offset, btnStartPosUdim.Y.Offset
    end
end)

UIS.InputChanged:Connect(function(i)
    if not btnDrag then return end
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement then
        local tx = btnStartPosUdim.X.Offset + (i.Position.X - btnStartPos.X)
        local ty = btnStartPosUdim.Y.Offset + (i.Position.Y - btnStartPos.Y)
        btnCX += (tx - btnCX) * DRAG_SMOOTH
        btnCY += (ty - btnCY) * DRAG_SMOOTH
        Btn.Position = UDim2.new(0, btnCX, 0, btnCY)
    end
end)

UIS.InputEnded:Connect(function() btnDrag = false end)

--==================================================
-- ✅ MENU CHÍNH - BÂY GIỜ KÉO ĐƯỢC LUÔN
--==================================================
local Menu = Instance.new("Frame")
Menu.Name = "Menu"
Menu.Parent = Gui
Menu.Size = UDim2.new(0, 280, 0, 160)
Menu.Position = UDim2.new(0.5, -140, 0.5, -80)
Menu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Menu.Visible = false
Instance.new("UICorner", Menu).CornerRadius = UDim.new(0, 12)

-- ✅ VIỀN RAINBOW
local Rainbow = Instance.new("UIStroke")
Rainbow.Parent = Menu
Rainbow.Thickness = 3

task.spawn(function()
    local hue = 0
    while Gui.Parent do
        hue = (hue + 0.005) % 1
        Rainbow.Color = Color3.fromHSV(hue, 1, 1)
        task.wait(0.03)
    end
end)

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Parent = Menu
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "NGUEYN DUY TDX"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.AutoLocalize = false

-- Nút chức năng
local ActionBtn = Instance.new("TextButton")
ActionBtn.Parent = Menu
ActionBtn.Size = UDim2.new(0, 220, 0, 50)
ActionBtn.Position = UDim2.new(0.5, -110, 0, 85)
ActionBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ActionBtn.Text = "JOIN SERVER"
ActionBtn.TextColor3 = Color3.new(1,1,1)
ActionBtn.TextSize = 16
ActionBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ActionBtn).CornerRadius = UDim.new(0, 8)
ActionBtn.AutoLocalize = false

-- === ✅ KÉO MENU CHÍNH ===
local menuDrag, menuStartPos, menuStartPosUdim = false, Vector2.new(), UDim2.new()
local menuCX, menuCY = Menu.Position.X.Offset, Menu.Position.Y.Offset

Menu.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
        menuDrag = true
        menuStartPos = i.Position
        menuStartPosUdim = Menu.Position
        menuCX, menuCY = menuStartPosUdim.X.Offset, menuStartPosUdim.Y.Offset
    end
end)

UIS.InputChanged:Connect(function(i)
    if not menuDrag then return end
    if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement then
        local tx = menuStartPosUdim.X.Offset + (i.Position.X - menuStartPos.X)
        local ty = menuStartPosUdim.Y.Offset + (i.Position.Y - menuStartPos.Y)
        menuCX += (tx - menuCX) * DRAG_SMOOTH
        menuCY += (ty - menuCY) * DRAG_SMOOTH
        Menu.Position = UDim2.new(0, menuCX, 0, menuCY)
    end
end)

UIS.InputEnded:Connect(function() menuDrag = false end)

-- Mở đóng menu
Btn.MouseButton1Click:Connect(function() Menu.Visible = not Menu.Visible end)

-- Nhảy server
ActionBtn.MouseButton1Click:Connect(function()
    ActionBtn.Text = "LOADING..."
    ServerHop()
    task.delay(1.5, function() ActionBtn.Text = "JOIN SERVER" end)
end)
