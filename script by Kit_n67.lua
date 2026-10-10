local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local CONFIG = {
    Theme = "Purple",
    MenuWidth = 720,
    MenuHeight = 460,
    MinWidth = 550,
    MaxWidth = 900,
    MinHeight = 380,
    MaxHeight = 650,
    MaxServerPlayers = 3,
    TeleportOffset = 5,
}

local THEMES = {
    Purple = Color3.fromRGB(140, 70, 255),
    Pink = Color3.fromRGB(255, 60, 150),
    Blue = Color3.fromRGB(50, 120, 255),
    Cyan = Color3.fromRGB(20, 200, 210),
    Green = Color3.fromRGB(40, 200, 100),
    Red = Color3.fromRGB(230, 50, 60),
    Orange = Color3.fromRGB(255, 130, 40),
}

local Accent = THEMES[CONFIG.Theme]
local UserId = LocalPlayer.UserId
local DisplayName = LocalPlayer.DisplayName
local Username = "@" .. LocalPlayer.Name
local AvatarURL = ""

local ClickSound = Instance.new("Sound")
ClickSound.Name = "LuxuryClickSound"
ClickSound.SoundId = "rbxassetid://6895079853" 
ClickSound.Volume = 1
ClickSound.Parent = SoundService

pcall(function()
    AvatarURL = Players:GetUserThumbnailAsync(
        UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size420x420
    )
end)

local Old = PlayerGui:FindFirstChild("LuxuryDashboardUI")
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
    S.Transparency = 0.3
    S.Parent = Object
    return S
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "LuxuryDashboardUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 999999
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Icon = Instance.new("ImageButton")
Icon.Name = "MenuIcon"
Icon.Parent = Gui
Icon.Size = UDim2.fromOffset(56, 56)
Icon.Position = UDim2.new(0, 20, 0.5, -28)
Icon.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Icon.BorderSizePixel = 0
Icon.AutoButtonColor = false
if AvatarURL ~= "" then Icon.Image = AvatarURL end
Corner(Icon, 28)
Stroke(Icon, Accent, 2)

local Menu = Instance.new("Frame")
Menu.Name = "MainMenu"
Menu.Parent = Gui
Menu.Size = UDim2.fromOffset(CONFIG.MenuWidth, CONFIG.MenuHeight)
Menu.Position = UDim2.new(0.5, -CONFIG.MenuWidth/2, 0.5, -CONFIG.MenuHeight/2)
Menu.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Menu.BorderSizePixel = 0
Menu.Visible = false
Menu.ClipsDescendants = true
Corner(Menu, 16)
Stroke(Menu, Accent, 1.5)

local TopBarControls = Instance.new("Frame")
TopBarControls.Parent = Menu
TopBarControls.Size = UDim2.fromOffset(100, 35)
TopBarControls.Position = UDim2.new(1, -105, 0, 8)
TopBarControls.BackgroundTransparency = 1
TopBarControls.ZIndex = 10

