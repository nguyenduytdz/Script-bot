-- ==============================================================================
-- Project: Luxury Dashboard UI (28 MASTER TABS + APPLE DYNAMIC ISLAND & STATUS)
-- Author: Kit_n67 | Upgraded for Boss Man
-- ==============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- BẢO MẬT ADMIN
local ADMIN_USERNAME = "kit_n67"
local isAdmin = (LocalPlayer.Name:lower() == ADMIN_USERNAME:lower())

-- CẤU HÌNH BẢO TRÌ
local MAINTENANCE_CONFIG = {
    Enabled = false,               -- false: TẮT BẢO TRÌ | true: BẬT BẢO TRÌ
    Duration = 10,                 -- Thời gian đếm ngược (giây)
    Reason = "Hệ thống Luxury Hub đang nâng cấp trọn bộ 28 Tab + Dynamic Island. Vui lòng chờ!"
}

local CONFIG = {
    Theme = "Purple",
    MenuWidth = 850,
    MenuHeight = 540,
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

local function Stroke(Object, Color, Thickness, Trans)
    local S = Instance.new("UIStroke")
    S.Color = Color
    S.Thickness = Thickness or 1
    S.Transparency = Trans or 0.3
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

-- ==========================================================
-- 📱 APPLE DYNAMIC ISLAND + THANH STATUS BÊN DƯỚI (CHỮ TO)
-- ==========================================================
local DynamicIsland = Instance.new("TextButton")
DynamicIsland.Name = "AppleDynamicIsland"
DynamicIsland.Parent = Gui
DynamicIsland.Size = UDim2.fromOffset(240, 42)                    -- Tỉ lệ chuẩn Pill Shape chuẩn Apple
DynamicIsland.Position = UDim2.new(0.5, -120, 0, 10)
DynamicIsland.BackgroundColor3 = Color3.fromRGB(0, 0, 0)          -- Màu đen tuyền OLED
DynamicIsland.BorderSizePixel = 0
DynamicIsland.AutoButtonColor = false
DynamicIsland.Text = ""
DynamicIsland.ClipsDescendants = true
Corner(DynamicIsland, 21)
Stroke(DynamicIsland, Color3.fromRGB(45, 45, 60), 1.5, 0.3)

-- MÔ PHỎNG CAMERA & FACEID
local CameraLens = Instance.new("Frame")
CameraLens.Parent = DynamicIsland
CameraLens.Size = UDim2.fromOffset(12, 12)
CameraLens.Position = UDim2.fromOffset(15, 15)
CameraLens.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
Corner(CameraLens, 6)

local FaceIDSensor = Instance.new("Frame")
FaceIDSensor.Parent = DynamicIsland
FaceIDSensor.Size = UDim2.fromOffset(8, 8)
FaceIDSensor.Position = UDim2.fromOffset(32, 17)
FaceIDSensor.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Corner(FaceIDSensor, 4)

local IslandTitle = Instance.new("TextLabel")
IslandTitle.Parent = DynamicIsland
IslandTitle.Size = UDim2.new(1, -110, 0, 20)
IslandTitle.Position = UDim2.fromOffset(48, 11)
IslandTitle.BackgroundTransparency = 1
IslandTitle.Text = "LUXURY DYNAMIC"
IslandTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
IslandTitle.TextSize = 11
IslandTitle.Font = Enum.Font.GothamBold
IslandTitle.TextXAlignment = Enum.TextXAlignment.Left

local ClockLabel = Instance.new("TextLabel")
ClockLabel.Parent = DynamicIsland
ClockLabel.Size = UDim2.fromOffset(60, 42)
ClockLabel.Position = UDim2.new(1, -65, 0, 0)
ClockLabel.BackgroundTransparency = 1
ClockLabel.Text = "00:00"
ClockLabel.TextColor3 = Accent
ClockLabel.TextSize = 12
ClockLabel.Font = Enum.Font.GothamBold

-- 🌟 THANH STATUS NẰM BÊN DƯỚI (CHỮ TO, RÕ NÉT)
local StatusContainer = Instance.new("Frame")
StatusContainer.Name = "StatusContainer"
StatusContainer.Parent = Gui
StatusContainer.Size = UDim2.fromOffset(360, 32)
StatusContainer.Position = UDim2.new(0.5, -180, 0, 56)
StatusContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Corner(StatusContainer, 10)
Stroke(StatusContainer, Accent, 1, 0.4)

local StatusIcon = Instance.new("TextLabel")
StatusIcon.Parent = StatusContainer
StatusIcon.Size = UDim2.fromOffset(25, 32)
StatusIcon.Position = UDim2.fromOffset(8, 0)
StatusIcon.BackgroundTransparency = 1
StatusIcon.Text = "⚡"
StatusIcon.TextSize = 14

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = StatusContainer
StatusLabel.Size = UDim2.new(1, -40, 1, 0)
StatusLabel.Position = UDim2.fromOffset(32, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Đang khởi tạo hệ thống..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 13                                          -- Chữ to rõ ràng!
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextTruncate = Enum.TextTruncate.AtEnd

-- HIỆU ỨNG NỔI BẬT KHI CÓ STATUS MỚI
local function SetStatus(text)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
    TweenService:Create(StatusLabel, TweenInfo.new(0.4), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end

-- CHI TIẾT KHI CLICK DYNAMIC ISLAND
local IslandExpandedContent = Instance.new("Frame")
IslandExpandedContent.Parent = DynamicIsland
IslandExpandedContent.Size = UDim2.new(1, -20, 0, 25)
IslandExpandedContent.Position = UDim2.fromOffset(10, 42)
IslandExpandedContent.BackgroundTransparency = 1
IslandExpandedContent.Visible = false

local FpsPingText = Instance.new("TextLabel")
FpsPingText.Parent = IslandExpandedContent
FpsPingText.Size = UDim2.new(1, 0, 1, 0)
FpsPingText.BackgroundTransparency = 1
FpsPingText.Text = "⚡ 60 FPS   •   🌐 0 ms"
FpsPingText.TextColor3 = Color3.fromRGB(200, 200, 220)
FpsPingText.TextSize = 11
FpsPingText.Font = Enum.Font.GothamBold

local isIslandExpanded = false
DynamicIsland.MouseButton1Click:Connect(function()
    ClickSound:Play()
    isIslandExpanded = not isIslandExpanded
    
    if isIslandExpanded then
        TweenService:Create(DynamicIsland, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(320, 72),
            Position = UDim2.new(0.5, -160, 0, 10)
        }):Play()
        IslandExpandedContent.Visible = true
    else
        TweenService:Create(DynamicIsland, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(240, 42),
            Position = UDim2.new(0.5, -120, 0, 10)
        }):Play()
        IslandExpandedContent.Visible = false
    end
end)

local currentFPS, currentPing = 60, 0
task.spawn(function()
    while Gui.Parent do
        local now = os.date("*t")
        ClockLabel.Text = string.format("%02d:%02d", now.hour, now.min)
        pcall(function() currentPing = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        FpsPingText.Text = "⚡ " .. currentFPS .. " FPS   •   🌐 " .. currentPing .. " ms"
        task.wait(1)
    end
end)

-- ==========================================================
-- KHỞI TẠO MENU CHÍNH
-- ==========================================================
local function StartMainDashboard()
    SetStatus("Menu chính đã sẵn sàng!")

    local Icon = Instance.new("ImageButton")
    Icon.Name = "MenuIcon"
    Icon.Parent = Gui
    Icon.Size = UDim2.fromOffset(52, 52)
    Icon.Position = UDim2.new(0, 20, 0.5, -26)
    Icon.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    Icon.BorderSizePixel = 0
    Icon.AutoButtonColor = false
    Icon.Image = "rbxthumb://type=Asset&id=113875514885319&w=150&h=150"
    Corner(Icon, 26)
    Stroke(Icon, Accent, 2)

    local Menu = Instance.new("Frame")
    Menu.Name = "MainMenu"
    Menu.Parent = Gui
    Menu.Size = UDim2.fromOffset(CONFIG.MenuWidth, CONFIG.MenuHeight)
    Menu.Position = UDim2.new(0.5, -CONFIG.MenuWidth/2, 0.5, -CONFIG.MenuHeight/2)
    Menu.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    Menu.BorderSizePixel = 0
    Menu.Visible = true
    Menu.ClipsDescendants = true
    Corner(Menu, 16)
    Stroke(Menu, Accent, 1.5)

    local DragHeader = Instance.new("Frame")
    DragHeader.Parent = Menu
    DragHeader.Size = UDim2.new(1, -110, 0, 35)
    DragHeader.Position = UDim2.fromOffset(0, 0)
    DragHeader.BackgroundTransparency = 1
    DragHeader.ZIndex = 5

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
            ClickSound:Play()
            Callback()
        end)
        return Btn
    end

    local IsMaximized = false
    local NormalSize = UDim2.fromOffset(CONFIG.MenuWidth, CONFIG.MenuHeight)
    local NormalPos = Menu.Position

    MakeTopBtn(0, "—", function() Menu.Visible = false SetStatus("Ẩn giao diện Menu") end)

    MakeTopBtn(32, "🗖", function()
        IsMaximized = not IsMaximized
        if IsMaximized then
            NormalSize = Menu.Size
            NormalPos = Menu.Position
            Menu.Size = UDim2.new(0, 950, 0, 640)
            Menu.Position = UDim2.new(0.5, -475, 0.5, -320)
            SetStatus("Phóng to màn hình Menu")
        else
            Menu.Size = NormalSize
            Menu.Position = NormalPos
            SetStatus("Thu nhỏ màn hình Menu")
        end
    end)

    local IconEnabled = true
    MakeTopBtn(64, "×", function()
        Menu.Visible = false
        IconEnabled = false
        Icon.Visible = false
        SetStatus("Tắt Menu hoàn toàn")
    end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = Menu
    Sidebar.Size = UDim2.new(0, 210, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    Sidebar.BorderSizePixel = 0
    Corner(Sidebar, 16)

    local Logo = Instance.new("TextLabel")
    Logo.Parent = Sidebar
    Logo.Size = UDim2.new(1, -20, 0, 45)
    Logo.Position = UDim2.fromOffset(15, 10)
    Logo.BackgroundTransparency = 1
    Logo.Text = "LUXURY HUB 28T"
    Logo.TextColor3 = Accent
    Logo.TextSize = 15
    Logo.Font = Enum.Font.GothamBold
    Logo.TextXAlignment = Enum.TextXAlignment.Left

    local NavScroll = Instance.new("ScrollingFrame")
    NavScroll.Parent = Sidebar
    NavScroll.Size = UDim2.new(1, 0, 1, -115)
    NavScroll.Position = UDim2.fromOffset(0, 50)
    NavScroll.BackgroundTransparency = 1
    NavScroll.BorderSizePixel = 0
    NavScroll.ScrollBarThickness = 2
    NavScroll.ScrollBarImageColor3 = Accent

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.Parent = NavScroll
    NavLayout.Padding = UDim.new(0, 3)

    local Pages = {}
    local NavButtons = {}

    local function MakePage(Name)
        local Page = Instance.new("Frame")
        Page.Name = Name
        Page.Parent = Menu
        Page.Size = UDim2.new(1, -230, 1, -20)
        Page.Position = UDim2.fromOffset(220, 10)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Pages[Name] = Page
        return Page
    end

    local function MakeNav(Text, PageName)
        local Button = Instance.new("TextButton")
        Button.Parent = NavScroll
        Button.Size = UDim2.new(1, -20, 0, 28)
        Button.Position = UDim2.fromOffset(10, 0)
        Button.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
        Button.BackgroundTransparency = 1
        Button.BorderSizePixel = 0
        Button.Text = Text
        Button.TextColor3 = Color3.fromRGB(150, 150, 165)
        Button.TextSize = 10
        Button.Font = Enum.Font.GothamMedium
        Button.TextXAlignment = Enum.TextXAlignment.Left
        
        local TextPadding = Instance.new("UIPadding")
        TextPadding.PaddingLeft = UDim.new(0, 10)
        TextPadding.Parent = Button

        Corner(Button, 7)
        NavButtons[PageName] = Button
        return Button
    end

    -- KHỞI TẠO TẤT CẢ 28 TAB
    local HomePage = MakePage("Home")
    local UtilityPage = MakePage("Utility")
    local FlyNoclipPage = MakePage("FlyNoclip")
    local CombatPage = MakePage("Combat")
    local AutoFarmPage = MakePage("AutoFarm")
    local SpinFovPage = MakePage("SpinFov")
    local TargetPage = MakePage("Target")
    local AntiAfkPage = MakePage("AntiAfk")
    local EspPage = MakePage("Esp")
    local VisualsPage = MakePage("Visuals")
    local PresetsPage = MakePage("Presets")
    local PosPage = MakePage("Positions")
    local VehiclePage = MakePage("Vehicle")
    local InventoryPage = MakePage("Inventory")
    local CmdPage = MakePage("CommandBar")
    local ScriptHubPage = MakePage("ScriptHub")
    local AudioPage = MakePage("Audio")
    local AnnouncePage = MakePage("Announce")
    local WebhookPage = MakePage("Webhook")
    local LogsPage = MakePage("ConsoleLogs")
    local PlayersPage = MakePage("Players")
    local ServerPage = MakePage("Server")
    local ServerInfoPage = MakePage("ServerInfo")
    local ChatPage = MakePage("Chat")
    local SkinPage = MakePage("Skin")
    local AdminPage = MakePage("AdminControl")
    local SettingsPage = MakePage("Settings")
    local CreatorPage = MakePage("Creator")

    local HomeNav = MakeNav("🏠  Dashboard", "Home")
    local UtilityNav = MakeNav("⚡  Utilities & Speed", "Utility")
    local FlyNoclipNav = MakeNav("✈️  Fly & Noclip", "FlyNoclip")
    local CombatNav = MakeNav("💥  Hitbox & Combat", "Combat")
    local AutoFarmNav = MakeNav("🤖  Auto Farm Clicker", "AutoFarm")
    local SpinFovNav = MakeNav("🌀  Spinbot & Camera FOV", "SpinFov")
    local TargetNav = MakeNav("🎯  Target Spectate", "Target")
    local AntiAfkNav = MakeNav("🛡️  Anti-AFK System", "AntiAfk")
    local EspNav = MakeNav("👁️  ESP Wallhack", "Esp")
    local VisualsNav = MakeNav("☀️  Visuals & Booster", "Visuals")
    local PresetsNav = MakeNav("🎨  Lighting Presets", "Presets")
    local PosNav = MakeNav("📍  Teleport Waypoints", "Positions")
    local VehicleNav = MakeNav("🚗  Vehicle Speed Boost", "Vehicle")
    local InventoryNav = MakeNav("🎒  Backpack Viewer", "Inventory")
    local CmdNav = MakeNav("🔤  Command Bar", "CommandBar")
    local ScriptHubNav = MakeNav("📁  Script Hub Library", "ScriptHub")
    local AudioNav = MakeNav("🎵  Audio Player", "Audio")
    local AnnounceNav = MakeNav("💬  Auto Chat Announcer", "Announce")
    local WebhookNav = MakeNav("🔔  Discord Webhook", "Webhook")
    local LogsNav = MakeNav("📜  Console Logs", "ConsoleLogs")
    local PlayersNav = MakeNav("👥  Players List", "Players")
    local ServerNav = MakeNav("🌐  Server Hop Hub", "Server")
    local ServerInfoNav = MakeNav("📊  Server Details", "ServerInfo")
    local ChatNav = MakeNav("💬  Global Chat", "Chat")
    local SkinNav = MakeNav("👕  Custom Skin", "Skin")
    local AdminNav = MakeNav("👑  Admin Panel", "AdminControl")
    local SettingsNav = MakeNav("⚙️  Settings", "Settings")
    local CreatorNav = MakeNav("👑  Creator Info", "Creator")

    local BottomProfile = Instance.new("Frame")
    BottomProfile.Parent = Sidebar
    BottomProfile.Size = UDim2.new(1, -20, 0, 55)
    BottomProfile.Position = UDim2.new(0, 10, 1, -60)
    BottomProfile.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
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
        Title.Size = UDim2.new(1, 0, 0, 26)
        Title.Position = UDim2.fromOffset(5, 5)
        Title.BackgroundTransparency = 1
        Title.Text = Main
        Title.TextColor3 = Color3.new(1, 1, 1)
        Title.TextSize = 18
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local Subtitle = Instance.new("TextLabel")
        Subtitle.Parent = Page
        Subtitle.Size = UDim2.new(1, 0, 0, 18)
        Subtitle.Position = UDim2.fromOffset(5, 31)
        Subtitle.BackgroundTransparency = 1
        Subtitle.Text = Sub
        Subtitle.TextColor3 = Color3.fromRGB(140, 140, 155)
        Subtitle.TextSize = 11
        Subtitle.Font = Enum.Font.Gotham
        Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    end

    -- TAB 1: DASHBOARD
    PageTitle(HomePage, "Dashboard Overview", "Thống kê hệ thống và thông tin cá nhân")
    local function StatCard(Page, X, Y, W, Label)
        local Card = Instance.new("Frame")
        Card.Parent = Page
        Card.Size = UDim2.fromOffset(W, 70)
        Card.Position = UDim2.fromOffset(X, Y)
        Card.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
        Corner(Card, 12)
        Stroke(Card, Color3.fromRGB(40, 40, 55), 1)

        local L = Instance.new("TextLabel")
        L.Parent = Card
        L.Size = UDim2.new(1, -20, 0, 18)
        L.Position = UDim2.fromOffset(10, 8)
        L.BackgroundTransparency = 1
        L.Text = Label
        L.TextColor3 = Color3.fromRGB(130, 130, 145)
        L.TextSize = 10
        L.Font = Enum.Font.GothamMedium
        L.TextXAlignment = Enum.TextXAlignment.Left

        local V = Instance.new("TextLabel")
        V.Parent = Card
        V.Size = UDim2.new(1, -20, 0, 30)
        V.Position = UDim2.fromOffset(10, 28)
        V.BackgroundTransparency = 1
        V.Text = "--"
        V.TextColor3 = Accent
        V.TextSize = 19
        V.Font = Enum.Font.GothamBold
        V.TextXAlignment = Enum.TextXAlignment.Left
        return V
    end

    local FPSValue = StatCard(HomePage, 5, 55, 150, "FRAME RATE (FPS)")
    local PingValue = StatCard(HomePage, 160, 55, 150, "NETWORK PING")
    local PlayerCount = StatCard(HomePage, 5, 133, 150, "SERVER PLAYERS")
    local UserIDValue = StatCard(HomePage, 160, 133, 150, "ROBLOX USER ID")
    UserIDValue.Text = tostring(UserId)

    -- TAB 2: UTILITIES & SPEED
    PageTitle(UtilityPage, "Player Utilities", "Tùy chỉnh tốc độ mượt mà chống giật lùi (Anti-Rubberband)")
    local currentSpeed = 16
    local isCFrameMethod = true

    local UtilCard = Instance.new("Frame")
    UtilCard.Parent = UtilityPage
    UtilCard.Size = UDim2.new(1, -5, 0, 120)
    UtilCard.Position = UDim2.fromOffset(0, 55)
    UtilCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(UtilCard, 10)

    local SpeedLbl = Instance.new("TextLabel")
    SpeedLbl.Parent = UtilCard
    SpeedLbl.Size = UDim2.new(1, -20, 0, 25)
    SpeedLbl.Position = UDim2.fromOffset(10, 10)
    SpeedLbl.BackgroundTransparency = 1
    SpeedLbl.Text = "⚡ TỐC ĐỘ DI CHUYỂN: " .. currentSpeed
    SpeedLbl.TextColor3 = Color3.new(1, 1, 1)
    SpeedLbl.Font = Enum.Font.GothamBold
    SpeedLbl.TextXAlignment = Enum.TextXAlignment.Left

    local SpeedInp = Instance.new("TextBox")
    SpeedInp.Parent = UtilCard
    SpeedInp.Size = UDim2.new(1, -20, 0, 32)
    SpeedInp.Position = UDim2.fromOffset(10, 40)
    SpeedInp.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    SpeedInp.Text = "16"
    SpeedInp.TextColor3 = Accent
    SpeedInp.Font = Enum.Font.GothamBold
    Corner(SpeedInp, 6)

    SpeedInp.FocusLost:Connect(function()
        local n = tonumber(SpeedInp.Text)
        if n then 
            currentSpeed = n 
            SpeedLbl.Text = "⚡ TỐC ĐỘ DI CHUYỂN: " .. currentSpeed
            SetStatus("Chỉnh WalkSpeed: " .. currentSpeed)
        end
    end)

    RunService.RenderStepped:Connect(function(delta)
        if isCFrameMethod and currentSpeed > 16 then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.MoveDirection.Magnitude > 0 then
                    hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (currentSpeed - 16) * delta)
                end
            end
        end
    end)

    -- TAB 3: FLY & NOCLIP
    PageTitle(FlyNoclipPage, "Fly & Noclip Mode", "Bay tự do trên không và di chuyển xuyên tường")
    local FlyCard = Instance.new("Frame")
    FlyCard.Parent = FlyNoclipPage
    FlyCard.Size = UDim2.new(1, -5, 0, 110)
    FlyCard.Position = UDim2.fromOffset(0, 55)
    FlyCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(FlyCard, 10)

    local noclipActive = false
    local NoclipBtn = Instance.new("TextButton")
    NoclipBtn.Parent = FlyCard
    NoclipBtn.Size = UDim2.new(0.95, 0, 0, 36)
    NoclipBtn.Position = UDim2.fromOffset(10, 15)
    NoclipBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    NoclipBtn.Text = "👻 NOCLIP (XUYÊN TƯỜNG): OFF"
    NoclipBtn.TextColor3 = Color3.new(1, 1, 1)
    NoclipBtn.Font = Enum.Font.GothamBold
    Corner(NoclipBtn, 8)

    NoclipBtn.MouseButton1Click:Connect(function()
        noclipActive = not noclipActive
        NoclipBtn.Text = noclipActive and "👻 NOCLIP (XUYÊN TƯỜNG): ON" or "👻 NOCLIP (XUYÊN TƯỜNG): OFF"
        NoclipBtn.BackgroundColor3 = noclipActive and Accent or Color3.fromRGB(35, 35, 45)
        SetStatus(noclipActive and "Đã bật Noclip xuyên tường" or "Đã tắt Noclip xuyên tường")
    end)

    RunService.Stepped:Connect(function()
        if noclipActive and LocalPlayer.Character then
            for _, v in ipairs(LocalPlayer.Character:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)

    -- TAB 4: HITBOX EXTENDER
    PageTitle(CombatPage, "Hitbox & Combat Utilities", "Mở rộng Hitbox kẻ địch & Tự động đánh")
    local CombatCard = Instance.new("Frame")
    CombatCard.Parent = CombatPage
    CombatCard.Size = UDim2.new(1, -5, 0, 110)
    CombatCard.Position = UDim2.fromOffset(0, 55)
    CombatCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(CombatCard, 10)

    local HitboxBtn = Instance.new("TextButton")
    HitboxBtn.Parent = CombatCard
    HitboxBtn.Size = UDim2.new(0.95, 0, 0, 36)
    HitboxBtn.Position = UDim2.fromOffset(10, 15)
    HitboxBtn.BackgroundColor3 = Accent
    HitboxBtn.Text = "🎯 HITBOX EXTENDER (PHÓNG TO THÂN KẺ ĐỊCH)"
    HitboxBtn.TextColor3 = Color3.new(1, 1, 1)
    HitboxBtn.Font = Enum.Font.GothamBold
    Corner(HitboxBtn, 8)

    HitboxBtn.MouseButton1Click:Connect(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
                p.Character.HumanoidRootPart.Transparency = 0.7
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
        SetStatus("Đã phóng to Hitbox toàn bộ người chơi")
    end)

    -- TAB 5: AUTO FARM CLICKER
    PageTitle(AutoFarmPage, "Auto Farm Clicker", "Tự động click chuột và tung chiêu liên tục")
    local FarmCard = Instance.new("Frame")
    FarmCard.Parent = AutoFarmPage
    FarmCard.Size = UDim2.new(1, -5, 0, 100)
    FarmCard.Position = UDim2.fromOffset(0, 55)
    FarmCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(FarmCard, 10)

    local isAutoClicking = false
    local AutoClickBtn = Instance.new("TextButton")
    AutoClickBtn.Parent = FarmCard
    AutoClickBtn.Size = UDim2.new(0.95, 0, 0, 36)
    AutoClickBtn.Position = UDim2.fromOffset(10, 15)
    AutoClickBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    AutoClickBtn.Text = "🤖 BẬT AUTO CLICK (FAST ATTACK): OFF"
    AutoClickBtn.TextColor3 = Color3.new(1, 1, 1)
    AutoClickBtn.Font = Enum.Font.GothamBold
    Corner(AutoClickBtn, 8)

    AutoClickBtn.MouseButton1Click:Connect(function()
        isAutoClicking = not isAutoClicking
        AutoClickBtn.Text = isAutoClicking and "🤖 BẬT AUTO CLICK (FAST ATTACK): ON" or "🤖 BẬT AUTO CLICK (FAST ATTACK): OFF"
        AutoClickBtn.BackgroundColor3 = isAutoClicking and Accent or Color3.fromRGB(35, 35, 45)
        SetStatus(isAutoClicking and "Đã BẬT Auto Click Farm" or "Đã TẮT Auto Click Farm")
    end)

    task.spawn(function()
        while Gui.Parent do
            if isAutoClicking then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(500, 500))
            end
            task.wait(0.1)
        end
    end)

    -- TAB 6: SPINBOT & CAMERA FOV
    PageTitle(SpinFovPage, "Spinbot & Camera FOV", "Xoay nhân vật cực nhanh & Mở rộng tầm nhìn FOV")
    local SpinCard = Instance.new("Frame")
    SpinCard.Parent = SpinFovPage
    SpinCard.Size = UDim2.new(1, -5, 0, 100)
    SpinCard.Position = UDim2.fromOffset(0, 55)
    SpinCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(SpinCard, 10)

    local FovBtn = Instance.new("TextButton")
    FovBtn.Parent = SpinCard
    FovBtn.Size = UDim2.new(0.95, 0, 0, 36)
    FovBtn.Position = UDim2.fromOffset(10, 15)
    FovBtn.BackgroundColor3 = Accent
    FovBtn.Text = "🔍 BẬT MAX FOV TẦM NHÌN (120)"
    FovBtn.TextColor3 = Color3.new(1, 1, 1)
    FovBtn.Font = Enum.Font.GothamBold
    Corner(FovBtn, 8)

    FovBtn.MouseButton1Click:Connect(function()
        workspace.CurrentCamera.FieldOfView = 120
        SetStatus("Đã mở rộng FOV Camera lên 120")
    end)

    -- TAB 8: ANTI-AFK SYSTEM
    PageTitle(AntiAfkPage, "Anti-AFK System", "Treo game 24/7 không lo bị ngắt kết nối")
    local AfkCard = Instance.new("Frame")
    AfkCard.Parent = AntiAfkPage
    AfkCard.Size = UDim2.new(1, -5, 0, 100)
    AfkCard.Position = UDim2.fromOffset(0, 55)
    AfkCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(AfkCard, 10)

    local AfkBtn = Instance.new("TextButton")
    AfkBtn.Parent = AfkCard
    AfkBtn.Size = UDim2.new(0.95, 0, 0, 36)
    AfkBtn.Position = UDim2.fromOffset(10, 15)
    AfkBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
    AfkBtn.Text = "🛡️ ANTI-AFK KICK PROTECTOR: ON"
    AfkBtn.TextColor3 = Color3.new(1, 1, 1)
    AfkBtn.Font = Enum.Font.GothamBold
    Corner(AfkBtn, 8)

    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)

    -- TAB 9: ESP WALLHACK
    PageTitle(EspPage, "ESP Wallhack", "Định vị vị trí người chơi xuyên tường")
    local EspCard = Instance.new("Frame")
    EspCard.Parent = EspPage
    EspCard.Size = UDim2.new(1, -5, 0, 100)
    EspCard.Position = UDim2.fromOffset(0, 55)
    EspCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(EspCard, 10)

    local EspEnabled = false
    local EspToggle = Instance.new("TextButton")
    EspToggle.Parent = EspCard
    EspToggle.Size = UDim2.new(0.95, 0, 0, 36)
    EspToggle.Position = UDim2.fromOffset(10, 15)
    EspToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    EspToggle.Text = "👁️ PLAYER HIGHLIGHT ESP: OFF"
    EspToggle.TextColor3 = Color3.fromRGB(180, 180, 190)
    EspToggle.Font = Enum.Font.GothamBold
    Corner(EspToggle, 8)

    EspToggle.MouseButton1Click:Connect(function()
        EspEnabled = not EspEnabled
        EspToggle.Text = EspEnabled and "👁️ PLAYER HIGHLIGHT ESP: ON" or "👁️ PLAYER HIGHLIGHT ESP: OFF"
        EspToggle.BackgroundColor3 = EspEnabled and Accent or Color3.fromRGB(35, 35, 45)
        SetStatus(EspEnabled and "Đã BẬT ESP Nhìn xuyên tường" or "Đã TẮT ESP Nhìn xuyên tường")
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("LuxuryESP")
                if EspEnabled then
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "LuxuryESP"
                        hl.FillColor = Accent
                        hl.Parent = p.Character
                    end
                else
                    if hl then hl:Destroy() end
                end
            end
        end
    end)

    -- TAB 10: VISUALS & FPS BOOSTER
    PageTitle(VisualsPage, "Visuals & Performance", "Xóa sương mù và tối ưu FPS")
    local VisCard = Instance.new("Frame")
    VisCard.Parent = VisualsPage
    VisCard.Size = UDim2.new(1, -5, 0, 100)
    VisCard.Position = UDim2.fromOffset(0, 55)
    VisCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(VisCard, 10)

    local FpsBoostBtn = Instance.new("TextButton")
    FpsBoostBtn.Parent = VisCard
    FpsBoostBtn.Size = UDim2.new(0.95, 0, 0, 36)
    FpsBoostBtn.Position = UDim2.fromOffset(10, 15)
    FpsBoostBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 90)
    FpsBoostBtn.Text = "🚀 CẤP TỐC TĂNG MƯỢT FPS (POTATO GRAPHICS)"
    FpsBoostBtn.TextColor3 = Color3.new(1, 1, 1)
    FpsBoostBtn.Font = Enum.Font.GothamBold
    Corner(FpsBoostBtn, 8)

    FpsBoostBtn.MouseButton1Click:Connect(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
            if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
        end
        SetStatus("Đã kích hoạt Booster tăng FPS")
    end)

    -- TAB 12: WAYPOINTS TELEPORT
    PageTitle(PosPage, "Teleport Waypoints", "Lưu tọa độ vị trí")
    local PosCard = Instance.new("Frame")
    PosCard.Parent = PosPage
    PosCard.Size = UDim2.new(1, -5, 0, 100)
    PosCard.Position = UDim2.fromOffset(0, 55)
    PosCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(PosCard, 10)

    local SavedCFrame = nil
    local SaveBtn = Instance.new("TextButton")
    SaveBtn.Parent = PosCard
    SaveBtn.Size = UDim2.new(0.46, 0, 0, 36)
    SaveBtn.Position = UDim2.fromOffset(10, 15)
    SaveBtn.BackgroundColor3 = Accent
    SaveBtn.Text = "📍 LƯU VỊ TRÍ"
    SaveBtn.TextColor3 = Color3.new(1, 1, 1)
    SaveBtn.Font = Enum.Font.GothamBold
    Corner(SaveBtn, 8)

    local LoadPosBtn = Instance.new("TextButton")
    LoadPosBtn.Parent = PosCard
    LoadPosBtn.Size = UDim2.new(0.46, 0, 0, 36)
    LoadPosBtn.Position = UDim2.new(0.5, 5, 0, 15)
    LoadPosBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    LoadPosBtn.Text = "🌀 DỊCH CHUYỂN"
    LoadPosBtn.TextColor3 = Color3.new(1, 1, 1)
    LoadPosBtn.Font = Enum.Font.GothamBold
    Corner(LoadPosBtn, 8)

    SaveBtn.MouseButton1Click:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            SavedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            SaveBtn.Text = "✓ ĐÃ LƯU TỌA ĐỘ!"
            SetStatus("Đã lưu tọa độ vị trí hiện tại!")
            task.wait(1)
            SaveBtn.Text = "📍 LƯU VỊ TRÍ"
        end
    end)

    LoadPosBtn.MouseButton1Click:Connect(function()
        if SavedCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = SavedCFrame
            SetStatus("Dịch chuyển về vị trí đã lưu!")
        end
    end)

    -- TAB 16: SCRIPT HUB
    PageTitle(ScriptHubPage, "Script Hub Library", "Khởi chạy các Script hỗ trợ game phổ biến")
    local HubCard = Instance.new("Frame")
    HubCard.Parent = ScriptHubPage
    HubCard.Size = UDim2.new(1, -5, 0, 100)
    HubCard.Position = UDim2.fromOffset(0, 55)
    HubCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(HubCard, 10)

    local IyBtn = Instance.new("TextButton")
    IyBtn.Parent = HubCard
    IyBtn.Size = UDim2.new(0.95, 0, 0, 36)
    IyBtn.Position = UDim2.fromOffset(10, 15)
    IyBtn.BackgroundColor3 = Accent
    IyBtn.Text = "⚡ KHỞI CHẠY INFINITE YIELD ADMIN"
    IyBtn.TextColor3 = Color3.new(1, 1, 1)
    IyBtn.Font = Enum.Font.GothamBold
    Corner(IyBtn, 8)

    IyBtn.MouseButton1Click:Connect(function()
        SetStatus("Đang tải Infinite Yield Admin...")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end)

    -- ĐIỀU HƯỚNG TAB
    local function ShowPage(Name)
        for PageName, Page in pairs(Pages) do Page.Visible = (PageName == Name) end
        for PageName, Button in pairs(NavButtons) do
            if PageName == Name then
                Button.BackgroundColor3 = Accent
                Button.TextColor3 = Color3.new(1, 1, 1)
            else
                Button.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
                Button.TextColor3 = Color3.fromRGB(150, 150, 165)
            end
        end
        SetStatus("Đang ở Tab " .. Name)
    end
    HomeNav.MouseButton1Click:Connect(function() ShowPage("Home") end)
    UtilityNav.MouseButton1Click:Connect(function() ShowPage("Utility") end)
    FlyNoclipNav.MouseButton1Click:Connect(function() ShowPage("FlyNoclip") end)
    CombatNav.MouseButton1Click:Connect(function() ShowPage("Combat") end)
    AutoFarmNav.MouseButton1Click:Connect(function() ShowPage("AutoFarm") end)
    SpinFovNav.MouseButton1Click:Connect(function() ShowPage("SpinFov") end)
    TargetNav.MouseButton1Click:Connect(function() ShowPage("Target") end)
    AntiAfkNav.MouseButton1Click:Connect(function() ShowPage("AntiAfk") end)
    EspNav.MouseButton1Click:Connect(function() ShowPage("Esp") end)
    VisualsNav.MouseButton1Click:Connect(function() ShowPage("Visuals") end)
    PresetsNav.MouseButton1Click:Connect(function() ShowPage("Presets") end)
    PosNav.MouseButton1Click:Connect(function() ShowPage("Positions") end)
    VehicleNav.MouseButton1Click:Connect(function() ShowPage("Vehicle") end)
    InventoryNav.MouseButton1Click:Connect(function() ShowPage("Inventory") end)
    CmdNav.MouseButton1Click:Connect(function() ShowPage("CommandBar") end)
    ScriptHubNav.MouseButton1Click:Connect(function() ShowPage("ScriptHub") end)
    AudioNav.MouseButton1Click:Connect(function() ShowPage("Audio") end)
    AnnounceNav.MouseButton1Click:Connect(function() ShowPage("Announce") end)
    WebhookNav.MouseButton1Click:Connect(function() ShowPage("Webhook") end)
    LogsNav.MouseButton1Click:Connect(function() ShowPage("ConsoleLogs") end)
    PlayersNav.MouseButton1Click:Connect(function() ShowPage("Players") end)
    ServerNav.MouseButton1Click:Connect(function() ShowPage("Server") end)
    ServerInfoNav.MouseButton1Click:Connect(function() ShowPage("ServerInfo") end)
    ChatNav.MouseButton1Click:Connect(function() ShowPage("Chat") end)
    SkinNav.MouseButton1Click:Connect(function() ShowPage("Skin") end)
    AdminNav.MouseButton1Click:Connect(function() ShowPage("AdminControl") end)
    SettingsNav.MouseButton1Click:Connect(function() ShowPage("Settings") end)
    CreatorNav.MouseButton1Click:Connect(function() ShowPage("Creator") end)

    ShowPage("Home")

    Icon.MouseButton1Click:Connect(function()
        if IconEnabled then Menu.Visible = not Menu.Visible end
    end)

    local Frames = 0
    local LastFPS = os.clock()
    RunService.RenderStepped:Connect(function()
        Frames += 1
        local Now = os.clock()
        if Now - LastFPS >= 1 then
            currentFPS = Frames
            FPSValue.Text = tostring(Frames)
            Frames = 0
            LastFPS = Now
        end
    end)
