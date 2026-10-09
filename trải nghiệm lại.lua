--========================================================
-- DARK/RED HUB (GRAVITY HUB STYLE)
-- HOME + PLAYERS + SERVER HOP + SETTINGS
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local CONFIG = {
    Theme = Color3.fromRGB(255, 0, 0), -- Màu đỏ chủ đạo như ảnh
    BgColor = Color3.fromRGB(10, 10, 12),
    SurfaceColor = Color3.fromRGB(18, 18, 22),
    TextColor = Color3.fromRGB(240, 240, 240),
    SubTextColor = Color3.fromRGB(150, 150, 150),
    MenuWidth = 750,
    MenuHeight = 480,
    MaxServerPlayers = 3,
    TeleportOffset = 5,
}

local Accent = CONFIG.Theme
local UserId = LocalPlayer.UserId
local DisplayName = LocalPlayer.DisplayName

-- Xóa UI cũ nếu có
local Old = PlayerGui:FindFirstChild("DarkRedHubUI")
if Old then Old:Destroy() end

local function Corner(Object, Radius)
    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, Radius)
    C.Parent = Object
    return C
end

local function Stroke(Object, Color, Thickness)
    local S = Instance.new("UIStroke")
    S.Color = Color
    S.Thickness = Thickness or 1
    S.Parent = Object
    return S
end

-- TẠO SCREEN GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "DarkRedHubUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

-- NÚT MỞ MENU (ICON)
local Icon = Instance.new("ImageButton")
Icon.Name = "MenuIcon"
Icon.Parent = Gui
Icon.Size = UDim2.fromOffset(50, 50)
Icon.Position = UDim2.new(0, 20, 0.5, -25)
Icon.BackgroundColor3 = CONFIG.BgColor
Icon.Image = "rbxassetid://15082156891" -- Icon đỏ ngẫu nhiên (có thể thay đổi)
Corner(Icon, 25)
Stroke(Icon, Accent, 2)

-- MENU CHÍNH
local Menu = Instance.new("Frame")
Menu.Name = "MainMenu"
Menu.Parent = Gui
Menu.Size = UDim2.fromOffset(CONFIG.MenuWidth, CONFIG.MenuHeight)
Menu.Position = UDim2.new(0.5, -CONFIG.MenuWidth/2, 0.5, -CONFIG.MenuHeight/2)
Menu.BackgroundColor3 = CONFIG.BgColor
Menu.BorderSizePixel = 0
Menu.Visible = false
Corner(Menu, 8)
Stroke(Menu, Accent, 1) -- Viền đỏ toàn bộ menu

-- TOP BAR (Thanh tiêu đề)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = Menu
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = CONFIG.BgColor
TopBar.BorderSizePixel = 0
Corner(TopBar, 8)

-- Fix góc dưới của TopBar vuông lại để dính với Body
local TopBarHider = Instance.new("Frame")
TopBarHider.Parent = TopBar
TopBarHider.Size = UDim2.new(1, 0, 0, 8)
TopBarHider.Position = UDim2.new(0, 0, 1, -8)
TopBarHider.BackgroundColor3 = CONFIG.BgColor
TopBarHider.BorderSizePixel = 0

