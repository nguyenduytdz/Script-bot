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
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

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
local isFarming = false
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
-- HỘP THOẠI HỎI TRƯỚC KHI XÓA (MẪU U436)
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
ConfirmCard.Size = UDim2.new(0, 296, 0, 224)
ConfirmCard.Position = UDim2.new(0.5, 0, 0.5, 0)
ConfirmCard.BackgroundColor3 = Color3.fromRGB(26, 27, 37)
ConfirmCard.BorderSizePixel = 0
ConfirmCard.ZIndex = 112
ConfirmCard.Parent = ConfirmOverlay
Instance.new("UICorner", ConfirmCard).CornerRadius = UDim.new(0, 20)

local ConfirmCardStroke = Instance.new("UIStroke")
ConfirmCardStroke.Color = Color3.fromRGB(255, 255, 255)
ConfirmCardStroke.Transparency = 0.84
ConfirmCardStroke.Thickness = 1
ConfirmCardStroke.Parent = ConfirmCard

local ConfirmIconTile = Instance.new("Frame")
ConfirmIconTile.Size = UDim2.new(0, 52, 0, 52)
ConfirmIconTile.Position = UDim2.new(0, 20, 0, 18)
ConfirmIconTile.BackgroundColor3 = Color3.fromRGB(217, 58, 85)
ConfirmIconTile.BackgroundTransparency = 0.86
ConfirmIconTile.BorderSizePixel = 0
ConfirmIconTile.ZIndex = 113
ConfirmIconTile.Parent = ConfirmCard
Instance.new("UICorner", ConfirmIconTile).CornerRadius = UDim.new(0, 16)

local ConfirmBinIcon = Instance.new("TextLabel")
ConfirmBinIcon.Size = UDim2.new(1, 0, 1, 0)
ConfirmBinIcon.BackgroundTransparency = 1
ConfirmBinIcon.Text = "🗑️"
ConfirmBinIcon.TextSize = 24
ConfirmBinIcon.Font = Enum.Font.GothamBold
ConfirmBinIcon.ZIndex = 114
ConfirmBinIcon.Parent = ConfirmIconTile

local ConfirmTitle = Instance.new("TextLabel")
ConfirmTitle.Size = UDim2.new(1, -40, 0, 24)
ConfirmTitle.Position = UDim2.new(0, 20, 0, 78)
ConfirmTitle.BackgroundTransparency = 1
ConfirmTitle.Text = "Xóa mục này?"
ConfirmTitle.TextColor3 = Color3.fromRGB(244, 240, 232)
ConfirmTitle.TextSize = 16
ConfirmTitle.Font = Enum.Font.GothamBold
ConfirmTitle.TextXAlignment = Enum.TextXAlignment.Left
ConfirmTitle.ZIndex = 113
ConfirmTitle.Parent = ConfirmCard

local ConfirmDesc = Instance.new("TextLabel")
ConfirmDesc.Size = UDim2.new(1, -40, 0, 44)
ConfirmDesc.Position = UDim2.new(0, 20, 0, 104)
ConfirmDesc.BackgroundTransparency = 1
ConfirmDesc.Text = "Dữ liệu đã chọn sẽ bị xóa khỏi lịch sử. Hành động này không thể hoàn tác."
ConfirmDesc.TextColor3 = Color3.fromRGB(185, 182, 194)
ConfirmDesc.TextSize = 12
ConfirmDesc.Font = Enum.Font.Gotham
ConfirmDesc.TextWrapped = true
ConfirmDesc.TextXAlignment = Enum.TextXAlignment.Left
ConfirmDesc.TextYAlignment = Enum.TextYAlignment.Top
ConfirmDesc.ZIndex = 113
ConfirmDesc.Parent = ConfirmCard

local ConfirmCancelBtn = Instance.new("TextButton")
ConfirmCancelBtn.Size = UDim2.new(0.5, -24, 0, 40)
ConfirmCancelBtn.Position = UDim2.new(0, 20, 1, -58)
ConfirmCancelBtn.BackgroundColor3 = Color3.fromRGB(38, 40, 54)
ConfirmCancelBtn.TextColor3 = Color3.fromRGB(244, 240, 232)
ConfirmCancelBtn.Text = "Hủy"
ConfirmCancelBtn.TextSize = 13
ConfirmCancelBtn.Font = Enum.Font.GothamBold
ConfirmCancelBtn.ZIndex = 114
ConfirmCancelBtn.Parent = ConfirmCard
Instance.new("UICorner", ConfirmCancelBtn).CornerRadius = UDim.new(0, 12)
local CancelBtnStroke = Instance.new("UIStroke")
CancelBtnStroke.Color = Color3.fromRGB(255, 255, 255)
CancelBtnStroke.Transparency = 0.84
CancelBtnStroke.Thickness = 1
CancelBtnStroke.Parent = ConfirmCancelBtn

local ConfirmDeleteBtn = Instance.new("TextButton")
ConfirmDeleteBtn.Size = UDim2.new(0.5, -24, 0, 40)
ConfirmDeleteBtn.Position = UDim2.new(0.5, 4, 1, -58)
ConfirmDeleteBtn.BackgroundColor3 = Color3.fromRGB(229, 72, 77)
ConfirmDeleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmDeleteBtn.Text = "Xóa"
ConfirmDeleteBtn.TextSize = 13
ConfirmDeleteBtn.Font = Enum.Font.GothamBold
ConfirmDeleteBtn.ZIndex = 114
ConfirmDeleteBtn.Parent = ConfirmCard
Instance.new("UICorner", ConfirmDeleteBtn).CornerRadius = UDim.new(0, 12)

local pendingDeleteCallback = nil
local isConfirmBusy = false

local function closeConfirmDialog()
    isConfirmBusy = false
    pendingDeleteCallback = nil
    ConfirmOverlay.Visible = false
    ConfirmBinIcon.Text = "🗑️"
    ConfirmBinIcon.Rotation = 0
    ConfirmDeleteBtn.Text = "Xóa"
end

local function promptDeleteConfirm(titleText, descText, onConfirmed)
    if isConfirmBusy then return end
    pendingDeleteCallback = onConfirmed
    ConfirmTitle.Text = titleText or "Xác nhận xóa?"
    ConfirmDesc.Text = descText or "Hành động này sẽ xóa dữ liệu đã chọn."
    ConfirmBinIcon.Text = "🗑️"
    ConfirmBinIcon.Rotation = 0
    ConfirmDeleteBtn.Text = "Xóa"
    ConfirmOverlay.Visible = true
    ConfirmCard.Size = UDim2.new(0, 266, 0, 202)
    TweenService:Create(ConfirmCard, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 296, 0, 224)
    }):Play()
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
    ConfirmBinIcon.Text = "📥"
    TweenService:Create(ConfirmBinIcon, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Rotation = -28
    }):Play()
    task.delay(0.28, function()
        if pendingDeleteCallback then
            pcall(pendingDeleteCallback)
        end
        closeConfirmDialog()
    end)
end)

-- GHI CHÚ NỔI TRÊN MÀN HÌNH
local DisplayContainer = Instance.new("Frame")
DisplayContainer.Name = "ScreenNoteDisplay"
DisplayContainer.Size = UDim2.new(0, 280, 0, 54)
DisplayContainer.Position = UDim2.new(0.5, -140, 0.14, 0)
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
DisplayLabel.TextSize = 22
DisplayLabel.Font = Enum.Font.FredokaOne
DisplayLabel.TextWrapped = true
DisplayLabel.RichText = true
DisplayLabel.ZIndex = 66
DisplayLabel.Parent = DisplayContainer

local TextStroke = Instance.new("UIStroke")
TextStroke.Thickness = 2
TextStroke.Color = Color3.fromRGB(0, 0, 0)
TextStroke.Parent = DisplayLabel

attachDrag(DisplayContainer, DisplayLabel)

local ToggleIconBtn = Instance.new("TextButton")
ToggleIconBtn.Name = "ToggleIconBtn"
ToggleIconBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleIconBtn.Position = UDim2.new(0.05, 0, 0.14, 0)
ToggleIconBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ToggleIconBtn.TextColor3 = Color3.fromRGB(255, 220, 50)
ToggleIconBtn.TextSize = 22
ToggleIconBtn.Font = Enum.Font.GothamBold
ToggleIconBtn.Text = "⚡"
ToggleIconBtn.Active = true
ToggleIconBtn.Visible = false
ToggleIconBtn.ZIndex = 20
ToggleIconBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleIconBtn).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(224, 86, 36)
IconStroke.Thickness = 2
IconStroke.Parent = ToggleIconBtn

-- Giữ nguyên kích thước 326x360 của giao diện chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 326, 0, 360)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 18)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(123, 97, 255)
MainStroke.Transparency = 0.45
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

local isMenuVisible = true
onButtonClicked(ToggleIconBtn, function()
    if not isUiReady then return end
    isMenuVisible = not isMenuVisible
    MainFrame.Visible = isMenuVisible
    setLiveAction(isMenuVisible and "Đã mở giao diện chính" or "Đã thu gọn giao diện", Color3.fromRGB(255, 225, 110))
    TweenService:Create(ToggleIconBtn, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Rotation = ToggleIconBtn.Rotation + 360
    }):Play()
end)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -16, 0, 26)
TitleLabel.Position = UDim2.new(0, 8, 0, 4)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🐾 Throw Food Auto Logger"
TitleLabel.TextColor3 = Color3.fromRGB(244, 240, 232)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.ZIndex = 11
TitleLabel.Parent = MainFrame

-- THANH TAB NẰM BÊN DƯỚI MENU NHỎ GỌN (ĐÃ THAY WEBHOOK BẰNG TAB FARM)
local BottomTabBar = Instance.new("ScrollingFrame")
BottomTabBar.Name = "BottomTabBar"
BottomTabBar.Size = UDim2.new(1, -14, 0, 36)
BottomTabBar.Position = UDim2.new(0, 7, 1, -42)
BottomTabBar.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
BottomTabBar.BorderSizePixel = 0
BottomTabBar.ScrollingDirection = Enum.ScrollingDirection.X
BottomTabBar.ScrollBarThickness = 2
BottomTabBar.ScrollBarImageColor3 = Color3.fromRGB(115, 130, 175)
BottomTabBar.CanvasSize = UDim2.new(0, 462, 0, 0)
BottomTabBar.ZIndex = 14
BottomTabBar.Parent = MainFrame
Instance.new("UICorner", BottomTabBar).CornerRadius = UDim.new(0, 10)

local TabBarLayout = Instance.new("UIListLayout")
TabBarLayout.FillDirection = Enum.FillDirection.Horizontal
TabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabBarLayout.Padding = UDim.new(0, 5)
TabBarLayout.Parent = BottomTabBar

local TabBarPad = Instance.new("UIPadding")
TabBarPad.PaddingLeft = UDim.new(0, 5)
TabBarPad.PaddingRight = UDim.new(0, 5)
TabBarPad.Parent = BottomTabBar

local function makeBottomTabBtn(order, text)
    local b = Instance.new("TextButton")
    b.LayoutOrder = order
    b.Size = UDim2.new(0, 72, 0, 26)
    b.BackgroundColor3 = Color3.fromRGB(40, 42, 56)
    b.TextColor3 = Color3.fromRGB(205, 210, 224)
    b.TextSize = 9
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.ZIndex = 16
    b.Parent = BottomTabBar
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    return b
end

