-- ==========================================
-- CẤU HÌNH THÔNG TIN CỦA BẠN
-- ==========================================
local WebhookURL = "https://discord.com/api/webhooks/1570446166754201803/pPCEG-HczkXcUA2fWQd6pYo62wgLmeBxf1ri812j1AO2W87wWCz1LzoF-6s8tgem5yEo"
local DiscordUserID = "1494250347731091497"

local CURRENT_MIN_MONEY = 0

-- ==========================================
-- KHỞI TẠO DỊCH VỤ & BIẾN TRẠNG THÁI
-- ==========================================
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
if not httpRequest then
    warn("❌ Executor của bạn không hỗ trợ hàm HTTP Request!")
    return
end

local isRunning = true
local startTime = tick()
local petsCaughtCount = 0
local processedItems = {} 

local cachedGameName = "Throw Food For Animals"
pcall(function()
    cachedGameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

-- ==========================================
-- BẢNG HẬU TỐ SỐ LỚN
-- ==========================================
local Suffixes = {
    "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No",
    "Dc", "Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod",
    "Vg", "Uvg", "Dvg", "Tvg", "Qavg", "Qivg", "Sxvg", "Spvg", "Ocvg", "Novg",
    "Tg", "Utg", "Dtg", "Ttg", "Qatg", "Qitg", "Sxtg", "Sptg", "Octg", "Notg"
}

local function parseRawMoneyToNumber(val)
    if type(val) == "number" then return val end
    if type(val) ~= "string" then return 0 end
    val = val:gsub("%$", ""):gsub("/s", ""):gsub(",", ""):gsub("%s+", "")
    local numPart = tonumber(val:match("[%d%.]+"))
    if not numPart then return 0 end
    local suffixPart = string.upper(val:match("[%a]+") or "")
    local multipliers = {
        K = 1e3, M = 1e6, B = 1e9, T = 1e12,
        QA = 1e15, QI = 1e18, SX = 1e21, SP = 1e24, OC = 1e27, NO = 1e30,
        DC = 1e33, UD = 1e36, DD = 1e39, TD = 1e42, QAD = 1e45, QID = 1e48,
        SXD = 1e51, SPD = 1e54, OCD = 1e57, NOD = 1e60, VG = 1e63
    }
    if multipliers[suffixPart] then
        return numPart * multipliers[suffixPart]
    end
    return numPart
end

local function formatBigNumber(val)
    if type(val) == "string" then
        if string.find(val, "e%+") or tonumber(val) then val = tonumber(val) else return val end
    end
    local num = tonumber(val)
    if not num then return "Không rõ" end
    if num < 1000 then return string.format("%.2f", num):gsub("%.00$", "") end
    local tier = math.floor(math.log10(math.abs(num)) / 3)
    local suffix = Suffixes[tier + 1]
    if suffix then
        local scaled = num / (10 ^ (tier * 3))
        local formatted = string.format("%.2f", scaled):gsub("%.", ",")
        return formatted .. suffix:lower()
    else
        return string.format("%.2e", num)
    end
end

-- ==========================================
-- TẠO GIAO DIỆN (UI)
-- ==========================================
if CoreGui:FindFirstChild("ThrowFoodAutoMenu") then
    CoreGui.ThrowFoodAutoMenu:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThrowFoodAutoMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local function onButtonClicked(btn, callback)
    local connection
    connection = btn.MouseButton1Click:Connect(callback)
    if not connection then
        btn.Activated:Connect(callback)
    end
end

local ToggleIconBtn = Instance.new("TextButton")
ToggleIconBtn.Name = "ToggleIconBtn"
ToggleIconBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleIconBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
ToggleIconBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
ToggleIconBtn.TextColor3 = Color3.fromRGB(255, 220, 50)
ToggleIconBtn.TextSize = 22
ToggleIconBtn.Font = Enum.Font.GothamBold
ToggleIconBtn.Text = "⚡"
ToggleIconBtn.Active = true
ToggleIconBtn.Draggable = false
ToggleIconBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleIconBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(224, 86, 36)
IconStroke.Thickness = 2
IconStroke.Parent = ToggleIconBtn

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 310, 0, 365)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local isMenuVisible = true
onButtonClicked(ToggleIconBtn, function()
    isMenuVisible = not isMenuVisible
    MainFrame.Visible = isMenuVisible
    TweenService:Create(ToggleIconBtn, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Rotation = ToggleIconBtn.Rotation + 360
    }):Play()
end)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 32)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🐾 Throw Food Auto Logger"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 30)
TabContainer.Position = UDim2.new(0, 10, 0, 32)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local Tab1Btn = Instance.new("TextButton")
Tab1Btn.Size = UDim2.new(0.48, 0, 1, 0)
Tab1Btn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
Tab1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Tab1Btn.TextSize = 11
Tab1Btn.Font = Enum.Font.GothamBold
Tab1Btn.Text = "🚀 Gửi Webhook"
Tab1Btn.Parent = TabContainer
Instance.new("UICorner", Tab1Btn).CornerRadius = UDim.new(0, 6)

local Tab2Btn = Instance.new("TextButton")
Tab2Btn.Size = UDim2.new(0.48, 0, 1, 0)
Tab2Btn.Position = UDim2.new(0.52, 0, 0, 0)
Tab2Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
Tab2Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
Tab2Btn.TextSize = 11
Tab2Btn.Font = Enum.Font.GothamBold
Tab2Btn.Text = "📜 Lịch sử Pet"
Tab2Btn.Parent = TabContainer
Instance.new("UICorner", Tab2Btn).CornerRadius = UDim.new(0, 6)