-- Line đỏ phân cách TopBar
local TopLine = Instance.new("Frame")
TopLine.Parent = TopBar
TopLine.Size = UDim2.new(1, 0, 0, 1)
TopLine.Position = UDim2.new(0, 0, 1, -1)
TopLine.BackgroundColor3 = Accent
TopLine.BorderSizePixel = 0

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TopBar
TitleText.Size = UDim2.new(1, -120, 1, 0)
TitleText.Position = UDim2.fromOffset(15, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Gravity Hub [ Freemium ] Version 1.4"
TitleText.TextColor3 = CONFIG.SubTextColor
TitleText.TextSize = 13
TitleText.Font = Enum.Font.GothamMedium
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Nút điều khiển cửa sổ giả (Góc phải trên)
local ControlFrame = Instance.new("Frame")
ControlFrame.Parent = TopBar
ControlFrame.Size = UDim2.fromOffset(100, 45)
ControlFrame.Position = UDim2.new(1, -100, 0, 0)
ControlFrame.BackgroundTransparency = 1

local function MakeCtrlBtn(X, Text)
    local Btn = Instance.new("TextLabel")
    Btn.Parent = ControlFrame
    Btn.Size = UDim2.fromOffset(30, 45)
    Btn.Position = UDim2.fromOffset(X, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = Text
    Btn.TextColor3 = CONFIG.SubTextColor
    Btn.TextSize = 16
    Btn.Font = Enum.Font.Gotham
    return Btn
end
MakeCtrlBtn(0, "—")
MakeCtrlBtn(30, "◻")
local CloseMock = MakeCtrlBtn(60, "✕")

-- SIDEBAR (Menu bên trái)
local Sidebar = Instance.new("Frame")
Sidebar.Parent = Menu
Sidebar.Size = UDim2.new(0, 200, 1, -45)
Sidebar.Position = UDim2.fromOffset(0, 45)
Sidebar.BackgroundColor3 = CONFIG.BgColor
Sidebar.BorderSizePixel = 0

local Pages = {}
local NavButtons = {}
local ActiveLine = Instance.new("Frame")
ActiveLine.Parent = Sidebar
ActiveLine.Size = UDim2.new(0, 4, 0, 24)
ActiveLine.BackgroundColor3 = Accent
ActiveLine.BorderSizePixel = 0

local function MakePage(Name)
    local Page = Instance.new("Frame")
    Page.Name = Name
    Page.Parent = Menu
    Page.Size = UDim2.new(1, -210, 1, -55)
    Page.Position = UDim2.fromOffset(205, 50)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Pages[Name] = Page
    return Page
end

local function MakeNav(Text, Y, PageName)
    local Button = Instance.new("TextButton")
    Button.Parent = Sidebar
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.Position = UDim2.fromOffset(15, Y)
    Button.BackgroundTransparency = 1
    Button.Text = "  " .. Text
    Button.TextColor3 = CONFIG.SubTextColor
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamMedium
    Button.TextXAlignment = Enum.TextXAlignment.Left
    NavButtons[PageName] = Button
    return Button
end

local HomePage = MakePage("Home")
local PlayersPage = MakePage("Players")
local ServerPage = MakePage("Server")
local SettingsPage = MakePage("Settings")

local HomeNav = MakeNav("Tab Home", 20, "Home")
local PlayersNav = MakeNav("Tab Players", 70, "Players")
local ServerNav = MakeNav("Tab Server Hop", 120, "Server")
local SettingsNav = MakeNav("Tab Setting", 170, "Settings")

local function PageTitle(Page, Main, Sub)
    local Title = Instance.new("TextLabel")
    Title.Parent = Page
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.fromOffset(10, 10)
    Title.BackgroundTransparency = 1
    Title.Text = Main
    Title.TextColor3 = CONFIG.TextColor
    Title.TextSize = 28
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Parent = Page
    Subtitle.Size = UDim2.new(1, 0, 0, 20)
    Subtitle.Position = UDim2.fromOffset(10, 50)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = Sub
    Subtitle.TextColor3 = CONFIG.TextColor
    Subtitle.TextSize = 16
    Subtitle.Font = Enum.Font.GothamMedium
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
end

-- ========================================================
-- 1. HOME PAGE
-- ========================================================
PageTitle(HomePage, "Tab Home", "Overview / Analytics")

local function StatCard(X, Y, W, H, Label)
    local Card = Instance.new("Frame")
    Card.Parent = HomePage
    Card.Size = UDim2.fromOffset(W, H)
    Card.Position = UDim2.fromOffset(X, Y)
    Card.BackgroundColor3 = CONFIG.BgColor
    Corner(Card, 6)
    Stroke(Card, Accent, 1)

    local L = Instance.new("TextLabel")
    L.Parent = Card
    L.Size = UDim2.new(1, -20, 0, 25)
    L.Position = UDim2.fromOffset(10, 5)
    L.BackgroundTransparency = 1
    L.Text = Label
    L.TextColor3 = CONFIG.SubTextColor
    L.TextSize = 13
    L.Font = Enum.Font.Gotham
    L.TextXAlignment = Enum.TextXAlignment.Left

    local V = Instance.new("TextLabel")
    V.Parent = Card
    V.Size = UDim2.new(1, -20, 0, 40)
    V.Position = UDim2.fromOffset(10, 30)
    V.BackgroundTransparency = 1
    V.Text = "--"
    V.TextColor3 = Accent
    V.TextSize = 26
    V.Font = Enum.Font.GothamBold
    V.TextXAlignment = Enum.TextXAlignment.Left
    return V
end

local FPSValue = StatCard(10, 90, 240, 80, "FPS")
local PingValue = StatCard(265, 90, 240, 80, "PING (ms)")
local PlayerCount = StatCard(10, 185, 240, 80, "PLAYERS")
local UIDValue = StatCard(265, 185, 240, 80, "USER ID")
UIDValue.Text = tostring(UserId)

-- ==========================================================
-- 2. PLAYERS PAGE
-- ==========================================================
PageTitle(PlayersPage, "Tab Players", "Player / Target List")

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Parent = PlayersPage
PlayerList.Size = UDim2.new(1, -10, 1, -90)
PlayerList.Position = UDim2.fromOffset(10, 90)
PlayerList.BackgroundTransparency = 1
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 2
PlayerList.ScrollBarImageColor3 = Accent

local PlayerLayout = Instance.new("UIListLayout")
PlayerLayout.Parent = PlayerList
PlayerLayout.Padding = UDim.new(0, 8)

PlayerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, PlayerLayout.AbsoluteContentSize.Y + 10)
end)