local TabHomeBtn = makeBottomTabBtn(1, "🏠 Home")
local TabFarmBtn = makeBottomTabBtn(2, "🌾 Farm")
local TabHopBtn = makeBottomTabBtn(3, "🌐 Hop Sever")
local TabHistoryBtn = makeBottomTabBtn(4, "📜 Lịch sử")
local TabSettingsBtn = makeBottomTabBtn(5, "⚙️ Settings")
local TabNoteBtn = makeBottomTabBtn(6, "📝 Ghi chú")

-- ==========================================
-- DYNAMIC ISLAND TRÊN ĐẦU MÀN HÌNH
-- ==========================================
local DynamicIsland = Instance.new("Frame")
DynamicIsland.Name = "u459DynamicIsland"
DynamicIsland.AnchorPoint = Vector2.new(0.5, 0)
DynamicIsland.Position = UDim2.new(0.5, 0, 0, 6)
DynamicIsland.Size = UDim2.new(0, 210, 0, 34)
DynamicIsland.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DynamicIsland.BorderSizePixel = 0
DynamicIsland.Visible = true
DynamicIsland.ZIndex = 80
DynamicIsland.Parent = ScreenGui
local IslandCorner = Instance.new("UICorner", DynamicIsland)
IslandCorner.CornerRadius = UDim.new(0, 17)

local IslandStroke = Instance.new("UIStroke")
IslandStroke.Color = Color3.fromRGB(255, 255, 255)
IslandStroke.Transparency = 0.85
IslandStroke.Thickness = 1
IslandStroke.Parent = DynamicIsland

local IslandCompactText = Instance.new("TextLabel")
IslandCompactText.Size = UDim2.new(1, -20, 1, 0)
IslandCompactText.Position = UDim2.new(0, 10, 0, 0)
IslandCompactText.BackgroundTransparency = 1
IslandCompactText.Text = "🟢 0 Pet • 00:00:00"
IslandCompactText.TextColor3 = Color3.fromRGB(255, 255, 255)
IslandCompactText.TextSize = 11
IslandCompactText.Font = Enum.Font.GothamBold
IslandCompactText.TextXAlignment = Enum.TextXAlignment.Center
IslandCompactText.ZIndex = 82
IslandCompactText.Parent = DynamicIsland

local IslandExpandedText = Instance.new("TextLabel")
IslandExpandedText.Size = UDim2.new(1, -24, 1, -10)
IslandExpandedText.Position = UDim2.new(0, 12, 0, 5)
IslandExpandedText.BackgroundTransparency = 1
IslandExpandedText.Text = ""
IslandExpandedText.TextColor3 = Color3.fromRGB(244, 240, 232)
IslandExpandedText.TextSize = 11
IslandExpandedText.Font = Enum.Font.Code
IslandExpandedText.TextWrapped = true
IslandExpandedText.TextXAlignment = Enum.TextXAlignment.Left
IslandExpandedText.TextYAlignment = Enum.TextYAlignment.Center
IslandExpandedText.Visible = false
IslandExpandedText.ZIndex = 82
IslandExpandedText.Parent = DynamicIsland

local IslandTapBtn = Instance.new("TextButton")
IslandTapBtn.Size = UDim2.new(1, 0, 1, 0)
IslandTapBtn.Position = UDim2.new(0, 0, 0, 0)
IslandTapBtn.BackgroundTransparency = 1
IslandTapBtn.Text = ""
IslandTapBtn.ZIndex = 85
IslandTapBtn.Parent = DynamicIsland

local isIslandExpanded = false
local function setIslandExpanded(expanded)
    isIslandExpanded = expanded
    if expanded then
        IslandCompactText.Visible = false
        IslandExpandedText.Visible = true
        TweenService:Create(DynamicIsland, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
           Size = UDim2.new(0, 326, 0, 78)
        }):Play()
        TweenService:Create(IslandCorner, TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CornerRadius = UDim.new(0, 22)
        }):Play()
    else
        IslandExpandedText.Visible = false
        IslandCompactText.Visible = true
        TweenService:Create(DynamicIsland, TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 210, 0, 34)
        }):Play()
        TweenService:Create(IslandCorner, TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CornerRadius = UDim.new(0, 17)
        }):Play()
    end
end

onButtonClicked(IslandTapBtn, function()
    setIslandExpanded(not isIslandExpanded)
end)

-- ==========================================
-- KHUNG CHỮ NHẬT NẰM NGANG CHỈ HIỆN KHI CHẠY INTRO
-- ==========================================
local IntroRectFrame = Instance.new("Frame")
IntroRectFrame.Name = "IntroHorizontalRect"
IntroRectFrame.AnchorPoint = Vector2.new(0.5, 0.5)
IntroRectFrame.Size = UDim2.new(0, 480, 0, 180)
IntroRectFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
IntroRectFrame.BackgroundColor3 = Color3.fromRGB(10, 16, 28)
IntroRectFrame.BorderSizePixel = 0
IntroRectFrame.ZIndex = 90
IntroRectFrame.Parent = ScreenGui
Instance.new("UICorner", IntroRectFrame).CornerRadius = UDim.new(0, 18)
local IntroStroke = Instance.new("UIStroke")
IntroStroke.Color = Color3.fromRGB(115, 195, 255)
IntroStroke.Thickness = 1.5
IntroStroke.Parent = IntroRectFrame

local IntroLabel = Instance.new("TextLabel")
IntroLabel.Size = UDim2.new(1, -24, 0, 20)
IntroLabel.Position = UDim2.new(0, 12, 0, 8)
IntroLabel.BackgroundTransparency = 1
IntroLabel.Text = "✦ INTRO ORBIT CORE"
IntroLabel.TextColor3 = Color3.fromRGB(165, 220, 255)
IntroLabel.TextSize = 11
IntroLabel.Font = Enum.Font.GothamBold
IntroLabel.TextXAlignment = Enum.TextXAlignment.Left
IntroLabel.ZIndex = 91
IntroLabel.Parent = IntroRectFrame

local IntroStage = Instance.new("Frame")
IntroStage.Size = UDim2.new(1, -24, 0, 102)
IntroStage.Position = UDim2.new(0, 12, 0, 30)
IntroStage.BackgroundColor3 = Color3.fromRGB(12, 22, 42)
IntroStage.BorderSizePixel = 0
IntroStage.ClipsDescendants = true
IntroStage.ZIndex = 91
IntroStage.Parent = IntroRectFrame
Instance.new("UICorner", IntroStage).CornerRadius = UDim.new(0, 12)

local OrbitCenter = Instance.new("Frame")
OrbitCenter.AnchorPoint = Vector2.new(0.5, 0.5)
OrbitCenter.Size = UDim2.new(0, 74, 0, 74)
OrbitCenter.Position = UDim2.new(0.5, 0, 0.5, 0)
OrbitCenter.BackgroundTransparency = 1
OrbitCenter.ZIndex = 93
OrbitCenter.Parent = IntroStage

local ringSpecs = {
    {w = 72, h = 24, rot = 0,   color = Color3.fromRGB(190, 230, 255)},
    {w = 72, h = 24, rot = 60,  color = Color3.fromRGB(120, 195, 255)},
    {w = 72, h = 24, rot = -60, color = Color3.fromRGB(150, 215, 255)},
    {w = 56, h = 56, rot = 30,  color = Color3.fromRGB(220, 245, 255)}
}

local orbitRings = {}
local orbitTips = {}
for i, spec in ipairs(ringSpecs) do
    local ring = Instance.new("Frame")
    ring.AnchorPoint = Vector2.new(0.5, 0.5)
    ring.Size = UDim2.new(0, spec.w, 0, spec.h)
    ring.Position = UDim2.new(0.5, 0, 0.5, 0)
    ring.Rotation = spec.rot
    ring.BackgroundTransparency = 1
    ring.ZIndex = 93
    ring.Parent = OrbitCenter

    local stroke = Instance.new("UIStroke")
    stroke.Color = spec.color
    stroke.Thickness = 1.6
    stroke.Transparency = 0.85
    stroke.Parent = ring
    table.insert(orbitRings, stroke)

    local tip = Instance.new("Frame")
    tip.AnchorPoint = Vector2.new(0.5, 0.5)
    tip.Size = UDim2.new(0, 7, 0, 7)
    tip.Position = UDim2.new(1, 0, 0.5, 0)
    tip.BackgroundColor3 = Color3.fromRGB(240, 250, 255)
    tip.BorderSizePixel = 0
    tip.ZIndex = 95
    tip.Parent = ring
    Instance.new("UICorner", tip).CornerRadius = UDim.new(1, 0)
    table.insert(orbitTips, tip)
end

local SweepBeam = Instance.new("Frame")
SweepBeam.AnchorPoint = Vector2.new(0.5, 0.5)
SweepBeam.Size = UDim2.new(0, 140, 0, 2)
SweepBeam.Position = UDim2.new(0.35, 0, 0.72, 0)
SweepBeam.Rotation = -22
SweepBeam.BackgroundColor3 = Color3.fromRGB(210, 240, 255)
SweepBeam.BorderSizePixel = 0
SweepBeam.ZIndex = 94
SweepBeam.Parent = IntroStage
Instance.new("UICorner", SweepBeam).CornerRadius = UDim.new(1, 0)

local CoreHalo = Instance.new("Frame")
CoreHalo.AnchorPoint = Vector2.new(0.5, 0.5)
CoreHalo.Size = UDim2.new(0, 10, 0, 10)
CoreHalo.Position = UDim2.new(0.5, 0, 0.5, 0)
CoreHalo.BackgroundColor3 = Color3.fromRGB(130, 200, 255)
CoreHalo.BackgroundTransparency = 0.7
CoreHalo.BorderSizePixel = 0
CoreHalo.ZIndex = 94
CoreHalo.Parent = IntroStage
Instance.new("UICorner", CoreHalo).CornerRadius = UDim.new(1, 0)

local CoreFlare = Instance.new("Frame")
CoreFlare.AnchorPoint = Vector2.new(0.5, 0.5)
CoreFlare.Size = UDim2.new(0, 6, 0, 6)
CoreFlare.Position = UDim2.new(0.5, 0, 0.5, 0)
CoreFlare.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CoreFlare.BorderSizePixel = 0
CoreFlare.ZIndex = 97
CoreFlare.Parent = IntroStage
Instance.new("UICorner", CoreFlare).CornerRadius = UDim.new(1, 0)

local FlareRayH = Instance.new("Frame")
FlareRayH.AnchorPoint = Vector2.new(0.5, 0.5)
FlareRayH.Size = UDim2.new(0, 180, 0, 2)
FlareRayH.Position = UDim2.new(0.5, 0, 0.5, 0)
FlareRayH.BackgroundColor3 = Color3.fromRGB(215, 242, 255)
FlareRayH.BackgroundTransparency = 1
FlareRayH.BorderSizePixel = 0
FlareRayH.ZIndex = 96
FlareRayH.Parent = IntroStage

