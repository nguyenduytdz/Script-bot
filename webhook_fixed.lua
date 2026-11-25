-- ==========================================
-- CẤU HÌNH THÔNG TIN MẶC ĐỊNH
-- ==========================================
local DefaultWebhookURL = "https://discord.com/api/webhooks/1570446166754201803/pPCEG-HczkXcUA2fWQd6pYo62wgLmeBxf1ri812j1AO2W87wWCz1LzoF-6s8tgem5yEo"
local DefaultDiscordUserID = "1494250347731091497"

local WebhookURL = DefaultWebhookURL
local DiscordUserID = DefaultDiscordUserID
local CURRENT_MIN_MONEY = 0
local saveAndSendMode = "both" -- "both" | "save_only" | "send_only"

-- ==========================================
-- KHỞI TẠO DỊCH VỤ & BIẾN TRẠNG THÁI
-- ==========================================
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

local FONT_HEAVY = Enum.Font.GothamBlack
local FONT_BOLD = Enum.Font.GothamBold
local FONT_CODE = Enum.Font.Code

local function getUiParent()
    local ok, cg = pcall(function()
        return game:GetService("CoreGui")
    end)
    if ok and cg then
        local testOk = pcall(function()
            local f = Instance.new("Folder")
            f.Parent = cg
            f:Destroy()
        end)
        if testOk then
            return cg
        end
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local UiParent = getUiParent()

local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local isRunning = true
local startTime = tick()
local petsCaughtCount = 0
local processedItems = {}
local isUiReady = false

local liveActionStatus = "Sẵn sàng - Đang chờ thao tác của bạn"
local liveActionColor = Color3.fromRGB(130, 225, 255)

local function setLiveAction(msg, color)
    liveActionStatus = tostring(msg or "")
    liveActionColor = color or Color3.fromRGB(130, 225, 255)
end

local function getVnTimeString()
    local vnTimeTable = os.date("!*t", os.time() + 25200)
    return string.format("%02d:%02d:%02d - %02d/%02d/%d",
        vnTimeTable.hour, vnTimeTable.min, vnTimeTable.sec,
        vnTimeTable.day, vnTimeTable.month, vnTimeTable.year)
end

local function getVnBlinkingClock()
    local vnTimeTable = os.date("!*t", os.time() + 25200)
    local sep = (vnTimeTable.sec % 2 == 0) and ":" or " "
    return string.format("%02d%s%02d", vnTimeTable.hour, sep, vnTimeTable.min)
end

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
-- TẠO GIAO DIỆN (UI) BAN ĐẦU
-- ==========================================
if UiParent:FindFirstChild("ThrowFoodAutoMenu") then
    UiParent.ThrowFoodAutoMenu:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThrowFoodAutoMenu"
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = UiParent

local function onButtonClicked(btn, callback)
    btn.MouseButton1Click:Connect(callback)
end

local function attachDrag(targetFrame, handleObject)
    handleObject = handleObject or targetFrame
    handleObject.Active = true

    local isDragging = false
    local activeInput = nil
    local dragOrigin = Vector2.zero
    local frameOrigin = UDim2.new()

    handleObject.InputBegan:Connect(function(input)
        if isDragging then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            activeInput = input
            dragOrigin = input.Position
            frameOrigin = targetFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End and input == activeInput then
                    isDragging = false
                    activeInput = nil
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not isDragging or input ~= activeInput then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragOrigin
            targetFrame.Position = UDim2.new(
                frameOrigin.X.Scale,
                frameOrigin.X.Offset + delta.X,
                frameOrigin.Y.Scale,
                frameOrigin.Y.Offset + delta.Y
            )
        end
    end)
end

-- ==========================================
-- HỘP THOẠI HỎI TRƯỚC KHI XÓA
-- ==========================================
local ConfirmOverlay = Instance.new("Frame")
ConfirmOverlay.Name = "DeleteConfirmOverlay"
ConfirmOverlay.Size = UDim2.new(1, 0, 1, 0)
ConfirmOverlay.Position = UDim2.new(0, 0, 0, 0)
ConfirmOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ConfirmOverlay.BackgroundTransparency = 0.45
ConfirmOverlay.BorderSizePixel = 0
ConfirmOverlay.Visible = false
ConfirmOverlay.ZIndex = 110
ConfirmOverlay.Parent = ScreenGui

local ConfirmCard = Instance.new("Frame")
ConfirmCard.Name = "u436Dialog"
ConfirmCard.AnchorPoint = Vector2.new(0.5, 0.5)
ConfirmCard.Size = UDim2.new(0, 286, 0, 214)
ConfirmCard.Position = UDim2.new(0.5, 0, 0.5, 0)
ConfirmCard.BackgroundColor3 = Color3.fromRGB(26, 27, 37)
ConfirmCard.BorderSizePixel = 0
ConfirmCard.ZIndex = 112
ConfirmCard.Parent = ConfirmOverlay
Instance.new("UICorner", ConfirmCard).CornerRadius = UDim.new(0, 18)

local ConfirmCardStroke = Instance.new("UIStroke")
ConfirmCardStroke.Color = Color3.fromRGB(255, 255, 255)
ConfirmCardStroke.Transparency = 0.8
ConfirmCardStroke.Thickness = 1.2
ConfirmCardStroke.Parent = ConfirmCard

local ConfirmTitle = Instance.new("TextLabel")
ConfirmTitle.Size = UDim2.new(1, -32, 0, 24)
ConfirmTitle.Position = UDim2.new(0, 16, 0, 16)
ConfirmTitle.BackgroundTransparency = 1
ConfirmTitle.Text = "Xóa mục này?"
ConfirmTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmTitle.TextSize = 15
ConfirmTitle.Font = FONT_HEAVY
ConfirmTitle.TextXAlignment = Enum.TextXAlignment.Left
ConfirmTitle.ZIndex = 113
ConfirmTitle.Parent = ConfirmCard

local ConfirmDesc = Instance.new("TextLabel")
ConfirmDesc.Size = UDim2.new(1, -32, 0, 52)
ConfirmDesc.Position = UDim2.new(0, 16, 0, 46)
ConfirmDesc.BackgroundTransparency = 1
ConfirmDesc.Text = "Dữ liệu đã chọn sẽ bị xóa khỏi lịch sử. Hành động này không thể hoàn tác."
ConfirmDesc.TextColor3 = Color3.fromRGB(220, 224, 238)
ConfirmDesc.TextSize = 11
ConfirmDesc.Font = FONT_BOLD
ConfirmDesc.TextWrapped = true
ConfirmDesc.TextXAlignment = Enum.TextXAlignment.Left
ConfirmDesc.TextYAlignment = Enum.TextYAlignment.Top
ConfirmDesc.ZIndex = 113
ConfirmDesc.Parent = ConfirmCard

local ConfirmCancelBtn = Instance.new("TextButton")
ConfirmCancelBtn.Size = UDim2.new(0.5, -20, 0, 38)
ConfirmCancelBtn.Position = UDim2.new(0, 16, 1, -52)
ConfirmCancelBtn.BackgroundColor3 = Color3.fromRGB(44, 47, 64)
ConfirmCancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmCancelBtn.Text = "Hủy"
ConfirmCancelBtn.TextSize = 12
ConfirmCancelBtn.Font = FONT_HEAVY
ConfirmCancelBtn.ZIndex = 114
ConfirmCancelBtn.Parent = ConfirmCard
Instance.new("UICorner", ConfirmCancelBtn).CornerRadius = UDim.new(0, 10)

local ConfirmDeleteBtn = Instance.new("TextButton")
ConfirmDeleteBtn.Size = UDim2.new(0.5, -20, 0, 38)
ConfirmDeleteBtn.Position = UDim2.new(0.5, 4, 1, -52)
ConfirmDeleteBtn.BackgroundColor3 = Color3.fromRGB(229, 72, 77)
ConfirmDeleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmDeleteBtn.Text = "Xóa"
ConfirmDeleteBtn.TextSize = 12
ConfirmDeleteBtn.Font = FONT_HEAVY
ConfirmDeleteBtn.ZIndex = 114
ConfirmDeleteBtn.Parent = ConfirmCard
Instance.new("UICorner", ConfirmDeleteBtn).CornerRadius = UDim.new(0, 10)

local pendingDeleteCallback = nil
local isConfirmBusy = false

local function closeConfirmDialog()
    isConfirmBusy = false
    pendingDeleteCallback = nil
    ConfirmOverlay.Visible = false
    ConfirmDeleteBtn.Text = "Xóa"
end

local function promptDeleteConfirm(titleText, descText, onConfirmed)
    if isConfirmBusy then return end
    pendingDeleteCallback = onConfirmed
    ConfirmTitle.Text = titleText or "Xác nhận xóa?"
    ConfirmDesc.Text = descText or "Hành động này sẽ xóa dữ liệu đã chọn."
    ConfirmDeleteBtn.Text = "Xóa"
    ConfirmOverlay.Visible = true
end

onButtonClicked(ConfirmCancelBtn, function()
    if isConfirmBusy then return end
    setLiveAction("Đã hủy xóa lịch sử", Color3.fromRGB(185, 190, 210))
    closeConfirmDialog()
end)

onButtonClicked(ConfirmDeleteBtn, function()
    if isConfirmBusy then return end
    isConfirmBusy = true
    ConfirmDeleteBtn.Text = "Đang xóa..."
    task.delay(0.2, function()
        if pendingDeleteCallback then
            pcall(pendingDeleteCallback)
        end
        closeConfirmDialog()
    end)
end)

-- ==========================================
-- GHI CHÚ NỔI TRÊN MÀN HÌNH
-- ==========================================
local DisplayContainer = Instance.new("Frame")
DisplayContainer.Name = "ScreenNoteDisplay"
DisplayContainer.Size = UDim2.new(0, 260, 0, 48)
DisplayContainer.Position = UDim2.new(0.5, -130, 0.14, 0)
DisplayContainer.BackgroundTransparency = 1
DisplayContainer.Active = true
DisplayContainer.Visible = false
DisplayContainer.ZIndex = 65
DisplayContainer.Parent = ScreenGui

local DisplayLabel = Instance.new("TextLabel")
DisplayLabel.Name = "NoteText"
DisplayLabel.Size = UDim2.new(1, 0, 1, 0)
DisplayLabel.BackgroundTransparency = 1
DisplayLabel.Text = "Ghi chú của bạn..."
DisplayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DisplayLabel.TextSize = 20
DisplayLabel.Font = FONT_HEAVY
DisplayLabel.TextWrapped = true
DisplayLabel.RichText = true
DisplayLabel.ZIndex = 66
DisplayLabel.Parent = DisplayContainer

local TextStroke = Instance.new("UIStroke")
TextStroke.Thickness = 2.5
TextStroke.Color = Color3.fromRGB(0, 0, 0)
TextStroke.Parent = DisplayLabel

attachDrag(DisplayContainer, DisplayLabel)

-- ==========================================
-- CỤM 2 ICON NỔI RIÊNG BIỆT: ⚡ VÀ 💬
-- ==========================================
local FloatingDock = Instance.new("Frame")
FloatingDock.Name = "FloatingIconDock"
FloatingDock.Size = UDim2.new(0, 92, 0, 42)
FloatingDock.Position = UDim2.new(0.04, 0, 0.13, 0)
FloatingDock.BackgroundTransparency = 1
FloatingDock.Visible = false
FloatingDock.ZIndex = 22
FloatingDock.Parent = ScreenGui