local function MakeTopBtn(XOffset, Text, Callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = TopBarControls
    Btn.Size = UDim2.fromOffset(28, 28)
    Btn.Position = UDim2.fromOffset(XOffset, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Btn.BorderSizePixel = 0
    Btn.Text = Text
    Btn.TextColor3 = Color3.fromRGB(200, 200, 210)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamBold
    Corner(Btn, 6)
    
    Btn.MouseButton1Click:Connect(function()
        ClickSound:Play() -- Phát âm thanh khi bấm nút điều khiển góc phải
        Callback()
    end)
    return Btn
end

local IsMaximized = false
local NormalSize = UDim2.fromOffset(CONFIG.MenuWidth, CONFIG.MenuHeight)
local NormalPos = Menu.Position

-- Nút [-] Thu nhỏ menu nhưng không tắt icon
MakeTopBtn(0, "—", function()
    Menu.Visible = false
end)

-- Ký tự thu phóng menu [🗖] (Phóng to / Thu nhỏ)
MakeTopBtn(32, "🗖", function()
    IsMaximized = not IsMaximized
    if IsMaximized then
        NormalSize = Menu.Size
        NormalPos = Menu.Position
        Menu.Size = UDim2.new(0, 850, 0, 580)
        Menu.Position = UDim2.new(0.5, -425, 0.5, -290)
    else
        Menu.Size = NormalSize
        Menu.Position = NormalPos
    end
end)

-- Nút [×] Tắt menu và vô hiệu hóa icon hoàn toàn
local IconEnabled = true
MakeTopBtn(64, "×", function()
    Menu.Visible = false
    IconEnabled = false
    Icon.Visible = false
end)

-- SIDEBAR BÊN TRÁI
local Sidebar = Instance.new("Frame")
Sidebar.Parent = Menu
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
Sidebar.BorderSizePixel = 0
Corner(Sidebar, 16)

local Logo = Instance.new("TextLabel")
Logo.Parent = Sidebar
Logo.Size = UDim2.new(1, -20, 0, 45)
Logo.Position = UDim2.fromOffset(15, 12)
Logo.BackgroundTransparency = 1
Logo.Text = "LUXURY HUB"
Logo.TextColor3 = Accent
Logo.TextSize = 16
Logo.Font = Enum.Font.GothamBold
Logo.TextXAlignment = Enum.TextXAlignment.Left

local Pages = {}
local NavButtons = {}

local function MakePage(Name)
    local Page = Instance.new("Frame")
    Page.Name = Name
    Page.Parent = Menu
    Page.Size = UDim2.new(1, -200, 1, -20)
    Page.Position = UDim2.fromOffset(190, 10)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Pages[Name] = Page
    return Page
end

local function MakeNav(Text, Y, PageName)
    local Button = Instance.new("TextButton")
    Button.Parent = Sidebar
    Button.Size = UDim2.new(1, -20, 0, 42)
    Button.Position = UDim2.fromOffset(10, Y)
    Button.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Button.BackgroundTransparency = 1
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = Color3.fromRGB(150, 150, 165)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamMedium
    Button.TextXAlignment = Enum.TextXAlignment.Left
    
    local TextPadding = Instance.new("UIPadding")
    TextPadding.PaddingLeft = UDim.new(0, 14)
    TextPadding.Parent = Button

    Corner(Button, 10)
    NavButtons[PageName] = Button
    return Button
end

local HomePage = MakePage("Home")
local PlayersPage = MakePage("Players")
local ServerPage = MakePage("Server")
local SettingsPage = MakePage("Settings")

local HomeNav = MakeNav("🏠   Home Dashboard", 75, "Home")
local PlayersNav = MakeNav("👥   Online Players", 125, "Players")
local ServerNav = MakeNav("🌐   Server Hop", 175, "Server")
local SettingsNav = MakeNav("⚙️   UI Settings", 225, "Settings")

local BottomProfile = Instance.new("Frame")
BottomProfile.Parent = Sidebar
BottomProfile.Size = UDim2.new(1, -20, 0, 55)
BottomProfile.Position = UDim2.new(0, 10, 1, -65)
BottomProfile.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
BottomProfile.BorderSizePixel = 0
Corner(BottomProfile, 12)

local BottomAvatar = Instance.new("ImageLabel")
BottomAvatar.Parent = BottomProfile
BottomAvatar.Size = UDim2.fromOffset(38, 38)
BottomAvatar.Position = UDim2.fromOffset(8, 8)
BottomAvatar.BackgroundTransparency = 1
BottomAvatar.Image = AvatarURL
Corner(BottomAvatar, 19)

local BottomName = Instance.new("TextLabel")
BottomName.Parent = BottomProfile
BottomName.Size = UDim2.new(1, -52, 0, 18)
BottomName.Position = UDim2.fromOffset(50, 10)
BottomName.BackgroundTransparency = 1
BottomName.Text = DisplayName
BottomName.TextColor3 = Color3.new(1, 1, 1)
BottomName.TextSize = 11
BottomName.Font = Enum.Font.GothamBold
BottomName.TextXAlignment = Enum.TextXAlignment.Left
BottomName.TextTruncate = Enum.TextTruncate.AtEnd

local BottomUser = Instance.new("TextLabel")
BottomUser.Parent = BottomProfile
BottomUser.Size = UDim2.new(1, -52, 0, 16)
BottomUser.Position = UDim2.fromOffset(50, 28)
BottomUser.BackgroundTransparency = 1
BottomUser.Text = Username
BottomUser.TextColor3 = Accent
BottomUser.TextSize = 10
BottomUser.Font = Enum.Font.Gotham
BottomUser.TextXAlignment = Enum.TextXAlignment.Left

local function PageTitle(Page, Main, Sub)
    local Title = Instance.new("TextLabel")
    Title.Parent = Page
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.fromOffset(5, 8)
    Title.BackgroundTransparency = 1
    Title.Text = Main
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Parent = Page
    Subtitle.Size = UDim2.new(1, 0, 0, 18)
    Subtitle.Position = UDim2.fromOffset(5, 38)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = Sub
    Subtitle.TextColor3 = Color3.fromRGB(140, 140, 155)
    Subtitle.TextSize = 11
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
end

PageTitle(HomePage, "Dashboard Overview", "Thống kê hệ thống và thông tin cá nhân")

local function StatCard(Page, X, Y, W, Label)
    local Card = Instance.new("Frame")
    Card.Parent = Page
    Card.Size = UDim2.fromOffset(W, 75)
    Card.Position = UDim2.fromOffset(X, Y)
    Card.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Card.BorderSizePixel = 0
    Corner(Card, 12)
    Stroke(Card, Color3.fromRGB(40, 40, 55), 1)

    local L = Instance.new("TextLabel")
    L.Parent = Card
    L.Size = UDim2.new(1, -20, 0, 18)
    L.Position = UDim2.fromOffset(10, 10)
    L.BackgroundTransparency = 1
    L.Text = Label
    L.TextColor3 = Color3.fromRGB(130, 130, 145)
    L.TextSize = 10
    L.Font = Enum.Font.GothamMedium
    L.TextXAlignment = Enum.TextXAlignment.Left

    local V = Instance.new("TextLabel")
    V.Parent = Card
    V.Size = UDim2.new(1, -20, 0, 32)
    V.Position = UDim2.fromOffset(10, 30)
    V.BackgroundTransparency = 1
    V.Text = "--"
    V.TextColor3 = Accent
    V.TextSize = 20
    V.Font = Enum.Font.GothamBold
    V.TextXAlignment = Enum.TextXAlignment.Left
    return V
end

local FPSValue = StatCard(HomePage, 5, 75, 150, "FRAME RATE (FPS)")
local PingValue = StatCard(HomePage, 160, 75, 150, "NETWORK PING")
local PlayerCount = StatCard(HomePage, 5, 158, 150, "SERVER PLAYERS")
local UserIDValue = StatCard(HomePage, 160, 158, 150, "ROBLOX USER ID")
UserIDValue.Text = tostring(UserId)

PageTitle(PlayersPage, "Active Players", "Danh sách người chơi đang ở cùng server")

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Parent = PlayersPage
PlayerList.Size = UDim2.new(1, -5, 1, -75)
PlayerList.Position = UDim2.fromOffset(0, 65)
PlayerList.BackgroundTransparency = 1
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 3
PlayerList.ScrollBarImageColor3 = Accent

local PlayerLayout = Instance.new("UIListLayout")
PlayerLayout.Parent = PlayerList
PlayerLayout.Padding = UDim.new(0, 8)

PlayerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, PlayerLayout.AbsoluteContentSize.Y + 10)
end)

