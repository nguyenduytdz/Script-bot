-- ==========================================
-- VENYX STYLE UI TEMPLATE (ROUNDED & EMPTY TABS)
-- ==========================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if game.CoreGui:FindFirstChild("VenyxRoundedUI") then
    game.CoreGui.VenyxRoundedUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VenyxRoundedUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- ==========================================
-- 1. KHUNG CHÍNH BO GÓC LỚN (GIỐNG ẢNH)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(23, 24, 27)
MainFrame.Position = UDim2.new(0.5, -390, 0.5, -215)
MainFrame.Size = UDim2.new(0, 780, 0, 430)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 20)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(58, 60, 66)
MainStroke.Thickness = 1.5

-- Nút mở lại khi thu nhỏ
local RestoreBtn = Instance.new("TextButton")
RestoreBtn.Name = "RestoreBtn"
RestoreBtn.Parent = ScreenGui
RestoreBtn.BackgroundColor3 = Color3.fromRGB(28, 29, 33)
RestoreBtn.Position = UDim2.new(0.04, 0, 0.2, 0)
RestoreBtn.Size = UDim2.new(0, 46, 0, 46)
RestoreBtn.Font = Enum.Font.GothamBlack
RestoreBtn.Text = "Vx"
RestoreBtn.TextColor3 = Color3.fromRGB(245, 245, 245)
RestoreBtn.TextSize = 15
RestoreBtn.Visible = false
RestoreBtn.Active = true
RestoreBtn.Draggable = true
Instance.new("UICorner", RestoreBtn).CornerRadius = UDim.new(1, 0)
local RestoreStroke = Instance.new("UIStroke", RestoreBtn)
RestoreStroke.Color = Color3.fromRGB(72, 75, 82)
RestoreStroke.Thickness = 1.3

-- ==========================================
-- 2. THANH TIÊU ĐỀ (TOPBAR)
-- ==========================================
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(33, 34, 38)
TopBar.BorderSizePixel = 0
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.ClipsDescendants = true

-- Bo góc trên trùng với MainFrame để không bị lòi góc nhọn
local TopCorner = Instance.new("UICorner", TopBar)
TopCorner.CornerRadius = UDim.new(0, 20)

-- Che phần bo góc dưới của TopBar
local TopBottomMask = Instance.new("Frame")
TopBottomMask.Parent = TopBar
TopBottomMask.BackgroundColor3 = Color3.fromRGB(33, 34, 38)
TopBottomMask.BorderSizePixel = 0
TopBottomMask.Position = UDim2.new(0, 0, 1, -20)
TopBottomMask.Size = UDim2.new(1, 0, 0, 20)

local TopDivider = Instance.new("Frame")
TopDivider.Parent = TopBar
TopDivider.BackgroundColor3 = Color3.fromRGB(48, 50, 56)
TopDivider.BorderSizePixel = 0
TopDivider.Position = UDim2.new(0, 0, 1, -1)
TopDivider.Size = UDim2.new(1, 0, 0, 1)

-- Logo V x
local LogoLabel = Instance.new("TextLabel")
LogoLabel.Parent = TopBar
LogoLabel.BackgroundTransparency = 1
LogoLabel.Position = UDim2.new(0, 18, 0, 0)
LogoLabel.Size = UDim2.new(0, 28, 1, 0)
LogoLabel.Font = Enum.Font.GothamBlack
LogoLabel.Text = "Vₓ"
LogoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoLabel.TextSize = 21

-- Tên Hub + Game
local BrandLabel = Instance.new("TextLabel")
BrandLabel.Parent = TopBar
BrandLabel.BackgroundTransparency = 1
BrandLabel.Position = UDim2.new(0, 54, 0, 0)
BrandLabel.Size = UDim2.new(0, 230, 1, 0)
BrandLabel.Font = Enum.Font.GothamBold
BrandLabel.RichText = true
BrandLabel.Text = 'VENYX  <font color="#6E7178">/</font>  <font color="#C2C6CE" size="13">Tên Game Của Bạn</font>'
BrandLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BrandLabel.TextSize = 16
BrandLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Badge phiên bản v1.2.4
local VersionBadge = Instance.new("TextLabel")
VersionBadge.Parent = TopBar
VersionBadge.BackgroundColor3 = Color3.fromRGB(46, 48, 53)
VersionBadge.Position = UDim2.new(0, 286, 0.5, -10)
VersionBadge.Size = UDim2.new(0, 48, 0, 20)
VersionBadge.Font = Enum.Font.GothamMedium
VersionBadge.Text = "v1.2.4"
VersionBadge.TextColor3 = Color3.fromRGB(190, 193, 200)
VersionBadge.TextSize = 11
Instance.new("UICorner", VersionBadge).CornerRadius = UDim.new(1, 0)