local DockLayout = Instance.new("UIListLayout")
DockLayout.FillDirection = Enum.FillDirection.Horizontal
DockLayout.SortOrder = Enum.SortOrder.LayoutOrder
DockLayout.VerticalAlignment = Enum.VerticalAlignment.Center
DockLayout.Padding = UDim.new(0, 8)
DockLayout.Parent = FloatingDock

local ToggleIconBtn = Instance.new("TextButton")
ToggleIconBtn.Name = "ToggleIconBtn"
ToggleIconBtn.LayoutOrder = 1
ToggleIconBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleIconBtn.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
ToggleIconBtn.TextColor3 = Color3.fromRGB(255, 220, 50)
ToggleIconBtn.TextSize = 20
ToggleIconBtn.Font = FONT_HEAVY
ToggleIconBtn.Text = "⚡"
ToggleIconBtn.Active = true
ToggleIconBtn.ZIndex = 24
ToggleIconBtn.Parent = FloatingDock
Instance.new("UICorner", ToggleIconBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(255, 200, 40)
IconStroke.Thickness = 2
IconStroke.Parent = ToggleIconBtn

local ChatIconBtn = Instance.new("TextButton")
ChatIconBtn.Name = "ChatIconBtn"
ChatIconBtn.LayoutOrder = 2
ChatIconBtn.Size = UDim2.new(0, 40, 0, 40)
ChatIconBtn.BackgroundColor3 = Color3.fromRGB(24, 118, 242)
ChatIconBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ChatIconBtn.TextSize = 19
ChatIconBtn.Font = FONT_HEAVY
ChatIconBtn.Text = "💬"
ChatIconBtn.Active = true
ChatIconBtn.ZIndex = 24
ChatIconBtn.Parent = FloatingDock
Instance.new("UICorner", ChatIconBtn).CornerRadius = UDim.new(1, 0)
local ChatIconStroke = Instance.new("UIStroke")
ChatIconStroke.Color = Color3.fromRGB(140, 205, 255)
ChatIconStroke.Thickness = 2
ChatIconStroke.Parent = ChatIconBtn

attachDrag(FloatingDock, ToggleIconBtn)

-- ==========================================
-- MENU CHÍNH ĐÃ THU GỌN (292 x 312)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 292, 0, 312)
MainFrame.Position = UDim2.new(0.04, 0, 0.21, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(123, 97, 255)
MainStroke.Transparency = 0.35
MainStroke.Thickness = 1.4
MainStroke.Parent = MainFrame

local isMenuVisible = true
onButtonClicked(ToggleIconBtn, function()
    if not isUiReady then return end
    isMenuVisible = not isMenuVisible
    MainFrame.Visible = isMenuVisible
    setLiveAction(isMenuVisible and "Đã mở giao diện chính" or "Đã thu gọn giao diện", Color3.fromRGB(255, 225, 110))
    TweenService:Create(ToggleIconBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Rotation = ToggleIconBtn.Rotation + 360
    }):Play()
end)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -12, 0, 24)
TitleLabel.Position = UDim2.new(0, 6, 0, 3)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🐾 THROW FOOD HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 12
TitleLabel.Font = FONT_HEAVY
TitleLabel.ZIndex = 11
TitleLabel.Parent = MainFrame

-- THANH TAB BÊN DƯỚI (GỒM TAB HUB MỚI)
local BottomTabBar = Instance.new("ScrollingFrame")
BottomTabBar.Name = "BottomTabBar"
BottomTabBar.Size = UDim2.new(1, -10, 0, 32)
BottomTabBar.Position = UDim2.new(0, 5, 1, -37)
BottomTabBar.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
BottomTabBar.BorderSizePixel = 0
BottomTabBar.ScrollingDirection = Enum.ScrollingDirection.X
BottomTabBar.ScrollBarThickness = 2
BottomTabBar.ScrollBarImageColor3 = Color3.fromRGB(130, 150, 200)
BottomTabBar.CanvasSize = UDim2.new(0, 396, 0, 0)
BottomTabBar.ZIndex = 14
BottomTabBar.Parent = MainFrame
Instance.new("UICorner", BottomTabBar).CornerRadius = UDim.new(0, 9)

local TabBarLayout = Instance.new("UIListLayout")
TabBarLayout.FillDirection = Enum.FillDirection.Horizontal
TabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabBarLayout.Padding = UDim.new(0, 4)
TabBarLayout.Parent = BottomTabBar

local TabBarPad = Instance.new("UIPadding")
TabBarPad.PaddingLeft = UDim.new(0, 4)
TabBarPad.PaddingRight = UDim.new(0, 4)
TabBarPad.Parent = BottomTabBar

local function makeBottomTabBtn(order, text)
    local b = Instance.new("TextButton")
    b.LayoutOrder = order
    b.Size = UDim2.new(0, 60, 0, 24)
    b.BackgroundColor3 = Color3.fromRGB(40, 42, 56)
    b.TextColor3 = Color3.fromRGB(235, 240, 255)
    b.TextSize = 8
    b.Font = FONT_HEAVY
    b.Text = text
    b.ZIndex = 16
    b.Parent = BottomTabBar
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local TabHomeBtn = makeBottomTabBtn(1, "🏠 Home")
local TabHopBtn = makeBottomTabBtn(2, "🌐 Hop")
local TabHubBtn = makeBottomTabBtn(3, "🚀 Hub")
local TabHistoryBtn = makeBottomTabBtn(4, "📜 Lịch sử")
local TabSettingsBtn = makeBottomTabBtn(5, "⚙️ Update")
local TabNoteBtn = makeBottomTabBtn(6, "📝 Ghi chú")

-- ==========================================
-- CỬA SỔ GIAO DIỆN ỨNG DỤNG NHẮN TIN (KHI BẤM 💬)
-- ==========================================
local ChatAppFrame = Instance.new("Frame")
ChatAppFrame.Name = "MessagingAppWindow"
ChatAppFrame.Size = UDim2.new(0, 276, 0, 326)
ChatAppFrame.Position = UDim2.new(0.5, -138, 0.2, 0)
ChatAppFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 25)
ChatAppFrame.BorderSizePixel = 0
ChatAppFrame.Active = true
ChatAppFrame.Draggable = true
ChatAppFrame.Visible = false
ChatAppFrame.ZIndex = 75
ChatAppFrame.Parent = ScreenGui
Instance.new("UICorner", ChatAppFrame).CornerRadius = UDim.new(0, 18)
local ChatWindowStroke = Instance.new("UIStroke")
ChatWindowStroke.Color = Color3.fromRGB(45, 136, 255)
ChatWindowStroke.Thickness = 1.5
ChatWindowStroke.Parent = ChatAppFrame

local ChatHeader = Instance.new("Frame")
ChatHeader.Size = UDim2.new(1, 0, 0, 44)
ChatHeader.Position = UDim2.new(0, 0, 0, 0)
ChatHeader.BackgroundColor3 = Color3.fromRGB(26, 30, 44)
ChatHeader.BorderSizePixel = 0
ChatHeader.ZIndex = 76
ChatHeader.Parent = ChatAppFrame
Instance.new("UICorner", ChatHeader).CornerRadius = UDim.new(0, 18)

local ChatTitleLbl = Instance.new("TextLabel")
ChatTitleLbl.Size = UDim2.new(1, -80, 1, 0)
ChatTitleLbl.Position = UDim2.new(0, 14, 0, 0)
ChatTitleLbl.BackgroundTransparency = 1
ChatTitleLbl.Text = "💬 TIN NHẮN NHANH"
ChatTitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
ChatTitleLbl.TextSize = 12
ChatTitleLbl.Font = FONT_HEAVY
ChatTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
ChatTitleLbl.ZIndex = 77
ChatTitleLbl.Parent = ChatHeader

local ChatSubLbl = Instance.new("TextLabel")
ChatSubLbl.Size = UDim2.new(1, -80, 0, 14)
ChatSubLbl.Position = UDim2.new(0, 14, 0, 24)
ChatSubLbl.BackgroundTransparency = 1
ChatSubLbl.Text = "● Đang hoạt động"
ChatSubLbl.TextColor3 = Color3.fromRGB(68, 224, 125)
ChatSubLbl.TextSize = 9
ChatSubLbl.Font = FONT_BOLD
ChatSubLbl.TextXAlignment = Enum.TextXAlignment.Left
ChatSubLbl.ZIndex = 77
ChatSubLbl.Parent = ChatHeader

ChatTitleLbl.Position = UDim2.new(0, 14, 0, 4)
ChatTitleLbl.Size = UDim2.new(1, -80, 0, 20)

local ChatCloseBtn = Instance.new("TextButton")
ChatCloseBtn.Size = UDim2.new(0, 28, 0, 28)
ChatCloseBtn.Position = UDim2.new(1, -38, 0.5, -14)
ChatCloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 75)
ChatCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ChatCloseBtn.Text = "✕"
ChatCloseBtn.TextSize = 12
ChatCloseBtn.Font = FONT_HEAVY
ChatCloseBtn.ZIndex = 78
ChatCloseBtn.Parent = ChatHeader
Instance.new("UICorner", ChatCloseBtn).CornerRadius = UDim.new(1, 0)

local ChatScroll = Instance.new("ScrollingFrame")
ChatScroll.Size = UDim2.new(1, -14, 1, -96)
ChatScroll.Position = UDim2.new(0, 7, 0, 48)
ChatScroll.BackgroundColor3 = Color3.fromRGB(20, 23, 33)
ChatScroll.BorderSizePixel = 0
ChatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ChatScroll.ScrollBarThickness = 4
ChatScroll.ZIndex = 76
ChatScroll.Parent = ChatAppFrame
Instance.new("UICorner", ChatScroll).CornerRadius = UDim.new(0, 12)

local ChatScrollLayout = Instance.new("UIListLayout")
ChatScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ChatScrollLayout.Padding = UDim.new(0, 6)
ChatScrollLayout.Parent = ChatScroll

local ChatScrollPad = Instance.new("UIPadding")
ChatScrollPad.PaddingTop = UDim.new(0, 6)
ChatScrollPad.PaddingBottom = UDim.new(0, 6)
ChatScrollPad.PaddingLeft = UDim.new(0, 6)
ChatScrollPad.PaddingRight = UDim.new(0, 6)
ChatScrollPad.Parent = ChatScroll

local ChatInputBar = Instance.new("Frame")
ChatInputBar.Size = UDim2.new(1, -14, 0, 38)
ChatInputBar.Position = UDim2.new(0, 7, 1, -44)
ChatInputBar.BackgroundColor3 = Color3.fromRGB(28, 32, 46)
ChatInputBar.BorderSizePixel = 0
ChatInputBar.ZIndex = 76
ChatInputBar.Parent = ChatAppFrame
Instance.new("UICorner", ChatInputBar).CornerRadius = UDim.new(0, 14)