local function TeleportToPlayer(Target)
    if Target == LocalPlayer then return end
    local MyChar, TChar = LocalPlayer.Character, Target.Character
    if MyChar and TChar and TChar:FindFirstChild("HumanoidRootPart") then
        MyChar:PivotTo(TChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, CONFIG.TeleportOffset))
    end
end

local function RefreshPlayers()
    for _, Child in ipairs(PlayerList:GetChildren()) do
        if Child:IsA("Frame") then Child:Destroy() end
    end

    for _, Target in ipairs(Players:GetPlayers()) do
        if Target ~= LocalPlayer then
            local Row = Instance.new("Frame")
            Row.Parent = PlayerList
            Row.Size = UDim2.new(1, -5, 0, 60)
            Row.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
            Row.BorderSizePixel = 0
            Corner(Row, 12)

            local Name = Instance.new("TextLabel")
            Name.Parent = Row
            Name.Size = UDim2.new(1, -110, 0, 22)
            Name.Position = UDim2.fromOffset(14, 10)
            Name.BackgroundTransparency = 1
            Name.Text = Target.DisplayName
            Name.TextColor3 = Color3.new(1, 1, 1)
            Name.TextSize = 13
            Name.Font = Enum.Font.GothamBold
            Name.TextXAlignment = Enum.TextXAlignment.Left

            local User = Instance.new("TextLabel")
            User.Parent = Row
            User.Size = UDim2.new(1, -110, 0, 18)
            User.Position = UDim2.fromOffset(14, 32)
            User.BackgroundTransparency = 1
            User.Text = "@" .. Target.Name
            User.TextColor3 = Color3.fromRGB(130, 130, 145)
            User.TextSize = 11
            User.Font = Enum.Font.Gotham
            User.TextXAlignment = Enum.TextXAlignment.Left

            local Teleport = Instance.new("TextButton")
            Teleport.Parent = Row
            Teleport.Size = UDim2.fromOffset(75, 34)
            Teleport.Position = UDim2.new(1, -85, 0.5, -17)
            Teleport.BackgroundColor3 = Accent
            Teleport.BorderSizePixel = 0
            Teleport.Text = "TELEPORT"
            Teleport.TextColor3 = Color3.new(1, 1, 1)
            Teleport.TextSize = 11
            Teleport.Font = Enum.Font.GothamBold
            Corner(Teleport, 8)

            Teleport.MouseButton1Click:Connect(function()
                TeleportToPlayer(Target)
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
PageTitle(ServerPage, "Server Hop Hub", "Tìm kiếm và kết nối nhanh vào các server ít người")

local FindServers = Instance.new("TextButton")
FindServers.Parent = ServerPage
FindServers.Size = UDim2.new(1, -5, 0, 44)
FindServers.Position = UDim2.fromOffset(0, 65)
FindServers.BackgroundColor3 = Accent
FindServers.BorderSizePixel = 0
FindServers.Text = "🔄  TÌM LẠI SERVER"
FindServers.TextColor3 = Color3.new(1, 1, 1)
FindServers.TextSize = 12
FindServers.Font = Enum.Font.GothamBold
Corner(FindServers, 10)

local ServerStatus = Instance.new("TextLabel")
ServerStatus.Parent = ServerPage
ServerStatus.Size = UDim2.new(1, -5, 0, 22)
ServerStatus.Position = UDim2.fromOffset(0, 114)
ServerStatus.BackgroundTransparency = 1
ServerStatus.Text = "Trạng thái: Sẵn sàng quét server"
ServerStatus.TextColor3 = Color3.fromRGB(140, 140, 155)
ServerStatus.TextSize = 11
ServerStatus.Font = Enum.Font.Gotham
ServerStatus.TextXAlignment = Enum.TextXAlignment.Left

local ServerList = Instance.new("ScrollingFrame")
ServerList.Parent = ServerPage
ServerList.Size = UDim2.new(1, -5, 1, -145)
ServerList.Position = UDim2.fromOffset(0, 140)
ServerList.BackgroundTransparency = 1
ServerList.BorderSizePixel = 0
ServerList.ScrollBarThickness = 3
ServerList.ScrollBarImageColor3 = Accent

local ServerLayout = Instance.new("UIListLayout")
ServerLayout.Parent = ServerList
ServerLayout.Padding = UDim.new(0, 8)

ServerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ServerList.CanvasSize = UDim2.new(0, 0, 0, ServerLayout.AbsoluteContentSize.Y + 10)
end)