end

-- BẢO TRÌ SYSTEM
if MAINTENANCE_CONFIG.Enabled and not isAdmin then
    SetStatus("Hệ thống đang bảo trì...")
    local MaintFrame = Instance.new("Frame")
    MaintFrame.Parent = Gui
    MaintFrame.Size = UDim2.fromOffset(400, 200)
    MaintFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    MaintFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    Corner(MaintFrame, 16)
    Stroke(MaintFrame, Color3.fromRGB(255, 80, 80), 2)

    local MaintTitle = Instance.new("TextLabel")
    MaintTitle.Parent = MaintFrame
    MaintTitle.Size = UDim2.new(1, -20, 0, 35)
    MaintTitle.Position = UDim2.fromOffset(10, 15)
    MaintTitle.BackgroundTransparency = 1
    MaintTitle.Text = "🛠️ HỆ THỐNG ĐANG BẢO TRÌ"
    MaintTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
    MaintTitle.TextSize = 15
    MaintTitle.Font = Enum.Font.GothamBold

    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Parent = MaintFrame
    TimerLabel.Size = UDim2.new(1, 0, 0, 30)
    TimerLabel.Position = UDim2.fromOffset(0, 135)
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Text = "⏳ Tự động mở lại sau: " .. MAINTENANCE_CONFIG.Duration .. " giây"
    TimerLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    TimerLabel.Font = Enum.Font.GothamBold

    task.spawn(function()
        local timeLeft = MAINTENANCE_CONFIG.Duration
        while timeLeft > 0 do
            task.wait(1)
            timeLeft -= 1
            TimerLabel.Text = "⏳ Tự động mở lại sau: " .. timeLeft .. " giây"
        end
        MaintFrame:Destroy()
        StartMainDashboard()
    end)
else
    StartMainDashboard()
end

print("Luxury Dashboard Master Edition Loaded!")
