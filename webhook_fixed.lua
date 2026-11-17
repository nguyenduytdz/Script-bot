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
MainFrame.Size = UDim2.new(0, 310, 0, 340)
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

local FilterDropdownBtn = Instance.new("TextButton")
FilterDropdownBtn.Size = UDim2.new(1, -20, 0, 28)
FilterDropdownBtn.Position = UDim2.new(0, 10, 0, 72)
FilterDropdownBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
FilterDropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FilterDropdownBtn.TextSize = 11
FilterDropdownBtn.Font = Enum.Font.GothamBold
FilterDropdownBtn.Text = "🔽 Lọc Tiền: Tất cả (0)"
FilterDropdownBtn.Parent = Tab1Content
Instance.new("UICorner", FilterDropdownBtn).CornerRadius = UDim.new(0, 6)

local DropdownListFrame = Instance.new("ScrollingFrame")
DropdownListFrame.Size = UDim2.new(1, -20, 0, 90)
DropdownListFrame.Position = UDim2.new(0, 10, 0, 103)
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
        CURRENT_MIN_MONEY = val
        FilterDropdownBtn.Text = "🔽 Lọc Tiền: " .. name
        isDropdownOpen = false
        DropdownListFrame.Visible = false
    end)
end

createFilterOption("Tất cả (Nhận hết)", 0)
createFilterOption("Từ 1M+ /s", 1e6)
createFilterOption("Từ 1B+ /s", 1e9)
createFilterOption("Từ 1T+ /s", 1e12)
createFilterOption("Từ 1Qa+ /s", 1e15)
createFilterOption("Từ 1spd+ /s", 1e54)

local isDropdownOpen = false
onButtonClicked(FilterDropdownBtn, function()
    isDropdownOpen = not isDropdownOpen
    DropdownListFrame.Visible = isDropdownOpen
    if isDropdownOpen then
        FilterDropdownBtn.Text = "🔼 Đóng bảng lọc tiền"
    else
        FilterDropdownBtn.Text = "🔽 Lọc Tiền: " .. (CURRENT_MIN_MONEY == 0 and "Tất cả" or formatBigNumber(CURRENT_MIN_MONEY) .. "+")
    end
end)

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -20, 0, 36)
ToggleButton.Position = UDim2.new(0, 10, 0, 105)
ToggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 13
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "STOP SCRIPT"
ToggleButton.Parent = Tab1Content
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)

local FooterLabel = Instance.new("TextLabel")
FooterLabel.Size = UDim2.new(1, -20, 0, 30)
FooterLabel.Position = UDim2.new(0, 10, 0, 195)
FooterLabel.BackgroundTransparency = 1
FooterLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
FooterLabel.TextSize = 11
FooterLabel.Font = Enum.Font.Gotham
FooterLabel.TextWrapped = true
FooterLabel.Text = "Đã gửi: 0 thú | Trạng thái: 🟢 Đang chạy"
FooterLabel.Parent = Tab1Content

DropdownListFrame:GetPropertyChangedSignal("Visible"):Connect(function()
    if DropdownListFrame.Visible then
        ToggleButton.Position = UDim2.new(0, 10, 0, 198)
        FooterLabel.Position = UDim2.new(0, 10, 0, 238)
    else
        ToggleButton.Position = UDim2.new(0, 10, 0, 105)
        FooterLabel.Position = UDim2.new(0, 10, 0, 195)
    end
end)

-- --- TAB 2: LỊCH SỬ + TÌM KIẾM / LỌC / XÓA LỊCH SỬ ---
local HistoryRecords = {}
local historyFilterMode = "all"
local refreshHistory

local HistorySearch = Instance.new("TextBox")
HistorySearch.Size = UDim2.new(1, -155, 0, 30)
HistorySearch.Position = UDim2.new(0, 10, 0, 66)
HistorySearch.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
HistorySearch.TextColor3 = Color3.fromRGB(245, 245, 245)
HistorySearch.PlaceholderColor3 = Color3.fromRGB(155, 155, 165)
HistorySearch.PlaceholderText = "🔎 Tìm tên..."
HistorySearch.Text = ""
HistorySearch.TextSize = 11
HistorySearch.Font = Enum.Font.Gotham
HistorySearch.ClearTextOnFocus = false
HistorySearch.Parent = MainFrame
HistorySearch.Visible = false
Instance.new("UICorner", HistorySearch).CornerRadius = UDim.new(0, 6)

-- Nút Lọc siêu nhỏ gọn
local HistoryFilterBtn = Instance.new("TextButton")
HistoryFilterBtn.Size = UDim2.new(0, 38, 0, 30)
HistoryFilterBtn.Position = UDim2.new(1, -145, 0, 66)
HistoryFilterBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
HistoryFilterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HistoryFilterBtn.Text = "☷"
HistoryFilterBtn.TextSize = 12
HistoryFilterBtn.Font = Enum.Font.GothamBold
HistoryFilterBtn.Parent = MainFrame
HistoryFilterBtn.Visible = false
Instance.new("UICorner", HistoryFilterBtn).CornerRadius = UDim.new(0, 6)

-- Nút Xóa lịch sử
local HistoryClearBtn = Instance.new("TextButton")
HistoryClearBtn.Size = UDim2.new(0, 38, 0, 30)
HistoryClearBtn.Position = UDim2.new(1, -103, 0, 66)
HistoryClearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
HistoryClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HistoryClearBtn.Text = "🗑️"
HistoryClearBtn.TextSize = 12
HistoryClearBtn.Font = Enum.Font.GothamBold
HistoryClearBtn.Parent = MainFrame
HistoryClearBtn.Visible = false
Instance.new("UICorner", HistoryClearBtn).CornerRadius = UDim.new(0, 6)