local ChatInputBox = Instance.new("TextBox")
ChatInputBox.Size = UDim2.new(1, -66, 1, -6)
ChatInputBox.Position = UDim2.new(0, 8, 0, 3)
ChatInputBox.BackgroundTransparency = 1
ChatInputBox.Text = ""
ChatInputBox.PlaceholderText = "Nhắn tin..."
ChatInputBox.PlaceholderColor3 = Color3.fromRGB(150, 160, 185)
ChatInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ChatInputBox.TextSize = 10
ChatInputBox.Font = FONT_BOLD
ChatInputBox.TextXAlignment = Enum.TextXAlignment.Left
ChatInputBox.ClearTextOnFocus = false
ChatInputBox.ZIndex = 77
ChatInputBox.Parent = ChatInputBar

local ChatSendBtn = Instance.new("TextButton")
ChatSendBtn.Size = UDim2.new(0, 52, 0, 28)
ChatSendBtn.Position = UDim2.new(1, -57, 0.5, -14)
ChatSendBtn.BackgroundColor3 = Color3.fromRGB(24, 118, 242)
ChatSendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ChatSendBtn.Text = "Gửi"
ChatSendBtn.TextSize = 10
ChatSendBtn.Font = FONT_HEAVY
ChatSendBtn.ZIndex = 78
ChatSendBtn.Parent = ChatInputBar
Instance.new("UICorner", ChatSendBtn).CornerRadius = UDim.new(0, 10)

