--==================================================
-- SERVER HOP + FOLLOW | UI CẬP NHẬT ĐẦY ĐỦ YÊU CẦU
-- Tính năng: Avatar, Tên, FPS/ms, Tùy chỉnh màu, Kích thước, Kéo di chuyển, Nút ẩn/hiện
-- LocalScript | Roblox
--==================================================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRoot = Character:FindFirstChild("HumanoidRootPart")

local PlaceId = game.PlaceId
local JobId = game.JobId
local UniverseId = game:GetService("UniverseId")

--==================================================
-- CẤU HÌNH MẶC ĐỊNH — CÓ THỂ ĐỔI TRONG SETTINGS
--==================================================
local DEFAULT_COLORS = {
    BG = {17, 17, 22},
    SIDEBAR = {24, 24, 34},
    CARD = {32, 32, 45},
    HOVER = {45, 45, 65},
    ACCENT = {90, 140, 255},
    GREEN = {45, 180, 90},
    RED = {200, 60, 60},
    TEXT = {255, 255, 255},
    TEXT_MUTE = {160, 160, 180},
    BORDER = {50, 50, 70},
    FOLLOW_BTN = {45, 180, 90}
}

local SETTINGS = {
    Colors = {},
    MenuVisible = true,
    MenuSize = {W=720, H=460}
}

-- Load màu từ bảng
local function GetColor(name)
    local c = SETTINGS.Colors[name] or DEFAULT_COLORS[name]
    return Color3.fromRGB(c[1], c[2], c[3])
end

-- Khôi phục màu mặc định
local function ResetColors()
    for k,v in pairs(DEFAULT_COLORS) do
        SETTINGS.Colors[k] = {v[1], v[2], v[3]}
    end
end
ResetColors()

--==================================================
-- THÔNG BÁO
--==================================================
local function Notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 3})
    end)
end

--==================================================
-- XÓA GIAO DIỆN CŨ
--==================================================
if PlayerGui:FindFirstChild("MainPanelUI") then PlayerGui.MainPanelUI:Destroy() end
if PlayerGui:FindFirstChild("MenuToggleBtn") then PlayerGui.MenuToggleBtn:Destroy() end

--==================================================
-- KHUNG CHÍNH
--==================================================
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "MainPanelUI"
MainUI.ResetOnSpawn = false
MainUI.IgnoreGuiInset = true
MainUI.DisplayOrder = 999999
MainUI.Parent = PlayerGui

-- NÚT MỞ/TẮT MENU — KÉO ĐƯỢC
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "MenuToggleBtn"
ToggleBtn.Size = UDim2.fromOffset(50, 50)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.92, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
ToggleBtn.Text = "☰"
ToggleBtn.TextSize = 24
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Active = true
ToggleBtn.Parent = MainUI
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 12)
local TogStroke = Instance.new("UIStroke", ToggleBtn)
TogStroke.Color = Color3.fromRGB(90,140,255)
TogStroke.Thickness = 2

-- Kéo nút toggle
local DragToggle, DragTStart, DragTPos = false, nil, nil
ToggleBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        DragToggle = true; DragTStart = i.Position; DragTPos = ToggleBtn.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if not DragToggle then return end
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
        local d = i.Position - DragTStart
        ToggleBtn.Position = UDim2.new(0, DragTPos.X.Offset + d.X, 0, DragTPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then DragToggle = false end
end)

-- KHUNG CHÍNH
local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = UDim2.fromOffset(SETTINGS.MenuSize.W, SETTINGS.MenuSize.H)
Container.Position = UDim2.new(0.5, -SETTINGS.MenuSize.W/2, 0.5, -SETTINGS.MenuSize.H/2)
Container.BackgroundColor3 = GetColor("BG")
Container.Visible = SETTINGS.MenuVisible
Container.Active = true
Container.ClipsDescendants = true
Container.Parent = MainUI
Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 16)
local MainStroke = Instance.new("UIStroke", Container)
MainStroke.Color = GetColor("BORDER")
MainStroke.Thickness = 1.5