local function ClearServers()
    for _, Child in ipairs(ServerList:GetChildren()) do
        if Child:IsA("Frame") then Child:Destroy() end
    end
end

local function FetchServerPage(Cursor)
    local URL = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    if Cursor then URL = URL .. "&cursor=" .. HttpService:UrlEncode(Cursor) end
    local Success, Response = pcall(function() return game:HttpGet(URL) end)
    if not Success or not Response then return nil end
    local DecodeSuccess, Data = pcall(function() return HttpService:JSONDecode(Response) end)
    return DecodeSuccess and Data or nil
end

local function GetServers()
    local Servers = {}
    local Cursor = nil
    local PagesScanned = 0
    while PagesScanned < 15 do
        PagesScanned += 1
        local Data = FetchServerPage(Cursor)
        if not Data or not Data.data then break end
        for _, Server in ipairs(Data.data) do
            local Playing = tonumber(Server.playing) or 999
            if Server.id ~= game.JobId and Playing <= CONFIG.MaxServerPlayers and Playing > 0 then
                table.insert(Servers, Server)
            end
        end
        Cursor = Data.nextPageCursor
        if not Cursor then break end
        task.wait(0.05)
    end
    table.sort(Servers, function(a, b)
        return (tonumber(a.playing) or 999) < (tonumber(b.playing) or 999)
    end)
    return Servers
end

