--========================================================
-- MODERN ROBLOX DASHBOARD
-- HOME + SERVER HOP + PLAYER TELEPORT + SETTINGS
-- LocalScript -> StarterPlayer > StarterPlayerScripts
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local CONFIG = {
    Theme = "Purple",
    MenuWidth = 700,
    MenuHeight = 450,
    MinWidth = 520,
    MaxWidth = 900,
    MinHeight = 350,
    MaxHeight = 650,
    MaxServerPlayers = 1, -- Giới hạn server 1 người
    UseRobloxAvatarForIcon = true,
    AnimeIcon = "",
    TeleportOffset = 5,
}

local THEMES = {
    Purple = Color3.fromRGB(155, 90, 255),
    Pink = Color3.fromRGB(255, 80, 170),
    Blue = Color3.fromRGB(70, 130, 255),
    Cyan = Color3.fromRGB(35, 205, 220),
    Green = Color3.fromRGB(60, 210, 120),
    Red = Color3.fromRGB(240, 70, 80),
    Orange = Color3.fromRGB(255, 145, 50),
}

local Accent = THEMES[CONFIG.Theme]
local UserId = LocalPlayer.UserId
local DisplayName = LocalPlayer.DisplayName
local Username = "@" .. LocalPlayer.Name
local AvatarURL = ""

pcall(function()
    AvatarURL = Players:GetUserThumbnailAsync(
        UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size420x420
    )
end)

local Old = PlayerGui:FindFirstChild("ModernDuyUI")
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

local Gui = Instance.new("ScreenGui")
Gui.Name = "ModernDuyUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 999999
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Icon = Instance.new("ImageButton")
Icon.Name = "MenuIcon"
Icon.Parent = Gui
Icon.Size = UDim2.fromOffset(60,60)
Icon.Position = UDim2.new(0,18,0.5,-30)
Icon.BackgroundColor3 = Color3.fromRGB(20,20,26)
Icon.BorderSizePixel = 0
Icon.AutoButtonColor = false

if CONFIG.UseRobloxAvatarForIcon and AvatarURL ~= "" then
    Icon.Image = AvatarURL
elseif CONFIG.AnimeIcon ~= "" then
    Icon.Image = CONFIG.AnimeIcon
end

Corner(Icon,30)
local IconStroke = Stroke(Icon,Accent,3)

local Menu = Instance.new("Frame")
Menu.Name = "MainMenu"
Menu.Parent = Gui
Menu.Size = UDim2.fromOffset(CONFIG.MenuWidth,CONFIG.MenuHeight)
Menu.Position = UDim2.new(0.5,-CONFIG.MenuWidth/2,0.5,-CONFIG.MenuHeight/2)
Menu.BackgroundColor3 = Color3.fromRGB(14,14,19)
Menu.BorderSizePixel = 0
Menu.Visible = false
Menu.ClipsDescendants = true
Corner(Menu,18)
local MenuStroke = Stroke(Menu,Accent,2)

-- SIDEBAR (GIỮ NGUYÊN BÊN TRÁI MENU)
local Sidebar = Instance.new("Frame")
Sidebar.Parent = Menu
Sidebar.Size = UDim2.new(0,155,1,0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20,20,27)
Sidebar.BorderSizePixel = 0
Corner(Sidebar,18)

local Logo = Instance.new("TextLabel")
Logo.Parent = Sidebar
Logo.Size = UDim2.new(1,-20,0,40)
Logo.Position = UDim2.fromOffset(10,8)
Logo.BackgroundTransparency = 1
Logo.Text = "DUY UI"
Logo.TextColor3 = Accent
Logo.TextSize = 21
Logo.Font = Enum.Font.GothamBlack

local SideAvatar = Instance.new("ImageLabel")
SideAvatar.Parent = Sidebar
SideAvatar.Size = UDim2.fromOffset(43,43)
SideAvatar.Position = UDim2.fromOffset(12,55)
SideAvatar.BackgroundColor3 = Color3.fromRGB(35,35,42)
SideAvatar.BorderSizePixel = 0
SideAvatar.Image = AvatarURL
Corner(SideAvatar,22)