-- ==========================================
-- DYNAMIC ISLAND (#459) - TRÊN ĐẦU KHI QUAY NGANG
-- ==========================================
local DynamicIsland = Instance.new("Frame")
DynamicIsland.Name = "u459DynamicIsland"
DynamicIsland.AnchorPoint = Vector2.new(0.5, 0)
DynamicIsland.Position = UDim2.new(0.5, 0, 0, 8)
DynamicIsland.Size = UDim2.new(0, 206, 0, 36)
DynamicIsland.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DynamicIsland.BorderSizePixel = 0
DynamicIsland.Visible = false
DynamicIsland.ZIndex = 80
DynamicIsland.Parent = ScreenGui
Instance.new("UICorner", DynamicIsland).CornerRadius = UDim.new(0, 18)

local IslandStroke = Instance.new("UIStroke")
IslandStroke.Color = Color3.fromRGB(255, 255, 255)
IslandStroke.Transparency = 0.86
IslandStroke.Thickness = 1
IslandStroke.Parent = DynamicIsland

local IslandTapBtn = Instance.new("TextButton")
IslandTapBtn.Size = UDim2.new(1, 0, 1, 0)
IslandTapBtn.Position = UDim2.new(0, 0, 0, 0)
IslandTapBtn.BackgroundTransparency = 1
IslandTapBtn.Text = ""
IslandTapBtn.ZIndex = 81
IslandTapBtn.Parent = DynamicIsland

-- Trạng thái thu gọn (Compact: 206x36)
local CompactView = Instance.new("Frame")
CompactView.Size = UDim2.new(1, 0, 1, 0)
CompactView.BackgroundTransparency = 1
CompactView.ZIndex = 82
CompactView.Parent = DynamicIsland

local CompactDot = Instance.new("Frame")
CompactDot.Size = UDim2.new(0, 8, 0, 8)
CompactDot.Position = UDim2.new(0, 12, 0.5, -4)
CompactDot.BackgroundColor3 = Color3.fromRGB(48, 209, 88)
CompactDot.BorderSizePixel = 0
CompactDot.ZIndex = 83
CompactDot.Parent = CompactView
Instance.new("UICorner", CompactDot).CornerRadius = UDim.new(1, 0)

local CompactTitle = Instance.new("TextLabel")
CompactTitle.Size = UDim2.new(0, 96, 1, 0)
CompactTitle.Position = UDim2.new(0, 25, 0, 0)
CompactTitle.BackgroundTransparency = 1
CompactTitle.Text = "🐾 0 Pet"
CompactTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
CompactTitle.TextSize = 12
CompactTitle.Font = Enum.Font.GothamBold
CompactTitle.TextXAlignment = Enum.TextXAlignment.Left
CompactTitle.ZIndex = 83
CompactTitle.Parent = CompactView

local CompactTimer = Instance.new("TextLabel")
CompactTimer.Size = UDim2.new(0, 72, 1, 0)
CompactTimer.Position = UDim2.new(1, -82, 0, 0)
CompactTimer.BackgroundTransparency = 1
CompactTimer.Text = "00:00:00"
CompactTimer.TextColor3 = Color3.fromRGB(255, 159, 10)
CompactTimer.TextSize = 11
CompactTimer.Font = Enum.Font.Code
CompactTimer.TextXAlignment = Enum.TextXAlignment.Right
CompactTimer.ZIndex = 83
CompactTimer.Parent = CompactView

-- Trạng thái mở rộng (Expanded: 316x84)
local ExpandedView = Instance.new("Frame")
ExpandedView.Size = UDim2.new(1, 0, 1, 0)
ExpandedView.BackgroundTransparency = 1
ExpandedView.Visible = false
ExpandedView.ZIndex = 82
ExpandedView.Parent = DynamicIsland

local ExpandedInfo = Instance.new("TextLabel")
ExpandedInfo.Size = UDim2.new(1, -24, 0, 34)
ExpandedInfo.Position = UDim2.new(0, 12, 0, 8)
ExpandedInfo.BackgroundTransparency = 1
ExpandedInfo.Text = "Đang tải trạng thái..."
ExpandedInfo.TextColor3 = Color3.fromRGB(244, 240, 232)
ExpandedInfo.TextSize = 10
ExpandedInfo.Font = Enum.Font.Code
ExpandedInfo.TextXAlignment = Enum.TextXAlignment.Left
ExpandedInfo.TextYAlignment = Enum.TextYAlignment.Top
ExpandedInfo.ZIndex = 83
ExpandedInfo.Parent = ExpandedView

local IslandToggleRunBtn = Instance.new("TextButton")
IslandToggleRunBtn.Size = UDim2.new(0, 96, 0, 26)
IslandToggleRunBtn.Position = UDim2.new(0, 12, 1, -34)
IslandToggleRunBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
IslandToggleRunBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
IslandToggleRunBtn.TextSize = 10
IslandToggleRunBtn.Font = Enum.Font.GothamBold
IslandToggleRunBtn.Text = "STOP SCRIPT"
IslandToggleRunBtn.ZIndex = 84
IslandToggleRunBtn.Parent = ExpandedView
Instance.new("UICorner", IslandToggleRunBtn).CornerRadius = UDim.new(0, 8)

local IslandMenuBtn = Instance.new("TextButton")
IslandMenuBtn.Size = UDim2.new(0, 96, 0, 26)
IslandMenuBtn.Position = UDim2.new(0, 114, 1, -34)
IslandMenuBtn.BackgroundColor3 = Color3.fromRGB(52, 52, 64)
IslandMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
IslandMenuBtn.TextSize = 10
IslandMenuBtn.Font = Enum.Font.GothamBold
IslandMenuBtn.Text = "Ẩn/Hiện Menu"
IslandMenuBtn.ZIndex = 84
IslandMenuBtn.Parent = ExpandedView
Instance.new("UICorner", IslandMenuBtn).CornerRadius = UDim.new(0, 8)

local IslandCollapseBtn = Instance.new("TextButton")
IslandCollapseBtn.Size = UDim2.new(0, 82, 0, 26)
IslandCollapseBtn.Position = UDim2.new(1, -94, 1, -34)
IslandCollapseBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
IslandCollapseBtn.TextColor3 = Color3.fromRGB(255, 159, 10)
IslandCollapseBtn.TextSize = 10
IslandCollapseBtn.Font = Enum.Font.GothamBold
IslandCollapseBtn.Text = "Thu gọn"
IslandCollapseBtn.ZIndex = 84
IslandCollapseBtn.Parent = ExpandedView
Instance.new("UICorner", IslandCollapseBtn).CornerRadius = UDim.new(0, 8)

local isIslandExpanded = false

local function setIslandExpanded(expanded)
    isIslandExpanded = expanded
    if expanded then
        CompactView.Visible = false
        ExpandedView.Visible = true
        TweenService:Create(DynamicIsland, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 316, 0, 84)
        }):Play()
        TweenService:Create(DynamicIsland:FindFirstChildOfClass("UICorner"), TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CornerRadius = UDim.new(0, 24)
        }):Play()
    else
        ExpandedView.Visible = false
        CompactView.Visible = true
        TweenService:Create(DynamicIsland, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 206, 0, 36)
        }):Play()
        TweenService:Create(DynamicIsland:FindFirstChildOfClass("UICorner"), TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CornerRadius = UDim.new(0, 18)
        }):Play()
    end
end

onButtonClicked(IslandTapBtn, function()
    if not isIslandExpanded then
        setIslandExpanded(true)
    end
end)

onButtonClicked(IslandCollapseBtn, function()
    setIslandExpanded(false)
end)

onButtonClicked(IslandMenuBtn, function()
    isMenuVisible = not isMenuVisible
    MainFrame.Visible = isMenuVisible
end)

local function syncRunButtons()
    if isRunning then
        ToggleButton.Text = "STOP SCRIPT"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        IslandToggleRunBtn.Text = "STOP SCRIPT"
        IslandToggleRunBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        CompactDot.BackgroundColor3 = Color3.fromRGB(48, 209, 88)
    else
        ToggleButton.Text = "START SCRIPT"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(224, 86, 36)
        IslandToggleRunBtn.Text = "START SCRIPT"
        IslandToggleRunBtn.BackgroundColor3 = Color3.fromRGB(224, 86, 36)
        CompactDot.BackgroundColor3 = Color3.fromRGB(255, 69, 58)
    end
end

onButtonClicked(IslandToggleRunBtn, function()
    isRunning = not isRunning
    syncRunButtons()
end)

local function updateLandscapeVisibility()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp = cam.ViewportSize
    local isLandscape = vp.X > vp.Y
    DynamicIsland.Visible = isLandscape
    if not isLandscape and isIslandExpanded then
        isIslandExpanded = false
        ExpandedView.Visible = false
        CompactView.Visible = true
        DynamicIsland.Size = UDim2.new(0, 206, 0, 36)
    end