-- Ẩn/Hiện menu
ToggleBtn.MouseButton1Click:Connect(function()
    SETTINGS.MenuVisible = not SETTINGS.MenuVisible
    Container.Visible = SETTINGS.MenuVisible
    ToggleBtn.Text = SETTINGS.MenuVisible and "✖" or "☰"
end)

-- Kéo di chuyển menu
local DragMenu, DragMStart, DragMPos = false, nil, nil
Container.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        DragMenu = true; DragMStart = i.Position; DragMPos = Container.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if not DragMenu then return end
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
        local d = i.Position - DragMStart
        Container.Position = UDim2.new(0, math.max(0, math.min(1366, DragMPos.X.Offset + d.X)), 0, math.max(0, math.min(768, DragMPos.Y.Offset + d.Y)))
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then DragMenu = false end
end)

-- Thanh kéo thay đổi kích thước góc dưới phải
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.fromOffset(24, 24)
ResizeHandle.Position = UDim2.new(1, -24, 1, -24)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text = "⤢"
ResizeHandle.TextSize = 14
ResizeHandle.TextColor3 = GetColor("TEXT_MUTE")
ResizeHandle.Font = Enum.Font.GothamBold
ResizeHandle.Active = true
ResizeHandle.ZIndex = 100
ResizeHandle.Parent = Container

local Resizing = false
local MinW, MinH = 520, 340
ResizeHandle.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        Resizing = true; DragMStart = i.Position; DragMPos = Container.Size
    end
end)
UIS.InputChanged:Connect(function(i)
    if not Resizing then return end
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
        local d = i.Position - DragMStart
        local newW = math.max(MinW, DragMPos.X.Offset + d.X)
        local newH = math.max(MinH, DragMPos.Y.Offset + d.Y)
        Container.Size = UDim2.fromOffset(newW, newH)
        SETTINGS.MenuSize.W, SETTINGS.MenuSize.H = newW, newH
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Resizing = false end
end)

--==================================================
-- THANH BÊN TRÁI — SIDEBAR
--==================================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = GetColor("SIDEBAR")
Sidebar.Parent = Container

-- AVATAR + TÊN GÓC TRÊN
local UserInfoTop = Instance.new("Frame")
UserInfoTop.Size = UDim2.new(1, 0, 0, 85)
UserInfoTop.BackgroundTransparency = 1
UserInfoTop.Parent = Sidebar

-- Avatar hình tròn kiểu anime
local AvatarTop = Instance.new("ImageLabel")
AvatarTop.Size = UDim2.fromOffset(52, 52)
AvatarTop.Position = UDim2.fromOffset(10, 10)
AvatarTop.BackgroundTransparency = 1
AvatarTop.CornerRadius = UDim.new(1,0)
AvatarTop.Parent = UserInfoTop
pcall(function()
    local userId = LocalPlayer.UserId
    AvatarTop.Image = "https://users.roblox.com/v1/users/"..userId.."/avatar"
    AvatarTop.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..userId.."&width=150&height=150&format=png"
end)
local AvatStroke = Instance.new("UIStroke", AvatarTop)
AvatStroke.Color = GetColor("ACCENT")
AvatStroke.Thickness = 2

-- Tên hiển thị + tên tài khoản
local NameTop = Instance.new("TextLabel")
NameTop.Size = UDim2.new(1, -75, 1, 0)
NameTop.Position = UDim2.fromOffset(70, 5)
NameTop.BackgroundTransparency = 1
NameTop.Text = LocalPlayer.DisplayName.."\n@"..LocalPlayer.Name
NameTop.TextColor3 = GetColor("TEXT")
NameTop.TextSize = 14
NameTop.Font = Enum.Font.GothamBold
NameTop.TextXAlignment = Enum.TextXAlignment.Left
NameTop.LineHeight = 1.2
NameTop.Parent = UserInfoTop
local UsernameTop = Instance.new("TextLabel")
UsernameTop.Size = UDim2.new(1, 0, 0, 16)
UsernameTop.Position = UDim2.fromOffset(70, 38)
UsernameTop.BackgroundTransparency = 1
UsernameTop.Text = "@"..LocalPlayer.Name
UsernameTop.TextColor3 = GetColor("TEXT_MUTE")
UsernameTop.TextSize = 11
UsernameTop.Font = Enum.Font.Gotham
UsernameTop.TextXAlignment = Enum.TextXAlignment.Left
UsernameTop.Parent = UserInfoTop