local SideDisplay = Instance.new("TextLabel")
SideDisplay.Parent = Sidebar
SideDisplay.Size = UDim2.new(1,-65,0,20)
SideDisplay.Position = UDim2.fromOffset(63,56)
SideDisplay.BackgroundTransparency = 1
SideDisplay.Text = DisplayName
SideDisplay.TextColor3 = Color3.new(1,1,1)
SideDisplay.TextSize = 11
SideDisplay.Font = Enum.Font.GothamBold
SideDisplay.TextXAlignment = Enum.TextXAlignment.Left
SideDisplay.TextTruncate = Enum.TextTruncate.AtEnd

local SideUsername = Instance.new("TextLabel")
SideUsername.Parent = Sidebar
SideUsername.Size = UDim2.new(1,-65,0,18)
SideUsername.Position = UDim2.fromOffset(63,78)
SideUsername.BackgroundTransparency = 1
SideUsername.Text = Username
SideUsername.TextColor3 = Color3.fromRGB(145,145,155)
SideUsername.TextSize = 9
SideUsername.Font = Enum.Font.Gotham
SideUsername.TextXAlignment = Enum.TextXAlignment.Left

local Pages = {}
local NavButtons = {}

local function MakePage(Name)
    local Page = Instance.new("Frame")
    Page.Name = Name
    Page.Parent = Menu
    Page.Size = UDim2.new(1,-170,1,-20)
    Page.Position = UDim2.fromOffset(160,10)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Pages[Name] = Page
    return Page
end

local function MakeNav(Text,Y,PageName)
    local Button = Instance.new("TextButton")
    Button.Parent = Sidebar
    Button.Size = UDim2.new(1,-20,0,40)
    Button.Position = UDim2.fromOffset(10,Y)
    Button.BackgroundTransparency = 1
    Button.BorderSizePixel = 0
    Button.Text = Text
    Button.TextColor3 = Color3.fromRGB(165,165,175)
    Button.TextSize = 12
    Button.Font = Enum.Font.GothamMedium
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Corner(Button,9)
    NavButtons[PageName] = Button
    return Button
end

local HomePage = MakePage("Home")
local PlayersPage = MakePage("Players")
local ServerPage = MakePage("Server")
local SettingsPage = MakePage("Settings")

local HomeNav = MakeNav("  🏠   HOME",125,"Home")
local PlayersNav = MakeNav("  👥   PLAYERS",171,"Players")
local ServerNav = MakeNav("  🌐   SERVER HOP",217,"Server")
local SettingsNav = MakeNav("  ⚙️   SETTINGS",263,"Settings")

local BottomProfile = Instance.new("Frame")
BottomProfile.Parent = Sidebar
BottomProfile.Size = UDim2.new(1,-20,0,60)
BottomProfile.Position = UDim2.new(0,10,1,-70)
BottomProfile.BackgroundColor3 = Color3.fromRGB(27,27,35)
BottomProfile.BorderSizePixel = 0
Corner(BottomProfile,11)

local BottomAvatar = Instance.new("ImageLabel")
BottomAvatar.Parent = BottomProfile
BottomAvatar.Size = UDim2.fromOffset(42,42)
BottomAvatar.Position = UDim2.fromOffset(7,9)
BottomAvatar.BackgroundTransparency = 1
BottomAvatar.Image = AvatarURL
Corner(BottomAvatar,21)

local BottomName = Instance.new("TextLabel")
BottomName.Parent = BottomProfile
BottomName.Size = UDim2.new(1,-58,0,20)
BottomName.Position = UDim2.fromOffset(55,9)
BottomName.BackgroundTransparency = 1
BottomName.Text = DisplayName
BottomName.TextColor3 = Color3.new(1,1,1)
BottomName.TextSize = 10
BottomName.Font = Enum.Font.GothamBold
BottomName.TextXAlignment = Enum.TextXAlignment.Left
BottomName.TextTruncate = Enum.TextTruncate.AtEnd

local BottomUser = Instance.new("TextLabel")
BottomUser.Parent = BottomProfile
BottomUser.Size = UDim2.new(1,-58,0,18)
BottomUser.Position = UDim2.fromOffset(55,29)
BottomUser.BackgroundTransparency = 1
BottomUser.Text = Username
BottomUser.TextColor3 = Accent
BottomUser.TextSize = 9
BottomUser.Font = Enum.Font.Gotham
BottomUser.TextXAlignment = Enum.TextXAlignment.Left