end

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLandscapeVisibility)
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLandscapeVisibility)
        updateLandscapeVisibility()
    end
end)
updateLandscapeVisibility()

-- --- TAB 1 ---
local Tab1Content = Instance.new("Frame")
Tab1Content.Size = UDim2.new(1, 0, 1, -70)
Tab1Content.Position = UDim2.new(0, 0, 0, 65)
Tab1Content.BackgroundTransparency = 1
Tab1Content.Visible = true
Tab1Content.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 65)
StatusLabel.Position = UDim2.new(0, 10, 0, 0)
StatusLabel.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
StatusLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextWrapped = true
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
StatusLabel.Parent = Tab1Content
Instance.new("UICorner", StatusLabel).CornerRadius = UDim.new(0, 8)

local CustomMoneyInput = Instance.new("TextBox")
CustomMoneyInput.Size = UDim2.new(1, -92, 0, 28)
CustomMoneyInput.Position = UDim2.new(0, 10, 0, 72)
CustomMoneyInput.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
CustomMoneyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
CustomMoneyInput.PlaceholderColor3 = Color3.fromRGB(155, 155, 165)
CustomMoneyInput.PlaceholderText = "💰 Tiền lưu/gửi (vd: 1M, 1B, 0)..."
CustomMoneyInput.Text = ""
CustomMoneyInput.TextSize = 10
CustomMoneyInput.Font = Enum.Font.Gotham
CustomMoneyInput.ClearTextOnFocus = false
CustomMoneyInput.Parent = Tab1Content
Instance.new("UICorner", CustomMoneyInput).CornerRadius = UDim.new(0, 6)

local SaveMoneyBtn = Instance.new("TextButton")
SaveMoneyBtn.Size = UDim2.new(0, 66, 0, 28)
SaveMoneyBtn.Position = UDim2.new(1, -76, 0, 72)
SaveMoneyBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
SaveMoneyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveMoneyBtn.TextSize = 10
SaveMoneyBtn.Font = Enum.Font.GothamBold
SaveMoneyBtn.Text = "💾 Lưu"
SaveMoneyBtn.Parent = Tab1Content
Instance.new("UICorner", SaveMoneyBtn).CornerRadius = UDim.new(0, 6)

local FilterDropdownBtn = Instance.new("TextButton")
FilterDropdownBtn.Size = UDim2.new(1, -20, 0, 28)
FilterDropdownBtn.Position = UDim2.new(0, 10, 0, 106)
FilterDropdownBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
FilterDropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FilterDropdownBtn.TextSize = 11
FilterDropdownBtn.Font = Enum.Font.GothamBold
FilterDropdownBtn.Text = "🔽 Lọc Lưu & Gửi: Tất cả (0)"
FilterDropdownBtn.Parent = Tab1Content
Instance.new("UICorner", FilterDropdownBtn).CornerRadius = UDim.new(0, 6)

local DropdownListFrame = Instance.new("ScrollingFrame")
DropdownListFrame.Size = UDim2.new(1, -20, 0, 90)
DropdownListFrame.Position = UDim2.new(0, 10, 0, 138)
DropdownListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
DropdownListFrame.BorderSizePixel = 0
DropdownListFrame.Visible = false
DropdownListFrame.CanvasSize = UDim2.new(0, 0, 0, 200)
DropdownListFrame.ScrollBarThickness = 4
DropdownListFrame.Parent = Tab1Content
Instance.new("UICorner", DropdownListFrame).CornerRadius = UDim.new(0, 6)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 3)
UIListLayout.Parent = DropdownListFrame

local isDropdownOpen = false

local function applyMinMoneyFilter(val, labelText)
    CURRENT_MIN_MONEY = math.max(0, tonumber(val) or 0)
    if CURRENT_MIN_MONEY == 0 then
        FilterDropdownBtn.Text = "🔽 Lọc Lưu & Gửi: Tất cả (0)"
    else
        FilterDropdownBtn.Text = "🔽 Lọc Lưu & Gửi: " .. (labelText or (formatBigNumber(CURRENT_MIN_MONEY) .. "+/s"))
    end
    isDropdownOpen = false
    DropdownListFrame.Visible = false
end

onButtonClicked(SaveMoneyBtn, function()
    local rawText = CustomMoneyInput.Text or ""
    if rawText:gsub("%s+", "") == "" then
        applyMinMoneyFilter(0, "Tất cả (0)")
        return
    end
    local parsedVal = parseRawMoneyToNumber(rawText)
    applyMinMoneyFilter(parsedVal, rawText .. "+")
end)

local function createFilterOption(name, val)
    local optBtn = Instance.new("TextButton")
    optBtn.Size = UDim2.new(1, -4, 0, 24)
    optBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    optBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
    optBtn.TextSize = 11
    optBtn.Font = Enum.Font.Gotham
    optBtn.Text = name
    optBtn.Parent = DropdownListFrame
    Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)

    onButtonClicked(optBtn, function()
        CustomMoneyInput.Text = val == 0 and "" or name
        applyMinMoneyFilter(val, name)
    end)
end

createFilterOption("Tất cả (Nhận hết)", 0)
createFilterOption("Từ 1M+ /s", 1e6)
createFilterOption("Từ 1B+ /s", 1e9)
createFilterOption("Từ 1T+ /s", 1e12)
createFilterOption("Từ 1Qa+ /s", 1e15)
createFilterOption("Từ 1spd+ /s", 1e54)

onButtonClicked(FilterDropdownBtn, function()
    isDropdownOpen = not isDropdownOpen
    DropdownListFrame.Visible = isDropdownOpen
    if isDropdownOpen then
        FilterDropdownBtn.Text = "🔼 Đóng bảng lọc tiền"
    else
        FilterDropdownBtn.Text = "🔽 Lọc Lưu & Gửi: " .. (CURRENT_MIN_MONEY == 0 and "Tất cả" or formatBigNumber(CURRENT_MIN_MONEY) .. "+")
    end
end)

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 36)
ToggleButton.Position = UDim2.new(0, 10, 0, 142)
ToggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 13
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "STOP SCRIPT"
ToggleButton.Parent = Tab1Content
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)

local FooterLabel = Instance.new("TextLabel")
FooterLabel.Size = UDim2.new(1, -20, 0, 30)
FooterLabel.Position = UDim2.new(0, 10, 0, 232)
FooterLabel.BackgroundTransparency = 1
FooterLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
FooterLabel.TextSize = 11
FooterLabel.Font = Enum.Font.Gotham
FooterLabel.TextWrapped = true
FooterLabel.Text = "Đã gửi: 0 thú | Trạng thái: 🟢 Đang chạy"
FooterLabel.Parent = Tab1Content

DropdownListFrame:GetPropertyChangedSignal("Visible"):Connect(function()
    if DropdownListFrame.Visible then
        ToggleButton.Position = UDim2.new(0, 10, 0, 233)
        FooterLabel.Position = UDim2.new(0, 10, 0, 272)
    else
        ToggleButton.Position = UDim2.new(0, 10, 0, 142)
        FooterLabel.Position = UDim2.new(0, 10, 0, 232)
    end
end)