-- NÚT ĐIỀU HƯỚNG
local Pages = {}
local SelectedPage = "Home"
local PageContainer = Instance.new("Frame")
PageContainer.Name = "PageContainer"
PageContainer.Size = UDim2.new(1, -180, 1, 0)
PageContainer.Position = UDim2.new(0, 180, 0, 0)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = Container

local function makeSideBtn(name, icon, pageId)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 42)
    Btn.Position = UDim2.fromOffset(10, 95 + (#Pages * 50))
    Btn.BackgroundTransparency = 1
    Btn.Text = "  "..icon.."  "..name
    Btn.TextColor3 = GetColor("TEXT_MUTE")
    Btn.TextSize = 14
    Btn.Font = Enum.Font.GothamBold
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = Sidebar

    Btn.MouseButton1Click:Connect(function()
        SelectedPage = pageId
        for _,p in pairs(Pages) do p.Visible = false end
        if Pages[pageId] then Pages[pageId].Visible = true end
    end)
    Pages[pageId] = Btn
    return Btn
end

makeSideBtn("Trang chủ", "🏠", "Home")
makeSideBtn("Server Hop", "🌐", "Servers")
makeSideBtn("Người chơi", "👥", "Players")
makeSideBtn("Theo dõi", "🎯", "Follow")
makeSideBtn("Cài đặt", "⚙️", "Settings")

-- Cập nhật trạng thái nút
local function UpdateBtnStyle()
    for id, btn in pairs(Pages) do
        btn.TextColor3 = (id == SelectedPage) and GetColor("ACCENT") or GetColor("TEXT_MUTE")
    end
end

--==================================================
-- TRANG HOME — FPS + MS
--==================================================
local HomePage = Instance.new("Frame")
HomePage.Name = "HomePage"
HomePage.Size = UDim2.new(1, 0, 1, 0)
HomePage.BackgroundTransparency = 1
HomePage.Visible = true
HomePage.Parent = PageContainer

local HomeTitle = Instance.new("TextLabel")
HomeTitle.Size = UDim2.new(1, -40, 0, 40)
HomeTitle.Position = UDim2.fromOffset(20, 15)
HomeTitle.BackgroundTransparency = 1
HomeTitle.Text = "🏠 TRANG CHỦ"
HomeTitle.TextColor3 = GetColor("TEXT")
HomeTitle.TextSize = 22
HomeTitle.Font = Enum.Font.GothamBold
HomeTitle.TextXAlignment = Enum.TextXAlignment.Left
HomeTitle.Parent = HomePage

-- FPS & Ping
local StatsFrame = Instance.new("Frame")
StatsFrame.Size = UDim2.new(1, -40, 0, 140)
StatsFrame.Position = UDim2.fromOffset(20, 70)
StatsFrame.BackgroundColor3 = GetColor("CARD")
Instance.new("UICorner", StatsFrame).CornerRadius = UDim.new(0, 12)
StatsFrame.Parent = HomePage

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(1, -30, 0, 50)
FPSLabel.Position = UDim2.fromOffset(15, 15)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "⚡ FPS: 0"
FPSLabel.TextColor3 = GetColor("GREEN")
FPSLabel.TextSize = 24
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
FPSLabel.Parent = StatsFrame

local PingLabel = Instance.new("TextLabel")
PingLabel.Size = UDim2.new(1, -30, 0, 50)
PingLabel.Position = UDim2.fromOffset(15, 75)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "📶 Ping: 0 ms"
PingLabel.TextColor3 = GetColor("ACCENT")
PingLabel.TextSize = 24
PingLabel.Font = Enum.Font.GothamBold
PingLabel.TextXAlignment = Enum.TextXAlignment.Left
PingLabel.Parent = StatsFrame

-- Cập nhật FPS & Ping
local LastTime, Frames = os.clock(), 0
RunService.Heartbeat:Connect(function()
    Frames += 1
    local Now = os.clock()
    if Now - LastTime >= 1 then
        local fps = Frames / (Now - LastTime)
        local ping = math.floor(NetworkClient:GetPing() * 1000 + 0.5)
        FPSLabel.Text = "⚡ FPS: "..math.floor(fps)
        PingLabel.Text = "📶 Ping: "..ping.." ms"
        FPSLabel.TextColor3 = fps >= 50 and GetColor("GREEN") or (fps >= 30 and Color3.fromRGB(220,180,40) or GetColor("RED"))
        LastTime, Frames = Now, 0
    end
end)

-- Avatar + Tên góc dưới cùng bên trái
local BottomUser = Instance.new("Frame")
BottomUser.Size = UDim2.new(1, 0, 0, 70)
BottomUser.Position = UDim2.new(0, 0, 1, -70)
BottomUser.BackgroundColor3 = GetColor("SIDEBAR")
BottomUser.Parent = Sidebar

local BottomAvatar = Instance.new("ImageLabel")
BottomAvatar.Size = UDim2.fromOffset(44, 44)
BottomAvatar.Position = UDim2.fromOffset(12, 13)
BottomAvatar.BackgroundTransparency = 1
BottomAvatar.CornerRadius = UDim.new(1,0)
BottomAvatar.Parent = BottomUser
pcall(function()
    BottomAvatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=150&height=150&format=png"
end)
local BotStroke = Instance.new("UIStroke", BottomAvatar)
BotStroke.Color = GetColor("ACCENT")
BotStroke.Thickness = 2

local BottomName = Instance.new("TextLabel")
BottomName.Size = UDim2.new(1, -70, 1, 0)
BottomName.Position = UDim2.fromOffset(65, 10)
BottomName.BackgroundTransparency = 1
BottomName.Text = LocalPlayer.DisplayName.."\n< "..LocalPlayer.Name.." >"
BottomName.TextColor3 = GetColor("TEXT")
BottomName.TextSize = 12
BottomName.Font = Enum.Font.GothamBold
BottomName.TextXAlignment = Enum.TextXAlignment.Left
BottomName.LineHeight = 1.3
BottomName.Parent = BottomUser

--==================================================
-- TRANG SETTINGS — TÙY CHỈNH MÀU
--==================================================
local SettingsPage = Instance.new("Frame")
SettingsPage.Name = "SettingsPage"
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.Parent = PageContainer
Pages["Settings"] = SettingsPage

local SetTitle = Instance.new("TextLabel")
SetTitle.Size = UDim2.new(1, -40, 0, 40)
SetTitle.Position = UDim2.fromOffset(20, 15)
SetTitle.BackgroundTransparency = 1
SetTitle.Text = "⚙️ CÀI ĐẶT & TÙY CHỈNH MÀU"
SetTitle.TextColor3 = GetColor("TEXT")
SetTitle.TextSize = 20
SetTitle.Font = Enum.Font.GothamBold
SetTitle.TextXAlignment = Enum.TextXAlignment.Left
SetTitle.Parent = SettingsPage

local SetScroll = Instance.new("ScrollingFrame")
SetScroll.Size = UDim2.new(1, -40, 1, -70)
SetScroll.Position = UDim2.fromOffset(20, 60)
SetScroll.BackgroundTransparency = 1
SetScroll.ScrollBarThickness = 4
SetScroll.ScrollBarImageColor3 = GetColor("ACCENT")
SetScroll.CanvasSize = UDim2.new()
SetScroll.Parent = SettingsPage

local SetLayout = Instance.new("UIListLayout")
SetLayout.Padding = UDim.new(0, 12)
SetLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SetLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SetScroll.CanvasSize = UDim2.new(0, 0, 0, SetLayout.AbsoluteContentSize.Y + 20)
end)
SetLayout.Parent = SetScroll

-- Tạo bộ chọn màu
local function MakeColorPicker(label, colorKey)
    local Item = Instance.new("Frame")
    Item.Size = UDim2.new(1, -10, 0, 55)
    Item.BackgroundColor3 = GetColor("CARD")
    Instance.new("UICorner", Item).CornerRadius = UDim.new(0, 10)
    Item.Parent = SetScroll

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -90, 1, 0)
    Lbl.Position = UDim2.fromOffset(15, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = label
    Lbl.TextColor3 = GetColor("TEXT")
    Lbl.TextSize = 14
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Item

    local Preview = Instance.new("TextButton")
    Preview.Size = UDim2.fromOffset(45, 45)
    Preview.Position = UDim2.new(1, -60, 0.5, -22)
    Preview.BackgroundColor3 = GetColor(colorKey)
    Instance.new("UICorner", Preview).CornerRadius = UDim.new(0, 8)
    Preview.Text = ""
    Preview.Parent = Item

    -- Tạo bộ chọn RGB đơn giản
    local function UpdateColor()
        Preview.BackgroundColor3 = GetColor(colorKey)
        -- Cập nhật toàn bộ UI
        Container.BackgroundColor3 = GetColor("BG")
        Sidebar.BackgroundColor3 = GetColor("SIDEBAR")
        StatsFrame.BackgroundColor3 = GetColor("CARD")
        for _, btn in pairs(Pages) do
            if btn:IsA("TextButton") then
                btn.TextColor3 = (btn.Name == SelectedPage) and GetColor("ACCENT") or GetColor("TEXT_MUTE")
            end
        end
        UpdateBtnStyle()
    end

    Preview.MouseButton1Click:Connect(function()
        -- Đổi màu ngẫu nhiên -> bạn có thể nhập số chính xác
        local r = math.random(30, 255)
        local g = math.random(30, 255)
        local b = math.random(30, 255)
        SETTINGS.Colors[colorKey] = {r, g, b}
        UpdateColor()
        Notify("🎨 Đổi màu", label.." đã cập nhật!")
    end)
end

MakeColorPicker("Nút Follow", "FOLLOW_BTN")
MakeColorPicker("Màu nhấn chính", "ACCENT")
MakeColorPicker("Nền chính", "BG")
MakeColorPicker("Thanh bên", "SIDEBAR")
MakeColorPicker("Thẻ khối", "CARD")
MakeColorPicker("Màu chữ chính", "TEXT")
MakeColorPicker("Màu chữ mờ", "TEXT_MUTE")

-- Nút khôi phục mặc định
local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(1, -10, 0, 45)
ResetBtn.BackgroundColor3 = GetColor("RED")
ResetBtn.Text = "🔄 Khôi phục màu mặc định"
ResetBtn.TextColor3 = Color3.new(1,1,1)
ResetBtn.TextSize = 14
ResetBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 10)
ResetBtn.Parent = SetScroll
ResetBtn.MouseButton1Click:Connect(function()
    ResetColors()
    Notify("✅ Đặt lại", "Đã khôi phục màu mặc định!")
end)