local function PageTitle(Page,Main,Sub)
    local Title = Instance.new("TextLabel")
    Title.Parent = Page
    Title.Size = UDim2.new(1,-10,0,32)
    Title.Position = UDim2.fromOffset(5,5)
    Title.BackgroundTransparency = 1
    Title.Text = Main
    Title.TextColor3 = Color3.new(1,1,1)
    Title.TextSize = 23
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Parent = Page
    Subtitle.Size = UDim2.new(1,-10,0,20)
    Subtitle.Position = UDim2.fromOffset(5,37)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = Sub
    Subtitle.TextColor3 = Color3.fromRGB(125,125,135)
    Subtitle.TextSize = 10
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
end

PageTitle(HomePage,"Welcome back 👋","Thông tin tài khoản và hiệu năng")

local function StatCard(Page,X,Y,W,Label)
    local Card = Instance.new("Frame")
    Card.Parent = Page
    Card.Size = UDim2.fromOffset(W,82)
    Card.Position = UDim2.fromOffset(X,Y)
    Card.BackgroundColor3 = Color3.fromRGB(25,25,32)
    Card.BorderSizePixel = 0
    Corner(Card,12)

    local L = Instance.new("TextLabel")
    L.Parent = Card
    L.Size = UDim2.new(1,-18,0,20)
    L.Position = UDim2.fromOffset(9,8)
    L.BackgroundTransparency = 1
    L.Text = Label
    L.TextColor3 = Color3.fromRGB(140,140,150)
    L.TextSize = 9
    L.Font = Enum.Font.Gotham
    L.TextXAlignment = Enum.TextXAlignment.Left

    local V = Instance.new("TextLabel")
    V.Parent = Card
    V.Size = UDim2.new(1,-18,0,40)
    V.Position = UDim2.fromOffset(9,30)
    V.BackgroundTransparency = 1
    V.Text = "--"
    V.TextColor3 = Accent
    V.TextSize = 23
    V.Font = Enum.Font.GothamBold
    V.TextXAlignment = Enum.TextXAlignment.Left
    return V
end

local FPSValue = StatCard(HomePage,5,72,145,"FPS")
local PingValue = StatCard(HomePage,160,72,145,"PING / MS")
local PlayerCount = StatCard(HomePage,5,165,145,"PLAYERS")
local UserIDValue = StatCard(HomePage,160,165,145,"USER ID")
UserIDValue.Text = tostring(UserId)

local HomeProfile = Instance.new("Frame")
HomeProfile.Parent = HomePage
HomeProfile.Size = UDim2.new(1,-10,0,125)
HomeProfile.Position = UDim2.fromOffset(5,260)
HomeProfile.BackgroundColor3 = Color3.fromRGB(25,25,32)
HomeProfile.BorderSizePixel = 0
Corner(HomeProfile,14)

local HomeAvatar = Instance.new("ImageLabel")
HomeAvatar.Parent = HomeProfile
HomeAvatar.Size = UDim2.fromOffset(88,88)
HomeAvatar.Position = UDim2.fromOffset(15,18)
HomeAvatar.BackgroundTransparency = 1
HomeAvatar.Image = AvatarURL
Corner(HomeAvatar,44)

local HomeDisplay = Instance.new("TextLabel")
HomeDisplay.Parent = HomeProfile
HomeDisplay.Size = UDim2.new(1,-125,0,30)
HomeDisplay.Position = UDim2.fromOffset(120,22)
HomeDisplay.BackgroundTransparency = 1
HomeDisplay.Text = DisplayName
HomeDisplay.TextColor3 = Color3.new(1,1,1)
HomeDisplay.TextSize = 18
HomeDisplay.Font = Enum.Font.GothamBold
HomeDisplay.TextXAlignment = Enum.TextXAlignment.Left

local HomeUser = Instance.new("TextLabel")
HomeUser.Parent = HomeProfile
HomeUser.Size = UDim2.new(1,-125,0,25)
HomeUser.Position = UDim2.fromOffset(120,53)
HomeUser.BackgroundTransparency = 1
HomeUser.Text = Username
HomeUser.TextColor3 = Accent
HomeUser.TextSize = 12
HomeUser.Font = Enum.Font.GothamMedium
HomeUser.TextXAlignment = Enum.TextXAlignment.Left