local FlareRayV = Instance.new("Frame")
FlareRayV.AnchorPoint = Vector2.new(0.5, 0.5)
FlareRayV.Size = UDim2.new(0, 2, 0, 92)
FlareRayV.Position = UDim2.new(0.5, 0, 0.5, 0)
FlareRayV.BackgroundColor3 = Color3.fromRGB(215, 242, 255)
FlareRayV.BackgroundTransparency = 1
FlareRayV.BorderSizePixel = 0
FlareRayV.ZIndex = 96
FlareRayV.Parent = IntroStage

local IntroBarBg = Instance.new("Frame")
IntroBarBg.Size = UDim2.new(1, -24, 0, 7)
IntroBarBg.Position = UDim2.new(0, 12, 0, 139)
IntroBarBg.BackgroundColor3 = Color3.fromRGB(20, 26, 40)
IntroBarBg.BorderSizePixel = 0
IntroBarBg.ZIndex = 91
IntroBarBg.Parent = IntroRectFrame
Instance.new("UICorner", IntroBarBg).CornerRadius = UDim.new(1, 0)

local IntroBarFill = Instance.new("Frame")
IntroBarFill.Size = UDim2.new(0, 0, 1, 0)
IntroBarFill.BackgroundColor3 = Color3.fromRGB(145, 215, 255)
IntroBarFill.BorderSizePixel = 0
IntroBarFill.ZIndex = 92
IntroBarFill.Parent = IntroBarBg
Instance.new("UICorner", IntroBarFill).CornerRadius = UDim.new(1, 0)

local IntroSubLabel = Instance.new("TextLabel")
IntroSubLabel.Size = UDim2.new(1, -24, 0, 18)
IntroSubLabel.Position = UDim2.new(0, 12, 0, 151)
IntroSubLabel.BackgroundTransparency = 1
IntroSubLabel.Text = "Đang chạy intro... 0%"
IntroSubLabel.TextColor3 = Color3.fromRGB(190, 215, 240)
IntroSubLabel.TextSize = 10
IntroSubLabel.Font = Enum.Font.Code
IntroSubLabel.TextXAlignment = Enum.TextXAlignment.Left
IntroSubLabel.ZIndex = 91
IntroSubLabel.Parent = IntroRectFrame

local openTab

local introElapsed = 0
local introDuration = 3.2
local introConn
introConn = RunService.Heartbeat:Connect(function(dt)
    introElapsed = introElapsed + dt
    local ratio = math.clamp(introElapsed / introDuration, 0, 1)
    IntroBarFill.Size = UDim2.new(ratio, 0, 1, 0)
    IntroSubLabel.Text = string.format("Đang chạy intro... %d%%", math.floor(ratio * 100))

    local sweepP = math.clamp(ratio / 0.55, 0, 1)
    SweepBeam.Position = UDim2.new(0.28 + 0.22 * sweepP, 0, 0.75 - 0.25 * sweepP, 0)
    SweepBeam.BackgroundTransparency = sweepP > 0.85 and ((sweepP - 0.85) / 0.15) or 0

    local convergeP = math.clamp((ratio - 0.1) / 0.5, 0, 1)
    for i, stroke in ipairs(orbitRings) do
        stroke.Transparency = 0.85 - 0.65 * convergeP
        local tip = orbitTips[i]
        local angle = (introElapsed * (1.8 + i * 0.45)) + (i * 1.4)
        local rx = (0.35 - 0.15 * convergeP) * math.cos(angle)
        local ry = (0.35 - 0.15 * convergeP) * math.sin(angle)
        tip.Position = UDim2.new(0.5 + rx, 0, 0.5 + ry, 0)
    end

    local spinBoost = ratio > 0.55 and ((ratio - 0.55) * 4.5) or 0
    OrbitCenter.Rotation = (introElapsed * 65 + spinBoost * 30) % 360

    local flareP = math.clamp((ratio - 0.72) / 0.28, 0, 1)
    local haloSize = 10 + flareP * 78
    CoreHalo.Size = UDim2.new(0, haloSize, 0, haloSize)
    CoreHalo.BackgroundTransparency = 0.72 - 0.42 * flareP

    local coreSize = 6 + flareP * 18
    CoreFlare.Size = UDim2.new(0, coreSize, 0, coreSize)

    FlareRayH.BackgroundTransparency = 1 - flareP * 0.85
    FlareRayV.BackgroundTransparency = 1 - flareP * 0.85
    FlareRayH.Size = UDim2.new(0, 60 + flareP * 180, 0, 2)
    FlareRayV.Size = UDim2.new(0, 2, 0, 24 + flareP * 72)

    if ratio >= 1 then
        if introConn then introConn:Disconnect() end
        if IntroRectFrame then
            IntroRectFrame:Destroy()
        end
        isUiReady = true
        if openTab then openTab("home") end
        ToggleIconBtn.Visible = true
        MainFrame.Visible = true
        isMenuVisible = true
        setLiveAction("Đã tải xong menu - Sẵn sàng hoạt động", Color3.fromRGB(46, 204, 113))
    end
end)

local CONTENT_TOP_Y = 34
local CONTENT_HEIGHT = 278

-- --- TAB HOME ---
local HomeContent = Instance.new("ScrollingFrame")
HomeContent.Size = UDim2.new(1, -16, 0, CONTENT_HEIGHT)
HomeContent.Position = UDim2.new(0, 8, 0, CONTENT_TOP_Y)
HomeContent.BackgroundTransparency = 1
HomeContent.BorderSizePixel = 0
HomeContent.CanvasSize = UDim2.new(0, 0, 0, 300)
HomeContent.ScrollBarThickness = 5
HomeContent.ScrollBarImageColor3 = Color3.fromRGB(130, 140, 175)
HomeContent.Visible = true
HomeContent.ZIndex = 12
HomeContent.Parent = MainFrame

local HomeInfoCard = Instance.new("TextLabel")
HomeInfoCard.Size = UDim2.new(1, -8, 0, 128)
HomeInfoCard.Position = UDim2.new(0, 0, 0, 0)
HomeInfoCard.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
HomeInfoCard.TextColor3 = Color3.fromRGB(232, 235, 245)
HomeInfoCard.TextSize = 11
HomeInfoCard.Font = Enum.Font.Code
HomeInfoCard.TextWrapped = true
HomeInfoCard.TextXAlignment = Enum.TextXAlignment.Left
HomeInfoCard.TextYAlignment = Enum.TextYAlignment.Top
HomeInfoCard.Text = " 🏠 TỔNG QUAN HỆ THỐNG\n Đang tải thông tin server..."
HomeInfoCard.ZIndex = 13
HomeInfoCard.Parent = HomeContent
Instance.new("UICorner", HomeInfoCard).CornerRadius = UDim.new(0, 8)

local HomeJobBox = Instance.new("TextBox")
HomeJobBox.Size = UDim2.new(1, -8, 0, 32)
HomeJobBox.Position = UDim2.new(0, 0, 0, 136)
HomeJobBox.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
HomeJobBox.TextColor3 = Color3.fromRGB(130, 215, 255)
HomeJobBox.TextSize = 10
HomeJobBox.Font = Enum.Font.Code
HomeJobBox.TextEditable = false
HomeJobBox.ClearTextOnFocus = false
HomeJobBox.Text = tostring(game.JobId ~= "" and game.JobId or "Studio / Local")
HomeJobBox.ZIndex = 13
HomeJobBox.Parent = HomeContent
Instance.new("UICorner", HomeJobBox).CornerRadius = UDim.new(0, 7)

local HomeCopyJobBtn = Instance.new("TextButton")
HomeCopyJobBtn.Size = UDim2.new(1, -8, 0, 32)
HomeCopyJobBtn.Position = UDim2.new(0, 0, 0, 174)
HomeCopyJobBtn.BackgroundColor3 = Color3.fromRGB(61, 139, 255)
HomeCopyJobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeCopyJobBtn.TextSize = 11
HomeCopyJobBtn.Font = Enum.Font.GothamBold
HomeCopyJobBtn.Text = "📋 Copy JobId Sever Hiện Tại"
HomeCopyJobBtn.ZIndex = 13
HomeCopyJobBtn.Parent = HomeContent
Instance.new("UICorner", HomeCopyJobBtn).CornerRadius = UDim.new(0, 8)

local HomeQuickHopBtn = Instance.new("TextButton")
HomeQuickHopBtn.Size = UDim2.new(1, -8, 0, 32)
HomeQuickHopBtn.Position = UDim2.new(0, 0, 0, 212)
HomeQuickHopBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
HomeQuickHopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeQuickHopBtn.TextSize = 11
HomeQuickHopBtn.Font = Enum.Font.GothamBold
HomeQuickHopBtn.Text = "🌐 Mở Tab Hop Sever"
HomeQuickHopBtn.ZIndex = 13
HomeQuickHopBtn.Parent = HomeContent
Instance.new("UICorner", HomeQuickHopBtn).CornerRadius = UDim.new(0, 8)

-- ==========================================
-- TAB FARM (THAY THẾ TAB WEBHOOK)
-- 1. Độ hiếm (Common -> Divine) [> / v]
-- 2. Khu vực farm [> / v]
-- 3. Cách đi đến thứ đó (Teleporting, Đi bộ) [> / v]
-- 4. Cách mang về (Bay, Đi về, Bay nhanh) [> / v]
-- + Nút Farm ở bên dưới
-- ==========================================
local FarmContent = Instance.new("ScrollingFrame")
FarmContent.Size = UDim2.new(1, -16, 0, CONTENT_HEIGHT)
FarmContent.Position = UDim2.new(0, 8, 0, CONTENT_TOP_Y)
FarmContent.BackgroundTransparency = 1
FarmContent.BorderSizePixel = 0
FarmContent.ScrollingDirection = Enum.ScrollingDirection.Y
FarmContent.CanvasSize = UDim2.new(0, 0, 0, 420)
FarmContent.ScrollBarThickness = 5
FarmContent.ScrollBarImageColor3 = Color3.fromRGB(130, 140, 175)
FarmContent.Visible = false
FarmContent.ZIndex = 12
FarmContent.Parent = MainFrame

local FarmLayout = Instance.new("UIListLayout")
FarmLayout.SortOrder = Enum.SortOrder.LayoutOrder
FarmLayout.Padding = UDim.new(0, 6)
FarmLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
FarmLayout.Parent = FarmContent

local FarmStatusLabel = Instance.new("TextLabel")
FarmStatusLabel.LayoutOrder = 1
FarmStatusLabel.Size = UDim2.new(1, -8, 0, 34)
FarmStatusLabel.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
FarmStatusLabel.TextColor3 = Color3.fromRGB(220, 230, 245)
FarmStatusLabel.TextSize = 10
FarmStatusLabel.Font = Enum.Font.Code
FarmStatusLabel.TextWrapped = true
FarmStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
FarmStatusLabel.Text = " 🌾 Chế độ Farm: Sẵn sàng"
FarmStatusLabel.ZIndex = 13
FarmStatusLabel.Parent = FarmContent
Instance.new("UICorner", FarmStatusLabel).CornerRadius = UDim.new(0, 7)

local RARITY_ORDER = {
    "Common",
    "Uncommon",
    "Rare",
    "Epic",
    "Legendary",
    "Mythic",
    "Secret",
    "Divine"
}

local selectedRarities = {}
for _, rName in ipairs(RARITY_ORDER) do
    selectedRarities[rName] = true
