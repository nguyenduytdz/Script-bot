-- ==============================================================================
-- Project: CeboFinder Exact UI Clone (Standalone Edition)
-- Author: Kit_n67 | Custom Built for Boss Man
-- ==============================================================================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Xóa UI cũ nếu có
local Old = PlayerGui:FindFirstChild("CeboFinderExactUI")
if Old then Old:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "CeboFinderExactUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 999999
Gui.Parent = PlayerGui

-- Main Frame (Chuẩn tỷ lệ màu sắc như ảnh 2)[span_2](start_span)[span_2](end_span)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = Gui
MainFrame.Size = UDim2.fromOffset(740, 460)
MainFrame.Position = UDim2.new(0.5, -370, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 55)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Top Title Bar ("CeboFinder" + Trạng thái "Connected")
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 48)
TopBar.BackgroundTransparency = 1

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Parent = TopBar
TitleLbl.Size = UDim2.fromOffset(140, 48)
TitleLbl.Position = UDim2.fromOffset(16, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "CeboFinder"
TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLbl.TextSize = 16
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

local StatusDot = Instance.new("Frame")
StatusDot.Parent = TopBar
StatusDot.Size = UDim2.fromOffset(6, 6)
StatusDot.Position = UDim2.fromOffset(16, 33)
StatusDot.BackgroundColor3 = Color3.fromRGB(40, 200, 100)
local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = StatusDot

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Parent = TopBar
StatusLbl.Size = UDim2.fromOffset(100, 20)
StatusLbl.Position = UDim2.fromOffset(26, 25)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = "Connected"
StatusLbl.TextColor3 = Color3.fromRGB(140, 140, 155)
StatusLbl.TextSize = 11
StatusLbl.Font = Enum.Font.Gotham
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Sidebar Trái (Logs, History, Users, Settings, Hide)[span_3](start_span)[span_3](end_span)
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 160, 1, -48)
Sidebar.Position = UDim2.fromOffset(0, 48)
Sidebar.BackgroundColor3 = Color3.fromRGB(13, 13, 16)
Sidebar.BorderSizePixel = 0

local NavLayout = Instance.new("UIListLayout")
NavLayout.Parent = Sidebar
NavLayout.Padding = UDim.new(0, 6)
NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local function MakeNav(text, active)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 38)
    btn.BackgroundColor3 = active and Color3.fromRGB(35, 35, 45) or Color3.fromRGB(20, 20, 25)
    btn.Text = text
    btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 165)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.Parent = Sidebar
    return btn
end

-- Khoảng cách đệm phía trên danh mục Sidebar
local PaddingTop = Instance.new("UIPadding")
PaddingTop.PaddingTop = UDim.new(0, 10)
PaddingTop.Parent = Sidebar

local NavLogs = MakeNav("Logs", true)
local NavHistory = MakeNav("History", false)
local NavUsers = MakeNav("Users", false)
local NavSettings = MakeNav("Settings", false)

-- Nút "Hide" ở góc dưới cùng bên trái (Giống ảnh 2)[span_4](start_span)[span_4](end_span)
local HideBtn = Instance.new("TextButton")
HideBtn.Parent = Sidebar
HideBtn.Size = UDim2.new(1, -20, 0, 38)
HideBtn.Position = UDim2.new(0, 10, 1, -48)
HideBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
HideBtn.Text = "Hide"
HideBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
HideBtn.TextSize = 12
HideBtn.Font = Enum.Font.GothamBold
local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 6)
HideCorner.Parent = HideBtn

HideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Content Khu Vực Phải (Live Feed & Toggles)[span_5](start_span)[span_5](end_span)
local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.Size = UDim2.new(1, -160, 1, -48)
ContentArea.Position = UDim2.fromOffset(160, 48)
ContentArea.BackgroundTransparency = 1

-- Thanh Top Toggles ("Auto-Join" & "Auto-Force")[span_6](start_span)[span_6](end_span)
local ToggleBar = Instance.new("Frame")
ToggleBar.Parent = ContentArea
ToggleBar.Size = UDim2.new(1, -20, 0, 48)
ToggleBar.Position = UDim2.fromOffset(10, 12)
ToggleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBar

local function MakeToggle(posX, labelText)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = ToggleBar
    lbl.Size = UDim2.fromOffset(80, 48)
    lbl.Position = UDim2.fromOffset(posX, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(200, 200, 210)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    
    local pill = Instance.new("TextButton")
    pill.Parent = ToggleBar
    pill.Size = UDim2.fromOffset(40, 22)
    pill.Position = UDim2.fromOffset(posX + 85, 13)
    pill.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    pill.Text = ""
    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(1, 0)
    pCorner.Parent = pill
    
    local circle = Instance.new("Frame")
    circle.Parent = pill
    circle.Size = UDim2.fromOffset(16, 16)
    circle.Position = UDim2.fromOffset(3, 3)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = circle
    
    local state = false
    pill.MouseButton1Click:Connect(function()
        state = not state
        pill.BackgroundColor3 = state and Color3.fromRGB(140, 70, 255) or Color3.fromRGB(45, 45, 55)
        circle.Position = state and UDim2.fromOffset(21, 3) or UDim2.fromOffset(3, 3)
    end)
end

MakeToggle(15, "Auto-Join")
MakeToggle(190, "Auto-Force")

-- Header dòng chữ "LIVE FEED" và nút "Clear[span_7](start_span)"[span_7](end_span)
local FeedHeader = Instance.new("Frame")
FeedHeader.Parent = ContentArea
FeedHeader.Size = UDim2.new(1, -20, 0, 25)
FeedHeader.Position = UDim2.fromOffset(10, 68)
FeedHeader.BackgroundTransparency = 1

local LiveFeedLbl = Instance.new("TextLabel")
LiveFeedLbl.Parent = FeedHeader
LiveFeedLbl.Size = UDim2.fromOffset(100, 25)
LiveFeedLbl.Position = UDim2.fromOffset(0, 0)
LiveFeedLbl.BackgroundTransparency = 1
LiveFeedLbl.Text = "LIVE FEED"
LiveFeedLbl.TextColor3 = Color3.fromRGB(140, 140, 155)
LiveFeedLbl.TextSize = 10
LiveFeedLbl.Font = Enum.Font.GothamBold
LiveFeedLbl.TextXAlignment = Enum.TextXAlignment.Left

local DetectedCount = Instance.new("TextLabel")
DetectedCount.Parent = FeedHeader
DetectedCount.Size = UDim2.fromOffset(100, 25)
DetectedCount.Position = UDim2.fromOffset(320, 0)
DetectedCount.BackgroundTransparency = 1
DetectedCount.Text = "0 detected"
DetectedCount.TextColor3 = Color3.fromRGB(110, 110, 125)
DetectedCount.TextSize = 10
DetectedCount.Font = Enum.Font.Gotham
DetectedCount.TextXAlignment = Enum.TextXAlignment.Right

local ClearFeedBtn = Instance.new("TextButton")
ClearFeedBtn.Parent = FeedHeader
ClearFeedBtn.Size = UDim2.fromOffset(55, 22)
ClearFeedBtn.Position = UDim2.new(1, -55, 0, 0)
ClearFeedBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ClearFeedBtn.Text = "Clear"
ClearFeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearFeedBtn.TextSize = 10
ClearFeedBtn.Font = Enum.Font.GothamBold
local cfCorner = Instance.new("UICorner")
cfCorner.CornerRadius = UDim.new(0, 4)
cfCorner.Parent = ClearFeedBtn

-- Scrolling Frame chứa danh sách các dòng trứng spawn (Giống ảnh 2)[span_8](start_span)[span_8](end_span)
local FeedScroll = Instance.new("ScrollingFrame")
FeedScroll.Parent = ContentArea
FeedScroll.Size = UDim2.new(1, -20, 1, -102)
FeedScroll.Position = UDim2.fromOffset(10, 96)
FeedScroll.BackgroundTransparency = 1
FeedScroll.ScrollBarThickness = 3
FeedScroll.ScrollBarImageColor3 = Color3.fromRGB(140, 70, 255)

local FeedListLayout = Instance.new("UIListLayout")
FeedListLayout.Parent = FeedScroll
FeedListLayout.Padding = UDim.new(0, 8)

local count = 0

-- Hàm tạo các dòng Feed trứng spawn
local function AddEggFeed(eggName, moneyText)
    count += 1
    DetectedCount.Text = count .. " detected"
    
    local Card = Instance.new("Frame")
    Card.Parent = FeedScroll
    Card.Size = UDim2.new(1, -5, 0, 52)
    Card.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 8)
    cCorner.Parent = Card
    
    local cStroke = Instance.new("UIStroke")
    cStroke.Color = Color3.fromRGB(40, 40, 50)
    cStroke.Thickness = 1
    cStroke.Parent = Card
    
    -- Thanh màu dọc bên trái card (Đặc trưng CeboFinder ảnh 2)[span_9](start_span)[span_9](end_span)
    local Bar = Instance.new("Frame")
    Bar.Parent = Card
    Bar.Size = UDim2.new(0, 4, 1, -16)
    Bar.Position = UDim2.fromOffset(8, 8)
    Bar.BackgroundColor3 = Color3.fromRGB(140, 70, 255)
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(1, 0)
    bCorner.Parent = Bar
    
    -- Tên trứng & Giá tiền (Ví dụ: Starry Fox [ $18.4B/s ])[span_10](start_span)[span_10](end_span)
    local NameLbl = Instance.new("TextLabel")
    NameLbl.Parent = Card
    NameLbl.Size = UDim2.new(1, -180, 0, 22)
    NameLbl.Position = UDim2.fromOffset(22, 6)
    NameLbl.BackgroundTransparency = 1
    NameLbl.Text = eggName .. " [ " .. moneyText .. " ]"
    NameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLbl.TextSize = 13
    NameLbl.Font = Enum.Font.GothamBold
    NameLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Dòng phụ thời gian và loại Secret[span_11](start_span)[span_11](end_span)
    local InfoLbl = Instance.new("TextLabel")
    InfoLbl.Parent = Card
    InfoLbl.Size = UDim2.new(1, -180, 0, 18)
    InfoLbl.Position = UDim2.fromOffset(22, 26)
    InfoLbl.BackgroundTransparency = 1
    InfoLbl.Text = math.random(1,9) .. "/" .. math.random(1,9) .. " • 0:0" .. math.random(1,9) .. " • Secret"
    InfoLbl.TextColor3 = Color3.fromRGB(140, 140, 155)
    InfoLbl.TextSize = 11
    InfoLbl.Font = Enum.Font.Gotham
    InfoLbl.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Nút JOIN[span_12](start_span)[span_12](end_span)
    local JoinBtn = Instance.new("TextButton")
    JoinBtn.Parent = Card
    JoinBtn.Size = UDim2.fromOffset(65, 28)
    JoinBtn.Position = UDim2.new(1, -145, 0.5, -14)
    JoinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    JoinBtn.Text = "JOIN"
    JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    JoinBtn.TextSize = 11
    JoinBtn.Font = Enum.Font.GothamBold
    local jCorner = Instance.new("UICorner")
    jCorner.CornerRadius = UDim.new(0, 6)
    jCorner.Parent = JoinBtn
    
    JoinBtn.MouseButton1Click:Connect(function()
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
    end)
    
    -- Nút FORCE[span_13](start_span)[span_13](end_span)
    local ForceBtn = Instance.new("TextButton")
    ForceBtn.Parent = Card
    ForceBtn.Size = UDim2.fromOffset(65, 28)
    ForceBtn.Position = UDim2.new(1, -72, 0.5, -14)
    ForceBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    ForceBtn.Text = "FORCE"
    ForceBtn.TextColor3 = Color3.fromRGB(150, 150, 165)
    ForceBtn.TextSize = 11
    ForceBtn.Font = Enum.Font.GothamBold
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 6)
    fCorner.Parent = ForceBtn
    
    FeedScroll.CanvasPosition = Vector2.new(0, FeedScroll.AbsoluteCanvasSize.Y)
end

ClearFeedBtn.MouseButton1Click:Connect(function()
    for _, c in ipairs(FeedScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    count = 0
    DetectedCount.Text = "0 detected"
end)

-- 🤖 BẮT TỰ ĐỘNG THÔNG BÁO TRỨNG SPAWN TRÊN MÀN HÌNH (ẢNH 1)[span_14](start_span)[span_14](end_span)
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            for _, gui in ipairs(PlayerGui:GetDescendants()) do
                if gui:IsA("TextLabel") and gui.Visible and gui.Text ~= "" then
                    local txt = gui.Text
                    if string.find(txt, "Egg") and string.find(txt, "spawn") then
                        local mockMoney = string.format("$%.1fB/s", math.random(10, 280) / 10)
                        AddEggFeed(txt, mockMoney)
                        task.wait(6)
                    end
                end
            end
        end)
    end
end)

print("CeboFinder UI Clone Loaded Successfully!")