local function RefreshPlayers()
    for _, Child in ipairs(PlayerList:GetChildren()) do
        if Child:IsA("Frame") then Child:Destroy() end
    end

    for _, Target in ipairs(Players:GetPlayers()) do
        if Target ~= LocalPlayer then
            local Row = Instance.new("Frame")
            Row.Parent = PlayerList
            Row.Size = UDim2.new(1, -10, 0, 50)
            Row.BackgroundColor3 = CONFIG.BgColor
            Corner(Row, 6)
            Stroke(Row, Accent, 1)

            local Name = Instance.new("TextLabel")
            Name.Parent = Row
            Name.Size = UDim2.new(1, -120, 1, 0)
            Name.Position = UDim2.fromOffset(15, 0)
            Name.BackgroundTransparency = 1
            Name.Text = Target.DisplayName .. " (@" .. Target.Name .. ")"
            Name.TextColor3 = CONFIG.TextColor
            Name.TextSize = 13
            Name.Font = Enum.Font.GothamMedium
            Name.TextXAlignment = Enum.TextXAlignment.Left

            local Teleport = Instance.new("TextButton")
            Teleport.Parent = Row
            Teleport.Size = UDim2.fromOffset(80, 30)
            Teleport.Position = UDim2.new(1, -90, 0.5, -15)
            Teleport.BackgroundColor3 = Accent
            Teleport.Text = "TELEPORT"
            Teleport.TextColor3 = Color3.new(0,0,0)
            Teleport.TextSize = 12
            Teleport.Font = Enum.Font.GothamBold
            Corner(Teleport, 6)

            Teleport.MouseButton1Click:Connect(function()
                local Char, TChar = LocalPlayer.Character, Target.Character
                if Char and TChar and TChar:FindFirstChild("HumanoidRootPart") then
                    Char:PivotTo(TChar.HumanoidRootPart.CFrame * CFrame.new(0,0,CONFIG.TeleportOffset))
                end
            end)
        end
    end
end
RefreshPlayers()
Players.PlayerAdded:Connect(function() task.wait(0.2) RefreshPlayers() end)
Players.PlayerRemoving:Connect(function() task.wait(0.1) RefreshPlayers() end)

-- ========================================================
-- 3. SERVER HOP PAGE
-- ========================================================
PageTitle(ServerPage, "Tab Server Hop", "Hop / Find Server")

-- Nút TÌM LẠI SERVER (Chiếm trọn bề ngang)
local FindServers = Instance.new("TextButton")
FindServers.Parent = ServerPage
FindServers.Size = UDim2.new(1, -20, 0, 45)
FindServers.Position = UDim2.fromOffset(10, 90)
FindServers.BackgroundColor3 = CONFIG.BgColor
FindServers.Text = "🔄  TÌM LẠI SERVER"
FindServers.TextColor3 = CONFIG.TextColor
FindServers.TextSize = 14
FindServers.Font = Enum.Font.GothamBold
Corner(FindServers, 6)
Stroke(FindServers, Accent, 1)