--==================================================
-- TRANG PLAYERS + FOLLOW
--==================================================
local PlayersPage = Instance.new("Frame")
PlayersPage.Name = "PlayersPage"
PlayersPage.Size = UDim2.new(1, 0, 1, 0)
PlayersPage.BackgroundTransparency = 1
PlayersPage.Visible = false
PlayersPage.Parent = PageContainer
Pages["Players"] = PlayersPage

local FollowPage = Instance.new("Frame")
FollowPage.Name = "FollowPage"
FollowPage.Size = UDim2.new(1, 0, 1, 0)
FollowPage.BackgroundTransparency = 1
FollowPage.Visible = false
FollowPage.Parent = PageContainer
Pages["Follow"] = FollowPage

local PlayersTitle = Instance.new("TextLabel")
PlayersTitle.Size = UDim2.new(1, -40, 0, 40)
PlayersTitle.Position = UDim2.fromOffset(20, 15)
PlayersTitle.BackgroundTransparency = 1
PlayersTitle.Text = "👥 DANH SÁCH NGƯỜI CHƠI"
PlayersTitle.TextColor3 = GetColor("TEXT")
PlayersTitle.TextSize = 20
PlayersTitle.Font = Enum.Font.GothamBold
PlayersTitle.TextXAlignment = Enum.TextXAlignment.Left
PlayersTitle.Parent = PlayersPage

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1, -40, 1, -70)
PlayerScroll.Position = UDim2.fromOffset(20, 60)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.ScrollBarThickness = 4
PlayerScroll.ScrollBarImageColor3 = GetColor("ACCENT")
PlayerScroll.CanvasSize = UDim2.new()
PlayerScroll.Parent = PlayersPage

