-- ==============================================================================
-- Project: Luxury Dashboard UI (SAFE EDITION - PERFECT SERVER HOP & HOME JOB ID)
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
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ADMIN_USERNAME = "kit_n67"
local isAdmin = (LocalPlayer.Name:lower() == ADMIN_USERNAME:lower())

local MAINTENANCE_CONFIG = {
    Enabled = false,
    Duration = 10,
    Reason = "Hệ thống đang bảo trì..."
}

local CREATOR_LINKS = {
    TikTok = "https://www.tiktok.com/@kit_n67",
    YouTube = "https://www.youtube.com/@kit_n67",
    Discord = "https://discord.gg/luxuryhub"
}

local CONFIG = {
    Theme = "Purple",
    MenuWidth = 760,
    MenuHeight = 490,
    TeleportOffset = 3,
}

local THEMES = {
    Purple = Color3.fromRGB(140, 70, 255),
    Pink = Color3.fromRGB(255, 60, 150),
    Blue = Color3.fromRGB(50, 120, 255),
    Cyan = Color3.fromRGB(20, 200, 210),
    Green = Color3.fromRGB(40, 200, 100),
    Red = Color3.fromRGB(230, 50, 60),
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
    AvatarURL = Players:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)

-- 🛡️ ANTI-AFK CHẠY ẨN NGẦM 100%
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
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

-- 📱 DYNAMIC ISLAND (IPHONE PILL DESIGN)
local DynamicIsland = Instance.new("TextButton")
DynamicIsland.Name = "AppleDynamicIsland"
DynamicIsland.Parent = Gui
DynamicIsland.Size = UDim2.fromOffset(210, 36)
DynamicIsland.Position = UDim2.new(0.5, -105, 0, 10)
DynamicIsland.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DynamicIsland.BorderSizePixel = 0
DynamicIsland.AutoButtonColor = false
DynamicIsland.Text = ""
DynamicIsland.ClipsDescendants = true
Corner(DynamicIsland, 18)
Stroke(DynamicIsland, Color3.fromRGB(35, 35, 45), 1.5, 0.4)

local CameraLens = Instance.new("Frame")
CameraLens.Parent = DynamicIsland
CameraLens.Size = UDim2.fromOffset(11, 11)
CameraLens.Position = UDim2.fromOffset(14, 12.5)
CameraLens.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
Corner(CameraLens, 6)

local ClockLabel = Instance.new("TextLabel")
ClockLabel.Parent = DynamicIsland
ClockLabel.Size = UDim2.fromOffset(60, 36)
ClockLabel.Position = UDim2.new(1, -65, 0, 0)
ClockLabel.BackgroundTransparency = 1
ClockLabel.Text = "00:00"
ClockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ClockLabel.TextSize = 11
ClockLabel.Font = Enum.Font.GothamBold