local HomePlace = Instance.new("TextLabel")
HomePlace.Parent = HomeProfile
HomePlace.Size = UDim2.new(1,-125,0,35)
HomePlace.Position = UDim2.fromOffset(120,78)
HomePlace.BackgroundTransparency = 1
HomePlace.Text = "Place ID: "..game.PlaceId
HomePlace.TextColor3 = Color3.fromRGB(130,130,140)
HomePlace.TextSize = 10
HomePlace.Font = Enum.Font.Gotham
HomePlace.TextXAlignment = Enum.TextXAlignment.Left

PageTitle(PlayersPage,"Players 👥","Người chơi hiện tại trong server")

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Parent = PlayersPage
PlayerList.Size = UDim2.new(1,-10,1,-70)
PlayerList.Position = UDim2.fromOffset(5,65)
PlayerList.BackgroundTransparency = 1
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 4
PlayerList.ScrollBarImageColor3 = Accent

local PlayerLayout = Instance.new("UIListLayout")
PlayerLayout.Parent = PlayerList
PlayerLayout.Padding = UDim.new(0,7)

PlayerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerList.CanvasSize = UDim2.new(0,0,0,PlayerLayout.AbsoluteContentSize.Y+10)
end)

local function TeleportToPlayer(Target)
    if Target == LocalPlayer then return end

    local MyCharacter = LocalPlayer.Character
    local TargetCharacter = Target.Character

    if not MyCharacter or not TargetCharacter then return end

    local TargetRoot = TargetCharacter:FindFirstChild("HumanoidRootPart")
    if not TargetRoot then return end

    MyCharacter:PivotTo(
        TargetRoot.CFrame * CFrame.new(0,0,CONFIG.TeleportOffset)
    )
end

local function RefreshPlayers()
    for _,Child in ipairs(PlayerList:GetChildren()) do
        if Child:IsA("Frame") then Child:Destroy() end
    end

    for _,Target in ipairs(Players:GetPlayers()) do
        if Target ~= LocalPlayer then
            local Row = Instance.new("Frame")
            Row.Parent = PlayerList
            Row.Size = UDim2.new(1,-5,0,68)
            Row.BackgroundColor3 = Color3.fromRGB(25,25,32)
            Row.BorderSizePixel = 0
            Corner(Row,12)

            local Avatar = Instance.new("ImageLabel")
            Avatar.Parent = Row
            Avatar.Size = UDim2.fromOffset(50,50)
            Avatar.Position = UDim2.fromOffset(8,9)
            Avatar.BackgroundTransparency = 1
            Corner(Avatar,25)

            task.spawn(function()
                local Success,Image = pcall(function()
                    return Players:GetUserThumbnailAsync(
                        Target.UserId,
                        Enum.ThumbnailType.HeadShot,
                        Enum.ThumbnailSize.Size150x150
                    )
                end)
                if Success and Avatar.Parent then Avatar.Image = Image end
            end)

            local Name = Instance.new("TextLabel")
            Name.Parent = Row
            Name.Size = UDim2.new(1,-145,0,24)
            Name.Position = UDim2.fromOffset(68,10)
            Name.BackgroundTransparency = 1
            Name.Text = Target.DisplayName
            Name.TextColor3 = Color3.new(1,1,1)
            Name.TextSize = 12
            Name.Font = Enum.Font.GothamBold
            Name.TextXAlignment = Enum.TextXAlignment.Left
            Name.TextTruncate = Enum.TextTruncate.AtEnd

            local User = Instance.new("TextLabel")
            User.Parent = Row
            User.Size = UDim2.new(1,-145,0,20)
            User.Position = UDim2.fromOffset(68,34)
            User.BackgroundTransparency = 1
            User.Text = "@"..Target.Name
            User.TextColor3 = Color3.fromRGB(135,135,145)
            User.TextSize = 10
            User.Font = Enum.Font.Gotham
            User.TextXAlignment = Enum.TextXAlignment.Left

            local Teleport = Instance.new("TextButton")
            Teleport.Parent = Row
            Teleport.Size = UDim2.fromOffset(68,38)
            Teleport.Position = UDim2.new(1,-76,0.5,-19)
            Teleport.BackgroundColor3 = Accent
            Teleport.BorderSizePixel = 0
            Teleport.Text = "TELE"
            Teleport.TextColor3 = Color3.new(1,1,1)
            Teleport.TextSize = 10
            Teleport.Font = Enum.Font.GothamBold
            Corner(Teleport,8)

            Teleport.MouseButton1Click:Connect(function()
                TeleportToPlayer(Target)
            end)
        end
    end