-- --- TAB 2: LỊCH SỬ + XÁC NHẬN XOÁ (#436) ---
local HistoryRecords = {}
local historyFilterMode = "all"
local isSelectMode = false
local selectedIndices = {}
local refreshHistory

local HistorySearch = Instance.new("TextBox")
HistorySearch.Size = UDim2.new(0, 130, 0, 30)
HistorySearch.Position = UDim2.new(0, 10, 0, 66)
HistorySearch.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
HistorySearch.TextColor3 = Color3.fromRGB(245, 245, 245)
HistorySearch.PlaceholderColor3 = Color3.fromRGB(155, 155, 165)
HistorySearch.PlaceholderText = "🔎 Tìm tên..."
HistorySearch.Text = ""
HistorySearch.TextSize = 10
HistorySearch.Font = Enum.Font.Gotham
HistorySearch.ClearTextOnFocus = false
HistorySearch.Parent = MainFrame
HistorySearch.Visible = false
Instance.new("UICorner", HistorySearch).CornerRadius = UDim.new(0, 6)

local HistoryFilterBtn = Instance.new("TextButton")
HistoryFilterBtn.Size = UDim2.new(0, 32, 0, 30)
HistoryFilterBtn.Position = UDim2.new(0, 145, 0, 66)
HistoryFilterBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
HistoryFilterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HistoryFilterBtn.Text = "☷"
HistoryFilterBtn.TextSize = 11
HistoryFilterBtn.Font = Enum.Font.GothamBold
HistoryFilterBtn.Parent = MainFrame
HistoryFilterBtn.Visible = false
Instance.new("UICorner", HistoryFilterBtn).CornerRadius = UDim.new(0, 6)

local HistorySelectBtn = Instance.new("TextButton")
HistorySelectBtn.Size = UDim2.new(0, 32, 0, 30)
HistorySelectBtn.Position = UDim2.new(0, 182, 0, 66)
HistorySelectBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
HistorySelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HistorySelectBtn.Text = "🗑️"
HistorySelectBtn.TextSize = 11
HistorySelectBtn.Font = Enum.Font.GothamBold
HistorySelectBtn.Parent = MainFrame
HistorySelectBtn.Visible = false
Instance.new("UICorner", HistorySelectBtn).CornerRadius = UDim.new(0, 6)

local HistoryCountLabel = Instance.new("TextLabel")
HistoryCountLabel.Size = UDim2.new(0, 70, 0, 30)
HistoryCountLabel.Position = UDim2.new(0, 219, 0, 66)
HistoryCountLabel.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
HistoryCountLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
HistoryCountLabel.TextSize = 11
HistoryCountLabel.Font = Enum.Font.GothamBold
HistoryCountLabel.Text = "0"
HistoryCountLabel.TextXAlignment = Enum.TextXAlignment.Center
HistoryCountLabel.Parent = MainFrame
HistoryCountLabel.Visible = false
Instance.new("UICorner", HistoryCountLabel).CornerRadius = UDim.new(0, 6)

local DeleteActionBar = Instance.new("Frame")
DeleteActionBar.Size = UDim2.new(1, -20, 0, 30)
DeleteActionBar.Position = UDim2.new(0, 10, 1, -38)
DeleteActionBar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
DeleteActionBar.Visible = false
DeleteActionBar.Parent = MainFrame
Instance.new("UICorner", DeleteActionBar).CornerRadius = UDim.new(0, 6)

local DeleteSelectedBtn = Instance.new("TextButton")
DeleteSelectedBtn.Size = UDim2.new(0.48, 0, 1, -4)
DeleteSelectedBtn.Position = UDim2.new(0, 2, 0, 2)
DeleteSelectedBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
DeleteSelectedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DeleteSelectedBtn.TextSize = 10
DeleteSelectedBtn.Font = Enum.Font.GothamBold
DeleteSelectedBtn.Text = "Xóa đã chọn (0)"
DeleteSelectedBtn.Parent = DeleteActionBar
Instance.new("UICorner", DeleteSelectedBtn).CornerRadius = UDim.new(0, 4)

local DeleteAllBtn = Instance.new("TextButton")
DeleteAllBtn.Size = UDim2.new(0.48, 0, 1, -4)
DeleteAllBtn.Position = UDim2.new(0.52, -2, 0, 2)
DeleteAllBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 40)
DeleteAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DeleteAllBtn.TextSize = 10
DeleteAllBtn.Font = Enum.Font.GothamBold
DeleteAllBtn.Text = "Xóa tất cả"
DeleteAllBtn.Parent = DeleteActionBar
Instance.new("UICorner", DeleteAllBtn).CornerRadius = UDim.new(0, 4)

local HistoryFilterPopup = Instance.new("Frame")
HistoryFilterPopup.Size = UDim2.new(0, 130, 0, 88)
HistoryFilterPopup.Position = UDim2.new(0, 145, 0, 99)
HistoryFilterPopup.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
HistoryFilterPopup.Visible = false
HistoryFilterPopup.ZIndex = 10
HistoryFilterPopup.Parent = MainFrame
Instance.new("UICorner", HistoryFilterPopup).CornerRadius = UDim.new(0, 6)