-- Badge trạng thái • Idle
local StatusBadge = Instance.new("Frame")
StatusBadge.Parent = TopBar
StatusBadge.BackgroundColor3 = Color3.fromRGB(46, 48, 53)
StatusBadge.Position = UDim2.new(0, 342, 0.5, -10)
StatusBadge.Size = UDim2.new(0, 56, 0, 20)
Instance.new("UICorner", StatusBadge).CornerRadius = UDim.new(1, 0)

local StatusDot = Instance.new("Frame")
StatusDot.Parent = StatusBadge
StatusDot.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
StatusDot.Position = UDim2.new(0, 9, 0.5, -3)
StatusDot.Size = UDim2.new(0, 6, 0, 6)
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

local StatusText = Instance.new("TextLabel")
StatusText.Parent = StatusBadge
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0, 20, 0, 0)
StatusText.Size = UDim2.new(1, -20, 1, 0)
StatusText.Font = Enum.Font.GothamMedium
StatusText.Text = "Idle"
StatusText.TextColor3 = Color3.fromRGB(220, 222, 228)
StatusText.TextSize = 11
StatusText.TextXAlignment = Enum.TextXAlignment.Left

-- Thanh Search bên phải
local SearchBoxFrame = Instance.new("Frame")
SearchBoxFrame.Parent = TopBar
SearchBoxFrame.BackgroundColor3 = Color3.fromRGB(25, 26, 29)
SearchBoxFrame.Position = UDim2.new(1, -218, 0.5, -14)
SearchBoxFrame.Size = UDim2.new(0, 162, 0, 28)
Instance.new("UICorner", SearchBoxFrame).CornerRadius = UDim.new(1, 0)
local SearchStroke = Instance.new("UIStroke", SearchBoxFrame)
SearchStroke.Color = Color3.fromRGB(54, 56, 62)
SearchStroke.Thickness = 1

local SearchInput = Instance.new("TextBox")
SearchInput.Parent = SearchBoxFrame
SearchInput.BackgroundTransparency = 1
SearchInput.Position = UDim2.new(0, 12, 0, 0)
SearchInput.Size = UDim2.new(1, -20, 1, 0)
SearchInput.Font = Enum.Font.Gotham
SearchInput.PlaceholderText = "🔍  Search"
SearchInput.PlaceholderColor3 = Color3.fromRGB(135, 139, 148)
SearchInput.Text = ""
SearchInput.TextColor3 = Color3.fromRGB(235, 235, 235)
SearchInput.TextSize = 12
SearchInput.TextXAlignment = Enum.TextXAlignment.Left

-- Nút thu nhỏ (–)
local MinBtn = Instance.new("TextButton")
MinBtn.Parent = TopBar
MinBtn.BackgroundColor3 = Color3.fromRGB(46, 48, 53)
MinBtn.Position = UDim2.new(1, -44, 0.5, -13)
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "–"
MinBtn.TextColor3 = Color3.fromRGB(220, 222, 228)
MinBtn.TextSize = 14
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    RestoreBtn.Visible = true
end)

RestoreBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    RestoreBtn.Visible = false
end)

-- ==========================================
-- 3. CỘT ICON BÊN TRÁI (SIDEBAR BO GÓC DƯỚI)
-- ==========================================
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(28, 29, 32)
Sidebar.BorderSizePixel = 0
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.Size = UDim2.new(0, 58, 1, -50)
Sidebar.ClipsDescendants = true