local PlayerLayout = Instance.new("UIListLayout")
PlayerLayout.Padding = UDim.new(0, 8)
PlayerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, PlayerLayout.AbsoluteContentSize.Y + 15)
end)
PlayerLayout.Parent = PlayerScroll

-- Hệ thống Follow
local Following, FollowingPlayer = false, nil

local function StopFollowing()
    Following = false; FollowingPlayer = nil
    Notify("🛑 Đã dừng", "Không còn theo ai")
end

local function FollowPlayer(Target)
    if Target == LocalPlayer then return end
    FollowingPlayer = Target; Following = true
    Notify("🎯 Đang theo", Target.DisplayName)
end

RunService.Heartbeat:Connect(function()
    if not Following or not FollowingPlayer or not FollowingPlayer.Parent then
        if Following then StopFollowing() end
        return
    end
    local c = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local t = FollowingPlayer.Character and FollowingPlayer.Character:FindFirstChild("HumanoidRootPart")
    if c and t then
        c.CFrame = t.CFrame * CFrame.new(0,0,FOLLOW_DISTANCE)
    end
end)

-- Thêm người chơi
local function AddPlayer(Target)
    if Target == LocalPlayer then return end
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -5, 0, 55)
    Row.BackgroundColor3 = GetColor("CARD")
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 10)
    Row.Parent = PlayerScroll

    local Av = Instance.new("ImageLabel")
    Av.Size = UDim2.fromOffset(38, 38)
    Av.Position = UDim2.fromOffset(10, 8)
    Av.BackgroundTransparency = 1
    Av.CornerRadius = UDim.new(1,0)
    pcall(function() Av.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..Target.UserId.."&width=100&height=100&format=png" end)
    Av.Parent = Row

    local Nm = Instance.new("TextLabel")
    Nm.Size = UDim2.new(1, -110, 1, 0)
    Nm.Position = UDim2.fromOffset(58, 5)
    Nm.BackgroundTransparency = 1
    Nm.Text = Target.DisplayName.."\n@"..Target.Name
    Nm.TextColor3 = GetColor("TEXT")
    Nm.TextSize = 13
    Nm.Font = Enum.Font.GothamBold
    Nm.TextXAlignment = Enum.TextXAlignment.Left
    Nm.LineHeight = 1.2
    Nm.Parent = Row

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.fromOffset(75, 36)
    Btn.Position = UDim2.new(1, -85, 0.5, -18)
    Btn.BackgroundColor3 = GetColor("FOLLOW_BTN")
    Btn.Text = "🟢 FOLLOW"
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.TextSize = 12
    Btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    Btn.Parent = Row

    Btn.MouseButton1Click:Connect(function() FollowPlayer(Target) end)

    Target.AncestryChanged:Connect(function(_,p)
        if not p then
            if FollowingPlayer == Target then StopFollowing() end
            Row:Destroy()
        end
    end)