local chatOrderCounter = 0
local function addMessageBubble(senderName, text, isOutgoing)
    chatOrderCounter = chatOrderCounter + 1
    local bubble = Instance.new("Frame")
    bubble.LayoutOrder = chatOrderCounter
    bubble.Size = UDim2.new(0.84, 0, 0, 42)
    bubble.Position = UDim2.new(isOutgoing and 0.16 or 0, 0, 0, 0)
    bubble.BackgroundColor3 = isOutgoing and Color3.fromRGB(24, 118, 242) or Color3.fromRGB(42, 46, 64)
    bubble.BorderSizePixel = 0
    bubble.ZIndex = 77
    bubble.Parent = ChatScroll
    Instance.new("UICorner", bubble).CornerRadius = UDim.new(0, 12)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -12, 1, -4)
    lbl.Position = UDim2.new(0, 6, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 10
    lbl.Font = FONT_BOLD
    lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Center
    lbl.Text = (isOutgoing and "" or (senderName .. ": ")) .. tostring(text)
    lbl.ZIndex = 78
    lbl.Parent = bubble

    task.defer(function()
        local h = math.max(32, lbl.TextBounds.Y + 12)
        bubble.Size = UDim2.new(0.84, 0, 0, h)
        ChatScroll.CanvasSize = UDim2.new(0, 0, 0, ChatScrollLayout.AbsoluteContentSize.Y + 16)
        ChatScroll.CanvasPosition = Vector2.new(0, math.max(0, ChatScroll.CanvasSize.Y.Offset - ChatScroll.AbsoluteSize.Y))
    end)
end

addMessageBubble("Hệ thống", "Chào bạn! Đây là khung chat mini.", false)
addMessageBubble("Hệ thống", "Gõ tin nhắn rồi bấm Gửi hoặc nhấn Enter.", false)

local function sendChatMessage()
    local msg = tostring(ChatInputBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if msg == "" then return end
    ChatInputBox.Text = ""
    addMessageBubble("Bạn", msg, true)
    pcall(function()
        local tcs = game:GetService("TextChatService")
        if tcs.ChatVersion == Enum.ChatVersion.TextChatService then
            local channels = tcs:FindFirstChild("TextChannels")
            local general = channels and channels:FindFirstChild("RBXGeneral")
            if general then
                general:SendAsync(msg)
            end
        else
            local chatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            local sayMsg = chatEvents and chatEvents:FindFirstChild("SayMessageRequest")
            if sayMsg then
                sayMsg:FireServer(msg, "All")
            end
        end
    end)
    setLiveAction("Đã gửi tin nhắn: " .. msg:sub(1, 18), Color3.fromRGB(68, 224, 125))
end

onButtonClicked(ChatSendBtn, sendChatMessage)
ChatInputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        sendChatMessage()
    end
end)

onButtonClicked(ChatIconBtn, function()
    ChatAppFrame.Visible = not ChatAppFrame.Visible
    setLiveAction(ChatAppFrame.Visible and "Đã mở giao diện nhắn tin" or "Đã đóng giao diện nhắn tin", Color3.fromRGB(90, 185, 255))
end)

onButtonClicked(ChatCloseBtn, function()
    ChatAppFrame.Visible = false
end)

-- ==========================================
-- DYNAMIC ISLAND: CHỈ GIỜ VN MÀU VÀNG BÊN PHẢI, DẤU : NHẤP NHÁY TỪNG GIÂY
-- ==========================================
local DynamicIsland = Instance.new("Frame")
DynamicIsland.Name = "u459DynamicIsland"
DynamicIsland.AnchorPoint = Vector2.new(0.5, 0)
DynamicIsland.Position = UDim2.new(0.5, 0, 0, 6)
DynamicIsland.Size = UDim2.new(0, 160, 0, 34)
DynamicIsland.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DynamicIsland.BorderSizePixel = 0
DynamicIsland.Visible = true
DynamicIsland.ZIndex = 80
DynamicIsland.Parent = ScreenGui
Instance.new("UICorner", DynamicIsland).CornerRadius = UDim.new(0, 17)

local IslandStroke = Instance.new("UIStroke")
IslandStroke.Color = Color3.fromRGB(255, 220, 50)
IslandStroke.Transparency = 0.55
IslandStroke.Thickness = 1.2
IslandStroke.Parent = DynamicIsland

local IslandVnClockLabel = Instance.new("TextLabel")
IslandVnClockLabel.Size = UDim2.new(1, -20, 1, 0)
IslandVnClockLabel.Position = UDim2.new(0, 10, 0, 0)
IslandVnClockLabel.BackgroundTransparency = 1
IslandVnClockLabel.Text = "00:00"
IslandVnClockLabel.TextColor3 = Color3.fromRGB(255, 220, 50)
IslandVnClockLabel.TextSize = 20
IslandVnClockLabel.Font = FONT_HEAVY
IslandVnClockLabel.TextXAlignment = Enum.TextXAlignment.Right
IslandVnClockLabel.TextYAlignment = Enum.TextYAlignment.Center
IslandVnClockLabel.ZIndex = 82
IslandVnClockLabel.Parent = DynamicIsland

-- ==========================================
-- INTRO
-- ==========================================
local IntroRectFrame = Instance.new("Frame")
IntroRectFrame.Name = "IntroHorizontalRect"
IntroRectFrame.AnchorPoint = Vector2.new(0.5, 0.5)
IntroRectFrame.Size = UDim2.new(0, 320, 0, 130)
IntroRectFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
IntroRectFrame.BackgroundColor3 = Color3.fromRGB(10, 16, 28)
IntroRectFrame.BorderSizePixel = 0
IntroRectFrame.ZIndex = 90
IntroRectFrame.Parent = ScreenGui
Instance.new("UICorner", IntroRectFrame).CornerRadius = UDim.new(0, 16)
local IntroStroke = Instance.new("UIStroke")
IntroStroke.Color = Color3.fromRGB(115, 195, 255)
IntroStroke.Thickness = 1.5
IntroStroke.Parent = IntroRectFrame

local IntroLabel = Instance.new("TextLabel")
IntroLabel.Size = UDim2.new(1, -20, 0, 22)
IntroLabel.Position = UDim2.new(0, 10, 0, 10)
IntroLabel.BackgroundTransparency = 1
IntroLabel.Text = "✦ INTRO ORBIT CORE"
IntroLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
IntroLabel.TextSize = 12
IntroLabel.Font = FONT_HEAVY
IntroLabel.TextXAlignment = Enum.TextXAlignment.Left
IntroLabel.ZIndex = 91
IntroLabel.Parent = IntroRectFrame

local IntroBarBg = Instance.new("Frame")
IntroBarBg.Size = UDim2.new(1, -20, 0, 8)
IntroBarBg.Position = UDim2.new(0, 10, 0, 58)
IntroBarBg.BackgroundColor3 = Color3.fromRGB(22, 30, 48)
IntroBarBg.BorderSizePixel = 0
IntroBarBg.ZIndex = 91
IntroBarBg.Parent = IntroRectFrame
Instance.new("UICorner", IntroBarBg).CornerRadius = UDim.new(1, 0)

local IntroBarFill = Instance.new("Frame")
IntroBarFill.Size = UDim2.new(0, 0, 1, 0)
IntroBarFill.BackgroundColor3 = Color3.fromRGB(255, 220, 50)
IntroBarFill.BorderSizePixel = 0
IntroBarFill.ZIndex = 92
IntroBarFill.Parent = IntroBarBg
Instance.new("UICorner", IntroBarFill).CornerRadius = UDim.new(1, 0)

local IntroSubLabel = Instance.new("TextLabel")
IntroSubLabel.Size = UDim2.new(1, -20, 0, 22)
IntroSubLabel.Position = UDim2.new(0, 10, 0, 78)
IntroSubLabel.BackgroundTransparency = 1
IntroSubLabel.Text = "Đang tải giao diện... 0%"
IntroSubLabel.TextColor3 = Color3.fromRGB(235, 245, 255)
IntroSubLabel.TextSize = 11
IntroSubLabel.Font = FONT_HEAVY
IntroSubLabel.TextXAlignment = Enum.TextXAlignment.Left
IntroSubLabel.ZIndex = 91
IntroSubLabel.Parent = IntroRectFrame

local openTab

local introElapsed = 0
local introDuration = 1.6
local introConn
introConn = RunService.Heartbeat:Connect(function(dt)
    introElapsed = introElapsed + dt
    local ratio = math.clamp(introElapsed / introDuration, 0, 1)
    IntroBarFill.Size = UDim2.new(ratio, 0, 1, 0)
    IntroSubLabel.Text = string.format("Đang tải giao diện... %d%%", math.floor(ratio * 100))

    if ratio >= 1 then
        if introConn then introConn:Disconnect() end
        if IntroRectFrame then
            IntroRectFrame:Destroy()
        end
        isUiReady = true
        if openTab then openTab("home") end
        FloatingDock.Visible = true
        MainFrame.Visible = true
        isMenuVisible = true
        setLiveAction("Đã tải xong menu - Sẵn sàng hoạt động", Color3.fromRGB(46, 204, 113))
    end
end)

local CONTENT_TOP_Y = 30
local CONTENT_HEIGHT = 240

-- ==========================================
-- TAB HOME
-- ==========================================
local HomeContent = Instance.new("ScrollingFrame")
HomeContent.Size = UDim2.new(1, -12, 0, CONTENT_HEIGHT)
HomeContent.Position = UDim2.new(0, 6, 0, CONTENT_TOP_Y)
HomeContent.BackgroundTransparency = 1
HomeContent.BorderSizePixel = 0
HomeContent.CanvasSize = UDim2.new(0, 0, 0, 235)
HomeContent.ScrollBarThickness = 4
HomeContent.ScrollBarImageColor3 = Color3.fromRGB(145, 160, 205)
HomeContent.Visible = true
HomeContent.ZIndex = 12
HomeContent.Parent = MainFrame

local HomeInfoCard = Instance.new("TextLabel")
HomeInfoCard.Size = UDim2.new(1, -6, 0, 86)
HomeInfoCard.Position = UDim2.new(0, 0, 0, 0)
HomeInfoCard.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
HomeInfoCard.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeInfoCard.TextSize = 11
HomeInfoCard.Font = FONT_HEAVY
HomeInfoCard.TextWrapped = true
HomeInfoCard.TextXAlignment = Enum.TextXAlignment.Left
HomeInfoCard.TextYAlignment = Enum.TextYAlignment.Top
HomeInfoCard.Text = " 🏠 TỔNG QUAN HỆ THỐNG\n Đang tải thông tin server..."
HomeInfoCard.ZIndex = 13
HomeInfoCard.Parent = HomeContent
Instance.new("UICorner", HomeInfoCard).CornerRadius = UDim.new(0, 8)

local HomeJobBox = Instance.new("TextBox")
HomeJobBox.Size = UDim2.new(1, -6, 0, 28)
HomeJobBox.Position = UDim2.new(0, 0, 0, 92)
HomeJobBox.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
HomeJobBox.TextColor3 = Color3.fromRGB(125, 220, 255)
HomeJobBox.TextSize = 10
HomeJobBox.Font = FONT_HEAVY
HomeJobBox.TextEditable = false
HomeJobBox.ClearTextOnFocus = false
HomeJobBox.Text = tostring(game.JobId ~= "" and game.JobId or "Studio / Local")
HomeJobBox.ZIndex = 13
HomeJobBox.Parent = HomeContent
Instance.new("UICorner", HomeJobBox).CornerRadius = UDim.new(0, 7)

local HomeCopyJobBtn = Instance.new("TextButton")
HomeCopyJobBtn.Size = UDim2.new(1, -6, 0, 30)
HomeCopyJobBtn.Position = UDim2.new(0, 0, 0, 126)
HomeCopyJobBtn.BackgroundColor3 = Color3.fromRGB(61, 139, 255)
HomeCopyJobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeCopyJobBtn.TextSize = 10
HomeCopyJobBtn.Font = FONT_HEAVY
HomeCopyJobBtn.Text = "📋 COPY JOBID SEVER HIỆN TẠI"
HomeCopyJobBtn.ZIndex = 13
HomeCopyJobBtn.Parent = HomeContent
Instance.new("UICorner", HomeCopyJobBtn).CornerRadius = UDim.new(0, 8)

local HomeQuickHopBtn = Instance.new("TextButton")
HomeQuickHopBtn.Size = UDim2.new(1, -6, 0, 30)
HomeQuickHopBtn.Position = UDim2.new(0, 0, 0, 162)
HomeQuickHopBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
HomeQuickHopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeQuickHopBtn.TextSize = 10
HomeQuickHopBtn.Font = FONT_HEAVY
HomeQuickHopBtn.Text = "🌐 MỞ TAB HOP SEVER"
HomeQuickHopBtn.ZIndex = 13
HomeQuickHopBtn.Parent = HomeContent
Instance.new("UICorner", HomeQuickHopBtn).CornerRadius = UDim.new(0, 8)

-- ==========================================
-- TAB HOP SEVER (CHỮ ĐẬM RÕ Ở MỤC TÌM SERVER)
-- ==========================================
local HopContent = Instance.new("ScrollingFrame")
HopContent.Size = UDim2.new(1, -12, 0, CONTENT_HEIGHT)
HopContent.Position = UDim2.new(0, 6, 0, CONTENT_TOP_Y)
HopContent.BackgroundTransparency = 1
HopContent.BorderSizePixel = 0
HopContent.ScrollingDirection = Enum.ScrollingDirection.Y
HopContent.CanvasSize = UDim2.new(0, 0, 0, 330)
HopContent.ScrollBarThickness = 4
HopContent.ScrollBarImageColor3 = Color3.fromRGB(145, 160, 205)
HopContent.Visible = false
HopContent.ZIndex = 12
HopContent.Parent = MainFrame

local HopStatusLabel = Instance.new("TextLabel")
HopStatusLabel.Size = UDim2.new(1, -6, 0, 32)
HopStatusLabel.Position = UDim2.new(0, 0, 0, 0)
HopStatusLabel.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
HopStatusLabel.TextColor3 = Color3.fromRGB(255, 240, 140)
HopStatusLabel.TextSize = 10
HopStatusLabel.Font = FONT_HEAVY
HopStatusLabel.TextWrapped = true
HopStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
HopStatusLabel.TextYAlignment = Enum.TextYAlignment.Center
HopStatusLabel.Text = " 🌐 CHỌN LOẠI SEVER ĐỂ TÌM DANH SÁCH"
HopStatusLabel.ZIndex = 13
HopStatusLabel.Parent = HopContent
Instance.new("UICorner", HopStatusLabel).CornerRadius = UDim.new(0, 7)

local Hop1PlayerBtn = Instance.new("TextButton")
Hop1PlayerBtn.Size = UDim2.new(0.32, -3, 0, 26)
Hop1PlayerBtn.Position = UDim2.new(0, 0, 0, 36)
Hop1PlayerBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
Hop1PlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Hop1PlayerBtn.TextSize = 9
Hop1PlayerBtn.Font = FONT_HEAVY
Hop1PlayerBtn.Text = "👤 1 NGƯỜI"
Hop1PlayerBtn.ZIndex = 13
Hop1PlayerBtn.Parent = HopContent
Instance.new("UICorner", Hop1PlayerBtn).CornerRadius = UDim.new(0, 6)

local HopLowPingBtn = Instance.new("TextButton")
HopLowPingBtn.Size = UDim2.new(0.32, -3, 0, 26)
HopLowPingBtn.Position = UDim2.new(0.34, -1, 0, 36)
HopLowPingBtn.BackgroundColor3 = Color3.fromRGB(61, 139, 255)
HopLowPingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopLowPingBtn.TextSize = 9
HopLowPingBtn.Font = FONT_HEAVY
HopLowPingBtn.Text = "⚡ PING THẤP"
HopLowPingBtn.ZIndex = 13
HopLowPingBtn.Parent = HopContent
Instance.new("UICorner", HopLowPingBtn).CornerRadius = UDim.new(0, 6)

local HopOldServerBtn = Instance.new("TextButton")
HopOldServerBtn.Size = UDim2.new(0.32, -3, 0, 26)
HopOldServerBtn.Position = UDim2.new(0.68, -1, 0, 36)
HopOldServerBtn.BackgroundColor3 = Color3.fromRGB(155, 89, 182)
HopOldServerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopOldServerBtn.TextSize = 9
HopOldServerBtn.Font = FONT_HEAVY
HopOldServerBtn.Text = "🕰️ SEVER CŨ"
HopOldServerBtn.ZIndex = 13
HopOldServerBtn.Parent = HopContent
Instance.new("UICorner", HopOldServerBtn).CornerRadius = UDim.new(0, 6)

local CopyCurrentJobBtn = Instance.new("TextButton")
CopyCurrentJobBtn.Size = UDim2.new(1, -6, 0, 24)
CopyCurrentJobBtn.Position = UDim2.new(0, 0, 0, 66)
CopyCurrentJobBtn.BackgroundColor3 = Color3.fromRGB(230, 126, 34)
CopyCurrentJobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyCurrentJobBtn.TextSize = 9
CopyCurrentJobBtn.Font = FONT_HEAVY
CopyCurrentJobBtn.Text = "📋 COPY JOBID SEVER HIỆN TẠI"
CopyCurrentJobBtn.ZIndex = 13
CopyCurrentJobBtn.Parent = HopContent
Instance.new("UICorner", CopyCurrentJobBtn).CornerRadius = UDim.new(0, 6)

local PasteJobInput = Instance.new("TextBox")
PasteJobInput.Size = UDim2.new(1, -68, 0, 26)
PasteJobInput.Position = UDim2.new(0, 0, 0, 94)
PasteJobInput.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
PasteJobInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PasteJobInput.PlaceholderColor3 = Color3.fromRGB(185, 192, 215)
PasteJobInput.PlaceholderText = "📌 DÁN JOBID..."
PasteJobInput.Text = ""
PasteJobInput.TextSize = 10
PasteJobInput.Font = FONT_HEAVY
PasteJobInput.ClearTextOnFocus = false
PasteJobInput.ZIndex = 13
PasteJobInput.Parent = HopContent
Instance.new("UICorner", PasteJobInput).CornerRadius = UDim.new(0, 6)

local JoinJobBtn = Instance.new("TextButton")
JoinJobBtn.Size = UDim2.new(0, 58, 0, 26)
JoinJobBtn.Position = UDim2.new(1, -64, 0, 94)
JoinJobBtn.BackgroundColor3 = Color3.fromRGB(31, 184, 154)
JoinJobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinJobBtn.TextSize = 10
JoinJobBtn.Font = FONT_HEAVY
JoinJobBtn.Text = "🚀 JOIN"
JoinJobBtn.ZIndex = 13
JoinJobBtn.Parent = HopContent
Instance.new("UICorner", JoinJobBtn).CornerRadius = UDim.new(0, 6)

local ServerListFrame = Instance.new("ScrollingFrame")
ServerListFrame.Size = UDim2.new(1, -6, 0, 114)
ServerListFrame.Position = UDim2.new(0, 0, 0, 124)
ServerListFrame.BackgroundColor3 = Color3.fromRGB(24, 26, 38)
ServerListFrame.BorderSizePixel = 0
ServerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ServerListFrame.ScrollBarThickness = 4
ServerListFrame.ZIndex = 13
ServerListFrame.Parent = HopContent
Instance.new("UICorner", ServerListFrame).CornerRadius = UDim.new(0, 7)

local ServerListLayout = Instance.new("UIListLayout")
ServerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ServerListLayout.Padding = UDim.new(0, 4)
ServerListLayout.Parent = ServerListFrame

local isHopping = false
local function setHopStatus(msg)
    HopStatusLabel.Text = " " .. tostring(msg)
end

local function rawHttpGet(url)
    if httpRequest then
        local ok, res = pcall(function()
            return httpRequest({
                Url = url,
                Method = "GET",
                Headers = {
                    ["Accept"] = "application/json",
                    ["User-Agent"] = "Roblox/WinInet"
                }
            })
        end)
        if ok and type(res) == "table" and type(res.Body) == "string" and res.Body ~= "" then
            return res.Body
        end
    end

    local gOk, gBody = pcall(function()
        return HttpService:GetAsync(url, false)
    end)
    if gOk and type(gBody) == "string" and gBody ~= "" then
        return gBody
    end

    return nil
end

local function fetchPublicServers(maxPages, sortOrder)
    local allServers = {}
    local cursor = ""
    local pages = 0
    local order = sortOrder or "Asc"

    while pages < (maxPages or 3) do
        pages = pages + 1
        local url = string.format(
            "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&limit=100%s",
            game.PlaceId,
            order,
            cursor ~= "" and ("&cursor=" .. HttpService:UrlEncode(cursor)) or ""
        )

        local body = rawHttpGet(url)
        if not body then
            if #allServers > 0 then
                break
            end
            return nil, "KHÔNG KẾT NỐI ĐƯỢC MÁY CHỦ ROBLOX"
        end

        local cleanBody = body:match("%b{}") or body
        local dOk, decoded = pcall(function()
            return HttpService:JSONDecode(cleanBody)
        end)

        if dOk and type(decoded) == "table" then
            if type(decoded.data) == "table" then
                for _, srv in ipairs(decoded.data) do
                    if type(srv) == "table" and srv.id and tostring(srv.id) ~= tostring(game.JobId) then
                        table.insert(allServers, srv)
                    end
                end
            end
            if type(decoded.nextPageCursor) == "string" and decoded.nextPageCursor ~= "" then
                cursor = decoded.nextPageCursor
            else
                break
            end
        else
            if #allServers > 0 then
                break
            end
            return nil, "DỮ LIỆU SEVER CHƯA SẴN SÀNG, HÃY THỬ LẠI"
        end
    end

    return allServers, nil
end

local function teleportToJob(jobId, labelHint)
    local cleanId = tostring(jobId or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if cleanId == "" then
        setHopStatus("⚠️ HÃY DÁN JOBID TRƯỚC KHI JOIN!")
        setLiveAction("Chưa có JobId hợp lệ để Join", Color3.fromRGB(255, 195, 80))
        return
    end
    local targetMsg = "ĐANG JOIN " .. string.upper(labelHint or cleanId:sub(1, 14))
    setHopStatus("🔄 " .. targetMsg .. "...")
    setLiveAction(targetMsg, Color3.fromRGB(46, 204, 113))
    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, cleanId, LocalPlayer)
    end)
    if not ok then
        setHopStatus("❌ LỖI JOIN: " .. tostring(err))
        setLiveAction("Join thất bại: " .. tostring(err), Color3.fromRGB(255, 95, 95))
    end