end

local selectedAreaName = "Khu vực mặc định"
local selectedAreaCFrame = nil
local travelMethod = "Teleporting" -- "Teleporting" | "Đi bộ"
local returnMethod = "Bay"         -- "Bay" | "Đi về" | "Bay nhanh"

local function createCollapsibleSection(orderNum, titleText, initialOpen)
    local isOpen = initialOpen and true or false

    local container = Instance.new("Frame")
    container.LayoutOrder = orderNum
    container.Size = UDim2.new(1, -8, 0, 30)
    container.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
    container.BorderSizePixel = 0
    container.ClipsDescendants = true
    container.ZIndex = 13
    container.Parent = FarmContent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, 0, 0, 30)
    headerBtn.Position = UDim2.new(0, 0, 0, 0)
    headerBtn.BackgroundColor3 = Color3.fromRGB(38, 41, 56)
    headerBtn.TextColor3 = Color3.fromRGB(244, 240, 232)
    headerBtn.TextSize = 10
    headerBtn.Font = Enum.Font.GothamBold
    headerBtn.TextXAlignment = Enum.TextXAlignment.Left
    headerBtn.Text = (isOpen and " v " or " > ") .. titleText
    headerBtn.ZIndex = 14
    headerBtn.Parent = container
    Instance.new("UICorner", headerBtn).CornerRadius = UDim.new(0, 8)

    local bodyFrame = Instance.new("Frame")
    bodyFrame.Size = UDim2.new(1, -12, 0, 10)
    bodyFrame.Position = UDim2.new(0, 6, 0, 35)
    bodyFrame.BackgroundTransparency = 1
    bodyFrame.Visible = isOpen
    bodyFrame.ZIndex = 13
    bodyFrame.Parent = container

    local bodyLayout = Instance.new("UIListLayout")
    bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    bodyLayout.Padding = UDim.new(0, 4)
    bodyLayout.Parent = bodyFrame

    local function refreshSectionHeight()
        if isOpen then
            headerBtn.Text = " v " .. titleText
            bodyFrame.Visible = true
            local h = bodyLayout.AbsoluteContentSize.Y + 42
            container.Size = UDim2.new(1, -8, 0, math.max(36, h))
        else
            headerBtn.Text = " > " .. titleText
            bodyFrame.Visible = false
            container.Size = UDim2.new(1, -8, 0, 30)
        end
        task.defer(function()
            FarmContent.CanvasSize = UDim2.new(0, 0, 0, FarmLayout.AbsoluteContentSize.Y + 14)
        end)
    end

    bodyLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if isOpen then
            refreshSectionHeight()
        end
    end)

    onButtonClicked(headerBtn, function()
        isOpen = not isOpen
        refreshSectionHeight()
        setLiveAction((isOpen and "Mở mục: " or "Đóng mục: ") .. titleText, Color3.fromRGB(130, 215, 255))
    end)

    return container, bodyFrame, refreshSectionHeight
end

-- 1. Độ hiếm từ Common -> Divine
local _, rarityBody, refreshRaritySec = createCollapsibleSection(2, "1. Độ hiếm cần farm (Common - Divine)", true)

local rarityButtons = {}
local function updateRarityButtonsVisual()
    for _, rName in ipairs(RARITY_ORDER) do
        local btn = rarityButtons[rName]
        if btn then
            if selectedRarities[rName] then
                btn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Text = "✔ " .. rName
            else
                btn.BackgroundColor3 = Color3.fromRGB(45, 48, 64)
                btn.TextColor3 = Color3.fromRGB(185, 190, 210)
                btn.Text = "  " .. rName
            end
        end
    end
end

for idx, rName in ipairs(RARITY_ORDER) do
    local rBtn = Instance.new("TextButton")
    rBtn.LayoutOrder = idx
    rBtn.Size = UDim2.new(1, 0, 0, 24)
    rBtn.TextSize = 10
    rBtn.Font = Enum.Font.GothamBold
    rBtn.TextXAlignment = Enum.TextXAlignment.Left
    rBtn.ZIndex = 14
    rBtn.Parent = rarityBody
    Instance.new("UICorner", rBtn).CornerRadius = UDim.new(0, 5)
    rarityButtons[rName] = rBtn

    onButtonClicked(rBtn, function()
        selectedRarities[rName] = not selectedRarities[rName]
        updateRarityButtonsVisual()
        setLiveAction(
            (selectedRarities[rName] and "Bật độ hiếm: " or "Tắt độ hiếm: ") .. rName,
            Color3.fromRGB(130, 235, 185)
        )
    end)
end
updateRarityButtonsVisual()

-- 2. Chọn khu vực để farm
local _, areaBody, refreshAreaSec = createCollapsibleSection(3, "2. Chọn khu vực để farm", false)

local areaButtons = {}
local function discoverFarmAreas()
    local areas = {}
    local seen = {}

    local function addArea(name, cf)
        if not name or name == "" or seen[name] then return end
        seen[name] = true
        table.insert(areas, { name = name, cf = cf })
    end

    local foldersToScan = {
        Workspace:FindFirstChild("Zones"),
        Workspace:FindFirstChild("Areas"),
        Workspace:FindFirstChild("Map"),
        Workspace:FindFirstChild("Spawns"),
        Workspace:FindFirstChild("Regions")
    }

    for _, folder in ipairs(foldersToScan) do
        if folder then
            for _, obj in ipairs(folder:GetChildren()) do
                if obj:IsA("BasePart") then
                    addArea(obj.Name, obj.CFrame + Vector3.new(0, 4, 0))
                elseif obj:IsA("Model") then
                    local pivot = obj:GetPivot()
                    addArea(obj.Name, pivot + Vector3.new(0, 4, 0))
                end
            end
        end
    end

    if #areas == 0 then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local basePos = hrp and hrp.Position or Vector3.new(0, 5, 0)
        addArea("Khu vực hiện tại", CFrame.new(basePos))
        addArea("Khu vực 1 (Common/Rare)", CFrame.new(basePos + Vector3.new(25, 0, 0)))
        addArea("Khu vực 2 (Epic/Legendary)", CFrame.new(basePos + Vector3.new(-25, 0, 25)))
        addArea("Khu vực 3 (Mythic/Divine)", CFrame.new(basePos + Vector3.new(0, 0, -35)))
    end

    return areas
end

local function rebuildAreaButtons()
    for _, ch in ipairs(areaBody:GetChildren()) do
        if ch:IsA("TextButton") then
            ch:Destroy()
        end
    end
    areaButtons = {}

    local areas = discoverFarmAreas()
    if areas[1] and not selectedAreaCFrame then
        selectedAreaName = areas[1].name
        selectedAreaCFrame = areas[1].cf
    end

    for idx, ar in ipairs(areas) do
        local b = Instance.new("TextButton")
        b.LayoutOrder = idx
        b.Size = UDim2.new(1, 0, 0, 24)
        b.TextSize = 10
        b.Font = Enum.Font.GothamBold
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.ZIndex = 14
        b.Parent = areaBody
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)

        local isCur = (selectedAreaName == ar.name)
        b.BackgroundColor3 = isCur and Color3.fromRGB(61, 139, 255) or Color3.fromRGB(45, 48, 64)
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Text = (isCur and "📍 " or "  ") .. ar.name
        areaButtons[ar.name] = b

        onButtonClicked(b, function()
            selectedAreaName = ar.name
            selectedAreaCFrame = ar.cf
            rebuildAreaButtons()
            setLiveAction("Đã chọn khu vực farm: " .. ar.name, Color3.fromRGB(130, 215, 255))
        end)
    end
end
rebuildAreaButtons()

-- 3. Cách đi đến thứ đó (Teleporting, Đi bộ)
local _, travelBody, refreshTravelSec = createCollapsibleSection(4, "3. Cách đi đến thứ đó", false)

local travelOptions = { "Teleporting", "Đi bộ" }
local function rebuildTravelButtons()
    for _, ch in ipairs(travelBody:GetChildren()) do
        if ch:IsA("TextButton") then
            ch:Destroy()
        end
    end

    for idx, mode in ipairs(travelOptions) do
        local b = Instance.new("TextButton")
        b.LayoutOrder = idx
        b.Size = UDim2.new(1, 0, 0, 24)
        b.TextSize = 10
        b.Font = Enum.Font.GothamBold
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.ZIndex = 14
        b.Parent = travelBody
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)

        local active = (travelMethod == mode)
        b.BackgroundColor3 = active and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(45, 48, 64)
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Text = (active and "✔ " or "  ") .. mode

        onButtonClicked(b, function()
            travelMethod = mode
            rebuildTravelButtons()
            setLiveAction("Cách đi đến: " .. mode, Color3.fromRGB(46, 204, 113))
        end)
    end
end
rebuildTravelButtons()

-- 4. Cách mang về (Bay, Đi về, Bay nhanh)
local _, returnBody, refreshReturnSec = createCollapsibleSection(5, "4. Cách mang về", false)

local returnOptions = { "Bay", "Đi về", "Bay nhanh" }
local function rebuildReturnButtons()
    for _, ch in ipairs(returnBody:GetChildren()) do
        if ch:IsA("TextButton") then
            ch:Destroy()
        end
    end

    for idx, mode in ipairs(returnOptions) do
        local b = Instance.new("TextButton")
        b.LayoutOrder = idx
        b.Size = UDim2.new(1, 0, 0, 24)
        b.TextSize = 10
        b.Font = Enum.Font.GothamBold
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.ZIndex = 14
        b.Parent = returnBody
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)

        local active = (returnMethod == mode)
        b.BackgroundColor3 = active and Color3.fromRGB(142, 68, 173) or Color3.fromRGB(45, 48, 64)
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Text = (active and "✔ " or "  ") .. mode

        onButtonClicked(b, function()
            returnMethod = mode
            rebuildReturnButtons()
            setLiveAction("Cách mang về: " .. mode, Color3.fromRGB(205, 140, 255))
        end)
    end
end
rebuildReturnButtons()

-- Nút Farm nằm bên dưới các phần chọn lọc
local FarmActionBtn = Instance.new("TextButton")
FarmActionBtn.LayoutOrder = 6
FarmActionBtn.Size = UDim2.new(1, -8, 0, 36)
FarmActionBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
FarmActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmActionBtn.TextSize = 12
FarmActionBtn.Font = Enum.Font.GothamBold
FarmActionBtn.Text = "🌾 BẮT ĐẦU FARM"
FarmActionBtn.ZIndex = 14
FarmActionBtn.Parent = FarmContent
Instance.new("UICorner", FarmActionBtn).CornerRadius = UDim.new(0, 8)

FarmLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    FarmContent.CanvasSize = UDim2.new(0, 0, 0, FarmLayout.AbsoluteContentSize.Y + 14)
end)