-- Ô hiển thị số lượng pet
local HistoryCountLabel = Instance.new("TextLabel")
HistoryCountLabel.Size = UDim2.new(0, 50, 0, 30)
HistoryCountLabel.Position = UDim2.new(1, -60, 0, 66)
HistoryCountLabel.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
HistoryCountLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
HistoryCountLabel.TextSize = 11
HistoryCountLabel.Font = Enum.Font.GothamBold
HistoryCountLabel.Text = "0"
HistoryCountLabel.TextXAlignment = Enum.TextXAlignment.Center
HistoryCountLabel.Parent = MainFrame
HistoryCountLabel.Visible = false
Instance.new("UICorner", HistoryCountLabel).CornerRadius = UDim.new(0, 6)

-- Menu popup Lọc
local HistoryFilterPopup = Instance.new("Frame")
HistoryFilterPopup.Size = UDim2.new(0, 130, 0, 88)
HistoryFilterPopup.Position = UDim2.new(1, -140, 0, 99)
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

-- Menu popup Xóa lịch sử
local HistoryClearPopup = Instance.new("Frame")
HistoryClearPopup.Size = UDim2.new(0, 130, 0, 60)
HistoryClearPopup.Position = UDim2.new(1, -140, 0, 99)
HistoryClearPopup.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
HistoryClearPopup.Visible = false
HistoryClearPopup.ZIndex = 10
HistoryClearPopup.Parent = MainFrame
Instance.new("UICorner", HistoryClearPopup).CornerRadius = UDim.new(0, 6)

local function makeClearOption(label, callback, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 24)
    b.Position = UDim2.new(0, 4, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 10
    b.Font = Enum.Font.GothamBold
    b.Text = label
    b.ZIndex = 11
    b.Parent = HistoryClearPopup
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    onButtonClicked(b, function()
        HistoryClearPopup.Visible = false
        callback()
    end)
end

makeClearOption("Xoá toàn bộ", function()
    HistoryRecords = {}
    if refreshHistory then refreshHistory() end
end, 4)

makeClearOption("Xoá mục cũ nhất", function()
    if #HistoryRecords > 0 then
        table.remove(HistoryRecords, 1)
        if refreshHistory then refreshHistory() end
    end
end, 32)

onButtonClicked(HistoryClearBtn, function()
    HistoryClearPopup.Visible = not HistoryClearPopup.Visible
end)

local Tab2Content = Instance.new("ScrollingFrame")
Tab2Content.Size = UDim2.new(1, -10, 1, -140)
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

refreshHistory = function()
    for _, child in ipairs(Tab2Content:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local shown = 0
    local q = string.lower(HistorySearch.Text or "")
    for _, record in ipairs(HistoryRecords) do
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
            itemFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
            itemFrame.BorderSizePixel = 0
            itemFrame.LayoutOrder = shown
            itemFrame.Parent = Tab2Content
            Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 6)

            local descLabel = Instance.new("TextLabel")
            descLabel.Size = UDim2.new(1, -10, 1, 0)
            descLabel.Position = UDim2.new(0, 5, 0, 0)
            descLabel.BackgroundTransparency = 1
            descLabel.TextColor3 = Color3.fromRGB(230, 230, 240)
            descLabel.TextSize = 12
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
    task.wait()
    Tab2Content.CanvasPosition = Vector2.new(0, Tab2Content.CanvasSize.Y.Offset)
end

HistorySearch:GetPropertyChangedSignal("Text"):Connect(function()
    refreshHistory()
end)

onButtonClicked(Tab1Btn, function()
    Tab1Content.Visible = true
    Tab2Content.Visible = false
    HistorySearch.Visible = false
    HistoryFilterBtn.Visible = false
    HistoryClearBtn.Visible = false
    HistoryCountLabel.Visible = false
    HistoryFilterPopup.Visible = false
    HistoryClearPopup.Visible = false
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
    HistoryClearBtn.Visible = false
    HistoryCountLabel.Visible = false
    HistoryFilterPopup.Visible = false
    HistoryClearPopup.Visible = false
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
    HistoryClearBtn.Visible = true
    HistoryCountLabel.Visible = true
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
    petsCaughtCount = petsCaughtCount + 1

    local vnTimeTable = os.date("!*t", os.time() + 25200)
    local vnTimeString = string.format("%02d:%02d:%02d - %02d/%02d/%d",
        vnTimeTable.hour, vnTimeTable.min, vnTimeTable.sec,
        vnTimeTable.day, vnTimeTable.month, vnTimeTable.year)

    table.insert(HistoryRecords, {data = petData, time = vnTimeString})
    if refreshHistory then refreshHistory() end

    if not isRunning then return end
    if CURRENT_MIN_MONEY > 0 and petData.NumericMoney < CURRENT_MIN_MONEY then return end

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
    if isRunning then
        ToggleButton.Text = "STOP SCRIPT"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        ToggleButton.Text = "START SCRIPT"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(224, 86, 36)
    end
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
        FooterLabel.Text = string.format("Đã ghi nhận: %d thú | Trạng thái: 🟢 Đang gửi webhook", petsCaughtCount)
    else
        FooterLabel.Text = string.format("Đã ghi nhận: %d thú | Trạng thái: 🔴 Dừng gửi webhook (vẫn lưu lịch sử)", petsCaughtCount)
    end
end)
