-- ==============================================================================
-- Project: Luxury Dashboard UI (FULL MASTER EDITION + MAINTENANCE MODE)
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
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================================
-- CẤU HÌNH CHẾ ĐỘ BẢO TRÌ (MAINTENANCE CONFIG)
-- ==========================================================
local MAINTENANCE_CONFIG = {
    Enabled = true,                        -- Đặt là true để bật bảo trì, false để chạy bình thường
    Duration = 60,                         -- Thời gian bảo trì (tính bằng giây, ví dụ 60 giây)
    Reason = "Hệ thống Luxury Hub đang tiến hành bảo trì nâng cấp phiên bản mới để tối ưu hóa tiêu chí người dùng."
}

-- BẢO MẬT ADMIN
local ADMIN_USERNAME = "kit_n67"
local isAdmin = (LocalPlayer.Name:lower() == ADMIN_USERNAME:lower())

local CREATOR_LINKS = {
    TikTok = "https://www.tiktok.com/@kit_n67",
    YouTube = "https://www.youtube.com/@kit_n67",
    Discord = "https://discord.gg/luxuryhub"
}

local CONFIG = {
    Theme = "Purple",
    MenuWidth = 760,
    MenuHeight = 480,
    MinWidth = 580,
    MaxWidth = 950,
    MinHeight = 400,
    MaxHeight = 700,
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

-- ==========================================================
-- GIAO DIỆN BẢO TRÌ (HIỆN NẾU MAINTENANCE_CONFIG.Enabled = true)
-- ==========================================================
local function StartMainDashboard()
    -- ICON MENU CHÍNH
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

    -- MENU CHÍNH
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

    -- HEADER KÉO THẢ MENU
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

    MakeTopBtn(0, "—", function() Menu.Visible = false end)

    MakeTopBtn(32, "🗖", function()
        IsMaximized = not IsMaximized
        if IsMaximized then
            NormalSize = Menu.Size
            NormalPos = Menu.Position
            Menu.Size = UDim2.new(0, 880, 0, 600)
            Menu.Position = UDim2.new(0.5, -440, 0.5, -300)
        else
            Menu.Size = NormalSize
            Menu.Position = NormalPos
        end
    end)

    local IconEnabled = true
    MakeTopBtn(64, "×", function()
        Menu.Visible = false
        IconEnabled = false
        Icon.Visible = false
    end)

    -- SIDEBAR
    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = Menu
    Sidebar.Size = UDim2.new(0, 185, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    Sidebar.BorderSizePixel = 0
    Corner(Sidebar, 16)

    local Logo = Instance.new("TextLabel")
    Logo.Parent = Sidebar
    Logo.Size = UDim2.new(1, -20, 0, 45)
    Logo.Position = UDim2.fromOffset(15, 10)
    Logo.BackgroundTransparency = 1
    Logo.Text = "LUXURY HUB"
    Logo.TextColor3 = Accent
    Logo.TextSize = 16
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
    NavLayout.Padding = UDim.new(0, 5)

    local Pages = {}
    local NavButtons = {}

    local function MakePage(Name)
        local Page = Instance.new("Frame")
        Page.Name = Name
        Page.Parent = Menu
        Page.Size = UDim2.new(1, -205, 1, -20)
        Page.Position = UDim2.fromOffset(195, 10)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Pages[Name] = Page
        return Page
    end

    local function MakeNav(Text, PageName)
        local Button = Instance.new("TextButton")
        Button.Parent = NavScroll
        Button.Size = UDim2.new(1, -20, 0, 32)
        Button.Position = UDim2.fromOffset(10, 0)
        Button.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
        Button.BackgroundTransparency = 1
        Button.BorderSizePixel = 0
        Button.Text = Text
        Button.TextColor3 = Color3.fromRGB(150, 150, 165)
        Button.TextSize = 11
        Button.Font = Enum.Font.GothamMedium
        Button.TextXAlignment = Enum.TextXAlignment.Left
        
        local TextPadding = Instance.new("UIPadding")
        TextPadding.PaddingLeft = UDim.new(0, 14)
        TextPadding.Parent = Button

        Corner(Button, 8)
        NavButtons[PageName] = Button
        return Button
    end

    -- KHỞI TẠO TẤT CẢ CÁC TAB
    local HomePage = MakePage("Home")
    local UtilityPage = MakePage("Utility")
    local PlayersPage = MakePage("Players")
    local ServerPage = MakePage("Server")
    local ServerInfoPage = MakePage("ServerInfo")
    local ChatPage = MakePage("Chat")
    local SkinPage = MakePage("Skin")
    local SettingsPage = MakePage("Settings")
    local CreatorPage = MakePage("Creator")

    local HomeNav = MakeNav("🏠   Dashboard", "Home")
    local UtilityNav = MakeNav("⚡   Utilities & Speed", "Utility")
    local PlayersNav = MakeNav("👥   Players", "Players")
    local ServerNav = MakeNav("🌐   Server Hop", "Server")
    local ServerInfoNav = MakeNav("📊   Server Details", "ServerInfo")
    local ChatNav = MakeNav("💬   Global Chat", "Chat")
    local SkinNav = MakeNav("👕   Custom Skin", "Skin")
    local SettingsNav = MakeNav("⚙️   Settings", "Settings")
    local CreatorNav = MakeNav("👑   Creator Info", "Creator")

    -- PROFILE DƯỚI GÓC SIDEBAR
    local BottomProfile = Instance.new("Frame")
    BottomProfile.Parent = Sidebar
    BottomProfile.Size = UDim2.new(1, -20, 0, 55)
    BottomProfile.Position = UDim2.new(0, 10, 1, -60)
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
        Title.Size = UDim2.new(1, 0, 0, 28)
        Title.Position = UDim2.fromOffset(5, 5)
        Title.BackgroundTransparency = 1
        Title.Text = Main
        Title.TextColor3 = Color3.new(1, 1, 1)
        Title.TextSize = 19
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local Subtitle = Instance.new("TextLabel")
        Subtitle.Parent = Page
        Subtitle.Size = UDim2.new(1, 0, 0, 18)
        Subtitle.Position = UDim2.fromOffset(5, 33)
        Subtitle.BackgroundTransparency = 1
        Subtitle.Text = Sub
        Subtitle.TextColor3 = Color3.fromRGB(140, 140, 155)
        Subtitle.TextSize = 11
        Subtitle.Font = Enum.Font.Gotham
        Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    end

    -- TAB 1: HOME
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

    local FPSValue = StatCard(HomePage, 5, 60, 150, "FRAME RATE (FPS)")
    local PingValue = StatCard(HomePage, 160, 60, 150, "NETWORK PING")
    local PlayerCount = StatCard(HomePage, 5, 138, 150, "SERVER PLAYERS")
    local UserIDValue = StatCard(HomePage, 160, 138, 150, "ROBLOX USER ID")
    UserIDValue.Text = tostring(UserId)

    local JobCard = Instance.new("Frame")
    JobCard.Parent = HomePage
    JobCard.Size = UDim2.fromOffset(305, 70)
    JobCard.Position = UDim2.fromOffset(5, 216)
    JobCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(JobCard, 12)
    Stroke(JobCard, Color3.fromRGB(40, 40, 55), 1)

    local JobCardLabel = Instance.new("TextLabel")
    JobCardLabel.Parent = JobCard
    JobCardLabel.Size = UDim2.new(1, -20, 0, 18)
    JobCardLabel.Position = UDim2.fromOffset(10, 8)
    JobCardLabel.BackgroundTransparency = 1
    JobCardLabel.Text = "CURRENT SERVER JOB ID"
    JobCardLabel.TextColor3 = Color3.fromRGB(130, 130, 145)
    JobCardLabel.TextSize = 10
    JobCardLabel.Font = Enum.Font.GothamMedium
    JobCardLabel.TextXAlignment = Enum.TextXAlignment.Left

    local JobCardValue = Instance.new("TextLabel")
    JobCardValue.Parent = JobCard
    JobCardValue.Size = UDim2.new(1, -95, 0, 30)
    JobCardValue.Position = UDim2.fromOffset(10, 28)
    JobCardValue.BackgroundTransparency = 1
    JobCardValue.Text = game.JobId
    JobCardValue.TextColor3 = Accent
    JobCardValue.TextSize = 10
    JobCardValue.Font = Enum.Font.GothamBold
    JobCardValue.TextXAlignment = Enum.TextXAlignment.Left
    JobCardValue.TextTruncate = Enum.TextTruncate.AtEnd

    local CopyCurrentJobBtn = Instance.new("TextButton")
    CopyCurrentJobBtn.Parent = JobCard
    CopyCurrentJobBtn.Size = UDim2.fromOffset(75, 30)
    CopyCurrentJobBtn.Position = UDim2.new(1, -85, 0.5, -15)
    CopyCurrentJobBtn.BackgroundColor3 = Accent
    CopyCurrentJobBtn.Text = "📋 COPY"
    CopyCurrentJobBtn.TextColor3 = Color3.new(1, 1, 1)
    CopyCurrentJobBtn.TextSize = 10
    CopyCurrentJobBtn.Font = Enum.Font.GothamBold
    Corner(CopyCurrentJobBtn, 6)

    CopyCurrentJobBtn.MouseButton1Click:Connect(function()
        ClickSound:Play()
        if setclipboard then setclipboard(game.JobId) end
        CopyCurrentJobBtn.Text = "✓ COPIED"
        CopyCurrentJobBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
        task.wait(1.5)
        CopyCurrentJobBtn.Text = "📋 COPY"
        CopyCurrentJobBtn.BackgroundColor3 = Accent
    end)

    local QuickRejoinBtn = Instance.new("TextButton")
    QuickRejoinBtn.Parent = HomePage
    QuickRejoinBtn.Size = UDim2.fromOffset(305, 38)
    QuickRejoinBtn.Position = UDim2.fromOffset(5, 296)
    QuickRejoinBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    QuickRejoinBtn.Text = "🔄  REJOIN CURRENT SERVER"
    QuickRejoinBtn.TextColor3 = Color3.new(1, 1, 1)
    QuickRejoinBtn.TextSize = 11
    QuickRejoinBtn.Font = Enum.Font.GothamBold
    Corner(QuickRejoinBtn, 10)
    Stroke(QuickRejoinBtn, Accent, 1)

    QuickRejoinBtn.MouseButton1Click:Connect(function()
        ClickSound:Play()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)

    -- TAB 2: UTILITIES & SPEED
    PageTitle(UtilityPage, "Player Utilities", "Tùy chỉnh tốc độ mượt mà chống giật lùi (Anti-Rubberband)")

    local UtilScroll = Instance.new("ScrollingFrame")
    UtilScroll.Parent = UtilityPage
    UtilScroll.Size = UDim2.new(1, -5, 1, -55)
    UtilScroll.Position = UDim2.fromOffset(0, 55)
    UtilScroll.BackgroundTransparency = 1
    UtilScroll.BorderSizePixel = 0
    UtilScroll.ScrollBarThickness = 3
    UtilScroll.ScrollBarImageColor3 = Accent

    local UtilLayout = Instance.new("UIListLayout")
    UtilLayout.Parent = UtilScroll
    UtilLayout.Padding = UDim.new(0, 12)

    local SpeedCard = Instance.new("Frame")
    SpeedCard.Parent = UtilScroll
    SpeedCard.Size = UDim2.new(1, -5, 0, 120)
    SpeedCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(SpeedCard, 10)
    Stroke(SpeedCard, Color3.fromRGB(40, 40, 55), 1)

    local SpeedTitle = Instance.new("TextLabel")
    SpeedTitle.Parent = SpeedCard
    SpeedTitle.Size = UDim2.new(1, -20, 0, 22)
    SpeedTitle.Position = UDim2.fromOffset(12, 6)
    SpeedTitle.BackgroundTransparency = 1
    SpeedTitle.Text = "⚡ TỐC ĐỘ CHẠY (SPEED: 16)"
    SpeedTitle.TextColor3 = Color3.new(1, 1, 1)
    SpeedTitle.TextSize = 11
    SpeedTitle.Font = Enum.Font.GothamBold
    SpeedTitle.TextXAlignment = Enum.TextXAlignment.Left

    local SpeedValBox = Instance.new("TextBox")
    SpeedValBox.Parent = SpeedCard
    SpeedValBox.Size = UDim2.fromOffset(55, 24)
    SpeedValBox.Position = UDim2.new(1, -65, 0, 6)
    SpeedValBox.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    SpeedValBox.Text = "16"
    SpeedValBox.TextColor3 = Accent
    SpeedValBox.TextSize = 11
    SpeedValBox.Font = Enum.Font.GothamBold
    Corner(SpeedValBox, 6)

    local SliderBack = Instance.new("Frame")
    SliderBack.Parent = SpeedCard
    SliderBack.Size = UDim2.new(1, -24, 0, 8)
    SliderBack.Position = UDim2.fromOffset(12, 36)
    SliderBack.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    Corner(SliderBack, 4)

    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBack
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = Accent
    Corner(SliderFill, 4)

    local SliderKnob = Instance.new("TextButton")
    SliderKnob.Parent = SliderBack
    SliderKnob.Size = UDim2.fromOffset(16, 16)
    SliderKnob.Position = UDim2.new(0, -8, 0.5, -8)
    SliderKnob.BackgroundColor3 = Color3.new(1, 1, 1)
    SliderKnob.Text = ""
    Corner(SliderKnob, 8)

    local MethodBtn = Instance.new("TextButton")
    MethodBtn.Parent = SpeedCard
    MethodBtn.Size = UDim2.new(1, -24, 0, 28)
    MethodBtn.Position = UDim2.fromOffset(12, 52)
    MethodBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    MethodBtn.Text = "🚀 CHẾ ĐỘ: CFRAME BYPASS (KHÔNG BỊ KÉO LÙI)"
    MethodBtn.TextColor3 = Color3.fromRGB(40, 200, 100)
    MethodBtn.TextSize = 10
    MethodBtn.Font = Enum.Font.GothamBold
    Corner(MethodBtn, 6)

    local NoteLbl = Instance.new("TextLabel")
    NoteLbl.Parent = SpeedCard
    NoteLbl.Size = UDim2.new(1, -24, 0, 24)
    NoteLbl.Position = UDim2.fromOffset(12, 86)
    NoteLbl.BackgroundTransparency = 1
    NoteLbl.Text = "*Khuyên dùng CFrame Bypass để không bao giờ bị giật lùi vị trí cũ!"
    NoteLbl.TextColor3 = Color3.fromRGB(130, 130, 145)
    NoteLbl.TextSize = 9
    NoteLbl.Font = Enum.Font.Gotham
    NoteLbl.TextXAlignment = Enum.TextXAlignment.Left

    local currentSpeed = 16
    local isCFrameMethod = true

    local function ApplySpeed(val)
        currentSpeed = math.clamp(val, 16, 100)
        SpeedTitle.Text = "⚡ TỐC ĐỘ CHẠY (SPEED: " .. currentSpeed .. ")"
        SpeedValBox.Text = tostring(currentSpeed)

        local rel = (currentSpeed - 16) / (100 - 16)
        SliderFill.Size = UDim2.new(rel, 0, 1, 0)
        SliderKnob.Position = UDim2.new(rel, -8, 0.5, -8)

        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            if not isCFrameMethod then
                char:FindFirstChildOfClass("Humanoid").WalkSpeed = currentSpeed
            else
                char:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
            end
        end
    end

    MethodBtn.MouseButton1Click:Connect(function()
        ClickSound:Play()
        isCFrameMethod = not isCFrameMethod
        if isCFrameMethod then
            MethodBtn.Text = "🚀 CHẾ ĐỘ: CFRAME BYPASS (KHÔNG BỊ KÉO LÙI)"
            MethodBtn.TextColor3 = Color3.fromRGB(40, 200, 100)
        else
            MethodBtn.Text = "🏃 CHẾ ĐỘ: WALKSPEED MẶC ĐỊNH (CÓ THỂ BỊ CHECK)"
            MethodBtn.TextColor3 = Color3.fromRGB(255, 130, 40)
        end
        ApplySpeed(currentSpeed)
    end)

    local draggingSlider = false
    SliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local absPos = SliderBack.AbsolutePosition.X
            local absSize = SliderBack.AbsoluteSize.X
            local rel = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
            ApplySpeed(math.floor(16 + rel * 84))
        end
    end)

    SpeedValBox.FocusLost:Connect(function()
        local n = tonumber(SpeedValBox.Text)
        if n then ApplySpeed(n) end
    end)

    RunService.RenderStepped:Connect(function(delta)
        if isCFrameMethod and currentSpeed > 16 then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.MoveDirection.Magnitude > 0 then
                    local multiplier = (currentSpeed - 16) * delta
                    hrp.CFrame = hrp.CFrame + (hum.MoveDirection * multiplier)
                end
            end
        end
    end)

    local InfJumpEnabled = false
    local InfRow = Instance.new("Frame")
    InfRow.Parent = UtilScroll
    InfRow.Size = UDim2.new(1, -5, 0, 42)
    InfRow.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(InfRow, 10)

    local InfLbl = Instance.new("TextLabel")
    InfLbl.Parent = InfRow
    InfLbl.Size = UDim2.new(1, -80, 1, 0)
    InfLbl.Position = UDim2.fromOffset(12, 0)
    InfLbl.BackgroundTransparency = 1
    InfLbl.Text = "🦘 NHẢY VÔ TẬN (INFINITE JUMP)"
    InfLbl.TextColor3 = Color3.new(1, 1, 1)
    InfLbl.TextSize = 11
    InfLbl.Font = Enum.Font.GothamBold
    InfLbl.TextXAlignment = Enum.TextXAlignment.Left

    local InfBtn = Instance.new("TextButton")
    InfBtn.Parent = InfRow
    InfBtn.Size = UDim2.fromOffset(60, 26)
    InfBtn.Position = UDim2.new(1, -70, 0.5, -13)
    InfBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    InfBtn.Text = "OFF"
    InfBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
    InfBtn.TextSize = 10
    InfBtn.Font = Enum.Font.GothamBold
    Corner(InfBtn, 6)

    InfBtn.MouseButton1Click:Connect(function()
        ClickSound:Play()
        InfJumpEnabled = not InfJumpEnabled
        if InfJumpEnabled then
            InfBtn.Text = "ON"
            InfBtn.BackgroundColor3 = Accent
            InfBtn.TextColor3 = Color3.new(1, 1, 1)
        else
            InfBtn.Text = "OFF"
            InfBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            InfBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
        end
    end)

    UserInputService.JumpRequest:Connect(function()
        if InfJumpEnabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    -- TAB 3: PLAYERS
    PageTitle(PlayersPage, "Active Players", "Danh sách người chơi đang ở cùng server")
    local PlayerList = Instance.new("ScrollingFrame")
    PlayerList.Parent = PlayersPage
    PlayerList.Size = UDim2.new(1, -5, 1, -65)
    PlayerList.Position = UDim2.fromOffset(0, 55)
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

    local function RefreshPlayers()
        for _, Child in ipairs(PlayerList:GetChildren()) do if Child:IsA("Frame") then Child:Destroy() end end
        for _, Target in ipairs(Players:GetPlayers()) do
            if Target ~= LocalPlayer then
                local Row = Instance.new("Frame")
                Row.Parent = PlayerList
                Row.Size = UDim2.new(1, -5, 0, 55)
                Row.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
                Corner(Row, 12)

                local Name = Instance.new("TextLabel")
                Name.Parent = Row
                Name.Size = UDim2.new(1, -110, 0, 20)
                Name.Position = UDim2.fromOffset(12, 8)
                Name.BackgroundTransparency = 1
                Name.Text = Target.DisplayName
                Name.TextColor3 = Color3.new(1, 1, 1)
                Name.TextSize = 12
                Name.Font = Enum.Font.GothamBold
                Name.TextXAlignment = Enum.TextXAlignment.Left

                local User = Instance.new("TextLabel")
                User.Parent = Row
                User.Size = UDim2.new(1, -110, 0, 16)
                User.Position = UDim2.fromOffset(12, 28)
                User.BackgroundTransparency = 1
                User.Text = "@" .. Target.Name
                User.TextColor3 = Color3.fromRGB(130, 130, 145)
                User.TextSize = 10
                User.Font = Enum.Font.Gotham
                User.TextXAlignment = Enum.TextXAlignment.Left

                local Teleport = Instance.new("TextButton")
                Teleport.Parent = Row
                Teleport.Size = UDim2.fromOffset(75, 30)
                Teleport.Position = UDim2.new(1, -85, 0.5, -15)
                Teleport.BackgroundColor3 = Accent
                Teleport.Text = "TELEPORT"
                Teleport.TextColor3 = Color3.new(1, 1, 1)
                Teleport.TextSize = 10
                Teleport.Font = Enum.Font.GothamBold
                Corner(Teleport, 8)

                Teleport.MouseButton1Click:Connect(function()
                    local MyChar, TChar = LocalPlayer.Character, Target.Character
                    if MyChar and TChar and TChar:FindFirstChild("HumanoidRootPart") then
                        MyChar:PivotTo(TChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, CONFIG.TeleportOffset))
                    end
                end)
            end
        end
    end
    RefreshPlayers()
    Players.PlayerAdded:Connect(function() task.wait(0.2) RefreshPlayers() end)
    Players.PlayerRemoving:Connect(function() task.wait(0.1) RefreshPlayers() end)

    -- TAB 4: SERVER HOP HUB
    PageTitle(ServerPage, "Server Hop Hub", "Quét tìm server ít người, treo cũ hoặc ping thấp")

    local FindLowPingServer = Instance.new("TextButton")
    FindLowPingServer.Parent = ServerPage
    FindLowPingServer.Size = UDim2.new(0.31, 0, 0, 34)
    FindLowPingServer.Position = UDim2.fromOffset(0, 52)
    FindLowPingServer.BackgroundColor3 = Color3.fromRGB(40, 180, 90)
    FindLowPingServer.Text = "⚡ PING THẤP"
    FindLowPingServer.TextColor3 = Color3.new(1, 1, 1)
    FindLowPingServer.TextSize = 10
    FindLowPingServer.Font = Enum.Font.GothamBold
    Corner(FindLowPingServer, 8)

    local Find1Player = Instance.new("TextButton")
    Find1Player.Parent = ServerPage
    Find1Player.Size = UDim2.new(0.32, 0, 0, 34)
    Find1Player.Position = UDim2.new(0.34, 0, 0, 52)
    Find1Player.BackgroundColor3 = Accent
    Find1Player.Text = "🔍 1 NGƯỜI"
    Find1Player.TextColor3 = Color3.new(1, 1, 1)
    Find1Player.TextSize = 10
    Find1Player.Font = Enum.Font.GothamBold
    Corner(Find1Player, 8)

    local FindOldServer = Instance.new("TextButton")
    FindOldServer.Parent = ServerPage
    FindOldServer.Size = UDim2.new(0.31, 0, 0, 34)
    FindOldServer.Position = UDim2.new(0.68, 0, 0, 52)
    FindOldServer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    FindOldServer.Text = "⏳ TREO CŨ"
    FindOldServer.TextColor3 = Color3.fromRGB(200, 200, 210)
    FindOldServer.TextSize = 10
    FindOldServer.Font = Enum.Font.GothamBold
    Corner(FindOldServer, 8)
    Stroke(FindOldServer, Accent, 1)

    local JobInputContainer = Instance.new("Frame")
    JobInputContainer.Parent = ServerPage
    JobInputContainer.Size = UDim2.new(1, -5, 0, 36)
    JobInputContainer.Position = UDim2.fromOffset(0, 92)
    JobInputContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(JobInputContainer, 8)
    Stroke(JobInputContainer, Color3.fromRGB(45, 45, 60), 1)

    local JobInput = Instance.new("TextBox")
    JobInput.Parent = JobInputContainer
    JobInput.Size = UDim2.new(1, -125, 1, 0)
    JobInput.Position = UDim2.fromOffset(10, 0)
    JobInput.BackgroundTransparency = 1
    JobInput.PlaceholderText = "Dán mã Job ID server vào đây..."
    JobInput.Text = ""
    JobInput.TextColor3 = Color3.new(1, 1, 1)
    JobInput.TextSize = 10
    JobInput.Font = Enum.Font.Gotham

    local JoinJobBtn = Instance.new("TextButton")
    JoinJobBtn.Parent = JobInputContainer
    JoinJobBtn.Size = UDim2.fromOffset(110, 26)
    JoinJobBtn.Position = UDim2.new(1, -115, 0.5, -13)
    JoinJobBtn.BackgroundColor3 = Accent
    JoinJobBtn.Text = "🚀 JOIN JOB ID"
    JoinJobBtn.TextColor3 = Color3.new(1, 1, 1)
    JoinJobBtn.TextSize = 9
    JoinJobBtn.Font = Enum.Font.GothamBold
    Corner(JoinJobBtn, 6)

    JoinJobBtn.MouseButton1Click:Connect(function()
        local targetJobId = JobInput.Text:gsub("%s+", "")
        if targetJobId ~= "" then
            ClickSound:Play()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetJobId, LocalPlayer)
        end
    end)

    local ServerStatus = Instance.new("TextLabel")
    ServerStatus.Parent = ServerPage
    ServerStatus.Size = UDim2.new(1, -5, 0, 18)
    ServerStatus.Position = UDim2.fromOffset(0, 132)
    ServerStatus.BackgroundTransparency = 1
    ServerStatus.Text = "Trạng thái: Sẵn sàng quét server"
    ServerStatus.TextColor3 = Color3.fromRGB(140, 140, 155)
    ServerStatus.TextSize = 10
    ServerStatus.Font = Enum.Font.Gotham

    local ServerList = Instance.new("ScrollingFrame")
    ServerList.Parent = ServerPage
    ServerList.Size = UDim2.new(1, -5, 1, -155)
    ServerList.Position = UDim2.fromOffset(0, 152)
    ServerList.BackgroundTransparency = 1
    ServerList.BorderSizePixel = 0
    ServerList.ScrollBarThickness = 3
    ServerList.ScrollBarImageColor3 = Accent

    local ServerLayout = Instance.new("UIListLayout")
    ServerLayout.Parent = ServerList
    ServerLayout.Padding = UDim.new(0, 6)

    local function FetchServerPage(Cursor)
        local URL = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        if Cursor then URL = URL .. "&cursor=" .. HttpService:UrlEncode(Cursor) end
        local Success, Response = pcall(function() return game:HttpGet(URL) end)
        if not Success or not Response then return nil end
        local DecodeSuccess, Data = pcall(function() return HttpService:JSONDecode(Response) end)
        return DecodeSuccess and Data or nil
    end

    local function GetServers(mode)
        local Servers = {}
        local Cursor = nil
        local PagesScanned = 0
        while PagesScanned < 10 do
            PagesScanned += 1
            local Data = FetchServerPage(Cursor)
            if not Data or not Data.data then break end
            for _, Server in ipairs(Data.data) do
                local Playing = tonumber(Server.playing) or 999
                if Server.id ~= game.JobId and Playing > 0 then
                    if mode == "strict1" and Playing == 1 then table.insert(Servers, Server)
                    elseif mode == "old" and Playing <= 2 then table.insert(Servers, Server)
                    elseif mode == "lowping" then table.insert(Servers, Server) end
                end
            end
            Cursor = Data.nextPageCursor
            if not Cursor then break end
            task.wait(0.02)
        end
        return Servers
    end

    local function AddServerRow(Server, Index, modeTag)
        local Row = Instance.new("Frame")
        Row.Parent = ServerList
        Row.Size = UDim2.new(1, -5, 0, 50)
        Row.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
        Corner(Row, 10)
        local Info = Instance.new("TextLabel")
        Info.Parent = Row
        Info.Size = UDim2.new(1, -150, 1, 0)
        Info.Position = UDim2.fromOffset(10, 0)
        Info.BackgroundTransparency = 1
        Info.Text = "[" .. modeTag .. "] SERVER #" .. Index .. " (" .. Server.playing .. " NGƯỜI)"
        Info.TextColor3 = Color3.new(1, 1, 1)
        Info.TextSize = 10
        Info.Font = Enum.Font.GothamMedium
        Info.TextXAlignment = Enum.TextXAlignment.Left

        local CopyJobBtn = Instance.new("TextButton")
        CopyJobBtn.Parent = Row
        CopyJobBtn.Size = UDim2.fromOffset(75, 28)
        CopyJobBtn.Position = UDim2.new(1, -130, 0.5, -14)
        CopyJobBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        CopyJobBtn.Text = "📋 JOB ID"
        CopyJobBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
        CopyJobBtn.TextSize = 9
        CopyJobBtn.Font = Enum.Font.GothamBold
        Corner(CopyJobBtn, 6)

        CopyJobBtn.MouseButton1Click:Connect(function()
            ClickSound:Play()
            if setclipboard then setclipboard(Server.id) end
            CopyJobBtn.Text = "✓ COPIED"
            CopyJobBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
            task.wait(1.5)
            CopyJobBtn.Text = "📋 JOB ID"
            CopyJobBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        end)

        local Join = Instance.new("TextButton")
        Join.Parent = Row
        Join.Size = UDim2.fromOffset(45, 28)
        Join.Position = UDim2.new(1, -50, 0.5, -14)
        Join.BackgroundColor3 = Accent
        Join.Text = "🚀"
        Join.TextSize = 13
        Corner(Join, 6)

        Join.MouseButton1Click:Connect(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, LocalPlayer)
        end)
    end

    FindLowPingServer.MouseButton1Click:Connect(function()
        ClickSound:Play()
        ServerStatus.Text = "Đang quét..."
        task.spawn(function()
            local list = GetServers("lowping")
            for _, v in ipairs(ServerList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
            for i, s in ipairs(list) do AddServerRow(s, i, "Low Ping") end
            ServerStatus.Text = "✓ Đã xong!"
        end)
    end)

    Find1Player.MouseButton1Click:Connect(function()
        ClickSound:Play()
        ServerStatus.Text = "Đang quét..."
        task.spawn(function()
            local list = GetServers("strict1")
            for _, v in ipairs(ServerList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
            for i, s in ipairs(list) do AddServerRow(s, i, "1 Người") end
            ServerStatus.Text = "✓ Đã xong!"
        end)
    end)

    FindOldServer.MouseButton1Click:Connect(function()
        ClickSound:Play()
        ServerStatus.Text = "Đang quét..."
        task.spawn(function()
            local list = GetServers("old")
            for _, v in ipairs(ServerList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
            for i, s in ipairs(list) do AddServerRow(s, i, "Treo Cũ") end
            ServerStatus.Text = "✓ Đã xong!"
        end)
    end)

    -- TAB 5: SERVER DETAILS
    PageTitle(ServerInfoPage, "Server Details", "Thông tin hạ tầng và máy chủ Roblox hiện tại")

    local InfoFrame = Instance.new("Frame")
    InfoFrame.Parent = ServerInfoPage
    InfoFrame.Size = UDim2.new(1, -5, 1, -60)
    InfoFrame.Position = UDim2.fromOffset(0, 55)
    InfoFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Corner(InfoFrame, 12)
    Stroke(InfoFrame, Color3.fromRGB(40, 40, 55), 1)

    local function MakeInfoRow(Y, Title, Value)
        local Row = Instance.new("Frame")
        Row.Parent = InfoFrame
        Row.Size = UDim2.new(1, -20, 0, 35)
        Row.Position = UDim2.fromOffset(10, Y)
        Row.BackgroundTransparency = 1

        local T = Instance.new("TextLabel")
        T.Parent = Row
        T.Size = UDim2.new(0.4, 0, 1, 0)
        T.BackgroundTransparency = 1
        T.Text = Title
        T.TextColor3 = Color3.fromRGB(140, 140, 160)
        T.TextSize = 11
        T.Font = Enum.Font.GothamBold
        T.TextXAlignment = Enum.TextXAlignment.Left

        local V = Instance.new("TextLabel")
        V.Parent = Row
        V.Size = UDim2.new(0.6, 0, 1, 0)
        V.Position = UDim2.new(0.4, 0, 0, 0)
        V.BackgroundTransparency = 1
        V.Text = Value
        V.TextColor3 = Accent
        V.TextSize = 11
        V.Font = Enum.Font.Gotham
        V.TextXAlignment = Enum.TextXAlignment.Right
        V.TextTruncate = Enum.TextTruncate.AtEnd
        return V
    end

    MakeInfoRow(10, "GAME PLACE ID:", tostring(game.PlaceId))
    MakeInfoRow(50, "SERVER JOB ID:", game.JobId)
    local UptimeVal = MakeInfoRow(90, "SERVER UPTIME:", "0s")
    MakeInfoRow(130, "MAX PLAYERS CAPACITY:", tostring(Players.MaxPlayers))
    MakeInfoRow(170, "CREATOR ID:", tostring(game.CreatorId))

    local startTime = os.clock()
    task.spawn(function()
        while ServerInfoPage.Parent do
            local elapsed = math.floor(os.clock() - startTime)
            local hrs = math.floor(elapsed / 3600)
            local mins = math.floor((elapsed % 3600) / 60)
            local secs = elapsed % 60
            UptimeVal.Text = string.format("%02dh %02dm %02ds", hrs, mins, secs)
            task.wait(1)
        end
    end)

    -- TAB 6: GLOBAL CHAT
    PageTitle(ChatPage, "Global Community Chat", "Trò chuyện trực tuyến cùng những người dùng script khác")

    local PinnedBanner = Instance.new("Frame")
    PinnedBanner.Parent = ChatPage
    PinnedBanner.Size = UDim2.new(1, -5, 0, 32)
    PinnedBanner.Position = UDim2.fromOffset(0, 52)
    PinnedBanner.BackgroundColor3 = Color3.fromRGB(22, 18, 30)
    Corner(PinnedBanner, 8)
    Stroke(PinnedBanner, Accent, 1)

    local PinnedText = Instance.new("TextLabel")
    PinnedText.Parent = PinnedBanner
    PinnedText.Size = UDim2.new(1, -20, 1, 0)
    PinnedText.Position = UDim2.fromOffset(10, 0)
    PinnedText.BackgroundTransparency = 1
    PinnedText.Text = "📌 Tin nhắn ghim từ Admin: Chào mừng bạn đến với Luxury Hub!"
    PinnedText.TextColor3 = Color3.fromRGB(240, 220, 255)
    PinnedText.TextSize = 10
    PinnedText.Font = Enum.Font.GothamBold
    PinnedText.TextXAlignment = Enum.TextXAlignment.Left

    local ChatBoxContainer = Instance.new("ScrollingFrame")
    ChatBoxContainer.Parent = ChatPage
    ChatBoxContainer.Size = UDim2.new(1, -5, 1, -145)
    ChatBoxContainer.Position = UDim2.fromOffset(0, 90)
    ChatBoxContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    ChatBoxContainer.BorderSizePixel = 0
    ChatBoxContainer.ScrollBarThickness = 3
    ChatBoxContainer.ScrollBarImageColor3 = Accent
    Corner(ChatBoxContainer, 10)
    Stroke(ChatBoxContainer, Color3.fromRGB(40, 40, 55), 1)

    local ChatLayout = Instance.new("UIListLayout")
    ChatLayout.Parent = ChatBoxContainer
    ChatLayout.Padding = UDim.new(0, 5)

    local ChatInput = Instance.new("TextBox")
    ChatInput.Parent = ChatPage
    ChatInput.Size = UDim2.new(1, -75, 0, 36)
    ChatInput.Position = UDim2.new(0, 0, 1, -42)
    ChatInput.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    ChatInput.PlaceholderText = "Nhập nội dung tin nhắn..."
    ChatInput.Text = ""
    ChatInput.TextColor3 = Color3.new(1, 1, 1)
    ChatInput.TextSize = 11
    ChatInput.Font = Enum.Font.Gotham
    Corner(ChatInput, 8)

    local SendChatBtn = Instance.new("TextButton")
    SendChatBtn.Parent = ChatPage
    SendChatBtn.Size = UDim2.fromOffset(70, 36)
    SendChatBtn.Position = UDim2.new(1, -70, 1, -42)
    SendChatBtn.BackgroundColor3 = Accent
    SendChatBtn.Text = "GỬI"
    SendChatBtn.TextColor3 = Color3.new(1, 1, 1)
    SendChatBtn.TextSize = 11
    SendChatBtn.Font = Enum.Font.GothamBold
    Corner(SendChatBtn, 8)

    local ProcessedChatLogs = {}
    local function AddChatMessage(senderName, senderAvatar, messageText, isSpecialAdmin)
        local msgFingerprint = senderName .. ":" .. messageText
        if ProcessedChatLogs[msgFingerprint] and (os.clock() - ProcessedChatLogs[msgFingerprint]) < 1 then return end
        ProcessedChatLogs[msgFingerprint] = os.clock()

        local Row = Instance.new("Frame")
        Row.Parent = ChatBoxContainer
        Row.Size = UDim2.new(1, -10, 0, 40)
        Row.BackgroundTransparency = 1

        local Avatar = Instance.new("ImageLabel")
        Avatar.Parent = Row
        Avatar.Size = UDim2.fromOffset(28, 28)
        Avatar.Position = UDim2.fromOffset(5, 5)
        Avatar.BackgroundTransparency = 1
        Avatar.Image = senderAvatar ~= "" and senderAvatar or AvatarURL
        Corner(Avatar, 14)

        local NameLabel = Instance.new("TextLabel")
        NameLabel.Parent = Row
        NameLabel.Size = UDim2.new(1, -85, 0, 15)
        NameLabel.Position = UDim2.fromOffset(40, 3)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = senderName .. (isSpecialAdmin and " 👑 [ADMIN]" or "")
        NameLabel.TextColor3 = isSpecialAdmin and Color3.fromRGB(255, 100, 100) or Accent
        NameLabel.TextSize = 10
        NameLabel.Font = Enum.Font.GothamBold
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left

        local TextLabel = Instance.new("TextLabel")
        TextLabel.Parent = Row
        TextLabel.Size = UDim2.new(1, -85, 0, 18)
        TextLabel.Position = UDim2.fromOffset(40, 18)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = messageText
        TextLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
        TextLabel.TextSize = 11
        TextLabel.Font = Enum.Font.Gotham
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left

        task.defer(function() ChatBoxContainer.CanvasPosition = Vector2.new(0, 99999) end)
    end

    AddChatMessage("System Bot", "", "Hệ thống Universal Chat đã sẵn sàng!", false)

    -- TAB 7: CUSTOM SKIN
    PageTitle(SkinPage, "Custom Skin Hub", "Sao chép ngoại hình và animation của người chơi khác")

    local SkinList = Instance.new("ScrollingFrame")
    SkinList.Parent = SkinPage
    SkinList.Size = UDim2.new(1, -5, 1, -65)
    SkinList.Position = UDim2.fromOffset(0, 55)
    SkinList.BackgroundTransparency = 1
    SkinList.BorderSizePixel = 0
    SkinList.ScrollBarThickness = 3
    SkinList.ScrollBarImageColor3 = Accent

    local SkinLayout = Instance.new("UIListLayout")
    SkinLayout.Parent = SkinList
    SkinLayout.Padding = UDim.new(0, 8)
    SkinLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SkinList.CanvasSize = UDim2.new(0, 0, 0, SkinLayout.AbsoluteContentSize.Y + 10)
    end)

    local function RefreshSkinList()
        for _, Child in ipairs(SkinList:GetChildren()) do if Child:IsA("Frame") then Child:Destroy() end end
        for _, Target in ipairs(Players:GetPlayers()) do
            if Target ~= LocalPlayer then
                local Row = Instance.new("Frame")
                Row.Parent = SkinList
                Row.Size = UDim2.new(1, -5, 0, 55)
                Row.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
                Corner(Row, 12)

                local TargetAvatar = Instance.new("ImageLabel")
                TargetAvatar.Parent = Row
                TargetAvatar.Size = UDim2.fromOffset(38, 38)
                TargetAvatar.Position = UDim2.fromOffset(8, 8)
                TargetAvatar.BackgroundTransparency = 1
                Corner(TargetAvatar, 19)
                
                pcall(function()
                    TargetAvatar.Image = Players:GetUserThumbnailAsync(Target.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                end)

                local Name = Instance.new("TextLabel")
                Name.Parent = Row
                Name.Size = UDim2.new(1, -140, 0, 20)
                Name.Position = UDim2.fromOffset(55, 8)
                Name.BackgroundTransparency = 1
                Name.Text = Target.DisplayName
                Name.TextColor3 = Color3.new(1, 1, 1)
                Name.TextSize = 12
                Name.Font = Enum.Font.GothamBold
                Name.TextXAlignment = Enum.TextXAlignment.Left

                local User = Instance.new("TextLabel")
                User.Parent = Row
                User.Size = UDim2.new(1, -140, 0, 16)
                User.Position = UDim2.fromOffset(55, 28)
                User.BackgroundTransparency = 1
                User.Text = "@" .. Target.Name
                User.TextColor3 = Color3.fromRGB(130, 130, 145)
                User.TextSize = 10
                User.Font = Enum.Font.Gotham
                User.TextXAlignment = Enum.TextXAlignment.Left

                local SkinBtn = Instance.new("TextButton")
                SkinBtn.Parent = Row
                SkinBtn.Size = UDim2.fromOffset(70, 30)
                SkinBtn.Position = UDim2.new(1, -80, 0.5, -15)
                SkinBtn.BackgroundColor3 = Accent
                SkinBtn.Text = "SKIN"
                SkinBtn.TextColor3 = Color3.new(1, 1, 1)
                SkinBtn.TextSize = 10
                SkinBtn.Font = Enum.Font.GothamBold
                Corner(SkinBtn, 8)

                SkinBtn.MouseButton1Click:Connect(function()
                    ClickSound:Play()
                    SkinBtn.Text = "..."
                    task.spawn(function()
                        local success = pcall(function()
                            local char = LocalPlayer.Character
                            if char and char:FindFirstChildOfClass("Humanoid") then
                                local desc = Players:GetHumanoidDescriptionFromUserId(Target.UserId)
                                if desc then char:FindFirstChildOfClass("Humanoid"):ApplyDescriptionReset(desc) end
                            end
                        end)
                        if success then
                            SkinBtn.Text = "✓ DONE"
                            SkinBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
                            task.wait(1.5)
                            SkinBtn.Text = "SKIN"
                            SkinBtn.BackgroundColor3 = Accent
                        end
                    end)
                end)
            end
        end
    end
    RefreshSkinList()
    Players.PlayerAdded:Connect(function() task.wait(0.2) RefreshSkinList() end)
    Players.PlayerRemoving:Connect(function() task.wait(0.1) RefreshSkinList() end)

    -- TAB 8: SETTINGS
    PageTitle(SettingsPage, "Customization", "Tùy chỉnh giao diện và màu chủ đạo")
    local ThemeLabel = Instance.new("TextLabel")
    ThemeLabel.Parent = SettingsPage
    ThemeLabel.Size = UDim2.new(1, 0, 0, 20)
    ThemeLabel.Position = UDim2.fromOffset(0, 55)
    ThemeLabel.BackgroundTransparency = 1
    ThemeLabel.Text = "CHỌN MÀU GIAO DIỆN (THEME COLOR)"
    ThemeLabel.TextColor3 = Color3.new(1, 1, 1)
    ThemeLabel.TextSize = 11
    ThemeLabel.Font = Enum.Font.GothamBold
    ThemeLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ThemeContainer = Instance.new("Frame")
    ThemeContainer.Parent = SettingsPage
    ThemeContainer.Size = UDim2.new(1, 0, 0, 150)
    ThemeContainer.Position = UDim2.fromOffset(0, 80)
    ThemeContainer.BackgroundTransparency = 1

    local Grid = Instance.new("UIGridLayout")
    Grid.Parent = ThemeContainer
    Grid.CellSize = UDim2.fromOffset(105, 36)
    Grid.CellPadding = UDim2.fromOffset(8, 8)

    for Name, Color in pairs(THEMES) do
        local Button = Instance.new("TextButton")
        Button.Parent = ThemeContainer
        Button.BackgroundColor3 = Color
        Button.Text = Name
        Button.TextColor3 = Color3.new(1, 1, 1)
        Button.TextSize = 10
        Button.Font = Enum.Font.GothamBold
        Corner(Button, 8)

        Button.MouseButton1Click:Connect(function()
            Accent = Color
            Menu.UIStroke.Color = Accent
            Icon.UIStroke.Color = Accent
            Logo.TextColor3 = Accent
            BottomUser.TextColor3 = Accent
            QuickRejoinBtn.UIStroke.Color = Accent
            SendChatBtn.BackgroundColor3 = Accent
            JoinJobBtn.BackgroundColor3 = Accent
            CopyCurrentJobBtn.BackgroundColor3 = Accent

            for PageName, Nav in pairs(NavButtons) do
                if Pages[PageName].Visible then
                    Nav.BackgroundColor3 = Accent
                    Nav.TextColor3 = Color3.new(1, 1, 1)
                end
            end
        end)
    end

    -- TAB 9: CREATOR INFO
    PageTitle(CreatorPage, "Developer Information", "Thông tin chi tiết về nhà phát triển script")
    local CreatorCard = Instance.new("Frame")
    CreatorCard.Parent = CreatorPage
    CreatorCard.Size = UDim2.new(1, -5, 0, 80)
    CreatorCard.Position = UDim2.fromOffset(0, 55)
    CreatorCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(CreatorCard, 12)
    Stroke(CreatorCard, Accent, 1.5)

    local CreatorTitle = Instance.new("TextLabel")
    CreatorTitle.Parent = CreatorCard
    CreatorTitle.Size = UDim2.new(1, -20, 0, 24)
    CreatorTitle.Position = UDim2.fromOffset(15, 10)
    CreatorTitle.BackgroundTransparency = 1
    CreatorTitle.Text = "👑  SCRIPT CREATOR: Kit_n67"
    CreatorTitle.TextColor3 = Accent
    CreatorTitle.TextSize = 14
    CreatorTitle.Font = Enum.Font.GothamBold
    CreatorTitle.TextXAlignment = Enum.TextXAlignment.Left

    local CreatorDesc = Instance.new("TextLabel")
    CreatorDesc.Parent = CreatorCard
    CreatorDesc.Size = UDim2.new(1, -20, 0, 34)
    CreatorDesc.Position = UDim2.fromOffset(15, 34)
    CreatorDesc.BackgroundTransparency = 1
    CreatorDesc.Text = "Luxury Dashboard v2.0 Ultimate - Phiên bản tối ưu giao diện và tích hợp đa tính năng."
    CreatorDesc.TextColor3 = Color3.fromRGB(160, 160, 175)
    CreatorDesc.TextSize = 11
    CreatorDesc.Font = Enum.Font.Gotham
    CreatorDesc.TextXAlignment = Enum.TextXAlignment.Left

    local SocialFrame = Instance.new("Frame")
    SocialFrame.Parent = CreatorPage
    SocialFrame.Size = UDim2.new(1, -5, 1, -150)
    SocialFrame.Position = UDim2.fromOffset(0, 145)
    SocialFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Corner(SocialFrame, 12)
    Stroke(SocialFrame, Color3.fromRGB(40, 40, 55), 1)

    local SocialLayout = Instance.new("UIListLayout")
    SocialLayout.Parent = SocialFrame
    SocialLayout.Padding = UDim.new(0, 8)

    local SocialPadding = Instance.new("UIPadding")
    SocialPadding.PaddingTop = UDim.new(0, 10)
    SocialPadding.PaddingLeft = UDim.new(0, 10)
    SocialPadding.PaddingRight = UDim.new(0, 10)
    SocialPadding.Parent = SocialFrame

    local function CreateSocialRow(platformName, iconEmoji, linkUrl)
        local Row = Instance.new("Frame")
        Row.Parent = SocialFrame
        Row.Size = UDim2.new(1, 0, 0, 42)
        Row.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
        Corner(Row, 10)

        local IconLbl = Instance.new("TextLabel")
        IconLbl.Parent = Row
        IconLbl.Size = UDim2.fromOffset(30, 42)
        IconLbl.Position = UDim2.fromOffset(10, 0)
        IconLbl.BackgroundTransparency = 1
        IconLbl.Text = iconEmoji
        IconLbl.TextSize = 15

        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.Parent = Row
        TitleLbl.Size = UDim2.new(1, -130, 0, 18)
        TitleLbl.Position = UDim2.fromOffset(45, 4)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Text = platformName
        TitleLbl.TextColor3 = Color3.new(1, 1, 1)
        TitleLbl.TextSize = 11
        TitleLbl.Font = Enum.Font.GothamBold
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

        local LinkLbl = Instance.new("TextLabel")
        LinkLbl.Parent = Row
        LinkLbl.Size = UDim2.new(1, -130, 0, 16)
        LinkLbl.Position = UDim2.fromOffset(45, 22)
        LinkLbl.BackgroundTransparency = 1
        LinkLbl.Text = linkUrl
        LinkLbl.TextColor3 = Color3.fromRGB(140, 140, 160)
        LinkLbl.TextSize = 10
        LinkLbl.Font = Enum.Font.Gotham
        LinkLbl.TextXAlignment = Enum.TextXAlignment.Left

        local LinkLbl = Instance.new("TextLabel")
        LinkLbl.Parent = Row
        LinkLbl.Size = UDim2.new(1, -130, 0, 16)
        LinkLbl.Position = UDim2.fromOffset(45, 22)
        LinkLbl.BackgroundTransparency = 1
        LinkLbl.Text = linkUrl
        LinkLbl.TextColor3 = Color3.fromRGB(140, 140, 160)
        LinkLbl.TextSize = 10
        LinkLbl.Font = Enum.Font.Gotham
        LinkLbl.TextXAlignment = Enum.TextXAlignment.Left

        local CopyBtn = Instance.new("TextButton")
        CopyBtn.Parent = Row
        CopyBtn.Size = UDim2.fromOffset(70, 26)
        CopyBtn.Position = UDim2.new(1, -78, 0.5, -13)
        CopyBtn.BackgroundColor3 = Accent
        CopyBtn.Text = "📋 COPY"
        CopyBtn.TextColor3 = Color3.new(1, 1, 1)
        CopyBtn.TextSize = 10
        CopyBtn.Font = Enum.Font.GothamBold
        Corner(CopyBtn, 6)

        CopyBtn.MouseButton1Click:Connect(function()
            ClickSound:Play()
            if setclipboard then setclipboard(linkUrl) end
            CopyBtn.Text = "✓ COPIED"
            CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
            task.wait(1.5)
            CopyBtn.Text = "📋 COPY"
            CopyBtn.BackgroundColor3 = Accent
        end)
    end

    CreateSocialRow("TikTok", "🎵", CREATOR_LINKS.TikTok)
    CreateSocialRow("YouTube", "▶️", CREATOR_LINKS.YouTube)
    CreateSocialRow("Discord", "💬", CREATOR_LINKS.Discord)

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
    end

    HomeNav.MouseButton1Click:Connect(function() ShowPage("Home") end)
    UtilityNav.MouseButton1Click:Connect(function() ShowPage("Utility") end)
    PlayersNav.MouseButton1Click:Connect(function() ShowPage("Players") end)
    ServerNav.MouseButton1Click:Connect(function() ShowPage("Server") end)
    ServerInfoNav.MouseButton1Click:Connect(function() ShowPage("ServerInfo") end)
    ChatNav.MouseButton1Click:Connect(function() ShowPage("Chat") end)
    SkinNav.MouseButton1Click:Connect(function() ShowPage("Skin") end)
    SettingsNav.MouseButton1Click:Connect(function() ShowPage("Settings") end)
    CreatorNav.MouseButton1Click:Connect(function() ShowPage("Creator") end)

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
            pcall(function() Ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
            PingValue.Text = math.floor(Ping) .. " ms"
            PlayerCount.Text = tostring(#Players:GetPlayers())
            task.wait(1)
        end
    end)

    Icon.MouseButton1Click:Connect(function()
        if IconEnabled then Menu.Visible = not Menu.Visible end
    end)

    local DraggingMenu, MenuDragStart, MenuStartPosition = false, nil, nil
    DragHeader.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            DraggingMenu = true
            MenuDragStart = Input.Position
            MenuStartPosition = Menu.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if DraggingMenu and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = Input.Position - MenuDragStart
            Menu.Position = UDim2.new(MenuStartPosition.X.Scale, MenuStartPosition.X.Offset + Delta.X, MenuStartPosition.Y.Scale, MenuStartPosition.Y.Offset + Delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            DraggingMenu = false
        end
    end)

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Luxury Dashboard",
            Text = "Đã tải thành công phiên bản Master Ultimate!",
            Icon = "rbxthumb://type=Asset&id=113875514885319&w=150&h=150",
            Duration = 4,
        })
    end)
end

-- ==========================================================
-- KIỂM TRA CHẾ ĐỘ BẢO TRÌ TRƯỚC KHI KHỞI CHẠY
-- ==========================================================
if MAINTENANCE_CONFIG.Enabled and not isAdmin then
    local MaintFrame = Instance.new("Frame")
    MaintFrame.Parent = Gui
    MaintFrame.Size = UDim2.fromOffset(420, 260)
    MaintFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
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

    local MaintDesc = Instance.new("TextLabel")
    MaintDesc.Parent = MaintFrame
    MaintDesc.Size = UDim2.new(1, -30, 0, 70)
    MaintDesc.Position = UDim2.fromOffset(15, 55)
    MaintDesc.BackgroundTransparency = 1
    MaintDesc.Text = MAINTENANCE_CONFIG.Reason
    MaintDesc.TextColor3 = Color3.fromRGB(200, 200, 215)
    MaintDesc.TextSize = 11
    MaintDesc.Font = Enum.Font.Gotham
    MaintDesc.TextWrapped = true

    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Parent = MaintFrame
    TimerLabel.Size = UDim2.new(1, 0, 0, 24)
    TimerLabel.Position = UDim2.fromOffset(0, 135)
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.Text = "Thời gian tự động vào lại: " .. MAINTENANCE_CONFIG.Duration .. "s"
    TimerLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    TimerLabel.TextSize = 11
    TimerLabel.Font = Enum.Font.GothamBold

    -- NÚT BỎ QUA / TẮT BẢO TRÌ ĐỂ CHẠY LIỀN
    local BypassBtn = Instance.new("TextButton")
    BypassBtn.Parent = MaintFrame
    BypassBtn.Size = UDim2.fromOffset(180, 38)
    BypassBtn.Position = UDim2.new(0.5, -90, 1, -55)
    BypassBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 90)
    BypassBtn.Text = "🚀 CHẠY LUÔN (BYPASS)"
    BypassBtn.TextColor3 = Color3.new(1, 1, 1)
    BypassBtn.TextSize = 11
    BypassBtn.Font = Enum.Font.GothamBold
    Corner(BypassBtn, 8)

    local timeLeft = MAINTENANCE_CONFIG.Duration
    local connection
    local function CloseMaintenance()
        if connection then connection:Disconnect() end
        MaintFrame:Destroy()
        StartMainDashboard()
    end

    BypassBtn.MouseButton1Click:Connect(function()
        ClickSound:Play()
        CloseMaintenance()
    end)

    connection = task.spawn(function()
        while timeLeft > 0 and MaintFrame.Parent do
            task.wait(1)
            timeLeft -= 1
            TimerLabel.Text = "Thời gian tự động vào lại: " .. timeLeft .. "s"
        end
        if MaintFrame.Parent then
            CloseMaintenance()
        end
    end)
else
    -- Nếu Admin hoặc tắt bảo trì thì load thẳng menu chính
    StartMainDashboard()
end

print("Luxury Dashboard Master Ultimate + Maintenance System Loaded!")