end

local function RefreshPlayers()
    for _,c in ipairs(PlayerScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    for _,pl in ipairs(Players:GetPlayers()) do AddPlayer(pl) end
end
Players.PlayerAdded:Connect(function() task.wait(0.2) RefreshPlayers() end)
Players.PlayerRemoving:Connect(function(t) if FollowingPlayer == t then StopFollowing() end task.wait(0.1) RefreshPlayers() end)
RefreshPlayers()

--==================================================
-- TRANG SERVER HOP
--==================================================
local ServersPage = Instance.new("Frame")
ServersPage.Name = "ServersPage"
ServersPage.Size = UDim2.new(1, 0, 1, 0)
ServersPage.BackgroundTransparency = 1
ServersPage.Visible = false
ServersPage.Parent = PageContainer
Pages["Servers"] = ServersPage

local SvrTitle = Instance.new("TextLabel")
SvrTitle.Size = UDim2.new(1, -40, 0, 40)
SvrTitle.Position = UDim2.fromOffset(20, 15)
SvrTitle.BackgroundTransparency = 1
SvrTitle.Text = "🌐 TÌM SERVER ÍT NGƯỜI"
SvrTitle.TextColor3 = GetColor("TEXT")
SvrTitle.TextSize = 20
SvrTitle.Font = Enum.Font.GothamBold
SvrTitle.TextXAlignment = Enum.TextXAlignment.Left
SvrTitle.Parent = ServersPage

local FindBtn = Instance.new("TextButton")
FindBtn.Size = UDim2.new(1, -40, 0, 48)
FindBtn.Position = UDim2.fromOffset(20, 65)
FindBtn.BackgroundColor3 = GetColor("ACCENT")
FindBtn.Text = "🔍 TÌM SERVER ÍT NGƯỜI"
FindBtn.TextColor3 = Color3.new(1,1,1)
FindBtn.TextSize = 15
FindBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", FindBtn).CornerRadius = UDim.new(0, 10)
FindBtn.Parent = ServersPage

local SvrStatus = Instance.new("TextLabel")
SvrStatus.Size = UDim2.new(1, -40, 0, 25)
SvrStatus.Position = UDim2.fromOffset(20, 120)
SvrStatus.BackgroundTransparency = 1
SvrStatus.Text = "⚪ Chưa tìm server"
SvrStatus.TextColor3 = GetColor("TEXT_MUTE")
SvrStatus.TextSize = 12
SvrStatus.Font = Enum.Font.Gotham
SvrStatus.TextXAlignment = Enum.TextXAlignment.Left
SvrStatus.Parent = ServersPage

local SvrScroll = Instance.new("ScrollingFrame")
SvrScroll.Size = UDim2.new(1, -40, 1, -160)
SvrScroll.Position = UDim2.fromOffset(20, 150)
SvrScroll.BackgroundTransparency = 1
SvrScroll.ScrollBarThickness = 4
SvrScroll.ScrollBarImageColor3 = GetColor("ACCENT")
SvrScroll.CanvasSize = UDim2.new()
SvrScroll.Parent = ServersPage

local SvrLayout = Instance.new("UIListLayout")
SvrLayout.Padding = UDim.new(0, 8)
SvrLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SvrScroll.CanvasSize = UDim2.new(0, 0, 0, SvrLayout.AbsoluteContentSize.Y + 15)
end)
SvrLayout.Parent = SvrScroll