local function AddServer(Server, Index)
    local Playing = tonumber(Server.playing) or 0
    local MaxPlayers = tonumber(Server.maxPlayers) or 0

    local Row = Instance.new("Frame")
    Row.Parent = ServerList
    Row.Size = UDim2.new(1, -5, 0, 60)
    Row.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Row.BorderSizePixel = 0
    Corner(Row, 12)

    local Info = Instance.new("TextLabel")
    Info.Parent = Row
    Info.Size = UDim2.new(1, -80, 1, 0)
    Info.Position = UDim2.fromOffset(14, 0)
    Info.BackgroundTransparency = 1
    Info.Text = "SERVER #" .. Index .. " (" .. Playing .. " NGƯỜI)\n👥 Tình trạng: " .. Playing .. " / " .. MaxPlayers
    Info.TextColor3 = Color3.new(1, 1, 1)
    Info.TextSize = 11
    Info.Font = Enum.Font.GothamMedium
    Info.TextXAlignment = Enum.TextXAlignment.Left

    local Join = Instance.new("TextButton")
    Join.Parent = Row
    Join.Size = UDim2.fromOffset(50, 36)
    Join.Position = UDim2.new(1, -60, 0.5, -18)
    Join.BackgroundColor3 = Accent
    Join.BorderSizePixel = 0
    Join.Text = "🚀"
    Join.TextColor3 = Color3.new(1, 1, 1)
    Join.TextSize = 16
    Join.Font = Enum.Font.GothamBold
    Corner(Join, 8)

    Join.MouseButton1Click:Connect(function()
        Join.Active = false
        Join.Text = "..."
        TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, LocalPlayer)
    end)
end

local SearchingServers = false
local CurrentFoundServers = {}

FindServers.MouseButton1Click:Connect(function()
    if SearchingServers then return end
    SearchingServers = true
    ClearServers()
    FindServers.Text = "⏳  ĐANG QUÉT SERVER..."
    ServerStatus.Text = "Trạng thái: Đang duyệt các trang server công khai..."

    task.spawn(function()
        CurrentFoundServers = GetServers()
        if #CurrentFoundServers == 0 then
            ServerStatus.Text = "❌ Không tìm thấy server phù hợp, hãy thử lại!"
        else
            ServerStatus.Text = "✓ Đã tìm thấy " .. #CurrentFoundServers .. " server ít người"
            for i, Server in ipairs(CurrentFoundServers) do
                AddServer(Server, i)
            end
        end
        SearchingServers = false
        FindServers.Text = "🔄  TÌM LẠI SERVER"
    end)
end)

-- ========================================================
-- 4. SETTINGS PAGE (CHỌN MÀU THEME)
-- ========================================================
PageTitle(SettingsPage, "Customization", "Tùy chỉnh giao diện và màu chủ đạo")

local ThemeLabel = Instance.new("TextLabel")
ThemeLabel.Parent = SettingsPage
ThemeLabel.Size = UDim2.new(1, 0, 0, 24)
ThemeLabel.Position = UDim2.fromOffset(0, 70)
ThemeLabel.BackgroundTransparency = 1
ThemeLabel.Text = "CHỌN MÀU GIAO DIỆN (THEME COLOR)"
ThemeLabel.TextColor3 = Color3.new(1, 1, 1)
ThemeLabel.TextSize = 11
ThemeLabel.Font = Enum.Font.GothamBold
ThemeLabel.TextXAlignment = Enum.TextXAlignment.Left

local ThemeContainer = Instance.new("Frame")
ThemeContainer.Parent = SettingsPage
ThemeContainer.Size = UDim2.new(1, 0, 0, 160)
ThemeContainer.Position = UDim2.fromOffset(0, 100)
ThemeContainer.BackgroundTransparency = 1

local Grid = Instance.new("UIGridLayout")
Grid.Parent = ThemeContainer
Grid.CellSize = UDim2.fromOffset(108, 40)
Grid.CellPadding = UDim2.fromOffset(8, 8)

for Name, Color in pairs(THEMES) do
    local Button = Instance.new("TextButton")
    Button.Parent = ThemeContainer
    Button.BackgroundColor3 = Color
    Button.BorderSizePixel = 0
    Button.Text = Name
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextSize = 11
    Button.Font = Enum.Font.GothamBold
    Corner(Button, 8)

    Button.MouseButton1Click:Connect(function()
        Accent = Color
        Menu.UIStroke.Color = Accent
        Icon.UIStroke.Color = Accent
        Logo.TextColor3 = Accent
        BottomUser.TextColor3 = Accent
        PlayerList.ScrollBarImageColor3 = Accent
        ServerList.ScrollBarImageColor3 = Accent
        FindServers.BackgroundColor3 = Accent

        for PageName, Nav in pairs(NavButtons) do
            if Pages[PageName].Visible then
                Nav.BackgroundColor3 = Accent
                Nav.TextColor3 = Color3.new(1, 1, 1)
            end
        end
    end)