end

local function renderServerList(serverRows, titlePrefix)
    for _, child in ipairs(ServerListFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local count = #serverRows
    for idx, srv in ipairs(serverRows) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -6, 0, 36)
        row.BackgroundColor3 = Color3.fromRGB(38, 42, 60)
        row.BorderSizePixel = 0
        row.LayoutOrder = idx
        row.ZIndex = 14
        row.Parent = ServerListFrame
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -60, 1, 0)
        lbl.Position = UDim2.new(0, 6, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextSize = 10
        lbl.Font = FONT_HEAVY
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextWrapped = true
        lbl.Text = string.format(
            "SEVER %d: %s NGƯỜI | %sMS\nID: %s",
            idx,
            tostring(srv.playing or "?"),
            tostring(srv.ping or "?"),
            tostring(srv.id):sub(1, 13) .. "..."
        )
        lbl.ZIndex = 15
        lbl.Parent = row

        local joinBtn = Instance.new("TextButton")
        joinBtn.Size = UDim2.new(0, 48, 0, 24)
        joinBtn.Position = UDim2.new(1, -52, 0.5, -12)
        joinBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        joinBtn.TextSize = 10
        joinBtn.Font = FONT_HEAVY
        joinBtn.Text = "JOIN"
        joinBtn.ZIndex = 15
        joinBtn.Parent = row
        Instance.new("UICorner", joinBtn).CornerRadius = UDim.new(0, 5)

        local srvId = tostring(srv.id)
        onButtonClicked(joinBtn, function()
            PasteJobInput.Text = srvId
            teleportToJob(srvId, "SEVER " .. idx)
        end)
    end

    ServerListFrame.CanvasSize = UDim2.new(0, 0, 0, count * 40 + 6)
    local doneMsg = string.format("%s: TÌM THẤY %d SEVER", string.upper(titlePrefix), count)
    setHopStatus(doneMsg)
    setLiveAction("Đã tải xong " .. doneMsg, Color3.fromRGB(46, 204, 113))
end

local function loadServersByMode(mode)
    if isHopping then return end
    isHopping = true
    local modeName = mode == "one_player" and "SEVER 1 NGƯỜI" or (mode == "low_ping" and "SEVER PING THẤP" or "SEVER CŨ")
    setHopStatus("🔍 ĐANG TẢI " .. modeName .. "...")
    setLiveAction("Đang tải danh sách " .. modeName .. "...", Color3.fromRGB(130, 215, 255))

    task.spawn(function()
        local sortOrder = (mode == "old_server") and "Desc" or "Asc"
        local servers, err = fetchPublicServers(4, sortOrder)
        if not servers then
            setHopStatus("⚠️ " .. tostring(err))
            setLiveAction("Chưa tải được danh sách: " .. tostring(err), Color3.fromRGB(255, 195, 80))
            isHopping = false
            return
        end

        local list = {}
        if mode == "one_player" then
            for _, srv in ipairs(servers) do
                if (tonumber(srv.playing) or 999) == 1 then
                    table.insert(list, srv)
                end
            end
            if #list == 0 then
                table.sort(servers, function(a, b)
                    return (tonumber(a.playing) or 999) < (tonumber(b.playing) or 999)
                end)
                for i = 1, math.min(15, #servers) do
                    table.insert(list, servers[i])
                end
            end
            renderServerList(list, "👤 1 NGƯỜI")
        elseif mode == "low_ping" then
            for _, srv in ipairs(servers) do
                if srv.ping ~= nil then
                    table.insert(list, srv)
                end
            end
            table.sort(list, function(a, b)
                return (tonumber(a.ping) or 9999) < (tonumber(b.ping) or 9999)
            end)
            local topLow = {}
            for i = 1, math.min(20, #list) do
                table.insert(topLow, list[i])
            end
            renderServerList(topLow, "⚡ PING THẤP")
        elseif mode == "old_server" then
            for i = 1, math.min(20, #servers) do
                table.insert(list, servers[i])
            end
            renderServerList(list, "🕰️ SEVER CŨ")
        end

        isHopping = false
    end)
end

local function copyJobToClipboard()
    local curId = tostring(game.JobId ~= "" and game.JobId or "Studio / Local")
    local copied = false
    if setclipboard then
        pcall(function()
            setclipboard(curId)
            copied = true
        end)
    elseif toclipboard then
        pcall(function()
            toclipboard(curId)
            copied = true
        end)
    end
    PasteJobInput.Text = curId
    if copied then
        setHopStatus("📋 ĐÃ COPY JOBID: " .. curId:sub(1, 18))
        setLiveAction("Đã copy JobId: " .. curId:sub(1, 18), Color3.fromRGB(46, 204, 113))
    else
        setHopStatus("📌 ĐÃ ĐIỀN JOBID: " .. curId:sub(1, 18))
        setLiveAction("Đã điền JobId hiện tại", Color3.fromRGB(130, 215, 255))
    end
end

onButtonClicked(Hop1PlayerBtn, function() loadServersByMode("one_player") end)
onButtonClicked(HopLowPingBtn, function() loadServersByMode("low_ping") end)
onButtonClicked(HopOldServerBtn, function() loadServersByMode("old_server") end)
onButtonClicked(CopyCurrentJobBtn, copyJobToClipboard)
onButtonClicked(HomeCopyJobBtn, copyJobToClipboard)
onButtonClicked(JoinJobBtn, function()
    teleportToJob(PasteJobInput.Text, "JOBID ĐÃ DÁN")
end)

-- ==========================================
-- TAB HUB: DANH SÁCH SCRIPT & NÚT CHẠY SCRIPT
-- ==========================================
local HubContent = Instance.new("ScrollingFrame")
HubContent.Size = UDim2.new(1, -12, 0, CONTENT_HEIGHT)
HubContent.Position = UDim2.new(0, 6, 0, CONTENT_TOP_Y)
HubContent.BackgroundTransparency = 1
HubContent.BorderSizePixel = 0
HubContent.ScrollingDirection = Enum.ScrollingDirection.Y
HubContent.CanvasSize = UDim2.new(0, 0, 0, 260)
HubContent.ScrollBarThickness = 4
HubContent.ScrollBarImageColor3 = Color3.fromRGB(145, 160, 205)
HubContent.Visible = false
HubContent.ZIndex = 12
HubContent.Parent = MainFrame

local HubLayout = Instance.new("UIListLayout")
HubLayout.SortOrder = Enum.SortOrder.LayoutOrder
HubLayout.Padding = UDim.new(0, 6)
HubLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
HubLayout.Parent = HubContent

local HubStatusBanner = Instance.new("TextLabel")
HubStatusBanner.LayoutOrder = 0
HubStatusBanner.Size = UDim2.new(1, -6, 0, 26)
HubStatusBanner.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
HubStatusBanner.TextColor3 = Color3.fromRGB(130, 235, 185)
HubStatusBanner.TextSize = 9
HubStatusBanner.Font = FONT_HEAVY
HubStatusBanner.TextXAlignment = Enum.TextXAlignment.Left
HubStatusBanner.Text = " 🚀 CHỌN SCRIPT ĐỂ CHẠY NGAY"
HubStatusBanner.ZIndex = 13
HubStatusBanner.Parent = HubContent
Instance.new("UICorner", HubStatusBanner).CornerRadius = UDim.new(0, 7)

local HubScripts = {
    {
        name = "HOP SEVER (NGUYENDUYTDZ)",
        desc = "Script đổi server nhanh",
        run = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/nguyenduytdz/Script-bot/main/Hop%20Sever.lua"))()
        end
    },
    {
        name = "ANTI AFK PRO",
        desc = "Chống văng khi treo máy",
        run = function()
            local vu = game:GetService("VirtualUser")
            LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
    },
    {
        name = "TỐC ĐỘ & NHẢY CAO",
        desc = "WalkSpeed 32 / JumpPower 75",
        run = function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 32
                hum.UseJumpPower = true
                hum.JumpPower = 75
            end
        end
    },
    {
        name = "REJOIN SEVER HIỆN TẠI",
        desc = "Vào lại nhanh server này",
        run = function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    }
}

for idx, item in ipairs(HubScripts) do
    local row = Instance.new("Frame")
    row.LayoutOrder = idx
    row.Size = UDim2.new(1, -6, 0, 42)
    row.BackgroundColor3 = Color3.fromRGB(34, 37, 52)
    row.BorderSizePixel = 0
    row.ZIndex = 13
    row.Parent = HubContent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local infoLbl = Instance.new("TextLabel")
    infoLbl.Size = UDim2.new(1, -68, 1, 0)
    infoLbl.Position = UDim2.new(0, 8, 0, 0)
    infoLbl.BackgroundTransparency = 1
    infoLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLbl.TextSize = 9
    infoLbl.Font = FONT_HEAVY
    infoLbl.TextXAlignment = Enum.TextXAlignment.Left
    infoLbl.TextWrapped = true
    infoLbl.Text = string.format("📜 %s\n   %s", item.name, item.desc)
    infoLbl.ZIndex = 14
    infoLbl.Parent = row

    local runBtn = Instance.new("TextButton")
    runBtn.Size = UDim2.new(0, 54, 0, 26)
    runBtn.Position = UDim2.new(1, -60, 0.5, -13)
    runBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    runBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    runBtn.TextSize = 9
    runBtn.Font = FONT_HEAVY
    runBtn.Text = "CHẠY"
    runBtn.ZIndex = 15
    runBtn.Parent = row
    Instance.new("UICorner", runBtn).CornerRadius = UDim.new(0, 6)

    onButtonClicked(runBtn, function()
        HubStatusBanner.Text = " ⚡ ĐANG CHẠY: " .. item.name
        setLiveAction("Đang chạy script: " .. item.name, Color3.fromRGB(255, 220, 50))
        local ok, err = pcall(item.run)
        if ok then
            HubStatusBanner.Text = " ✅ ĐÃ KÍCH HOẠT: " .. item.name
            setLiveAction("Đã chạy xong: " .. item.name, Color3.fromRGB(46, 204, 113))
        else
            HubStatusBanner.Text = " ⚠️ LỖI: " .. tostring(err):sub(1, 28)
            setLiveAction("Lỗi chạy script: " .. tostring(err), Color3.fromRGB(255, 110, 110))
        end
    end)
end

HubLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    HubContent.CanvasSize = UDim2.new(0, 0, 0, HubLayout.AbsoluteContentSize.Y + 12)
end)

-- ==========================================
-- TAB SETTINGS / UPDATE: CHỮ CHI TIẾT BẢN CẬP NHẬT ĐẬM RÕ
-- ==========================================
local Tab3Content = Instance.new("ScrollingFrame")
Tab3Content.Size = UDim2.new(1, -12, 0, CONTENT_HEIGHT)
Tab3Content.Position = UDim2.new(0, 6, 0, CONTENT_TOP_Y)
Tab3Content.BackgroundTransparency = 1
Tab3Content.BorderSizePixel = 0
Tab3Content.ScrollingDirection = Enum.ScrollingDirection.Y
Tab3Content.CanvasSize = UDim2.new(0, 0, 0, 320)
Tab3Content.ScrollBarThickness = 4
Tab3Content.ScrollBarImageColor3 = Color3.fromRGB(145, 160, 205)
Tab3Content.Visible = false
Tab3Content.ZIndex = 12
Tab3Content.Parent = MainFrame

local UpdateListLayout = Instance.new("UIListLayout")
UpdateListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UpdateListLayout.Padding = UDim.new(0, 6)
UpdateListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UpdateListLayout.Parent = Tab3Content

local UpdateEntries = {
    {
        time = "22:50",
        author = "Nguyen Duy Ngô",
        version = "v2.5",
        kind = "Update tính năng",
        details = "• IN ĐẬM TOÀN BỘ CHỮ & CHI TIẾT UPDATE\n• ĐỒNG HỒ DYNAMIC ISLAND NHẤP NHÁY DẤU : MỖI GIÂY\n• THÊM TAB HUB CHỨA DANH SÁCH SCRIPT & NÚT CHẠY\n• THU GỌN MENU CHÍNH VÀ THÊM ICON 💬 APP NHẮN TIN"
    },
    {
        time = "22:30",
        author = "Nguyen Duy Ngô",
        version = "v2.4",
        kind = "Update tính năng",
        details = "• DYNAMIC ISLAND CHỈ HIỆN GIỜ VN MÀU VÀNG BÊN PHẢI\n• TAB HOME BỎ ĐÃ BẮT VÀ TRẠNG THÁI\n• SỬA LỖI ĐỌC DANH SÁCH SEVER TRONG HOP SEVER"
    },
    {
        time = "20:15",
        author = "Nguyen Duy Ngô",
        version = "v2.3",
        kind = "Fix",
        details = "• SỬA CHUYỂN TAB VÀ TỐI ƯU QUÉT PET MỚI NHẬN"
    }
}

local expandedUpdateFlags = {}

local function refreshUpdateList()
    for _, ch in ipairs(Tab3Content:GetChildren()) do
        if ch:IsA("Frame") then
            ch:Destroy()
        end
    end

    for idx, entry in ipairs(UpdateEntries) do
        local isOpen = expandedUpdateFlags[idx] == true

        local card = Instance.new("Frame")
        card.LayoutOrder = idx
        card.Size = UDim2.new(1, -6, 0, 42)
        card.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
        card.BorderSizePixel = 0
        card.ClipsDescendants = true
        card.ZIndex = 13
        card.Parent = Tab3Content
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

        local summaryBtn = Instance.new("TextButton")
        summaryBtn.Size = UDim2.new(1, 0, 0, 42)
        summaryBtn.Position = UDim2.new(0, 0, 0, 0)
        summaryBtn.BackgroundColor3 = Color3.fromRGB(42, 46, 64)
        summaryBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        summaryBtn.TextSize = 9
        summaryBtn.Font = FONT_HEAVY
        summaryBtn.TextXAlignment = Enum.TextXAlignment.Left
        summaryBtn.TextWrapped = true
        summaryBtn.Text = string.format(
            " %s ⏰ %s | 👤 %s\n    🏷️ %s • 🛠️ %s",
            isOpen and "▼" or "▶",
            entry.time,
            entry.author,
            entry.version,
            entry.kind
        )
        summaryBtn.ZIndex = 14
        summaryBtn.Parent = card
        Instance.new("UICorner", summaryBtn).CornerRadius = UDim.new(0, 8)

        local detailBox = Instance.new("TextLabel")
        detailBox.Size = UDim2.new(1, -10, 0, 76)
        detailBox.Position = UDim2.new(0, 5, 0, 46)
        detailBox.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
        detailBox.TextColor3 = Color3.fromRGB(255, 245, 175)
        detailBox.TextSize = 10
        detailBox.Font = FONT_HEAVY
        detailBox.TextXAlignment = Enum.TextXAlignment.Left
        detailBox.TextYAlignment = Enum.TextYAlignment.Top
        detailBox.TextWrapped = true
        detailBox.Text = entry.details
        detailBox.Visible = isOpen
        detailBox.ZIndex = 14
        detailBox.Parent = card
        Instance.new("UICorner", detailBox).CornerRadius = UDim.new(0, 6)

        local detailHeight = math.max(66, detailBox.TextBounds.Y + 14)
        detailBox.Size = UDim2.new(1, -10, 0, detailHeight)
        card.Size = UDim2.new(1, -6, 0, isOpen and (52 + detailHeight) or 42)

        onButtonClicked(summaryBtn, function()
            expandedUpdateFlags[idx] = not expandedUpdateFlags[idx]
            refreshUpdateList()
            setLiveAction(
                (expandedUpdateFlags[idx] and "Xem chi tiết bản " or "Đóng chi tiết bản ") .. entry.version,
                Color3.fromRGB(255, 220, 50)
            )
        end)
    end

    task.defer(function()
        Tab3Content.CanvasSize = UDim2.new(0, 0, 0, UpdateListLayout.AbsoluteContentSize.Y + 12)
    end)
end

refreshUpdateList()
UpdateListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Tab3Content.CanvasSize = UDim2.new(0, 0, 0, UpdateListLayout.AbsoluteContentSize.Y + 12)
end)

-- ==========================================
-- TAB GHI CHÚ MÀN HÌNH
-- ==========================================
local Tab4Content = Instance.new("ScrollingFrame")
Tab4Content.Size = UDim2.new(1, -12, 0, CONTENT_HEIGHT)
Tab4Content.Position = UDim2.new(0, 6, 0, CONTENT_TOP_Y)
Tab4Content.BackgroundTransparency = 1
Tab4Content.BorderSizePixel = 0
Tab4Content.ScrollingDirection = Enum.ScrollingDirection.Y
Tab4Content.CanvasSize = UDim2.new(0, 0, 0, 320)
Tab4Content.ScrollBarThickness = 4
Tab4Content.ScrollBarImageColor3 = Color3.fromRGB(145, 160, 205)
Tab4Content.ClipsDescendants = true
Tab4Content.Visible = false
Tab4Content.ZIndex = 12
Tab4Content.Parent = MainFrame

local NoteListLayout = Instance.new("UIListLayout")
NoteListLayout.Padding = UDim.new(0, 6)
NoteListLayout.SortOrder = Enum.SortOrder.LayoutOrder
NoteListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NoteListLayout.Parent = Tab4Content

NoteListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Tab4Content.CanvasSize = UDim2.new(0, 0, 0, NoteListLayout.AbsoluteContentSize.Y + 10)
end)

local NoteInputBox = Instance.new("TextBox")
NoteInputBox.Size = UDim2.new(1, -6, 0, 48)
NoteInputBox.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
NoteInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
NoteInputBox.PlaceholderColor3 = Color3.fromRGB(175, 182, 205)
NoteInputBox.PlaceholderText = "Nhập ghi chú lên màn hình..."
NoteInputBox.Text = ""
NoteInputBox.Font = FONT_HEAVY
NoteInputBox.TextSize = 10
NoteInputBox.TextWrapped = true
NoteInputBox.ClearTextOnFocus = false
NoteInputBox.MultiLine = true
NoteInputBox.ZIndex = 13
NoteInputBox.Parent = Tab4Content
Instance.new("UICorner", NoteInputBox).CornerRadius = UDim.new(0, 8)

local NoteActionRow = Instance.new("Frame")
NoteActionRow.Size = UDim2.new(1, -6, 0, 28)
NoteActionRow.BackgroundTransparency = 1
NoteActionRow.ZIndex = 13
NoteActionRow.Parent = Tab4Content

local NoteToggleShowBtn = Instance.new("TextButton")
NoteToggleShowBtn.Size = UDim2.new(0.66, -3, 1, 0)
NoteToggleShowBtn.Position = UDim2.new(0, 0, 0, 0)
NoteToggleShowBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
NoteToggleShowBtn.Text = "👁️ HIỆN GHI CHÚ"
NoteToggleShowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoteToggleShowBtn.Font = FONT_HEAVY
NoteToggleShowBtn.TextSize = 9
NoteToggleShowBtn.ZIndex = 14
NoteToggleShowBtn.Parent = NoteActionRow
Instance.new("UICorner", NoteToggleShowBtn).CornerRadius = UDim.new(0, 7)

local NoteClearBtn = Instance.new("TextButton")
NoteClearBtn.Size = UDim2.new(0.34, -3, 1, 0)
NoteClearBtn.Position = UDim2.new(0.66, 3, 0, 0)
NoteClearBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
NoteClearBtn.Text = "🗑️ XÓA"
NoteClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoteClearBtn.Font = FONT_HEAVY
NoteClearBtn.TextSize = 9
NoteClearBtn.ZIndex = 14
NoteClearBtn.Parent = NoteActionRow
Instance.new("UICorner", NoteClearBtn).CornerRadius = UDim.new(0, 7)

local NoteSizeRow = Instance.new("Frame")
NoteSizeRow.Size = UDim2.new(1, -6, 0, 28)
NoteSizeRow.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
NoteSizeRow.ZIndex = 13
NoteSizeRow.Parent = Tab4Content
Instance.new("UICorner", NoteSizeRow).CornerRadius = UDim.new(0, 8)

local NoteSizeLabel = Instance.new("TextLabel")
NoteSizeLabel.Size = UDim2.new(1, -76, 1, 0)
NoteSizeLabel.Position = UDim2.new(0, 8, 0, 0)
NoteSizeLabel.BackgroundTransparency = 1
NoteSizeLabel.Text = "CỠ CHỮ: 20"
NoteSizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NoteSizeLabel.Font = FONT_HEAVY
NoteSizeLabel.TextSize = 10
NoteSizeLabel.TextXAlignment = Enum.TextXAlignment.Left
NoteSizeLabel.ZIndex = 14
NoteSizeLabel.Parent = NoteSizeRow

local NoteMinusBtn = Instance.new("TextButton")
NoteMinusBtn.Size = UDim2.new(0, 28, 0, 22)
NoteMinusBtn.Position = UDim2.new(1, -64, 0.5, -11)
NoteMinusBtn.BackgroundColor3 = Color3.fromRGB(54, 58, 78)
NoteMinusBtn.Text = "-"
NoteMinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoteMinusBtn.Font = FONT_HEAVY
NoteMinusBtn.TextSize = 14
NoteMinusBtn.ZIndex = 14
NoteMinusBtn.Parent = NoteSizeRow
Instance.new("UICorner", NoteMinusBtn).CornerRadius = UDim.new(0, 6)

local NotePlusBtn = Instance.new("TextButton")
NotePlusBtn.Size = UDim2.new(0, 28, 0, 22)
NotePlusBtn.Position = UDim2.new(1, -32, 0.5, -11)
NotePlusBtn.BackgroundColor3 = Color3.fromRGB(54, 58, 78)
NotePlusBtn.Text = "+"
NotePlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NotePlusBtn.Font = FONT_HEAVY
NotePlusBtn.TextSize = 14
NotePlusBtn.ZIndex = 14
NotePlusBtn.Parent = NoteSizeRow
Instance.new("UICorner", NotePlusBtn).CornerRadius = UDim.new(0, 6)

local NoteColorBtn = Instance.new("TextButton")
NoteColorBtn.Size = UDim2.new(1, -6, 0, 28)
NoteColorBtn.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
NoteColorBtn.Text = "🎨 MÀU CHỮ: TRẮNG"
NoteColorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoteColorBtn.Font = FONT_HEAVY
NoteColorBtn.TextSize = 10
NoteColorBtn.ZIndex = 13
NoteColorBtn.Parent = Tab4Content
Instance.new("UICorner", NoteColorBtn).CornerRadius = UDim.new(0, 8)

local NoteEffectBtn = Instance.new("TextButton")
NoteEffectBtn.Size = UDim2.new(1, -6, 0, 28)
NoteEffectBtn.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
NoteEffectBtn.Text = "✨ HIỆU ỨNG: KHÔNG"
NoteEffectBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
NoteEffectBtn.Font = FONT_HEAVY
NoteEffectBtn.TextSize = 10
NoteEffectBtn.ZIndex = 13
NoteEffectBtn.Parent = Tab4Content
Instance.new("UICorner", NoteEffectBtn).CornerRadius = UDim.new(0, 8)

local NoteBgToggleBtn = Instance.new("TextButton")
NoteBgToggleBtn.Size = UDim2.new(1, -6, 0, 28)
NoteBgToggleBtn.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
NoteBgToggleBtn.Text = "⬛ NỀN CHỮ: TẮT"
NoteBgToggleBtn.TextColor3 = Color3.fromRGB(220, 225, 240)
NoteBgToggleBtn.Font = FONT_HEAVY
NoteBgToggleBtn.TextSize = 10
NoteBgToggleBtn.ZIndex = 13
NoteBgToggleBtn.Parent = Tab4Content
Instance.new("UICorner", NoteBgToggleBtn).CornerRadius = UDim.new(0, 8)

local currentNoteSize = 20
local isNoteShowing = false
local hasNoteBg = false

local noteColors = {
    {Name = "TRẮNG", Val = Color3.fromRGB(255, 255, 255)},
    {Name = "VÀNG GOLD", Val = Color3.fromRGB(255, 215, 0)},
    {Name = "XANH NEON", Val = Color3.fromRGB(0, 255, 170)},
    {Name = "ĐỎ RỰC", Val = Color3.fromRGB(255, 65, 65)},
    {Name = "XANH DƯƠNG", Val = Color3.fromRGB(0, 170, 255)},
    {Name = "TÍM HỒNG", Val = Color3.fromRGB(220, 100, 255)}
}
local noteColorIdx = 1

local noteEffects = {"KHÔNG", "CẦU VỒNG (RGB)", "NHẤP NHÁY (PULSE)", "PHÁT SÁNG (NEON)", "LƠ LỬNG (FLOAT)"}
local noteEffectIdx = 1

NoteInputBox:GetPropertyChangedSignal("Text"):Connect(function()
    if NoteInputBox.Text == "" then
        DisplayLabel.Text = "Ghi chú trống..."
    else
        DisplayLabel.Text = NoteInputBox.Text
        setLiveAction("Đang sửa ghi chú: " .. NoteInputBox.Text:sub(1, 22), Color3.fromRGB(130, 215, 255))
    end
end)

onButtonClicked(NoteToggleShowBtn, function()
    isNoteShowing = not isNoteShowing
    DisplayContainer.Visible = isNoteShowing
    if isNoteShowing then
        if NoteInputBox.Text ~= "" then
            DisplayLabel.Text = NoteInputBox.Text
        end
        NoteToggleShowBtn.Text = "🙈 ẨN GHI CHÚ"
        NoteToggleShowBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 90)
        setLiveAction("Đã bật ghi chú nổi trên màn hình", Color3.fromRGB(46, 204, 113))
    else
        NoteToggleShowBtn.Text = "👁️ HIỆN GHI CHÚ"
        NoteToggleShowBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        setLiveAction("Đã ẩn ghi chú khỏi màn hình", Color3.fromRGB(185, 190, 210))
    end
end)

