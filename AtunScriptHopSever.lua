-- ==============================================================================
-- Project: Luxury Dashboard UI (Fixed Rubberband WalkSpeed + Added Slider)
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
    MenuWidth = 750,
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

-- ICON MENU
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

-- HEADER KÉO THẢ
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

-- ========================================================
-- TAB UTILITIES: FIX RUBBERBAND & THÊM SLIDER TỐC ĐỘ CHẠY
-- ========================================================
PageTitle(UtilityPage, "Player Utilities", "Điều chỉnh tốc độ chạy chống giật lùi & nhảy vô tận")

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

-- KHU VỰC CÔNG CỤ CHỈNH WALKSPEED KÈM SLIDER VÀ NÚT BẬT BYPASS
local SpeedCard = Instance.new("Frame")
SpeedCard.Parent = UtilScroll
SpeedCard.Size = UDim2.new(1, -5, 0, 95)
SpeedCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
Corner(SpeedCard, 10)
Stroke(SpeedCard, Color3.fromRGB(40, 40, 55), 1)

local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Parent = SpeedCard
SpeedTitle.Size = UDim2.new(1, -20, 0, 22)
SpeedTitle.Position = UDim2.fromOffset(12, 6)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "🏃 TỐC ĐỘ CHẠY (BYPASS SPEED: 16)"
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

-- THANH SLIDER
local SliderBack = Instance.new("Frame")
SliderBack.Parent = SpeedCard
SliderBack.Size = UDim2.new(1, -24, 0, 8)
SliderBack.Position = UDim2.fromOffset(12, 38)
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

-- NÚT BYPASS CHỐNG TELEPORT VỀ LẠI
local BypassToggle = Instance.new("TextButton")
BypassToggle.Parent = SpeedCard
BypassToggle.Size = UDim2.new(1, -24, 0, 28)
BypassToggle.Position = UDim2.fromOffset(12, 58)
BypassToggle.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
BypassToggle.Text = "🛡️ BYPASS ANTI-CHEAT (CHỐNG GIẬT LÙI): OFF"
BypassToggle.TextColor3 = Color3.fromRGB(160, 160, 175)
BypassToggle.TextSize = 10
BypassToggle.Font = Enum.Font.GothamBold
Corner(BypassToggle, 6)

local currentSpeed = 16
local bypassEnabled = false

local function UpdateSpeed(val)
    currentSpeed = math.clamp(val, 16, 120)
    SpeedTitle.Text = "🏃 TỐC ĐỘ CHẠY (BYPASS SPEED: " .. currentSpeed .. ")"
    SpeedValBox.Text = tostring(currentSpeed)
    
    local rel = (currentSpeed - 16) / (120 - 16)
    SliderFill.Size = UDim2.new(rel, 0, 1, 0)
    SliderKnob.Position = UDim2.new(rel, -8, 0.5, -8)
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = currentSpeed
    end
end

-- KÉO SLIDER
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
        local mousePos = input.Position.X
        local rel = math.clamp((mousePos - absPos) / absSize, 0, 1)
        local calculated = math.floor(16 + rel * (120 - 16))
        UpdateSpeed(calculated)
    end
end)

SpeedValBox.FocusLost:Connect(function()
    local n = tonumber(SpeedValBox.Text)
    if n then UpdateSpeed(n) end
end)

BypassToggle.MouseButton1Click:Connect(function()
    ClickSound:Play()
    bypassEnabled = not bypassEnabled
    if bypassEnabled then
        BypassToggle.Text = "🛡️ BYPASS ANTI-CHEAT (CHỐNG GIẬT LÙI): ON"
        BypassToggle.BackgroundColor3 = Accent
        BypassToggle.TextColor3 = Color3.new(1, 1, 1)
    else
        BypassToggle.Text = "🛡️ BYPASS ANTI-CHEAT (CHỐNG GIẬT LÙI): OFF"
        BypassToggle.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        BypassToggle.TextColor3 = Color3.fromRGB(160, 160, 175)
    end
end)

-- VÒNG LẶP DỊCH CHUYỂN NHẸ (BYPASS C-FRAME VECTOR) TRÁNH BỊ DỊCH CHUYỂN LÙI
RunService.Heartbeat:Connect(function(delta)
    if bypassEnabled and currentSpeed > 16 then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.MoveDirection.Magnitude > 0 then
                local extraSpeed = (currentSpeed - 16) * delta
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * extraSpeed)
            end
        end
    end
end)

-- NÚT TOGGLE NHẢY VÔ TẬN
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

-- ========================================================
-- TAB DASHBOARD / HOME
-- ========================================================
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

-- ==========================================================
-- ĐIỀU HƯỚNG TẢI TAB & CÁC TRANG CÒN LẠI
-- ==========================================================
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

-- RUNTIME FPS & PING
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

-- KÉO THẢ MENU
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
        Text = "Đã cập nhật tính năng Bypass Speed & Slider mượt mà!",
        Icon = "rbxthumb://type=Asset&id=113875514885319&w=150&h=150",
        Duration = 4,
    })
end)

print("Luxury Dashboard Fixed Speed & Slider Loaded!")