end

-- ĐỔI TAB CHỨC NĂNG
local function ShowPage(Name)
    for PageName, Page in pairs(Pages) do
        Page.Visible = (PageName == Name)
    end
    for PageName, Button in pairs(NavButtons) do
        if PageName == Name then
            Button.BackgroundColor3 = Accent
            Button.TextColor3 = Color3.new(1, 1, 1)
        else
            Button.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
            Button.TextColor3 = Color3.fromRGB(150, 150, 165)
        end
    end
end

HomeNav.MouseButton1Click:Connect(function() ShowPage("Home") end)
PlayersNav.MouseButton1Click:Connect(function() ShowPage("Players") end)
ServerNav.MouseButton1Click:Connect(function() ShowPage("Server") end)
SettingsNav.MouseButton1Click:Connect(function() ShowPage("Settings") end)

ShowPage("Home")

-- CẬP NHẬT FPS & PING
local Frames = 0
local LastFPS = os.clock()
RunService.RenderStepped:Connect(function()
    Frames += 1
    local Now = os.clock()
    if Now - LastFPS >= 1 then
        FPSValue.Text = tostring(Frames)
        Frames = 0
        LastFPS = Now
    end
end)

task.spawn(function()
    while Gui.Parent do
        local Ping = 0
        pcall(function() Ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
        PingValue.Text = math.floor(Ping) .. " ms"
        PlayerCount.Text = tostring(#Players:GetPlayers())
        task.wait(1)
    end
end)

-- BẬT TẮT MENU (ICON TRÒN) - CHỈ HOẠT ĐỘNG KHI ICON CHƯA BỊ TẮT HẲN BỞI NÚT [×]
Icon.MouseButton1Click:Connect(function()
    if IconEnabled then
        Menu.Visible = not Menu.Visible
    end
end)

-- HỆ THỐNG ÂM THANH CLICK BÊN TRONG MENU
UserInputService.InputBegan:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not Menu.Visible then return end
        local pos = input.Position

        local function isInside(gui)
            if not gui or not gui.Parent then return false end
            local absPos, absSize = gui.AbsolutePosition, gui.AbsoluteSize
            return pos.X >= absPos.X and pos.X <= (absPos.X + absSize.X) 
               and pos.Y >= absPos.Y and pos.Y <= (absPos.Y + absSize.Y)
        end

        if isInside(Icon) then return end
        if isInside(Menu) then ClickSound:Play() end
    end
end)

-- KÉO DI CHUYỂN ICON NỔI
local DraggingIcon, IconDragStart, IconStartPosition = false, nil, nil
Icon.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        DraggingIcon = true
        IconDragStart = Input.Position
        IconStartPosition = Icon.Position
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not DraggingIcon then return end
    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
        local Delta = Input.Position - IconDragStart
        Icon.Position = UDim2.new(IconStartPosition.X.Scale, IconStartPosition.X.Offset + Delta.X, IconStartPosition.Y.Scale, IconStartPosition.Y.Offset + Delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        DraggingIcon = false
    end
end)

-- NÚT CO GIÃN CỬA SỔ (RESIZE GÓC DƯỚI PHẢI)
local Resize = Instance.new("TextButton")
Resize.Parent = Menu
Resize.Size = UDim2.fromOffset(26, 26)
Resize.Position = UDim2.new(1, -30, 1, -30)
Resize.BackgroundColor3 = Accent
Resize.BorderSizePixel = 0
Resize.Text = "◢"
Resize.TextColor3 = Color3.new(1, 1, 1)
Resize.TextSize = 12
Corner(Resize, 6)

local Resizing, ResizeStart, OriginalSize = false, nil, nil
Resize.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Resizing = true
        ResizeStart = Input.Position
        OriginalSize = Menu.AbsoluteSize
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Resizing then return end
    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
        local Delta = Input.Position - ResizeStart
        local W = math.clamp(OriginalSize.X + Delta.X, CONFIG.MinWidth, CONFIG.MaxWidth)
        local H = math.clamp(OriginalSize.Y + Delta.Y, CONFIG.MinHeight, CONFIG.MaxHeight)
        Menu.Size = UDim2.fromOffset(W, H)
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        Resizing = false
    end
end)

print("Luxury Dashboard with Full Audio & Controls loaded successfully!")