-- Lấy danh sách server
local function GetServers()
    local Results, Cursor = {}, nil
    for Page = 1, MAX_PAGES do
        local URL = "https://games.roblox.com/v1/games/"..UniverseId.."/servers/Public?sortOrder=Asc&limit=100"
        if Cursor then URL ..= "&cursor="..HttpService:UrlEncode(Cursor) end

        local Success, Resp = pcall(function() return game:HttpGet(URL) end)
        if not Success then break end

        local Data
        local Decode = pcall(function() Data = HttpService:JSONDecode(Resp) end)
        if not Decode or not Data or not Data.data then break end

        for _,s in ipairs(Data.data) do
            local p = tonumber(s.playing) or 0
            if p <= MAX_SERVER_PLAYERS and s.id ~= JobId then table.insert(Results, s) end
        end
        Cursor = Data.nextPageCursor; if not Cursor then break end
        task.wait(0.15)
    end
    table.sort(Results, function(a,b) return (tonumber(a.playing) or 999) < (tonumber(b.playing) or 999) end)
    return Results
end

local Searching = false
FindBtn.MouseButton1Click:Connect(function()
    if Searching then return end
    Searching = true; FindBtn.Text = "⏳ ĐANG TÌM..."; FindBtn.Active = false
    SvrStatus.Text = "🔎 Đang quét..."
    for _,c in ipairs(SvrScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end

    task.spawn(function()
        local list = GetServers()
        if #list == 0 then
            SvrStatus.Text = "❌ Không tìm thấy server phù hợp"
        else
            SvrStatus.Text = "🟢 Tìm thấy "..#list.." server — Ít nhất: "..(tonumber(list[1].playing) or "?").." người"
            for _,sv in ipairs(list) do
                local p = tonumber(sv.playing) or 0
                local Row = Instance.new("Frame")
                Row.Size = UDim2.new(1, -5, 0, 55)
                Row.BackgroundColor3 = GetColor("CARD")
                Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 10)
                Row.Parent = SvrScroll

                local Info = Instance.new("TextLabel")
                Info.Size = UDim2.new(1, -85, 1, 0)
                Info.Position = UDim2.fromOffset(15, 5)
                Info.BackgroundTransparency = 1
                Info.Text = "👤 "..p.." / "..sv.maxPlayers.."\n🆔 "..string.sub(sv.id,1,12).."..."
                Info.TextColor3 = GetColor("TEXT")
                Info.TextSize = 13
                Info.Font = Enum.Font.GothamBold
                Info.TextXAlignment = Enum.TextXAlignment.Left
                Info.LineHeight = 1.2
                Info.Parent = Row

                local JoinBtn = Instance.new("TextButton")
                JoinBtn.Size = UDim2.fromOffset(65, 38)
                JoinBtn.Position = UDim2.new(1, -75, 0.5, -19)
                JoinBtn.BackgroundColor3 = GetColor("GREEN")
                JoinBtn.Text = "🚀 VÀO"
                JoinBtn.TextColor3 = Color3.new(1,1,1)
                JoinBtn.TextSize = 12
                JoinBtn.Font = Enum.Font.GothamBold
                Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 8)
                JoinBtn.Parent = Row

                JoinBtn.MouseButton1Click:Connect(function()
                    Notify("🚀 Đang chuyển server", "Đang vào server mới...")
                    pcall(function() TeleportService:TeleportToPlaceInstance(PlaceId, sv.id, LocalPlayer) end)
                end)
                task.wait(0.02)
            end
        end
        Searching = false; FindBtn.Text = "🔄 TÌM LẠI SERVER"; FindBtn.Active = true
    end)
end)

-- Cập nhật trạng thái trang khi chuyển
local function SyncPage()
    UpdateBtnStyle()
    for id,p in pairs(Pages) do
        if type(p)=="table" and p.Visible ~= nil then
            p.Visible = (id == SelectedPage)
        end
    end
end
for id in pairs(Pages) do
    if Pages[id] and Pages[id].MouseButton1Click then
        local orig = Pages[id].MouseButton1Click
        Pages[id].MouseButton1Click:Connect(SyncPage)
    end
end
-- Gán ban đầu
Pages["Home"].Visible = true; Pages["Servers"].Visible = false; Pages["Players"].Visible = false; Pages["Follow"].Visible = false; Pages["Settings"].Visible = false
UpdateBtnStyle()

--==================================================
-- BẮT ĐẦU
--==================================================
Notify("✅ Đã tải", "Menu đã sẵn sàng! Bấm ☰ để ẩn/hiện")
print("✅ Menu Loaded — Avatar + FPS + Tùy chỉnh màu")