-- Bo góc dưới trái khớp với MainFrame
local SideCorner = Instance.new("UICorner", Sidebar)
SideCorner.CornerRadius = UDim.new(0, 20)

local SideTopMask = Instance.new("Frame")
SideTopMask.Parent = Sidebar
SideTopMask.BackgroundColor3 = Color3.fromRGB(28, 29, 32)
SideTopMask.BorderSizePixel = 0
SideTopMask.Position = UDim2.new(0, 0, 0, 0)
SideTopMask.Size = UDim2.new(1, 0, 0, 20)

local SideRightMask = Instance.new("Frame")
SideRightMask.Parent = Sidebar
SideRightMask.BackgroundColor3 = Color3.fromRGB(28, 29, 32)
SideRightMask.BorderSizePixel = 0
SideRightMask.Position = UDim2.new(1, -20, 0, 0)
SideRightMask.Size = UDim2.new(0, 20, 1, 0)

local SideDivider = Instance.new("Frame")
SideDivider.Parent = Sidebar
SideDivider.BackgroundColor3 = Color3.fromRGB(48, 50, 56)
SideDivider.BorderSizePixel = 0
SideDivider.Position = UDim2.new(1, -1, 0, 0)
SideDivider.Size = UDim2.new(0, 1, 1, 0)

local IconHolder = Instance.new("Frame")
IconHolder.Parent = Sidebar
IconHolder.BackgroundTransparency = 1
IconHolder.Position = UDim2.new(0, 0, 0, 12)
IconHolder.Size = UDim2.new(1, 0, 1, -76)

local IconLayout = Instance.new("UIListLayout", IconHolder)
IconLayout.Padding = UDim.new(0, 8)
IconLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Avatar người chơi ở góc dưới cùng bên trái
local AvatarFrame = Instance.new("ImageLabel")
AvatarFrame.Parent = Sidebar
AvatarFrame.BackgroundColor3 = Color3.fromRGB(46, 48, 53)
AvatarFrame.Position = UDim2.new(0.5, -16, 1, -48)
AvatarFrame.Size = UDim2.new(0, 32, 0, 32)
AvatarFrame.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
Instance.new("UICorner", AvatarFrame).CornerRadius = UDim.new(1, 0)
local AvatarStroke = Instance.new("UIStroke", AvatarFrame)
AvatarStroke.Color = Color3.fromRGB(72, 76, 84)
AvatarStroke.Thickness = 1.2

-- ==========================================
-- 4. KHU VỰC NỘI DUNG CHÍNH (ĐỂ TRỐNG HOÀN TOÀN)
-- ==========================================
local ContentWrapper = Instance.new("Frame")
ContentWrapper.Parent = MainFrame
ContentWrapper.BackgroundTransparency = 1
ContentWrapper.Position = UDim2.new(0, 58, 0, 50)
ContentWrapper.Size = UDim2.new(1, -58, 1, -50)

local ResizeHint = Instance.new("TextLabel")
ResizeHint.Parent = ContentWrapper
ResizeHint.BackgroundTransparency = 1
ResizeHint.Position = UDim2.new(1, -24, 1, -24)
ResizeHint.Size = UDim2.new(0, 18, 0, 18)
ResizeHint.Font = Enum.Font.GothamBold
ResizeHint.Text = "//"
ResizeHint.TextColor3 = Color3.fromRGB(95, 98, 106)
ResizeHint.TextSize = 11

local TabConfigs = {
    { Name = "Home",     Icon = "⌂", SubTabs = {"Overview"} },
    { Name = "Steal",    Icon = "◎", SubTabs = {"Auto Steal", "Egg Predictor"} },
    { Name = "Farm",     Icon = "🌱", SubTabs = {"Auto Farm"} },
    { Name = "Visuals",  Icon = "✦", SubTabs = {"ESP", "World"} },
    { Name = "Player",   Icon = "웃", SubTabs = {"Movement", "Character"} },
    { Name = "Settings", Icon = "⚙", SubTabs = {"General", "Config"} }
}

local CreatedTabs = {}