end

RefreshPlayers()

Players.PlayerAdded:Connect(function()
    task.wait(0.2)
    RefreshPlayers()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.1)
    RefreshPlayers()
end)

-- ========================================================
-- PHẦN SERVER HOP
-- ========================================================
PageTitle(ServerPage,"Server Hop 🌐","Tìm server có 1 người chơi")

-- Nút HOP (Nằm bên trái nút TÌM LẠI SERVER)
local HopButton = Instance.new("TextButton")
HopButton.Parent = ServerPage
HopButton.Size = UDim2.new(0,110,0,42)
HopButton.Position = UDim2.fromOffset(5,65)
HopButton.BackgroundColor3 = Accent
HopButton.BorderSizePixel = 0
HopButton.Text = "Hop"
HopButton.TextColor3 = Color3.new(1,1,1)
HopButton.TextSize = 13
HopButton.Font = Enum.Font.GothamBold
Corner(HopButton,10)

-- Nút TÌM LẠI SERVER
local FindServers = Instance.new("TextButton")
FindServers.Parent = ServerPage
FindServers.Size = UDim2.new(1,-125,0,42)
FindServers.Position = UDim2.fromOffset(120,65)
FindServers.BackgroundColor3 = Accent
FindServers.BorderSizePixel = 0
FindServers.Text = "🔄  TÌM LẠI SERVER"
FindServers.TextColor3 = Color3.new(1,1,1)
FindServers.TextSize = 12
FindServers.Font = Enum.Font.GothamBold
Corner(FindServers,10)

local ServerStatus = Instance.new("TextLabel")
ServerStatus.Parent = ServerPage
ServerStatus.Size = UDim2.new(1,-10,0,25)
ServerStatus.Position = UDim2.fromOffset(5,110)
ServerStatus.BackgroundTransparency = 1
ServerStatus.Text = "Chưa tìm server"
ServerStatus.TextColor3 = Color3.fromRGB(140,140,150)
ServerStatus.TextSize = 10
ServerStatus.Font = Enum.Font.Gotham
ServerStatus.TextXAlignment = Enum.TextXAlignment.Left

local ServerList = Instance.new("ScrollingFrame")
ServerList.Parent = ServerPage
ServerList.Size = UDim2.new(1,-10,1,-145)
ServerList.Position = UDim2.fromOffset(5,140)
ServerList.BackgroundTransparency = 1
ServerList.BorderSizePixel = 0
ServerList.ScrollBarThickness = 4
ServerList.ScrollBarImageColor3 = Accent

local ServerLayout = Instance.new("UIListLayout")
ServerLayout.Parent = ServerList
ServerLayout.Padding = UDim.new(0,7)

ServerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ServerList.CanvasSize = UDim2.new(0,0,0,ServerLayout.AbsoluteContentSize.Y+10)
end)

local function ClearServers()
    for _,Child in ipairs(ServerList:GetChildren()) do
        if Child:IsA("Frame") then Child:Destroy() end
    end
end

local function GetServers()
    local Servers = {}
    local Cursor = nil

    for _ = 1,10 do
        local URL =
            "https://games.roblox.com/v1/games/"..
            game.PlaceId..
            "/servers/Public?sortOrder=Asc&limit=100"

        if Cursor then
            URL = URL.."&cursor="..HttpService:UrlEncode(Cursor)
        end

        local Success,Response = pcall(function()
            return HttpService:GetAsync(URL)
        end)

        if not Success then break end

        local Data
        local DecodeSuccess = pcall(function()
            Data = HttpService:JSONDecode(Response)
        end)

        if not DecodeSuccess or not Data then break end

        for _,Server in ipairs(Data.data or {}) do
            local Playing = tonumber(Server.playing) or 999

            -- Chỉ chọn server có đúng 1 người chơi
            if Server.id ~= game.JobId and Playing == 1 then
                table.insert(Servers,Server)
            end
        end

        Cursor = Data.nextPageCursor
        if not Cursor then break end
        task.wait(0.1)
    end

    table.sort(Servers,function(A,B)
        return (tonumber(A.playing) or 999) < (tonumber(B.playing) or 999)
    end)

    return Servers