-- THANH STATUS BÊN DƯỚI DYNAMIC ISLAND
local StatusContainer = Instance.new("Frame")
StatusContainer.Name = "StatusContainer"
StatusContainer.Parent = Gui
StatusContainer.Size = UDim2.fromOffset(340, 30)
StatusContainer.Position = UDim2.new(0.5, -170, 0, 52)
StatusContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Corner(StatusContainer, 10)
Stroke(StatusContainer, Accent, 1, 0.4)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = StatusContainer
StatusLabel.Size = UDim2.new(1, -20, 1, 0)
StatusLabel.Position = UDim2.fromOffset(10, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Luxury Dashboard Ready"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local function SetStatus(text)
    StatusLabel.Text = text
end

task.spawn(function()
    while Gui.Parent do
        local now = os.date("*t")
        ClockLabel.Text = string.format("%02d:%02d", now.hour, now.min)
        task.wait(1)
    end
end)

-- MENU CHÍNH
local function StartMainDashboard()
    SetStatus("Dashboard Overview")

    local Icon = Instance.new("ImageButton")
    Icon.Name = "MenuIcon"
    Icon.Parent = Gui
    Icon.Size = UDim2.fromOffset(52, 52)
    Icon.Position = UDim2.new(0, 20, 0.5, -26)
    Icon.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    Icon.Image = "rbxthumb://type=Asset&id=113875514885319&w=150&h=150"
    Corner(Icon, 26)
    Stroke(Icon, Accent, 2)

    local Menu = Instance.new("Frame")
    Menu.Name = "MainMenu"
    Menu.Parent = Gui
    Menu.Size = UDim2.fromOffset(CONFIG.MenuWidth, CONFIG.MenuHeight)
    Menu.Position = UDim2.new(0.5, -CONFIG.MenuWidth/2, 0.5, -CONFIG.MenuHeight/2)
    Menu.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    Menu.ClipsDescendants = true
    Corner(Menu, 16)
    Stroke(Menu, Accent, 1.5)

    local DragHeader = Instance.new("Frame")
    DragHeader.Parent = Menu
    DragHeader.Size = UDim2.new(1, -110, 0, 35)
    DragHeader.Position = UDim2.fromOffset(0, 0)
    DragHeader.BackgroundTransparency = 1

    local TopBarControls = Instance.new("Frame")
    TopBarControls.Parent = Menu
    TopBarControls.Size = UDim2.fromOffset(100, 35)
    TopBarControls.Position = UDim2.new(1, -105, 0, 8)
    TopBarControls.BackgroundTransparency = 1

    local function MakeTopBtn(XOffset, Text, Callback)
        local Btn = Instance.new("TextButton")
        Btn.Parent = TopBarControls
        Btn.Size = UDim2.fromOffset(28, 28)
        Btn.Position = UDim2.fromOffset(XOffset, 0)
        Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
        Btn.Text = Text
        Btn.TextColor3 = Color3.fromRGB(200, 200, 210)
        Btn.Font = Enum.Font.GothamBold
        Corner(Btn, 6)
        Btn.MouseButton1Click:Connect(function() ClickSound:Play() Callback() end)
    end

    MakeTopBtn(0, "—", function() Menu.Visible = false SetStatus("Đã ẩn Menu") end)
    MakeTopBtn(32, "🗖", function() Menu.Size = (Menu.Size.X.Offset == 760) and UDim2.fromOffset(880, 560) or UDim2.fromOffset(760, 490) end)
    MakeTopBtn(64, "×", function() Menu.Visible = false Icon.Visible = false SetStatus("Đã tắt Menu") end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = Menu
    Sidebar.Size = UDim2.new(0, 185, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
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
    NavScroll.ScrollBarThickness = 2
    NavScroll.ScrollBarImageColor3 = Accent

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.Parent = NavScroll
    NavLayout.Padding = UDim.new(0, 5)

    local Pages, NavButtons = {}, {}

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

    -- KHỞI TẠO TAB
    local HomePage = MakePage("Home")
    local PlayersPage = MakePage("Players")
    local EspPage = MakePage("Esp")
    local PosPage = MakePage("Positions")
    local ServerPage = MakePage("Server")
    local ScriptHubPage = MakePage("ScriptHub")
    local CreatorPage = MakePage("Creator")

    local HomeNav = MakeNav("🏠   Dashboard", "Home")
    local PlayersNav = MakeNav("👥   Players List & TP", "Players")
    local EspNav = MakeNav("👁️   ESP Wallhack", "Esp")
    local PosNav = MakeNav("📍   Waypoints", "Positions")
    local ServerNav = MakeNav("🌐   Server Hop Hub", "Server")
    local ScriptHubNav = MakeNav("📁   Script Hub", "ScriptHub")
    local CreatorNav = MakeNav("👑   Creator Info", "Creator")

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

    -- TAB 1: DASHBOARD (CÓ HIỂN THỊ MÃ JOB ID SERVER ĐANG Ở)
    PageTitle(HomePage, "Dashboard Overview", "Thống kê hệ thống")
    
    local FPSValue = Instance.new("TextLabel")
    FPSValue.Parent = HomePage
    FPSValue.Size = UDim2.fromOffset(150, 65)
    FPSValue.Position = UDim2.fromOffset(5, 55)
    FPSValue.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    FPSValue.Text = "FPS: --"
    FPSValue.TextColor3 = Accent
    FPSValue.Font = Enum.Font.GothamBold
    Corner(FPSValue, 10)

    -- MÃ JOB ID SERVER ĐANG Ở TẠI TAB HOME
    local JobCard = Instance.new("Frame")
    JobCard.Parent = HomePage
    JobCard.Size = UDim2.new(1, -10, 0, 65)
    JobCard.Position = UDim2.fromOffset(5, 130)
    JobCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(JobCard, 10)
    Stroke(JobCard, Color3.fromRGB(40, 40, 55), 1)

    local JobTitleLbl = Instance.new("TextLabel")
    JobTitleLbl.Parent = JobCard
    JobTitleLbl.Size = UDim2.new(1, -20, 0, 20)
    JobTitleLbl.Position = UDim2.fromOffset(12, 8)
    JobTitleLbl.BackgroundTransparency = 1
    JobTitleLbl.Text = "🆔 SERVER JOB ID ĐANG Ở:"
    JobTitleLbl.TextColor3 = Color3.fromRGB(150, 150, 170)
    JobTitleLbl.TextSize = 11
    JobTitleLbl.Font = Enum.Font.GothamBold
    JobTitleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local JobValueLbl = Instance.new("TextLabel")
    JobValueLbl.Parent = JobCard
    JobValueLbl.Size = UDim2.new(1, -20, 0, 25)
    JobValueLbl.Position = UDim2.fromOffset(12, 30)
    JobValueLbl.BackgroundTransparency = 1
    JobValueLbl.Text = game.JobId
    JobValueLbl.TextColor3 = Accent
    JobValueLbl.TextSize = 12
    JobValueLbl.Font = Enum.Font.Gotham
    JobValueLbl.TextXAlignment = Enum.TextXAlignment.Left
    JobValueLbl.TextTruncate = Enum.TextTruncate.AtEnd

    -- TAB 2: PLAYERS & TP
    PageTitle(PlayersPage, "Active Players & Teleport", "Xem danh sách và dịch chuyển tới người chơi")
    local PlayerScroll = Instance.new("ScrollingFrame")
    PlayerScroll.Parent = PlayersPage
    PlayerScroll.Size = UDim2.new(1, -5, 1, -65)
    PlayerScroll.Position = UDim2.fromOffset(0, 55)
    PlayerScroll.BackgroundTransparency = 1
    PlayerScroll.ScrollBarThickness = 3
    PlayerScroll.ScrollBarImageColor3 = Accent

    local PlayerListLayout = Instance.new("UIListLayout")
    PlayerListLayout.Parent = PlayerScroll
    PlayerListLayout.Padding = UDim.new(0, 8)

    local function RefreshPlayers()
        for _, c in ipairs(PlayerScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        for _, Target in ipairs(Players:GetPlayers()) do
            if Target ~= LocalPlayer then
                local Row = Instance.new("Frame")
                Row.Parent = PlayerScroll
                Row.Size = UDim2.new(1, -5, 0, 55)
                Row.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
                Corner(Row, 10)

                local NameLbl = Instance.new("TextLabel")
                NameLbl.Parent = Row
                NameLbl.Size = UDim2.new(1, -190, 0, 20)
                NameLbl.Position = UDim2.fromOffset(12, 8)
                NameLbl.BackgroundTransparency = 1
                NameLbl.Text = Target.DisplayName .. " (@" .. Target.Name .. ")"
                NameLbl.TextColor3 = Color3.new(1, 1, 1)
                NameLbl.Font = Enum.Font.GothamBold
                NameLbl.TextXAlignment = Enum.TextXAlignment.Left

                local TpToBtn = Instance.new("TextButton")
                TpToBtn.Parent = Row
                TpToBtn.Size = UDim2.fromOffset(80, 28)
                TpToBtn.Position = UDim2.new(1, -85, 0.5, -14)
                TpToBtn.BackgroundColor3 = Accent
                TpToBtn.Text = "🚀 TP TỚI"
                TpToBtn.TextColor3 = Color3.new(1, 1, 1)
                TpToBtn.Font = Enum.Font.GothamBold
                Corner(TpToBtn, 6)

                TpToBtn.MouseButton1Click:Connect(function()
                    if LocalPlayer.Character and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character:PivotTo(Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, CONFIG.TeleportOffset))
                        SetStatus("Đã TP tới: " .. Target.DisplayName)
                    end
                end)
            end
        end
    end
    RefreshPlayers()
    Players.PlayerAdded:Connect(function() task.wait(0.2) RefreshPlayers() end)
    Players.PlayerRemoving:Connect(function() task.wait(0.1) RefreshPlayers() end)

    -- TAB 3: ESP
    PageTitle(EspPage, "ESP Wallhack", "Nhìn vị trí người chơi xuyên tường")
    local EspEnabled = false
    local EspBtn = Instance.new("TextButton")
    EspBtn.Parent = EspPage
    EspBtn.Size = UDim2.new(1, -5, 0, 40)
    EspBtn.Position = UDim2.fromOffset(0, 55)
    EspBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    EspBtn.Text = "👁️ ESP PLAYER HIGHLIGHT: OFF"
    EspBtn.TextColor3 = Color3.new(1, 1, 1)
    EspBtn.Font = Enum.Font.GothamBold
    Corner(EspBtn, 8)

    EspBtn.MouseButton1Click:Connect(function()
        EspEnabled = not EspEnabled
        EspBtn.Text = EspEnabled and "👁️ ESP PLAYER HIGHLIGHT: ON" or "👁️ ESP PLAYER HIGHLIGHT: OFF"
        EspBtn.BackgroundColor3 = EspEnabled and Accent or Color3.fromRGB(35, 35, 45)
        SetStatus(EspEnabled and "Đã BẬT ESP xuyên tường" or "Đã TẮT ESP")
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("LuxuryESP")
                if EspEnabled then
                    if not hl then hl = Instance.new("Highlight") hl.Name = "LuxuryESP" hl.FillColor = Accent hl.Parent = p.Character end
                else
                    if hl then hl:Destroy() end
                end
            end
        end
    end)

    -- TAB 4: WAYPOINTS
    PageTitle(PosPage, "Teleport Waypoints", "Lưu tọa độ mong muốn")
    local SavedCFrame = nil
    local SaveBtn = Instance.new("TextButton")
    SaveBtn.Parent = PosPage
    SaveBtn.Size = UDim2.new(0.48, 0, 0, 36)
    SaveBtn.Position = UDim2.fromOffset(0, 55)
    SaveBtn.BackgroundColor3 = Accent
    SaveBtn.Text = "📍 LƯU VỊ TRÍ"
    SaveBtn.TextColor3 = Color3.new(1, 1, 1)
    SaveBtn.Font = Enum.Font.GothamBold
    Corner(SaveBtn, 8)

    local LoadBtn = Instance.new("TextButton")
    LoadBtn.Parent = PosPage
    LoadBtn.Size = UDim2.new(0.48, 0, 0, 36)
    LoadBtn.Position = UDim2.new(0.5, 5, 0, 55)
    LoadBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    LoadBtn.Text = "🌀 DỊCH CHUYỂN"
    LoadBtn.TextColor3 = Color3.new(1, 1, 1)
    LoadBtn.Font = Enum.Font.GothamBold
    Corner(LoadBtn, 8)

    SaveBtn.MouseButton1Click:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            SavedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            SetStatus("Đã lưu tọa độ vị trí!")
        end
    end)

    LoadBtn.MouseButton1Click:Connect(function()
        if SavedCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = SavedCFrame
            SetStatus("Đã dịch chuyển về vị trí cũ!")
        end
    end)

    -- TAB 5: SERVER HOP HUB (3 NÚT CHÍNH + DÁN JOB ID + COPY JOB ID)
    PageTitle(ServerPage, "Server Hop Hub", "Quản lý chuyển Server, nhập Job ID hoặc sao chép mã Server")

    -- PHẦN NHẬP JOB ID + NÚT JOIN + NÚT COPY JOB ID
    local JobContainer = Instance.new("Frame")
    JobContainer.Parent = ServerPage
    JobContainer.Size = UDim2.new(1, -5, 0, 42)
    JobContainer.Position = UDim2.fromOffset(0, 55)
    JobContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(JobContainer, 8)

    local JobInp = Instance.new("TextBox")
    JobInp.Parent = JobContainer
    JobInp.Size = UDim2.new(1, -190, 1, 0)
    JobInp.Position = UDim2.fromOffset(10, 0)
    JobInp.BackgroundTransparency = 1
    JobInp.PlaceholderText = "Dán mã Job ID server vào đây..."
    JobInp.Text = ""
    JobInp.TextColor3 = Color3.new(1, 1, 1)
    JobInp.Font = Enum.Font.Gotham

    local JoinJobBtn = Instance.new("TextButton")
    JoinJobBtn.Parent = JobContainer
    JoinJobBtn.Size = UDim2.fromOffset(80, 30)
    JoinJobBtn.Position = UDim2.new(1, -175, 0.5, -15)
    JoinJobBtn.BackgroundColor3 = Accent
    JoinJobBtn.Text = "🚀 JOIN JOB"
    JoinJobBtn.TextColor3 = Color3.new(1, 1, 1)
    JoinJobBtn.Font = Enum.Font.GothamBold
    Corner(JoinJobBtn, 6)

    local CopyJobBtn = Instance.new("TextButton")
    CopyJobBtn.Parent = JobContainer
    CopyJobBtn.Size = UDim2.fromOffset(85, 30)
    CopyJobBtn.Position = UDim2.new(1, -90, 0.5, -15)
    CopyJobBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    CopyJobBtn.Text = "📋 COPY JOB"
    CopyJobBtn.TextColor3 = Color3.new(1, 1, 1)
    CopyJobBtn.Font = Enum.Font.GothamBold
    Corner(CopyJobBtn, 6)

    JoinJobBtn.MouseButton1Click:Connect(function()
        local targetJob = JobInp.Text:gsub("%s+", "")
        if targetJob ~= "" then
            SetStatus("Đang chuyển tới Job ID...")
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetJob, LocalPlayer)
        end
    end)

    CopyJobBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(game.JobId) end)
        SetStatus("Đã copy Job ID vào bộ nhớ tạm!")
        CopyJobBtn.Text = "✓ ĐÃ COPY!"
        task.wait(1)
        CopyJobBtn.Text = "📋 COPY JOB"
    end)

    -- 3 NÚT TÌM SERVER (1 NGƯỜI / PING THẤP / TREO CỦ)
    local Find1PlayerBtn = Instance.new("TextButton")
    Find1PlayerBtn.Parent = ServerPage
    Find1PlayerBtn.Size = UDim2.new(1, -5, 0, 38)
    Find1PlayerBtn.Position = UDim2.fromOffset(0, 107)
    Find1PlayerBtn.BackgroundColor3 = Accent
    Find1PlayerBtn.Text = "🔍 TÌM SERVER 1 NGƯỜI (LOWEST PLAYERS)"
    Find1PlayerBtn.TextColor3 = Color3.new(1, 1, 1)
    Find1PlayerBtn.Font = Enum.Font.GothamBold
    Corner(Find1PlayerBtn, 8)

    local FindLowPingBtn = Instance.new("TextButton")
    FindLowPingBtn.Parent = ServerPage
    FindLowPingBtn.Size = UDim2.new(1, -5, 0, 38)
    FindLowPingBtn.Position = UDim2.fromOffset(0, 153)
    FindLowPingBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 90)
    FindLowPingBtn.Text = "⚡ TÌM SERVER PING THẤP"
    FindLowPingBtn.TextColor3 = Color3.new(1, 1, 1)
    FindLowPingBtn.Font = Enum.Font.GothamBold
    Corner(FindLowPingBtn, 8)

    local FindOldServerBtn = Instance.new("TextButton")
    FindOldServerBtn.Parent = ServerPage
    FindOldServerBtn.Size = UDim2.new(1, -5, 0, 38)
    FindOldServerBtn.Position = UDim2.fromOffset(0, 199)
    FindOldServerBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    FindOldServerBtn.Text = "⏳ TÌM SERVER TREO CỦ (OLD SERVERS)"
    FindOldServerBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    FindOldServerBtn.Font = Enum.Font.GothamBold
    Corner(FindOldServerBtn, 8)

    local function TeleportToCustomServer(mode)
        SetStatus("Đang quét danh sách Server...")
        task.spawn(function()
            local sortOrder = (mode == "1player" or mode == "lowping") and "Asc" or "Desc"
            local raw = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=" .. sortOrder .. "&limit=100")
            local data = HttpService:JSONDecode(raw)
            if data and data.data then
                local validServers = {}
                for _, s in ipairs(data.data) do
                    if s.id ~= game.JobId and s.playing < s.maxPlayers then
                        if mode == "1player" and s.playing == 1 then
                            table.insert(validServers, s)
                        elseif mode ~= "1player" then
                            table.insert(validServers, s)
                        end
                    end
                end
                if #validServers > 0 then
                    local target = validServers[math.random(1, math.min(5, #validServers))]
                    SetStatus("Đang chuyển tới Server: " .. target.id)
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, target.id, LocalPlayer)
                else
                    SetStatus("Không tìm thấy server phù hợp, thử lại sau!")
                end
            end
        end)
    end

    Find1PlayerBtn.MouseButton1Click:Connect(function() TeleportToCustomServer("1player") end)
    FindLowPingBtn.MouseButton1Click:Connect(function() TeleportToCustomServer("lowping") end)
    FindOldServerBtn.MouseButton1Click:Connect(function() TeleportToCustomServer("old") end)

    -- TAB 6: SCRIPT HUB
    PageTitle(ScriptHubPage, "Script Hub Library", "Khởi chạy script hỗ trợ an toàn")
    local IyBtn = Instance.new("TextButton")
    IyBtn.Parent = ScriptHubPage
    IyBtn.Size = UDim2.new(1, -5, 0, 40)
    IyBtn.Position = UDim2.fromOffset(0, 55)
    IyBtn.BackgroundColor3 = Accent
    IyBtn.Text = "⚡ RUN INFINITE YIELD ADMIN"
    IyBtn.TextColor3 = Color3.new(1, 1, 1)
    IyBtn.Font = Enum.Font.GothamBold
    Corner(IyBtn, 8)

    IyBtn.MouseButton1Click:Connect(function()
        SetStatus("Đang tải Infinite Yield Admin...")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end)

    -- TAB 7: CREATOR INFO
    PageTitle(CreatorPage, "Developer & Socials", "Thông tin tác giả Kit_n67")

    local DevCard = Instance.new("Frame")
    DevCard.Parent = CreatorPage
    DevCard.Size = UDim2.new(1, -5, 0, 90)
    DevCard.Position = UDim2.fromOffset(0, 55)
    DevCard.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(DevCard, 10)
    Stroke(DevCard, Accent, 1)

    local DevTitle = Instance.new("TextLabel")
    DevTitle.Parent = DevCard
    DevTitle.Size = UDim2.new(1, -20, 0, 25)
    DevTitle.Position = UDim2.fromOffset(15, 12)
    DevTitle.BackgroundTransparency = 1
    DevTitle.Text = "👑 CREATOR: Kit_n67"
    DevTitle.TextColor3 = Color3.new(1, 1, 1)
    DevTitle.TextSize = 15
    DevTitle.Font = Enum.Font.GothamBold
    DevTitle.TextXAlignment = Enum.TextXAlignment.Left

    local DevSub = Instance.new("TextLabel")
    DevSub.Parent = DevCard
    DevSub.Size = UDim2.new(1, -20, 0, 20)
    DevSub.Position = UDim2.fromOffset(15, 38)
    DevSub.BackgroundTransparency = 1
    DevSub.Text = "Cảm ơn boss đã tin tưởng và sử dụng hệ thống Luxury Dashboard!"
    DevSub.TextColor3 = Color3.fromRGB(150, 150, 170)
    DevSub.TextSize = 11
    DevSub.Font = Enum.Font.Gotham
    DevSub.TextXAlignment = Enum.TextXAlignment.Left

    local function MakeSocialBtn(YPos, Text, Link, Color)
        local Btn = Instance.new("TextButton")
        Btn.Parent = CreatorPage
        Btn.Size = UDim2.new(1, -5, 0, 36)
        Btn.Position = UDim2.fromOffset(0, YPos)
        Btn.BackgroundColor3 = Color
        Btn.Text = Text
        Btn.TextColor3 = Color3.new(1, 1, 1)
        Btn.TextSize = 11
        Btn.Font = Enum.Font.GothamBold
        Corner(Btn, 8)

        Btn.MouseButton1Click:Connect(function()
            pcall(function() setclipboard(Link) end)
            SetStatus("Đã copy link: " .. Link)
            Btn.Text = "✓ ĐÃ SAO CHÉP LINK DÁN VÀO TRÌNH DUYỆT!"
            task.wait(1.5)
            Btn.Text = Text
        end)
    end

    MakeSocialBtn(155, "🎵 TIKTOK: @kit_n67 (BẤM ĐỂ SAO CHÉP LINK)", CREATOR_LINKS.TikTok, Color3.fromRGB(30, 30, 40))
    MakeSocialBtn(200, "▶️ YOUTUBE: Kit_n67 Channel (BẤM ĐỂ SAO CHÉP LINK)", CREATOR_LINKS.YouTube, Color3.fromRGB(200, 40, 50))
    MakeSocialBtn(245, "💬 DISCORD COMMUNITY (BẤM ĐỂ SAO CHÉP LINK)", CREATOR_LINKS.Discord, Color3.fromRGB(88, 101, 242))

    -- ĐIỀU HƯỚNG TAB
    local function ShowPage(Name)
        for PageName, Page in pairs(Pages) do Page.Visible = (PageName == Name) end
        for PageName, Button in pairs(NavButtons) do
            Button.BackgroundColor3 = (PageName == Name) and Accent or Color3.fromRGB(22, 22, 30)
            Button.TextColor3 = (PageName == Name) and Color3.new(1, 1, 1) or Color3.fromRGB(150, 150, 165)
        end
        SetStatus("Đang ở Tab " .. Name)
    end

    HomeNav.MouseButton1Click:Connect(function() ShowPage("Home") end)
    PlayersNav.MouseButton1Click:Connect(function() ShowPage("Players") end)
    EspNav.MouseButton1Click:Connect(function() ShowPage("Esp") end)
    PosNav.MouseButton1Click:Connect(function() ShowPage("Positions") end)
    ServerNav.MouseButton1Click:Connect(function() ShowPage("Server") end)
    ScriptHubNav.MouseButton1Click:Connect(function() ShowPage("ScriptHub") end)
    CreatorNav.MouseButton1Click:Connect(function() ShowPage("Creator") end)

    ShowPage("Home")
    Icon.MouseButton1Click:Connect(function() Menu.Visible = not Menu.Visible end)

    local Frames, LastFPS = 0, os.clock()
    RunService.RenderStepped:Connect(function()
        Frames += 1
        local Now = os.clock()
        if Now - LastFPS >= 1 then
            FPSValue.Text = "FPS: " .. Frames
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
    MaintFrame.Size = UDim2.fromOffset(380, 180)
    MaintFrame.Position = UDim2.new(0.5, -190, 0.5, -90)
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
    MaintTitle.Font = Enum.Font.GothamBold

    local TimerLabel = Instance.new("TextLabel")
    TimerLabel.Parent = MaintFrame
    TimerLabel.Size = UDim2.new(1, 0, 0, 30)
    TimerLabel.Position = UDim2.fromOffset(0, 120)
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

print("Luxury Dashboard Perfect Server Hop Loaded!")