local ServerStatus = Instance.new("TextLabel")
ServerStatus.Parent = ServerPage
ServerStatus.Size = UDim2.new(1, -20, 0, 20)
ServerStatus.Position = UDim2.fromOffset(10, 140)
ServerStatus.BackgroundTransparency = 1
ServerStatus.Text = "Status: Idle"
ServerStatus.TextColor3 = CONFIG.SubTextColor
ServerStatus.TextSize = 12
ServerStatus.Font = Enum.Font.Gotham
ServerStatus.TextXAlignment = Enum.TextXAlignment.Left

local ServerList = Instance.new("ScrollingFrame")
ServerList.Parent = ServerPage
ServerList.Size = UDim2.new(1, -20, 1, -170)
ServerList.Position = UDim2.fromOffset(10, 165)
ServerList.BackgroundTransparency = 1
ServerList.BorderSizePixel = 0
ServerList.ScrollBarThickness = 2
ServerList.ScrollBarImageColor3 = Accent

local ServerLayout = Instance.new("UIListLayout")
ServerLayout.Parent = ServerList
ServerLayout.Padding = UDim.new(0, 8)

ServerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ServerList.CanvasSize = UDim2.new(0,0,0,ServerLayout.AbsoluteContentSize.Y+10)
end)

local function AddServer(Server, Index)
    local Playing = tonumber(Server.playing) or 0
    local Row = Instance.new("Frame")
    Row.Parent = ServerList
    Row.Size = UDim2.new(1, -10, 0, 50)
    Row.BackgroundColor3 = CONFIG.BgColor
    Corner(Row, 6)
    Stroke(Row, Accent, 1)

    local Info = Instance.new("TextLabel")
    Info.Parent = Row
    Info.Size = UDim2.new(1, -90, 1, 0)
    Info.Position = UDim2.fromOffset(15, 0)
    Info.BackgroundTransparency = 1
    Info.Text = "SERVER #"..Index.." - Players: "..Playing
    Info.TextColor3 = CONFIG.TextColor
    Info.TextSize = 13
    Info.Font = Enum.Font.GothamMedium
    Info.TextXAlignment = Enum.TextXAlignment.Left

    local Join = Instance.new("TextButton")
    Join.Parent = Row
    Join.Size = UDim2.fromOffset(70, 30)
    Join.Position = UDim2.new(1, -80, 0.5, -15)
    Join.BackgroundColor3 = Accent
    Join.Text = "HOP"
    Join.TextColor3 = Color3.new(0,0,0)
    Join.TextSize = 12
    Join.Font = Enum.Font.GothamBold
    Corner(Join, 6)

    Join.MouseButton1Click:Connect(function()
        Join.Text = "..."
        TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, LocalPlayer)
    end)
end

-- ========================================================
-- 4. SETTINGS PAGE (GIAO DIỆN TOGGLE GIỐNG ẢNH)
-- ========================================================
PageTitle(SettingsPage, "Tab Setting", "Settings / Configure")

local SettingList = Instance.new("ScrollingFrame")
SettingList.Parent = SettingsPage
SettingList.Size = UDim2.new(1, -20, 1, -90)
SettingList.Position = UDim2.fromOffset(10, 90)
SettingList.BackgroundTransparency = 1
SettingList.BorderSizePixel = 0
SettingList.ScrollBarThickness = 2
SettingList.ScrollBarImageColor3 = Accent

local SetLayout = Instance.new("UIListLayout")
SetLayout.Parent = SettingList
SetLayout.Padding = UDim.new(0, 10)

SetLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SettingList.CanvasSize = UDim2.new(0,0,0,SetLayout.AbsoluteContentSize.Y+10)
end)