local function makeHistoryModeButton(label, mode, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 24)
    b.Position = UDim2.new(0, 4, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(52, 52, 64)
    b.TextColor3 = Color3.fromRGB(245, 245, 245)
    b.TextSize = 10
    b.Font = Enum.Font.Gotham
    b.Text = label
    b.ZIndex = 11
    b.Parent = HistoryFilterPopup
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    onButtonClicked(b, function()
        historyFilterMode = mode
        HistoryFilterPopup.Visible = false
        if refreshHistory then refreshHistory() end
    end)
end
makeHistoryModeButton("Tất cả", "all", 4)
makeHistoryModeButton("Lọc giá trị", "value", 30)
makeHistoryModeButton("Lọc độ hiếm", "rarity", 56)

onButtonClicked(HistoryFilterBtn, function()
    HistoryFilterPopup.Visible = not HistoryFilterPopup.Visible
end)

-- ==========================================
-- HỘP THOẠI XÁC NHẬN XOÁ (#436) CHO LỊCH SỬ
-- ==========================================
local ConfirmOverlay = Instance.new("Frame")
ConfirmOverlay.Name = "u436ConfirmOverlay"
ConfirmOverlay.Size = UDim2.new(1, 0, 1, 0)
ConfirmOverlay.Position = UDim2.new(0, 0, 0, 0)
ConfirmOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ConfirmOverlay.BackgroundTransparency = 0.45
ConfirmOverlay.BorderSizePixel = 0
ConfirmOverlay.Visible = false
ConfirmOverlay.ZIndex = 50
ConfirmOverlay.Parent = MainFrame
Instance.new("UICorner", ConfirmOverlay).CornerRadius = UDim.new(0, 14)

local ConfirmCard = Instance.new("Frame")
ConfirmCard.Name = "u436-d"
ConfirmCard.Size = UDim2.new(0, 274, 0, 186)
ConfirmCard.Position = UDim2.new(0.5, -137, 0.5, -93)
ConfirmCard.BackgroundColor3 = Color3.fromRGB(30, 31, 40)
ConfirmCard.BorderSizePixel = 0
ConfirmCard.ZIndex = 51
ConfirmCard.Parent = ConfirmOverlay
Instance.new("UICorner", ConfirmCard).CornerRadius = UDim.new(0, 16)
local ConfirmStroke = Instance.new("UIStroke")
ConfirmStroke.Color = Color3.fromRGB(255, 255, 255)
ConfirmStroke.Transparency = 0.85
ConfirmStroke.Thickness = 1
ConfirmStroke.Parent = ConfirmCard

local BinIconBox = Instance.new("Frame")
BinIconBox.Size = UDim2.new(0, 42, 0, 42)
BinIconBox.Position = UDim2.new(0, 16, 0, 14)
BinIconBox.BackgroundColor3 = Color3.fromRGB(217, 58, 85)
BinIconBox.BackgroundTransparency = 0.85
BinIconBox.BorderSizePixel = 0
BinIconBox.ZIndex = 52
BinIconBox.Parent = ConfirmCard
Instance.new("UICorner", BinIconBox).CornerRadius = UDim.new(0, 12)

local BinLid = Instance.new("Frame")
BinLid.Size = UDim2.new(0, 22, 0, 3)
BinLid.Position = UDim2.new(0.5, -11, 0, 12)
BinLid.BackgroundColor3 = Color3.fromRGB(255, 125, 140)
BinLid.BorderSizePixel = 0
BinLid.ZIndex = 54
BinLid.Parent = BinIconBox
Instance.new("UICorner", BinLid).CornerRadius = UDim.new(0, 2)

local BinBody = Instance.new("Frame")
BinBody.Size = UDim2.new(0, 16, 0, 15)
BinBody.Position = UDim2.new(0.5, -8, 0, 16)
BinBody.BackgroundColor3 = Color3.fromRGB(255, 125, 140)
BinBody.BorderSizePixel = 0
BinBody.ZIndex = 53
BinBody.Parent = BinIconBox
Instance.new("UICorner", BinBody).CornerRadius = UDim.new(0, 3)

local DocSheet = Instance.new("Frame")
DocSheet.Size = UDim2.new(0, 9, 0, 11)
DocSheet.Position = UDim2.new(0.5, -4, 0, 2)
DocSheet.BackgroundColor3 = Color3.fromRGB(244, 240, 232)
DocSheet.BackgroundTransparency = 1
DocSheet.BorderSizePixel = 0
DocSheet.ZIndex = 53
DocSheet.Parent = BinIconBox
Instance.new("UICorner", DocSheet).CornerRadius = UDim.new(0, 1)

local ConfirmTitle = Instance.new("TextLabel")
ConfirmTitle.Size = UDim2.new(1, -80, 0, 24)
ConfirmTitle.Position = UDim2.new(0, 66, 0, 14)
ConfirmTitle.BackgroundTransparency = 1
ConfirmTitle.Text = "Xoá lịch sử pet?"
ConfirmTitle.TextColor3 = Color3.fromRGB(244, 240, 232)
ConfirmTitle.TextSize = 14
ConfirmTitle.Font = Enum.Font.GothamBold
ConfirmTitle.TextXAlignment = Enum.TextXAlignment.Left
ConfirmTitle.ZIndex = 52
ConfirmTitle.Parent = ConfirmCard

local ConfirmDesc = Instance.new("TextLabel")
ConfirmDesc.Size = UDim2.new(1, -32, 0, 46)
ConfirmDesc.Position = UDim2.new(0, 16, 0, 62)
ConfirmDesc.BackgroundTransparency = 1
ConfirmDesc.Text = "Các mục đã chọn sẽ bị xoá khỏi lịch sử và không thể hoàn tác."
ConfirmDesc.TextColor3 = Color3.fromRGB(195, 192, 205)
ConfirmDesc.TextSize = 11
ConfirmDesc.Font = Enum.Font.Gotham
ConfirmDesc.TextWrapped = true
ConfirmDesc.TextXAlignment = Enum.TextXAlignment.Left
ConfirmDesc.TextYAlignment = Enum.TextYAlignment.Top
ConfirmDesc.ZIndex = 52
ConfirmDesc.Parent = ConfirmCard

local CancelConfirmBtn = Instance.new("TextButton")
CancelConfirmBtn.Size = UDim2.new(0.5, -20, 0, 36)
CancelConfirmBtn.Position = UDim2.new(0, 16, 1, -50)
CancelConfirmBtn.BackgroundColor3 = Color3.fromRGB(48, 50, 62)
CancelConfirmBtn.TextColor3 = Color3.fromRGB(244, 240, 232)
CancelConfirmBtn.TextSize = 12
CancelConfirmBtn.Font = Enum.Font.GothamBold
CancelConfirmBtn.Text = "Cancel"
CancelConfirmBtn.ZIndex = 52
CancelConfirmBtn.Parent = ConfirmCard
Instance.new("UICorner", CancelConfirmBtn).CornerRadius = UDim.new(0, 10)

local OkConfirmBtn = Instance.new("TextButton")
OkConfirmBtn.Size = UDim2.new(0.5, -20, 0, 36)
OkConfirmBtn.Position = UDim2.new(0.5, 4, 1, -50)
OkConfirmBtn.BackgroundColor3 = Color3.fromRGB(217, 48, 74)
OkConfirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OkConfirmBtn.TextSize = 12
OkConfirmBtn.Font = Enum.Font.GothamBold
OkConfirmBtn.Text = "Delete"
OkConfirmBtn.ZIndex = 52
OkConfirmBtn.Parent = ConfirmCard
Instance.new("UICorner", OkConfirmBtn).CornerRadius = UDim.new(0, 10)

local pendingDeleteMode = nil
local confirmBusy = false

local function resetTrashVisual()
    BinLid.Rotation = 0
    DocSheet.Position = UDim2.new(0.5, -4, 0, 2)
    DocSheet.BackgroundTransparency = 1
    ConfirmCard.Position = UDim2.new(0.5, -137, 0.5, -93)
    ConfirmOverlay.BackgroundTransparency = 0.45
end

local function closeConfirmDialog(afterFn)
    local outTween = TweenService:Create(ConfirmCard, TweenInfo.new(0.26, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -137, 0.5, -83)
    })
    local fadeTween = TweenService:Create(ConfirmOverlay, TweenInfo.new(0.26, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    outTween:Play()
    fadeTween:Play()
    outTween.Completed:Once(function()
        ConfirmOverlay.Visible = false
        resetTrashVisual()
        confirmBusy = false
        pendingDeleteMode = nil
        if afterFn then afterFn() end
    end)
end

local function openConfirmDialog(mode)
    if confirmBusy then return end
    if mode == "selected" then
        local count = 0
        for _, v in pairs(selectedIndices) do
            if v then count = count + 1 end
        end
        if count == 0 then return end
        ConfirmTitle.Text = "Xoá mục đã chọn?"
        ConfirmDesc.Text = string.format("%d mục lịch sử sẽ bị xoá vĩnh viễn. Thao tác này không thể hoàn tác.", count)
    elseif mode == "all" then
        if #HistoryRecords == 0 then return end
        ConfirmTitle.Text = "Xoá toàn bộ lịch sử?"
        ConfirmDesc.Text = string.format("Toàn bộ %d mục trong lịch sử pet sẽ bị xoá. Thao tác này không thể hoàn tác.", #HistoryRecords)
    else
        return
    end

    pendingDeleteMode = mode
    resetTrashVisual()
    ConfirmOverlay.Visible = true
    ConfirmCard.Position = UDim2.new(0.5, -137, 0.5, -79)
    TweenService:Create(ConfirmCard, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -137, 0.5, -93)
    }):Play()
end

onButtonClicked(CancelConfirmBtn, function()
    if confirmBusy then return end
    confirmBusy = true
    closeConfirmDialog()
end)

onButtonClicked(OkConfirmBtn, function()
    if confirmBusy or not pendingDeleteMode then return end
    confirmBusy = true

    TweenService:Create(BinLid, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Rotation = -38
    }):Play()
    DocSheet.BackgroundTransparency = 0
    DocSheet.Position = UDim2.new(0.5, -4, 0, 1)

    task.delay(0.25, function()
        if not ConfirmOverlay.Visible then return end
        local dropTween = TweenService:Create(DocSheet, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -4, 0, 18)
        })
        dropTween:Play()
        dropTween.Completed:Once(function()
            DocSheet.BackgroundTransparency = 1
            local lidClose = TweenService:Create(BinLid, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Rotation = 0
            })
            lidClose:Play()
            lidClose.Completed:Once(function()
                local modeToRun = pendingDeleteMode
                closeConfirmDialog(function()
                    if modeToRun == "selected" then
                        local newRecords = {}
                        for idx, record in ipairs(HistoryRecords) do
                            if not selectedIndices[idx] then
                                table.insert(newRecords, record)
                            end
                        end
                        HistoryRecords = newRecords
                        selectedIndices = {}
                    elseif modeToRun == "all" then
                        HistoryRecords = {}
                        selectedIndices = {}
                    end
                    if refreshHistory then refreshHistory() end
                end)
            end)
        end)
    end)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Escape and ConfirmOverlay.Visible and not confirmBusy then
        confirmBusy = true
        closeConfirmDialog()
    end
