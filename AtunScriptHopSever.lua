-- ==============================================================================
-- Project: Luxury Dashboard UI (8 TABS + FULL SERVER HOP HUB)
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
    Reason = "Đang tối ưu bảo trì..."
}

local CONFIG = {
    Theme = "Purple",
    MenuWidth = 760,
    MenuHeight = 500,
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
-- 📱 DYNAMIC ISLAND (IPHONE DESIGN)
-- ==========================================================
local DynamicIsland = Instance.new("TextButton")
DynamicIsland.Name = "AppleDynamicIsland"
DynamicIsland.Parent = Gui
DynamicIsland.Size = UDim2.fromOffset(230, 40)
DynamicIsland.Position = UDim2.new(0.5, -115, 0, 10)
DynamicIsland.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DynamicIsland.BorderSizePixel = 0
DynamicIsland.AutoButtonColor = false
DynamicIsland.Text = ""
DynamicIsland.ClipsDescendants = true
Corner(DynamicIsland, 20)
Stroke(DynamicIsland, Color3.fromRGB(45, 45, 60), 1.5, 0.3)

local CameraLens = Instance.new("Frame")
CameraLens.Parent = DynamicIsland
CameraLens.Size = UDim2.fromOffset(12, 12)
CameraLens.Position = UDim2.fromOffset(14, 14)
CameraLens.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
Corner(CameraLens, 6)

local ClockLabel = Instance.new("TextLabel")
ClockLabel.Parent = DynamicIsland
ClockLabel.Size = UDim2.fromOffset(60, 40)
ClockLabel.Position = UDim2.new(1, -65, 0, 0)
ClockLabel.BackgroundTransparency = 1
ClockLabel.Text = "00:00"
ClockLabel.TextColor3 = Accent
ClockLabel.TextSize = 12
ClockLabel.Font = Enum.Font.GothamBold

-- THANH STATUS BÊN DƯỚI DYNAMIC ISLAND
local StatusContainer = Instance.new("Frame")
StatusContainer.Name = "StatusContainer"
StatusContainer.Parent = Gui
StatusContainer.Size = UDim2.fromOffset(340, 30)
StatusContainer.Position = UDim2.new(0.5, -170, 0, 55)
StatusContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Corner(StatusContainer, 10)
Stroke(StatusContainer, Accent, 1, 0.4)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = StatusContainer
StatusLabel.Size = UDim2.new(1, -20, 1, 0)
StatusLabel.Position = UDim2.fromOffset(10, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Hệ thống Server Hop đã sẵn sàng!"
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

-- ==========================================================
-- MENU CHÍNH
-- ==========================================================
local function StartMainDashboard()
    SetStatus("Đang ở Dashboard Overview")

    local Icon = Instance.new("ImageButton")
    Icon.Name = "MenuIcon"
    Icon.Parent = Gui
    Icon.Size = UDim2.fromOffset(50, 50)
    Icon.Position = UDim2.new(0, 20, 0.5, -25)
    Icon.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    Icon.Image = "rbxthumb://type=Asset&id=113875514885319&w=150&h=150"
    Corner(Icon, 25)
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
    MakeTopBtn(32, "🗖", function() Menu.Size = (Menu.Size.X.Offset == 760) and UDim2.fromOffset(900, 560) or UDim2.fromOffset(760, 500) end)
    MakeTopBtn(64, "×", function() Menu.Visible = false Icon.Visible = false SetStatus("Đã tắt Menu") end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = Menu
    Sidebar.Size = UDim2.new(0, 190, 1, 0)
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
        Page.Size = UDim2.new(1, -210, 1, -20)
        Page.Position = UDim2.fromOffset(200, 10)
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
        TextPadding.PaddingLeft = UDim.new(0, 12)
        TextPadding.Parent = Button

        Corner(Button, 8)
        NavButtons[PageName] = Button
        return Button
    end

    -- DANH SÁCH TAB
    local HomePage = MakePage("Home")
    local UtilityPage = MakePage("Utility")
    local AntiAfkPage = MakePage("AntiAfk")
    local EspPage = MakePage("Esp")
    local PosPage = MakePage("Positions")
    local ServerPage = MakePage("Server")
    local ScriptHubPage = MakePage("ScriptHub")
    local SettingsPage = MakePage("Settings")

    local HomeNav = MakeNav("🏠  Dashboard", "Home")
    local UtilityNav = MakeNav("⚡  Speed Utilities", "Utility")
    local AntiAfkNav = MakeNav("🛡️  Anti-AFK System", "AntiAfk")
    local EspNav = MakeNav("👁️  ESP Wallhack", "Esp")
    local PosNav = MakeNav("📍  Waypoints", "Positions")
    local ServerNav = MakeNav("🌐  Server Hop Hub", "Server")
    local ScriptHubNav = MakeNav("📁  Script Hub", "ScriptHub")
    local SettingsNav = MakeNav("⚙️  Settings", "Settings")

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

    -- 1. HOME TAB
    PageTitle(HomePage, "Dashboard Overview", "Thống kê hệ thống")
    local FPSValue = Instance.new("TextLabel")
    FPSValue.Parent = HomePage
    FPSValue.Size = UDim2.fromOffset(160, 60)
    FPSValue.Position = UDim2.fromOffset(5, 55)
    FPSValue.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    FPSValue.Text = "FPS: --"
    FPSValue.TextColor3 = Accent
    FPSValue.Font = Enum.Font.GothamBold
    Corner(FPSValue, 10)

    -- 2. UTILITY TAB
    PageTitle(UtilityPage, "Speed Utilities", "Tốc độ di chuyển Safe Mode")
    local SpeedInp = Instance.new("TextBox")
    SpeedInp.Parent = UtilityPage
    SpeedInp.Size = UDim2.new(1, -10, 0, 36)
    SpeedInp.Position = UDim2.fromOffset(5, 55)
    SpeedInp.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    SpeedInp.PlaceholderText = "Nhập WalkSpeed (Mặc định: 16)..."
    SpeedInp.Text = "16"
    SpeedInp.TextColor3 = Accent
    SpeedInp.Font = Enum.Font.GothamBold
    Corner(SpeedInp, 8)

    SpeedInp.FocusLost:Connect(function()
        local n = tonumber(SpeedInp.Text)
        if n and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = n
            SetStatus("Thay đổi WalkSpeed: " .. n)
        end
    end)

    -- 3. ANTI-AFK TAB
    PageTitle(AntiAfkPage, "Anti-AFK System", "Bảo vệ treo game 24/7")
    local AfkBtn = Instance.new("TextButton")
    AfkBtn.Parent = AntiAfkPage
    AfkBtn.Size = UDim2.new(1, -10, 0, 40)
    AfkBtn.Position = UDim2.fromOffset(5, 55)
    AfkBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
    AfkBtn.Text = "🛡️ ANTI-AFK: DANG BẬT BẢO VỆ"
    AfkBtn.TextColor3 = Color3.new(1, 1, 1)
    AfkBtn.Font = Enum.Font.GothamBold
    Corner(AfkBtn, 8)

    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)

    -- 4. ESP TAB
    PageTitle(EspPage, "ESP Wallhack", "Nhìn vị trí người chơi xuyên tường")
    local EspEnabled = false
    local EspBtn = Instance.new("TextButton")
    EspBtn.Parent = EspPage
    EspBtn.Size = UDim2.new(1, -10, 0, 40)
    EspBtn.Position = UDim2.fromOffset(5, 55)
    EspBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    EspBtn.Text = "👁️ ESP PLAYER HIGHLIGHT: OFF"
    EspBtn.TextColor3 = Color3.new(1, 1, 1)
    EspBtn.Font = Enum.Font.GothamBold
    Corner(EspBtn, 8)

    EspBtn.MouseButton1Click:Connect(function()
        EspEnabled = not EspEnabled
        EspBtn.Text = EspEnabled and "👁️ ESP PLAYER HIGHLIGHT: ON" or "👁️ ESP PLAYER HIGHLIGHT: OFF"
        EspBtn.BackgroundColor3 = EspEnabled and Accent or Color3.fromRGB(35, 35, 45)
        SetStatus(EspEnabled and "Đã bật ESP xuyên tường" or "Đã tắt ESP")
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

    -- 5. WAYPOINTS TAB
    PageTitle(PosPage, "Teleport Waypoints", "Lưu tọa độ mong muốn")
    local SavedCFrame = nil
    local SaveBtn = Instance.new("TextButton")
    SaveBtn.Parent = PosPage
    SaveBtn.Size = UDim2.new(0.48, 0, 0, 36)
    SaveBtn.Position = UDim2.fromOffset(5, 55)
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

    -- 6. TAB SERVER HOP CHUẨN ĐẦY ĐỦ (PING THẤP / 1 NGƯỜI / TREO CỦ)
    PageTitle(ServerPage, "Server Hop Hub", "Quét tìm server ít người, ping thấp hoặc treo cũ")

    local FindLowPing = Instance.new("TextButton")
    FindLowPing.Parent = ServerPage
    FindLowPing.Size = UDim2.new(0.31, 0, 0, 34)
    FindLowPing.Position = UDim2.fromOffset(5, 52)
    FindLowPing.BackgroundColor3 = Color3.fromRGB(40, 180, 90)
    FindLowPing.Text = "⚡ PING THẤP"
    FindLowPing.TextColor3 = Color3.new(1, 1, 1)
    FindLowPing.Font = Enum.Font.GothamBold
    Corner(FindLowPing, 8)

    local Find1Player = Instance.new("TextButton")
    Find1Player.Parent = ServerPage
    Find1Player.Size = UDim2.new(0.32, 0, 0, 34)
    Find1Player.Position = UDim2.new(0.34, 5, 0, 52)
    Find1Player.BackgroundColor3 = Accent
    Find1Player.Text = "🔍 1 NGƯỜI"
    Find1Player.TextColor3 = Color3.new(1, 1, 1)
    Find1Player.Font = Enum.Font.GothamBold
    Corner(Find1Player, 8)

    local FindOldServer = Instance.new("TextButton")
    FindOldServer.Parent = ServerPage
    FindOldServer.Size = UDim2.new(0.31, 0, 0, 34)
    FindOldServer.Position = UDim2.new(0.68, 5, 0, 52)
    FindOldServer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    FindOldServer.Text = "⏳ TREO CỦ"
    FindOldServer.TextColor3 = Color3.fromRGB(200, 200, 210)
    FindOldServer.Font = Enum.Font.GothamBold
    Corner(FindOldServer, 8)

    local JobContainer = Instance.new("Frame")
    JobContainer.Parent = ServerPage
    JobContainer.Size = UDim2.new(1, -10, 0, 36)
    JobContainer.Position = UDim2.fromOffset(5, 92)
    JobContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Corner(JobContainer, 8)

    local JobInp = Instance.new("TextBox")
    JobInp.Parent = JobContainer
    JobInp.Size = UDim2.new(1, -125, 1, 0)
    JobInp.Position = UDim2.fromOffset(10, 0)
    JobInp.BackgroundTransparency = 1
    JobInp.PlaceholderText = "Dán mã Job ID server vào đây..."
    JobInp.Text = ""
    JobInp.TextColor3 = Color3.new(1, 1, 1)
    JobInp.Font = Enum.Font.Gotham

    local JoinJobBtn = Instance.new("TextButton")
    JoinJobBtn.Parent = JobContainer
    JoinJobBtn.Size = UDim2.fromOffset(110, 26)
    JoinJobBtn.Position = UDim2.new(1, -115, 0.5, -13)
    JoinJobBtn.BackgroundColor3 = Accent
    JoinJobBtn.Text = "🚀 JOIN JOB ID"
    JoinJobBtn.TextColor3 = Color3.new(1, 1, 1)
    JoinJobBtn.Font = Enum.Font.GothamBold
    Corner(JoinJobBtn, 6)

    JoinJobBtn.MouseButton1Click:Connect(function()
        local targetJob = JobInp.Text:gsub("%s+", "")
        if targetJob ~= "" then
            SetStatus("Đang chuyển tới Job ID...")
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetJob, LocalPlayer)
        end
    end)

    local ServerList = Instance.new("ScrollingFrame")
    ServerList.Parent = ServerPage
    ServerList.Size = UDim2.new(1, -10, 1, -135)
    ServerList.Position = UDim2.fromOffset(5, 132)
    ServerList.BackgroundTransparency = 1
    ServerList.ScrollBarThickness = 3
    ServerList.ScrollBarImageColor3 = Accent

    local ServerLayout = Instance.new("UIListLayout")
    ServerLayout.Parent = ServerList
    ServerLayout.Padding = UDim.new(0, 6)

    local function FetchServers(Cursor)
        local URL = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        if Cursor then URL = URL .. "&cursor=" .. HttpService:UrlEncode(Cursor) end
        local Success, Response = pcall(function() return game:HttpGet(URL) end)
        if not Success or not Response then return nil end
        local DecodeSuccess, Data = pcall(function() return HttpService:JSONDecode(Response) end)
        return DecodeSuccess and Data or nil
    end

    local function ScanAndDisplayServers(mode)
        SetStatus("Đang quét tìm danh sách Server...")
        for _, v in ipairs(ServerList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end

        task.spawn(function()
            local Cursor, PagesScanned = nil, 0
            while PagesScanned < 5 do
                PagesScanned += 1
                local Data = FetchServers(Cursor)
                if not Data or not Data.data then break end

                for i, Server in ipairs(Data.data) do
                    local Playing = tonumber(Server.playing) or 999
                    if Server.id ~= game.JobId and Playing > 0 then
                        if (mode == "1player" and Playing == 1) or (mode == "old" and Playing <= 3) or (mode == "lowping") then
                            local Row = Instance.new("Frame")
                            Row.Parent = ServerList
                            Row.Size = UDim2.new(1, -5, 0, 42)
                            Row.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
                            Corner(Row, 8)

                            local Info = Instance.new("TextLabel")
                            Info.Parent = Row
                            Info.Size = UDim2.new(1, -80, 1, 0)
                            Info.Position = UDim2.fromOffset(10, 0)
                            Info.BackgroundTransparency = 1
                            Info.Text = "SERVER (" .. Playing .. " Người) - Ping Thấp"
                            Info.TextColor3 = Color3.new(1, 1, 1)
                            Info.Font = Enum.Font.GothamMedium
                            Info.TextXAlignment = Enum.TextXAlignment.Left

                            local Join = Instance.new("TextButton")
                            Join.Parent = Row
                            Join.Size = UDim2.fromOffset(60, 28)
                            Join.Position = UDim2.new(1, -65, 0.5, -14)
                            Join.BackgroundColor3 = Accent
                            Join.Text = "🚀 JOIN"
                            Join.TextColor3 = Color3.new(1, 1, 1)
                            Join.Font = Enum.Font.GothamBold
                            Corner(Join, 6)

                            Join.MouseButton1Click:Connect(function()
                                SetStatus("Đang dịch chuyển tới Server...")
                                TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, LocalPlayer)
                            end)
                        end
                    end
                end
                Cursor = Data.nextPageCursor
                if not Cursor then break end
                task.wait(0.05)
            end
            SetStatus("✓ Đã tải xong danh sách Server!")
        end)
    end

    FindLowPing.MouseButton1Click:Connect(function() ScanAndDisplayServers("lowping") end)
    Find1Player.MouseButton1Click:Connect(function() ScanAndDisplayServers("1player") end)
    FindOldServer.MouseButton1Click:Connect(function() ScanAndDisplayServers("old") end)

    -- 7. SCRIPT HUB TAB
    PageTitle(ScriptHubPage, "Script Hub Library", "Khởi chạy script hỗ trợ")
    local IyBtn = Instance.new("TextButton")
    IyBtn.Parent = ScriptHubPage
    IyBtn.Size = UDim2.new(1, -10, 0, 40)
    IyBtn.Position = UDim2.fromOffset(5, 55)
    IyBtn.BackgroundColor3 = Accent
    IyBtn.Text = "⚡ RUN INFINITE YIELD ADMIN"
    IyBtn.TextColor3 = Color3.new(1, 1, 1)
    IyBtn.Font = Enum.Font.GothamBold
    Corner(IyBtn, 8)

    IyBtn.MouseButton1Click:Connect(function()
        SetStatus("Đang tải Infinite Yield Admin...")
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end)

    -- 8. SETTINGS TAB
    PageTitle(SettingsPage, "Settings & Info", "Thông tin tác giả Kit_n67")

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
    UtilityNav.MouseButton1Click:Connect(function() ShowPage("Utility") end)
    AntiAfkNav.MouseButton1Click:Connect(function() ShowPage("AntiAfk") end)
    EspNav.MouseButton1Click:Connect(function() ShowPage("Esp") end)
    PosNav.MouseButton1Click:Connect(function() ShowPage("Positions") end)
    ServerNav.MouseButton1Click:Connect(function() ShowPage("Server") end)
    ScriptHubNav.MouseButton1Click:Connect(function() ShowPage("ScriptHub") end)
    SettingsNav.MouseButton1Click:Connect(function() ShowPage("Settings") end)

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

-- ==========================================================
-- BẢO TRÌ SYSTEM
-- ==========================================================
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

print("Luxury Hop Hub Loaded!")