-- HÀM TẠO TOGGLE THEO PHONG CÁCH "GRAVITY HUB" (Viền đỏ, nền đen, nút gạt)
local function CreateToggle(Parent, Text, DefaultState, Callback)
    local State = DefaultState

    local ToggleFrame = Instance.new("TextButton")
    ToggleFrame.Parent = Parent
    ToggleFrame.Size = UDim2.new(1, -10, 0, 55)
    ToggleFrame.BackgroundColor3 = CONFIG.BgColor
    ToggleFrame.Text = ""
    Corner(ToggleFrame, 8)
    Stroke(ToggleFrame, Accent, 1)

    local Title = Instance.new("TextLabel")
    Title.Parent = ToggleFrame
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.fromOffset(20, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Text
    Title.TextColor3 = CONFIG.TextColor
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamMedium
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local SwitchBg = Instance.new("Frame")
    SwitchBg.Parent = ToggleFrame
    SwitchBg.Size = UDim2.fromOffset(48, 24)
    SwitchBg.Position = UDim2.new(1, -70, 0.5, -12)
    SwitchBg.BackgroundColor3 = State and Accent or CONFIG.BgColor
    Corner(SwitchBg, 12)
    local SwitchStroke = Stroke(SwitchBg, Accent, 1)

    local Thumb = Instance.new("Frame")
    Thumb.Parent = SwitchBg
    Thumb.Size = UDim2.fromOffset(18, 18)
    Thumb.Position = State and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    Thumb.BackgroundColor3 = State and CONFIG.BgColor or Accent
    Corner(Thumb, 9)

    ToggleFrame.MouseButton1Click:Connect(function()
        State = not State
        SwitchBg.BackgroundColor3 = State and Accent or CONFIG.BgColor
        Thumb.BackgroundColor3 = State and CONFIG.BgColor or Accent
        Thumb.Position = State and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        if Callback then Callback(State) end
    end)
end

-- THÊM CÁC TOGGLE GIẢ LẬP GIỐNG TRONG ẢNH
CreateToggle(SettingList, "Fast Attack", true, function(val) print("Fast Attack:", val) end)
CreateToggle(SettingList, "Bring Mobs", true, function(val) print("Bring Mobs:", val) end)
CreateToggle(SettingList, "Auto Hop (Every 30 Minutes)", false, function(val) print("Auto Hop:", val) end)
CreateToggle(SettingList, "Auto Turn on Buso", true, function(val) print("Auto Buso:", val) end)

-- ========================================================
-- LOGIC ĐIỀU HƯỚNG VÀ DRAG
-- ========================================================
local function ShowPage(Name)
    for PageName, Page in pairs(Pages) do
        Page.Visible = (PageName == Name)
    end
    for _, Button in pairs(NavButtons) do
        Button.TextColor3 = CONFIG.SubTextColor
        Button.Font = Enum.Font.GothamMedium
    end
    
    local Active = NavButtons[Name]
    if Active then
        Active.TextColor3 = CONFIG.TextColor
        Active.Font = Enum.Font.GothamBold
        ActiveLine.Position = UDim2.new(0, 0, 0, Active.Position.Y.Offset + 8)
    end
end

HomeNav.MouseButton1Click:Connect(function() ShowPage("Home") end)
PlayersNav.MouseButton1Click:Connect(function() ShowPage("Players") end)
ServerNav.MouseButton1Click:Connect(function() ShowPage("Server") end)
SettingsNav.MouseButton1Click:Connect(function() ShowPage("Settings") end)

ShowPage("Home")

-- VÒNG LẶP FPS & PING
local Frames, LastFPS = 0, os.clock()
RunService.RenderStepped:Connect(function()
    Frames += 1
    local Now = os.clock()
    if Now - LastFPS >= 1 then
        FPSValue.Text = tostring(Frames)
        Frames, LastFPS = 0, Now
    end
end)

task.spawn(function()
    while Gui.Parent do
        local Ping = 0
        pcall(function() Ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
        PingValue.Text = math.floor(Ping)
        PlayerCount.Text = tostring(#Players:GetPlayers())
        task.wait(1)
    end
end)

-- BẬT TẮT MENU (ICON)
Icon.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)

-- KÉO MENU (TOP BAR)
local Dragging, DragStart, StartPos
TopBar.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPos = Menu.Position
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = Input.Position - DragStart
        Menu.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)
            