end)

local Tab2Content = Instance.new("ScrollingFrame")
Tab2Content.Size = UDim2.new(1, -10, 1, -145)
Tab2Content.Position = UDim2.new(0, 5, 0, 102)
Tab2Content.BackgroundTransparency = 1
Tab2Content.Visible = false
Tab2Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Tab2Content.ScrollBarThickness = 4
Tab2Content.Parent = MainFrame

local HistoryLayout = Instance.new("UIListLayout")
HistoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
HistoryLayout.Padding = UDim.new(0, 5)
HistoryLayout.Parent = Tab2Content

local function updateSelectedCountText()
    local count = 0
    for _, v in pairs(selectedIndices) do
        if v then count = count + 1 end
    end
    DeleteSelectedBtn.Text = string.format("Xóa đã chọn (%d)", count)
end

refreshHistory = function()
    for _, child in ipairs(Tab2Content:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local shown = 0
    local q = string.lower(HistorySearch.Text or "")
    for idx, record in ipairs(HistoryRecords) do
        local d = record.data
        local matchesName = (q == "" or string.find(string.lower(d.Name or ""), q, 1, true) ~= nil)

        local matchesFilter = true
        if historyFilterMode == "value" then
            matchesFilter = (q == "" or string.find(string.lower(tostring(d.MoneyPerSec or "")), q, 1, true) ~= nil)
        elseif historyFilterMode == "rarity" then
            matchesFilter = (q == "" or string.find(string.lower(tostring(d.Rarity or "")), q, 1, true) ~= nil)
        end

        local matches = (historyFilterMode == "all") and matchesName or (matchesName and matchesFilter)

        if matches then
            shown = shown + 1
            local itemFrame = Instance.new("Frame")
            itemFrame.Size = UDim2.new(1, -5, 0, 72)
            itemFrame.BackgroundColor3 = selectedIndices[idx] and Color3.fromRGB(60, 40, 45) or Color3.fromRGB(35, 35, 42)
            itemFrame.BorderSizePixel = 0
            itemFrame.LayoutOrder = shown
            itemFrame.Parent = Tab2Content
            Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 6)

            local textLeftOffset = 5

            if isSelectMode then
                textLeftOffset = 32
                local checkBtn = Instance.new("TextButton")
                checkBtn.Size = UDim2.new(0, 22, 0, 22)
                checkBtn.Position = UDim2.new(0, 5, 0.5, -11)
                checkBtn.BackgroundColor3 = selectedIndices[idx] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(55, 55, 65)
                checkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                checkBtn.TextSize = 12
                checkBtn.Font = Enum.Font.GothamBold
                checkBtn.Text = selectedIndices[idx] and "✓" or ""
                checkBtn.Parent = itemFrame
                Instance.new("UICorner", checkBtn).CornerRadius = UDim.new(0, 4)

                onButtonClicked(checkBtn, function()
                    selectedIndices[idx] = not selectedIndices[idx]
                    itemFrame.BackgroundColor3 = selectedIndices[idx] and Color3.fromRGB(60, 40, 45) or Color3.fromRGB(35, 35, 42)
                    checkBtn.BackgroundColor3 = selectedIndices[idx] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(55, 55, 65)
                    checkBtn.Text = selectedIndices[idx] and "✓" or ""
                    updateSelectedCountText()
                end)
            end

            local descLabel = Instance.new("TextLabel")
            descLabel.Size = UDim2.new(1, -textLeftOffset - 5, 1, 0)
            descLabel.Position = UDim2.new(0, textLeftOffset, 0, 0)
            descLabel.BackgroundTransparency = 1
            descLabel.TextColor3 = Color3.fromRGB(230, 230, 240)
            descLabel.TextSize = 11
            descLabel.Font = Enum.Font.Code
            descLabel.TextXAlignment = Enum.TextXAlignment.Left
            descLabel.TextYAlignment = Enum.TextYAlignment.Center
            descLabel.TextWrapped = true
            descLabel.Text = string.format(
                "🐾 %s | ⚖️ %s\n✨ %s | 🧬 %s\n💸 %s\n⏰ %s",
                d.Name or "Pet",
                d.Weight or "Không rõ",
                d.Rarity or "Không rõ",
                d.Mutation or "Mặc định",
                d.MoneyPerSec or "Không rõ",
                record.time
            )
            descLabel.Parent = itemFrame
        end
    end
    Tab2Content.CanvasSize = UDim2.new(0, 0, 0, shown * 77)
    HistoryCountLabel.Text = tostring(#HistoryRecords)
    updateSelectedCountText()
end

onButtonClicked(HistorySelectBtn, function()
    isSelectMode = not isSelectMode
    selectedIndices = {}
    DeleteActionBar.Visible = isSelectMode
    HistorySelectBtn.BackgroundColor3 = isSelectMode and Color3.fromRGB(241, 196, 15) or Color3.fromRGB(200, 50, 50)
    HistorySelectBtn.Text = isSelectMode and "✖" or "🗑️"
    Tab2Content.Size = isSelectMode and UDim2.new(1, -10, 1, -148) or UDim2.new(1, -10, 1, -110)
    refreshHistory()
end)

onButtonClicked(DeleteSelectedBtn, function()
    openConfirmDialog("selected")
end)

onButtonClicked(DeleteAllBtn, function()
    openConfirmDialog("all")
end)

HistorySearch:GetPropertyChangedSignal("Text"):Connect(function()
    refreshHistory()
end)

onButtonClicked(Tab1Btn, function()
    Tab1Content.Visible = true
    Tab2Content.Visible = false
    HistorySearch.Visible = false
    HistoryFilterBtn.Visible = false
    HistorySelectBtn.Visible = false
    HistoryCountLabel.Visible = false
    HistoryFilterPopup.Visible = false
    DeleteActionBar.Visible = false
    ConfirmOverlay.Visible = false
    Tab1Btn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    Tab1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab2Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Tab2Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

onButtonClicked(Tab2Btn, function()
    Tab1Content.Visible = false
    Tab2Content.Visible = true
    HistorySearch.Visible = true
    HistoryFilterBtn.Visible = true
    HistorySelectBtn.Visible = true
    HistoryCountLabel.Visible = true
    DeleteActionBar.Visible = isSelectMode
    Tab2Btn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    Tab2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab1Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Tab1Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    refreshHistory()
end)

-- ==========================================
-- HÀM QUÉT MÀU SẮC & THÔNG TIN THÚ
-- ==========================================
local function getPetRealColor(item, rarityStr)
    for key, val in pairs(item:GetAttributes()) do
        local k = string.lower(key)
        if (string.find(k, "color") or string.find(k, "colour") or string.find(k, "rgb")) and typeof(val) == "Color3" then
            return math.floor(val.R * 255) * 65536 + math.floor(val.G * 255) * 256 + math.floor(val.B * 255)
        end
    end
    for _, child in ipairs(item:GetDescendants()) do
        if child:IsA("BasePart") then
            local col = child.Color
            return math.floor(col.R * 255) * 65536 + math.floor(col.G * 255) * 256 + math.floor(col.B * 255)
        elseif child:IsA("Highlight") and child.FillColor then
            local col = child.FillColor
            return math.floor(col.R * 255) * 65536 + math.floor(col.G * 255) * 256 + math.floor(col.B * 255)
        end
    end
    local r = string.lower(tostring(rarityStr))
    if string.find(r, "sovereign") or string.find(r, "secret") then
        return 16711680
    elseif string.find(r, "mythic") then
        return 11141375
    elseif string.find(r, "legendary") then
        return 16766720
    elseif string.find(r, "epic") then
        return 10181046
    elseif string.find(r, "rare") then
        return 3447003
    else
        return 9807270
    end
end

local function extractPetInfo(item)
    task.wait(0.2)
    local info = {
        Name = item.Name,
        Rarity = "Thường (Common)",
        Mutation = "Mặc định (Normal)",
        RawMoney = nil,
        NumericMoney = 0,
        Weight = "Không rõ",
        NumericWeight = nil
    }

    local function parseWeightString(str)
        if type(str) ~= "string" and type(str) ~= "number" then return nil end
        local s = tostring(str)
        local numMatch = s:match("([%d%.,]+)")
        if numMatch then
            local cleanNum = numMatch:gsub(",", "")
            local num = tonumber(cleanNum)
            if num then
                local formatted = tostring(math.floor(num))
                local k
                repeat
                    formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
                until k == 0
                return formatted .. " kg", num
            end
        end
        return nil, nil
    end

    for key, val in pairs(item:GetAttributes()) do
        local k = string.lower(key)
        local vStr = tostring(val)
        if string.find(k, "weight") or string.find(k, "kg") then
            local formattedW, numW = parseWeightString(vStr)
            if numW then
                info.Weight = formattedW
                info.NumericWeight = numW
            end
        elseif string.find(k, "rarity") or string.find(k, "tier") or string.find(k, "grade") then
            info.Rarity = vStr
        elseif string.find(k, "mut") or string.find(k, "variant") or string.find(k, "rainbow") or string.find(k, "ruby") or string.find(k, "emerald") or string.find(k, "diamond") or string.find(k, "gold") then
            info.Mutation = vStr
        elseif string.find(k, "rate") or string.find(k, "income") or string.find(k, "cps") or string.find(k, "mps") or string.find(k, "sec") or string.find(k, "money") or string.find(k, "cash") or string.find(k, "earn") or string.find(k, "value") or string.find(k, "dps") then
            info.RawMoney = val
        end
    end

    for _, child in ipairs(item:GetDescendants()) do
        local k = string.lower(child.Name)
        if child:IsA("ValueBase") then
            local vStr = tostring(child.Value)
            if (string.find(k, "weight") or string.find(k, "kg")) and info.Weight == "Không rõ" then
                local formattedW, numW = parseWeightString(vStr)
                if numW then
                    info.Weight = formattedW
                    info.NumericWeight = numW
                end
            elseif (string.find(k, "rarity") or string.find(k, "tier")) and info.Rarity == "Thường (Common)" then
                info.Rarity = vStr
            elseif (string.find(k, "mut") or string.find(k, "variant")) and info.Mutation == "Mặc định (Normal)" then
                info.Mutation = vStr
            elseif (string.find(k, "rate") or string.find(k, "income") or string.find(k, "cps") or string.find(k, "sec") or string.find(k, "money") or string.find(k, "cash") or string.find(k, "earn")) and not info.RawMoney then
                info.RawMoney = child.Value
            end
        elseif child:IsA("TextLabel") and child.Text ~= "" then
            local txt = child.Text
            if info.Weight == "Không rõ" and string.find(string.lower(txt), "kg") then
                local formattedW, numW = parseWeightString(txt)
                if numW then
                    info.Weight = formattedW
                    info.NumericWeight = numW
                end
            end
            if string.find(txt, "/s") or string.find(txt, "%$") or string.find(txt, "spd") or string.find(txt, "nod") or string.find(txt, "vg") then
                info.RawMoney = txt
            end
        end
    end

    if info.RawMoney then
        info.NumericMoney = parseRawMoneyToNumber(info.RawMoney)
    end

    local finalMoney = "Không rõ"
    if info.RawMoney then
        finalMoney = formatBigNumber(info.RawMoney)
        if not string.find(finalMoney, "/s") then finalMoney = finalMoney .. "/s" end
    end
    info.MoneyPerSec = finalMoney
    info.EmbedColor = getPetRealColor(item, info.Rarity)
    return info
end

-- ==========================================
-- LỌC THÔNG MINH (CHỈ NHẬN PET)
-- ==========================================
local function isRealPet(item)
    if not item or not item.Parent then return false end
    
    local nameLower = string.lower(item.Name)
    if string.find(nameLower, "food") or string.find(nameLower, "bait") or 
       string.find(nameLower, "apple") or string.find(nameLower, "meat") or 
       string.find(nameLower, "seed") or string.find(nameLower, "treat") or
       string.find(nameLower, "potion") or string.find(nameLower, "egg") or
       string.find(nameLower, "hammer") or string.find(nameLower, "pickaxe") or
       string.find(nameLower, "rod") or string.find(nameLower, "bats") then
        return false
    end

    local hasPetStat = false
    for key, _ in pairs(item:GetAttributes()) do
        local k = string.lower(key)
        if string.find(k, "rate") or string.find(k, "income") or 
           string.find(k, "rarity") or string.find(k, "weight") then
            hasPetStat = true
            break
        end
    end

    if not hasPetStat then
        for _, child in ipairs(item:GetDescendants()) do
            if child:IsA("ValueBase") then
                local k = string.lower(child.Name)
                if string.find(k, "rate") or string.find(k, "income") or 
                   string.find(k, "rarity") or string.find(k, "weight") then
                    hasPetStat = true
                    break
                end
            end
        end
    end

    return hasPetStat
end

-- ==========================================
-- GỬI WEBHOOK & GHI LỊCH SỬ
-- ==========================================
local function sendDiscordWebhook(petData)
    if CURRENT_MIN_MONEY > 0 and petData.NumericMoney < CURRENT_MIN_MONEY then
        return
    end

    petsCaughtCount = petsCaughtCount + 1

    local vnTimeTable = os.date("!*t", os.time() + 25200)
    local vnTimeString = string.format("%02d:%02d:%02d - %02d/%02d/%d",
        vnTimeTable.hour, vnTimeTable.min, vnTimeTable.sec,
        vnTimeTable.day, vnTimeTable.month, vnTimeTable.year)

    table.insert(HistoryRecords, {data = petData, time = vnTimeString})
    if refreshHistory then refreshHistory() end

    if not isRunning then return end

    local playerName = LocalPlayer.Name
    local displayName = LocalPlayer.DisplayName
    local userId = tostring(LocalPlayer.UserId)
    local profileLink = "https://www.roblox.com/users/" .. userId .. "/profile"
    local avatarThumb = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"

    local payload = {
        ["content"] = "<@" .. DiscordUserID .. "> 🎉 Bạn vừa bắt được một sinh vật mới!",
        ["embeds"] = {{
            ["title"] = "🐾 BẮT ĐƯỢC THÚ MỚI: " .. petData.Name,
            ["color"] = petData.EmbedColor,
            ["thumbnail"] = { ["url"] = avatarThumb },
            ["fields"] = {
                { ["name"] = "✨ Độ hiếm (Rarity)", ["value"] = "`" .. petData.Rarity .. "`", ["inline"] = true },
                { ["name"] = "🧬 Đột biến (Mutation)", ["value"] = "`" .. petData.Mutation .. "`", ["inline"] = true },
                { ["name"] = "💸 Tiền / Giây (Income)", ["value"] = "`" .. petData.MoneyPerSec .. "`", ["inline"] = true },
                { ["name"] = "⚖️ Cân nặng", ["value"] = "`" .. (petData.Weight or "Không rõ") .. "`", ["inline"] = true },
                { ["name"] = "👤 Nhân vật Roblox", ["value"] = string.format("[%s (@%s)](%s)\n**ID:** `%s`", displayName, playerName, profileLink, userId), ["inline"] = false }
            },
            ["footer"] = { ["text"] = "Throw Food For Animals • Bắt lúc: " .. vnTimeString },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    pcall(function()
        httpRequest({
            Url = WebhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

-- ==========================================
-- BỘ NHỚ ĐỆM & THEO DÕI TÚI ĐỒ / NHÂN VẬT
-- ==========================================
local function getItemUID(item)
    return item:GetAttribute("UUID") or item:GetAttribute("Id") or item:GetAttribute("ID") or item:GetDebugId() or (item.Name .. tostring(os.clock()))
end

local function handleNewItem(newItem)
    if not newItem or not newItem:IsA("Tool") then return end

    local itemUID = getItemUID(newItem)
    if processedItems[itemUID] then return end
    processedItems[itemUID] = true 

    task.wait(1.5)
    if not newItem.Parent then return end
    if not isRealPet(newItem) then return end

    local petInfo = extractPetInfo(newItem)
    sendDiscordWebhook(petInfo)
end

local function monitorContainer(container)
    if not container then return end
    for _, item in ipairs(container:GetChildren()) do
        if item:IsA("Tool") then
            processedItems[getItemUID(item)] = true
        end
    end
    container.ChildAdded:Connect(handleNewItem)
end

local function setupListeners()
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then monitorContainer(bp) end
    
    local char = LocalPlayer.Character
    if char then monitorContainer(char) end
end

setupListeners()

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    monitorContainer(char)
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then monitorContainer(bp) end
end)

if LocalPlayer:FindFirstChild("Backpack") then
    LocalPlayer.Backpack.ChildAdded:Connect(handleNewItem)
end

-- ==========================================
-- START/STOP BUTTON
-- ==========================================
onButtonClicked(ToggleButton, function()
    isRunning = not isRunning
    syncRunButtons()
end)

-- ==========================================
-- VÒNG LẶP CẬP NHẬT TRẠNG THÁI
-- ==========================================
local frameCount = 0
local lastFpsUpdate = tick()
local currentFps = 60

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastFpsUpdate >= 0.5 then
        currentFps = math.floor(frameCount / (tick() - lastFpsUpdate))
        frameCount = 0
        lastFpsUpdate = tick()
    end

    local vnTime = os.date("!*t", os.time() + 25200)
    local vnClockStr = string.format("%02d:%02d:%02d", vnTime.hour, vnTime.min, vnTime.sec)

    local ping = 0
    pcall(function()
        ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
    end)

    local elapsedSeconds = math.floor(tick() - startTime)
    local h = math.floor(elapsedSeconds / 3600)
    local m = math.floor((elapsedSeconds % 3600) / 60)
    local s = elapsedSeconds % 60
    local runTimeStr = string.format("%02d:%02d:%02d", h, m, s)

    StatusLabel.Text = string.format(
        " ⏱️ Đã chạy: %s | 🇻🇳 %s\n 🎮 Game: %s\n ⚡ FPS: %d | 📶 Ping: %dms",
        runTimeStr, vnClockStr, cachedGameName, currentFps, ping
    )

    if isRunning then
        FooterLabel.Text = string.format("Đã lưu/gửi: %d thú | Trạng thái: 🟢 Đang chạy", petsCaughtCount)
    else
        FooterLabel.Text = string.format("Đã lưu/gửi: %d thú | Trạng thái: 🔴 Đang tạm dừng gửi", petsCaughtCount)
    end

    -- Cập nhật Dynamic Island khi màn hình ngang
    if DynamicIsland.Visible then
        CompactTitle.Text = string.format("🐾 %d Pet", #HistoryRecords)
        CompactTimer.Text = runTimeStr
        local minMoneyStr = CURRENT_MIN_MONEY == 0 and "Tất cả" or (formatBigNumber(CURRENT_MIN_MONEY) .. "+/s")
        ExpandedInfo.Text = string.format(
            "⏱️ %s | ⚡ %d FPS | 📶 %dms\n💰 Lọc: %s | 🐾 Lịch sử: %d",
            runTimeStr, currentFps, ping, minMoneyStr, #HistoryRecords
        )
    end
end)