end

local function AddServer(Server)
    local Playing = tonumber(Server.playing) or 0
    local MaxPlayers = tonumber(Server.maxPlayers) or 0

    local Row = Instance.new("Frame")
    Row.Parent = ServerList
    Row.Size = UDim2.new(1,-5,0,65)
    Row.BackgroundColor3 = Color3.fromRGB(25,25,32)
    Row.BorderSizePixel = 0
    Corner(Row,12)

    local Info = Instance.new("TextLabel")
    Info.Parent = Row
    Info.Size = UDim2.new(1,-85,1,0)
    Info.Position = UDim2.fromOffset(12,0)
    Info.BackgroundTransparency = 1
    Info.Text = "SERVER 1 NGƯỜI\n👥 "..Playing.." / "..MaxPlayers
    Info.TextColor3 = Color3.new(1,1,1)
    Info.TextSize = 11
    Info.Font = Enum.Font.GothamMedium
    Info.TextXAlignment = Enum.TextXAlignment.Left

    -- Nút Join dạng Icon 🚀
    local Join = Instance.new("TextButton")
    Join.Parent = Row
    Join.Size = UDim2.fromOffset(60,40)
    Join.Position = UDim2.new(1,-68,0.5,-20)
    Join.BackgroundColor3 = Accent
    Join.BorderSizePixel = 0
    Join.Text = "🚀"
    Join.TextColor3 = Color3.new(1,1,1)
    Join.TextSize = 18
    Join.Font = Enum.Font.GothamBold
    Corner(Join,8)

    Join.MouseButton1Click:Connect(function()
        Join.Active = false
        Join.Text = "..."
        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            Server.id,
            LocalPlayer
        )
    end)
end

local SearchingServers = false
local CurrentFoundServers = {}

FindServers.MouseButton1Click:Connect(function()
    if SearchingServers then return end

    SearchingServers = true
    ClearServers()

    FindServers.Text = "⏳  ĐANG TÌM..."
    ServerStatus.Text = "Đang tìm kiếm server 1 người..."

    task.spawn(function()
        CurrentFoundServers = GetServers()

        if #CurrentFoundServers == 0 then
            ServerStatus.Text = "❌ Không tìm thấy server 1 người chơi nào"
        else
            ServerStatus.Text = "✓ Tìm thấy "..#CurrentFoundServers.." server 1 người"
            for _,Server in ipairs(CurrentFoundServers) do
                AddServer(Server)
            end
        end

        SearchingServers = false
        FindServers.Text = "🔄  TÌM LẠI SERVER"
    end)
end)

-- Nút Hop thực hiện chuyển tới server 1 người đầu tiên tìm thấy
HopButton.MouseButton1Click:Connect(function()
    if #CurrentFoundServers > 0 then
        HopButton.Text = "⏳..."
        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            CurrentFoundServers[1].id,
            LocalPlayer
        )
    else
        ServerStatus.Text = "⚠️ Bấm 'TÌM LẠI SERVER' trước để quét danh sách server!"
    end
end)

-- ========================================================
-- SETTINGS PAGE
-- ========================================================
PageTitle(SettingsPage,"Settings ⚙️","Tùy chỉnh giao diện")

local ThemeLabel = Instance.new("TextLabel")
ThemeLabel.Parent = SettingsPage
ThemeLabel.Size = UDim2.new(1,-10,0,25)
ThemeLabel.Position = UDim2.fromOffset(5,70)
ThemeLabel.BackgroundTransparency = 1
ThemeLabel.Text = "THEME COLOR"
ThemeLabel.TextColor3 = Color3.new(1,1,1)
ThemeLabel.TextSize = 12
ThemeLabel.Font = Enum.Font.GothamBold
ThemeLabel.TextXAlignment = Enum.TextXAlignment.Left

local ThemeContainer = Instance.new("Frame")
ThemeContainer.Parent = SettingsPage
ThemeContainer.Size = UDim2.new(1,-10,0,180)
ThemeContainer.Position = UDim2.fromOffset(5,105)
ThemeContainer.BackgroundTransparency = 1