for index, cfg in ipairs(TabConfigs) do
    local isFirst = (index == 2)

    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = IconHolder
    TabBtn.BackgroundColor3 = isFirst and Color3.fromRGB(50, 52, 58) or Color3.fromRGB(28, 29, 32)
    TabBtn.BackgroundTransparency = isFirst and 0 or 1
    TabBtn.Size = UDim2.new(0, 38, 0, 38)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Text = cfg.Icon
    TabBtn.TextColor3 = isFirst and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(132, 136, 145)
    TabBtn.TextSize = 18
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 10)

    local Page = Instance.new("Frame")
    Page.Parent = ContentWrapper
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = isFirst

    local PageTitle = Instance.new("TextLabel")
    PageTitle.Parent = Page
    PageTitle.BackgroundTransparency = 1
    PageTitle.Position = UDim2.new(0, 22, 0, 14)
    PageTitle.Size = UDim2.new(0, 200, 0, 26)
    PageTitle.Font = Enum.Font.GothamBold
    PageTitle.Text = cfg.Name
    PageTitle.TextColor3 = Color3.fromRGB(245, 246, 250)
    PageTitle.TextSize = 19
    PageTitle.TextXAlignment = Enum.TextXAlignment.Left

    local SubTabBar = Instance.new("Frame")
    SubTabBar.Parent = Page
    SubTabBar.BackgroundColor3 = Color3.fromRGB(31, 32, 36)
    SubTabBar.Position = UDim2.new(1, -220, 0, 14)
    SubTabBar.Size = UDim2.new(0, 198, 0, 28)
    Instance.new("UICorner", SubTabBar).CornerRadius = UDim.new(1, 0)
    local SubStroke = Instance.new("UIStroke", SubTabBar)
    SubStroke.Color = Color3.fromRGB(50, 52, 58)
    SubStroke.Thickness = 1

    local SubLayout = Instance.new("UIListLayout", SubTabBar)
    SubLayout.FillDirection = Enum.FillDirection.Horizontal
    SubLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SubLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    SubLayout.Padding = UDim.new(0, 4)

    -- Khu vực nội dung hoàn toàn TRỐNG
    local EmptyBody = Instance.new("Frame")
    EmptyBody.Name = "EmptyContainer"
    EmptyBody.Parent = Page
    EmptyBody.BackgroundTransparency = 1
    EmptyBody.Position = UDim2.new(0, 22, 0, 52)
    EmptyBody.Size = UDim2.new(1, -44, 1, -68)

    local SubBtns = {}
    for sIdx, sName in ipairs(cfg.SubTabs) do
        local sBtn = Instance.new("TextButton")
        sBtn.Parent = SubTabBar
        sBtn.BackgroundColor3 = (sIdx == 1) and Color3.fromRGB(54, 56, 62) or Color3.fromRGB(31, 32, 36)
        sBtn.BackgroundTransparency = (sIdx == 1) and 0 or 1
        sBtn.Size = UDim2.new(1 / #cfg.SubTabs, -6, 0, 22)
        sBtn.Font = Enum.Font.GothamSemibold
        sBtn.Text = sName
        sBtn.TextColor3 = (sIdx == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(145, 148, 156)
        sBtn.TextSize = 11
        Instance.new("UICorner", sBtn).CornerRadius = UDim.new(1, 0)

        table.insert(SubBtns, sBtn)
        sBtn.MouseButton1Click:Connect(function()
            for _, b in ipairs(SubBtns) do
                b.BackgroundTransparency = 1
                b.TextColor3 = Color3.fromRGB(145, 148, 156)
            end
            sBtn.BackgroundTransparency = 0
            sBtn.BackgroundColor3 = Color3.fromRGB(54, 56, 62)
            sBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
    end

    table.insert(CreatedTabs, {Btn = TabBtn, Page = Page})

    TabBtn.MouseButton1Click:Connect(function()
        for _, item in ipairs(CreatedTabs) do
            item.Page.Visible = false
            item.Btn.BackgroundTransparency = 1
            item.Btn.TextColor3 = Color3.fromRGB(132, 136, 145)
        end
        Page.Visible = true
        TabBtn.BackgroundTransparency = 0
        TabBtn.BackgroundColor3 = Color3.fromRGB(50, 52, 58)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end