local function moveCharacterTo(targetCf, mode)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not targetCf then return end

    if mode == "Teleporting" or mode == "Bay nhanh" then
        hrp.CFrame = targetCf
    elseif mode == "Đi bộ" then
        if hum then
            hum:MoveTo(targetCf.Position)
        else
            hrp.CFrame = targetCf
        end
    elseif mode == "Bay" then
        local startCf = hrp.CFrame
        local steps = 18
        for i = 1, steps do
            if not isFarming and mode == "Bay" then break end
            local alpha = i / steps
            local pos = startCf.Position:Lerp(targetCf.Position, alpha) + Vector3.new(0, math.sin(alpha * math.pi) * 8, 0)
            hrp.CFrame = CFrame.new(pos)
            task.wait(0.03)
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.6)
        if isFarming then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local areas = discoverFarmAreas()
                local targetCf = selectedAreaCFrame or (areas[1] and areas[1].cf) or hrp.CFrame
                FarmStatusLabel.Text = string.format(
                    " 🌾 Đang Farm (%s) • Đi: %s • Về: %s",
                    selectedAreaName, travelMethod, returnMethod
                )
                moveCharacterTo(targetCf, travelMethod)

                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not isFarming then break end
                    if obj:IsA("ProximityPrompt") and obj.Enabled then
                        local parentPart = obj.Parent and (obj.Parent:IsA("BasePart") and obj.Parent or obj.Parent:FindFirstChildWhichIsA("BasePart", true))
                        if parentPart then
                            moveCharacterTo(parentPart.CFrame + Vector3.new(0, 2, 0), travelMethod)
                            pcall(function()
                                fireproximityprompt(obj)
                            end)
                            task.wait(0.25)
                            moveCharacterTo(targetCf, returnMethod)
                            break
                        end
                    end
                end
            end
        else
            FarmStatusLabel.Text = string.format(
                " ⏸️ Dừng Farm • Khu: %s • Đi: %s • Về: %s",
                selectedAreaName, travelMethod, returnMethod
            )
        end
    end
end)

onButtonClicked(FarmActionBtn, function()
    isFarming = not isFarming
    if isFarming then
        FarmActionBtn.Text = "⏹️ DỪNG FARM"
        FarmActionBtn.BackgroundColor3 = Color3.fromRGB(224, 86, 36)
        setLiveAction(
            string.format("Bắt đầu Farm (%s | %s -> %s)", selectedAreaName, travelMethod, returnMethod),
            Color3.fromRGB(46, 204, 113)
        )
    else
        FarmActionBtn.Text = "🌾 BẮT ĐẦU FARM"
        FarmActionBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        setLiveAction("Đã dừng Farm", Color3.fromRGB(255, 130, 85))
    end
end)

-- --- TAB HOP SEVER ---
local HopContent = Instance.new("ScrollingFrame")
HopContent.Size = UDim2.new(1, -16, 0, CONTENT_HEIGHT)
HopContent.Position = UDim2.new(0, 8, 0, CONTENT_TOP_Y)
HopContent.BackgroundTransparency = 1
HopContent.BorderSizePixel = 0
HopContent.ScrollingDirection = Enum.ScrollingDirection.Y
HopContent.CanvasSize = UDim2.new(0, 0, 0, 360)
HopContent.ScrollBarThickness = 5
HopContent.ScrollBarImageColor3 = Color3.fromRGB(130, 140, 175)
HopContent.Visible = false
HopContent.ZIndex = 12
HopContent.Parent = MainFrame

local HopStatusLabel = Instance.new("TextLabel")
HopStatusLabel.Size = UDim2.new(1, -8, 0, 34)
HopStatusLabel.Position = UDim2.new(0, 0, 0, 0)
HopStatusLabel.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
HopStatusLabel.TextColor3 = Color3.fromRGB(220, 228, 242)
HopStatusLabel.TextSize = 10
HopStatusLabel.Font = Enum.Font.Code
HopStatusLabel.TextWrapped = true
HopStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
HopStatusLabel.TextYAlignment = Enum.TextYAlignment.Center
HopStatusLabel.Text = " 🌐 Chọn loại sever để hiển thị danh sách"
HopStatusLabel.ZIndex = 13
HopStatusLabel.Parent = HopContent
Instance.new("UICorner", HopStatusLabel).CornerRadius = UDim.new(0, 7)

local Hop1PlayerBtn = Instance.new("TextButton")
Hop1PlayerBtn.Size = UDim2.new(0.32, -4, 0, 28)
Hop1PlayerBtn.Position = UDim2.new(0, 0, 0, 40)
Hop1PlayerBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
Hop1PlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Hop1PlayerBtn.TextSize = 9
Hop1PlayerBtn.Font = Enum.Font.GothamBold
Hop1PlayerBtn.Text = "👤 1 người"
Hop1PlayerBtn.ZIndex = 13
Hop1PlayerBtn.Parent = HopContent
Instance.new("UICorner", Hop1PlayerBtn).CornerRadius = UDim.new(0, 6)

local HopLowPingBtn = Instance.new("TextButton")
HopLowPingBtn.Size = UDim2.new(0.32, -4, 0, 28)
HopLowPingBtn.Position = UDim2.new(0.34, -2, 0, 40)
HopLowPingBtn.BackgroundColor3 = Color3.fromRGB(61, 139, 255)
HopLowPingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopLowPingBtn.TextSize = 9
HopLowPingBtn.Font = Enum.Font.GothamBold
HopLowPingBtn.Text = "⚡ Ping thấp"
HopLowPingBtn.ZIndex = 13
HopLowPingBtn.Parent = HopContent
Instance.new("UICorner", HopLowPingBtn).CornerRadius = UDim.new(0, 6)

local HopOldServerBtn = Instance.new("TextButton")
HopOldServerBtn.Size = UDim2.new(0.32, -4, 0, 28)
HopOldServerBtn.Position = UDim2.new(0.68, -2, 0, 40)
HopOldServerBtn.BackgroundColor3 = Color3.fromRGB(142, 68, 173)
HopOldServerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopOldServerBtn.TextSize = 9
HopOldServerBtn.Font = Enum.Font.GothamBold
HopOldServerBtn.Text = "🕰️ Sever cũ"
HopOldServerBtn.ZIndex = 13
HopOldServerBtn.Parent = HopContent
Instance.new("UICorner", HopOldServerBtn).CornerRadius = UDim.new(0, 6)

local CopyCurrentJobBtn = Instance.new("TextButton")
CopyCurrentJobBtn.Size = UDim2.new(1, -8, 0, 26)
CopyCurrentJobBtn.Position = UDim2.new(0, 0, 0, 74)
CopyCurrentJobBtn.BackgroundColor3 = Color3.fromRGB(230, 126, 34)
CopyCurrentJobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyCurrentJobBtn.TextSize = 10
CopyCurrentJobBtn.Font = Enum.Font.GothamBold
CopyCurrentJobBtn.Text = "📋 Copy JobId Sever Hiện Tại"
CopyCurrentJobBtn.ZIndex = 13
CopyCurrentJobBtn.Parent = HopContent
Instance.new("UICorner", CopyCurrentJobBtn).CornerRadius = UDim.new(0, 6)

local PasteJobInput = Instance.new("TextBox")
PasteJobInput.Size = UDim2.new(1, -80, 0, 28)
PasteJobInput.Position = UDim2.new(0, 0, 0, 106)
PasteJobInput.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
PasteJobInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PasteJobInput.PlaceholderColor3 = Color3.fromRGB(155, 160, 180)
PasteJobInput.PlaceholderText = "📌 Dán JobId server..."
PasteJobInput.Text = ""
PasteJobInput.TextSize = 10
PasteJobInput.Font = Enum.Font.Code
PasteJobInput.ClearTextOnFocus = false
PasteJobInput.ZIndex = 13
PasteJobInput.Parent = HopContent
Instance.new("UICorner", PasteJobInput).CornerRadius = UDim.new(0, 6)

PasteJobInput:GetPropertyChangedSignal("Text"):Connect(function()
    local j = PasteJobInput.Text or ""
    if j ~= "" then
        setLiveAction("Đang nhập JobId: " .. j:sub(1, 18), Color3.fromRGB(130, 215, 255))
    end
end)

local JoinJobBtn = Instance.new("TextButton")
JoinJobBtn.Size = UDim2.new(0, 68, 0, 28)
JoinJobBtn.Position = UDim2.new(1, -76, 0, 106)
JoinJobBtn.BackgroundColor3 = Color3.fromRGB(31, 184, 154)
JoinJobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinJobBtn.TextSize = 10
JoinJobBtn.Font = Enum.Font.GothamBold
JoinJobBtn.Text = "🚀 Join"
JoinJobBtn.ZIndex = 13
JoinJobBtn.Parent = HopContent
Instance.new("UICorner", JoinJobBtn).CornerRadius = UDim.new(0, 6)

local ServerListFrame = Instance.new("ScrollingFrame")
ServerListFrame.Size = UDim2.new(1, -8, 0, 134)
ServerListFrame.Position = UDim2.new(0, 0, 0, 140)
ServerListFrame.BackgroundColor3 = Color3.fromRGB(26, 28, 40)
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

local function fetchPublicServers(maxPages)
    if not httpRequest then
        return nil, "Executor không hỗ trợ httpRequest"
    end
    local allServers = {}
    local cursor = ""
    local pages = 0

    while pages < (maxPages or 3) do
        pages = pages + 1
        local url = string.format(
            "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100%s",
            game.PlaceId,
            cursor ~= "" and ("&cursor=" .. HttpService:UrlEncode(cursor)) or ""
        )
        local ok, res = pcall(function()
            return httpRequest({ Url = url, Method = "GET" })
        end)
        if not ok or not res or not res.Body then
            return nil, "Không lấy được danh sách server"
        end
        local dOk, decoded = pcall(function()
            return HttpService:JSONDecode(res.Body)
        end)
        if not dOk or type(decoded) ~= "table" or type(decoded.data) ~= "table" then
            return nil, "Lỗi đọc dữ liệu server"
        end
        for _, srv in ipairs(decoded.data) do
            if type(srv) == "table" and srv.id and srv.id ~= game.JobId then
                table.insert(allServers, srv)
            end
        end
        if decoded.nextPageCursor and decoded.nextPageCursor ~= "" then
            cursor = decoded.nextPageCursor
        else
            break
        end
    end
    return allServers, nil
end