local Grid = Instance.new("UIGridLayout")
Grid.Parent = ThemeContainer
Grid.CellSize = UDim2.fromOffset(105,42)
Grid.CellPadding = UDim2.fromOffset(8,8)

for Name,Color in pairs(THEMES) do
    local Button = Instance.new("TextButton")
    Button.Parent = ThemeContainer
    Button.BackgroundColor3 = Color
    Button.BorderSizePixel = 0
    Button.Text = Name
    Button.TextColor3 = Color3.new(1,1,1)
    Button.TextSize = 11
    Button.Font = Enum.Font.GothamBold
    Corner(Button,9)

    Button.MouseButton1Click:Connect(function()
        Accent = Color
        MenuStroke.Color = Accent
        IconStroke.Color = Accent
        Logo.TextColor3 = Accent
        BottomUser.TextColor3 = Accent
        HomeUser.TextColor3 = Accent
        FPSValue.TextColor3 = Accent
        PingValue.TextColor3 = Accent
        PlayerCount.TextColor3 = Accent
        UserIDValue.TextColor3 = Accent
        PlayerList.ScrollBarImageColor3 = Accent
        ServerList.ScrollBarImageColor3 = Accent
        FindServers.BackgroundColor3 = Accent
        HopButton.BackgroundColor3 = Accent

        for PageName,Nav in pairs(NavButtons) do
            if Pages[PageName].Visible then
                Nav.BackgroundColor3 = Accent
            end
        end
    end)
end

local function ShowPage(Name)
    for PageName,Page in pairs(Pages) do
        Page.Visible = PageName == Name
    end

    for _,Button in pairs(NavButtons) do
        Button.BackgroundTransparency = 1
        Button.TextColor3 = Color3.fromRGB(165,165,175)
    end

    local Active = NavButtons[Name]
    if Active then
        Active.BackgroundTransparency = 0
        Active.BackgroundColor3 = Accent
        Active.TextColor3 = Color3.new(1,1,1)
    end
end

HomeNav.MouseButton1Click:Connect(function() ShowPage("Home") end)
PlayersNav.MouseButton1Click:Connect(function() ShowPage("Players") end)
ServerNav.MouseButton1Click:Connect(function() ShowPage("Server") end)
SettingsNav.MouseButton1Click:Connect(function() ShowPage("Settings") end)

ShowPage("Home")

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

        pcall(function()
            Ping =
                Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)

        PingValue.Text = math.floor(Ping).." ms"
        PlayerCount.Text = tostring(#Players:GetPlayers())

        task.wait(1)
    end
end)

Icon.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)

-- DRAG ICON
local DraggingIcon = false
local IconDragStart
local IconStartPosition

Icon.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        DraggingIcon = true
        IconDragStart = Input.Position
        IconStartPosition = Icon.Position
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not DraggingIcon then return end

    if Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then

        local Delta = Input.Position - IconDragStart

        Icon.Position = UDim2.new(
            IconStartPosition.X.Scale,
            IconStartPosition.X.Offset + Delta.X,
            IconStartPosition.Y.Scale,
            IconStartPosition.Y.Offset + Delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        DraggingIcon = false
    end
end)

-- RESIZE MENU
local Resize = Instance.new("TextButton")
Resize.Parent = Menu
Resize.Size = UDim2.fromOffset(30,30)
Resize.Position = UDim2.new(1,-34,1,-34)
Resize.BackgroundColor3 = Accent
Resize.BorderSizePixel = 0
Resize.Text = "↘"
Resize.TextColor3 = Color3.new(1,1,1)
Resize.TextSize = 17
Resize.Font = Enum.Font.GothamBold
Corner(Resize,8)

local Resizing = false
local ResizeStart
local OriginalSize

Resize.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Resizing = true
        ResizeStart = Input.Position
        OriginalSize = Menu.AbsoluteSize
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Resizing then return end

    if Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then

        local Delta = Input.Position - ResizeStart

        local W = math.clamp(
            OriginalSize.X + Delta.X,
            CONFIG.MinWidth,
            CONFIG.MaxWidth
        )

        local H = math.clamp(
            OriginalSize.Y + Delta.Y,
            CONFIG.MinHeight,
            CONFIG.MaxHeight
        )

        Menu.Size = UDim2.fromOffset(W,H)
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Resizing = false
    end
end)

print("Modern Dashboard loaded")