onButtonClicked(NoteClearBtn, function()
    NoteInputBox.Text = ""
    DisplayLabel.Text = ""
    setLiveAction("Đã xóa nội dung ghi chú", Color3.fromRGB(255, 195, 80))
end)

onButtonClicked(NoteMinusBtn, function()
    currentNoteSize = math.max(10, currentNoteSize - 2)
    DisplayLabel.TextSize = currentNoteSize
    NoteSizeLabel.Text = "CỠ CHỮ: " .. currentNoteSize
end)

onButtonClicked(NotePlusBtn, function()
    currentNoteSize = math.min(72, currentNoteSize + 2)
    DisplayLabel.TextSize = currentNoteSize
    NoteSizeLabel.Text = "CỠ CHỮ: " .. currentNoteSize
end)

onButtonClicked(NoteColorBtn, function()
    noteColorIdx = (noteColorIdx % #noteColors) + 1
    DisplayLabel.TextColor3 = noteColors[noteColorIdx].Val
    NoteColorBtn.Text = "🎨 MÀU CHỮ: " .. noteColors[noteColorIdx].Name
    NoteColorBtn.TextColor3 = noteColors[noteColorIdx].Val
end)

onButtonClicked(NoteEffectBtn, function()
    noteEffectIdx = (noteEffectIdx % #noteEffects) + 1
    local currentEffect = noteEffects[noteEffectIdx]
    NoteEffectBtn.Text = "✨ HIỆU ỨNG: " .. currentEffect

    DisplayLabel.TextTransparency = 0
    TextStroke.Color = Color3.fromRGB(0, 0, 0)
    TextStroke.Thickness = 2.5
    DisplayLabel.TextColor3 = noteColors[noteColorIdx].Val

    if currentEffect == "PHÁT SÁNG (NEON)" then
        TextStroke.Color = noteColors[noteColorIdx].Val
        TextStroke.Thickness = 3.5
        DisplayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

onButtonClicked(NoteBgToggleBtn, function()
    hasNoteBg = not hasNoteBg
    if hasNoteBg then
        DisplayContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        DisplayContainer.BackgroundTransparency = 0.35
        if not DisplayContainer:FindFirstChild("UICorner") then
            Instance.new("UICorner", DisplayContainer).CornerRadius = UDim.new(0, 10)
        end
        NoteBgToggleBtn.Text = "⬛ NỀN CHỮ: BẬT"
    else
        DisplayContainer.BackgroundTransparency = 1
        NoteBgToggleBtn.Text = "⬛ NỀN CHỮ: TẮT"
    end
end)

-- ==========================================
-- TAB LỊCH SỬ
-- ==========================================
local HistoryRecords = {}
local historyFilterMode = "all"
local refreshHistory

local HistorySearch = Instance.new("TextBox")
HistorySearch.Size = UDim2.new(0, 124, 0, 26)
HistorySearch.Position = UDim2.new(0, 8, 0, CONTENT_TOP_Y)
HistorySearch.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
HistorySearch.TextColor3 = Color3.fromRGB(255, 255, 255)
HistorySearch.PlaceholderColor3 = Color3.fromRGB(175, 182, 205)
HistorySearch.PlaceholderText = "🔎 TÌM TÊN..."
HistorySearch.Text = ""
HistorySearch.TextSize = 9
HistorySearch.Font = FONT_HEAVY
HistorySearch.ClearTextOnFocus = false
HistorySearch.Visible = false
HistorySearch.ZIndex = 13
HistorySearch.Parent = MainFrame
Instance.new("UICorner", HistorySearch).CornerRadius = UDim.new(0, 6)

local HistoryFilterBtn = Instance.new("TextButton")
HistoryFilterBtn.Size = UDim2.new(0, 30, 0, 26)
HistoryFilterBtn.Position = UDim2.new(0, 136, 0, CONTENT_TOP_Y)
HistoryFilterBtn.BackgroundColor3 = Color3.fromRGB(44, 47, 64)
HistoryFilterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HistoryFilterBtn.Text = "☷"
HistoryFilterBtn.TextSize = 11
HistoryFilterBtn.Font = FONT_HEAVY
HistoryFilterBtn.Visible = false
HistoryFilterBtn.ZIndex = 13
HistoryFilterBtn.Parent = MainFrame
Instance.new("UICorner", HistoryFilterBtn).CornerRadius = UDim.new(0, 6)

local HistoryClearBtn = Instance.new("TextButton")
HistoryClearBtn.Size = UDim2.new(0, 30, 0, 26)
HistoryClearBtn.Position = UDim2.new(0, 170, 0, CONTENT_TOP_Y)
HistoryClearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
HistoryClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HistoryClearBtn.Text = "🗑️"
HistoryClearBtn.TextSize = 11
HistoryClearBtn.Font = FONT_HEAVY
HistoryClearBtn.Visible = false
HistoryClearBtn.ZIndex = 13
HistoryClearBtn.Parent = MainFrame
Instance.new("UICorner", HistoryClearBtn).CornerRadius = UDim.new(0, 6)

local HistoryCountLabel = Instance.new("TextLabel")
HistoryCountLabel.Size = UDim2.new(0, 78, 0, 26)
HistoryCountLabel.Position = UDim2.new(0, 204, 0, CONTENT_TOP_Y)
HistoryCountLabel.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
HistoryCountLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
HistoryCountLabel.TextSize = 11
HistoryCountLabel.Font = FONT_HEAVY
HistoryCountLabel.Text = "0"
HistoryCountLabel.TextXAlignment = Enum.TextXAlignment.Center
HistoryCountLabel.Visible = false
HistoryCountLabel.ZIndex = 13
HistoryCountLabel.Parent = MainFrame
Instance.new("UICorner", HistoryCountLabel).CornerRadius = UDim.new(0, 6)

local HistoryFilterPopup = Instance.new("Frame")
HistoryFilterPopup.Size = UDim2.new(0, 120, 0, 84)
HistoryFilterPopup.Position = UDim2.new(0, 136, 0, CONTENT_TOP_Y + 30)
HistoryFilterPopup.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
HistoryFilterPopup.Visible = false
HistoryFilterPopup.ZIndex = 25
HistoryFilterPopup.Parent = MainFrame
Instance.new("UICorner", HistoryFilterPopup).CornerRadius = UDim.new(0, 6)

local function makeHistoryModeButton(label, mode, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 22)
    b.Position = UDim2.new(0, 4, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(50, 54, 72)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 9
    b.Font = FONT_HEAVY
    b.Text = label
    b.ZIndex = 26
    b.Parent = HistoryFilterPopup
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    onButtonClicked(b, function()
        historyFilterMode = mode
        HistoryFilterPopup.Visible = false
        if refreshHistory then refreshHistory() end
    end)
end
makeHistoryModeButton("TẤT CẢ", "all", 4)
makeHistoryModeButton("LỌC GIÁ TRỊ", "value", 30)
makeHistoryModeButton("LỌC ĐỘ HIẾM", "rarity", 56)

onButtonClicked(HistoryFilterBtn, function()
    HistoryFilterPopup.Visible = not HistoryFilterPopup.Visible
end)

onButtonClicked(HistoryClearBtn, function()
    if #HistoryRecords == 0 then
        setLiveAction("Lịch sử đang trống", Color3.fromRGB(185, 190, 210))
        return
    end
    promptDeleteConfirm(
        "Xóa toàn bộ lịch sử?",
        string.format("Tất cả %d mục trong lịch sử sẽ bị xóa.", #HistoryRecords),
        function()
            HistoryRecords = {}
            if refreshHistory then refreshHistory() end
        end
    )
end)

local Tab2Content = Instance.new("ScrollingFrame")
Tab2Content.Size = UDim2.new(1, -10, 0, CONTENT_HEIGHT - 30)
Tab2Content.Position = UDim2.new(0, 5, 0, CONTENT_TOP_Y + 30)
Tab2Content.BackgroundTransparency = 1
Tab2Content.Visible = false
Tab2Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Tab2Content.ScrollBarThickness = 4
Tab2Content.ScrollBarImageColor3 = Color3.fromRGB(145, 160, 205)
Tab2Content.ZIndex = 12
Tab2Content.Parent = MainFrame

local HistoryLayout = Instance.new("UIListLayout")
HistoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
HistoryLayout.Padding = UDim.new(0, 5)
HistoryLayout.Parent = Tab2Content

refreshHistory = function()
    for _, child in ipairs(Tab2Content:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local shown = 0
    local q = string.lower(HistorySearch.Text or "")
    for recIdx, record in ipairs(HistoryRecords) do
        local d = record.data
        local matchesName = (q == "" or string.find(string.lower(d.Name or ""), q, 1, true) ~= nil)
        local matchesFilter = true
        if historyFilterMode == "value" then
            matchesFilter = (q == "" or string.find(string.lower(tostring(d.MoneyPerSec or "")), q, 1, true) ~= nil)
        elseif historyFilterMode == "rarity" then
            matchesFilter = (q == "" or string.find(string.lower(tostring(d.Rarity or "")), q, 1, true) ~= nil)
        end
        if (historyFilterMode == "all" and matchesName) or (matchesName and matchesFilter) then
            shown = shown + 1
            local itemFrame = Instance.new("Frame")
            itemFrame.Size = UDim2.new(1, -6, 0, 64)
            itemFrame.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
            itemFrame.BorderSizePixel = 0
            itemFrame.LayoutOrder = shown
            itemFrame.ZIndex = 13
            itemFrame.Parent = Tab2Content
            Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 6)

            local descLabel = Instance.new("TextLabel")
            descLabel.Size = UDim2.new(1, -34, 1, 0)
            descLabel.Position = UDim2.new(0, 5, 0, 0)
            descLabel.BackgroundTransparency = 1
            descLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            descLabel.TextSize = 10
            descLabel.Font = FONT_HEAVY
            descLabel.TextXAlignment = Enum.TextXAlignment.Left
            descLabel.TextYAlignment = Enum.TextYAlignment.Center
            descLabel.TextWrapped = true
            descLabel.Text = string.format(
                "🐾 %s | ⚖️ %s\n✨ %s | 🧬 %s\n💸 %s | ⏰ %s",
                d.Name or "Pet",
                d.Weight or "Không rõ",
                d.Rarity or "Không rõ",
                d.Mutation or "Mặc định",
                d.MoneyPerSec or "Không rõ",
                record.time
            )
            descLabel.ZIndex = 14
            descLabel.Parent = itemFrame

            local removeOneBtn = Instance.new("TextButton")
            removeOneBtn.Size = UDim2.new(0, 22, 0, 22)
            removeOneBtn.Position = UDim2.new(1, -26, 0.5, -11)
            removeOneBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
            removeOneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            removeOneBtn.TextSize = 10
            removeOneBtn.Font = FONT_HEAVY
            removeOneBtn.Text = "✕"
            removeOneBtn.ZIndex = 15
            removeOneBtn.Parent = itemFrame
            Instance.new("UICorner", removeOneBtn).CornerRadius = UDim.new(0, 6)

            local targetIndex = recIdx
            local targetPetName = d.Name or "Pet"
            onButtonClicked(removeOneBtn, function()
                promptDeleteConfirm(
                    "Xóa mục này?",
                    string.format("Mục “%s” sẽ bị xóa khỏi lịch sử.", targetPetName),
                    function()
                        if HistoryRecords[targetIndex] then
                            table.remove(HistoryRecords, targetIndex)
                            refreshHistory()
                        end
                    end
                )
            end)
        end
    end
    Tab2Content.CanvasSize = UDim2.new(0, 0, 0, shown * 69)
    HistoryCountLabel.Text = tostring(#HistoryRecords)
end

HistorySearch:GetPropertyChangedSignal("Text"):Connect(function()
    refreshHistory()
end)

local allTabButtons = {
    home = TabHomeBtn,
    hop = TabHopBtn,
    hub = TabHubBtn,
    history = TabHistoryBtn,
    settings = TabSettingsBtn,
    note = TabNoteBtn
}

local tabNamesVi = {
    home = "Home",
    hop = "Hop Sever",
    hub = "Hub",
    history = "Lịch sử",
    settings = "Update",
    note = "Ghi chú"
}

local function setActiveTabStyle(tabKey)
    for k, b in pairs(allTabButtons) do
        if k == tabKey then
            b.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            b.BackgroundColor3 = Color3.fromRGB(40, 42, 56)
            b.TextColor3 = Color3.fromRGB(235, 240, 255)
        end
    end
end

openTab = function(tabKey)
    if type(tabKey) == "number" then
        local numMap = { "home", "hop", "hub", "history", "settings", "note" }
        tabKey = numMap[tabKey] or "home"
    end

    setActiveTabStyle(tabKey)
    setLiveAction("Đã chuyển sang tab " .. (tabNamesVi[tabKey] or tostring(tabKey)), Color3.fromRGB(130, 215, 255))

    HomeContent.Visible = (tabKey == "home")
    HopContent.Visible = (tabKey == "hop")
    HubContent.Visible = (tabKey == "hub")
    Tab2Content.Visible = (tabKey == "history")
    Tab3Content.Visible = (tabKey == "settings")
    Tab4Content.Visible = (tabKey == "note")

    if tabKey == "settings" then
        refreshUpdateList()
    end

    local isHist = (tabKey == "history")
    HistorySearch.Visible = isHist
    HistoryFilterBtn.Visible = isHist
    HistoryClearBtn.Visible = isHist
    HistoryCountLabel.Visible = isHist
    if not isHist then
        HistoryFilterPopup.Visible = false
    else
        refreshHistory()
    end
end

onButtonClicked(TabHomeBtn, function() openTab("home") end)
onButtonClicked(TabHopBtn, function() openTab("hop") end)
onButtonClicked(TabHubBtn, function() openTab("hub") end)
onButtonClicked(TabHistoryBtn, function() openTab("history") end)
onButtonClicked(TabSettingsBtn, function() openTab("settings") end)
onButtonClicked(TabNoteBtn, function() openTab("note") end)
onButtonClicked(HomeQuickHopBtn, function() openTab("hop") end)

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
    if string.find(r, "divine") or string.find(r, "sovereign") or string.find(r, "secret") then
        return 16711680
    elseif string.find(r, "mythic") then
        return 11141375
    elseif string.find(r, "legendary") then
        return 16766720
    elseif string.find(r, "epic") then
        return 10181046
    elseif string.find(r, "rare") then
        return 3447003
    elseif string.find(r, "uncommon") then
        return 3066993
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
    local vnTimeString = getVnTimeString()

    if saveAndSendMode == "both" or saveAndSendMode == "save_only" then
        table.insert(HistoryRecords, {data = petData, time = vnTimeString})
        if refreshHistory then refreshHistory() end
    end

    local shouldSend = (saveAndSendMode == "both" or saveAndSendMode == "send_only")
    if not isRunning or not shouldSend or not httpRequest or WebhookURL == "" then
        return
    end

    local playerName = LocalPlayer.Name
    local displayName = LocalPlayer.DisplayName
    local userId = tostring(LocalPlayer.UserId)
    local profileLink = "https://www.roblox.com/users/" .. userId .. "/profile"
    local avatarThumb = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"

    local pingPrefix = (DiscordUserID ~= "") and ("<@" .. DiscordUserID .. "> ") or ""
    local payload = {
        ["content"] = pingPrefix .. "🎉 Bạn vừa bắt được một sinh vật mới!",
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
-- VÒNG LẶP CẬP NHẬT TRẠNG THÁI & HIỆU ỨNG
-- ==========================================
local frameCount = 0
local lastFpsUpdate = tick()
local currentFps = 60
local noteTickCount = 0

RunService.RenderStepped:Connect(function(dt)
    local now = tick()

    if isNoteShowing then
        noteTickCount = noteTickCount + dt
        local currentEffect = noteEffects[noteEffectIdx]
        if currentEffect == "CẦU VỒNG (RGB)" then
            local hue = (now * 0.25) % 1
            DisplayLabel.TextColor3 = Color3.fromHSV(hue, 0.85, 1)
        elseif currentEffect == "NHẤP NHÁY (PULSE)" then
            local alpha = (math.sin(noteTickCount * 4) + 1) / 2
            DisplayLabel.TextTransparency = alpha * 0.65
        elseif currentEffect == "LƠ LỬNG (FLOAT)" then
            local offset = math.sin(noteTickCount * 3) * 6
            DisplayLabel.Position = UDim2.new(0, 0, 0, offset)
        else
            DisplayLabel.Position = UDim2.new(0, 0, 0, 0)
        end
    end

    frameCount = frameCount + 1
    if now - lastFpsUpdate >= 0.5 then
        currentFps = math.floor(frameCount / (now - lastFpsUpdate))
        frameCount = 0
        lastFpsUpdate = now
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

    local plrCount = #Players:GetPlayers()
    local maxPlr = Players.MaxPlayers

    HomeInfoCard.Text = string.format(
        " 🏠 TỔNG QUAN HỆ THỐNG\n 👤 NGƯỜI CHƠI: %d/%d | ⏱️ CHẠY: %s\n 🇻🇳 %s | ⚡ FPS: %d | 📶 PING: %dms",
        plrCount, maxPlr, runTimeStr, vnClockStr, currentFps, ping
    )

    if DynamicIsland.Visible then
        IslandVnClockLabel.Text = getVnBlinkingClock()
    end
end)