local function teleportToJob(jobId, labelHint)
    local cleanId = tostring(jobId or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if cleanId == "" then
        setHopStatus("⚠️ Vui lòng dán JobId hợp lệ trước khi Join!")
        setLiveAction("Chưa có JobId hợp lệ để Join", Color3.fromRGB(255, 195, 80))
        return
    end
    local targetMsg = "Đang Join " .. (labelHint or cleanId:sub(1, 14))
    setHopStatus("🔄 " .. targetMsg .. "...")
    setLiveAction(targetMsg, Color3.fromRGB(46, 204, 113))
    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, cleanId, LocalPlayer)
    end)
    if not ok then
        setHopStatus("❌ Join thất bại: " .. tostring(err))
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
        row.Size = UDim2.new(1, -6, 0, 34)
        row.BackgroundColor3 = Color3.fromRGB(36, 39, 54)
        row.BorderSizePixel = 0
        row.LayoutOrder = idx
        row.ZIndex = 14
        row.Parent = ServerListFrame
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -64, 1, 0)
        lbl.Position = UDim2.new(0, 6, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(235, 238, 248)
        lbl.TextSize = 9
        lbl.Font = Enum.Font.Code
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextWrapped = true
        lbl.Text = string.format(
            "Sever %d: %s người | %sms\nID: %s",
            idx,
            tostring(srv.playing or "?"),
            tostring(srv.ping or "?"),
            tostring(srv.id):sub(1, 14) .. "..."
        )
        lbl.ZIndex = 15
        lbl.Parent = row

        local joinBtn = Instance.new("TextButton")
        joinBtn.Size = UDim2.new(0, 52, 0, 24)
        joinBtn.Position = UDim2.new(1, -56, 0.5, -12)
        joinBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        joinBtn.TextSize = 9
        joinBtn.Font = Enum.Font.GothamBold
        joinBtn.Text = "Join"
        joinBtn.ZIndex = 15
        joinBtn.Parent = row
        Instance.new("UICorner", joinBtn).CornerRadius = UDim.new(0, 5)

        local srvId = tostring(srv.id)
        onButtonClicked(joinBtn, function()
            PasteJobInput.Text = srvId
            teleportToJob(srvId, "Sever " .. idx)
        end)
    end

    ServerListFrame.CanvasSize = UDim2.new(0, 0, 0, count * 38 + 6)
    local doneMsg = string.format("%s: tìm thấy %d sever", titlePrefix, count)
    setHopStatus(doneMsg)
    setLiveAction("Đã tải xong " .. doneMsg, Color3.fromRGB(46, 204, 113))
end

local function loadServersByMode(mode)
    if isHopping then return end
    isHopping = true
    local modeName = mode == "one_player" and "sever 1 người" or (mode == "low_ping" and "sever ping thấp" or "sever cũ")
    setHopStatus("🔍 Đang tải danh sách " .. modeName .. "...")
    setLiveAction("Đang tải danh sách " .. modeName .. "...", Color3.fromRGB(130, 215, 255))

    task.spawn(function()
        local servers, err = fetchPublicServers(4)
        if not servers then
            setHopStatus("❌ " .. tostring(err))
            setLiveAction("Lỗi tải server: " .. tostring(err), Color3.fromRGB(255, 95, 95))
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
            renderServerList(list, "👤 1 người")
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
            renderServerList(topLow, "⚡ Ping thấp")
        elseif mode == "old_server" then
            local olderServers, _ = fetchPublicServers(6)
            local pool = (olderServers and #olderServers > 0) and olderServers or servers
            for i = #pool, math.max(1, #pool - 19), -1 do
                table.insert(list, pool[i])
            end
            renderServerList(list, "🕰️ Sever cũ")
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
        setHopStatus("📋 Đã copy JobId: " .. curId)
        setLiveAction("Đã copy JobId: " .. curId:sub(1, 18), Color3.fromRGB(46, 204, 113))
    else
        setHopStatus("📌 Đã điền JobId: " .. curId)
        setLiveAction("Đã điền JobId hiện tại", Color3.fromRGB(130, 215, 255))
    end
end

onButtonClicked(Hop1PlayerBtn, function() loadServersByMode("one_player") end)
onButtonClicked(HopLowPingBtn, function() loadServersByMode("low_ping") end)
onButtonClicked(HopOldServerBtn, function() loadServersByMode("old_server") end)
onButtonClicked(CopyCurrentJobBtn, copyJobToClipboard)
onButtonClicked(HomeCopyJobBtn, copyJobToClipboard)
onButtonClicked(JoinJobBtn, function()
    teleportToJob(PasteJobInput.Text, "JobId đã dán")
end)

-- --- TAB SETTINGS ---
local Tab3Content = Instance.new("ScrollingFrame")
Tab3Content.Size = UDim2.new(1, -16, 0, CONTENT_HEIGHT)
Tab3Content.Position = UDim2.new(0, 8, 0, CONTENT_TOP_Y)
Tab3Content.BackgroundTransparency = 1
Tab3Content.BorderSizePixel = 0
Tab3Content.CanvasSize = UDim2.new(0, 0, 0, 320)
Tab3Content.ScrollBarThickness = 5
Tab3Content.ScrollBarImageColor3 = Color3.fromRGB(130, 140, 175)
Tab3Content.Visible = false
Tab3Content.ZIndex = 12
Tab3Content.Parent = MainFrame

local SettingsInfoLabel = Instance.new("TextLabel")
SettingsInfoLabel.Size = UDim2.new(1, -8, 0, 160)
SettingsInfoLabel.Position = UDim2.new(0, 0, 0, 0)
SettingsInfoLabel.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
SettingsInfoLabel.TextColor3 = Color3.fromRGB(225, 225, 235)
SettingsInfoLabel.TextSize = 11
SettingsInfoLabel.Font = Enum.Font.Code
SettingsInfoLabel.TextWrapped = true
SettingsInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
SettingsInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
SettingsInfoLabel.Text = " ⚙️ Cài đặt nâng cao:\n • Tự động quét Backpack & Character\n • Hỗ trợ lọc hậu tố tiền K, M, B, T, Qa, spd...\n • Lưu lịch sử thú bắt được kèm giờ Việt Nam\n • Hỗ trợ Farm độ hiếm Common -> Divine + Hop Sever"
SettingsInfoLabel.ZIndex = 13
SettingsInfoLabel.Parent = Tab3Content
Instance.new("UICorner", SettingsInfoLabel).CornerRadius = UDim.new(0, 8)

-- --- TAB GHI CHÚ MÀN HÌNH ---
local Tab4Content = Instance.new("ScrollingFrame")
Tab4Content.Size = UDim2.new(1, -16, 0, CONTENT_HEIGHT)
Tab4Content.Position = UDim2.new(0, 8, 0, CONTENT_TOP_Y)
Tab4Content.BackgroundTransparency = 1
Tab4Content.BorderSizePixel = 0
Tab4Content.ScrollingDirection = Enum.ScrollingDirection.Y
Tab4Content.CanvasSize = UDim2.new(0, 0, 0, 370)
Tab4Content.ScrollBarThickness = 5
Tab4Content.ScrollBarImageColor3 = Color3.fromRGB(130, 140, 175)
Tab4Content.ClipsDescendants = true
Tab4Content.Visible = false
Tab4Content.ZIndex = 12
Tab4Content.Parent = MainFrame

local NoteListLayout = Instance.new("UIListLayout")
NoteListLayout.Padding = UDim.new(0, 7)
NoteListLayout.SortOrder = Enum.SortOrder.LayoutOrder
NoteListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NoteListLayout.Parent = Tab4Content

NoteListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Tab4Content.CanvasSize = UDim2.new(0, 0, 0, NoteListLayout.AbsoluteContentSize.Y + 10)
end)

local NoteInputBox = Instance.new("TextBox")
NoteInputBox.Size = UDim2.new(1, -8, 0, 56)
NoteInputBox.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
NoteInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
NoteInputBox.PlaceholderColor3 = Color3.fromRGB(150, 155, 175)
NoteInputBox.PlaceholderText = "Nhập nội dung ghi chú lên màn hình..."
NoteInputBox.Text = ""
NoteInputBox.Font = Enum.Font.Gotham
NoteInputBox.TextSize = 11
NoteInputBox.TextWrapped = true
NoteInputBox.ClearTextOnFocus = false
NoteInputBox.MultiLine = true
NoteInputBox.ZIndex = 13
NoteInputBox.Parent = Tab4Content
Instance.new("UICorner", NoteInputBox).CornerRadius = UDim.new(0, 8)

local NoteActionRow = Instance.new("Frame")
NoteActionRow.Size = UDim2.new(1, -8, 0, 30)
NoteActionRow.BackgroundTransparency = 1
NoteActionRow.ZIndex = 13
NoteActionRow.Parent = Tab4Content

local NoteToggleShowBtn = Instance.new("TextButton")
NoteToggleShowBtn.Size = UDim2.new(0.66, -3, 1, 0)
NoteToggleShowBtn.Position = UDim2.new(0, 0, 0, 0)
NoteToggleShowBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
NoteToggleShowBtn.Text = "👁️ Hiển thị lên màn hình"
NoteToggleShowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoteToggleShowBtn.Font = Enum.Font.GothamBold
NoteToggleShowBtn.TextSize = 10
NoteToggleShowBtn.ZIndex = 14
NoteToggleShowBtn.Parent = NoteActionRow
Instance.new("UICorner", NoteToggleShowBtn).CornerRadius = UDim.new(0, 7)

local NoteClearBtn = Instance.new("TextButton")
NoteClearBtn.Size = UDim2.new(0.34, -3, 1, 0)
NoteClearBtn.Position = UDim2.new(0.66, 3, 0, 0)
NoteClearBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
NoteClearBtn.Text = "🗑️ Xóa"
NoteClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoteClearBtn.Font = Enum.Font.GothamBold
NoteClearBtn.TextSize = 10
NoteClearBtn.ZIndex = 14
NoteClearBtn.Parent = NoteActionRow
Instance.new("UICorner", NoteClearBtn).CornerRadius = UDim.new(0, 7)

local NoteSizeRow = Instance.new("Frame")
NoteSizeRow.Size = UDim2.new(1, -8, 0, 30)
NoteSizeRow.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
NoteSizeRow.ZIndex = 13
NoteSizeRow.Parent = Tab4Content
Instance.new("UICorner", NoteSizeRow).CornerRadius = UDim.new(0, 8)

local NoteSizeLabel = Instance.new("TextLabel")
NoteSizeLabel.Size = UDim2.new(1, -84, 1, 0)
NoteSizeLabel.Position = UDim2.new(0, 10, 0, 0)
NoteSizeLabel.BackgroundTransparency = 1
NoteSizeLabel.Text = "Kích thước chữ: 22"
NoteSizeLabel.TextColor3 = Color3.fromRGB(225, 228, 238)
NoteSizeLabel.Font = Enum.Font.GothamMedium
NoteSizeLabel.TextSize = 11
NoteSizeLabel.TextXAlignment = Enum.TextXAlignment.Left
NoteSizeLabel.ZIndex = 14
NoteSizeLabel.Parent = NoteSizeRow

local NoteMinusBtn = Instance.new("TextButton")
NoteMinusBtn.Size = UDim2.new(0, 32, 0, 22)
NoteMinusBtn.Position = UDim2.new(1, -72, 0.5, -11)
NoteMinusBtn.BackgroundColor3 = Color3.fromRGB(50, 52, 70)
NoteMinusBtn.Text = "-"
NoteMinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoteMinusBtn.Font = Enum.Font.GothamBold
NoteMinusBtn.TextSize = 14
NoteMinusBtn.ZIndex = 14
NoteMinusBtn.Parent = NoteSizeRow
Instance.new("UICorner", NoteMinusBtn).CornerRadius = UDim.new(0, 6)

local NotePlusBtn = Instance.new("TextButton")
NotePlusBtn.Size = UDim2.new(0, 32, 0, 22)
NotePlusBtn.Position = UDim2.new(1, -36, 0.5, -11)
NotePlusBtn.BackgroundColor3 = Color3.fromRGB(50, 52, 70)
NotePlusBtn.Text = "+"
NotePlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NotePlusBtn.Font = Enum.Font.GothamBold
NotePlusBtn.TextSize = 14
NotePlusBtn.ZIndex = 14
NotePlusBtn.Parent = NoteSizeRow
Instance.new("UICorner", NotePlusBtn).CornerRadius = UDim.new(0, 6)

local NoteFontBtn = Instance.new("TextButton")
NoteFontBtn.Size = UDim2.new(1, -8, 0, 30)
NoteFontBtn.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
NoteFontBtn.Text = "🔤 Font: FredokaOne (Bấm để đổi)"
NoteFontBtn.TextColor3 = Color3.fromRGB(225, 228, 238)
NoteFontBtn.Font = Enum.Font.GothamMedium
NoteFontBtn.TextSize = 11
NoteFontBtn.ZIndex = 13
NoteFontBtn.Parent = Tab4Content
Instance.new("UICorner", NoteFontBtn).CornerRadius = UDim.new(0, 8)

local NoteColorBtn = Instance.new("TextButton")
NoteColorBtn.Size = UDim2.new(1, -8, 0, 30)
NoteColorBtn.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
NoteColorBtn.Text = "🎨 Màu chữ: Trắng (Bấm để đổi)"
NoteColorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoteColorBtn.Font = Enum.Font.GothamMedium
NoteColorBtn.TextSize = 11
NoteColorBtn.ZIndex = 13
NoteColorBtn.Parent = Tab4Content
Instance.new("UICorner", NoteColorBtn).CornerRadius = UDim.new(0, 8)

local NoteEffectBtn = Instance.new("TextButton")
NoteEffectBtn.Size = UDim2.new(1, -8, 0, 30)
NoteEffectBtn.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
NoteEffectBtn.Text = "✨ Hiệu ứng: Không (Bấm để đổi)"
NoteEffectBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
NoteEffectBtn.Font = Enum.Font.GothamMedium
NoteEffectBtn.TextSize = 11
NoteEffectBtn.ZIndex = 13
NoteEffectBtn.Parent = Tab4Content
Instance.new("UICorner", NoteEffectBtn).CornerRadius = UDim.new(0, 8)

local NoteBgToggleBtn = Instance.new("TextButton")
NoteBgToggleBtn.Size = UDim2.new(1, -8, 0, 30)
NoteBgToggleBtn.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
NoteBgToggleBtn.Text = "⬛ Nền chữ: Tắt (Bấm để bật)"
NoteBgToggleBtn.TextColor3 = Color3.fromRGB(185, 190, 208)
NoteBgToggleBtn.Font = Enum.Font.GothamMedium
NoteBgToggleBtn.TextSize = 11
NoteBgToggleBtn.ZIndex = 13
NoteBgToggleBtn.Parent = Tab4Content
Instance.new("UICorner", NoteBgToggleBtn).CornerRadius = UDim.new(0, 8)

local currentNoteSize = 22
local isNoteShowing = false
local hasNoteBg = false

local noteFonts = {
    {Name = "FredokaOne", Enum = Enum.Font.FredokaOne},
    {Name = "GothamBold", Enum = Enum.Font.GothamBold},
    {Name = "Arcade (Pixel)", Enum = Enum.Font.Arcade},
    {Name = "Code (Lập trình)", Enum = Enum.Font.Code},
    {Name = "Creepster (Kinh dị)", Enum = Enum.Font.Creepster},
    {Name = "LuckiestGuy", Enum = Enum.Font.LuckiestGuy},
    {Name = "SciFi (Tương lai)", Enum = Enum.Font.SciFi}
}
local noteFontIdx = 1

local noteColors = {
    {Name = "Trắng", Val = Color3.fromRGB(255, 255, 255)},
    {Name = "Vàng Gold", Val = Color3.fromRGB(255, 215, 0)},
    {Name = "Xanh Neon", Val = Color3.fromRGB(0, 255, 170)},
    {Name = "Đỏ Rực", Val = Color3.fromRGB(255, 65, 65)},
    {Name = "Xanh Dương", Val = Color3.fromRGB(0, 170, 255)},
    {Name = "Tím Hồng", Val = Color3.fromRGB(220, 100, 255)}
}
local noteColorIdx = 1

local noteEffects = {"Không", "Cầu vồng (RGB)", "Nhấp nháy (Pulse)", "Phát sáng (Neon)", "Lơ lửng (Float)"}
local noteEffectIdx = 1

NoteInputBox:GetPropertyChangedSignal("Text"):Connect(function()
    if NoteInputBox.Text == "" then
        DisplayLabel.Text = "Ghi chú trống..."
    else
        DisplayLabel.Text = NoteInputBox.Text
        setLiveAction("Đang sửa ghi chú: " .. NoteInputBox.Text:sub(1, 22), Color3.fromRGB(130, 215, 255))
    end
    local textBounds = DisplayLabel.TextBounds
    DisplayContainer.Size = UDim2.new(0, math.clamp(textBounds.X + 28, 140, 480), 0, math.max(textBounds.Y + 18, 46))
end)

onButtonClicked(NoteToggleShowBtn, function()
    isNoteShowing = not isNoteShowing
    DisplayContainer.Visible = isNoteShowing
    if isNoteShowing then
        if NoteInputBox.Text ~= "" then
            DisplayLabel.Text = NoteInputBox.Text
        end
        NoteToggleShowBtn.Text = "🙈 Ẩn khỏi màn hình"
        NoteToggleShowBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 90)
        setLiveAction("Đã bật ghi chú nổi trên màn hình", Color3.fromRGB(46, 204, 113))
    else
        NoteToggleShowBtn.Text = "👁️ Hiển thị lên màn hình"
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
    NoteSizeLabel.Text = "Kích thước chữ: " .. currentNoteSize
    setLiveAction("Cỡ chữ ghi chú: " .. currentNoteSize, Color3.fromRGB(130, 215, 255))
end)

onButtonClicked(NotePlusBtn, function()
    currentNoteSize = math.min(72, currentNoteSize + 2)
    DisplayLabel.TextSize = currentNoteSize
    NoteSizeLabel.Text = "Kích thước chữ: " .. currentNoteSize
    setLiveAction("Cỡ chữ ghi chú: " .. currentNoteSize, Color3.fromRGB(130, 215, 255))
end)

onButtonClicked(NoteFontBtn, function()
    noteFontIdx = (noteFontIdx % #noteFonts) + 1
    DisplayLabel.Font = noteFonts[noteFontIdx].Enum
    NoteFontBtn.Text = "🔤 Font: " .. noteFonts[noteFontIdx].Name
    setLiveAction("Font ghi chú: " .. noteFonts[noteFontIdx].Name, Color3.fromRGB(130, 215, 255))
end)

onButtonClicked(NoteColorBtn, function()
    noteColorIdx = (noteColorIdx % #noteColors) + 1
    DisplayLabel.TextColor3 = noteColors[noteColorIdx].Val
    NoteColorBtn.Text = "🎨 Màu chữ: " .. noteColors[noteColorIdx].Name
    NoteColorBtn.TextColor3 = noteColors[noteColorIdx].Val
    setLiveAction("Màu chữ ghi chú: " .. noteColors[noteColorIdx].Name, noteColors[noteColorIdx].Val)
end)

onButtonClicked(NoteEffectBtn, function()
    noteEffectIdx = (noteEffectIdx % #noteEffects) + 1
    local currentEffect = noteEffects[noteEffectIdx]
    NoteEffectBtn.Text = "✨ Hiệu ứng: " .. currentEffect

    DisplayLabel.TextTransparency = 0
    TextStroke.Color = Color3.fromRGB(0, 0, 0)
    TextStroke.Thickness = 2
    DisplayLabel.TextColor3 = noteColors[noteColorIdx].Val

    if currentEffect == "Phát sáng (Neon)" then
        TextStroke.Color = noteColors[noteColorIdx].Val
        TextStroke.Thickness = 3.5
        DisplayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    setLiveAction("Hiệu ứng ghi chú: " .. currentEffect, Color3.fromRGB(255, 215, 0))
end)

onButtonClicked(NoteBgToggleBtn, function()
    hasNoteBg = not hasNoteBg
    if hasNoteBg then
        DisplayContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        DisplayContainer.BackgroundTransparency = 0.35
        if not DisplayContainer:FindFirstChild("UICorner") then
            Instance.new("UICorner", DisplayContainer).CornerRadius = UDim.new(0, 10)
        end
        NoteBgToggleBtn.Text = "⬛ Nền chữ: Bật (Dễ đọc)"
        setLiveAction("Đã bật nền chữ ghi chú", Color3.fromRGB(46, 204, 113))
    else
        DisplayContainer.BackgroundTransparency = 1
        NoteBgToggleBtn.Text = "⬛ Nền chữ: Tắt (Bấm để bật)"
        setLiveAction("Đã tắt nền chữ ghi chú", Color3.fromRGB(185, 190, 210))
    end
end)

-- --- TAB LỊCH SỬ ---
local HistoryRecords = {}
local historyFilterMode = "all"
local refreshHistory

local HistorySearch = Instance.new("TextBox")
HistorySearch.Size = UDim2.new(0, 142, 0, 28)
HistorySearch.Position = UDim2.new(0, 10, 0, CONTENT_TOP_Y)
HistorySearch.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
HistorySearch.TextColor3 = Color3.fromRGB(245, 245, 250)
HistorySearch.PlaceholderColor3 = Color3.fromRGB(155, 155, 170)
HistorySearch.PlaceholderText = "🔎 Tìm tên..."
HistorySearch.Text = ""
HistorySearch.TextSize = 10
HistorySearch.Font = Enum.Font.Gotham
HistorySearch.ClearTextOnFocus = false
HistorySearch.Visible = false
HistorySearch.ZIndex = 13
HistorySearch.Parent = MainFrame
Instance.new("UICorner", HistorySearch).CornerRadius = UDim.new(0, 6)

local HistoryFilterBtn = Instance.new("TextButton")
HistoryFilterBtn.Size = UDim2.new(0, 34, 0, 28)
HistoryFilterBtn.Position = UDim2.new(0, 158, 0, CONTENT_TOP_Y)
HistoryFilterBtn.BackgroundColor3 = Color3.fromRGB(40, 42, 56)
HistoryFilterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HistoryFilterBtn.Text = "☷"
HistoryFilterBtn.TextSize = 11
HistoryFilterBtn.Font = Enum.Font.GothamBold
HistoryFilterBtn.Visible = false
HistoryFilterBtn.ZIndex = 13
HistoryFilterBtn.Parent = MainFrame
Instance.new("UICorner", HistoryFilterBtn).CornerRadius = UDim.new(0, 6)

local HistoryClearBtn = Instance.new("TextButton")
HistoryClearBtn.Size = UDim2.new(0, 34, 0, 28)
HistoryClearBtn.Position = UDim2.new(0, 198, 0, CONTENT_TOP_Y)
HistoryClearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
HistoryClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HistoryClearBtn.Text = "🗑️"
HistoryClearBtn.TextSize = 11
HistoryClearBtn.Font = Enum.Font.GothamBold
HistoryClearBtn.Visible = false
HistoryClearBtn.ZIndex = 13
HistoryClearBtn.Parent = MainFrame
Instance.new("UICorner", HistoryClearBtn).CornerRadius = UDim.new(0, 6)

local HistoryCountLabel = Instance.new("TextLabel")
HistoryCountLabel.Size = UDim2.new(0, 72, 0, 28)
HistoryCountLabel.Position = UDim2.new(0, 238, 0, CONTENT_TOP_Y)
HistoryCountLabel.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
HistoryCountLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
HistoryCountLabel.TextSize = 11
HistoryCountLabel.Font = Enum.Font.GothamBold
HistoryCountLabel.Text = "0"
HistoryCountLabel.TextXAlignment = Enum.TextXAlignment.Center
HistoryCountLabel.Visible = false
HistoryCountLabel.ZIndex = 13
HistoryCountLabel.Parent = MainFrame
Instance.new("UICorner", HistoryCountLabel).CornerRadius = UDim.new(0, 6)

local HistoryFilterPopup = Instance.new("Frame")
HistoryFilterPopup.Size = UDim2.new(0, 130, 0, 88)
HistoryFilterPopup.Position = UDim2.new(0, 158, 0, CONTENT_TOP_Y + 32)
HistoryFilterPopup.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
HistoryFilterPopup.Visible = false
HistoryFilterPopup.ZIndex = 25
HistoryFilterPopup.Parent = MainFrame
Instance.new("UICorner", HistoryFilterPopup).CornerRadius = UDim.new(0, 6)

local function makeHistoryModeButton(label, mode, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 24)
    b.Position = UDim2.new(0, 4, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(48, 50, 66)
    b.TextColor3 = Color3.fromRGB(245, 245, 250)
    b.TextSize = 10
    b.Font = Enum.Font.Gotham
    b.Text = label
    b.ZIndex = 26
    b.Parent = HistoryFilterPopup
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    onButtonClicked(b, function()
        historyFilterMode = mode
        HistoryFilterPopup.Visible = false
        setLiveAction("Lọc lịch sử: " .. label, Color3.fromRGB(130, 215, 255))
        if refreshHistory then refreshHistory() end
    end)
end
makeHistoryModeButton("Tất cả", "all", 4)
makeHistoryModeButton("Lọc giá trị", "value", 30)
makeHistoryModeButton("Lọc độ hiếm", "rarity", 56)

onButtonClicked(HistoryFilterBtn, function()
    HistoryFilterPopup.Visible = not HistoryFilterPopup.Visible
    setLiveAction(HistoryFilterPopup.Visible and "Đang mở bộ lọc lịch sử" or "Đã đóng bộ lọc lịch sử", Color3.fromRGB(130, 215, 255))
end)

onButtonClicked(HistoryClearBtn, function()
    if #HistoryRecords == 0 then
        setLiveAction("Lịch sử đang trống", Color3.fromRGB(185, 190, 210))
        return
    end
    setLiveAction("Đang hỏi xác nhận xóa toàn bộ lịch sử", Color3.fromRGB(255, 195, 80))
    promptDeleteConfirm(
        "Xóa toàn bộ lịch sử?",
        string.format("Tất cả %d mục trong lịch sử sẽ bị xóa. Không thể hoàn tác.", #HistoryRecords),
        function()
            HistoryRecords = {}
            setLiveAction("Đã xóa toàn bộ lịch sử", Color3.fromRGB(255, 110, 110))
            if refreshHistory then refreshHistory() end
        end
    )
end)

local Tab2Content = Instance.new("ScrollingFrame")
Tab2Content.Size = UDim2.new(1, -12, 0, CONTENT_HEIGHT - 34)
Tab2Content.Position = UDim2.new(0, 6, 0, CONTENT_TOP_Y + 34)
Tab2Content.BackgroundTransparency = 1
Tab2Content.Visible = false
Tab2Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Tab2Content.ScrollBarThickness = 5
Tab2Content.ScrollBarImageColor3 = Color3.fromRGB(130, 140, 175)
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
            itemFrame.Size = UDim2.new(1, -6, 0, 68)
            itemFrame.BackgroundColor3 = Color3.fromRGB(32, 34, 46)
            itemFrame.BorderSizePixel = 0
            itemFrame.LayoutOrder = shown
            itemFrame.ZIndex = 13
            itemFrame.Parent = Tab2Content
            Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 6)

            local descLabel = Instance.new("TextLabel")
            descLabel.Size = UDim2.new(1, -38, 1, 0)
            descLabel.Position = UDim2.new(0, 5, 0, 0)
            descLabel.BackgroundTransparency = 1
            descLabel.TextColor3 = Color3.fromRGB(230, 230, 240)
            descLabel.TextSize = 11
            descLabel.Font = Enum.Font.Code
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
            removeOneBtn.Size = UDim2.new(0, 24, 0, 24)
            removeOneBtn.Position = UDim2.new(1, -28, 0.5, -12)
            removeOneBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
            removeOneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            removeOneBtn.TextSize = 11
            removeOneBtn.Font = Enum.Font.GothamBold
            removeOneBtn.Text = "✕"
            removeOneBtn.ZIndex = 15
            removeOneBtn.Parent = itemFrame
            Instance.new("UICorner", removeOneBtn).CornerRadius = UDim.new(0, 6)

            local targetIndex = recIdx
            local targetPetName = d.Name or "Pet"
            onButtonClicked(removeOneBtn, function()
                setLiveAction("Đang hỏi xóa mục: " .. targetPetName, Color3.fromRGB(255, 195, 80))
                promptDeleteConfirm(
                    "Xóa mục này?",
                    string.format("Mục “%s” sẽ bị xóa khỏi lịch sử. Không thể hoàn tác.", targetPetName),
                    function()
                        if HistoryRecords[targetIndex] then
                            table.remove(HistoryRecords, targetIndex)
                            setLiveAction("Đã xóa mục: " .. targetPetName, Color3.fromRGB(255, 110, 110))
                            refreshHistory()
                        end
                    end
                )
            end)
        end
    end
    Tab2Content.CanvasSize = UDim2.new(0, 0, 0, shown * 73)
    HistoryCountLabel.Text = tostring(#HistoryRecords)
end

HistorySearch:GetPropertyChangedSignal("Text"):Connect(function()
    local q = HistorySearch.Text or ""
    if q == "" then
        setLiveAction("Đã xóa từ khóa tìm lịch sử", Color3.fromRGB(185, 190, 210))
    else
        setLiveAction("Đang tìm lịch sử: " .. q, Color3.fromRGB(130, 215, 255))
    end
    refreshHistory()
end)

local allTabButtons = {
    home = TabHomeBtn,
    farm = TabFarmBtn,
    hop = TabHopBtn,
    history = TabHistoryBtn,
    settings = TabSettingsBtn,
    note = TabNoteBtn
}

local tabNamesVi = {
    home = "Home",
    farm = "Farm",
    hop = "Hop Sever",
    history = "Lịch sử",
    settings = "Settings",
    note = "Ghi chú"
}

local function setActiveTabStyle(tabKey)
    for k, b in pairs(allTabButtons) do
        if k == tabKey then
            b.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            b.BackgroundColor3 = Color3.fromRGB(40, 42, 56)
            b.TextColor3 = Color3.fromRGB(205, 210, 224)
        end
    end
end

openTab = function(tabKey)
    if type(tabKey) == "number" then
        local numMap = { "home", "farm", "hop", "history", "settings", "note" }
        tabKey = numMap[tabKey] or "home"
    end

    setActiveTabStyle(tabKey)
    setLiveAction("Đã chuyển sang tab " .. (tabNamesVi[tabKey] or tostring(tabKey)), Color3.fromRGB(130, 215, 255))

    HomeContent.Visible = (tabKey == "home")
    FarmContent.Visible = (tabKey == "farm")
    HopContent.Visible = (tabKey == "hop")
    Tab2Content.Visible = (tabKey == "history")
    Tab3Content.Visible = (tabKey == "settings")
    Tab4Content.Visible = (tabKey == "note")

    if tabKey == "farm" then
        rebuildAreaButtons()
        refreshRaritySec()
        refreshAreaSec()
        refreshTravelSec()
        refreshReturnSec()
        FarmContent.CanvasSize = UDim2.new(0, 0, 0, FarmLayout.AbsoluteContentSize.Y + 14)
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
onButtonClicked(TabFarmBtn, function() openTab("farm") end)
onButtonClicked(TabHopBtn, function() openTab("hop") end)
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

local function isRarityAllowed(rarityStr)
    local anySelected = false
    for _, v in pairs(selectedRarities) do
        if v then
            anySelected = true
            break
        end
    end
    if not anySelected then return true end

    local low = string.lower(tostring(rarityStr or ""))
    for _, rName in ipairs(RARITY_ORDER) do
        if selectedRarities[rName] and string.find(low, string.lower(rName), 1, true) then
            return true
        end
    end
    return false
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
    if not isRarityAllowed(petData.Rarity) then
        setLiveAction("Bỏ qua " .. petData.Name .. " (ngoài độ hiếm chọn)", Color3.fromRGB(185, 190, 210))
        return
    end

    if CURRENT_MIN_MONEY > 0 and petData.NumericMoney < CURRENT_MIN_MONEY then
        setLiveAction("Bỏ qua " .. petData.Name .. " (dưới mức lọc tiền)", Color3.fromRGB(185, 190, 210))
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
        setLiveAction("Đã lưu " .. petData.Name .. " (không gửi Webhook)", Color3.fromRGB(130, 235, 185))
        return
    end

    setLiveAction("Đang gửi Webhook: " .. petData.Name .. "...", Color3.fromRGB(130, 215, 255))

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
        setLiveAction("Đã gửi Webhook: " .. petData.Name, Color3.fromRGB(46, 204, 113))
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

    setLiveAction("Phát hiện thú mới: " .. newItem.Name, Color3.fromRGB(255, 215, 0))
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
-- VÒNG LẶP CẬP NHẬT TRẠNG THÁI & HIỆU ỨNG GHI CHÚ
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
        if currentEffect == "Cầu vồng (RGB)" then
            local hue = (now * 0.25) % 1
            DisplayLabel.TextColor3 = Color3.fromHSV(hue, 0.85, 1)
        elseif currentEffect == "Nhấp nháy (Pulse)" then
            local alpha = (math.sin(noteTickCount * 4) + 1) / 2
            DisplayLabel.TextTransparency = alpha * 0.65
        elseif currentEffect == "Lơ lửng (Float)" then
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
        " 🏠 TỔNG QUAN HỆ THỐNG\n 👤 Người chơi: %d/%d | 🐾 Đã bắt: %d\n ⏱️ Đã chạy: %s | 🇻🇳 %s\n ⚡ FPS: %d | 📶 Ping: %dms\n 🟢 Trạng thái: %s",
        plrCount, maxPlr, #HistoryRecords, runTimeStr, vnClockStr, currentFps, ping,
        isFarming and "Đang Farm" or (isRunning and "Đang chạy" or "Tạm dừng")
    )

    if DynamicIsland.Visible then
        local statusIcon = (isRunning or isFarming) and "🟢" or "🔴"
        IslandCompactText.Text = string.format("%s %d Pet • %s", statusIcon, #HistoryRecords, runTimeStr)
        if isIslandExpanded then
            local minMoneyStr = CURRENT_MIN_MONEY == 0 and "Tất cả" or (formatBigNumber(CURRENT_MIN_MONEY) .. "+/s")
            IslandExpandedText.Text = string.format(
                "%s %s | ⏱️ %s\n⚡ %d FPS | 📶 %dms | 💰 %s",
                statusIcon, isFarming and "Đang Farm" or (isRunning and "Đang chạy" or "Tạm dừng"), runTimeStr, currentFps, ping, minMoneyStr
            )
        end
    end
end)
